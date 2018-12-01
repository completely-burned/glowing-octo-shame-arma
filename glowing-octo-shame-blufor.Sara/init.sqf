[] Call Compile preprocessFileLineNumbers "init_common.sqf";
if (isServer) then {
	[] execVM "server\init_server.sqf";
};

[] execVM "client\init_client.sqf";
