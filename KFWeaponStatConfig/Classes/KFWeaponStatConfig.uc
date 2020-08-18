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

// Loads each weapon in a list
var() config array<LoadedWeapon> StandardWeapon;

replication
{
	unreliable if (Role == ROLE_Authority)
                  StandardWeapon;
}

simulated function PostNetReceive()
{
  TimeStampLog("-----|| KF-WeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  ModifyWeapon(StandardWeapon);
}

// Dynamically Load and modify weapons that are found in the Config File
simulated function ModifyWeapon(array<LoadedWeapon> WeaponsList)
{
    local int i;
    local class<KFWeapon> CurrentWeapon;
    local class<KFFire> CurrentWeaponFire;
    local class<KFShotgunFire> CurrentWeaponShotgunFire; // Used For Weapons with Special Fire Classes
    local class<KFWeaponPickup> CurrentWeaponPickup;
    local class<KFProjectileWeaponDamageType> CurrentWeaponDmgType;
    local class<Projectile> CurrentWeaponProjectile;
    local class<ShotgunBullet> CurrentWeaponShotgunBullet;

    // TO-DO
    // More vars for ImpactDamage

    MutLog("-----|| Reading Config File For Weapons ||-----");

    for(i=0; i<WeaponsList.Length; i++)
    {
      // Exit if Weapon Class Not Found
      if(class<KFWeapon>(DynamicLoadObject(WeaponsList[i].WeaponClassName, class'Class')) != none)
      {
        CurrentWeapon = class<KFWeapon>(DynamicLoadObject(WeaponsList[i].WeaponClassName, class'Class'));
        CurrentWeaponPickup = class<KFWeaponPickup>(DynamicLoadObject(string(CurrentWeapon.default.PickupClass), class'Class'));

        // Log for Currently Detected Weapon
        MutLog("-----|| Detected & Applying Config For: "$GetItemName(string(CurrentWeapon))$" ||-----");

        // Grab Needed Classes & Check WeaponFire types, then proceed to change values accordingly
        if (class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponFire = class<KFFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponFire.default.DamageType), class'Class'));

        // WeaponFire Class Related Changes
        CurrentWeaponFire.default.DamageMax = WeaponsList[i].DamageMax;
        CurrentWeaponFire.default.FireRate = WeaponsList[i].FireRate;
        CurrentWeaponFire.default.FireAnimRate = WeaponsList[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = WeaponsList[i].HeadShotDamageMult;

        }
        else if (class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class')) != none){
        CurrentWeaponShotgunFire = class<KFShotgunFire>(DynamicLoadObject(string(CurrentWeapon.default.FireModeClass[0]), class'Class'));
        if (class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none && class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) == none){
        CurrentWeaponProjectile = class<Projectile>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponProjectile.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Projectile Class");
        MutLog("       >Special Class: " $string(CurrentWeaponProjectile));

        // WeaponFire Class Related Changes
        CurrentWeaponProjectile.default.Damage = WeaponsList[i].DamageMax;
        CurrentWeaponShotgunFire.default.FireRate = WeaponsList[i].FireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = WeaponsList[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        switch(GetItemName(string(CurrentWeapon))){
          case "CrossbowArrow":
            class'KFMod.CrossbowArrow'.default.HeadShotDamageMult = WeaponsList[i].HeadShotDamageMult;
            }
        }

        else if (class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class')) != none){
        CurrentWeaponShotgunBullet = class<ShotgunBullet>(DynamicLoadObject(string(CurrentWeaponShotgunFire.default.ProjectileClass), class'Class'));
        CurrentWeaponDmgType = class<KFProjectileWeaponDamageType>(DynamicLoadObject(string(CurrentWeaponShotgunBullet.default.MyDamageType), class'Class'));

        MutLog("       >" $GetItemName(string(CurrentWeapon))$ " Has A Shotgun-Bullet Class");
        MutLog("       >Special Class: " $string(CurrentWeaponShotgunBullet));

        // WeaponFire Class Related Changes
        CurrentWeaponShotgunBullet.default.Damage = WeaponsList[i].DamageMax;
        CurrentWeaponShotgunFire.default.FireRate = WeaponsList[i].FireRate;
        CurrentWeaponShotgunFire.default.FireAnimRate = WeaponsList[i].FireAnimRate;

        // DmgType Class Related Changes
        CurrentWeaponDmgType.default.HeadShotDamageMult = 1;

        // TO-DO
        // Add Switch statement to manually change HeadShotDamageMult like the above switch
            }
        }

        // Vars Shared among all weapons the same, no need to condition-check
        // Base Class Related Changes
        CurrentWeapon.default.MagCapacity = WeaponsList[i].MagCapacity;
        CurrentWeapon.default.Weight = WeaponsList[i].Weight;
        CurrentWeapon.default.ReloadRate = WeaponsList[i].ReloadRate;
        CurrentWeapon.default.ReloadAnimRate = WeaponsList[i].ReloadAnimRate;

        // PickUp Class Related Changes
        CurrentWeaponPickup.default.Weight = WeaponsList[i].Weight;
        CurrentWeaponPickup.default.cost = WeaponsList[i].Cost;

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
  local int i;

  default.StandardWeapon.Length = StandardWeapon.Length;
  for(i=0; i<StandardWeapon.Length; i++)
  {
    // TO-DO
    // Implement duplicates detection and remove them
    default.StandardWeapon[i] = StandardWeapon[i];
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

    // Temp entry just to have a default value
    StandardWeapon(0)=(WeaponClassName="KFMod.Single",MagCapacity=35,DamageMax=500,Weight=0,Cost=0,HeadShotDamageMult=1.1,FireRate=0.175,FireAnimRate=1.5,ReloadRate=2.0,ReloadAnimRate=2.0)
}