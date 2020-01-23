class X2Effect_BulletTime_SKR extends X2Effect_Persistent;

var int iBULLETTIME_GRAZEDMG_MODIFIER;
var int iBULLETTIME_TOCRITHIT_MODIFIER;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritModifier;
    local XComGameState_Unit EffectSource;
	
    EffectSource = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if(Target.ObjectID == EffectSource.ObjectID)
	{	
		CritModifier.ModType = eHit_Crit;
		CritModifier.Reason = FriendlyName;
		CritModifier.Value = -1 * iBULLETTIME_TOCRITHIT_MODIFIER;
		ShotModifiers.AddItem(CritModifier);
	}
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState) 
{ 
	local int Modifier;

	if(AppliedData.AbilityResultContext.HitResult == eHit_Graze)
	{
		if(iBULLETTIME_GRAZEDMG_MODIFIER >= CurrentDamage)
			Modifier = -1 * (CurrentDamage - 1);
		else
			Modifier = -1 * iBULLETTIME_GRAZEDMG_MODIFIER;
	}
	else
	{
		Modifier = 0;
	}
	return Modifier; 
}