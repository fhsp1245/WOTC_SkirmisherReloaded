class X2Effect_ReworkedZeroIn extends X2Effect_Persistent;

var int iZEROIN_CRIT_BONUS;
var int iZEROIN_AIM_BONUS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', ReworkedZeroInListener, ELD_OnStateSubmitted, , `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID), , EffectObj);
}

//Zero In's aim and crit chance modifying
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local X2AbilityToHitCalc_StandardAim AimCalc;
	local ShotModifierInfo ShotMod;
	local UnitValue ZeroInValue;

	Attacker.GetUnitValue('ZeroInShots', ZeroInValue);
	AimCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (ZeroInValue.fValue > 0 && AimCalc.bReactionFire == false)
	{
		ShotMod.ModType = eHit_Crit;
		ShotMod.Reason = FriendlyName;
		ShotMod.Value = ZeroInValue.fValue * iZEROIN_CRIT_BONUS;
		ShotModifiers.AddItem(ShotMod);

		ShotMod.ModType = eHit_Success;
		ShotMod.Reason = FriendlyName;
		ShotMod.Value = ZeroInValue.fValue * iZEROIN_AIM_BONUS;
		ShotModifiers.AddItem(ShotMod);
	}
}

//Copied from XComeGameState_Effect. Zero In Listener: Whenever you use offensive ability , increase Zero In counter by 1
static function EventListenerReturn ReworkedZeroInListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local UnitValue UValue;

	local XComGameState_Effect EffectState;
	local EffectAppliedData ApplyEffectParameters;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	EffectState = XComGameState_Effect(CallbackData);
	ApplyEffectParameters = EffectState.ApplyEffectParameters;

	`assert(AbilityContext != none);
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	`assert(AbilityState != none);
	UnitState = XComGameState_Unit(EventSource);
	`assert(UnitState != none);
	
	if (AbilityState.IsAbilityInputTriggered())
	{
		if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("ZeroIn Increment");
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.GetUnitValue('ZeroInShots', UValue);
			UnitState.SetUnitFloatValue('ZeroInShots', UValue.fValue + 1);

			if (UnitState.ActionPoints.Length > 0)
			{
				//	show flyover for boost, but only if they have actions left to potentially use them
				NewGameState.ModifyStateObject(class'XComGameState_Ability', ApplyEffectParameters.AbilityStateObjectRef.ObjectID);		//	create this for the vis function
				XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;
			}
		}
		SubmitNewGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

//Copied from XComGameState_Effect
static function SubmitNewGameState(out XComGameState NewGameState)
{
	local X2TacticalGameRuleset TacticalRules;
	local XComGameStateHistory History;

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		TacticalRules = `TACTICALRULES;
		TacticalRules.SubmitGameState(NewGameState);
	}
	else
	{
		History = `XCOMHISTORY;
		History.CleanupPendingGameState(NewGameState);
	}
}

DefaultProperties
{
	EffectName="ZeroIn"
	DuplicateResponse=eDupe_Ignore
}