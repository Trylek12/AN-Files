/*
	File: fn_copSearch.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Returns information on the search.
*/
life_action_inUse = false;
params [
	["_civ",objNull,[objNull]],
	["_invs",[],[[]]],
	["_robber",false,[false]]
];
if(isNull _civ) exitWith {};
private _illegal = 0;
private _inv = "";

if(count _invs > 0) then
{
	{
		_displayName = getText (missionConfigFile >> "VirtualItems" >> _x select 0 >> "displayName");
		_inv = _inv + format["%1 %2<br/>",_x select 1,(localize _displayName)];
		_price = getNumber (missionConfigFile >> "VirtualItems" >> _x select 0 >> "sellPrice");

		if(!(_price isEqualTo -1)) then {
			_illegal = _illegal + ((_x select 1) * _price);
		};
	} forEach _invs;

	[0,"STR_Cop_Contraband",true,[(_civ getVariable ["realname",name _civ]),[_illegal] call life_fnc_rupadudejat]] remoteExecCall ["life_fnc_brusathusek",west];
}
else
{
	_inv = localize "STR_Cop_NoIllegal";
};

if(!alive _civ || {player distance _civ > 5}) exitWith {hintSilent format[localize "STR_Cop_CouldntSearch",_civ getVariable ["realname",name _civ]]};
hintSilent parseText format["<t color='#FF0000'><t size='2'>%1</t></t><br/><t color='#FFD700'><t size='1.5'><br/>" +(localize "STR_Cop_IllegalItems")+ "</t></t><br/>%2<br/><br/><br/><br/><t color='#FF0000'>%3</t>"
,(_civ getVariable ["realname",name _civ]),_inv,if(_robber) then {"Robbed the bank"} else {""}];

if(_robber) then {
	[0,"STR_Cop_Robber",true,[(_civ getVariable ["realname",name _civ])]] remoteExecCall ["life_fnc_brusathusek",-2];
};
