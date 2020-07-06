//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int Single9mmMag, Single9mmDmgMin, Single9mmDmgMax, Single9mmRecoil,
                  MK23Mag, MK23DmgMin, MK23DmgMax;
var() config bool bEnableSharp;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "bEnableSharp", "Enable Changes for SharpShooter Weapons", 0, 0, "check");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "0. Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMin", "0. Single9mm Min Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "0. Single9mm Max Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmRecoil", "0. Single9mm Recoil", 0, 0, "select", "0;Default;1;Medium;2;High");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23Mag", "0. MK23 Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "MK23DmgMin", "0. MK23 Min Damage", 0, 0, "text");
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
		case "Single9mmDmgMin":
			return "Min Damage for the  Single9mm | Default is 25";
    case "Single9mmDmgMax":
			return "Max Damage for the  Single9mm | Default is 35";
    case "Single9mmRecoil":
      return "Changes the recoil power | Leave empty for default";
    case "MK23Mag":
			return "Mag Size | Default is 12";
		case "MK23DmgMin":
			return "Minimum Damage | Default is 80";
    case "MK23DmgMax":
			return "Maximum | Default is 82";
    default:
			return Super.GetDescriptionText(SettingName);
	}
}

function PostBeginPlay ()
{
  SetTimer(0.1,false);
}

function Timer ()
{
  if (bEnableSharp){
    ApplySharpShooter();
  }
}

simulated function ApplySharpShooter(){
    
    Log("Changing SharpShooter Weapons Stats");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMin=Single9mmDmgMin;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    switch(Single9mmRecoil){
      case 0:
        class'KFMod.SingleFire'.default.maxVerticalRecoilAngle=300;
        class'KFMod.SingleFire'.default.maxHorizontalRecoilAngle=50;
        break;
      case 1:
        class'KFMod.SingleFire'.default.maxVerticalRecoilAngle=600;
        class'KFMod.SingleFire'.default.maxHorizontalRecoilAngle=120;
        break;
      case 2:
        class'KFMod.SingleFire'.default.maxVerticalRecoilAngle=1200;
        class'KFMod.SingleFire'.default.maxHorizontalRecoilAngle=600;
        break;
    }
    Log("-----|| Single9mm Mag: " $Single9mmMag$ " || Single9mm MinDmg: " $Single9mmDmgMin$ " || Single9mm MaxDmg: " $Single9mmDmgMax$ " || Single9mm Recoil: " $Single9mmRecoil$ " ||-----");
    class'KFMod.MK23Pistol'.default.MagCapacity=MK23Mag;
    class'KFMod.MK23Fire'.default.DamageMin=MK23DmgMin;
    class'KFMod.MK23Fire'.default.DamageMax=MK23DmgMax;
    Log("-----|| MK23 Mag: " $MK23Mag$ " || MK23 MinDmg: " $MK23DmgMin$ " || MK23 MaxDmg: " $MK23DmgMax$ " ||-----");
    Log("SS Weapons Stat Changed");

}

defaultproperties
{
    // Mandatory Vars
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=true

    // Mut Vars
    GroupName="KF-WeaponStatConfig"
    FriendlyName="WeaponStatConfig Mut"
    Description="Change weapon Stats, currently supports Standard KF weapons only; - By Vel-San"

    // Weapon Stats
    // SS
    Single9mmMag=15
    Single9mmDmgMin=25
    Single9mmDmgMax=35
    Single9mmRecoil=0
    MK23Mag=12
    MK23DmgMin=80
    MK23DmgMax=82
}
