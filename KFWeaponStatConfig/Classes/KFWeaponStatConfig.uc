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

// Debugging
var config bool DEBUG;
// Weapons Count
const WEAPONS_COUNT = 150;
// Weapons List
var() config string StandardWeapons[WEAPONS_COUNT];
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
}

simulated function PostNetBeginPlay()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
  GetServerVars();
  SetTimer(0.1, false);
}

simulated function Timer()
{
  ModifyWeapon(ActualStandardWeapons);
}

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(array<LoadedWeapon> Weapon)
{
    local int i;
    local class<KFWeapon> CurrentWeapon;
    local class<KFFire> CurrentWeaponFire;
    local class<KFShotgunFire> CurrentWeaponShotgunFire;
    local class<KFMeleeFire> CurrentWeaponKFMeleeFire;
    local class<KFWeaponPickup> CurrentWeaponPickup;
    local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;
    local class<Projectile> CurrentWeaponProjectile;
    local class<ShotgunBullet> CurrentWeaponShotgunBullet;

    // TO-DO
    // More vars for ImpactDamage

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
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = Weapon[i].DamageMax;
        CurrentWeaponFire.default.FireRate = Weapon[i].FireRate;
        CurrentWeaponFire.default.FireAnimRate = Weapon[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = Weapon[i].HeadShotDamageMult;

        }
        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
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
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        CurrentWeapon.default.MagCapacity = Weapon[i].MagCapacity;
        CurrentWeapon.default.Weight = Weapon[i].Weight;
        CurrentWeapon.default.ReloadRate = Weapon[i].ReloadRate;
        CurrentWeapon.default.ReloadAnimRate = Weapon[i].ReloadAnimRate;

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = Weapon[i].Weight;
        CurrentWeaponPickup.default.cost = Weapon[i].Cost;

        // DamageType Class Related Changes
        // TO-DO
        // Check For Projectile, WeaponProjectile or LAW.
        // Change DamageMax accordingly because some cases it is
        // connected with ImpactDamage instead of DamageMax e.g. FlareRevolvers
        // P.S: Fuck You TripWireInteractive for these inconsistencies

        if (DEBUG){
          MutLog("-----|| DEBUG ClassName: "$Weapon[i].WeaponClassName$" ||-----");
          MutLog("-----|| DEBUG MagCapacity: "$Weapon[i].MagCapacity$" ||-----");
          MutLog("-----|| DEBUG DamageMax: "$Weapon[i].DamageMax$" ||-----");
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
  local int i, Count, MagCapacity, DamageMax, Weight, Cost;
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
      DamageMax = int(tempWeaponList[2]);
      Weight = int(tempWeaponList[3]);
      Cost = int(tempWeaponList[4]);
      HeadShotDamageMult = float(tempWeaponList[5]);
      FireRate = float(tempWeaponList[6]);
      FireAnimRate = float(tempWeaponList[7]);
      ReloadRate = float(tempWeaponList[8]);
      ReloadAnimRate = float(tempWeaponList[9]);

      // TO-DO
      // Implement duplicates detection

      ActualStandardWeapons[i].WeaponClassName = WeaponClassName;
      ActualStandardWeapons[i].MagCapacity = MagCapacity;
      ActualStandardWeapons[i].DamageMax = DamageMax;
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
    // TO-DO
    // Update version + Description
    GroupName="KF-WeaponStatConfig"
    FriendlyName="Weapon Stat Config - v3.0b"
    Description="Change various weapon stats on-the-fly using a pre-configured file! - By Vel-San"

    // Debugging
    DEBUG=false

    // Always keep the same order when adding or editing values !!!
    // ClassName; Mag; DmgMax; Weight; Cost; HeadShot Multi; FireRate; FireRate Anim; ReloadRate; ReloadRate Anime
    // StandardWeapons(0)="KFMod.Single;50;500;2;0;2.0;0.175;1.5;1;2.5"
}