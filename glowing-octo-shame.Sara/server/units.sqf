
private ["_allowGetin","_deleteList","_getOut"];
while{true}do{
_deleteList=[];
_getOut=[];
{
	Private["_assignedVehicle"];
	_assignedVehicle = assignedVehicle _x;
	_allowGetin=true;
	if(alive _x)then{
		if(false)then{
			if(!isNull _assignedVehicle)then{
				private ["_VehicleRole"];
				_VehicleRole = assignedVehicleRole _x;

				if(_allowGetin)then{
				// private ["_behaviour"];
				// _behaviour = behaviour _x;
					if((behaviour _x == "COMBAT"))then{
						if(count _VehicleRole > 0)then{
							if(_VehicleRole select 0 == "Cargo")then{
								_allowGetin=false;
							};
							if(_VehicleRole select 0 == "Turret")then{
							};
						};
					};
				};

				if(_allowGetin && true)then{
					if(((civilianBasePos distance vehicle _x)<(500 max sizeLocation))or ((civilianBasePos distance _assignedVehicle)<(500 max sizeLocation)))then{
						private ["_enableAttack"];
						_enableAttack = true;
						if!(_enableAttack)then{
						};
						if!(_enableAttack)then{
							if!(_assignedVehicle isKindOf "Air")then{
								_allowGetin=false;
							};
						}else{
							if(count _VehicleRole > 0)then{
								if(_VehicleRole select 0 == "Cargo")then{
									_allowGetin=false;
								};
								if(_VehicleRole select 0 == "Turret")then{
								};
							};
						};
					};
				};

				if(_allowGetin && true)then{
					if(_assignedVehicle isKindOf "LandVehicle")then{
						if(([vehicle _x, 300, side _x] call m_fnc_CheckCombatNearUnits))then{
							if(count _VehicleRole > 0)then{
								if(_VehicleRole select 0 == "Cargo")then{
									_allowGetin=false;
								};
								if(_VehicleRole select 0 == "Turret")then{
									if(_assignedVehicle isKindOf "BMP3")then{
										if(([_VehicleRole, [1, 0]] call BIS_fnc_returnNestedElement) in [1,2])then{
											_allowGetin=false;
										};
									};
								};
							};
						};
					};
				};

				if(_allowGetin)then{
					if(_assignedVehicle != vehicle _x)then{
						if((_assignedVehicle distance vehicle _x)>1000)then{
							_allowGetin=false;
						};
					};
				};

				if(_allowGetin)then{
					if(_assignedVehicle isKindOf "LandVehicle")then{
						if!([_assignedVehicle, false] call draga_fnc_CheckTurretAlive)then{
							_allowGetin=false;
						};
					}
				};

				if(toLower getText(configFile >> "CfgVehicles" >> typeOf _assignedVehicle >> "simulation") == "airplane")then{
					if(_x == vehicle _x)then{
						_allowGetin=false;
					};
					if(_assignedVehicle == vehicle _x)then{
						_allowGetin=true;
					};
				};

				if!(_allowGetin)then{
					if(_assignedVehicle isKindOf "Ship")then{
						_allowGetin=true;
					};
				};
			};
		};

		if (!isPlayer _x) then {

			Private["_time","_delete"];
			_delete = false;
			_time = (_x getVariable "time");
			if ( isNil "_time" ) then {
				_time = ( time + ( 60 * 30 ) );
				_x setVariable ["time", _time];
			}else{
				if ( _time < time )then {
					_delete = true;
				};
			};

				if (!_delete) then {
					if (isNull _assignedVehicle) then {
						if !(group _x in patrolGrps) then {
							if (_x distance civilianBasePos > 2500 max sizeLocation) then {
								_delete = true;
								_x setVariable ["time", time];
							};
						};
					};
				};


				if (_delete) then {
					if ((vehicle _x distance civilianBasePos) <= (sizeLocation / 2 + sizeLocation)) then {
						_delete = false;
						if ( _time < ( time + 180 ) )then {
							_time = time + 180;
							_x setVariable ["time", _time];
						};
					};
				};

				if (!_delete) then {
					if (fleeing _x) then {
						_delete = true;
						_x setVariable ["time", time];
					};
				};

				if (!_delete) then {
					if([[_x], listCrew] call m_fnc_CheckIsKindOfArray)then{
						if(isNull _assignedVehicle)then{
							_delete = true;
						};
					};
				};

					if (vehicle _x == _x) then {
						if (surfaceIsWater getPos _x) then {
							_timeIsWater = (_x getVariable "timeIsWater");
							if ( isNil "_timeIsWater" ) then {
								_timeIsWater = ( time + ( 60 * 3 ) );
								_x setVariable ["timeIsWater", _timeIsWater];
							}else{
								if ( _timeIsWater < time )then {
									_x setDamage 1;
								};
							};
						}else{
							_x setVariable ["timeIsWater", nil];
						};
					};

			if (_delete) then {
				_deleteList set [count _deleteList,_x];
			};

		};

	}else{
		[_x] joinSilent grpNull;
		_deleteList set [count _deleteList,_x];
	};

	if!(_allowGetin)then{
		_getOut set [count _getOut,_x];
	};
	sleep 0.01;
} forEach allUnits;

_getOut allowGetin false;

allUnits-_getOut allowGetin true;

_deleteList call fnc_cleanup;
	sleep 1;
};
