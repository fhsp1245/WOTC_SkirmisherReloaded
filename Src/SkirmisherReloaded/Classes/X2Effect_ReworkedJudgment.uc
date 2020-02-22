class X2Effect_ReworkedJudgment extends X2Effect_Persistent;
/*
var name AbilityToActivate;
var name GrantActionPoint;
var bool bUseMultiTargets;
var bool bSelfTargeting;
*/


/*
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', ReworkedJudgmentListener, ELD_OnStateSubmitted, , , , EffectObj);
}
*/
/*
static function EventListenerReturn ReworkedJudgmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, DeadUnit;
	//local UnitValue JudgmentKillCount;

	local XComGameState_Effect EffectState;
	local EffectAppliedData ApplyEffectParameters;

	EffectState = XComGameState_Effect(CallbackData);
	ApplyEffectParameters = EffectState.ApplyEffectParameters;
	
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			DeadUnit = XComGameState_Unit(EventData);

			if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
			{
				if (SourceUnit.IsEnemyUnit(DeadUnit))
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
					SourceUnit.ReserveActionPoints.AddItem('Judgment');
					`XEVENTMGR.TriggerEvent('JudgmentTriggered', SourceUnit, SourceUnit, NewGameState);
					SubmitNewGameState(NewGameState);
				}
			}
		}
	}
	

	return ELR_NoInterrupt;
}
*/
/*
static function EventListenerReturn ReworkedJudgmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, DeadUnit;
	//local UnitValue JudgmentKillCount;

	local XComGameState_Effect EffectState;
	local EffectAppliedData ApplyEffectParameters;

	EffectState = XComGameState_Effect(CallbackData);
	ApplyEffectParameters = EffectState.ApplyEffectParameters;

	if (!EffectState.bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				DeadUnit = XComGameState_Unit(EventData);

				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
				{
					if (SourceUnit.IsEnemyUnit(DeadUnit))
					{
						//SourceUnit.GetUnitValue('Judgment', JudgmentKillCount);
						//if (JudgmentKillCount.fValue == 0)
						//{
							NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
							SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
							SourceUnit.ActionPoints.AddItem('Judgment');
							SubmitNewGameState(NewGameState);
						//}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
*/
/*
//Copied from XComGameState_Effect.uc, CoveringFireCheck func.
function EventListenerReturn ReworkedJudgmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit JudgmentUnit, DeadUnit;
	local XComGameStateHistory History;
	//local X2Effect_CoveringFire CoveringFireEffect;
	local X2Effect_ReworkedJudgment JudgmentEffect;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	//local XComGameState_Effect NewEffectState;
	//local int RandRoll;

	local XComGameState_Effect EffectState;
	local EffectAppliedData ApplyEffectParameters;

	EffectState = XComGameState_Effect(CallbackData);
	ApplyEffectParameters = EffectState.ApplyEffectParameters;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		History = `XCOMHISTORY;

		JudgmentEffect = X2Effect_ReworkedJudgment(EffectState.GetX2Effect());

		JudgmentUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		DeadUnit = XComGameState_Unit(EventData);

		if(!JudgmentUnit.IsEnemyUnit(DeadUnit))
			return ELR_NoInterrupt;
	
		AbilityRef = JudgmentUnit.FindAbility(AbilityToActivate);
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
		if (AbilityState != none)
		{
			if (GrantActionPoint != '')
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
				//NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(Class, ObjectID));
				//NewEffectState.GrantsThisTurn++;

				JudgmentUnit = XComGameState_Unit(NewGameState.ModifyStateObject(JudgmentUnit.Class, JudgmentUnit.ObjectID));
				JudgmentUnit.ReserveActionPoints.AddItem(GrantActionPoint);
				
				if (AbilityState.CanActivateAbilityForObserverEvent(DeadUnit, JudgmentUnit) != 'AA_Success')
				{
					History.CleanupPendingGameState(NewGameState);
				}
				else
				{
				
					`TACTICALRULES.SubmitGameState(NewGameState);

					if (JudgmentEffect.bUseMultiTargets)
					{
						AbilityState.AbilityTriggerAgainstSingleTarget(JudgmentUnit.GetReference(), true);
					}
					else
					{
						AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, DeadUnit.ObjectID);
						if( AbilityContext.Validate() )
						{
							`TACTICALRULES.SubmitGameStateContext(AbilityContext);
						}
					}
				}
				
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
			else if (JudgmentEffect.bSelfTargeting && AbilityState.CanActivateAbilityForObserverEvent(JudgmentUnit) == 'AA_Success')
			{
				AbilityState.AbilityTriggerAgainstSingleTarget(JudgmentUnit.GetReference(), JudgmentEffect.bUseMultiTargets);
			}
			else if (AbilityState.CanActivateAbilityForObserverEvent(DeadUnit) == 'AA_Success')
			{
				if (JudgmentEffect.bUseMultiTargets)
				{
					AbilityState.AbilityTriggerAgainstSingleTarget(JudgmentUnit.GetReference(), true);
				}
				else
				{
					AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, DeadUnit.ObjectID);
					if( AbilityContext.Validate() )
					{
						`TACTICALRULES.SubmitGameStateContext(AbilityContext);
					}
				}
			}
			
		}
	}
	return ELR_NoInterrupt;
}


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
*/
/*
DefaultProperties
{
	bSelfTargeting = false
}
*/