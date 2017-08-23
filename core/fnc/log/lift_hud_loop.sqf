
disableSerialization;

private ["_cargo","_chopper","_array","_cargo_array","_can_lift","_cargo_pos","_rel_pos","_cargo_x","_cargo_y","_cargo_z","_obj_img","_hud_x","_hud_y","_hud_x_1","_hud_y_1","_pic_cargo","_obj_name","_name_cargo","_arrow_down","_arrow_up","_arrow","_complete","_incomplete","_obj_pic","_obj_alt"];

if !((Alive player && vehicle player != player) && btc_log_hud) then {
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	939996 cutRsc ["Default","PLAIN"];
};

_arrow_up	= _this select 0 select 0;
_arrow_down	= _this select 0 select 1;
_complete	= _this select 0 select 2;
_incomplete	= _this select 0 select 3;
_obj_img	= _this select 0 select 4;
_obj_pic	= _this select 0 select 5;
_arrow		= _this select 0 select 6;
_obj_name	= _this select 0 select 7;
_obj_alt	= _this select 0 select 8;

_chopper = vehicle player;
_array = [_chopper] call btc_fnc_log_get_liftable;
_cargo_array = nearestObjects [_chopper, _array, 30];
if (count _array == 0) then {_cargo_array = [];};
_cargo_array = _cargo_array - [_chopper];
if (count _cargo_array > 0 && ((_cargo_array select 0) isKindOf "ACE_friesGantry") OR (typeof (_cargo_array select 0) isEqualTo "ACE_friesAnchorBar")) then {_cargo_array deleteAt 0;};
if (count _cargo_array > 0) then {_cargo = _cargo_array select 0;} else {_cargo = objNull;};

if (({_cargo isKindOf _x} count _array) > 0) then {_can_lift = true;} else {_can_lift = false;};

if (!isNull _cargo) then {
	_cargo_pos = getPosATL _cargo;
	_rel_pos   = (_chopper) worldToModel _cargo_pos;
	_cargo_x   = _rel_pos select 0;
	_cargo_y   = _rel_pos select 1;
	_cargo_z   = _rel_pos select 2;
	_obj_img ctrlShow true;
	_hud_x   = _cargo_x / 100;
	switch (true) do {
		case (_cargo_y < 0): {_hud_y = (abs _cargo_y) / 100};
		case (_cargo_y > 0): {_hud_y = (0 - _cargo_y) / 100};
	};
	_hud_x_1 = (btc_lift_HUD_x + _hud_x) * safezoneW + safezoneX;
	_hud_y_1 = (btc_lift_HUD_y + _hud_y) * safezoneH + safezoneY;
	_obj_img ctrlsetposition [_hud_x_1, _hud_y_1];
	_obj_img ctrlCommit 0;
	_pic_cargo = "";
	if (_cargo isKindOf "LandVehicle") then {_pic_cargo = getText (configFile >> "cfgVehicles" >> typeof _cargo >> "picture");} else {_pic_cargo = "";};
	_name_cargo = getText (configFile >> "cfgVehicles" >> typeof _cargo >> "displayName");
	_obj_pic ctrlSetText _pic_cargo;
	_obj_name ctrlSetText _name_cargo;
	if (btc_lifted) then {
		_obj_alt ctrlSetText (format ["%1 m",(round((getpos _cargo select 2) * 10))/10]);
		_obj_img ctrlSetTextColor [0, 1, 0, 1];
	};

	if ((abs _cargo_z) > (btc_lift_max_h + 3)) then {
		_arrow ctrlSetText _arrow_down;
		_arrow ctrlSetTextColor [1, 0, 0, 1];
	} else {
		if ((abs _cargo_z) > btc_lift_max_h) then {
			_arrow ctrlSetText _arrow_down;
			_arrow ctrlSetTextColor [1, 1, 0, 1];
		};
	};
	if ((abs _cargo_z) < (btc_lift_min_h - 3)) then {
		_arrow ctrlSetText _arrow_up;
		_arrow ctrlSetTextColor [1, 0, 0, 1];
	} else {
		if ((abs _cargo_z) < btc_lift_min_h) then {
			_arrow ctrlSetText _arrow_up;
			_arrow ctrlSetTextColor [1, 1, 0, 1];
		};
	};
	if ((abs _cargo_z) > btc_lift_min_h && (abs _cargo_z) < btc_lift_max_h) then {
		_arrow ctrlSetText _complete;
		_arrow ctrlSetTextColor [0, 1, 0, 1];
	};
	if !(_can_lift) then {
		_arrow ctrlSetText _incomplete;
		_arrow ctrlSetTextColor [1, 0, 0, 1];
	};

} else {
	_obj_img ctrlShow false;
	_obj_pic ctrlSetText "";
	_obj_name ctrlSetText "";
	_arrow ctrlSetText "";
};