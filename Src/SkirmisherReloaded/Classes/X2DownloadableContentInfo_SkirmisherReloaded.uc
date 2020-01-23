//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SkirmisherReloaded.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SkirmisherReloaded extends X2DownloadableContentInfo config(SkirmisherReloaded);

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
	UpdateReturnFire();
	UpdateReflex();
	UpdateWrath();
	UpdateTotalCombat();
	UpdateZeroIn();
	UpdateWhiplash();
	UpdateInterrupt();
	UpdateManualOverride();
	UpdateBattlelord();
	UpdateParkour();
}

static function UpdateReturnFire()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('SkirmisherReturnFire');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedSkirmisherReturnFire(Template);
}

static function UpdateReflex()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('SkirmisherReflex');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedReflex(Template);
}

static function UpdateWrath()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('SkirmisherVengeance');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedWrath(Template);
}

//Total Combat is PurePassive(placeholder), and Its action point modifying effect can find in StandardShot Template from X2Ability_WeaponCommon
static function UpdateTotalCombat()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('StandardShot');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedTotalCombatStandardFire(Template);

	Template = AbilityMgr.FindAbilityTemplate('ThrowGrenade');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedTotalCombatThrowGrenade(Template);

	Template = AbilityMgr.FindAbilityTemplate('FinalizeSKULLJACK');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedTotalCombatSkulljack(Template);

	Template = AbilityMgr.FindAbilityTemplate('FinalizeSKULLMINE');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedTotalCombatSkullMine(Template);

	Template = AbilityMgr.FindAbilityTemplate('MimicBeaconThrow');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedTotalCombatMimicBeacon(Template);
}

static function UpdateZeroIn()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('ZeroIn');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedZeroIn(Template);
}

static function UpdateWhiplash()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('Whiplash');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedWhiplash(Template);
}

static function UpdateInterrupt()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('SkirmisherInterrupt');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedInterrupt(Template);

	Template = AbilityMgr.FindAbilityTemplate('SkirmisherInterruptInput');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedInterruptInput(Template);
}

static function UpdateManualOverride()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('ManualOverride');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedManualOverride(Template);
}

static function UpdateBattlelord()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('Battlelord');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedBattlelord(Template);
}

static function UpdateParkour()
{
	local X2AbilityTemplate Template;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Template = AbilityMgr.FindAbilityTemplate('Parkour');
	class'X2Ability_ReworkedSkirmisherPerkPack'.static.ReworkedParkour(Template);
}
