class Helper extends Object
  config(KFWeaponStatConfig);


var config array<string> PrintStatsFor;


// Print all default values for weapons in default.PrintStatsFor array from the config
static function PrintDefaultStats(optional bool bDebug)
{
  local int i;
  local array<KFWeaponStatConfig.LoadedWeapon> DefaultStats;

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

  // print nothing if we don't want to
  if (!bDebug || default.PrintStatsFor.Length == 0) return;

  DefaultStats.Length = default.PrintStatsFor.Length;

  MutLog("-----|| Analyzing Default Weapons [" $DefaultStats.Length$ "] ||-----");

  for (i=0; i<default.PrintStatsFor.Length; i++)
  {
    // Exit if Weapon Class Not Found
    if (class<KFWeapon>(DynamicLoadObject(default.PrintStatsFor[i], class'Class')) != none)
    {
      CurrentWeapon = class<KFWeapon>(DynamicLoadObject(default.PrintStatsFor[i], class'Class'));
      CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

      MutLog("############## " $string(CurrentWeapon)$ " ##############");
      DefaultStats[i].sWeaponClassName = string(CurrentWeapon);

      // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
      if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none)
      {
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // WeaponFire Class Related Changes
        DefaultStats[i].iDamageMax = CurrentWeaponFire.default.DamageMax;
        DefaultStats[i].fFireRate = CurrentWeaponFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

      }

      else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        DefaultStats[i].iDamageMax = CurrentWeaponKFHighROFFire.default.DamageMax;
        DefaultStats[i].fFireRate = CurrentWeaponKFHighROFFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponKFHighROFFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
      }

      else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        DefaultStats[i].iDamageMax = CurrentWeaponKFMeleeFire.default.MeleeDamage;
        DefaultStats[i].fFireRate = CurrentWeaponKFMeleeFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponKFMeleeFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDamTypeMelee.default.HeadShotDamageMult;
      }

      else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none)
        {
          CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
          MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponProjectile.default.Damage;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

          // TODO: Fix this to be compatible with the above statement
          // switch(GetItemName(string(CurrentWeapon)))
          // {
          //   case "CrossbowArrow":
          //     class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
          // }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none)
        {
          CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
          MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponShotgunBullet.default.Damage;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

          // TODO: Fix this to be compatible with the above statement
          // switch(GetItemName(string(CurrentWeapon)))
          // {
          //   case "CrossbowArrow":
          //     class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
          // }
        }

        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none)
        {
          CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponLAWProj.default.ImpactDamageType), class'Class'));

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A LAW-Proj Class");
          MutLog("       >Special Class: " $string(CurrentWeaponLAWProj));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponLAWProj.default.Damage;
          DefaultStats[i].iImpactDamage = CurrentWeaponLAWProj.default.ImpactDamage;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

          // TODO: Fix this to be compatible with the above statement
          // switch(GetItemName(string(CurrentWeapon)))
          // {
          //   case "CrossbowArrow":
          //     class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
          // }
        }
      }

      // Vars Shared among all weapons the same, no need to condition-check
      // Base Class Related Changes
      DefaultStats[i].iWeight = CurrentWeapon.default.Weight;

      // Ignore if current weapon is a Melee
      if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none)
      {
        DefaultStats[i].iMagCapacity = CurrentWeapon.default.MagCapacity;
        DefaultStats[i].fReloadRate = CurrentWeapon.default.ReloadRate;
        DefaultStats[i].fReloadAnimRate = CurrentWeapon.default.ReloadAnimRate;
      }

      // PickUp Class Related Changes
      DefaultStats[i].iWeight = CurrentWeaponPickup.default.Weight;
      DefaultStats[i].iCost = CurrentWeaponPickup.default.cost;
      DefaultStats[i].iAmmoCost = CurrentWeaponPickup.default.AmmoCost;

      MutLog("-----|| DEBUG - ClassName: "$DefaultStats[i].sWeaponClassName$" ||-----");
      MutLog("-----|| DEBUG - MagCapacity: "$DefaultStats[i].iMagCapacity$" ||-----");
      MutLog("-----|| DEBUG - AmmoCost: "$DefaultStats[i].iAmmoCost$" ||-----");
      MutLog("-----|| DEBUG - DamageMax: "$DefaultStats[i].iDamageMax$" ||-----");
      MutLog("-----|| DEBUG - ImpactDamage: "$DefaultStats[i].iImpactDamage$" ||-----");
      MutLog("-----|| DEBUG - Weight: "$DefaultStats[i].iWeight$" ||-----");
      MutLog("-----|| DEBUG - Cost: "$DefaultStats[i].iCost$" ||-----");
      MutLog("-----|| DEBUG - HeadShotDamageMult: "$DefaultStats[i].fHeadShotDamageMult$" ||-----");
      MutLog("-----|| DEBUG - FireRate: "$DefaultStats[i].fFireRate$" ||-----");
      MutLog("-----|| DEBUG - FireAnimRate: "$DefaultStats[i].fFireAnimRate$" ||-----");
      MutLog("-----|| DEBUG - ReloadRate: "$DefaultStats[i].fReloadRate$" ||-----");
      MutLog("-----|| DEBUG - ReloadAnimRate: "$DefaultStats[i].fReloadAnimRate$" ||-----");
    }
  }
}


static function MutLog(string s)
{
  log(s, 'WeaponStatsConfig');
}


defaultproperties{}