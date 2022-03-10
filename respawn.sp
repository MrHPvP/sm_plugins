#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo = {
name = "Respawn Commands",
author = "MrH_PvP",
description = "A group of useful teleport commands",
url = "",
};

//Initialize
char arg1[MAX_NAME_LENGTH],clientName[MAX_NAME_LENGTH];
int NumPlayers, clientindex, target_player, userID;
new Float:targetpos[3],Float:Xdeathpos[MAXPLAYERS],Float:Ydeathpos[MAXPLAYERS],Float:Zdeathpos[MAXPLAYERS];

public OnPluginStart(){
  HookEvent("player_death", Event_PlayerDeath);
  RegAdminCmd("sm_respawn", command_respawn, ADMFLAG_SLAY);
  RegAdminCmd("sm_r", command_respawn, ADMFLAG_SLAY);
  RegAdminCmd("sm_respawnteleport", command_respawnteleport, ADMFLAG_SLAY);
  RegAdminCmd("sm_rt", command_respawnteleport, ADMFLAG_SLAY);
  RegAdminCmd("sm_respawndeath", command_respawndeath, ADMFLAG_SLAY);
  RegAdminCmd("sm_rd", command_respawndeath, ADMFLAG_SLAY);
}
public Action Event_PlayerDeath(Handle deathposlog, const char[] name, bool dontBroadcast)
{
  userID = GetEventInt(deathposlog, "userid");
  target_player = GetClientOfUserId(userID);
  GetClientAbsOrigin(target_player, targetpos);


  if (!IsPlayerAlive(target_player)) {
    Xdeathpos[userID] = targetpos[0];
    Ydeathpos[userID] = targetpos[1];
    Zdeathpos[userID] = targetpos[2];
  }
  return Plugin_Continue;
}

public Action command_respawndeath(int client, int args)
{
  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_respawndeath/sm_rd <#userid|name>");
    return Plugin_Handled;

  }

  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_DEAD,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
  PrintToChat(client, " \x0b[\x01HN\x0b]\x01 No Players Found!");
  if (StrEqual(arg1,"@t",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bTerrorists \x01where they died",clientindex);}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bCounter-Terrorists \x01where they died",clientindex);}
  if (StrEqual(arg1,"@all",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bAll Players \x01where they died",clientindex);}
  return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
	{
    userID = GetClientUserId(target_list[NumPlayers]);
    targetpos[0] = Xdeathpos[userID];
    targetpos[1] = Ydeathpos[userID];
    targetpos[2] = Zdeathpos[userID];
    CS_RespawnPlayer(target_list[NumPlayers]);
    TeleportEntity(target_list[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bCounter-Terrorists \x01where they died",clientindex);return Plugin_Handled;}
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0b%s \x01where they died",clientindex,target_name);
  return Plugin_Handled;
}

public Action command_respawn(int client, int args)
{
  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_respawn/sm_r <#userid|name>");
    return Plugin_Handled;

  }

  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_DEAD,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
   PrintToChat(client, " \x0b[\x01HN\x0b]\x01 No Players Found!");
   if (StrEqual(arg1,"@t",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bTerrorists",clientindex);}
   if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bCounter-Terrorists",clientindex);}
   if (StrEqual(arg1,"@all",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bAll Players",clientindex);}
   return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
	{
  	  CS_RespawnPlayer(target_list[NumPlayers]);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bCounter-Terrorists",clientindex); return Plugin_Handled;}
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0b%s \x01",clientindex,target_name);
  return Plugin_Handled;
}

public Action command_respawnteleport(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_respawnteleport/sm_rt <#userid|name>");
    return Plugin_Handled;
  }

  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);
  GetClientAbsOrigin(client, targetpos);

  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_DEAD,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
    PrintToChat(client, " \x0b[\x01HN\x0b]\x01 No Players Found!");
    if (StrEqual(arg1,"@t",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned and brought \x0bTerrorists \x01to them",clientindex);}
    if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned and brought \x0bCounter-Terrorists \x01to them",clientindex);}
    if (StrEqual(arg1,"@all",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned and brought \x0bAll Players \x01to them",clientindex);}
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
	{
    CS_RespawnPlayer(target_list[NumPlayers]);
    TeleportEntity(target_list[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned \x0bCounter-Terrorists",clientindex); return Plugin_Handled;}
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01respawned and brought \x0b%s \x01to them",clientindex,target_name);
  return Plugin_Handled;
}
