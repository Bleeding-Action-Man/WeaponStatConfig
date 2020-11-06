class Helper extends Object
  config(KFWeaponStatConfig);


var config array<string> PrintStatsFor;


// Print all default values for weapons in default.PrintStatsFor array from the config
static function PrintDefaultStats(optional bool bDEBUG)
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
  if (!bDEBUG)
    return;

  MutLog("-----|| Analyzing Default Weapons ||-----");

  DefaultStats.Length = 89;

  for (i=0; i<default.PrintStatsFor.Length; i++)
  {
    // Exit if Weapon Class Not Found
    if (class<KFWeapon>(DynamicLoadObject(default.PrintStatsFor[i], class'Class')) != none)
    {
      CurrentWeapon = class<KFWeapon>(DynamicLoadObject(default.PrintStatsFor[i], class'Class'));
      CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

      MutLog("############## " $string(CurrentWeapon)$ " ##############");
      DefaultStats[i].WeaponClassName = string(CurrentWeapon);

      // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
      if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none)
      {
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // WeaponFire Class Related Changes
        DefaultStats[i].DamageMax = CurrentWeaponFire.default.DamageMax;
        DefaultStats[i].FireRate = CurrentWeaponFire.default.FireRate;
        DefaultStats[i].FireAnimRate = CurrentWeaponFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

      }

      else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        DefaultStats[i].DamageMax = CurrentWeaponKFHighROFFire.default.DamageMax;
        DefaultStats[i].FireRate = CurrentWeaponKFHighROFFire.default.FireRate;
        DefaultStats[i].FireAnimRate = CurrentWeaponKFHighROFFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;
      }

      else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none)
      {
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        DefaultStats[i].DamageMax = CurrentWeaponKFMeleeFire.default.MeleeDamage;
        DefaultStats[i].FireRate = CurrentWeaponKFMeleeFire.default.FireRate;
        DefaultStats[i].FireAnimRate = CurrentWeaponKFMeleeFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].HeadShotDamageMult = CurrentWeaponDamTypeMelee.default.HeadShotDamageMult;
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
          DefaultStats[i].DamageMax = CurrentWeaponProjectile.default.Damage;
          DefaultStats[i].FireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

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
          DefaultStats[i].DamageMax = CurrentWeaponShotgunBullet.default.Damage;
          DefaultStats[i].FireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

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
          DefaultStats[i].DamageMax = CurrentWeaponLAWProj.default.Damage;
          DefaultStats[i].ImpactDamage = CurrentWeaponLAWProj.default.ImpactDamage;
          DefaultStats[i].FireRate = CurrentWeaponShotgunFire.default.FireRate;
          DefaultStats[i].FireAnimRate = CurrentWeaponShotgunFire.default.FireAnimRate;

          // DmgType Class Related Changes
          DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

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
      DefaultStats[i].Weight = CurrentWeapon.default.Weight;

      // Ignore if current weapon is a Melee
      if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none)
      {
        DefaultStats[i].MagCapacity = CurrentWeapon.default.MagCapacity;
        DefaultStats[i].ReloadRate = CurrentWeapon.default.ReloadRate;
        DefaultStats[i].ReloadAnimRate = CurrentWeapon.default.ReloadAnimRate;
      }

      // PickUp Class Related Changes
      DefaultStats[i].Weight = CurrentWeaponPickup.default.Weight;
      DefaultStats[i].Cost = CurrentWeaponPickup.default.cost;
      DefaultStats[i].AmmoCost = CurrentWeaponPickup.default.AmmoCost;

      MutLog("-----|| DEBUG ClassName: "$DefaultStats[i].WeaponClassName$" ||-----");
      MutLog("-----|| DEBUG MagCapacity: "$DefaultStats[i].MagCapacity$" ||-----");
      MutLog("-----|| DEBUG AmmoCost: "$DefaultStats[i].AmmoCost$" ||-----");
      MutLog("-----|| DEBUG DamageMax: "$DefaultStats[i].DamageMax$" ||-----");
      MutLog("-----|| DEBUG ImpactDamage: "$DefaultStats[i].ImpactDamage$" ||-----");
      MutLog("-----|| DEBUG Weight: "$DefaultStats[i].Weight$" ||-----");
      MutLog("-----|| DEBUG Cost: "$DefaultStats[i].Cost$" ||-----");
      MutLog("-----|| DEBUG HeadShotDamageMult: "$DefaultStats[i].HeadShotDamageMult$" ||-----");
      MutLog("-----|| DEBUG FireRate: "$DefaultStats[i].FireRate$" ||-----");
      MutLog("-----|| DEBUG FireAnimRate: "$DefaultStats[i].FireAnimRate$" ||-----");
      MutLog("-----|| DEBUG ReloadRate: "$DefaultStats[i].ReloadRate$" ||-----");
      MutLog("-----|| DEBUG ReloadAnimRate: "$DefaultStats[i].ReloadAnimRate$" ||-----");
    }
  }
}


static function MutLog(string s)
{
  log(s, 'WeaponStatsConfig');
}


defaultproperties{}