class Helper extends Object
  config(WeaponStat_Config);

var config array<string> PrintStatsFor;

// Print all default values for weapons in default.PrintStatsFor array from the config
static function PrintDefaultStats(optional bool bDebug)
{
  local int i;
  local string sReadyMadeConfig;
  local array<WeaponStatConfig.LoadedWeapon> DefaultStats;

  local class<KFWeapon> CurrentWeapon;
  local class<KFWeaponPickup> CurrentWeaponPickup;
  local class<KFAmmunition> CurrentWeaponMaxAmmo;

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

      MutLog("############## " $string(CurrentWeapon)$ " | " $CurrentWeaponPickup.default.ItemName$ " ##############");
      DefaultStats[i].sWeaponClassName = string(CurrentWeapon);

      // Modify Weapon AltFireDamage
      if(CurrentWeapon.default.FireModeClass[1] != none
        && string(CurrentWeapon.default.FireModeClass[1]) != "KFMod.NoFire")
      {
        DefaultStats[i].iAltFireDamageMax = ModifyAltFireDmg(string(CurrentWeapon.default.FireModeClass[1]));
      }
      else
      {
        DefaultStats[i].iAltFireDamageMax = 0;
      }

      // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
      if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none)
      {
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponFire.default.AmmoClass), class'Class'));

        // WeaponFire Class Related Changes
        DefaultStats[i].iDamageMax = CurrentWeaponFire.default.DamageMax;
        DefaultStats[i].fSpread = CurrentWeaponFire.default.Spread;
        DefaultStats[i].fFireRate = CurrentWeaponFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponFire.default.FireAnimRate;

        // Max Ammo
        DefaultStats[i].iMaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

        // DmgType Class Related Changes
        DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

      }

      else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.AmmoClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        DefaultStats[i].iDamageMax = CurrentWeaponKFHighROFFire.default.DamageMax;
        DefaultStats[i].fSpread = CurrentWeaponKFHighROFFire.default.Spread;
        DefaultStats[i].fFireRate = CurrentWeaponKFHighROFFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponKFHighROFFire.default.FireAnimRate;

        // Max Ammo
        DefaultStats[i].iMaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

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
        DefaultStats[i].fSpread = CurrentWeaponKFMeleeFire.default.Spread;
        DefaultStats[i].fFireRate = CurrentWeaponKFMeleeFire.default.FireRate;
        DefaultStats[i].fFireAnimRate = CurrentWeaponKFMeleeFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDamTypeMelee.default.HeadShotDamageMult;
      }

      else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponMaxAmmo = class<KFAmmunition>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.AmmoClass), class'Class'));

        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none)
        {
          CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
           if (class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class')) != none )
          {
            CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));
            // DmgType Class Related Changes
            DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
          }
          else if (class<DamTypeM79Grenade>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class')) != none)
          {
            CurrentWeaponM79DmgType = class<DamTypeM79Grenade>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));
            // DmgType Class Related Changes
            DefaultStats[i].fHeadShotDamageMult = CurrentWeaponM79DmgType.default.HeadShotDamageMult;
          }

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
          MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponProjectile.default.Damage;
          DefaultStats[i].fSpread = CurrentWeaponShotgunFire.default.Spread;
          DefaultStats[i].iProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // Max Ammo
          DefaultStats[i].iMaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

          // For classes that are either: CrossbowArrow, M99Bullet CrossbuzzsawBlade
          // Or children of said classes, we have a different HeadShotMultiplier
          if (ClassIsChildOf(CurrentWeaponProjectile, class'CrossbuzzsawBlade'))
          {
            MutLog("       >Has Special HeadShot Implementation (CrossBuzzsawBlade)");
            DefaultStats[i].fHeadShotDamageMult = class<CrossbuzzsawBlade>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
          else if (ClassIsChildOf(CurrentWeaponProjectile, class'CrossbowArrow'))
          {
            MutLog("       >Has Special HeadShot Implementation (CrossbowArrow)");
            DefaultStats[i].fHeadShotDamageMult = class<CrossbowArrow>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
          else if (ClassIsChildOf(CurrentWeaponProjectile, class'M99Bullet'))
          {
            MutLog("       >Has Special HeadShot Implementation (M99Bullet)");
            DefaultStats[i].fHeadShotDamageMult = class<M99Bullet>(CurrentWeaponProjectile).default.HeadShotDamageMult;
          }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none)
        {
          CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
          MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponShotgunBullet.default.Damage;
          DefaultStats[i].fSpread = CurrentWeaponShotgunFire.default.Spread;
          DefaultStats[i].iProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // Max Ammo
          DefaultStats[i].iMaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

          // DmgType Class Related Changes
          DefaultStats[i].fHeadShotDamageMult = CurrentWeaponShotgunBullet.default.HeadShotDamageMult;

        }

        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none)
        {
          CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
          CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponLAWProj.default.ImpactDamageType), class'Class'));

          MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A LAW-Proj Class");
          MutLog("       >Special Class: " $string(CurrentWeaponLAWProj));

          // WeaponFire Class Related Changes
          DefaultStats[i].iDamageMax = CurrentWeaponLAWProj.default.Damage;
          DefaultStats[i].fSpread = CurrentWeaponShotgunFire.default.Spread;
          DefaultStats[i].iProjPerFire = CurrentWeaponShotgunFire.default.ProjPerFire;
          DefaultStats[i].iImpactDamage = CurrentWeaponLAWProj.default.ImpactDamage;
          DefaultStats[i].fFireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].fFireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // Max Ammo
          DefaultStats[i].iMaxAmmo = CurrentWeaponMaxAmmo.default.MaxAmmo;

          // DmgType Class Related Changes
          DefaultStats[i].fHeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

        }
      }

      // Vars Shared among all weapons the same, no need to condition-check
      // Base Class Related Changes
      DefaultStats[i].iWeight = CurrentWeapon.default.Weight;
      DefaultStats[i].iInventoryGroup = CurrentWeapon.default.InventoryGroup;

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
    }
  }

  MutLog("-----|| Below is a Ready-Made config of your loaded weapons ||-----");
  for(i=0; i < DefaultStats.Length; i++)
  {
    // Generate a copy-paste ready config for this weapon, with default variables
    sReadyMadeConfig = "";
    sReadyMadeConfig $= "aWeapon["$i$"]=(sWeaponClassName="$DefaultStats[i].sWeaponClassName$",iInventoryGroup="$DefaultStats[i].iInventoryGroup$",iWeight="$DefaultStats[i].iWeight$",iCost="$DefaultStats[i].iCost$",iDamageMax="$DefaultStats[i].iDamageMax$",iAltFireDamageMax="$DefaultStats[i].iAltFireDamageMax$",iMaxAmmo="$DefaultStats[i].iMaxAmmo$",iMagCapacity="$DefaultStats[i].iMagCapacity$",iAmmoCost="$DefaultStats[i].iAmmoCost$",iImpactDamage="$DefaultStats[i].iImpactDamage$",iProjPerFire="$DefaultStats[i].iProjPerFire$",fHeadShotDamageMult="$DefaultStats[i].fHeadShotDamageMult$",fSpread="$DefaultStats[i].fSpread$",fFireRate="$DefaultStats[i].fFireRate$",fFireAnimRate="$DefaultStats[i].fFireAnimRate$",fReloadRate="$DefaultStats[i].fReloadRate$",fReloadAnimRate="$DefaultStats[i].fReloadAnimRate$")";
    MutLog(sReadyMadeConfig);
  }
}

static function int ModifyAltFireDmg(string AltFireClass)
{
  local int AltFireDamage;

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
    AltFireDamage = CurrentWeaponAltFire.default.DamageMax;
  }
  else if (class<KFHighROFFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponKFHighROFAltFire = class<KFHighROFFire>(DynamicLoadObject(AltFireClass, class'Class'));
    AltFireDamage = CurrentWeaponKFHighROFAltFire.default.DamageMax;
  }
  else if (class<KFMeleeFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponKFMeleeAltFire = class<KFMeleeFire>(DynamicLoadObject(AltFireClass, class'Class'));
    AltFireDamage = CurrentWeaponKFMeleeAltFire.default.MeleeDamage;
  }
  else if (class<KFShotgunFire>(DynamicLoadObject(AltFireClass, class'Class')) != none)
  {
    CurrentWeaponShotgunAltFire = class<KFShotgunFire>(DynamicLoadObject(AltFireClass, class'Class'));

    if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none
      && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) == none
      && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) == none)
      {
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
        AltFireDamage = CurrentWeaponProjectile.default.Damage;
      }
    else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none)
    {
      CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
      AltFireDamage = CurrentWeaponShotgunBullet.default.Damage;
    }
    else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class')) != none)
    {
      CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunAltFire.default.ProjectileClass), class'Class'));
      AltFireDamage = CurrentWeaponLAWProj.default.Damage;
    }
  }
  return AltFireDamage;
}


static function MutLog(string s)
{
  log(s, 'WeaponStatsConfig');
}


defaultproperties{}