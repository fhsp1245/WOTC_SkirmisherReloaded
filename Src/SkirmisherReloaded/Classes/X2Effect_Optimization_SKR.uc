class X2Effect_Optimization_SKR extends X2Effect_Persistent;

var bool bAllowCrit;
var int iOPTIMIZATION_AIM_BONUS;
var int iOPTIMIZATION_CRIT_BONUS;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{ 
	return bAllowCrit; 
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local X2AbilityToHitCalc_StandardAim AimCalc;
	local ShotModifierInfo ShotMod;
	local UnitValue ZeroInValue;
	
	Attacker.GetUnitValue('ZeroInShots', ZeroInValue);
	AimCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if(AimCalc.bReactionFire == true)
	{
		ShotMod.ModType = eHit_Crit;
		ShotMod.Reason = FriendlyName;
		ShotMod.Value = ZeroInValue.fValue *  iOPTIMIZATION_CRIT_BONUS;
		ShotModifiers.AddItem(ShotMod);

		ShotMod.ModType = eHit_Success;
		ShotMod.Reason = FriendlyName;
		ShotMod.Value = ZeroInValue.fValue *  iOPTIMIZATION_AIM_BONUS;
		ShotModifiers.AddItem(ShotMod);
	}	
}
