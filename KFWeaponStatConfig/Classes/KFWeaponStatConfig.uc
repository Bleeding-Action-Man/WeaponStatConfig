//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int Single9mmMag, Single9mmDmgMax,
                  MK23Mag, MK23DmgMax;
var() config bool bEnableSharp;

simulated function PostNetReceive()
{
    super.PostNetReceive();
    TimeStampLog("-----|| Server Vars Replicated ||-----");
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
    MutLog("-----|| MK23 Mag: " $MK23Mag$ " || MK23 MaxDmg: " $MK23DmgMax$ " ||-----");
    MutLog("SS Weapons Stat Changed");
}

simulated function GetServerVars(){
    // SS Vars
    default.bEnableSharp = bEnableSharp;
    default.Single9mmMag = Single9mmMag;
    default.Single9mmDmgMax = Single9mmDmgMax;
    default.MK23Mag = MK23Mag;
    default.MK23DmgMax = MK23DmgMax;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "bEnableSharp", "Enable Changes for SharpShooter Weapons", 0, 0, "check");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "0. Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "0. Single9mm Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Mag", "0. MK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23DmgMax", "0. MK23 Max Damage", 0, 0, "text");
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
			return "Max Damage for the  Single9mm | Default is 35";
    case "MK23Mag":
			return "Mag Size | Default is 12";
    case "MK23DmgMax":
			return "Maximum | Default is 82";
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
    FriendlyName="WeaponStatConfig v1.0"
    Description="Change weapon MaxDmg, Magazine Size & Cost, currently supports Standard KF weapons only; - By Vel-San"

    // Weapon Stats
    // SS
    bEnableSharp=True
    Single9mmMag=15
    Single9mmDmgMax=35
    MK23Mag=12
    MK23DmgMax=82
}
