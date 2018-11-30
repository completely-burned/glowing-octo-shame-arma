if (getNumber(configFile >> "CfgVehicles" >> typeOf _this >> "isMan") == 1) then {
	if({isPlayer _x} count units _this > 0)then{
	};

	if!(_this in AllUnits)then{
		AllUnits = AllUnits + [_this];
	};

	private["_grp"];
	_grp = group _this;
	if!(_grp in allGroups)then{
		allGroups = allGroups + [_grp];
	};
}else{
};
