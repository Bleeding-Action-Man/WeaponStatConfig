//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator
  config(KFWeaponStatConfig);


// Struct of Weapons Array declared in Config File
struct LoadedWeapon
{
  var config string sWeaponClassName;
  var config int iMagCapacity, iAmmoCost, iDamageMax, iImpactDamage, iWeight, iCost;
  var config float fHeadShotDamageMult, fFireRate, fFireAnimRate, fReloadRate, fReloadAnimRate;
};

// Debugging
var() config bool bDebug;

// Weapons List to be loaded from Config File
var() config array<LoadedWeapon> Weapon;

var array<LoadedWeapon> RepWeapon;
var string RepWeaponClassName;
var int RepMagCapacity, RepAmmoCost, RepDamageMax, RepImpactDamage, RepWeight, RepCost;
var float RepHeadShotDamageMult, RepFireRate, RepFireAnimRate, RepReloadRate, RepReloadAnimRate;

function PostBeginPlay()
{
  if(bDebug) MutLog("-----|| DEBUG - class'Helper'.static.PrintDefaultStats(bDebug) ||-----");
  class'Helper'.static.PrintDefaultStats(bDebug);
  RepWeapon.Length = Weapon.Length;
  GetServerVars(RepWeapon);
  ModifyWeapon(RepWeapon);
}

replication

{
  unreliable if (Role == ROLE_Authority)
                RepWeaponClassName,
                RepMagCapacity, RepAmmoCost, RepDamageMax, RepImpactDamage, RepWeight, RepCost,
                RepHeadShotDamageMult, RepFireRate, RepFireAnimRate, RepReloadRate, RepReloadAnimRate;
}


// Dynamically Load and modify weapons that are found in the Config File
function ModifyWeapon(array<LoadedWeapon> TmpWeapons)
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

  if (TmpWeapons.Length == 0)
  {
    MutLog("-----|| 0 Weapons Found in Config - Aborting ||-----");
    return;
  }

  MutLog("-----|| Detected [" $TmpWeapons.Length$ "] Weapon Configs ||-----");

  for (i=0; i<TmpWeapons.Length; i++)
  {
      // Exit if Weapon Class Not Found
      if(class<KFWeapon>(DynamicLoadObject(TmpWeapons[i].sWeaponClassName, class'Class')) != none)
      {
        CurrentWeapon = class<KFWeapon>(DynamicLoadObject(TmpWeapons[i].sWeaponClassName, class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

        // Log for Currently Detected Weapon
        MutLog("-----|| Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Standard Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = TmpWeapons[i].iDamageMax;
        CurrentWeaponFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = TmpWeapons[i].fHeadShotDamageMult;

        }
        else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFHighROFFire.default.DamageMax = TmpWeapons[i].iDamageMax;
        CurrentWeaponKFHighROFFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponKFHighROFFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = TmpWeapons[i].fHeadShotDamageMult;
        }

        else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFMeleeFire.default.MeleeDamage = TmpWeapons[i].iDamageMax;
        CurrentWeaponKFMeleeFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponKFMeleeFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDamTypeMelee.default.HeadShotDamageMult = TmpWeapons[i].fHeadShotDamageMult;
        }

        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
        MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

        // WeaponFire Class Related Changes
        CurrentWeaponProjectile.default.Damage = TmpWeapons[i].iDamageMax;
        CurrentWeaponShotgunFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TODO: Find a way to get rid of this ugly hack.. some weapons
        // have 2 fHeadShotDamageMult, one in the base class and another in the DmgType
        switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = TmpWeapons[i].fHeadShotDamageMult;
            }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
        MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

        // WeaponFire Class Related Changes
        CurrentWeaponShotgunBullet.default.Damage = TmpWeapons[i].iDamageMax;
        CurrentWeaponShotgunFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

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
        CurrentWeaponLAWProj.default.Damage = TmpWeapons[i].iDamageMax;
        CurrentWeaponLAWProj.default.ImpactDamage = TmpWeapons[i].iImpactDamage;
        CurrentWeaponShotgunFire.default.FireRate = TmpWeapons[i].fFireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = TmpWeapons[i].fFireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TODO: Add Switch statement to manually change fHeadShotDamageMult like the above switch
            }
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        CurrentWeapon.default.Weight = TmpWeapons[i].iWeight;
        // Ignore if current weapon is a Melee
        if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
            CurrentWeapon.default.MagCapacity = TmpWeapons[i].iMagCapacity;
            CurrentWeapon.default.ReloadRate = TmpWeapons[i].fReloadRate;
            CurrentWeapon.default.ReloadAnimRate = TmpWeapons[i].fReloadAnimRate;
        }

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = TmpWeapons[i].iWeight;
        CurrentWeaponPickup.default.cost = TmpWeapons[i].iCost;
        CurrentWeaponPickup.default.AmmoCost = TmpWeapons[i].iAmmoCost;

        if (bDebug){
          MutLog("-----|| DEBUG - ClassName: "$TmpWeapons[i].sWeaponClassName$" ||-----");
          MutLog("-----|| DEBUG - iMagCapacity: "$TmpWeapons[i].iMagCapacity$" ||-----");
          MutLog("-----|| DEBUG - iAmmoCost: "$TmpWeapons[i].iAmmoCost$" ||-----");
          MutLog("-----|| DEBUG - iDamageMax: "$TmpWeapons[i].iDamageMax$" ||-----");
          MutLog("-----|| DEBUG - iImpactDamage: "$TmpWeapons[i].iImpactDamage$" ||-----");
          MutLog("-----|| DEBUG - iWeight: "$TmpWeapons[i].iWeight$" ||-----");
          MutLog("-----|| DEBUG - iCost: "$TmpWeapons[i].iCost$" ||-----");
          MutLog("-----|| DEBUG - fHeadShotDamageMult: "$TmpWeapons[i].fHeadShotDamageMult$" ||-----");
          MutLog("-----|| DEBUG - fFireRate: "$TmpWeapons[i].fFireRate$" ||-----");
          MutLog("-----|| DEBUG - fFireAnimRate: "$TmpWeapons[i].fFireAnimRate$" ||-----");
          MutLog("-----|| DEBUG - fReloadRate: "$TmpWeapons[i].fReloadRate$" ||-----");
          MutLog("-----|| DEBUG - fReloadAnimRate: "$TmpWeapons[i].fReloadAnimRate$" ||-----");
        }
      }
    }
}

function GetServerVars(out array<LoadedWeapon> TempWeapons)
{
  local int i;

  if(bDebug) MutLog("-----|| DEBUG - GetServerVars(); ||-----");

  for(i=0; i<Weapon.Length; i++)
  {
    RepWeaponClassName = Weapon[i].sWeaponClassName;
    RepMagCapacity = Weapon[i].iMagCapacity;
    RepAmmoCost = Weapon[i].iAmmoCost;
    RepDamageMax = Weapon[i].iDamageMax;
    RepImpactDamage = Weapon[i].iImpactDamage;
    RepWeight = Weapon[i].iWeight;
    RepCost = Weapon[i].iCost;
    RepHeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
    RepFireRate = Weapon[i].fFireRate;
    RepFireAnimRate = Weapon[i].fFireAnimRate;
    RepReloadRate = Weapon[i].fReloadRate;
    RepReloadAnimRate = Weapon[i].fReloadAnimRate;

    // TODO: Implement duplicates detection

    TempWeapons[i].sWeaponClassName = RepWeaponClassName;
    TempWeapons[i].iMagCapacity = RepMagCapacity;
    TempWeapons[i].iAmmoCost = RepAmmoCost;
    TempWeapons[i].iDamageMax = RepDamageMax;
    TempWeapons[i].iImpactDamage = RepImpactDamage;
    TempWeapons[i].iWeight = RepWeight;
    TempWeapons[i].iCost = RepCost;
    TempWeapons[i].fHeadShotDamageMult = RepHeadShotDamageMult;
    TempWeapons[i].fFireRate = RepFireRate;
    TempWeapons[i].fFireAnimRate = RepFireAnimRate;
    TempWeapons[i].fReloadRate = RepReloadRate;
    TempWeapons[i].fReloadAnimRate = RepReloadAnimRate;
  }
}

function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'WeaponStatsConfig');
}


function MutLog(string s)
{
  log(s, 'WeaponStatsConfig');
}


defaultproperties
{
  // Mut Vars
  GroupName="KF-WeaponStatConfig"
  FriendlyName="Weapon Stats Configurator - v1.3"
  Description="Change Standard & Custom Weapon Stats - By Vel-San, dkanus & NikC"
}