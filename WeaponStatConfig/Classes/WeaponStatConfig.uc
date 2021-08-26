//====================================================
// Base Mutator for WeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class WeaponStatConfig extends Mutator
  config(WeaponStat_Config);


// Struct of Weapons Array declared in Config File
// TODO: Add More Varibales, when needed ;p
struct LoadedWeapon
{
  var config string sWeaponClassName;
  var config int iMaxAmmo, iMagCapacity, iAmmoCost, iDamageMax, iAltFireDamageMax, iImpactDamage, iWeight, iCost, iInventoryGroup, iProjPerFire;
  var config float fHeadShotDamageMult, fSpread, fFireRate, fFireAnimRate, fReloadRate, fReloadAnimRate;
};

// Weapons Count | Default 200, but can be changed if Server Owners need more :)
const WEAPONS_COUNT = 200;

// Debugging
var config bool bDebug;

// Weapons List to be loaded from Config File
var config LoadedWeapon aWeapon[WEAPONS_COUNT];

var LoadedWeapon Weapon[WEAPONS_COUNT];

replication
{
  reliable if (Role == ROLE_Authority)
                bDebug,
                aWeapon, Weapon;
}

simulated function PostBeginPlay()
{
  if(bDebug) MutLog("-----|| class'Helper'.static.PrintDefaultStats(bDebug) ||-----");
  class'Helper'.static.PrintDefaultStats(bDebug);

  // Timer set to 3 to give some time for client var replication
  setTimer(3, false);
}

simulated function Timer()
{
  local int Count;

  // Get Count + Vars to Client
  Count = GetServerVars();

  // Trigger Weapon Modification
  if(Count > 0) ModifyWeapon(Count);
  else MutLog("-----|| 0 Weapons Found in Config - Aborting ||-----");
}

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(int TmpCount)
{
  local int i, MaxAmmo, MagCapacity, AmmoCost, DamageMax, AltFireDamageMax, ImpactDamage, Weight, Cost, InventoryGroup, ProjPerFire;
  local float HeadShotDamageMult, Spread, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;

  local class<KFWeapon> CurrentWeapon;
  local class<KFWeaponPickup> CurrentWeaponPickup;
  local class<KFAmmunition> CurrentWeaponMaxAmmo;

  // Primary Fire
  local class<KFFire> CurrentWeaponFire;
  local class<KFShotgunFire> CurrentWeaponShotgunFire;
  local class<KFMeleeFire> CurrentWeaponKFMeleeFire;
  local class<KFHighROFFire> CurrentWeaponKFHighROFFire;

  local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;
  local class<DamTypeM79Grenade> CurrentWeaponM79DmgType;
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
        if(bDebug) MutLog("-----|| Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Modify Weapon AltFireDamage
        if(CurrentWeapon.default.FireModeClass[1] != none
          && string(CurrentWeapon.default.FireModeClass[1]) != "KFMod.NoFire"
          && Weapon[i].iAltFireDamageMax >= 0)
        {
          AltFireDamageMax = ModifyAltFireDmg(string(CurrentWeapon.default.FireModeClass[1]), Weapon[i].iAltFireDamageMax);
        }

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponFire.default.AmmoClass), class'Class'));

        if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Standard Weapon");

        // WeaponFire Class Related Changes
        if(Weapon[i].iDamageMax >= 0) CurrentWeaponFire.default.DamageMax = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread >= 0) CurrentWeaponFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].fFireRate >= 0) CurrentWeaponFire.default.FireRate = Weapon[i].fFireRate;
        if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
        DamageMax = CurrentWeaponFire.default.DamageMax;
        Spread = CurrentWeaponFire.default.Spread;
        FireRate = CurrentWeaponFire.default.FireRate;
        FireAnimRate = CurrentWeaponFire.default.FireAnimRate;

        // Max Ammo Change
        if(Weapon[i].iMaxAmmo >= 0) CurrentWeaponMaxAmmo.default.MaxAmmo = Weapon[i].iMaxAmmo;
        // Just logging
        MaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

        // DmgType Class Related Changes
        if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
        }
        else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.AmmoClass), class'Class'));

        if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        if(Weapon[i].iDamageMax >= 0) CurrentWeaponKFHighROFFire.default.DamageMax = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread >= 0) CurrentWeaponKFHighROFFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].fFireRate >= 0) CurrentWeaponKFHighROFFire.default.FireRate = Weapon[i].fFireRate;
        if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponKFHighROFFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
        DamageMax = CurrentWeaponKFHighROFFire.default.DamageMax;
        Spread = CurrentWeaponKFHighROFFire.default.Spread;
        FireRate = CurrentWeaponKFHighROFFire.default.FireRate;
        FireAnimRate = CurrentWeaponKFHighROFFire.default.FireAnimRate;

        // Max Ammo Change
        if(Weapon[i].iMaxAmmo >= 0) CurrentWeaponMaxAmmo.default.MaxAmmo = Weapon[i].iMaxAmmo;
        // Just logging
        MaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

        // DmgType Class Related Changes
        if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
        }

        else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        if(Weapon[i].iDamageMax >= 0) CurrentWeaponKFMeleeFire.default.MeleeDamage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread >= 0) CurrentWeaponKFMeleeFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].fFireRate >= 0) CurrentWeaponKFMeleeFire.default.FireRate = Weapon[i].fFireRate;
        if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponKFMeleeFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
        DamageMax = CurrentWeaponKFMeleeFire.default.MeleeDamage;
        Spread = CurrentWeaponKFMeleeFire.default.Spread;
        FireRate = CurrentWeaponKFMeleeFire.default.FireRate;
        FireAnimRate = CurrentWeaponKFMeleeFire.default.FireAnimRate;

        // DmgType Class Related Changes
        if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponDamTypeMelee.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        HeadShotDamageMult = CurrentWeaponDamTypeMelee.default.HeadShotDamageMult;
        }

        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.AmmoClass), class'Class'));

        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none
        && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none
        && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none)
        {
          CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          if (class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class')) != none )
          {
            CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));
            // DmgType Class Related Changes
            if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
          }
          else if (class<DamTypeM79Grenade>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class')) != none)
          {
            CurrentWeaponM79DmgType = class<DamTypeM79Grenade>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));
            // DmgType Class Related Changes
            if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponM79DmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            HeadShotDamageMult = CurrentWeaponM79DmgType.default.HeadShotDamageMult;
          }

          if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
          if(bDebug) MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

          // WeaponFire Class Related Changes
          if(Weapon[i].iDamageMax >= 0) CurrentWeaponProjectile.default.Damage = Weapon[i].iDamageMax;
          if(Weapon[i].fSpread >= 0) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
          if(Weapon[i].iProjPerFire >= 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
          if(Weapon[i].fFireRate >= 0) CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
          if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
          DamageMax = CurrentWeaponProjectile.default.Damage;
          Spread = CurrentWeaponShotgunFire.default.Spread;
          ProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
          FireRate = CurrentWeaponShotgunFire.default.FireRate;
          FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // Max Ammo Change
          if(Weapon[i].iMaxAmmo >= 0) CurrentWeaponMaxAmmo.default.MaxAmmo = Weapon[i].iMaxAmmo;
          // Just logging
          MaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

          // For classes that are either: CrossbowArrow, M99Bullet CrossbuzzsawBlade
          // Or children of said classes, we have a different HeadShotMultiplier
          if (ClassIsChildOf(CurrentWeaponProjectile, class'CrossbuzzsawBlade'))
          {
            if(bDebug) MutLog("       >Has Special HeadShot Implementation (CrossBuzzsawBlade)");
            if(Weapon[i].fHeadShotDamageMult >= 0) class<CrossbuzzsawBlade>(CurrentWeaponProjectile).default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            HeadShotDamageMult = class<CrossbuzzsawBlade>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
          else if (ClassIsChildOf(CurrentWeaponProjectile, class'CrossbowArrow'))
          {
            if(bDebug) MutLog("       >Has Special HeadShot Implementation (CrossbowArrow)");
            if(Weapon[i].fHeadShotDamageMult >= 0) class<CrossbowArrow>(CurrentWeaponProjectile).default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            HeadShotDamageMult = class<CrossbowArrow>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
          else if (ClassIsChildOf(CurrentWeaponProjectile, class'M99Bullet'))
          {
            if(bDebug) MutLog("       >Has Special HeadShot Implementation (M99Bullet)");
            if(Weapon[i].fHeadShotDamageMult >= 0) class<M99Bullet>(CurrentWeaponProjectile).default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
            HeadShotDamageMult = class<M99Bullet>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

        if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
        if(bDebug) MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

        // WeaponFire Class Related Changes
        if(Weapon[i].iDamageMax >= 0) CurrentWeaponShotgunBullet.default.Damage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread >= 0) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].iProjPerFire >= 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
        if(Weapon[i].fFireRate >= 0) CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
        if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
        DamageMax = CurrentWeaponShotgunBullet.default.Damage;
        Spread = CurrentWeaponShotgunFire.default.Spread;
        ProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
        FireRate = CurrentWeaponShotgunFire.default.FireRate;
        FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

        // Max Ammo Change
        if(Weapon[i].iMaxAmmo >= 0) CurrentWeaponMaxAmmo.default.MaxAmmo = Weapon[i].iMaxAmmo;
        // Just logging
        MaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

        // DmgType Class Related Changes
        if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponShotgunBullet.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        HeadShotDamageMult = CurrentWeaponShotgunBullet.default.HeadShotDamageMult;

        }
        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponLAWProj.default.ImpactDamageType), class'Class'));

        if(bDebug) MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A LAW-Proj Class");
        if(bDebug) MutLog("       >Special Class: " $string(CurrentWeaponLAWProj));

        // WeaponFire Class Related Changes
        if(Weapon[i].iDamageMax >= 0) CurrentWeaponLAWProj.default.Damage = Weapon[i].iDamageMax;
        if(Weapon[i].fSpread >= 0) CurrentWeaponShotgunFire.default.Spread = Weapon[i].fSpread;
        if(Weapon[i].iProjPerFire >= 0) CurrentWeaponShotgunFire.default.ProjPerFire = Weapon[i].iProjPerFire;
        if(Weapon[i].iImpactDamage >= 0) CurrentWeaponLAWProj.default.ImpactDamage = Weapon[i].iImpactDamage;
        if(Weapon[i].fFireRate >= 0) CurrentWeaponShotgunFire.default.FireRate = Weapon[i].fFireRate;
        if(Weapon[i].fFireAnimRate >= 0) CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].fFireAnimRate;
        DamageMax = CurrentWeaponLAWProj.default.Damage;
        Spread = CurrentWeaponShotgunFire.default.Spread;
        ProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
        ImpactDamage = CurrentWeaponLAWProj.default.ImpactDamage;
        FireRate = CurrentWeaponShotgunFire.default.FireRate;
        FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

        // Max Ammo Change
        if(Weapon[i].iMaxAmmo >= 0) CurrentWeaponMaxAmmo.default.MaxAmmo = Weapon[i].iMaxAmmo;
        // Just logging
        MaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

        // DmgType Class Related Changes
        if(Weapon[i].fHeadShotDamageMult >= 0) CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].fHeadShotDamageMult;
        HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
            }
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        if(Weapon[i].iWeight >= 0) CurrentWeapon.default.Weight = Weapon[i].iWeight;
        if(Weapon[i].iInventoryGroup >= 0) CurrentWeapon.default.InventoryGroup = Weapon[i].iInventoryGroup;
        // Ignore if current weapon is a Melee
        if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
            if(Weapon[i].iMagCapacity >= 0) CurrentWeapon.default.MagCapacity = Weapon[i].iMagCapacity;
            MagCapacity = CurrentWeapon.default.MagCapacity;
            if(Weapon[i].fReloadRate >= 0) CurrentWeapon.default.ReloadRate = Weapon[i].fReloadRate;
            ReloadRate = CurrentWeapon.default.ReloadRate;
            if(Weapon[i].fReloadAnimRate >= 0) CurrentWeapon.default.ReloadAnimRate = Weapon[i].fReloadAnimRate;
            ReloadAnimRate = CurrentWeapon.default.ReloadAnimRate;
        }

        // PickUp Class Related Changes
        if(Weapon[i].iWeight >= 0) CurrentWeaponPickup.default.Weight = Weapon[i].iWeight;
        Weight = CurrentWeaponPickup.default.Weight;
        if(Weapon[i].iCost >= 0) CurrentWeaponPickup.default.cost = Weapon[i].iCost;
        Cost = CurrentWeaponPickup.default.cost;
        if(Weapon[i].iAmmoCost >= 0) CurrentWeaponPickup.default.AmmoCost = Weapon[i].iAmmoCost;
        AmmoCost = CurrentWeaponPickup.default.AmmoCost;

        if(bDebug){
          MutLog("-----|| ClassName: "$Weapon[i].sWeaponClassName$" ||-----");
          MutLog("-----|| InventoryGroup: "$InventoryGroup$" ||-----");
          MutLog("-----|| MaxAmmo: "$MaxAmmo$" ||-----");
          MutLog("-----|| MagCapacity: "$MagCapacity$" ||-----");
          MutLog("-----|| AmmoCost: "$AmmoCost$" ||-----");
          MutLog("-----|| DamageMax: "$DamageMax$" ||-----");
          MutLog("-----|| AltFireDamageMax: "$AltFireDamageMax$" ||-----");
          MutLog("-----|| ImpactDamage: "$ImpactDamage$" ||-----");
          MutLog("-----|| Weight: "$Weight$" ||-----");
          MutLog("-----|| Cost: "$Cost$" ||-----");
          MutLog("-----|| HeadShotDamageMult: "$HeadShotDamageMult$" ||-----");
          MutLog("-----|| Spread: "$Spread$" ||-----");
          MutLog("-----|| ProjPerFire: "$ProjPerFire$" ||-----");
          MutLog("-----|| FireRate: "$FireRate$" ||-----");
          MutLog("-----|| FireAnimRate: "$FireAnimRate$" ||-----");
          MutLog("-----|| ReloadRate: "$ReloadRate$" ||-----");
          MutLog("-----|| ReloadAnimRate: "$ReloadAnimRate$" ||-----");
        }
      }
    }
}

simulated function int ModifyAltFireDmg(string AltFireClass, int AltFireDamage)
{
  // AltFire, if it exists
  local class<KFFire> CurrentWeaponAltFire;
  local class<KFShotgunFire> CurrentWeaponShotgunAltFire;
  local class<KFMeleeFire> CurrentWeaponKFMeleeAltFire;
  local class<KFHighROFFire> CurrentWeaponKFHighROFAltFire;

  // IfDamage isn't in the base AltFireClass
  local class<Projectile> CurrentWeaponProjectile;
  local class<ShotgunBullet> CurrentWeaponShotgunBullet;
  local class<LAWProj> CurrentWeaponLAWProj;

  if (class<KFFire>(DynamicLoadObject(AltFireClass, class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(AltFireClass, class'Class')) == none)
  {
    CurrentWeaponAltFire = class<KFFire>(DynamicLoadObject(AltFireClass, class'Class'));
    CurrentWeaponAltFire.default.DamageMax = AltFireDamage;
    return CurrentWeaponAltFire.default.DamageMax;
  }
  else if (class<KFHighROFFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponKFHighROFAltFire = class<KFHighROFFire>(DynamicLoadObject(AltFireClass, class'Class'));
    CurrentWeaponKFHighROFAltFire.default.DamageMax = AltFireDamage;
    return CurrentWeaponKFHighROFAltFire.default.DamageMax;
  }
  else if (class<KFMeleeFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponKFMeleeAltFire = class<KFMeleeFire>(DynamicLoadObject(AltFireClass, class'Class'));
    CurrentWeaponKFMeleeAltFire.default.MeleeDamage = AltFireDamage;
    return CurrentWeaponKFMeleeAltFire.default.MeleeDamage;
  }
  else if (class<KFShotgunFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponShotgunAltFire = class<KFShotgunFire>(DynamicLoadObject(AltFireClass, class'Class'));

    if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none
      && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) == none
      && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) == none)
      {
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
        CurrentWeaponProjectile.default.Damage = AltFireDamage;
        return CurrentWeaponProjectile.default.Damage;
      }
    else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none)
    {
      CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
      CurrentWeaponShotgunBullet.default.Damage = AltFireDamage;
      return CurrentWeaponShotgunBullet.default.Damage;
    }
    else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none)
    {
      CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
      CurrentWeaponLAWProj.default.Damage = AltFireDamage;
      return CurrentWeaponLAWProj.default.Damage;
    }
  }
}

simulated function int GetServerVars()
{
  local int i;
  local int count; // To avoid running loops over WEAPONS_COUNT, just get the count of actual array entry

  if(bDebug) MutLog("-----|| GetServerVars(); ||-----");

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
  FriendlyName="Weapon Stats Configurator - v2.6"
  Description="Change Standard & Custom Weapon Stats; By Vel-San, dkanus & NikC"
}