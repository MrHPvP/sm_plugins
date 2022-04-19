#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <helpers>
#include <cstrike>
#undef REQUIRE_PLUGIN
#include <adminmenu>
#define MAX_WEAPONS		48
#pragma newdecls required

char arg1[MAX_NAME_LENGTH],arg2[MAX_WEAPONS],arg3[MAX_NAME_LENGTH],arg4[MAX_NAME_LENGTH],weapon_prefix[MAX_WEAPONS],clientName[MAX_NAME_LENGTH], targetName[MAX_NAME_LENGTH],location[64];
int NumPlayers, clientindex,targets[MAXPLAYERS], targetcount, iSubType,healthamount,healthmin,healthmax,redvalue,greenvalue,bluevalue,alphavalue=255,target_player, userID;
bool isml,valid_weapon;
float targetpos[3],Xdeathpos[MAXPLAYERS],Ydeathpos[MAXPLAYERS],Zdeathpos[MAXPLAYERS];
char prefix[] = " \x0b[\x01HN\x0b]\x01";
char g_weapons[MAX_WEAPONS][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_decoy","weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", "weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff",
	"weapon_scar20", "weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", "weapon_ump45", "weapon_xm1014",	"weapon_snowball","weapon_c4",
  "weapon_tablet","weapon_breachcharge","weapon_bumpmine","weapon_spanner","weapon_hammer","weapon_axe","weapon_tagrenade","weapon_healthshot","weapon_shield",
};

public Plugin myinfo =
{
	name = "All Commands",
	author = "MrH_PvP",
	description = "A group of admin/useful commands",
	version = "1.0",
	url = "http://www.sourcemod.net/"
};

// Include various commands and supporting functions
#include "admincommands/giveitem.sp"
#include "admincommands/health.sp"
#include "admincommands/player-colours.sp"
#include "admincommands/respawn.sp"
#include "admincommands/teleport.sp"

public void OnPluginStart(){
	RegAdminCmd("sm_give",command_giveitem, ADMFLAG_SLAY);
	RegAdminCmd("sm_weaponlist",command_list, ADMFLAG_SLAY);

	RegAdminCmd("sm_sethealth",command_sethealth, ADMFLAG_SLAY);
	RegAdminCmd("sm_hp",command_sethealth, ADMFLAG_SLAY);
	RegAdminCmd("sm_setrandomhealth",command_setrandomhealth, ADMFLAG_SLAY);
	RegAdminCmd("sm_rhp",command_setrandomhealth, ADMFLAG_SLAY);

	RegAdminCmd("sm_playercolour",command_playercolour, ADMFLAG_SLAY);
	RegAdminCmd("sm_pc",command_playercolour, ADMFLAG_SLAY);

	HookEvent("player_death", Event_PlayerDeath);
	RegAdminCmd("sm_respawn", command_respawn, ADMFLAG_SLAY);
	RegAdminCmd("sm_r", command_respawn, ADMFLAG_SLAY);
	RegAdminCmd("sm_respawnteleport", command_respawnteleport, ADMFLAG_SLAY);
	RegAdminCmd("sm_rt", command_respawnteleport, ADMFLAG_SLAY);
	RegAdminCmd("sm_respawndeath", command_respawndeath, ADMFLAG_SLAY);
	RegAdminCmd("sm_rd", command_respawndeath, ADMFLAG_SLAY);

	RegAdminCmd("sm_position", command_position, ADMFLAG_SLAY); //Types out the the x y z position
	RegAdminCmd("sm_pos", command_position, ADMFLAG_SLAY);
	RegAdminCmd("sm_location", command_location, ADMFLAG_SLAY); //Types out the the map location
	RegAdminCmd("sm_loc", command_location, ADMFLAG_SLAY);
	RegAdminCmd("sm_teleport",command_teleport, ADMFLAG_SLAY); //Teleports the player to another player's location
	RegAdminCmd("sm_tp",command_teleport, ADMFLAG_SLAY);
	RegAdminCmd("sm_goto",command_goto,ADMFLAG_SLAY); //Teleports the command user to another players's location
	RegAdminCmd("sm_bring",command_bring,ADMFLAG_SLAY); //Teleports another player to the command user's location
	RegAdminCmd("sm_back",command_back,ADMFLAG_SLAY);
}
