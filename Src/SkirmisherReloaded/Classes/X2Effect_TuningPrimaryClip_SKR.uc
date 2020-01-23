class X2Effect_TuningPrimaryClip_SKR extends X2Effect_Persistent;

var int iTUNING_BONUSCLIP_PRIMARY;
var int iTUNING_MINCLIPSIZE;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Unit EffectTargetUnit;
	local XComGameState_Item EffectTargetItem;
	local X2WeaponTemplate WeaponTemplate;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectTargetItem = EffectTargetUnit.GetPrimaryWeapon();
	WeaponTemplate = X2WeaponTemplate(EffectTargetItem.GetMyTemplate());

	if (WeaponTemplate.iClipSize >= iTUNING_MINCLIPSIZE)
	{
		EventMgr.RegisterForEvent(EffectObj, 'OverrideClipsize', OnOverrideClipsize, ELD_Immediate,,,, EffectObj);
	}
}

// EventListenerReturn function to modify weapon ammo count each time GetClipSize() is called (reloads, etc.)
static function EventListenerReturn OnOverrideClipsize(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;
	local XComGameState_Item ExpectedItem;
	local XComGameState_Effect EffectState;
	local X2Effect_TuningPrimaryClip_SKR Effect;

	EffectState = XComGameState_Effect(CallbackData);
	Effect = X2Effect_TuningPrimaryClip_SKR(EffectState.GetX2Effect());
	ExpectedItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));

	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
		return ELR_NoInterrupt;

	if (OverrideTuple.Id != 'OverrideClipSize')
		return ELR_NoInterrupt;

	if (XComGameState_Item(EventSource).ObjectID != ExpectedItem.ObjectID)
		return ELR_NoInterrupt;

	OverrideTuple.Data[0].i += Effect.iTUNING_BONUSCLIP_PRIMARY;

	return ELR_NoInterrupt;
}

defaultproperties
{
	DuplicateResponse = eDupe_Allow
}
