AllUnits=[];allGroups=[];patrolGrps=[];

///--- создание сторон
if (( sideLogic CountSide AllUnits ) < 1) then { CreateCenter sideLogic };
if (( civilian CountSide AllUnits ) < 1) then { CreateCenter civilian };
m_friendlySide = [west];
friendsW=[west]; friendsE=[east,resistance]; friendsG=[east,resistance];
{
	CreateCenter _x;
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
