
private ["_west","_east","_guer","_woodland","_deserted"];
_west=[];_east=[];_guer=[];

			_east=_east+[
				[[[["SquadleaderE","TeamLeaderE","TeamLeaderE","SoldierEG","SoldierEG","SoldierEMG","SoldierEMG","SoldierEAT","SoldierESniper"],[],[]]],0.5],
				[[[["Ka50","Ka50"],[[0,0,0],[5,-5,0]],["CAPTAIN","LIEUTENANT"]]],0.05],
				[[[["T72","T72","T72","T72"],[[0,0,0],[5,-5,0],[5,5,0],[-5,5,0]],["CAPTAIN","LIEUTENANT","LIEUTENANT","CORPORAL"]]],0.15]
			];
			_west=_west+[
				[[[["SquadLeaderW","TeamLeaderW","TeamLeaderW","SoldierWG","SoldierWG","SoldierWAR","SoldierWAR","SoldierWAT","SoldierWSniper"],[],[]]],0.5],
				[[[["AH1W","AH1W"],[[0,0,0],[5,-5,0]],["CAPTAIN","LIEUTENANT"]]],0.05],
				[[[["M1Abrams","M1Abrams","M1Abrams","M1Abrams"],[[0,0,0],[5,-5,0],[5,5,0],[-5,5,0]],["CAPTAIN","LIEUTENANT","LIEUTENANT","CORPORAL"]]],0.15]
			];
			_guer=_guer+[
			[[[["SquadleaderG","TeamLeaderG","SoldierGG","SoldierGMG","SoldierGMG","SoldierGB","SoldierGB","SoldierGB","SoldierGAT"],[],[]]],0.5],
			[[[["T72_RACS","T72_RACS","T72_RACS","T72_RACS"],[[0,0,0],[5,-5,0],[5,5,0]],["LIEUTENANT","CORPORAL","CORPORAL"]]],0.15]
			];

AllGroupsWest=_west;
AllGroupsEast=_east;
AllGroupsGuerrila=_guer;
