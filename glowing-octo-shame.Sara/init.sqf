[] Call Compile preprocessFileLineNumbers "init_common.sqf";
if (isServer) then {
	[] execVM "server\init_server.sqf";
};
