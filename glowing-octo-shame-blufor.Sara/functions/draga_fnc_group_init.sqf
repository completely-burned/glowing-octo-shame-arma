		private["_grp","_leader"];
		_grp = _this;
		_leader = leader _grp;

		private["_time"];
		_time = time;
		private["_cleanup"];
		_cleanup = [getPos vehicle _leader,time+40,time+120,waypointPosition [_grp,0]];

while{!isNull _grp}do{

if(isPlayer _leader)then{
	while {(count (waypoints _grp)) > 0} do
	{
		deleteWaypoint ((waypoints _grp) select 0);
	};
}else{
		private["_oldPos","_oldTime","_oldTime2","_oldPosWP"];
		_oldPos = _cleanup select 0;
		_oldTime = _cleanup select 1;
		_oldTime2 = _cleanup select 2;
		_oldPosWP = _cleanup select 3;
		private["_pos"];
		_pos = getPos vehicle _leader;
		private["_true"];
		_true = false;
		if(waypointPosition [_grp,0] distance _oldPosWP  < 5 )then{
			if!(_true)then{
				if((vehicle _leader distance civilianBasePos) <= (sizeLocation / 2 + sizeLocation))then{
					_cleanup = [getPos vehicle _leader,time+40,time+120,waypointPosition [_grp,0]];
					_true = true;
				};
			};
			if!(_true)then{
				if(_oldTime < time)then{
					if(_oldPos distance _pos >= 1)then{
						_cleanup = [getPos vehicle _leader,time+40,time+120,waypointPosition [_grp,0]];
						_true = true;
					}else{
						_cleanup = [getPos vehicle _leader,time+40,_oldTime2,waypointPosition [_grp,0]];
						while {(count (waypoints _grp)) > 0} do
						{
							deleteWaypoint ((waypoints _grp) select 0);
						};
						_true = true;
					};
				};
			};
			if(_oldTime2 < time)then{
					{_x setVariable ["time", 0]}forEach units _grp;
					_true = true;
			};
		}else{
			_cleanup = [getPos vehicle _leader,time+40,time+120,waypointPosition [_grp,0]];
		};
	};

	if(count waypoints _grp == 0)then{
		[_leader,_grp] call m_fnc_waypoints;
	};

	sleep 0.01;
};
