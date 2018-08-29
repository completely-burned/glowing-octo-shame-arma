private["_leader"];
_leader = (_this select 0);
	private ["_grp"];
	_grp = (_this select 1);

	private["_currentWP","_waypoints","_leaderPos"];
	_waypoints = waypoints _grp;
	_currentWP = 0;
	_leaderPos = getPos vehicle _leader;

	private ["_units","_vehicles","_landing","_types"];
	_units = units _grp;
	_vehicles = [];
	_types = [];
	_landing = false;
	{
		_types set [count _types, typeOf _x];
		private ["_veh"];
		_veh = vehicle _x;
		if(_veh != _x)then{
			if!(_veh in _vehicles)then{
				if (group effectiveCommander _veh == _grp) then {
					_vehicles set [count _vehicles, _veh];
					_types set [count _types, typeOf _veh];
					if(crew _veh - driver _veh - gunner _veh - commander _veh > 0)then{
						_landing = true;
					};
				};
			};
		};
	}forEach _units;

	private["_WaypointCombatMode"];
	_WaypointCombatMode = "RED";

	private["_WaypointBehaviour"];
	_WaypointBehaviour = "AWARE";

	private ["_patrol"];
	if (_grp in patrolGrps) then {_patrol = true}else{_patrol = false};

	private ["_pos"];
	_pos=civilianBasePos;

	private ["_air","_AA","_Ship","_arty","_uav"];
	_air = ([_vehicles, ["Air"]] call m_fnc_CheckIsKindOfArray);
	_AA = ([_vehicles, ["ZSU_Base","2S6M_Tunguska","HMMWV_Avenger","M6_EP1"]] call m_fnc_CheckIsKindOfArray);
	_Ship = ([_vehicles, ["Ship"]] call m_fnc_CheckIsKindOfArray);
	if({getNumber(LIB_cfgVeh >> _x >> "artilleryScanner") == 1}count _types > 0)then{
		_arty = true;
	}else{
		_arty = false;
	};
	_uav = ([_types, ["UAV"]] call m_fnc_CheckIsKindOfArray);
	if({getNumber (LIB_cfgVeh >> _x >> "isUav") == 1} count _types > 0)then{
		_uav = true;
	};
	private["_support"];
	_support = false;
	ScopeName "_support";
	{
		if(getNumber(LIB_cfgVeh >> _x >> "attendant")> 0 && _x isKindOf "LandVehicle")then{
			_support = true;
			BreakTo "_support";
		};
		if(getNumber(LIB_cfgVeh >> _x >> "transportfuel")> 0)then{
			_support = true;
			BreakTo "_support";
		};
		if(getNumber(LIB_cfgVeh >> _x >> "transportammo")> 0)then{
			_support = true;
			BreakTo "_support";
		};
		if(getNumber(LIB_cfgVeh >> _x >> "transportrepair")> 0)then{
			_support = true;
			BreakTo "_support";
		};

	}forEach _types;

	if(_uav)then{
		_WaypointCombatMode = "BLUE";
		_WaypointBehaviour = "CARELESS";
	};
	private ["_maxDist","_WaypointCompletionRadius","_SpeedMode"];
	if(_air)then{
		_maxDist = 4000;
		_WaypointCompletionRadius = 500;
		_SpeedMode = "FULL";
	}else{
		_maxDist = sizeLocation ;
		_WaypointCompletionRadius = 50;
		_SpeedMode = "NORMAL";
	};
	if(_AA)then{
		_maxDist = 200;
		_WaypointCompletionRadius = 1000;
	};
	if(_patrol)then{
		_pos = _leaderPos;
		_maxDist = ((_maxDist * 10) max 1500);
	};
	if(_arty)then{
		_pos = _leaderPos;
		_maxDist = ((_maxDist * 10) max 1500);
	};

	if(_landing && _air)then{
		_pos = civilianBasePos;
		_maxDist = sizeLocation*2;
		_WaypointCompletionRadius = _maxDist;
		_SpeedMode = "NORMAL";
	};

	if(_landing && _Ship)then{
		_pos = civilianBasePos;
		_maxDist = sizeLocation*2;
		_WaypointCompletionRadius = 400;
		_SpeedMode = "NORMAL";
	};

	private["_WaypointType"];
	_WaypointType = "MOVE";
	if(_support)then{
		_WaypointType = "SUPPORT";
		_pos = _leaderPos;
	};

	if(_landing && _air)then{
		_WaypointType = "UNLOAD";
	};

	if(_Submarine)then{
		_WaypointType = "GETOUT";
	};

	if(_WaypointType in ["UNLOAD","GETOUT"])then{
		_WaypointCombatMode = "GREEN";
	};

	if(count _vehicles == 0 && false)then{
		private["_true"];
		_true = true;
		private ["_dir","_dist2","_testPos"];
		_testPos = [];
		while {_true && ({alive _x} count _units > 0)} do {
			_dir = random 360;
			_dist2 = random _maxDist;
			_testPos = [(_pos select 0) + _dist2*sin _dir, (_pos select 1) + _dist2*cos _dir];
			_testPos = [_testPos,-1,0] call draga_fnc_isFlatEmpty;
			hint str _testPos;
			sleep 0.01;
			if(count _testPos > 0 or (({alive _x} count _units) == 0))then {_true = false};
		};
		if(count _testPos > 0)then {_pos = _testPos; _maxDist = 0};

	};
	private["_wp"];
	if (count waypoints _grp == 0) then {
		_wp = _grp addwaypoint [_pos, _maxDist];
	} else {
		_wp = [_grp,0];
	};
	_wp setWaypointType _WaypointType;
	_wp setWaypointSpeed _SpeedMode;
	_wp setWaypointCombatMode _WaypointCombatMode;
	_wp setWaypointBehaviour _WaypointBehaviour;
	// _wp setWaypointStatements ["true", "if(!isNil {this})then{group this setVariable ['_grp_wp_completed',true]; [this,true] call m_fnc_waypoints}"];
