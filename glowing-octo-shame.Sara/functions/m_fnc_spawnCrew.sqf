#define true 1
#define false 0

private ["_type","_crewType","_typicalCargo","_unit","_crew","_vehicle","_grp","_entry","_hasDriver","_turrets"];
_vehicle = _this select 0;
_grp = _this select 1;

_type = typeOf _vehicle;

_entry = configFile >> "CfgVehicles" >> _type;
_crew = [];

if ((count _this) > 2) then {
	_typicalCargo = (_this select 2);
	_crewType = (_typicalCargo select 0);
}else{
	_typicalCargo=[];
		_crewType = getText (_entry >> "crew");
};

_hasDriver = getNumber (_entry >> "hasDriver");

if ((_hasDriver == 1) && (isNull (driver _vehicle))) then
{
		_unit = _grp createUnit [_crewType, position _vehicle, [], 0, "FORM"];
		_crew = _crew + [_unit];

		_unit moveInDriver _vehicle;
};

_hasDriver = getNumber (_entry >> "hasGunner");

if ((_hasDriver == 1) && (isNull (gunner _vehicle))) then
{
		_unit = _grp createUnit [_crewType, position _vehicle, [], 0, "FORM"];
		_crew = _crew + [_unit];

		_unit moveInGunner _vehicle;
};

_hasDriver = getNumber (_entry >> "hasCommander");

if ((_hasDriver == 1) && (isNull (commander _vehicle))) then
{
		_unit = _grp createUnit [_crewType, position _vehicle, [], 0, "FORM"];
		_crew = _crew + [_unit];

		_unit moveInCommander _vehicle;
};


_crew
