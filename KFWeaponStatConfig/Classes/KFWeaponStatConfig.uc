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
                  M99Mag, M99DmgMax, M99Cost, M99Weight,
                  MP7MMag, MP7MDmgMax, MP7MCost, MP7MWeight,
                  MP5MMag, MP5MDmgMax, MP5MCost, MP5MWeight,
                  M7A3MMag, M7A3MDmgMax, M7A3MCost, M7A3MWeight,
                  KrissMMag, KrissMDmgMax, KrissMCost, KrissMWeight,
                  FlareRevolverMag, FlareRevolverDmgMax, FlareRevolverCost, FlareRevolverWeight,
                  DualFlareRevolverMag, DualFlareRevolverCost, DualFlareRevolverWeight,
                  MAC10MPMag, MAC10MPDmgMax, MAC10MPCost, MAC10MPWeight,
                  TrenchgunMag, TrenchgunDmgMax, TrenchgunCost, TrenchgunWeight,
                  HuskGunMag, HuskGunDmgMax, HuskGunCost, HuskGunWeight;

var() config float Single9mmFireRate, Single9mmFireAnimRate, Single9mmReloadRate, Single9mmReloadAnimeRate,
                   DualiesFireRate, DualiesFireAnimRate, DualiesReloadRate, DualiesReloadAnimeRate, DualiesHeadShotMulti,
                   MK23FireRate, MK23FireAnimRate, MK23ReloadRate, MK23ReloadAnimeRate, MK23HeadShotMulti,
                   DualMK23FireRate, DualMK23FireAnimRate, DualMK23ReloadRate, DualMK23ReloadAnimeRate, DualMK23HeadShotMulti,
                   Single44MagnumFireRate, Single44MagnumFireAnimRate, Single44MagnumReloadRate, Single44MagnumReloadAnimeRate, Single44MagnumHeadShotMulti,
                   Dual44MagnumFireRate, Dual44MagnumFireAnimRate, Dual44MagnumReloadRate, Dual44MagnumReloadAnimeRate, Dual44MagnumHeadShotMulti,
                   SingleDeagleFireRate, SingleDeagleFireAnimRate, SingleDeagleReloadRate, SingleDeagleReloadAnimeRate, SingleDeagleHeadShotMulti,
                   DualDeagleFireRate, DualDeagleFireAnimRate, DualDeagleReloadRate, DualDeagleReloadAnimeRate, DualDeagleHeadShotMulti,
                   WinchesterFireRate, WinchesterFireAnimRate, WinchesterReloadRate, WinchesterReloadAnimeRate, WinchesterHeadShotMulti,
                   SPSniperRifleFireRate, SPSniperRifleFireAnimRate, SPSniperRifleReloadRate, SPSniperRifleReloadAnimeRate, SPSniperRifleHeadShotMulti,
                   CrossbowFireRate, CrossbowFireAnimRate, CrossbowReloadRate, CrossbowReloadAnimeRate, CrossbowHeadShotMulti,
                   M14EBRFireRate, M14EBRFireAnimRate, M14EBRReloadRate, M14EBRReloadAnimeRate, M14EBRHeadShotMulti,
                   M99FireRate, M99FireAnimRate, M99ReloadRate, M99ReloadAnimeRate, M99HeadShotMulti,
                   MP7MFireRate, MP7MFireAnimRate, MP7MReloadRate, MP7MReloadAnimeRate,
                   MP5MFireRate, MP5MFireAnimRate, MP5MReloadRate, MP5MReloadAnimeRate,
                   M7A3MFireRate, M7A3MFireAnimRate, M7A3MReloadRate, M7A3MReloadAnimeRate,
                   KrissMFireRate, KrissMFireAnimRate, KrissMReloadRate, KrissMReloadAnimeRate,
                   FlareRevolverFireRate, FlareRevolverFireAnimRate, FlareRevolverReloadRate, FlareRevolverReloadAnimeRate, FlareRevolverHeadShotMulti,
                   DualFlareRevolverFireRate, DualFlareRevolverFireAnimRate, DualFlareRevolverReloadRate, DualFlareRevolverReloadAnimeRate,
                   MAC10MPFireRate, MAC10MPFireAnimRate, MAC10MPReloadRate, MAC10MPReloadAnimeRate,
                   TrenchgunFireRate, TrenchgunFireAnimRate, TrenchgunReloadRate, TrenchgunReloadAnimeRate, TrenchgunHeadShotMulti,
                   HuskGunFireRate, HuskGunFireAnimRate, HuskGunReloadRate, HuskGunReloadAnimeRate, HuskGunHeadShotMulti;

var() config bool bEnableSharp;
var() config bool bEnableMedic;
var() config bool bEnableFireBug;

//////////////////////////////////////////////////////////////////////////////
// Testing New Logic For Weapon Loading

// Normal Weapons that have no Projectile or Bullet Classes
struct LoadedWeapon
{
  var config string WeaponClassName;
  var config int MagCapacity, DamageMax, Weight, Cost;
  var config float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
};

// Load each weapon in a list
var() config array<LoadedWeapon> StandardWeapon;
//////////////////////////////////////////////////////////////////////////////


replication
{
	unreliable if (Role == ROLE_Authority)
                  bEnableSharp,
                  bEnableMedic,
                  bEnableFireBug,
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
                  M99Mag, M99DmgMax, M99Cost, M99Weight,
                  MP7MMag, MP7MDmgMax, MP7MCost, MP7MWeight,
                  MP5MMag, MP5MDmgMax, MP5MCost, MP5MWeight,
                  M7A3MMag, M7A3MDmgMax, M7A3MCost, M7A3MWeight,
                  KrissMMag, KrissMDmgMax, KrissMCost, KrissMWeight,
                  FlareRevolverMag, FlareRevolverDmgMax, FlareRevolverCost, FlareRevolverWeight,
                  DualFlareRevolverMag, DualFlareRevolverCost, DualFlareRevolverWeight,
                  MAC10MPMag, MAC10MPDmgMax, MAC10MPCost, MAC10MPWeight,
                  TrenchgunMag, TrenchgunDmgMax, TrenchgunCost, TrenchgunWeight,
                  HuskGunMag, HuskGunDmgMax, HuskGunCost, HuskGunWeight,
                  Single9mmFireRate, Single9mmFireAnimRate, Single9mmReloadRate, Single9mmReloadAnimeRate,
                   DualiesFireRate, DualiesFireAnimRate, DualiesReloadRate, DualiesReloadAnimeRate, DualiesHeadShotMulti,
                   MK23FireRate, MK23FireAnimRate, MK23ReloadRate, MK23ReloadAnimeRate, MK23HeadShotMulti,
                   DualMK23FireRate, DualMK23FireAnimRate, DualMK23ReloadRate, DualMK23ReloadAnimeRate, DualMK23HeadShotMulti,
                   Single44MagnumFireRate, Single44MagnumFireAnimRate, Single44MagnumReloadRate, Single44MagnumReloadAnimeRate, Single44MagnumHeadShotMulti,
                   Dual44MagnumFireRate, Dual44MagnumFireAnimRate, Dual44MagnumReloadRate, Dual44MagnumReloadAnimeRate, Dual44MagnumHeadShotMulti,
                   SingleDeagleFireRate, SingleDeagleFireAnimRate, SingleDeagleReloadRate, SingleDeagleReloadAnimeRate, SingleDeagleHeadShotMulti,
                   DualDeagleFireRate, DualDeagleFireAnimRate, DualDeagleReloadRate, DualDeagleReloadAnimeRate, DualDeagleHeadShotMulti,
                   WinchesterFireRate, WinchesterFireAnimRate, WinchesterReloadRate, WinchesterReloadAnimeRate, WinchesterHeadShotMulti,
                   SPSniperRifleFireRate, SPSniperRifleFireAnimRate, SPSniperRifleReloadRate, SPSniperRifleReloadAnimeRate, SPSniperRifleHeadShotMulti,
                   CrossbowFireRate, CrossbowFireAnimRate, CrossbowReloadRate, CrossbowReloadAnimeRate, CrossbowHeadShotMulti,
                   M14EBRFireRate, M14EBRFireAnimRate, M14EBRReloadRate, M14EBRReloadAnimeRate, M14EBRHeadShotMulti,
                   M99FireRate, M99FireAnimRate, M99ReloadRate, M99ReloadAnimeRate, M99HeadShotMulti,
                   MP7MFireRate, MP7MFireAnimRate, MP7MReloadRate, MP7MReloadAnimeRate,
                   MP5MFireRate, MP5MFireAnimRate, MP5MReloadRate, MP5MReloadAnimeRate,
                   M7A3MFireRate, M7A3MFireAnimRate, M7A3MReloadRate, M7A3MReloadAnimeRate,
                   KrissMFireRate, KrissMFireAnimRate, KrissMReloadRate, KrissMReloadAnimeRate,
                   FlareRevolverFireRate, FlareRevolverFireAnimRate, FlareRevolverReloadRate, FlareRevolverReloadAnimeRate, FlareRevolverHeadShotMulti,
                   DualFlareRevolverFireRate, DualFlareRevolverFireAnimRate, DualFlareRevolverReloadRate, DualFlareRevolverReloadAnimeRate,
                   MAC10MPFireRate, MAC10MPFireAnimRate, MAC10MPReloadRate, MAC10MPReloadAnimeRate,
                   TrenchgunFireRate, TrenchgunFireAnimRate, TrenchgunReloadRate, TrenchgunReloadAnimeRate, TrenchgunHeadShotMulti,
                   HuskGunFireRate, HuskGunFireAnimRate, HuskGunReloadRate, HuskGunReloadAnimeRate, HuskGunHeadShotMulti;
}

simulated function PostNetReceive()
{
  super.PostNetReceive();
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  // SetTimer(1, false);
  ModifyWeapon(StandardWeapon);
}

simulated function Timer()
{
  if (bEnableSharp){
    ApplySharpShooter();
  }
  if(bEnableMedic){
    ApplyFieldMedic();
  }
  if(bEnableFireBug){
    ApplyFireBug();
  }
}

simulated function ApplySharpShooter(){
    MutLog("-----|| Changing SharpShooter Weapons Stats ||-----");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    class'KFMod.SingleFire'.default.FireRate=Single9mmFireRate;
    class'KFMod.SingleFire'.default.FireAnimRate=Single9mmFireAnimRate;
    class'KFMod.Single'.default.ReloadRate=Single9mmReloadRate;
    class'KFMod.Single'.default.ReloadAnimRate=Single9mmReloadAnimeRate;
    MutLog("-----|| Single9mm: Applied ||-----");
    class'KFMod.Dualies'.default.MagCapacity=DualiesMag;
    class'KFMod.Dualies'.default.Weight=DualiesWeight;
    class'KFMod.DualiesPickup'.default.Weight=DualiesWeight;
    class'KFMod.DualiesFire'.default.DamageMax=DualiesDmgMax;
    class'KFMod.DualiesPickup'.default.cost=DualiesCost;
    class'KFMod.DamTypeDualies'.default.HeadShotDamageMult=DualiesHeadShotMulti;
    class'KFMod.DualiesFire'.default.FireRate=DualiesFireRate;
    class'KFMod.DualiesFire'.default.FireAnimRate=DualiesFireAnimRate;
    class'KFMod.Dualies'.default.ReloadRate=DualiesReloadRate;
    class'KFMod.Dualies'.default.ReloadAnimRate=DualiesReloadAnimeRate;
    MutLog("-----|| Dualies: Applied ||-----");
    class'KFMod.MK23Pistol'.default.MagCapacity=MK23Mag;
    class'KFMod.MK23Pistol'.default.Weight=MK23Weight;
    class'KFMod.MK23Pickup'.default.Weight=MK23Weight;
    class'KFMod.MK23Fire'.default.DamageMax=MK23DmgMax;
    class'KFMod.MK23Pickup'.default.cost=MK23Cost;
    class'KFMod.DamTypeMK23Pistol'.default.HeadShotDamageMult=MK23HeadShotMulti;
    class'KFMod.MK23Fire'.default.FireRate=MK23FireRate;
    class'KFMod.MK23Fire'.default.FireAnimRate=MK23FireAnimRate;
    class'KFMod.MK23Pistol'.default.ReloadRate=MK23ReloadRate;
    class'KFMod.MK23Pistol'.default.ReloadAnimRate=MK23ReloadAnimeRate;
    MutLog("-----|| MK23: Applied ||-----");
    class'KFMod.DualMK23Pistol'.default.MagCapacity=DualMK23Mag;
    class'KFMod.DualMK23Pistol'.default.Weight=DualMK23Weight;
    class'KFMod.DualMK23Pickup'.default.Weight=DualMK23Weight;
    class'KFMod.DualMK23Fire'.default.DamageMax=DualMK23DmgMax;
    class'KFMod.DualMK23Pickup'.default.cost=DualMK23Cost;
    class'KFMod.DamTypeDualMK23Pistol'.default.HeadShotDamageMult=DualMK23HeadShotMulti;
    class'KFMod.DualMK23Fire'.default.FireRate=DualMK23FireRate;
    class'KFMod.DualMK23Fire'.default.FireAnimRate=DualMK23FireAnimRate;
    class'KFMod.DualMK23Pistol'.default.ReloadRate=DualMK23ReloadRate;
    class'KFMod.DualMK23Pistol'.default.ReloadAnimRate=DualMK23ReloadAnimeRate;
    MutLog("-----|| DualMK23: Applied ||-----");
    class'KFMod.Magnum44Pistol'.default.MagCapacity=Single44MagnumMag;
    class'KFMod.Magnum44Pistol'.default.Weight=Single44MagnumWeight;
    class'KFMod.Magnum44Pickup'.default.Weight=Single44MagnumWeight;
    class'KFMod.Magnum44Fire'.default.DamageMax=Single44MagnumDmgMax;
    class'KFMod.Magnum44Pickup'.default.cost=Single44MagnumCost;
    class'KFMod.DamTypeMagnum44Pistol'.default.HeadShotDamageMult=Single44MagnumHeadShotMulti;
    class'KFMod.Magnum44Fire'.default.FireRate=Single44MagnumFireRate;
    class'KFMod.Magnum44Fire'.default.FireAnimRate=Single44MagnumFireAnimRate;
    class'KFMod.Magnum44Pistol'.default.ReloadRate=Single44MagnumReloadRate;
    class'KFMod.Magnum44Pistol'.default.ReloadAnimRate=Single44MagnumReloadAnimeRate;
    MutLog("-----|| 44 Magnum: Applied ||-----");
    class'KFMod.Dual44Magnum'.default.MagCapacity=Dual44MagnumMag;
    class'KFMod.Dual44Magnum'.default.Weight=Dual44MagnumWeight;
    class'KFMod.Dual44MagnumPickup'.default.Weight=Dual44MagnumWeight;
    class'KFMod.Dual44MagnumFire'.default.DamageMax=Dual44MagnumDmgMax;
    class'KFMod.Dual44MagnumPickup'.default.cost=Dual44MagnumCost;
    class'KFMod.DamTypeDual44Magnum'.default.HeadShotDamageMult=Dual44MagnumHeadShotMulti;
    class'KFMod.Dual44MagnumFire'.default.FireRate=Dual44MagnumFireRate;
    class'KFMod.Dual44MagnumFire'.default.FireAnimRate=Dual44MagnumFireAnimRate;
    class'KFMod.Dual44Magnum'.default.ReloadRate=Dual44MagnumReloadRate;
    class'KFMod.Dual44Magnum'.default.ReloadAnimRate=Dual44MagnumReloadAnimeRate;
    MutLog("-----|| 44 Dual Magnum: Applied ||-----");
    class'KFMod.Deagle'.default.MagCapacity=SingleDeagleMag;
    class'KFMod.Deagle'.default.Weight=SingleDeagleWeight;
    class'KFMod.DeaglePickup'.default.Weight=SingleDeagleWeight;
    class'KFMod.DeagleFire'.default.DamageMax=SingleDeagleDmgMax;
    class'KFMod.DeaglePickup'.default.cost=SingleDeagleCost;
    class'KFMod.DamTypeDeagle'.default.HeadShotDamageMult=SingleDeagleHeadShotMulti;
    class'KFMod.DeagleFire'.default.FireRate=SingleDeagleFireRate;
    class'KFMod.DeagleFire'.default.FireAnimRate=SingleDeagleFireAnimRate;
    class'KFMod.Deagle'.default.ReloadRate=SingleDeagleReloadRate;
    class'KFMod.Deagle'.default.ReloadAnimRate=SingleDeagleReloadAnimeRate;
    MutLog("-----|| HandCannon: Applied ||-----");
    class'KFMod.DualDeagle'.default.MagCapacity=DualDeagleMag;
    class'KFMod.DualDeagle'.default.Weight=DualDeagleWeight;
    class'KFMod.DualDeaglePickup'.default.Weight=DualDeagleWeight;
    class'KFMod.DualDeagleFire'.default.DamageMax=DualDeagleDmgMax;
    class'KFMod.DualDeaglePickup'.default.cost=DualDeagleCost;
    class'KFMod.DamTypeDualDeagle'.default.HeadShotDamageMult=DualDeagleHeadShotMulti;
    class'KFMod.DualDeagleFire'.default.FireRate=DualDeagleFireRate;
    class'KFMod.DualDeagleFire'.default.FireAnimRate=DualDeagleFireAnimRate;
    class'KFMod.DualDeagle'.default.ReloadRate=DualDeagleReloadRate;
    class'KFMod.DualDeagle'.default.ReloadAnimRate=DualDeagleReloadAnimeRate;
    MutLog("-----|| Dual HandCannon: Applied ||-----");
    class'KFMod.Winchester'.default.MagCapacity=WinchesterMag;
    class'KFMod.Winchester'.default.Weight=WinchesterWeight;
    class'KFMod.WinchesterPickup'.default.Weight=WinchesterWeight;
    class'KFMod.WinchesterFire'.default.DamageMax=WinchesterDmgMax;
    class'KFMod.WinchesterPickup'.default.cost=WinchesterCost;
    class'KFMod.DamTypeWinchester'.default.HeadShotDamageMult=WinchesterHeadShotMulti;
    class'KFMod.WinchesterFire'.default.FireRate=WinchesterFireRate;
    class'KFMod.WinchesterFire'.default.FireAnimRate=WinchesterFireAnimRate;
    class'KFMod.Winchester'.default.ReloadRate=WinchesterReloadRate;
    class'KFMod.Winchester'.default.ReloadAnimRate=WinchesterReloadAnimeRate;
    MutLog("-----|| Winchester: Applied ||-----");
    class'KFMod.Crossbow'.default.MagCapacity=CrossbowMag;
    class'KFMod.Crossbow'.default.Weight=CrossbowWeight;
    class'KFMod.CrossbowPickup'.default.Weight=CrossbowWeight;
    class'KFMod.CrossbowArrow'.default.Damage=CrossbowDmgMax;
    class'KFMod.CrossbowPickup'.default.cost=CrossbowCost;
    class'KFMod.CrossbowArrow'.default.HeadShotDamageMult=CrossbowHeadShotMulti;
    class'KFMod.CrossbowFire'.default.FireRate=CrossbowFireRate;
    class'KFMod.CrossbowFire'.default.FireAnimRate=CrossbowFireAnimRate;
    class'KFMod.Crossbow'.default.ReloadRate=CrossbowReloadRate;
    class'KFMod.Crossbow'.default.ReloadAnimRate=CrossbowReloadAnimeRate;
    MutLog("-----|| Crossbow: Applied ||-----");
    class'KFMod.SPSniperRifle'.default.MagCapacity=SPSniperRifleMag;
    class'KFMod.SPSniperRifle'.default.Weight=SPSniperRifleWeight;
    class'KFMod.SPSniperPickup'.default.Weight=SPSniperRifleWeight;
    class'KFMod.SPSniperFire'.default.DamageMax=SPSniperRifleDmgMax;
    class'KFMod.SPSniperPickup'.default.cost=SPSniperRifleCost;
    class'KFMod.DamTypeSPSniper'.default.HeadShotDamageMult=SPSniperRifleHeadShotMulti;
    class'KFMod.SPSniperFire'.default.FireRate=SPSniperRifleFireRate;
    class'KFMod.SPSniperFire'.default.FireAnimRate=SPSniperRifleFireAnimRate;
    class'KFMod.SPSniperRifle'.default.ReloadRate=SPSniperRifleReloadRate;
    class'KFMod.SPSniperRifle'.default.ReloadAnimRate=SPSniperRifleReloadAnimeRate;
    MutLog("-----|| SPSniperRifle: Applied ||-----");
    class'KFMod.M14EBRBattleRifle'.default.MagCapacity=M14EBRMag;
    class'KFMod.M14EBRBattleRifle'.default.Weight=M14EBRWeight;
    class'KFMod.M14EBRPickup'.default.Weight=M14EBRWeight;
    class'KFMod.M14EBRFire'.default.DamageMax=M14EBRDmgMax;
    class'KFMod.M14EBRPickup'.default.cost=M14EBRCost;
    class'KFMod.DamTypeM14EBR'.default.HeadShotDamageMult=M14EBRHeadShotMulti;
    class'KFMod.M14EBRFire'.default.FireRate=M14EBRFireRate;
    class'KFMod.M14EBRFire'.default.FireAnimRate=M14EBRFireAnimRate;
    class'KFMod.M14EBRBattleRifle'.default.ReloadRate=M14EBRReloadRate;
    class'KFMod.M14EBRBattleRifle'.default.ReloadAnimRate=M14EBRReloadAnimeRate;
    MutLog("-----|| M14EBR: Applied ||-----");
    class'KFMod.M99SniperRifle'.default.MagCapacity=M99Mag;
    class'KFMod.M99SniperRifle'.default.Weight=M99Weight;
    class'KFMod.M99Pickup'.default.Weight=M99Weight;
    class'KFMod.M99Bullet'.default.Damage=M99DmgMax;
    class'KFMod.M99Pickup'.default.cost=M99Cost;
    class'KFMod.M99Bullet'.default.HeadShotDamageMult=M99HeadShotMulti;
    class'KFMod.M99Fire'.default.FireRate=M99FireRate;
    class'KFMod.M99Fire'.default.FireAnimRate=M99FireAnimRate;
    class'KFMod.M99SniperRifle'.default.ReloadRate=M99ReloadRate;
    class'KFMod.M99SniperRifle'.default.ReloadAnimRate=M99ReloadAnimeRate;
    MutLog("-----|| M99: Applied ||-----");
    MutLog("-----|| SS Weapons Stat Changed ||-----");
}

simulated function ApplyFieldMedic(){
  MutLog("-----|| Changing Field Medic Weapons Stats ||-----");
  class'KFMod.MP7MMedicGun'.default.MagCapacity=MP7MMag;
  class'KFMod.MP7MMedicGun'.default.Weight=MP7MWeight;
  class'KFMod.MP7MPickup'.default.Weight=MP7MWeight;
  class'KFMod.MP7MFire'.default.DamageMax=MP7MDmgMax;
  class'KFMod.MP7MPickup'.default.cost=MP7MCost;
  class'KFMod.MP7MFire'.default.FireRate=MP7MFireRate;
  class'KFMod.MP7MFire'.default.FireAnimRate=MP7MFireAnimRate;
  class'KFMod.MP7MMedicGun'.default.ReloadRate=MP7MReloadRate;
  class'KFMod.MP7MMedicGun'.default.ReloadAnimRate=MP7MReloadAnimeRate;
  MutLog("-----|| MP7M: Applied ||-----");
  class'KFMod.MP5MMedicGun'.default.MagCapacity=MP5MMag;
  class'KFMod.MP5MMedicGun'.default.Weight=MP5MWeight;
  class'KFMod.MP5MPickup'.default.Weight=MP5MWeight;
  class'KFMod.MP5MFire'.default.DamageMax=MP5MDmgMax;
  class'KFMod.MP5MPickup'.default.cost=MP5MCost;
  class'KFMod.MP5MFire'.default.FireRate=MP5MFireRate;
  class'KFMod.MP5MFire'.default.FireAnimRate=MP5MFireAnimRate;
  class'KFMod.MP5MMedicGun'.default.ReloadRate=MP5MReloadRate;
  class'KFMod.MP5MMedicGun'.default.ReloadAnimRate=MP5MReloadAnimeRate;
  MutLog("-----|| MP5M: Applied ||-----");
  class'KFMod.M7A3MMedicGun'.default.MagCapacity=M7A3MMag;
  class'KFMod.M7A3MMedicGun'.default.Weight=M7A3MWeight;
  class'KFMod.M7A3MPickup'.default.Weight=M7A3MWeight;
  class'KFMod.M7A3MFire'.default.DamageMax=M7A3MDmgMax;
  class'KFMod.M7A3MPickup'.default.cost=M7A3MCost;
  class'KFMod.M7A3MFire'.default.FireRate=M7A3MFireRate;
  class'KFMod.M7A3MFire'.default.FireAnimRate=M7A3MFireAnimRate;
  class'KFMod.M7A3MMedicGun'.default.ReloadRate=M7A3MReloadRate;
  class'KFMod.M7A3MMedicGun'.default.ReloadAnimRate=M7A3MReloadAnimeRate;
  MutLog("-----|| M7A3M: Applied ||-----");
  class'KFMod.KrissMMedicGun'.default.MagCapacity=KrissMMag;
  class'KFMod.KrissMMedicGun'.default.Weight=KrissMWeight;
  class'KFMod.KrissMPickup'.default.Weight=KrissMWeight;
  class'KFMod.KrissMFire'.default.DamageMax=KrissMDmgMax;
  class'KFMod.KrissMPickup'.default.cost=KrissMCost;
  class'KFMod.KrissMFire'.default.FireRate=KrissMFireRate;
  class'KFMod.KrissMFire'.default.FireAnimRate=KrissMFireAnimRate;
  class'KFMod.KrissMMedicGun'.default.ReloadRate=KrissMReloadRate;
  class'KFMod.KrissMMedicGun'.default.ReloadAnimRate=KrissMReloadAnimeRate;
  MutLog("-----|| KrissM: Applied ||-----");
  MutLog("-----|| Medic Weapons Stat Changed ||-----");
}

simulated function ApplyFireBug(){
  MutLog("-----|| Changing Fire Bug Weapons Stats ||-----");
  class'KFMod.FlareRevolver'.default.MagCapacity=FlareRevolverMag;
  class'KFMod.FlareRevolver'.default.Weight=FlareRevolverWeight;
  class'KFMod.FlareRevolverPickup'.default.Weight=FlareRevolverWeight;
  class'KFMod.FlareRevolverProjectile'.default.ImpactDamage=FlareRevolverDmgMax;
  class'KFMod.FlareRevolverPickup'.default.cost=FlareRevolverCost;
  class'KFMod.FlareRevolverProjectile'.default.HeadShotDamageMult=FlareRevolverHeadShotMulti;
  class'KFMod.FlareRevolverFire'.default.FireRate=FlareRevolverFireRate;
  class'KFMod.FlareRevolverFire'.default.FireAnimRate=FlareRevolverFireAnimRate;
  class'KFMod.FlareRevolver'.default.ReloadRate=FlareRevolverReloadRate;
  class'KFMod.FlareRevolver'.default.ReloadAnimRate=FlareRevolverReloadAnimeRate;
  MutLog("-----|| FlareRevolver: Applied ||-----");
  class'KFMod.DualFlareRevolver'.default.MagCapacity=DualFlareRevolverMag;
  class'KFMod.DualFlareRevolver'.default.Weight=DualFlareRevolverWeight;
  class'KFMod.DualFlareRevolverPickup'.default.Weight=DualFlareRevolverWeight;
  class'KFMod.DualFlareRevolverPickup'.default.cost=DualFlareRevolverCost;
  class'KFMod.DualFlareRevolverFire'.default.FireRate=DualFlareRevolverFireRate;
  class'KFMod.DualFlareRevolverFire'.default.FireAnimRate=DualFlareRevolverFireAnimRate;
  class'KFMod.DualFlareRevolver'.default.ReloadRate=DualFlareRevolverReloadRate;
  class'KFMod.DualFlareRevolver'.default.ReloadAnimRate=DualFlareRevolverReloadAnimeRate;
  MutLog("-----|| DualFlareRevolver: Applied ||-----");
  class'KFMod.MAC10MP'.default.MagCapacity=MAC10MPMag;
  class'KFMod.MAC10MP'.default.Weight=MAC10MPWeight;
  class'KFMod.MAC10Pickup'.default.Weight=MAC10MPWeight;
  class'KFMod.MAC10Fire'.default.DamageMax=MAC10MPDmgMax;
  class'KFMod.MAC10Pickup'.default.cost=MAC10MPCost;
  class'KFMod.MAC10Fire'.default.FireRate=MAC10MPFireRate;
  class'KFMod.MAC10Fire'.default.FireAnimRate=MAC10MPFireAnimRate;
  class'KFMod.MAC10MP'.default.ReloadRate=MAC10MPReloadRate;
  class'KFMod.MAC10MP'.default.ReloadAnimRate=MAC10MPReloadAnimeRate;
  MutLog("-----|| MAC10MP: Applied ||-----");
  class'KFMod.Trenchgun'.default.MagCapacity=TrenchgunMag;
  class'KFMod.Trenchgun'.default.Weight=TrenchgunWeight;
  class'KFMod.TrenchgunPickup'.default.Weight=TrenchgunWeight;
  class'KFMod.TrenchgunBullet'.default.Damage=TrenchgunDmgMax;
  class'KFMod.TrenchgunBullet'.default.HeadShotDamageMult=TrenchgunHeadShotMulti;
  class'KFMod.TrenchgunPickup'.default.cost=TrenchgunCost;
  class'KFMod.TrenchgunFire'.default.FireRate=TrenchgunFireRate;
  class'KFMod.TrenchgunFire'.default.FireAnimRate=TrenchgunFireAnimRate;
  class'KFMod.Trenchgun'.default.ReloadRate=TrenchgunReloadRate;
  class'KFMod.Trenchgun'.default.ReloadAnimRate=TrenchgunReloadAnimeRate;
  MutLog("-----|| Trenchgun: Applied ||-----");
  class'KFMod.HuskGun'.default.MagCapacity=HuskGunMag;
  class'KFMod.HuskGun'.default.Weight=HuskGunWeight;
  class'KFMod.HuskGunPickup'.default.Weight=HuskGunWeight;
  class'KFMod.HuskGunProjectile'.default.ImpactDamage=HuskGunDmgMax;
  class'KFMod.HuskGunProjectile'.default.HeadShotDamageMult=HuskGunHeadShotMulti;
  class'KFMod.HuskGunPickup'.default.cost=HuskGunCost;
  class'KFMod.HuskGunFire'.default.FireRate=HuskGunFireRate;
  class'KFMod.HuskGunFire'.default.FireAnimRate=HuskGunFireAnimRate;
  class'KFMod.HuskGun'.default.ReloadRate=HuskGunReloadRate;
  class'KFMod.HuskGun'.default.ReloadAnimRate=HuskGunReloadAnimeRate;
  MutLog("-----|| HuskGun: Applied ||-----");
  MutLog("-----|| Fire Bug Weapons Stat Changed ||-----");

}

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(array<LoadedWeapon> WeaponsList)
{
    local int i;
    local class<KFWeapon> CurrentWeapon;
    local class<KFFire> CurrentWeaponFire;
    local class<KFWeaponPickup> CurrentWeaponPickup;
    local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;

    MutLog("-----|| Reading Config File For Weapons ||-----");

    for(i=0; i<WeaponsList.Length; i++)
    {
      // Exit if Weapon Class Not Found
      CurrentWeapon = class<KFWeapon>(DynamicLoadObject(WeaponsList[i].WeaponClassName, class'Class'));
      if(CurrentWeapon != none)
      {
        // Log for Currently Detected Weapon
        MutLog("-----|| Detected & Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Grab Needed Classes
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // Base Class Related Changes
        CurrentWeapon.default.MagCapacity = WeaponsList[i].MagCapacity;
        CurrentWeapon.default.Weight = WeaponsList[i].Weight;
        CurrentWeapon.default.ReloadRate = WeaponsList[i].ReloadRate;
        MutLog("-----|| Reload Anime Rate Before: "$CurrentWeapon.default.ReloadAnimRate$" ||-----");
        CurrentWeapon.default.ReloadAnimRate = WeaponsList[i].ReloadAnimRate;
        MutLog("-----|| Reload Anime Rate After: "$CurrentWeapon.default.ReloadAnimRate$" ||-----");

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = WeaponsList[i].DamageMax;
        CurrentWeaponFire.default.FireRate = WeaponsList[i].FireRate;
        CurrentWeaponFire.default.FireAnimRate = WeaponsList[i].FireAnimRate;

        // DamageType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = WeaponsList[i].HeadShotDamageMult;

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = WeaponsList[i].Weight;
        CurrentWeaponPickup.default.cost = WeaponsList[i].Cost;
      }
    }
}

simulated function GetServerVars(){

    // Options Vars
    default.bEnableSharp = bEnableSharp;
    default.bEnableMedic = bEnableMedic;
    default.bEnableFireBug = bEnableFireBug;

    // SS Vars
    default.Single9mmMag = Single9mmMag;
    default.Single9mmDmgMax = Single9mmDmgMax;
    default.Single9mmFireRate = Single9mmFireRate;
    default.Single9mmFireAnimRate = Single9mmFireAnimRate;
    default.Single9mmReloadRate = Single9mmReloadRate;
    default.Single9mmReloadAnimeRate = Single9mmReloadAnimeRate;
    default.DualiesMag = DualiesMag;
    default.DualiesDmgMax = DualiesDmgMax;
    default.DualiesCost = DualiesCost;
    default.DualiesWeight = DualiesWeight;
    default.DualiesHeadShotMulti = DualiesHeadShotMulti;
    default.DualiesFireRate = DualiesFireRate;
    default.DualiesFireAnimRate = DualiesFireAnimRate;
    default.DualiesReloadRate = DualiesReloadRate;
    default.DualiesReloadAnimeRate = DualiesReloadAnimeRate;
    default.MK23Mag = MK23Mag;
    default.MK23DmgMax = MK23DmgMax;
    default.MK23Cost = MK23Cost;
    default.MK23Weight = MK23Weight;
    default.MK23HeadShotMulti = MK23HeadShotMulti;
    default.MK23FireRate = MK23FireRate;
    default.MK23FireAnimRate = MK23FireAnimRate;
    default.MK23ReloadRate = MK23ReloadRate;
    default.MK23ReloadAnimeRate = MK23ReloadAnimeRate;
    default.DualMK23Mag = DualMK23Mag;
    default.DualMK23DmgMax = DualMK23DmgMax;
    default.DualMK23Cost = DualMK23Cost;
    default.DualMK23Weight = DualMK23Weight;
    default.DualMK23HeadShotMulti = DualMK23HeadShotMulti;
    default.DualMK23FireRate = DualMK23FireRate;
    default.DualMK23FireAnimRate = DualMK23FireAnimRate;
    default.DualMK23ReloadRate = DualMK23ReloadRate;
    default.DualMK23ReloadAnimeRate = DualMK23ReloadAnimeRate;
    default.Single44MagnumMag = Single44MagnumMag;
    default.Single44MagnumDmgMax = Single44MagnumDmgMax;
    default.Single44MagnumCost = Single44MagnumCost;
    default.Single44MagnumWeight = Single44MagnumWeight;
    default.Single44MagnumHeadShotMulti = Single44MagnumHeadShotMulti;
    default.Single44MagnumFireRate = Single44MagnumFireRate;
    default.Single44MagnumFireAnimRate = Single44MagnumFireAnimRate;
    default.Single44MagnumReloadRate = Single44MagnumReloadRate;
    default.Single44MagnumReloadAnimeRate = Single44MagnumReloadAnimeRate;
    default.Dual44MagnumMag = Dual44MagnumMag;
    default.Dual44MagnumDmgMax = Dual44MagnumDmgMax;
    default.Dual44MagnumCost = Dual44MagnumCost;
    default.Dual44MagnumWeight = Dual44MagnumWeight;
    default.Dual44MagnumHeadShotMulti = Dual44MagnumHeadShotMulti;
    default.Dual44MagnumFireRate = Dual44MagnumFireRate;
    default.Dual44MagnumFireAnimRate = Dual44MagnumFireAnimRate;
    default.Dual44MagnumReloadRate = Dual44MagnumReloadRate;
    default.Dual44MagnumReloadAnimeRate = Dual44MagnumReloadAnimeRate;
    default.SingleDeagleMag = SingleDeagleMag;
    default.SingleDeagleDmgMax = SingleDeagleDmgMax;
    default.SingleDeagleCost = SingleDeagleCost;
    default.SingleDeagleWeight = SingleDeagleWeight;
    default.SingleDeagleHeadShotMulti = SingleDeagleHeadShotMulti;
    default.SingleDeagleFireRate = SingleDeagleFireRate;
    default.SingleDeagleFireAnimRate = SingleDeagleFireAnimRate;
    default.SingleDeagleReloadRate = SingleDeagleReloadRate;
    default.SingleDeagleReloadAnimeRate = SingleDeagleReloadAnimeRate;
    default.DualDeagleMag = DualDeagleMag;
    default.DualDeagleDmgMax = DualDeagleDmgMax;
    default.DualDeagleCost = DualDeagleCost;
    default.DualDeagleWeight = DualDeagleWeight;
    default.DualDeagleHeadShotMulti = DualDeagleHeadShotMulti;
    default.DualDeagleFireRate = DualDeagleFireRate;
    default.DualDeagleFireAnimRate = DualDeagleFireAnimRate;
    default.DualDeagleReloadRate = DualDeagleReloadRate;
    default.DualDeagleReloadAnimeRate = DualDeagleReloadAnimeRate;
    default.WinchesterMag = WinchesterMag;
    default.WinchesterDmgMax = WinchesterDmgMax;
    default.WinchesterCost = WinchesterCost;
    default.WinchesterWeight = WinchesterWeight;
    default.WinchesterHeadShotMulti = WinchesterHeadShotMulti;
    default.WinchesterFireRate = WinchesterFireRate;
    default.WinchesterFireAnimRate = WinchesterFireAnimRate;
    default.WinchesterReloadRate = WinchesterReloadRate;
    default.WinchesterReloadAnimeRate = WinchesterReloadAnimeRate;
    default.CrossbowMag = CrossbowMag;
    default.CrossbowDmgMax = CrossbowDmgMax;
    default.CrossbowCost = CrossbowCost;
    default.CrossbowWeight = CrossbowWeight;
    default.CrossbowHeadShotMulti = CrossbowHeadShotMulti;
    default.CrossbowFireRate = CrossbowFireRate;
    default.CrossbowFireAnimRate = CrossbowFireAnimRate;
    default.CrossbowReloadRate = CrossbowReloadRate;
    default.CrossbowReloadAnimeRate = CrossbowReloadAnimeRate;
    default.SPSniperRifleMag = SPSniperRifleMag;
    default.SPSniperRifleDmgMax = SPSniperRifleDmgMax;
    default.SPSniperRifleCost = SPSniperRifleCost;
    default.SPSniperRifleWeight = SPSniperRifleWeight;
    default.SPSniperRifleHeadShotMulti = SPSniperRifleHeadShotMulti;
    default.SPSniperRifleFireRate = SPSniperRifleFireRate;
    default.SPSniperRifleFireAnimRate = SPSniperRifleFireAnimRate;
    default.SPSniperRifleReloadRate = SPSniperRifleReloadRate;
    default.SPSniperRifleReloadAnimeRate = SPSniperRifleReloadAnimeRate;
    default.M14EBRMag = M14EBRMag;
    default.M14EBRDmgMax = M14EBRDmgMax;
    default.M14EBRCost = M14EBRCost;
    default.M14EBRWeight = M14EBRWeight;
    default.M14EBRHeadShotMulti = M14EBRHeadShotMulti;
    default.M14EBRFireRate = M14EBRFireRate;
    default.M14EBRFireAnimRate = M14EBRFireAnimRate;
    default.M14EBRReloadRate = M14EBRReloadRate;
    default.M14EBRReloadAnimeRate = M14EBRReloadAnimeRate;
    default.M99Mag = M99Mag;
    default.M99DmgMax = M99DmgMax;
    default.M99Cost = M99Cost;
    default.M99Weight = M99Weight;
    default.M99HeadShotMulti = M99HeadShotMulti;
    default.M99FireRate = M99FireRate;
    default.M99FireAnimRate = M99FireAnimRate;
    default.M99ReloadRate = M99ReloadRate;
    default.M99ReloadAnimeRate = M99ReloadAnimeRate;

    // Field Medic
    default.MP7MMag = MP7MMag;
    default.MP7MDmgMax = MP7MDmgMax;
    default.MP7MCost = MP7MCost;
    default.MP7MWeight = MP7MWeight;
    default.MP7MFireRate = MP7MFireRate;
    default.MP7MFireAnimRate = MP7MFireAnimRate;
    default.MP7MReloadRate = MP7MReloadRate;
    default.MP7MReloadAnimeRate = MP7MReloadAnimeRate;
    default.MP5MMag = MP5MMag;
    default.MP5MDmgMax = MP5MDmgMax;
    default.MP5MCost = MP5MCost;
    default.MP5MWeight = MP5MWeight;
    default.MP5MFireRate = MP5MFireRate;
    default.MP5MFireAnimRate = MP5MFireAnimRate;
    default.MP5MReloadRate = MP5MReloadRate;
    default.MP5MReloadAnimeRate = MP5MReloadAnimeRate;
    default.M7A3MMag = M7A3MMag;
    default.M7A3MDmgMax = M7A3MDmgMax;
    default.M7A3MCost = M7A3MCost;
    default.M7A3MWeight = M7A3MWeight;
    default.M7A3MFireRate = M7A3MFireRate;
    default.M7A3MFireAnimRate = M7A3MFireAnimRate;
    default.M7A3MReloadRate = M7A3MReloadRate;
    default.M7A3MReloadAnimeRate = M7A3MReloadAnimeRate;
    default.KrissMMag = KrissMMag;
    default.KrissMDmgMax = KrissMDmgMax;
    default.KrissMCost = KrissMCost;
    default.KrissMWeight = KrissMWeight;
    default.KrissMFireRate = KrissMFireRate;
    default.KrissMFireAnimRate = KrissMFireAnimRate;
    default.KrissMReloadRate = KrissMReloadRate;
    default.KrissMReloadAnimeRate = KrissMReloadAnimeRate;

    // Fire Bug
    default.FlareRevolverMag = FlareRevolverMag;
    default.FlareRevolverDmgMax = FlareRevolverDmgMax;
    default.FlareRevolverCost = FlareRevolverCost;
    default.FlareRevolverWeight = FlareRevolverWeight;
    default.FlareRevolverHeadShotMulti = FlareRevolverHeadShotMulti;
    default.FlareRevolverFireRate = FlareRevolverFireRate;
    default.FlareRevolverFireAnimRate = FlareRevolverFireAnimRate;
    default.FlareRevolverReloadRate = FlareRevolverReloadRate;
    default.FlareRevolverReloadAnimeRate = FlareRevolverReloadAnimeRate;
    default.DualFlareRevolverMag = DualFlareRevolverMag;
    default.DualFlareRevolverCost = DualFlareRevolverCost;
    default.DualFlareRevolverWeight = DualFlareRevolverWeight;
    default.DualFlareRevolverFireRate = DualFlareRevolverFireRate;
    default.DualFlareRevolverFireAnimRate = DualFlareRevolverFireAnimRate;
    default.DualFlareRevolverReloadRate = DualFlareRevolverReloadRate;
    default.DualFlareRevolverReloadAnimeRate = DualFlareRevolverReloadAnimeRate;
    default.MAC10MPMag = MAC10MPMag;
    default.MAC10MPDmgMax = MAC10MPDmgMax;
    default.MAC10MPCost = MAC10MPCost;
    default.MAC10MPWeight = MAC10MPWeight;
    default.MAC10MPFireRate = MAC10MPFireRate;
    default.MAC10MPFireAnimRate = MAC10MPFireAnimRate;
    default.MAC10MPReloadRate = MAC10MPReloadRate;
    default.MAC10MPReloadAnimeRate = MAC10MPReloadAnimeRate;
    default.TrenchgunMag = TrenchgunMag;
    default.TrenchgunDmgMax = TrenchgunDmgMax;
    default.TrenchgunCost = TrenchgunCost;
    default.TrenchgunWeight = TrenchgunWeight;
    default.TrenchgunHeadShotMulti = TrenchgunHeadShotMulti;
    default.TrenchgunFireRate = TrenchgunFireRate;
    default.TrenchgunFireAnimRate = TrenchgunFireAnimRate;
    default.TrenchgunReloadRate = TrenchgunReloadRate;
    default.TrenchgunReloadAnimeRate = TrenchgunReloadAnimeRate;
    default.HuskGunMag = HuskGunMag;
    default.HuskGunDmgMax = HuskGunDmgMax;
    default.HuskGunCost = HuskGunCost;
    default.HuskGunWeight = HuskGunWeight;
    default.HuskGunHeadShotMulti = HuskGunHeadShotMulti;
    default.HuskGunFireRate = HuskGunFireRate;
    default.HuskGunFireAnimRate = HuskGunFireAnimRate;
    default.HuskGunReloadRate = HuskGunReloadRate;
    default.HuskGunReloadAnimeRate = HuskGunReloadAnimeRate;
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
    FriendlyName="Weapon Stat Config - v3.0b"
    Description="Change various weapon stats, currently supports Standard KF weapons for {SharpShooter | Field Medic | Fire Bug} (More Perks Coming Soon); - By Vel-San"

    // Weapon Stats
    // SS
    bEnableSharp=True
    bEnableMedic=True
    bEnableFireBug=True
    Single9mmMag=15
    Single9mmDmgMax=35
    Single9mmReloadRate=2.0
    Single9mmReloadAnimeRate=1.0
    Single9mmFireRate=0.175
    Single9mmFireAnimRate=1.5
    DualiesMag=30
    DualiesDmgMax=35
    DualiesCost=150
    DualiesWeight=4
    DualiesHeadShotMulti=1.1
    DualiesReloadRate=3.5
    DualiesReloadAnimeRate=1.0
    DualiesFireRate=0.10000
    DualiesFireAnimRate=1.0
    MK23Mag=12
    MK23DmgMax=82
    MK23Cost=500
    MK23Weight=2
    MK23HeadShotMulti=1.1
    MK23ReloadRate=2.6
    MK23ReloadAnimeRate=1.0
    MK23FireRate=0.18
    MK23FireAnimRate=1.0
    DualMK23Mag=24
    DualMK23DmgMax=82
    DualMK23Cost=1000
    DualMK23Weight=4
    DualMK23HeadShotMulti=1.1
    DualMK23ReloadRate=4.4667
    DualMK23ReloadAnimeRate=1.0
    DualMK23FireRate=0.120
    DualMK23FireAnimRate=1.0
    Single44MagnumMag=6
    Single44MagnumDmgMax=105
    Single44MagnumCost=450
    Single44MagnumWeight=2
    Single44MagnumHeadShotMulti=1.1
    Single44MagnumReloadRate=2.525
    Single44MagnumReloadAnimeRate=1.0
    Single44MagnumFireRate=0.15
    Single44MagnumFireAnimRate=1.0
    Dual44MagnumMag=12
    Dual44MagnumDmgMax=105
    Dual44MagnumCost=900
    Dual44MagnumWeight=4
    Dual44MagnumHeadShotMulti=1.1
    Dual44MagnumReloadRate=4.4667
    Dual44MagnumReloadAnimeRate=1.0
    Dual44MagnumFireRate=0.075
    Dual44MagnumFireAnimRate=1.0
    SingleDeagleMag=8
    SingleDeagleDmgMax=115
    SingleDeagleCost=500
    SingleDeagleWeight=2
    SingleDeagleHeadShotMulti=1.1
    SingleDeagleReloadRate=2.2
    SingleDeagleReloadAnimeRate=1.0
    SingleDeagleFireRate=0.25
    SingleDeagleFireAnimRate=1.5
    DualDeagleMag=16
    DualDeagleDmgMax=115
    DualDeagleCost=1000
    DualDeagleWeight=4
    DualDeagleHeadShotMulti=1.1
    DualDeagleReloadRate=3.5
    DualDeagleReloadAnimeRate=1.0
    DualDeagleFireRate=0.13
    DualDeagleFireAnimRate=1.5
    WinchesterMag=10
    WinchesterDmgMax=140
    WinchesterCost=200
    WinchesterWeight=6
    WinchesterHeadShotMulti=2.0
    WinchesterReloadRate=0.66666666667
    WinchesterReloadAnimeRate=1.0
    WinchesterFireRate=0.9
    WinchesterFireAnimRate=1.0
    CrossbowMag=1
    CrossbowDmgMax=300
    CrossbowCost=800
    CrossbowWeight=9
    CrossbowHeadShotMulti=4.0
    CrossbowReloadRate=0.01
    CrossbowReloadAnimeRate=1.0
    CrossbowFireRate=1.8
    CrossbowFireAnimRate=1.0
    SPSniperRifleMag=10
    SPSniperRifleDmgMax=180
    SPSniperRifleCost=1500
    SPSniperRifleWeight=6
    SPSniperRifleHeadShotMulti=2.0
    SPSniperRifleReloadRate=2.866
    SPSniperRifleReloadAnimeRate=1.0
    SPSniperRifleFireRate=0.94
    SPSniperRifleFireAnimRate=1.0
    M14EBRMag=20
    M14EBRDmgMax=80
    M14EBRCost=2500
    M14EBRWeight=8
    M14EBRHeadShotMulti=2.25
    M14EBRReloadRate=3.366
    M14EBRReloadAnimeRate=1.0
    M14EBRFireRate=0.25
    M14EBRFireAnimRate=1.0
    M99Mag=1
    M99DmgMax=675
    M99Cost=3500
    M99Weight=13
    M99HeadShotMulti=2.25
    M99ReloadRate=4.376
    M99ReloadAnimeRate=1.0
    M99FireRate=0.175
    M99FireAnimRate=1.0

    // Field Medic
    MP7MMag=20
    MP7MDmgMax=25
    MP7MCost=825
    MP7MWeight=3
    MP7MReloadRate=3.166
    MP7MReloadAnimeRate=1.0
    MP7MFireRate=0.063
    MP7MFireAnimRate=1.0
    MP5MMag=32
    MP5MDmgMax=30
    MP5MCost=1375
    MP5MWeight=3
    MP5MReloadRate=3.8
    MP5MReloadAnimeRate=1.0
    MP5MFireRate=0.075
    MP5MFireAnimRate=1.0
    M7A3MMag=15
    M7A3MDmgMax=70
    M7A3MCost=2050
    M7A3MWeight=6
    M7A3MReloadRate=3.066000
    M7A3MReloadAnimeRate=1.0
    M7A3MFireRate=0.166000
    M7A3MFireAnimRate=1.0
    KrissMMag=25
    KrissMDmgMax=40
    KrissMCost=2750
    KrissMWeight=3
    KrissMReloadRate=3.33
    KrissMReloadAnimeRate=1.0
    KrissMFireRate=0.063
    KrissMFireAnimRate=1.0

    // Fire Bug
    FlareRevolverMag=6
    FlareRevolverDmgMax=125
    FlareRevolverCost=500
    FlareRevolverWeight=2
    FlareRevolverHeadShotMulti=1.5
    FlareRevolverReloadRate=3.2
    FlareRevolverReloadAnimeRate=1.0
    FlareRevolverFireRate=0.4
    FlareRevolverFireAnimRate=1.0
    DualFlareRevolverMag=12
    DualFlareRevolverCost=1000
    DualFlareRevolverWeight=4
    DualFlareRevolverReloadRate=4.85
    DualFlareRevolverReloadAnimeRate=1.0
    DualFlareRevolverFireRate=0.20
    DualFlareRevolverFireAnimRate=1.0
    MAC10MPMag=30
    MAC10MPDmgMax=35
    MAC10MPCost=500
    MAC10MPWeight=4
    MAC10MPReloadRate=3.0
    MAC10MPReloadAnimeRate=1.0
    MAC10MPFireRate=0.052
    MAC10MPFireAnimRate=1.0
    TrenchgunMag=6
    TrenchgunDmgMax=18
    TrenchgunCost=1250
    TrenchgunWeight=8
    TrenchgunHeadShotMulti=1.5
    TrenchgunReloadRate=0.7
    TrenchgunReloadAnimeRate=1.0
    TrenchgunFireRate=0.965
    TrenchgunFireAnimRate=0.95
    HuskGunMag=1
    HuskGunDmgMax=100
    HuskGunCost=4000
    HuskGunWeight=8
    HuskGunHeadShotMulti=1.5
    HuskGunReloadRate=0.010000
    HuskGunReloadAnimeRate=1.0
    HuskGunFireRate=0.75
    HuskGunFireAnimRate=1.0
}