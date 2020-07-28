//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int  Single9mmMag, Single9mmDmgMax,
                  DualiesMag, DualiesDmgMax, DualiesCost, DualiesWeight,
                  MK23Mag, MK23DmgMax, MK23Cost, MK23Weight,
                  DualMK23Mag, DualMK23DmgMax, DualMK23Cost, DualMK23Weight,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost, Single44MagnumWeight,
                  Dual44MagnumMag, Dual44MagnumDmgMax, Dual44MagnumCost, Dual44MagnumWeight,
                  SingleDeagleMag, SingleDeagleDmgMax, SingleDeagleCost, SingleDeagleWeight,
                  DualDeagleMag, DualDeagleDmgMax, DualDeagleCost, DualDeagleWeight,
                  WinchesterMag, WinchesterDmgMax, WinchesterCost, WinchesterWeight,
                  CrossbowMag, CrossbowDmgMax, CrossbowCost, CrossbowWeight,
                  SPSniperRifleMag, SPSniperRifleDmgMax, SPSniperRifleCost, SPSniperRifleWeight,
                  M14EBRMag, M14EBRDmgMax, M14EBRCost, M14EBRWeight,
                  M99Mag, M99DmgMax, M99Cost, M99Weight;
var() config bool bEnableSharp;

replication
{
	unreliable if (Role == ROLE_Authority)
                  bEnableSharp,
		              Single9mmMag, Single9mmDmgMax,
                  DualiesMag, DualiesDmgMax, DualiesCost, DualiesWeight,
                  MK23Mag, MK23DmgMax, MK23Cost, MK23Weight,
                  DualMK23Mag, DualMK23DmgMax, DualMK23Cost, DualMK23Weight,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost, Single44MagnumWeight,
                  Dual44MagnumMag, Dual44MagnumDmgMax, Dual44MagnumCost, Dual44MagnumWeight,
                  SingleDeagleMag, SingleDeagleDmgMax, SingleDeagleCost, SingleDeagleWeight,
                  DualDeagleMag, DualDeagleDmgMax, DualDeagleCost, DualDeagleWeight,
                  WinchesterMag, WinchesterDmgMax, WinchesterCost, WinchesterWeight,
                  CrossbowMag, CrossbowDmgMax, CrossbowCost, CrossbowWeight,
                  SPSniperRifleMag, SPSniperRifleDmgMax, SPSniperRifleCost, SPSniperRifleWeight,
                  M14EBRMag, M14EBRDmgMax, M14EBRCost, M14EBRWeight,
                  M99Mag, M99DmgMax, M99Cost, M99Weight;
}

simulated function PostNetReceive()
{
  super.PostNetReceive();
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
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
    MutLog("-----|| Changing SharpShooter Weapons Stats ||-----");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    MutLog("-----|| Single9mm Mag: " $Single9mmMag$ " || Single9mm MaxDmg: " $Single9mmDmgMax$ " ||-----");
    class'KFMod.Dualies'.default.MagCapacity=DualiesMag;
    class'KFMod.Dualies'.default.Weight=DualiesWeight;
    class'KFMod.DualiesFire'.default.DamageMax=DualiesDmgMax;
    class'KFMod.DualiesPickup'.default.cost=DualiesCost;
    MutLog("-----|| Dualies Mag: " $DualiesMag$ " || Dualies MaxDmg: " $DualiesDmgMax$ " || Dualies Weight: " $DualiesWeight$ " ||-----");
    class'KFMod.MK23Pistol'.default.MagCapacity=MK23Mag;
    class'KFMod.MK23Pistol'.default.Weight=MK23Weight;
    class'KFMod.MK23Fire'.default.DamageMax=MK23DmgMax;
    class'KFMod.MK23Pickup'.default.cost=MK23Cost;
    MutLog("-----|| MK23 Mag: " $MK23Mag$ " || MK23 MaxDmg: " $MK23DmgMax$ " || MK23 Cost: " $MK23Cost$ " || MK23 Weight: " $MK23Weight$ " ||-----");
    class'KFMod.DualMK23Pistol'.default.MagCapacity=DualMK23Mag;
    class'KFMod.DualMK23Pistol'.default.Weight=DualMK23Weight;
    class'KFMod.DualMK23Fire'.default.DamageMax=DualMK23DmgMax;
    class'KFMod.DualMK23Pickup'.default.cost=DualMK23Cost;
    MutLog("-----|| DualMK23 Mag: " $DualMK23Mag$ " || DualMK23 MaxDmg: " $DualMK23DmgMax$ " || DualMK23 Cost: " $DualMK23Cost$ " || DualMK23 Weight: " $DualMK23Weight$ " ||-----");
    class'KFMod.Magnum44Pistol'.default.MagCapacity=Single44MagnumMag;
    class'KFMod.Magnum44Pistol'.default.Weight=Single44MagnumWeight;
    class'KFMod.Magnum44Fire'.default.DamageMax=Single44MagnumDmgMax;
    class'KFMod.Magnum44Pickup'.default.cost=Single44MagnumCost;
    MutLog("-----|| 44 Magnum Mag: " $Single44MagnumMag$ " || 44 Magnum MaxDmg: " $Single44MagnumDmgMax$ " || 44 Magnum Cost: " $Single44MagnumCost$ " || 44 Magnum Weight: " $Single44MagnumWeight$ " ||-----");
    class'KFMod.Dual44Magnum'.default.MagCapacity=Dual44MagnumMag;
    class'KFMod.Dual44Magnum'.default.Weight=Dual44MagnumWeight;
    class'KFMod.Dual44MagnumFire'.default.DamageMax=Dual44MagnumDmgMax;
    class'KFMod.Dual44MagnumPickup'.default.cost=Dual44MagnumCost;
    MutLog("-----|| 44 Dual Magnum Mag: " $Dual44MagnumMag$ " || 44 Dual Magnum MaxDmg: " $Dual44MagnumDmgMax$ " || 44 Dual Magnum Cost: " $Dual44MagnumCost$ " || 44 Dual Magnum Weight: " $Dual44MagnumWeight$ " ||-----");
    class'KFMod.Deagle'.default.MagCapacity=SingleDeagleMag;
    class'KFMod.Deagle'.default.Weight=SingleDeagleWeight;
    class'KFMod.DeagleFire'.default.DamageMax=SingleDeagleDmgMax;
    class'KFMod.DeaglePickup'.default.cost=SingleDeagleCost;
    MutLog("-----|| HandCannon Mag: " $SingleDeagleMag$ " || HandCannon MaxDmg: " $SingleDeagleDmgMax$ " || HandCannon Cost: " $SingleDeagleCost$ " || HandCannon Weight: " $SingleDeagleWeight$ " ||-----");
    class'KFMod.DualDeagle'.default.MagCapacity=DualDeagleMag;
    class'KFMod.DualDeagle'.default.Weight=DualDeagleWeight;
    class'KFMod.DualDeagleFire'.default.DamageMax=DualDeagleDmgMax;
    class'KFMod.DualDeaglePickup'.default.cost=DualDeagleCost;
    MutLog("-----|| Dual HandCannon Mag: " $DualDeagleMag$ " || Dual HandCannon MaxDmg: " $DualDeagleDmgMax$ " || Dual HandCannon Cost: " $DualDeagleCost$ " || Dual HandCannon Weight: " $DualDeagleWeight$ " ||-----");
    class'KFMod.Winchester'.default.MagCapacity=WinchesterMag;
    class'KFMod.Winchester'.default.Weight=WinchesterWeight;
    class'KFMod.WinchesterFire'.default.DamageMax=WinchesterDmgMax;
    class'KFMod.WinchesterPickup'.default.cost=WinchesterCost;
    MutLog("-----|| Winchester Mag: " $WinchesterMag$ " || Winchester MaxDmg: " $WinchesterDmgMax$ " || Winchester Cost: " $WinchesterCost$ " || Winchester Weight: " $WinchesterWeight$ " ||-----");
    class'KFMod.Crossbow'.default.MagCapacity=CrossbowMag;
    class'KFMod.Crossbow'.default.Weight=CrossbowWeight;
    class'KFMod.CrossbowArrow'.default.Damage=CrossbowDmgMax;
    class'KFMod.CrossbowPickup'.default.cost=CrossbowCost;
    MutLog("-----|| Crossbow Mag: " $CrossbowMag$ " || Crossbow MaxDmg: " $CrossbowDmgMax$ " || Crossbow Cost: " $CrossbowCost$ " || Crossbow Weight: " $CrossbowWeight$ " ||-----");
    class'KFMod.SPSniperRifle'.default.MagCapacity=SPSniperRifleMag;
    class'KFMod.SPSniperRifle'.default.Weight=SPSniperRifleWeight;
    class'KFMod.SPSniperFire'.default.DamageMax=SPSniperRifleDmgMax;
    class'KFMod.SPSniperPickup'.default.cost=SPSniperRifleCost;
    MutLog("-----|| SPSniperRifle Mag: " $SPSniperRifleMag$ " || SPSniperRifle MaxDmg: " $SPSniperRifleDmgMax$ " || SPSniperRifle Cost: " $SPSniperRifleCost$ " || SPSniperFire Weight: " $SPSniperRifleWeight$ " ||-----");
    class'KFMod.M14EBRBattleRifle'.default.MagCapacity=M14EBRMag;
    class'KFMod.M14EBRBattleRifle'.default.Weight=M14EBRWeight;
    class'KFMod.M14EBRFire'.default.DamageMax=M14EBRDmgMax;
    class'KFMod.M14EBRPickup'.default.cost=M14EBRCost;
    MutLog("-----|| M14EBR Mag: " $M14EBRMag$ " || M14EBR MaxDmg: " $M14EBRDmgMax$ " || M14EBR Cost: " $M14EBRCost$ " || M14BRR Weight: " $M14EBRWeight$ " ||-----");
    class'KFMod.M99SniperRifle'.default.MagCapacity=M99Mag;
    class'KFMod.M99SniperRifle'.default.Weight=M99Weight;
    class'KFMod.M99Bullet'.default.Damage=M99DmgMax;
    class'KFMod.M99Pickup'.default.cost=M99Cost;
    MutLog("-----|| M99 Mag: " $M99Mag$ " || M99 MaxDmg: " $M99DmgMax$ " || M99 Cost: " $M99Cost$ " || M99 Weight: " $M99Weight$ " ||-----");
    MutLog("-----|| SS Weapons Stat Changed ||-----");
}

simulated function GetServerVars(){
    // SS Vars
    default.bEnableSharp = bEnableSharp;
    default.Single9mmMag = Single9mmMag;
    default.Single9mmDmgMax = Single9mmDmgMax;
    default.DualiesMag = DualiesMag;
    default.DualiesDmgMax = DualiesDmgMax;
    default.DualiesCost = DualiesCost;
    default.DualiesWeight = DualiesWeight;
    default.MK23Mag = MK23Mag;
    default.MK23DmgMax = MK23DmgMax;
    default.MK23Cost = MK23Cost;
    default.MK23Weight = MK23Weight;
    default.DualMK23Mag = DualMK23Mag;
    default.DualMK23DmgMax = DualMK23DmgMax;
    default.DualMK23Cost = DualMK23Cost;
    default.DualMK23Weight = DualMK23Weight;
    default.Single44MagnumMag = Single44MagnumMag;
    default.Single44MagnumDmgMax = Single44MagnumDmgMax;
    default.Single44MagnumCost = Single44MagnumCost;
    default.Single44MagnumWeight = Single44MagnumWeight;
    default.Dual44MagnumMag = Dual44MagnumMag;
    default.Dual44MagnumDmgMax = Dual44MagnumDmgMax;
    default.Dual44MagnumCost = Dual44MagnumCost;
    default.Dual44MagnumWeight = Dual44MagnumWeight;
    default.SingleDeagleMag = SingleDeagleMag;
    default.SingleDeagleDmgMax = SingleDeagleDmgMax;
    default.SingleDeagleCost = SingleDeagleCost;
    default.SingleDeagleWeight = SingleDeagleWeight;
    default.DualDeagleMag = DualDeagleMag;
    default.DualDeagleDmgMax = DualDeagleDmgMax;
    default.DualDeagleCost = DualDeagleCost;
    default.DualDeagleWeight = DualDeagleWeight;
    default.WinchesterMag = WinchesterMag;
    default.WinchesterDmgMax = WinchesterDmgMax;
    default.WinchesterCost = WinchesterCost;
    Deagle.WinchesterWeight = WinchesterWeight;
    default.CrossbowMag = CrossbowMag;
    default.CrossbowDmgMax = CrossbowDmgMax;
    default.CrossbowCost = CrossbowCost;
    default.CrossbowWeight = CrossbowWeight;
    default.SPSniperRifleMag = SPSniperRifleMag;
    default.SPSniperRifleDmgMax = SPSniperRifleDmgMax;
    default.SPSniperRifleCost = SPSniperRifleCost;
    default.SPSniperRifleWeight = SPSniperRifleWeight;
    default.M14EBRMag = M14EBRMag;
    default.M14EBRDmgMax = M14EBRDmgMax;
    default.M14EBRCost = M14EBRCost;
    default.M14EBRWeight = M14EBRWeight;
    default.M99Mag = M99Mag;
    default.M99DmgMax = M99DmgMax;
    default.M99Cost = M99Cost;
    default.M99Weight = M99Weight;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "bEnableSharp", "Enable Changes for SharpShooter Weapons", 0, 0, "check");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "0. Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "0. Single9mm Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualiesMag", "0. Dualies Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualiesDmgMax", "0. Dualies Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualiesCost", "0. Dualies Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualiesWeight", "0. Dualies Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Mag", "0. MK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23DmgMax", "0. MK23 Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Cost", "0. MK23 Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Weight", "0. MK23 Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualMK23Mag", "0. DualMK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualMK23DmgMax", "0. DualMK23 Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualMK23Cost", "0. DualMK23 Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualMK23Weight", "0. DualMK23 Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumMag", "0. 44 Magnum Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumDmgMax", "0. 44 Magnum Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumCost", "0. 44 Magnum Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumWeight", "0. 44 Magnum Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Dual44MagnumMag", "0. 44 Dual Magnum Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Dual44MagnumDmgMax", "0. 44 Dual Magnum Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Dual44MagnumCost", "0. 44 Dual Magnum Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Dual44MagnumWeight", "0. 44 Dual Magnum Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleMag", "0. HandCannon Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleDmgMax", "0. HandCannon Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleCost", "0. HandCannon Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SingleDeagleWeight", "0. HandCannon Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualDeagleMag", "0. Dual HandCannon Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualDeagleDmgMax", "0. Dual HandCannon Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualDeagleCost", "0. Dual HandCannon Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "DualDeagleWeight", "0. Dual HandCannon Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterMag", "0. Winchester Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterDmgMax", "0. Winchester Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterCost", "0. Winchester Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "WinchesterWeight", "0. Winchester Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowMag", "0. Crossbow Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowDmgMax", "0. Crossbow Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowCost", "0. Crossbow Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "CrossbowWeight", "0. Crossbow Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleMag", "0. SPSniperRifle Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleDmgMax", "0. SPSniperRifle Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleCost", "0. SPSniperRifle Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "SPSniperRifleWeight", "0. SPSniperRifle Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRMag", "0. M14EBR Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRDmgMax", "0. M14EBR Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRCost", "0. M14EBR Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M14EBRWeight", "0. M14EBR Weight", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M99Mag", "0. M99 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M99DmgMax", "0. M99 Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M99Cost", "0. M99 Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "M99Weight", "0. M99 Weight", 0, 0, "text");
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
    case "DualiesMag":
			return "Mag Size | Default is 30";
    case "DualiesDmgMax":
			return "Max Damage | Default is 35";
    case "DualiesCost":
			return "Cost | Default is 150";
    case "DualiesWeight":
			return "Weight | Default is 4";
    case "MK23Mag":
			return "Mag Size | Default is 12";
    case "MK23DmgMax":
			return "Max Damage | Default is 82";
    case "MK23Cost":
			return "Cost | Default is 500";
    case "MK23Weight":
			return "Weight | Default is 2";
    case "DualMK23Mag":
			return "Mag Size | Default is 24";
    case "DualMK23DmgMax":
			return "Max Damage | Default is 82";
    case "DualMK23Cost":
			return "Cost | Default is 1000";
    case "DualMK23Weight":
			return "Cost | Default is 4";
    case "Single44MagnumMag":
			return "Mag Size | Default is 6";
    case "Single44MagnumDmgMax":
			return "Max Damage | Default is 105";
    case "Single44MagnumCost":
			return "Cost | Default is 450";
    case "Single44MagnumWeight":
			return "Weight | Default is 2";
    case "Dual44MagnumMag":
			return "Mag Size | Default is 12";
    case "Dual44MagnumDmgMax":
			return "Max Damage | Default is 105";
    case "Dual44MagnumCost":
			return "Cost | Default is 900";
    case "Dual44MagnumWeight":
			return "Weight | Default is 4";
    case "SingleDeagleMag":
			return "Mag Size | Default is 8";
    case "SingleDeagleDmgMax":
			return "Max Damage | Default is 115";
    case "SingleDeagleCost":
			return "Cost | Default is 500";
    case "SingleDeagleWeight":
			return "Weight | Default is 2";
    case "DualDeagleMag":
			return "Mag Size | Default is 16";
    case "DualDeagleDmgMax":
			return "Max Damage | Default is 115";
    case "DualDeagleCost":
			return "Cost | Default is 1000";
    case "DualDeagleWeight":
			return "Weight | Default is 4";
    case "WinchesterMag":
			return "Mag Size | Default is 10";
    case "WinchesterDmgMax":
			return "Max Damage | Default is 140";
    case "WinchesterCost":
			return "Cost | Default is 200";
    case "WinchesterWeight":
			return "Weight | Default is 6";
    case "CrossbowMag":
			return "Mag Size | Default is 1";
    case "CrossbowDmgMax":
			return "Max Damage | Default is 300";
    case "CrossbowCost":
			return "Cost | Default is 800";
    case "CrossbowWeight":
			return "Weight | Default is 9";
    case "SPSniperRifleMag":
			return "Mag Size | Default is 10";
    case "SPSniperRifleDmgMax":
			return "Max Damage | Default is 180";
    case "SPSniperRifleCost":
			return "Cost | Default is 1500";
    case "SPSniperRifleWeight":
			return "Weight | Default is 6";
    case "M14EBRMag":
			return "Mag Size | Default is 20";
    case "M14EBRDmgMax":
			return "Max Damage | Default is 80";
    case "M14EBRCost":
			return "Cost | Default is 2500";
    case "M14EBRWeight":
			return "Weight | Default is 8";
    case "M99Mag":
			return "Mag Size | Default is 1";
    case "M99DmgMax":
			return "Max Damage | Default is 675";
    case "M99Cost":
			return "Cost | Default is 3500";
    case "M99Weight":
			return "Weight | Default is 13";
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
    FriendlyName="Weapon Stat Config - v1.0b"
    Description="Change Weapon MaxDmg, Magazine Size & Cost (More options coming soon), currently supports Standard KF weapons only & SharpShooter (More Perks Coming Soon); - By Vel-San"

    // Weapon Stats
    // SS
    bEnableSharp=True
    Single9mmMag=15
    Single9mmDmgMax=35
    DualiesMag=30
    DualiesDmgMax=35
    DualiesCost=150
    DualiesWeight=4
    MK23Mag=12
    MK23DmgMax=82
    MK23Cost=500
    MK23Weight=2
    DualMK23Mag=24
    DualMK23DmgMax=82
    DualMK23Cost=1000
    DualMK23Weight=4
    Single44MagnumMag=6
    Single44MagnumDmgMax=105
    Single44MagnumCost=450
    Single44MagnumWeight=2
    Dual44MagnumMag=12
    Dual44MagnumDmgMax=105
    Dual44MagnumCost=900
    Dual44MagnumWeight=4
    SingleDeagleMag=8
    SingleDeagleDmgMax=115
    SingleDeagleCost=500
    SingleDeagleWeight=2
    DualDeagleMag=16
    DualDeagleDmgMax=115
    DualDeagleCost=1000
    DualDeagleWeight=4
    WinchesterMag=10
    WinchesterDmgMax=140
    WinchesterCost=200
    WinchesterWeight=6
    CrossbowMag=1
    CrossbowDmgMax=300
    CrossbowCost=800
    CrossbowWeight=9
    SPSniperRifleMag=10
    SPSniperRifleDmgMax=180
    SPSniperRifleCost=1500
    SPSniperRifleWeight=6
    M14EBRMag=20
    M14EBRDmgMax=80
    M14EBRCost=2500
    M14EBRWeight=8
    M99Mag=1
    M99DmgMax=675
    M99Cost=3500
    M99Weight=13
}
