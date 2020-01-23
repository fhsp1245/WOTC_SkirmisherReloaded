class X2Effect_TuningDamage_SKR extends X2Effect_Persistent;

var int iTUNING_BONUSDMG;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
	local int ExtraDamage;

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if(AbilityState.SourceWeapon.ObjectID == Attacker.GetPrimaryWeapon().ObjectID || AbilityState.SourceWeapon.ObjectID == Attacker.GetSecondaryWeapon().ObjectID)
			ExtraDamage = iTUNING_BONUSDMG;
	}
	return ExtraDamage; 
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}
