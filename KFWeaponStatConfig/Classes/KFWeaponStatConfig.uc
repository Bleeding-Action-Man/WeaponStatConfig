//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int Single9mmMag, Single9mmDmgMax,
                  MK23Mag, MK23DmgMax, MK23Cost,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost,
                  SingleDeagleMag, SingleDeagleDmgMax, SingleDeagleCost,
                  WinchesterMag, WinchesterDmgMax, WinchesterCost,
                  CrossbowMag, CrossbowDmgMax, CrossbowCost,
                  SPSniperRifleMag, SPSniperRifleDmgMax, SPSniperRifleCost,
                  M14EBRMag, M14EBRDmgMax, M14EBRCost;
var() config bool bEnableSharp;

replication
{
	unreliable if (Role == ROLE_Authority)
		              Single9mmMag, Single9mmDmgMax,
                  MK23Mag, MK23DmgMax, MK23Cost,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost,
                  SingleDeagleMag, SingleDeagleDmgMax, SingleDeagleCost,
                  WinchesterMag, WinchesterDmgMax, WinchesterCost,
                  CrossbowMag, CrossbowDmgMax, CrossbowCost,
                  SPSniperRifleMag, SPSniperRifleDmgMax, SPSniperRifleCost,
                  M14EBRMag, M14EBRDmgMax, M14EBRCost;
}

simulated function PostNetReceive()
{
  super.PostNetReceive();
  TimeStampLog("-----|| KFWeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  SetTimer(1, false);
}

simulated function Timer()
{
  if (bEnableSharp){
    ApplySharpShooter();
  }
}

simulated function ApplySharpShooter(){
    MutLog("Changing SharpShooter Weapons Stats");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    MutLog("-----|| Single9mm Mag: " $Single9mmMag$ " || Single9mm MaxDmg: " $Single9mmDmgMax$ " ||-----");
    class'KFMod.MK23Pistol'.default.MagCapacity=MK23Mag;
    class'KFMod.MK23Fire'.default.DamageMax=MK23DmgMax;
    class'KFMod.MK23Pickup'.default.cost=MK23Cost;
    MutLog("-----|| MK23 Mag: " $MK23Mag$ " || MK23 MaxDmg: " $MK23DmgMax$ " || MK23 Cost: " $MK23Cost$ " ||-----");
    class'KFMod.Magnum44Pistol'.default.MagCapacity=Single44MagnumMag;
    class'KFMod.Magnum44Fire'.default.DamageMax=Single44MagnumDmgMax;
    class'KFMod.Magnum44Pickup'.default.cost=Single44MagnumCost;
    MutLog("-----|| 44 Magnum Mag: " $Single44MagnumMag$ " || 44 Magnum MaxDmg: " $Single44MagnumDmgMax$ " || 44 Magnum Cost: " $Single44MagnumCost$ " ||-----");
    class'KFMod.Deagle'.default.MagCapacity=SingleDeagleMag;
    class'KFMod.DeagleFire'.default.DamageMax=SingleDeagleDmgMax;
    class'KFMod.DeaglePickup'.default.cost=SingleDeagleCost;
    MutLog("-----|| HandCannon Mag: " $SingleDeagleMag$ " || HandCannon MaxDmg: " $SingleDeagleDmgMax$ " || HandCannon Cost: " $SingleDeagleCost$ " ||-----");
    class'KFMod.Winchester'.default.MagCapacity=WinchesterMag;
    class'KFMod.WinchesterFire'.default.DamageMax=WinchesterDmgMax;
    class'KFMod.WinchesterPickup'.default.cost=WinchesterCost;
    MutLog("-----|| Winchester Mag: " $WinchesterMag$ " || Winchester MaxDmg: " $WinchesterDmgMax$ " || Winchester Cost: " $WinchesterCost$ " ||-----");
    class'KFMod.Crossbow'.default.MagCapacity=CrossbowMag;
    class'KFMod.CrossbowFire'.default.DamageMax=CrossbowDmgMax;
    class'KFMod.CrossbowPickup'.default.cost=CrossbowCost;
    MutLog("-----|| Crossbow Mag: " $CrossbowMag$ " || Crossbow MaxDmg: " $CrossbowDmgMax$ " || Crossbow Cost: " $CrossbowCost$ " ||-----");
    class'KFMod.SPSniperRifle'.default.MagCapacity=SPSniperRifleMag;
    class'KFMod.SPSniperFire'.default.DamageMax=SPSniperRifleDmgMax;
    class'KFMod.SPSniperPickup'.default.cost=SPSniperRifleCost;
    MutLog("-----|| SPSniperRifle Mag: " $SPSniperRifleMag$ " || SPSniperRifle MaxDmg: " $SPSniperRifleDmgMax$ " || SPSniperRifle Cost: " $SPSniperRifleCost$ " ||-----");
    class'KFMod.M14EBRBattleRifle'.default.MagCapacity=M14EBRMag;
    class'KFMod.M14EBRFire'.default.DamageMax=M14EBRDmgMax;
    class'KFMod.M14EBRPickup'.default.cost=M14EBRCost;
    MutLog("-----|| M14EBR Mag: " $M14EBRMag$ " || M14EBR MaxDmg: " $M14EBRDmgMax$ " || M14EBR Cost: " $M14EBRCost$ " ||-----");
    MutLog("SS Weapons Stat Changed");
}

simulated function GetServerVars(){
    // SS Vars
    default.bEnableSharp = bEnableSharp;
    default.Single9mmMag = Single9mmMag;
    default.Single9mmDmgMax = Single9mmDmgMax;
    default.MK23Mag = MK23Mag;
    default.MK23DmgMax = MK23DmgMax;
    default.MK23Cost = MK23Cost;
    default.Single44MagnumMag = Single44MagnumMag;
    default.Single44MagnumDmgMax = Single44MagnumDmgMax;
    default.Single44MagnumCost = Single44MagnumCost;
    default.SingleDeagleMag = SingleDeagleMag;
    default.SingleDeagleDmgMax = SingleDeagleDmgMax;
    default.SingleDeagleCost = SingleDeagleCost;
    default.WinchesterMag = WinchesterMag;
    default.WinchesterDmgMax = WinchesterDmgMax;
    default.WinchesterCost = WinchesterCost;
    default.CrossbowMag = CrossbowMag;
    default.CrossbowDmgMax = CrossbowDmgMax;
    default.CrossbowCost = CrossbowCost;
    default.SPSniperRifleMag = SPSniperRifleMag;
    default.SPSniperRifleDmgMax = SPSniperRifleDmgMax;
    default.SPSniperRifleCost = SPSniperRifleCost;
    default.M14EBRMag = M14EBRMag;
    default.M14EBRDmgMax = M14EBRDmgMax;
    default.M14EBRCost = M14EBRCost;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "bEnableSharp", "Enable Changes for SharpShooter Weapons", 0, 0, "check");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "0. Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "0. Single9mm Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Mag", "0. MK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23DmgMax", "0. MK23 Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Cost", "0. MK23 Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumMag", "0. 44 Magnum Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumDmgMax", "0. 44 Magnum Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumCost", "0. 44 Magnum Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleMag", "0. HandCannon Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleDmgMax", "0. HandCannon Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleCost", "0. HandCannon Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterMag", "0. Winchester Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterDmgMax", "0. Winchester Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterCost", "0. Winchester Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowMag", "0. Crossbow Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowDmgMax", "0. Crossbow Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowCost", "0. Crossbow Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleMag", "0. SPSniperRifle Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleDmgMax", "0. SPSniperRifle Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleCost", "0. SPSniperRifle Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRMag", "0. M14EBR Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRDmgMax", "0. M14EBR Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRCost", "0. M14EBR Cost", 0, 0, "text");
}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
    case "bEnableSharp":
      return "Apply Stat Changes for SharpShooter weapons";
		case "Single9mmMag":
			return "Mag Size | Default is 15";
    case "Single9mmDmgMax":
			return "Max Damage | Default is 35";
    case "MK23Mag":
			return "Mag Size | Default is 12";
    case "MK23DmgMax":
			return "Max Damage | Default is 82";
    case "MK23Cost":
			return "Cost | Default is 500";
    case "Single44MagnumMag":
			return "Mag Size | Default is 6";
    case "Single44MagnumDmgMax":
			return "Max Damage | Default is 105";
    case "Single44MagnumCost":
			return "Cost | Default is 450";
    case "SingleDeagleMag":
			return "Mag Size | Default is 8";
    case "SingleDeagleDmgMax":
			return "Max Damage | Default is 115";
    case "SingleDeagleCost":
			return "Cost | Default is 500";
    case "WinchesterMag":
			return "Mag Size | Default is 10";
    case "WinchesterDmgMax":
			return "Max Damage | Default is 140";
    case "WinchesterCost":
			return "Cost | Default is 200";
    case "CrossbowMag":
			return "Mag Size | Default is 1";
    case "CrossbowDmgMax":
			return "Max Damage | Default is 300";
    case "CrossbowCost":
			return "Cost | Default is 800";
    case "SPSniperRifleMag":
			return "Mag Size | Default is 10";
    case "SPSniperRifleDmgMax":
			return "Max Damage | Default is 180";
    case "SPSniperRifleCost":
			return "Cost | Default is 1500";
    case "M14EBRMag":
			return "Mag Size | Default is 20";
    case "M14EBRDmgMax":
			return "Max Damage | Default is 80";
    case "M14EBRCost":
			return "Cost | Default is 2500";
    default:
			return Super.GetDescriptionText(SettingName);
	}
}

simulated function TimeStampLog(coerce string s)
{
    log("["$Level.TimeSeconds$"s]" @ s, 'WeaponStatsConfig');
}

simulated function MutLog(string s)
{
    log(s, 'WeaponStatsConfig');
}

defaultproperties
{
    // Mandatory Vars
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=true
    bNetNotify=true

    // Mut Vars
    GroupName="KF-WeaponStatConfig"
    FriendlyName="Weapon Stat Config - v1.0"
    Description="Change Weapon MaxDmg, Magazine Size & Cost (More options coming soon), currently supports Standard KF weapons only & SharpShooter only (More Perks Coming Soon); - By Vel-San"

    // Weapon Stats
    // SS
    bEnableSharp=True
    Single9mmMag=15
    Single9mmDmgMax=35
    MK23Mag=12
    MK23DmgMax=82
    MK23Cost=500
    Single44MagnumMag=6
    Single44MagnumDmgMax=105
    Single44MagnumCost=450
    SingleDeagleMag=500
    SingleDeagleDmgMax=115
    SingleDeagleCost=8
    WinchesterMag=10
    WinchesterDmgMax=140
    WinchesterCost=200
    CrossbowMag=1
    CrossbowDmgMax=300
    CrossbowCost=800
    SPSniperRifleMag=10
    SPSniperRifleDmgMax=180
    SPSniperRifleCost=1500
    M14EBRMag=20
    M14EBRDmgMax=80
    M14EBRCost=2500
}
