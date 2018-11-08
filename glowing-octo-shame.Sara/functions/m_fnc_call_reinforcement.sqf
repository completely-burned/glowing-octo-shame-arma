private["_side"];
if(count _this > 0)then{
		_side = _this select 0;
}else{
		_side = [[east,west,resistance],[0.5,0.5,0.5]] call BIS_fnc_selectRandomWeighted;
};

private["_pos"];
private["_typeList"];
private["_patrol"];
if(count _this > 1)then{
	private ["_players"];
	if(isMultiplayer)then{
		_players = [];
		{
			if(isPlayer _x) then
			{
				_players = (_players + [_x]);
			}
		} foreach playableUnits;
	}else{
		_players = [player];
	};
	if (count _players > 0) then {
		_pos = getPos (_players call BIS_fnc_selectRandom);
	}else{
		_pos = civilianBasePos;
	};
	_patrol = true;
}else{
	_pos = civilianBasePos;
	_patrol = false;
};

if(_patrol)then{
	switch (_side) do {
		case (east):
		{
			_typeList=AllGroupsEastOld;
		};
		case (west):
		{
			_typeList=AllGroupsWestOld;
		};
		case (resistance):
		{
			_typeList=AllGroupsGuerrilaOld;
		};
		default {};
	};
}else{
	switch (_side) do {
		case (east):
		{
			_typeList=AllGroupsEast;
		};
		case (west):
		{
			_typeList=AllGroupsWest;
		};
		case (resistance):
		{
			_typeList=AllGroupsGuerrila;
		};
		default {};
	};
};

private["_grp1"];
private["_types"];
private["_SafePosParams"];
private["_pos_resp"];
_grp1 = (_typeList call BIS_fnc_selectRandomWeighted);
_types = [_grp1, [0, 0, 0]] call BIS_fnc_returnNestedElement;

_SafePosParams = ([_types] call m_fnc_SafePosParams);

if (_patrol)then{
	_SafePosParams set [0,((_SafePosParams select 0) * 2)];
	_SafePosParams set [1,((_SafePosParams select 1) * 2)];
};

_pos_resp = ([_pos]+_SafePosParams+[_side] call m_fnc_findSafePos);

if(count _pos_resp > 0)then{
private["_groups"];

_groups = ([_pos_resp, _side, _grp1 select 0] call m_fnc_spawnGroup);

private ["_units","_vehicles","_crew","_cargo"];
_units = []; _vehicles=[]; _crew = []; _cargo=[];
{
	private ["_grp"];
	_grp = _x;
	if(_patrol)then{
		 patrolGrps = patrolGrps + [_grp];
	};
	{
		_units set [count _units, _x];
		private ["_veh"];
		_veh = vehicle _x;
		if(_veh != _x)then{
			_crew set [count _crew, _x];
			if!(_veh in _vehicles)then{
				_vehicles set [count _vehicles, _veh];
			};
		}else{
			_cargo set [count _cargo, _x];
		};
	}forEach units _grp;

	while {(count (waypoints _grp)) > 0} do
	{
		deleteWaypoint ((waypoints _grp) select 0);
	};
	_grp spawn draga_fnc_group_init;
}forEach _groups;

private["_cargo2"];
_cargo2 = _cargo - (units (_groups select 0));

{
	_x setSkill m_skill;
	_x enableAI "TARGET";
	_x enableAI "AUTOTARGET";
	_x setSkill ["commanding", 1];
} foreach _units + _vehicles;

AllUnits = AllUnits + _units;
allGroups = allGroups + _groups;

private["_random2","_random5","_random10"];
_random2 = random 2; _random5 = random 5; _random10 = random 10;
if (_patrol)then{
	{
		_x setVariable ["time", time + (60 * 9) + (60 * _random2)];
	} foreach (_units );
}else{
	if (("air" in _types) || ("plane" in _types) || ("uav" in _types))then{
		{
			_x setVariable ["time", time + (60 * (5 + _random5))];
		} foreach _units;
	}else{
		{
			_x setVariable ["time", time + (60 * (40 + _random10))];
		} foreach (_units);
	};
};

if(count _cargo2 > 0)then{
	{
		_x setVariable ["time", time + (60 * (10 + _random5))];
	} foreach (_cargo2);
};
_groups;
}else{
	[grpNull];
};
