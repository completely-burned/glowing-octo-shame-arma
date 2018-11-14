allGroups=[];patrolGrps=[];
if (isNil {AllUnits}) then {
    AllUnits=[];
};
m_friendlySide = [];
private ["_i","_ii"];
for [{_i = 0}, {_i < count (missionConfigFile >> "MissionSQM" >> "Mission" >> "Groups")}, {_i = _i + 1}] do {
	private["_grpCFG"];
    _grpCFG = (missionConfigFile >> "MissionSQM" >> "Mission" >> "Groups") select _i;
		if (isClass _grpCFG) then {
			private["_sideCFG","_unitsCFG"];
			_sideCFG = getText (_grpCFG >> "side");
			_unitsCFG = _grpCFG >> "Vehicles";
			for [{_ii = 0}, {_ii < count _unitsCFG}, {_ii = _ii + 1}] do {
				private ["_unitCFG"];
				_unitCFG = _unitsCFG select _ii;
				if (isClass _unitCFG) then {
					private ["_isPlayable"];
					_isPlayable = false;
					if (getText (_unitCFG >> "player") in ["PLAY CDG","PLAYER COMMANDER"]) then {
						_isPlayable = true;
					};
					if (_isPlayable) then {
						switch (_sideCFG) do {
							case "EAST": {if !(east in m_friendlySide) then {m_friendlySide = m_friendlySide + [east]}};
							case "WEST": {if !(west in m_friendlySide) then {m_friendlySide = m_friendlySide + [west]}};
							case "GUER": {if !(resistance in m_friendlySide) then {m_friendlySide = m_friendlySide + [resistance]}};
							case "CIV": {if !(civilian in m_friendlySide) then {m_friendlySide = m_friendlySide + [civilian]}};
							default {};
						};
					};
				};
			};
		};
};

///--- создание сторон
if (( sideLogic CountSide AllUnits ) < 1) then { CreateCenter sideLogic };
if (( civilian CountSide AllUnits ) < 1) then { CreateCenter civilian };
friendsW=[west]; friendsE=[east]; friendsG=[resistance];

{
	if ((_x CountSide AllUnits) < 1) then {
		CreateCenter _x;
	};
	Private["_sideCreated"];
	_sideCreated = _x;
	{
		if (_x != _sideCreated) then {
			if ((_x in m_friendlySide && !(_sideCreated in m_friendlySide)) or (!(_x in m_friendlySide) && _sideCreated in m_friendlySide)) then {
				_x SetFriend [_sideCreated,0];
				_sideCreated SetFriend [_x,0];
			}else{
				_x SetFriend [_sideCreated,1];
				_sideCreated SetFriend [_x,1];
				if (_sideCreated == West) then {
				    friendsW set [count friendsW, _x];
				};
				if (_sideCreated == East) then {
				    friendsE set [count friendsE, _x];
				};
				if (_sideCreated == resistance) then {
				    friendsG set [count friendsG, _x];
				};
			};
		};
	} ForEach [East,West,Resistance];
	_x SetFriend [civilian,1];
	civilian SetFriend [_x,1];
} ForEach [East,West,Resistance];

availableVehicles = [] call m_fnc_availableVehicles;
publicVariable "availableVehicles";
availableWeapons = [] call m_fnc_availableWeapons;
publicVariable "availableWeapons";
availableMagazines = [] call m_fnc_availableMagazines;
publicVariable "availableMagazines";
availableBackpacks = [] call m_fnc_availableBackpacks;
publicVariable "availableBackpacks";

[] call compile preprocessFileLineNumbers "server\init_groups.sqf";
private["_path"];
_path = "server\";
//[] execVM (_path + "server_update_groups.sqf");
[] execVM (_path + "updateReinforcement.sqf");
[] execVM (_path + "gc.sqf");
[] execVM (_path + "units.sqf");
