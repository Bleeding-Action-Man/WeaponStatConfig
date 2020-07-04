//====================================================
// Base Mutator for KFWeaponStatConfig by Vel-San
// Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//====================================================

class KFWeaponStatConfig extends Mutator 
                                Config(KFWeaponStatConfig);

var() config int Single9mmMag, Single9mmDmgMin, Single9mmDmgMax;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmMag", "Single9mm Mag", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMin", "Single9mm Min Damage", 0, 0, "text");
    PlayInfo.AddSetting("KFWeaponStatConfig", "Single9mmDmgMax", "Single9mm Max Damage", 0, 0, "text");

}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
		case "Single9mmMag":
			return "Mag Size | Default is 15";
		case "Single9mmDmgMin":
			return "Min Damage for the  Single9mm | Default is 25";
        case "Single9mmDmgMax":
			return "Max Damage for the  Single9mm | Default is 35";
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
  ApplyWeaponStatChange();
}

simulated function ApplyWeaponStatChange(){
    
    Log("Weapon Stats Config Started");
    class'KFMod.Single'.default.MagCapacity=Single9mmMag;
    class'KFMod.SingleFire'.default.DamageMin=Single9mmDmgMin;
    class'KFMod.SingleFire'.default.DamageMax=Single9mmDmgMax;
    Log("-----|| Single9mm Mag: " $Single9mmMag$ " || Single9mm MinDmg: " $Single9mmDmgMin$ " || Single9mm MaxDmg: " $Single9mmDmgMax$ "||-----");
    Log("Weapon Stats Config Started");

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
    Description="Test version for Weapon Stats Configurator. Currently changes default Single9mm ( Single Default Pistol ) variables only; - By Vel-San"

    // Weapon Stats
    Single9mmMag=15
    Single9mmDmgMin=25
    Single9mmDmgMax=35
}
