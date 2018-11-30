private["_pos","_objDist","_waterMode","_true"];
_pos = _this select 0;
_objDist = _this select 1;
_waterMode = _this select 2;
_true = true;

if (true) then {
  if (_waterMode == 0 && surfaceIsWater _pos) then {
    _true = false;
  };
  if (_waterMode == 2 && !surfaceIsWater _pos) then {
    _true = false;
  };
};

if (count (_pos nearObjects _objDist) > 0) then {
  _true = false;
};
if (_true) then {_pos}else{[]};
