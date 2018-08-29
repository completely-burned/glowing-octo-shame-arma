[] Call Compile preprocessFileLineNumbers "init_common.sqf";
if (isServer) then {
	[] execVM "server\init_server.sqf";
};
civilianBasePos = getMarkerPos "respawn_civilian";
sizeLocation = 250;
