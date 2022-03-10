#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = {
name = "Teleport Commands",
author = "MrH_PvP",
description = "A group of useful teleport commands",
url = "",
};

//Initialize

char arg1[MAX_NAME_LENGTH], arg2[MAX_NAME_LENGTH], clientName[MAX_NAME_LENGTH];
int clientindex, target_player, NumPlayers;
new Float:targetpos[3];

public OnPluginStart(){
  RegAdminCmd("sm_position", command_position, ADMFLAG_SLAY);
  RegAdminCmd("sm_pos", command_position, ADMFLAG_SLAY);
  RegAdminCmd("sm_location", command_location, ADMFLAG_SLAY);
  RegAdminCmd("sm_loc", command_location, ADMFLAG_SLAY);
  RegAdminCmd("sm_teleport",command_teleport, ADMFLAG_SLAY);
  RegAdminCmd("sm_tp",command_teleport, ADMFLAG_SLAY);
  RegAdminCmd("sm_goto",command_goto,ADMFLAG_SLAY);
  RegAdminCmd("sm_bring",command_bring,ADMFLAG_SLAY);
}

//Commands
public Action command_position(int client,int args)
{

  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_position/sm_pos <#userid|name>");
    return Plugin_Handled;

  }
  GetCmdArg(1,arg1,sizeof(arg1));

  target_player = FindTarget(client,arg1);

  GetClientAbsOrigin(target_player, targetpos);

  PrintToChat(client, " \x0b[\x01HN\x0b]\x01 \x0b%N \x01is at \x0b%0.0f\x01,\x0b%0.0f\x01,\x0b%0.0f",target_player, targetpos[0], targetpos[1], targetpos[2]);

  return Plugin_Handled;

}

public Action command_location(int client,int args)
{

  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_location/sm_loc <#userid|name>");
    return Plugin_Handled;

  }

  GetCmdArg(1,arg1,sizeof(arg1));

  target_player = FindTarget(client,arg1);

  new String:location[64];

  GetEntPropString(target_player, Prop_Send, "m_szLastPlaceName", location, sizeof(location));

  ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 \x0b%N \x01is in \x0b%s", target_player, location);

  return Plugin_Handled;

}

public Action command_teleport(int client,int args)
{

  if (args < 2)
  {
    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_teleport/sm_tp <#userid|name> <#userid|name>");
    return Plugin_Handled;
  }

  GetCmdArg(2,arg2,sizeof(arg2));
  target_player = FindTarget(client,arg2);

  GetCmdArg(1,arg1,sizeof(arg1));
  clientindex = FindTarget(client,arg1);

  if (target_player == clientindex)
  {
    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 You cannot teleport to yourself because you are, you.");
    return Plugin_Handled;
  }

  GetClientAbsOrigin(target_player, targetpos);
  TeleportEntity(clientindex, targetpos, NULL_VECTOR, NULL_VECTOR);
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01teleported to \x0b%N",clientindex ,target_player);

  return Plugin_Handled;
}

public Action command_goto(int client,int args)
{

  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_goto <#userid|name>");
    return Plugin_Handled;
  }

  GetCmdArg(1,arg1,sizeof(arg1));
  target_player = FindTarget(client,arg1);

  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if (target_player == clientindex)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 You cannot goto to yourself because you are already here");
    return Plugin_Handled;

  }

  GetClientAbsOrigin(target_player, targetpos);
  TeleportEntity(client, targetpos, NULL_VECTOR, NULL_VECTOR);
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01went to \x0b%N",clientindex,target_player);

  return Plugin_Handled;
}

public Action command_bring(int client, int args)
{
  if (args < 1)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_goto <#userid|name>");
    return Plugin_Handled;

  }

  char target_name[MAX_TARGET_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);
  GetClientAbsOrigin(client, targetpos);

  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_ALIVE,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
    PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01brought \x0b%s \x01to them",clientindex,arg1);
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
	{
  	TeleportEntity(target_list[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}

  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01brought \x0b%s \x01to them",clientindex,target_name);
  return Plugin_Handled;
}
