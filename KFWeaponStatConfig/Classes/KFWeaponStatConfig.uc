//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator
                                Config(KFWeaponStatConfig);

struct LoadedWeapon
{
  var config string WeaponClassName;
  var config int MagCapacity, DamageMax, Weight, Cost;
  var config float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
  // TO-DO
  // Add More variables such as ImpactDamage for e.g. FlareRevolverGun
};

// Loads each weapon in a list
var() config array<LoadedWeapon> StandardWeapon;

replication
{
	unreliable if (Role == ROLE_Authority)
                  StandardWeapon;
}

simulated function PostNetReceive()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  ModifyWeapon(StandardWeapon);
}

// TO-DO
// Delete all of this commented section after total migration to Dynamic Weapon Loading
/*
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
*/

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(array<LoadedWeapon> WeaponsList)
{
    local int i;
    local class<KFWeapon> CurrentWeapon;
    local class<KFFire> CurrentWeaponFire;
    local class<KFWeaponPickup> CurrentWeaponPickup;
    local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;
    // TO-DO
    // More vars for ImpactDamage & Projectiles

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
        CurrentWeapon.default.ReloadAnimRate = WeaponsList[i].ReloadAnimRate;

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = WeaponsList[i].DamageMax;
        CurrentWeaponFire.default.FireRate = WeaponsList[i].FireRate;
        CurrentWeaponFire.default.FireAnimRate = WeaponsList[i].FireAnimRate;

        // DamageType Class Related Changes
        // TO-DO
        // Check For Projectile, WeaponProjectile or LAW.
        // Change DamageMax accordingly because some cases it is
        // connected with ImpactDamage instead of DamageMax e.g. FlareRevolvers
        // P.S: Fuck You TripWireInteractive for these inconsistencies
        if (CurrentWeaponFire.default.ProjectileClass != none){
        CurrentWeaponDmgType.default.HeadShotDamageMult = WeaponsList[i].HeadShotDamageMult;
        }
        else{

        }

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = WeaponsList[i].Weight;
        CurrentWeaponPickup.default.cost = WeaponsList[i].Cost;
      }
    }
}

simulated function GetServerVars()
{
  local int i;

  default.StandardWeapon.Length = StandardWeapon.Length;
  for(i=0; i<StandardWeapon.Length; i++)
  {
    // TO-DO
    // Implement duplicates detection and remove them
    default.StandardWeapon[i] = StandardWeapon[i];
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
    // TO-DO
    // Update version + Description
    GroupName="KF-WeaponStatConfig"
    FriendlyName="Weapon Stat Config - v3.0b"
    Description="Change various weapon stats on-the-fly using a pre-configured file! - By Vel-San"

    // Temp entry just to have a default value
    StandardWeapon(0)=(WeaponClassName="KFMod.Single",MagCapacity=35,DamageMax=500,Weight=0,Cost=0,HeadShotDamageMult=1.1,FireRate=0.175,FireAnimRate=1.5,ReloadRate=2.0,ReloadAnimRate=2.0)
}