class X2Effect_WrathDamage extends X2Effect_Persistent;

var int iWRATH_DAMAGE_BONUS;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int ExtraDamage;

	if (AbilityState.GetMyTemplateName() == 'PostAbilityMeleeForWrath' && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		ExtraDamage = iWRATH_DAMAGE_BONUS;
	}
	return ExtraDamage;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
