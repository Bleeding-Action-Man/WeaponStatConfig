//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator
  config(KFWeaponStatConfig);


struct LoadedWeapon
{
  var config string WeaponClassName;
  var config int MagCapacity, AmmoCost, DamageMax, ImpactDamage, Weight, Cost;
  var config float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
};

// Debugging
var config bool bDEBUG;

// Weapons Count
// KFMod Class Weapons Count: 54, taken from here: http://wiki.tripwireinteractive.com/index.php/Weapons_(Killing_Floor)
// All Official Weapons Count: 85, taken from here: http://kf-wiki.com/wiki/Inventory_system
// 150 is set as a safe-guard. If we need more I'll make it 150+
const WEAPONS_COUNT = 150;

// Weapons List
var() config string StandardWeapons[WEAPONS_COUNT];
var string replicatedList[WEAPONS_COUNT];
var array<LoadedWeapon> ActualStandardWeapons;

replication
{
  unreliable if (Role == ROLE_Authority)
                  bDEBUG,
                  replicatedList,
                  StandardWeapons;
}


simulated function PostBeginPlay()
{
  local int i;

  for (i=0; i<WEAPONS_COUNT; i++)
  {
    replicatedList[i] = StandardWeapons[i];
  }

  MutLog("TESTINNNNNNNNNNNNNNNNNNNNNNNNNNNNG! KFWeaponStatConfig -> class'Helper'.static.PrintDefaultStats(bDEBUG)");
  class'Helper'.static.PrintDefaultStats(bDEBUG);
}


simulated function PostNetBeginPlay()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
  GetServerVars();
  SetTimer(1, false);
}


simulated function Timer()
{
  MutLog("TESTINNNNNNNNNNNNNNNNNNNNNNNNNNNNG! KFWeaponStatConfig -> Timer()");
  ModifyWeapon(ActualStandardWeapons);
}


// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(array<LoadedWeapon> Weapon)
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

  if (Weapon.Length == 0)
  {
    MutLog("ModifyWeapon(ActualStandardWeapons) -> ActualStandardWeapons was none!!");
  }

  MutLog("-----|| Analyzing Configurations ||-----");

  for (i=0; i<Weapon.Length; i++)
  {
      // Exit if Weapon Class Not Found
      if(class<KFWeapon>(DynamicLoadObject(Weapon[i].WeaponClassName, class'Class')) != none)
      {
        CurrentWeapon = class<KFWeapon>(DynamicLoadObject(Weapon[i].WeaponClassName, class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

        // Log for Currently Detected Weapon
        MutLog("-----|| Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Standard Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = Weapon[i].DamageMax;
        CurrentWeaponFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;

        }
        else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFHighROFFire = class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponKFHighROFFire.default.DamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a High-Fire-Rate Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFHighROFFire.default.DamageMax = Weapon[i].DamageMax;
        CurrentWeaponKFHighROFFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponKFHighROFFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
        }

        else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponKFMeleeFire = class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDamTypeMelee = class<DamTypeMelee>(DynamicLoadObject(string(CurrentWeaponKFMeleeFire.default.hitDamageClass), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " is a Melee Weapon");

        // WeaponFire Class Related Changes
        CurrentWeaponKFMeleeFire.default.MeleeDamage = Weapon[i].DamageMax;
        CurrentWeaponKFMeleeFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponKFMeleeFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDamTypeMelee.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
        }

        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
        MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

        // WeaponFire Class Related Changes
        CurrentWeaponProjectile.default.Damage = Weapon[i].DamageMax;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
            }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
        MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

        // WeaponFire Class Related Changes
        CurrentWeaponShotgunBullet.default.Damage = Weapon[i].DamageMax;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TO-DO
        // Add Switch statement to manually change HeadShotDamageMult like the above switch
        }
        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponLAWProj = class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponLAWProj.default.ImpactDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A LAW-Proj Class");
        MutLog("       >Special Class: " $string(CurrentWeaponLAWProj));

        // WeaponFire Class Related Changes
        CurrentWeaponLAWProj.default.Damage = Weapon[i].DamageMax;
        CurrentWeaponLAWProj.default.ImpactDamage = Weapon[i].ImpactDamage;
        CurrentWeaponShotgunFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TO-DO
        // Add Switch statement to manually change HeadShotDamageMult like the above switch
            }
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        CurrentWeapon.default.Weight = Weapon[i].Weight;
        // Ignore if current weapon is a Melee
        if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
            CurrentWeapon.default.MagCapacity = Weapon[i].MagCapacity;
            CurrentWeapon.default.ReloadRate = Weapon[i].ReloadRate;
            CurrentWeapon.default.ReloadAnimRate = Weapon[i].ReloadAnimRate;
        }

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = Weapon[i].Weight;
        CurrentWeaponPickup.default.cost = Weapon[i].Cost;
        CurrentWeaponPickup.default.AmmoCost = Weapon[i].AmmoCost;

        if (bDEBUG){
          MutLog("-----|| bDEBUG ClassName: "$Weapon[i].WeaponClassName$" ||-----");
          MutLog("-----|| bDEBUG MagCapacity: "$Weapon[i].MagCapacity$" ||-----");
          MutLog("-----|| bDEBUG AmmoCost: "$Weapon[i].AmmoCost$" ||-----");
          MutLog("-----|| bDEBUG DamageMax: "$Weapon[i].DamageMax$" ||-----");
          MutLog("-----|| bDEBUG ImpactDamage: "$Weapon[i].ImpactDamage$" ||-----");
          MutLog("-----|| bDEBUG Weight: "$Weapon[i].Weight$" ||-----");
          MutLog("-----|| bDEBUG Cost: "$Weapon[i].Cost$" ||-----");
          MutLog("-----|| bDEBUG HeadShotDamageMult: "$Weapon[i].HeadShotDamageMult$" ||-----");
          MutLog("-----|| bDEBUG FireRate: "$Weapon[i].FireRate$" ||-----");
          MutLog("-----|| bDEBUG FireAnimRate: "$Weapon[i].FireAnimRate$" ||-----");
          MutLog("-----|| bDEBUG ReloadRate: "$Weapon[i].ReloadRate$" ||-----");
          MutLog("-----|| bDEBUG ReloadAnimRate: "$Weapon[i].ReloadAnimRate$" ||-----");
        }
      }
    }
}


simulated function GetServerVars()
{
  local string WeaponClassName;
  local int i, Count, MagCapacity, AmmoCost, DamageMax, ImpactDamage, Weight, Cost;
  local float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
  local array<string> tempWeaponList;

  MutLog("TESTINNNNNNNNNNNNNNNNNNNNNNNNNNNNG! KFWeaponStatConfig -> GetServerVars();");

  for (i=0; i<WEAPONS_COUNT; i++)
  {
    if (replicatedList[i] != "")
    {
      Count = Count + 1;
    }
  }

  ActualStandardWeapons.Length = Count;
  default.bDEBUG = bDEBUG;

  for (i=0; i<WEAPONS_COUNT; i++)
  {
    if (replicatedList[i] != "")
    {
      MutLog("-----|| Detected Config " $i$ " : "$replicatedList[i]$" ||-----");
      Split(replicatedList[i], ";", tempWeaponList);

      WeaponClassName = tempWeaponList[0];
      MagCapacity = int(tempWeaponList[1]);
      AmmoCost = int(tempWeaponList[2]);
      DamageMax = int(tempWeaponList[3]);
      ImpactDamage = int(tempWeaponList[4]);
      Weight = int(tempWeaponList[5]);
      Cost = int(tempWeaponList[6]);
      HeadShotDamageMult = float(tempWeaponList[7]);
      FireRate = float(tempWeaponList[8]);
      FireAnimRate = float(tempWeaponList[9]);
      ReloadRate = float(tempWeaponList[10]);
      ReloadAnimRate = float(tempWeaponList[11]);

      // TO-DO
      // Implement duplicates detection

      ActualStandardWeapons[i].WeaponClassName = WeaponClassName;
      ActualStandardWeapons[i].MagCapacity = MagCapacity;
      ActualStandardWeapons[i].AmmoCost = AmmoCost;
      ActualStandardWeapons[i].DamageMax = DamageMax;
      ActualStandardWeapons[i].ImpactDamage = ImpactDamage;
      ActualStandardWeapons[i].Weight = Weight;
      ActualStandardWeapons[i].Cost = Cost;
      ActualStandardWeapons[i].HeadShotDamageMult = HeadShotDamageMult;
      ActualStandardWeapons[i].FireRate = FireRate;
      ActualStandardWeapons[i].FireAnimRate = FireAnimRate;
      ActualStandardWeapons[i].ReloadRate = ReloadRate;
      ActualStandardWeapons[i].ReloadAnimRate = ReloadAnimRate;
    }
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
  GroupName="KF-WeaponStatConfig"
  FriendlyName="Weapon Stats Configurator - v1.3"
  Description="Change Weapon Stats on-the-fly! - By Vel-San, dkanus & NikC"

  bAlwaysRelevant=true
  RemoteRole=ROLE_SimulatedProxy
  bAddToServerPackages=true
  bNetNotify=true
}