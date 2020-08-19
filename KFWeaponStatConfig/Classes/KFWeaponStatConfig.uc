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

// Weapons Count
const WEAPONS_COUNT = 3;
// Weapons List
var() config string StandardWeapons[WEAPONS_COUNT];
var string replicatedList[WEAPONS_COUNT];
var array<LoadedWeapon> ActualStandardWeapons;

replication
{
	reliable if (Role == ROLE_Authority)
                  replicatedList,
                  StandardWeapons;
}

function PostBeginPlay()
{
  local int i;
  for(i=0; i<WEAPONS_COUNT; i++){
    replicatedList[i] = StandardWeapons[i];
  }
}

simulated function PostNetReceive()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  SetTimer(1, false);
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

    MutLog("-----|| Reading Config File For Weapons ||-----");

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

      }
    }
}

simulated function GetServerVars()
{
  local string WeaponClassName;
  local int i, MagCapacity, DamageMax, Weight, Cost;
  local float HeadShotDamageMult, FireRate, FireAnimRate, ReloadRate, ReloadAnimRate;
  local array<string> tempWeaponList;

  ActualStandardWeapons.Length = WEAPONS_COUNT;

  for(i=0; i<WEAPONS_COUNT; i++)
  {
    MutLog("-----|| Detected Config For: "$replicatedList[i]$" ||-----");
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

    MutLog("-----|| DEBUG ClassName: "$WeaponClassName$" ||-----");
    MutLog("-----|| DEBUG MagCapacity: "$MagCapacity$" ||-----");
    MutLog("-----|| DEBUG DamageMax: "$DamageMax$" ||-----");
    MutLog("-----|| DEBUG Weight: "$Weight$" ||-----");
    MutLog("-----|| DEBUG Cost: "$Cost$" ||-----");
    MutLog("-----|| DEBUG HeadShotDamageMult: "$HeadShotDamageMult$" ||-----");
    MutLog("-----|| DEBUG FireRate: "$FireRate$" ||-----");
    MutLog("-----|| DEBUG FireAnimRate: "$FireAnimRate$" ||-----");
    MutLog("-----|| DEBUG ReloadRate: "$ReloadRate$" ||-----");
    MutLog("-----|| DEBUG ReloadAnimRate: "$ReloadAnimRate$" ||-----");

    // TO-DO
    // Implement duplicates detection and remove them

    ActualStandardWeapons[i].WeaponClassName = tempWeaponList[0];
    ActualStandardWeapons[i].MagCapacity = int(tempWeaponList[1]);
    ActualStandardWeapons[i].DamageMax = int(tempWeaponList[2]);
    ActualStandardWeapons[i].Weight = int(tempWeaponList[3]);
    ActualStandardWeapons[i].Cost = int(tempWeaponList[4]);
    ActualStandardWeapons[i].HeadShotDamageMult = int(tempWeaponList[5]);
    ActualStandardWeapons[i].FireRate = float(tempWeaponList[6]);
    ActualStandardWeapons[i].FireAnimRate = float(tempWeaponList[7]);
    ActualStandardWeapons[i].ReloadRate = float(tempWeaponList[8]);
    ActualStandardWeapons[i].ReloadAnimRate = float(tempWeaponList[9]);

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

    // Temp tempWeaponList just to have a default value
    // Always keep the same order when adding or editing values:
    // ClassName; Mag; DmgMax; Weight; Cost; HeadShot Multi; FireRate; FireRate Anim; ReloadRate; ReloadRate Anime
    StandardWeapons(0)="KFMod.Single;50;500;5;0;2.0;0.175;1.5;1;2.5"
    StandardWeapons(1)="KFMod.Crossbow;12;500;0;0;2.0;0.1;1;1;2.5"
    StandardWeapons(2)="KFMod.AA12AutoShotgun;35;500;0;0;2.0;0.175;1.5;1;2.5"
}