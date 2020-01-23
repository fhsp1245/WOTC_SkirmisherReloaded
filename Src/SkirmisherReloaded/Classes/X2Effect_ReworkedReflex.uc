class X2Effect_ReworkedReflex extends X2Effect_Persistent;

var privatewrite name ReflexUnitValue;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', ReworkedReflexListener, ELD_OnStateSubmitted, , , , EffectObj);
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue ReflexValue;

	if (UnitState.GetUnitValue(default.ReflexUnitValue, ReflexValue))
	{
		if (ReflexValue.fValue > 0)
		{
			if (UnitState.IsAbleToAct())
				ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

			UnitState.ClearUnitValue(default.ReflexUnitValue);
		}
	}
}

//Completely copied SkirmisherReflexListener from XComGameState_Effect.uc but deleted lines that counts how many time Reflex triggered
static function EventListenerReturn ReworkedReflexListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local UnitValue ReflexValue;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Ability AbilityState;

	local XComGameState_Effect EffectState;
	local EffectAppliedData ApplyEffectParameters;

	AbilityState = XComGameState_Ability(EventData);
	EffectState = XComGameState_Effect(CallbackData);
	ApplyEffectParameters = EffectState.ApplyEffectParameters;

	// Set to only Offensive abilities to prevent Reflex from being kicked off on Chosen Tracking Shot Marker.
	if (AbilityState.IsAbilityInputTriggered() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
		{
			if (AbilityContext.InputContext.PrimaryTarget.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
			{
				SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
				if (SourceUnit == none)
					return ELR_NoInterrupt;

				TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if (TargetUnit == none)
					TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				
				`assert(TargetUnit != none);
				if (TargetUnit.IsFriendlyUnit(SourceUnit))
					return ELR_NoInterrupt;

				//	if it's the target unit's current turn, give them an action immediately
				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == TargetUnit.ControllingPlayer.ObjectID)
				{
					if (TargetUnit.IsAbleToAct())
					{
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Skirmisher Reflex Immediate Action");
						TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
						TargetUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
					}
				}
				//	if it's not their turn, increment the counter for next turn
				else if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != TargetUnit.ControllingPlayer.ObjectID)
				{
					//TargetUnit.GetUnitValue(class'X2Effect_SkirmisherReflex'.default.ReflexUnitValue, ReflexValue);
					TargetUnit.GetUnitValue(class'X2Effect_ReworkedReflex'.default.ReflexUnitValue, ReflexValue);
					if (ReflexValue.fValue == 0)
					{
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Skirmisher Reflex For Next Turn Increment");
						TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
						TargetUnit.SetUnitFloatValue(class'X2Effect_SkirmisherReflex'.default.ReflexUnitValue, 1, eCleanup_BeginTactical);
						//TargetUnit.SetUnitFloatValue(class'X2Effect_ReworkedReflex'.default.ReflexUnitValue, 1, eCleanup_BeginTurn);
					}
				}
				if (NewGameState != none)
				{
					NewGameState.ModifyStateObject(class'XComGameState_Ability', ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
					XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

DefaultProperties
{
	ReflexUnitValue = "SkirmisherReflex"
	EffectName = "SkirmisherReflex"
	DuplicateResponse = eDupe_Ignore
}