// тут все сделано неправильно, надо исправить

waitUntil {!isNil "m_fnc_init"};
waitUntil {!isNil "GroupsStarted"};
waitUntil {!isNil "locationStarted"};

private["_minFPS","_minGroups","_maxGroups","_enemyCoefficient","_playerCoefficient","_enemyCoefficientCfg","_timeFriendlyReinforcements"];

private["_all_groups","_friendlyGroups","_friendlyPatrols","_enemyGroups","_enemyPatrols","_enemySide"];

_enemySide = [west,east,resistance] - m_friendlySide;

while{true}do{
	_friendlyGroups = 0; _friendlyPatrols = 0; _enemyGroups = 0; _enemyPatrols = 0;
	{
		private ["_grp"];
		_grp=_x;
		Private["_side"];
		_side = side _grp;

		if({alive _x}count units _grp >0)then{
			if(!isPlayer leader _grp)then{
				if (_grp in patrolGrps) then {
					if (_side in m_friendlySide) then {
						_friendlyPatrols = _friendlyPatrols + 1;
					}else{
						_enemyPatrols = _enemyPatrols + 1;
					};
				}else{
					if (_side in m_friendlySide) then {
						_friendlyGroups = _friendlyGroups + 1;
					}else{
						_enemyGroups = _enemyGroups + 1;
					};
				};
			};
		}else{
			deleteGroup _grp;
		};
	}forEach allGroups;

	_all_groups=(_friendlyPatrols+_enemyPatrols+_friendlyGroups+_enemyGroups);

	if (isMultiplayer)then{
		{
			if(isPlayer _x)then{
				_friendlyGroups = _friendlyGroups + playerCoefficient;
			};
		}forEach playableUnits;
	}else{
		_friendlyGroups = _friendlyGroups + playerCoefficient;
	};

	if(!isNil {CivilianLocationStartTime})then{
		private["_time"];
		_time = time - CivilianLocationStartTime;
		_enemyCoefficient =  timeFriendlyReinforcements / (_time max 0.0001);
		_enemyCoefficient = (enemyCoefficientCfg min _enemyCoefficient) max 1;
	}else{
		_enemyCoefficient = enemyCoefficientCfg;
	};

	if(playerSide == civilian)then{
		_enemyCoefficient = 1;
	};

	if(_all_groups < maxGroups or maxGroups == 0)then{
			private ["_difference"];
			_difference = (((_all_groups / 5) min 8) max 4);
			if (_friendlyGroups * _enemyCoefficient + _difference >= _enemyGroups) then {
				[_enemySide call BIS_fnc_selectRandom] call m_fnc_call_reinforcement;
			};
			if (_enemyGroups + _difference >= _friendlyGroups * _enemyCoefficient) then {
				[m_friendlySide call BIS_fnc_selectRandom] call m_fnc_call_reinforcement;
			};
			if ((_enemyPatrols + _friendlyPatrols) < ((_enemyGroups + _friendlyGroups) / 4)) then {
				if (_friendlyPatrols * _enemyCoefficient + _difference >= _enemyPatrols) then {
					[_enemySide call BIS_fnc_selectRandom,"patrol"] call m_fnc_call_reinforcement;
				};
				if (_enemyPatrols + _difference >= _friendlyPatrols * _enemyCoefficient) then {
					[m_friendlySide call BIS_fnc_selectRandom,"patrol"] call m_fnc_call_reinforcement;
				};
			};
	};
	sleep 0.1;
};
