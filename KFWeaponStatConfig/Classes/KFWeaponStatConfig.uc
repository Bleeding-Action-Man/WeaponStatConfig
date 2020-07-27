//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int Single9mmMag, Single9mmDmgMax,
                  MK23Mag, MK23DmgMax, MK23Cost,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost;
var() config bool bEnableSharp;

replication
{
	unreliable if (Role == ROLE_Authority)
		              Single9mmMag, Single9mmDmgMax,
                  MK23Mag, MK23DmgMax, MK23Cost,
                  Single44MagnumMag, Single44MagnumDmgMax, Single44MagnumCost;
}

simulated function PostNetReceive()
{
  super.PostNetReceive();
  TimeStampLog("-----|| KFWeaponStatsConfig Server Vars Replicated ||-----");
	GetServerVars();
}

simulated function PostNetBeginPlay()
{
  SetTimer(1, false);
}

simulated function Timer()
{
  if (bEnableSharp){
    ApplySharpShooter();
  }
}

simulated function ApplySharpShooter(){
    MutLog("Changing SharpShooter Weapons Stats");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    MutLog("-----|| Single9mm Mag: " $Single9mmMag$ " || Single9mm MaxDmg: " $Single9mmDmgMax$ " ||-----");
    class'KFMod.MK23Pistol'.default.MagCapacity=MK23Mag;
    class'KFMod.MK23Fire'.default.DamageMax=MK23DmgMax;
    class'KFMod.MK23Pickup'.default.cost=MK23Cost;
    MutLog("-----|| MK23 Mag: " $MK23Mag$ " || MK23 MaxDmg: " $MK23DmgMax$ " || MK23 Cost: " $MK23Cost$ " ||-----");
    class'KFMod.Magnum44Pistol'.default.MagCapacity=Single44MagnumMag;
    class'KFMod.Magnum44Fire'.default.DamageMax=Single44MagnumDmgMax;
    class'KFMod.Magnum44Pickup'.default.cost=Single44MagnumCost;
    MutLog("-----|| 44 Magnum Mag: " $Single44MagnumMag$ " || 44 Magnum MaxDmg: " $Single44MagnumDmgMax$ " || 44 Magnum Cost: " $Single44MagnumCost$ " ||-----");
    MutLog("SS Weapons Stat Changed");
}

simulated function GetServerVars(){
    // SS Vars
    default.bEnableSharp = bEnableSharp;
    default.Single9mmMag = Single9mmMag;
    default.Single9mmDmgMax = Single9mmDmgMax;
    default.MK23Mag = MK23Mag;
    default.MK23DmgMax = MK23DmgMax;
    default.MK23Cost = MK23Cost;
    default.Single44MagnumMag = Single44MagnumMag;
    default.Single44MagnumDmgMax = Single44MagnumDmgMax;
    default.Single44MagnumCost = Single44MagnumCost;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "bEnableSharp", "Enable Changes for SharpShooter Weapons", 0, 0, "check");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "0. Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "0. Single9mm Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Mag", "0. MK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23DmgMax", "0. MK23 Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Cost", "0. MK23 Cost", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumMag", "0. 44 Magnum` Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumDmgMax", "0. 44 Magnum Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single44MagnumCost", "0. 44 Magnum Cost", 0, 0, "text");
}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
    case "bEnableSharp":
      return "Apply Stat Changes for SharpShooter weapons";
		case "Single9mmMag":
			return "Mag Size | Default is 15";
    case "Single9mmDmgMax":
			return "Max Damage | Default is 35";
    case "MK23Mag":
			return "Mag Size | Default is 12";
    case "MK23DmgMax":
			return "Max Damage | Default is 82";
    case "MK23Cost":
			return "Cost | Default is 500";
    case "Single44MagnumMag":
			return "Mag Size | Default is 6";
    case "Single44MagnumDmgMax":
			return "Max Damage | Default is 105";
    case "Single44MagnumCost":
			return "Cost | Default is 450";
    default:
			return Super.GetDescriptionText(SettingName);
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
    FriendlyName="Weapon Stat Config - v1.0"
    Description="Change Weapon MaxDmg, Magazine Size & Cost (More options coming soon), currently supports Standard KF weapons only & SharpShooter only (More Perks Coming Soon); - By Vel-San"

    // Weapon Stats
    // SS
    bEnableSharp=True
    Single9mmMag=15
    Single9mmDmgMax=35
    MK23Mag=12
    MK23DmgMax=82
    MK23Cost=500
    Single44MagnumMag=6
    Single44MagnumDmgMax=105
    Single44MagnumCost=450
}
