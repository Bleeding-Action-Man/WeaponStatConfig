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
  var config int MagCapacity, AmmoCost, DamageMax, ImpactDamage, Weight, Cost;
  var config float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
};

// Debugging
var config bool DEBUG;

// Weapons Count
// KFMod Class Weapons Count: 54, taken from here: http://wiki.tripwireinteractive.com/index.php/Weapons_(Killing_Floor)
// All Official Weapons Count: 85, taken from here: http://kf-wiki.com/wiki/Inventory_system
// 150 is set as a safe-guard. If we need more I'll make it 150+
const WEAPONS_COUNT = 150;

// Weapons List
var() config string StandardWeapons[WEAPONS_COUNT];
var array<string> PrintStatsFor;
var string replicatedList[WEAPONS_COUNT];
var array<LoadedWeapon> ActualStandardWeapons;

replication
{
	unreliable if (Role == ROLE_Authority)
                  DEBUG,
                  replicatedList,
                  StandardWeapons;
}

simulated function PostBeginPlay()
{
  local int i;
  for(i=0; i<WEAPONS_COUNT; i++){
    replicatedList[i] = StandardWeapons[i];
  }
  if(DEBUG)
  	PrintStatsFor.Length = 89;
	PrintDefaultStats();
}

simulated function PostNetBeginPlay()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
  GetServerVars();
  SetTimer(1, false);
}

simulated function Timer()
{
  	ModifyWeapon(ActualStandardWeapons);
}

// Print all default values for weapons in PrintStatsFor array from the config
simulated function PrintDefaultStats()
{
	local int i;
	local array<LoadedWeapon> DefaultStats;

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

    MutLog("-----|| Analyzing Default Weapons ||-----");

	DefaultStats.Length = 89;

    for(i=0; i<PrintStatsFor.Length; i++)
    {
      // Exit if Weapon Class Not Found
      if(class<KFWeapon>(DynamicLoadObject(PrintStatsFor[i], class'Class')) != none)
      {
        CurrentWeapon = class<KFWeapon>(DynamicLoadObject(PrintStatsFor[i], class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

		MutLog("############## " $string(CurrentWeapon)$ " ##############");
		DefaultStats[i].WeaponClassName = string(CurrentWeapon);

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none && class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // WeaponFire Class Related Changes
        DefaultStats[i].DamageMax = CurrentWeaponFire.default.DamageMax;
        DefaultStats[i].FireRate = CurrentWeaponFire.default.FireRate;
        DefaultStats[i].FireAnimRate = CurrentWeaponFire.default.FireAnimRate;

        // DmgType Class Related Changes
        DefaultStats[i].HeadShotDamageMult = CurrentWeaponDmgType.default.HeadShotDamageMult;

        }
        else if (class<KFHighROFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
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

        else if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
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

        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none && class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
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
        /*switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
            }*/
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
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
        /*switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
            }*/
        }

        else if (class<LAWProj>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
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
        /*switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;
            }*/
			}
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        DefaultStats[i].Weight = CurrentWeapon.default.Weight;

		// Ignore if current weapon is a Melee
        if (class<KFMeleeFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) == none){
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

    MutLog("-----|| Analyzing Configurations ||-----");

    for(i=0; i<Weapon.Length; i++)
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

        if (DEBUG){
          MutLog("-----|| DEBUG ClassName: "$Weapon[i].WeaponClassName$" ||-----");
          MutLog("-----|| DEBUG MagCapacity: "$Weapon[i].MagCapacity$" ||-----");
          MutLog("-----|| DEBUG AmmoCost: "$Weapon[i].AmmoCost$" ||-----");
          MutLog("-----|| DEBUG DamageMax: "$Weapon[i].DamageMax$" ||-----");
          MutLog("-----|| DEBUG ImpactDamage: "$Weapon[i].ImpactDamage$" ||-----");
          MutLog("-----|| DEBUG Weight: "$Weapon[i].Weight$" ||-----");
          MutLog("-----|| DEBUG Cost: "$Weapon[i].Cost$" ||-----");
          MutLog("-----|| DEBUG HeadShotDamageMult: "$Weapon[i].HeadShotDamageMult$" ||-----");
          MutLog("-----|| DEBUG FireRate: "$Weapon[i].FireRate$" ||-----");
          MutLog("-----|| DEBUG FireAnimRate: "$Weapon[i].FireAnimRate$" ||-----");
          MutLog("-----|| DEBUG ReloadRate: "$Weapon[i].ReloadRate$" ||-----");
          MutLog("-----|| DEBUG ReloadAnimRate: "$Weapon[i].ReloadAnimRate$" ||-----");
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

  for(i=0; i<WEAPONS_COUNT; i++){
    if (replicatedList[i] != ""){
      Count = Count + 1;
    }
  }

  ActualStandardWeapons.Length = Count;
  default.DEBUG = DEBUG;

  for(i=0; i<WEAPONS_COUNT; i++)
  {
    if (replicatedList[i] != ""){
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
    // Mandatory Vars
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=true
    bNetNotify=true

    // Mut Vars
    GroupName="KF-WeaponStatConfig"
    FriendlyName="Weapon Stats Config - v1.3"
    Description="Change Weapon Stats on-the-fly! - By Vel-San & dkanus"

    // Debugging
    DEBUG=false

    // This is a sample config for ones who lost their .ini & are smart enough to decompile and check the source-code ;)
    // Always keep the same order when adding or editing values !!!
    // ClassName; Mag; AmmoCost; DmgMax; ImpactDamage; Weight; Cost; HeadShot Multi; FireRate; FireRate Anim; ReloadRate; ReloadRate Anime
    // FireAnime & ReloadAnime: + To Increase | Low or High Values might break the Animations or make it slow-mo, increase/decrease gradually
    // FireRate & ReloadRate: - To Increase | Low or High Values might break firerate or make it slow-mo, increase/decrease gradually
    // MagCapacity, ReloadRate & ReloadAnimRate are ignored for MeleeWeapons
    // ImpactDamage is only for weapons with Impact such as Rocket Laucnhers (e.g. Demo Weapons)
    // StandardWeapons[0]="KFMod.Single;50;5;700;0;0;0;2.0;0.1;1.5;1;2.5"
    // StandardWeapons[1]="KFMod.Crossbow;12;5;1500;0;1;5;2.0;0.1;2.5;0.1;2.5"
    // StandardWeapons[2]="KFMod.AA12AutoShotgun;35;5;500;0;0;0;2.0;0.175;1.5;1;2.5"
    // StandardWeapons[3]="KFMod.Magnum44Pistol;35;5;500;0;1;0;2.0;0.175;1.5;0.5;2.5"
    // StandardWeapons[4]="KFMod.HuskGun;35;5;500;10;1;0;2.0;0.175;1.5;0.5;2.5"
    // StandardWeapons[5]="KFMod.Knife;50;5;1500;0;0;0;2.0;0.5;1.1;0.175;1.5"
    // StandardWeapons[0]="KFMod.KrissMMedicGun;50;5;700;0;0;0;2.0;0.1;1.5;1;2.5"
	# List below is only meant to generate default stats for weapons. If debug is set to true, stats will be generated
	PrintStatsFor[0]="KFMod.BlowerThrower"
	PrintStatsFor[1]="KFMod.BoomStick"
	PrintStatsFor[2]="KFMod.Bullpup"
	PrintStatsFor[3]="KFMod.BullpupDM"
	PrintStatsFor[4]="KFMod.BullpupSP"
	PrintStatsFor[5]="KFMod.CamoM32GrenadeLauncher"
	PrintStatsFor[6]="KFMod.CamoM4AssaultRifle"
	PrintStatsFor[7]="KFMod.CamoMP5MMedicGun"
	PrintStatsFor[8]="KFMod.CamoShotgun"
	PrintStatsFor[9]="KFMod.Chainsaw"
	PrintStatsFor[10]="KFMod.Claws"
	PrintStatsFor[11]="KFMod.ClaymoreSword"
	PrintStatsFor[12]="KFMod.Crossbow"
	PrintStatsFor[13]="KFMod.CrossbowSP"
	PrintStatsFor[14]="KFMod.Crossbuzzsaw"
	PrintStatsFor[15]="KFMod.Deagle"
	PrintStatsFor[16]="KFMod.Dual44Magnum"
	PrintStatsFor[17]="KFMod.DualDeagle"
	PrintStatsFor[18]="KFMod.DualFlareRevolver"
	PrintStatsFor[19]="KFMod.DualMK23Pistol"
	PrintStatsFor[20]="KFMod.Dualies"
	PrintStatsFor[21]="KFMod.DualiesDM"
	PrintStatsFor[22]="KFMod.DwarfAxe"
	PrintStatsFor[23]="KFMod.FNFAL_ACOG_AssaultRifle"
	PrintStatsFor[24]="KFMod.FakeSyringe"
	PrintStatsFor[25]="KFMod.FlameThrower"
	PrintStatsFor[26]="KFMod.FlareRevolver"
	PrintStatsFor[27]="KFMod.Frag"
	PrintStatsFor[28]="KFMod.GoldenAA12AutoShotgun"
	PrintStatsFor[29]="KFMod.GoldenAK47AssaultRifle"
	PrintStatsFor[30]="KFMod.GoldenBenelliShotgun"
	PrintStatsFor[31]="KFMod.GoldenChainsaw"
	PrintStatsFor[32]="KFMod.GoldenDeagle"
	PrintStatsFor[33]="KFMod.GoldenDualDeagle"
	PrintStatsFor[34]="KFMod.GoldenFlamethrower"
	PrintStatsFor[35]="KFMod.GoldenKatana"
	PrintStatsFor[36]="KFMod.GoldenM79GrenadeLauncher"
	PrintStatsFor[37]="KFMod.Huskgun"
	PrintStatsFor[38]="KFMod.JackhammerAutoShotgun"
	PrintStatsFor[39]="KFMod.KFMedicGun"
	PrintStatsFor[40]="KFMod.KFMeleeGun"
	PrintStatsFor[41]="KFMod.KSGShotgun"
	PrintStatsFor[42]="KFMod.Katana"
	PrintStatsFor[43]="KFMod.KrissMMedicGun"
	PrintStatsFor[44]="KFMod.LAW"
	PrintStatsFor[45]="KFMod.LAWDM"
	PrintStatsFor[46]="KFMod.M14EBRBattleRifle"
	PrintStatsFor[47]="KFMod.M32GrenadeLauncher"
	PrintStatsFor[48]="KFMod.M4203AssaultRifle"
	PrintStatsFor[49]="KFMod.M4AssaultRifle"
	PrintStatsFor[50]="KFMod.M79GrenadeLauncher"
	PrintStatsFor[51]="KFMod.M7A3MMedicGun"
	PrintStatsFor[52]="KFMod.M99SniperRifle"
	PrintStatsFor[53]="KFMod.MAC10MP"
	PrintStatsFor[54]="KFMod.MK23Pistol"
	PrintStatsFor[55]="KFMod.MKb42AssaultRifle"
	PrintStatsFor[56]="KFMod.MP5MMedicGun"
	PrintStatsFor[57]="KFMod.MP7MMedicGun"
	PrintStatsFor[58]="KFMod.Machete"
	PrintStatsFor[59]="KFMod.MachinePistol"
	PrintStatsFor[60]="KFMod.Magnum44Pistol"
	PrintStatsFor[61]="KFMod.NailGun"
	PrintStatsFor[62]="KFMod.NeonAK47AssaultRifle"
	PrintStatsFor[63]="KFMod.NeonKSGShotgun"
	PrintStatsFor[64]="KFMod.NeonKrissMMedicGun"
	PrintStatsFor[65]="KFMod.NeonSCARMK17AssaultRifle"
	PrintStatsFor[66]="KFMod.PipeBombExplosive"
	PrintStatsFor[67]="KFMod.SCARMK17AssaultRifle"
	PrintStatsFor[68]="KFMod.SPAutoShotgun"
	PrintStatsFor[69]="KFMod.SPGrenadeLauncher"
	PrintStatsFor[70]="KFMod.SPSniperRifle"
	PrintStatsFor[71]="KFMod.SPThompsonSMG"
	PrintStatsFor[72]="KFMod.Scythe"
	PrintStatsFor[73]="KFMod.SealSquealHarpoonBomber"
	PrintStatsFor[74]="KFMod.SeekerSixRocketLauncher"
	PrintStatsFor[75]="KFMod.Shotgun"
	PrintStatsFor[76]="KFMod.Single"
	PrintStatsFor[77]="KFMod.StunNade"
	PrintStatsFor[78]="KFMod.Syringe"
	PrintStatsFor[79]="KFMod.ThompsonDrumSMG"
	PrintStatsFor[80]="KFMod.ThompsonSMG"
	PrintStatsFor[81]="KFMod.TrenchGun"
	PrintStatsFor[82]="KFMod.Welder"
	PrintStatsFor[83]="KFMod.Winchester"
	PrintStatsFor[84]="KFMod.WinchesterDM"
	PrintStatsFor[85]="KFMod.ZEDGun"
	PrintStatsFor[86]="KFMod.ZEDMKIIWeapon"
	PrintStatsFor[87]="KFMod.ZedControlDevice"
	PrintStatsFor[88]="KFMod.knife"
}