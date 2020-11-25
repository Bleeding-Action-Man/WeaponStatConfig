//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator
  config(KFWeaponStatConfig);


// Struct of Weapons Array declared in Config File
// TODO: Add ProjPerFire & AltFire Changes
struct LoadedWeapon
{
  var config string sWeaponClassName;
  var config int iMagCapacity, iAmmoCost, iDamageMax, iImpactDamage, iWeight, iCost, iInventoryGroup, iProjPerFire;
  var config float fHeadShotDamageMult, fSpread, fFireRate, fFireAnimRate, fReloadRate, fReloadAnimRate;
};

// Weapons Count | Default 200, but can be changed if Server Owners need more :)
const WEAPONS_COUNT = 200;

// Debugging
var config bool bDebug;

// Weapons List to be loaded from Config File
var config LoadedWeapon aWeapon[WEAPONS_COUNT];

var bool Debug;
var LoadedWeapon Weapon[WEAPONS_COUNT];

replication
{
  reliable if (Role == ROLE_Authority)
                Debug,
                aWeapon, Weapon;
}

simulated function PostBeginPlay()
{
  Debug = bDebug;

  if(Debug) MutLog("-----|| DEBUG - class'Helper'.static.PrintDefaultStats(Debug) ||-----");
  class'Helper'.static.PrintDefaultStats(Debug);

  // Timer set to 3 to give some time for client var replication
  setTimer(3, false);
}

simulated function Timer()
{
  local int Count;

  // Get Count + Vars to Client
  Count = GetServerVars();

  // Trigger WeaponModification
  if(Count > 0) ModifyWeapon(Count);
  else MutLog("-----|| 0 Weapons Found in Config - Aborting ||-----");
}

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(int TmpCount)
{
  local int i;

  local class<KFWeapon> CurrentWeapon;
  local class<KFWeaponPickup> CurrentWeaponPickup;

  local class<KFFire> CurrentWeaponFire;
  local class<KFShotgunFire> CurrentWeaponShotgunFire;
  local class<KFMeleeFire> CurrentWeaponKFMeleeFire;
  local class<KFHighROFFire> CurrentWeaponKFHighROFFire;

  local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;
  local class<DamTypeMelee> CurrentWeaponDamTypeMelee;
  local class<Projectile> CurrentWeaponProjectile;
  local class<ShotgunBullet> CurrentWeaponShotgunBullet;
  local class<LAWProj> CurrentWeaponLAWProj;

  MutLog("-----|| Detected [" $TmpCount$ "] Weapon Configs ||-----");

  for (i=0; i<TmpCount; i++)
  {
      // Exit if Weapon Class Not Found
      if(class<KFWeapon>(DynamicLoadObject(Weapon[i].sWeaponClassName, class'Class')) != none)
      {
        CurrentWeapon = class<KFWeapon>(DynamicLoadObject(Weapon[i].sWeaponClassName, class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

        // Log for Currently Detected Weapon
        MutLog("-----|| Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Standard Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponFire.default.Spread = Weapon[i].fSpread;
        CurrentWeaponFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;

        }
        else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFHighROFFire.default.DamageMax = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponKFHighROFFire.default.Spread = Weapon[i].fSpread;
        CurrentWeaponKFHighROFFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponKFHighROFFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        }

        else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFMeleeFire.default.MeleeDamage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponKFMeleeFire.default.Spread = Weapon[i].fSpread;
        CurrentWeaponKFMeleeFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponKFMeleeFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDamTypeMelee.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        }

        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
        MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

        // WeaponFire Class Related Changes
        CurrentWeaponProjectile.default.Damage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].iProjPerFire != 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TODO: Find a way to get rid of this ugly hack.. some weapons
        // have 2 fHeadShotDamageMult, one in the base class and another in the DmgType
        switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
        MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

        // WeaponFire Class Related Changes
        CurrentWeaponShotgunBullet.default.Damage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].iProjPerFire != 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TODO: Add Switch statement to manually change fHeadShotDamageMult like the above switch
        }
        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponLAWProj.default.ImpactDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A LAW-Proj Class");
        MutLog("       >Special Class: " $string(CurrentWeaponLAWProj));

        // WeaponFire Class Related Changes
        CurrentWeaponLAWProj.default.Damage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread != 999) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].iProjPerFire != 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
        CurrentWeaponLAWProj.default.ImpactDamage = Weapon[i].iImpactDamage;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TODO: Add Switch statement to manually change fHeadShotDamageMult like the above switch
            }
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        CurrentWeapon.default.Weight = Weapon[i].iWeight;
        CurrentWeapon.default.InventoryGroup = Weapon[i].iInventoryGroup;
        // Ignore if current weapon is a Melee
        if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
            CurrentWeapon.default.MagCapacity = Weapon[i].iMagCapacity;
            CurrentWeapon.default.ReloadRate = Weapon[i].fReloadRate;
            CurrentWeapon.default.ReloadAnimRate = Weapon[i].fReloadAnimRate;
        }

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = Weapon[i].iWeight;
        CurrentWeaponPickup.default.cost = Weapon[i].iCost;
        CurrentWeaponPickup.default.AmmoCost = Weapon[i].iAmmoCost;

        if (Debug){
          MutLog("-----|| DEBUG - ClassName: "$Weapon[i].sWeaponClassName$" ||-----");
          MutLog("-----|| DEBUG - InventoryGroup: "$Weapon[i].iInventoryGroup$" ||-----");
          MutLog("-----|| DEBUG - MagCapacity: "$Weapon[i].iMagCapacity$" ||-----");
          MutLog("-----|| DEBUG - AmmoCost: "$Weapon[i].iAmmoCost$" ||-----");
          MutLog("-----|| DEBUG - DamageMax: "$Weapon[i].iDamageMax$" ||-----");
          MutLog("-----|| DEBUG - ImpactDamage: "$Weapon[i].iImpactDamage$" ||-----");
          MutLog("-----|| DEBUG - Weight: "$Weapon[i].iWeight$" ||-----");
          MutLog("-----|| DEBUG - Cost: "$Weapon[i].iCost$" ||-----");
          MutLog("-----|| DEBUG - HeadShotDamageMult: "$Weapon[i].fHeadShotDamageMult$" ||-----");
          MutLog("-----|| DEBUG - Spread: "$Weapon[i].fSpread$" ||-----");
          MutLog("-----|| DEBUG - ProjPerFire: "$Weapon[i].iProjPerFire$" ||-----");
          MutLog("-----|| DEBUG - FireRate: "$Weapon[i].fFireRate$" ||-----");
          MutLog("-----|| DEBUG - FireAnimRate: "$Weapon[i].fFireAnimRate$" ||-----");
          MutLog("-----|| DEBUG - ReloadRate: "$Weapon[i].fReloadRate$" ||-----");
          MutLog("-----|| DEBUG - ReloadAnimRate: "$Weapon[i].fReloadAnimRate$" ||-----");
        }
      }
    }
}

simulated function int GetServerVars()
{
  local int i;
  local int count; // To avoid running loops over WEAPONS_COUNT, just get the count of actual array entry

  if(Debug) MutLog("-----|| DEBUG - GetServerVars(); ||-----");

  count = 0;
  for(i=0; i<WEAPONS_COUNT; i++)
  {
    if (aWeapon[i].sWeaponClassName != "")
    {
      Weapon[i] = aWeapon[i];
      MutLog("-----|| Received Config for [" $Weapon[i].sWeaponClassName$ "] ||-----");
      count++;
    }
  }

  return count;
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
  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bAddToServerPackages=True
  bNetNotify=True

  // Mut Vars
  GroupName="KF-WeaponStatConfig"
  FriendlyName="Weapon Stats Configurator - v2.2"
  Description="Change Standard & Custom Weapon Stats - By Vel-San, dkanus & NikC"
}