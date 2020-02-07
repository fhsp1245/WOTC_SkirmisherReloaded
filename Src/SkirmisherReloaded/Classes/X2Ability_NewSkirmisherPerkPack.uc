class X2Ability_NewSkirmisherPerkPack extends X2Ability config(SkirmisherReloaded);

var config int iWRATH_DAMAGE_BONUS;
var config int iFULLTHROTTLE_COOLDOWN;
var config int iBULLETTIME_GRAZEDMG_MODIFIER;
var config int iBULLETTIME_TOCRITHIT_MODIFIER;
var config int iOPTIMIZATION_AIM_BONUS;
var config int iOPTIMIZATION_CRIT_BONUS;
var config int iTUNING_BONUSDMG;
var config int iTUNING_BONUSCLIP_PRIMARY;
var config int iTUNING_MINCLIPSIZE;
var config int iTUNING_BONUSCRIT_SECONDARY;
var config int iSHOTGROUPING_MISSDMG;
var config int iDEEPPOCKET_BONUS_ITEM;

var name ManualOverrideEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(WrathDamageBuff());
	Templates.AddItem(PostAbilityMeleeForWrath());
	Templates.AddItem(NewFullThrottle());
	Templates.AddItem(NewBattlelordEffect());
	Templates.AddItem(SKR_BulletTime());
	Templates.AddItem(SKR_Optimization());
	Templates.AddItem(SKR_Tuning());
	Templates.AddItem(SKR_ShotGrouping());
	Templates.AddItem(SKR_DeepPockets());
	Templates.AddItem(SKR_TotalCombat());

	return Templates;
}
//New PostAbilityMelee, in order to seperate Justice and Wrath has
static function X2AbilityTemplate PostAbilityMeleeForWrath()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener AbilityTrigger;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('PostAbilityMeleeForWrath');
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CinescriptCameraType = "Skirmisher_Melee";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityTriggers.Length = 0;

	AbilityTrigger = new class'X2AbilityTrigger_EventListener';
	AbilityTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	AbilityTrigger.ListenerData.EventID = 'ActivateSkirmisherWrath';
	AbilityTrigger.ListenerData.Filter = eFilter_Unit;
	AbilityTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(AbilityTrigger);

	Template.MergeVisualizationFn = DesiredVisualizationBlock_MergeVisualization;

	X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc).bGuaranteedHit = true;
	Template.AbilityCosts.Length = 0;

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
	Template.bUniqueSource = true;	

	return Template;
}

static function bool PostAbilityMeleeDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Ability MeleeAbility;
	local XComGameState_Unit OwnerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	OwnerState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	MeleeAbility = XComGameState_Ability(History.GetGameStateForObjectID(OwnerState.FindAbility('PostAbilityMeleeForWrath').ObjectID));

	MeleeAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	return true;
}

//Invisible template for Wrath's damage effect
static function X2AbilityTemplate WrathDamageBuff()
{
	local X2AbilityTemplate Template;
	local X2Effect_WrathDamage DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WrathDamageBuff');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_WrathDamage';
	DamageEffect.iWRATH_DAMAGE_BONUS = default.iWRATH_DAMAGE_BONUS;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, ,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

//Full Throttle is fully reworked: Now it's active ability that give one move-only action point and can use even no action point left. 
static function X2AbilityTemplate NewFullthrottle()
{
	local X2AbilityTemplate Template;
	local X2AbilityCooldown Cooldown;
	local X2AbilityCost_ActionPoints AbilityCost;
	local X2Effect_GrantActionPoints ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FullThrottle');
	Template.IconImage = "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_newfullthrottle";
	Template.ActivationSpeech = 'FullThrottle';

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Movement;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.iFULLTHROTTLE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AbilityCost = new class'X2AbilityCost_ActionPoints';
	AbilityCost.bFreeCost = true;
	AbilityCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(AbilityCost);
	
	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.ActivationSpeech = 'FullThrottle';

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Whenever you are attacked while Battlelord, reduce all cooldowns by 1.
static function X2AbilityTemplate NewBattlelordEffect()
{
	local X2AbilityTemplate	Template;
	local X2Effect_BattlelordReduceCooldown BattlelordEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NewBattlelordEffect');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Battlelord";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye; 
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	BattlelordEffect = new class'X2Effect_BattlelordReduceCooldown';
	BattlelordEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(BattlelordEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// +50 critical defense and reduce grazing damage by 3 
static function X2AbilityTemplate SKR_BulletTime()
{
	local X2AbilityTemplate Template;
	local X2Effect_BulletTime_SKR BulletTimeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SKR_BulletTime');
	Template.IconImage = "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_bullettime";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	BulletTimeEffect = new class'X2Effect_BulletTime_SKR';
	BulletTimeEffect.iBULLETTIME_GRAZEDMG_MODIFIER = default.iBULLETTIME_GRAZEDMG_MODIFIER;
	BulletTimeEffect.iBULLETTIME_TOCRITHIT_MODIFIER = default.iBULLETTIME_TOCRITHIT_MODIFIER;
	BulletTimeEffect.BuildPersistentEffect(1, true, false, false);
	BulletTimeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(BulletTimeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Reaction attacks can critical hit, and get Zero In bonus in enemy turn.
static function X2AbilityTemplate SKR_Optimization()
{
	local X2AbilityTemplate Template;
	local X2Effect_Optimization_SKR OptimizationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SKR_Optimization');
	Template.IconImage = "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_optimization";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	OptimizationEffect = new class'X2Effect_Optimization_SKR';
	OptimizationEffect.bAllowCrit = true;
	OptimizationEffect.iOPTIMIZATION_AIM_BONUS = class'X2Ability_ReworkedSkirmisherPerkPack'.default.iZEROIN_AIM_BONUS;
	OptimizationEffect.iOPTIMIZATION_CRIT_BONUS = class'X2Ability_ReworkedSkirmisherPerkPack'.default.iZEROIN_CRIT_BONUS;
	OptimizationEffect.BuildPersistentEffect(1, true, false, false);
	OptimizationEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(OptimizationEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Primary deals +1 damage and increase clipsize by 4. Secondary deals +1 damage and +20 critical chance.
static function X2AbilityTemplate SKR_Tuning()
{
	local X2AbilityTemplate Template;
	local X2Effect_TuningDamage_SKR DamageEffect;
	local X2Effect_TuningPrimaryClip_SKR ClipsizeEffect;
	local X2Effect_ToHitModifier CritEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SKR_Tuning');
	Template.IconImage = "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_tuning";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_TuningDamage_SKR';
	DamageEffect.iTUNING_BONUSDMG = default.iTUNING_BONUSDMG;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, ,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	CritEffect = new class'X2Effect_ToHitModifier';
	CritEffect.AddEffectHitModifier(eHit_Crit, default.iTUNING_BONUSCRIT_SECONDARY, Template.LocFriendlyName, , true, false, true, true);
	CritEffect.BuildPersistentEffect(1, true, false, false);
	CritEffect.EffectName = 'Tuning Critical';
	Template.AddTargetEffect(CritEffect);
	
	//HighlanderFeature
	ClipsizeEffect = new class'X2Effect_TuningPrimaryClip_SKR';
	ClipsizeEffect.iTUNING_BONUSCLIP_PRIMARY = default.iTUNING_BONUSCLIP_PRIMARY;
	ClipsizeEffect.iTUNING_MINCLIPSIZE = 1;
	ClipsizeEffect.EffectName = 'Tuning_BonusClip_Effect';
	ClipSizeEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(ClipsizeEffect);
	
	Template.AdditionalAbilities.AddItem('SKR_TuningPrimary');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//Missed shot deals 2 damage.
static function X2AbilityTemplate SKR_ShotGrouping()
{
	local X2AbilityTemplate Template;
	local X2Effect_ShotGrouping_SKR MissDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SKR_ShotGrouping');
	Template.IconImage = "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_shotgrouping";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	MissDamageEffect = new class'X2Effect_shotGrouping_SKR';
	MissDamageEffect.iSHOTGROUPING_MISSDMG = default.iSHOTGROUPING_MISSDMG;
	MissDamageEffect.BuildPersistentEffect(1, true, false, false);
	MissDamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, ,Template.AbilitySourceName);
	Template.AddTargetEffect(MissDamageEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Items have +1 additional charge.
static function X2AbilityTemplate SKR_DeepPockets()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('SKR_DeepPockets', "img:///SKR_NewSkirmisherPerkPack.UIPerk_SKR_deeppockets", false, 'eAbilitySource_Perk', true);
	Template.GetBonusWeaponAmmoFn = SKR_DeepPocketsBonusItem;

	return Template;
}

function int SKR_DeepPocketsBonusItem(XComGameState_Unit UnitState, XComGameState_Item ItemState)
{
	if (ItemState.InventorySlot == eInvSlot_Utility)
	{
		return default.iDEEPPOCKET_BONUS_ITEM;
	}

	return 0;
}

static function X2AbilityTemplate SKR_TotalCombat()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('SKR_TotalCombat', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_totalCombat");

	return Template;
}

DefaultProperties
{
	ManualOverrideEffectName = "ManualOverrideTriggered";
}