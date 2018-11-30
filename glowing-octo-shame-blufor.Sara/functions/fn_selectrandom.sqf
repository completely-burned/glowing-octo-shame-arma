/************************************************************
	Random Select
	By Andrew Barron

Parameters: array

This returns a randomly selected element from the passed array.

Example: [1,2,3] call BIS_fnc_selectRandom
Returns: 1, 2, or 3
************************************************************/

if(count _this == 0) exitWith {objNull};

_this select floor random count _this;
