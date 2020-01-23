class X2Ability_ReworkedSkirmisherPerkPack extends X2AbilityTemplate config(SkirmisherReloaded);

var config int iMAX_RETURNFIRE_TRIGGER;
var config int iWHIPLASH_COOLDOWN;
var config int iWHIPLASH_CRIT_CHANCE;
var config WeaponDamageValue WHIPLASH_BASE;
var config WeaponDamageValue WHIPLASH_ROBOT;
var config int iINTERRUPT_COOLDOWN;
var config int iMANUAL_OVERRIDE_COOLDOWN;
var config bool bHAS_BATTLELORD_ABILITYCHARGE;
var config int iBATTLELORD_COOLDOWN;
var config int iBATTLELORD_CHARGE;
var config int iPARKOUR_ACTION_POINT;
var config int iZEROIN_CRIT_BONUS;
var config int iZEROIN_AIM_BONUS;

var name ConcealedOverwatchTurn;
var name ManualOverrideEffectName;
var name ParkourEffectName;
var localized string sTacticalAnalysisFlyoverText;
var localized string sTacticalAnalysisWorldMessageText;

//Skirmisher can trigger Return Fire up to 3 times per turn
static function ReworkedSkirmisherReturnFire(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_ReturnFire FireEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.MaxPointsPerTurn = default.iMAX_RETURNFIRE_TRIGGER;
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, , ,Template.AbilitySourceName);
	AbilityTemplate.AddTargetEffect(FireEffect);
}

//Reflex triggered once per turn
static function ReworkedReflex(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_ReworkedReflex ReflexEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;

	ReflexEffect = new class'X2Effect_ReworkedReflex';
	ReflexEffect.BuildPersistentEffect(1, true, true, false);
	ReflexEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, , ,Template.AbilitySourceName);
	AbilityTemplate.AddTargetEffect(ReflexEffect);
}

//Wrath deals 2 additional damage
static function ReworkedWrath(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_GetOverThere GetOverThereEffect;
	local X2Effect_TriggerEvent PostAbilityMelee;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;

	GetOverThereEffect = new class'X2Effect_GetOverThere';
	AbilityTemplate.AddTargetEffect(GetOverThereEffect);

	PostAbilityMelee = new class'X2Effect_TriggerEvent';
	PostAbilityMelee.TriggerEventName = 'ActivateSkirmisherWrath';
	AbilityTemplate.AddTargetEffect(PostAbilityMelee);
	AbilityTemplate.DamagePreviewFn = class'X2Ability_NewSkirmisherPerkPack'.static.PostAbilityMeleeDamagePreview;
	AbilityTemplate.AdditionalAbilities.AddItem('PostAbilityMeleeForWrath');
	AbilityTemplate.AdditionalAbilities.AddItem('WrathDamageBuff');
}

//Total Combat intergrated with Marauder
static function ReworkedTotalCombatStandardFire(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost Cost;

	AbilityTemplate = Template;

	foreach AbilityTemplate.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SKR_TotalCombat');
	}
}

static function ReworkedTotalCombatThrowGrenade(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost Cost;

	AbilityTemplate = Template;

	foreach AbilityTemplate.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SKR_TotalCombat');
	}
}

static function ReworkedTotalCombatSkulljack(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost Cost;

	AbilityTemplate = Template;

	foreach AbilityTemplate.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SKR_TotalCombat');
	}
}

static function ReworkedTotalCombatSkullMine(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost Cost;

	AbilityTemplate = Template;

	foreach AbilityTemplate.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SKR_TotalCombat');
	}
}

static function ReworkedTotalCombatMimicBeacon(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCost Cost;

	AbilityTemplate = Template;

	foreach AbilityTemplate.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('SKR_TotalCombat');
	}
}

//Zero In now provide +5 aim and +10 crit bonuses that can be stacked whenever you attack
static function ReworkedZeroIn(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_ReworkedZeroIn ZeroInEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;

	ZeroInEffect = new class'X2Effect_ReworkedZeroIn';
	ZeroInEffect.iZEROIN_CRIT_BONUS = default.iZEROIN_CRIT_BONUS;
	ZeroInEffect.iZEROIN_AIM_BONUS = default.iZEROIN_AIM_BONUS;
	ZeroInEffect.BuildPersistentEffect(1, true, false, false);
	ZeroInEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	AbilityTemplate.AddTargetEffect(ZeroinEffect);
}

//Remove Whiplash's charge and add 5-turns cooldown
static function ReworkedWhiplash(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCooldown Cooldown;
	local X2AbilityCost_ActionPoints AbilityCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2AbilityToHitCalc_StandardAim StandardAim;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;
	
	AbilityTemplate.AbilityCharges = none;

	AbilityTemplate.AbilityCosts.Length = 0;
	AbilityCost = new class'X2AbilityCost_ActionPoints';
	AbilityCost.bFreeCost = true;
	AbilityCost.bConsumeAllPoints = true;
	AbilityTemplate.AbilityCosts.AddItem(AbilityCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.iWHIPLASH_COOLDOWN;
	AbilityTemplate.AbilityCooldown = Cooldown;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.EffectDamageValue = default.WHIPLASH_BASE;
	Template.AddTargetEffect(WeaponDamageEffect);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreArmor = true;	
	WeaponDamageEffect.EffectDamageValue = default.WHIPLASH_ROBOT;
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitPropertyCondition);
	Template.AddTargetEffect(WeaponDamageEffect);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInCritMod = default.iWHIPLASH_CRIT_CHANCE;
	StandardAim.bAllowCrit = true;
	AbilityTemplate.AbilityToHitCalc = StandardAim;
	
}

//Remove Interrupt's charge and add 3 turn cooldown.
static function ReworkedInterruptInput(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCooldown Cooldown;
	local X2AbilityCost_ActionPoints AbilityCost;

	AbilityTemplate = Template;

	AbilityTemplate.AbilityCharges = none;

	AbilityTemplate.AbilityCosts.Length = 0;
	AbilityCost = new class'X2AbilityCost_ActionPoints';
	AbilityCost.bFreeCost = true;
	AbilityCost.bConsumeAllPoints = true;
	AbilityCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	AbilityTemplate.AbilityCosts.AddItem(AbilityCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.iINTERRUPT_COOLDOWN;
	AbilityTemplate.AbilityCooldown = Cooldown;
}

//StunnedEffect from X2Ability_XPackAbilitySet - AddTacticalAnalysis();
//Add Interrupt to Tactical Analysis(lose 1 action point) effect, so the enemy triggered Interrupt will skip their next action. 
static function ReworkedInterrupt(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_Stunned StunnedEffect;

	AbilityTemplate = Template;

	StunnedEffect = new class'X2Effect_Stunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnEnd);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 1;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectName = 'TacticalAnalysis';
	//StunnedEffect.EffectTickedVisualizationFn = TacticalAnalysisVisualizationTicked;
	//StunnedEffect.EffectRemovedVisualizationFn = TacticalAnalysisVisualizationTicked;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	StunnedEffect.bSkipAnimation = true;
	StunnedEffect.CustomIdleOverrideAnim = '';
	StunnedEffect.DamageTypes.Length = 0;

	AbilityTemplate.AddTargetEffect(StunnedEffect);
}

//Copied from X2Ability_XPackAbilitySet for Interrupt's stun effect visualization, but functionally it does nothing at this time.
/*
function TacticalAnalysisVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{

	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (UnitState == none)
		return;

	if( !UnitState.IsAlive() )
	{
		return;
	}
	
	//class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.sTacticalAnalysisFlyoverText, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata, default.sTacticalAnalysisWorldMessageText, VisualizeGameState.GetContext(), class'UIEventNoticesTactical'.default.WillLostTitle, class'UIUtilities_Image'.const.UnitStatus_Stunned, eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}
*/

// Reduce all cooldowns to 1.
static function ReworkedManualOverride(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost_ActionPoints AbilityCost;
	local X2AbilityCooldown Cooldown;
	local X2Effect_ReworkedManualOverride ManualOverrideEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;

	AbilityTemplate.AbilityCosts.Length = 0;
	AbilityCost = new class'X2AbilityCost_ActionPoints';
	AbilityCost.bFreeCost = true;
	AbilityCost.bConsumeAllPoints = true;
	AbilityTemplate.AbilityCosts.AddItem(AbilityCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.iMANUAL_OVERRIDE_COOLDOWN;
	AbilityTemplate.AbilityCooldown = Cooldown;

	ManualOverrideEffect = new class'X2Effect_ReworkedManualOverride';
	AbilityTemplate.AddTargetEffect(ManualOverrideEffect);
}

//Battlelord will give you 2 action after every enemy action, and reduce all cooldown by 1 while activated. 
static function ReworkedBattlelord(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCharges Charges;
	local X2AbilityCost_Charges ChargeCost;
	local X2AbilityCooldown Cooldown;
	local X2AbilityCost_ActionPoints AbilityCost;
	local X2Effect_ReworkedBattlelord BattlelordEffect;
	local X2Effect_CoveringFire CoveringEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityTargetEffects.Length = 0;
	AbilityTemplate.AbilityCharges = none;
	AbilityTemplate.AbilityCosts.Length = 0;

	AbilityCost = new class'X2AbilityCost_ActionPoints';
	AbilityCost.iNumPoints = 1;
	AbilityCost.bConsumeAllPoints = true;
	AbilityCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	AbilityTemplate.AbilityCosts.AddItem(AbilityCost);

	if(!default.bHAS_BATTLELORD_ABILITYCHARGE)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.iBATTLELORD_COOLDOWN;
		AbilityTemplate.AbilityCooldown = Cooldown;
	}
	else
	{
		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		AbilityTemplate.AbilityCosts.AddItem(ChargeCost);

		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.iBATTLELORD_CHARGE;
		AbilityTemplate.AbilityCharges = Charges;
	}

	BattlelordEffect = new class'X2Effect_ReworkedBattlelord';
	BattlelordEffect.BuildPersistentEffect(1, false, , , eGameRule_PlayerTurnBegin);
	BattlelordEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	AbilityTemplate.AddTargetEffect(BattlelordEffect);
	
	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringEffect.AbilityToActivate = 'NewBattlelordEffect';
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.bSelfTargeting = true;
	CoveringEffect.EffectName = 'BattlelordCooldownReduceEffect';
	AbilityTemplate.AddTargetEffect(CoveringEffect);

	AbilityTemplate.AdditionalAbilities.AddItem('NewBattlelordEffect');
}

//Parkour will give you non-move action point once per turn after you move.
static function ReworkedParkour(X2AbilityTemplate Template)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTrigger_EventListener ActivationTrigger;
	local X2Effect_GrantActionPoints AddActionPointsEffect;
	local X2Condition_UnitValue UnitCondition;
	local X2Effect_SetUnitValue UnitValueEffect;

	AbilityTemplate = Template;
	AbilityTemplate.AbilityShooterEffects.Length = 0;
	AbilityTemplate.AbilityTriggers.Length = 0;

	ActivationTrigger = new class'X2AbilityTrigger_EventListener';
	ActivationTrigger.ListenerData.EventID = 'ObjectMoved';
	ActivationTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	ActivationTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	ActivationTrigger.ListenerData.Filter = eFilter_Unit;
	AbilityTemplate.AbilityTriggers.AddItem(ActivationTrigger);

	UnitCondition = new class'X2Condition_UnitValue';
	UnitCondition.AddCheckValue(default.ParkourEffectName, 0);
	AbilityTemplate.AbilityShooterConditions.AddItem(UnitCondition);
	
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = default.ParkourEffectName;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	//UnitValueEffect.TargetConditions.AddItem(UnitCondition);
	AbilityTemplate.AddShooterEffect(UnitValueEffect);
	
	AddActionPointsEffect = new class'X2Effect_GrantActionPoints';
	AddActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	AddActionPointsEffect.NumActionPoints = default.iPARKOUR_ACTION_POINT;
	AbilityTemplate.AddShooterEffect(AddActionPointsEffect);
}

defaultproperties
{
	ConcealedOverwatchTurn="ConcealedOverwatch"
	ParkourEffectName = "ParkourTriggered"
}
