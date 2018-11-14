///--- бардак, комментировать нечего
// waitUntil {!isNil "bis_fnc_init"};
locationTypes=["Name","NameVillage","NameCity","NameCityCapital"];
// if(worldName == "Shapur_BAF")then{
	// locationTypes=["NameLocal","NameVillage","NameCity","NameCityCapital"];
// };
// private["_fnc_Locations_1"];

waitUntil {!isNil "AllGroupsWestOld"};
waitUntil {!isNil "AllGroupsEastOld"};
waitUntil {!isNil "AllGroupsGuerrilaOld"};
// private["_locationNext"];
locationNext={
	if(!isNil {CivilianLocation})then{
		CivilianLocation setVariable ["time",time];
	};

	private["_sizeLocation"];
	_sizeLocation = + 500;
	private["_NextLocations"];
	_NextLocations = (nearestLocations [civilianBasePos, locationTypes, 5000]);
	if(!isNil {CivilianLocation})then{
		_NextLocations = (_NextLocations - [CivilianLocation]);
	};
	if(count _NextLocations >0 )then{
		CivilianLocationStartTime = time;
		CivilianLocation = _NextLocations call BIS_fnc_selectRandom;
		civilianBasePos = locationPosition CivilianLocation;
		civilianBasePos resize 2;
		publicVariable "civilianBasePos";
		publicVariable "CivilianLocation";
		_sizeLocation = (((size CivilianLocation) select 0) max 250);
		{_x setDamage 0} forEach (nearestObjects [civilianBasePos, [], 1000]);
	};


 	private["_grps_rarity"];
 	_grps_rarity = CivilianLocation getVariable "_grps_rarity";
 	if (isNil {_grps_rarity}) then {
		AllGroupsWest 		= AllGroupsWestOld;
		AllGroupsEast 		= AllGroupsEastOld;
		AllGroupsGuerrila 	= AllGroupsGuerrilaOld;
	}else{
		private["_fnc4"];
		_fnc4={
			private["_grp","_types"];
			_grp = +(_this select 0);
			for "_i" from 0 to ((count (_grp select 0)) - 1) do {
				_types = [_grp, [0, _i, 0, 0, 0]] call BIS_fnc_returnNestedElement;
				{
					if ([_types, _x select 0] call m_fnc_CheckIsKindOfArray) then {
						private["_rarity"];
						_rarity = ([_grp, [1, _i]] call BIS_fnc_returnNestedElement);
						_rarity = (_rarity * (_x select 1));
						[_grp, [1, _i],  _rarity] call BIS_fnc_setNestedElement;
					};

				}forEach (_this select 1);
			};
			_grp
		};

		AllGroupsWest 		= ([AllGroupsWestOld, _grps_rarity] call _fnc4);
		AllGroupsEast 		= ([AllGroupsEastOld, _grps_rarity] call _fnc4);
		AllGroupsGuerrila 	= ([AllGroupsGuerrilaOld, _grps_rarity] call _fnc4);
	};

	"MainTown" setMarkerPos civilianBasePos;
	"MainTown" setMarkerSize [_sizeLocation,_sizeLocation];
	sizeLocation=_sizeLocation;
	publicVariable "sizeLocation";
};

CreateMarker ["MainTown", getPos player];
"MainTown" setMarkerShape "ELLIPSE";
"MainTown" setMarkerColor "ColorBlack";

// CivilianLocation = locationNull;
civilianBasePos = position player;
sizeLocation = 250;
[] call locationNext;
locationStarted = true;
