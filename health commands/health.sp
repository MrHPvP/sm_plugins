
#include <sourcemod>
#include <sdktools>
public Plugin:myinfo = {
  name = "Health Commands",
  author = "MrH_PvP",
  description = "A group of useful health commands"
}

// Initialize
char arg1[MAX_NAME_LENGTH],arg2[MAX_NAME_LENGTH],arg3[MAX_NAME_LENGTH],clientName[MAX_NAME_LENGTH];
char prefix[] = " \x0b[\x01HN\x0b]\x01";
int NumPlayers, clientindex,healthamount,healthmin,healthmax;

public OnPluginStart(){
  RegAdminCmd("sm_sethealth",command_sethealth, ADMFLAG_SLAY);
  RegAdminCmd("sm_hp",command_sethealth, ADMFLAG_SLAY);
  RegAdminCmd("sm_setrandomhealth",command_setrandomhealth, ADMFLAG_SLAY);
  RegAdminCmd("sm_randhp",command_setrandomhealth, ADMFLAG_SLAY);
}
public Action command_sethealth(int client, int args)
{
  if (args < 2)
  {

    ReplyToCommand(client, "%s Usage: sm_sethealth/sm_hp <#userid|name> <Number>",prefix);
    return Plugin_Handled;

  }

  char target_name[MAX_NAME_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);
  GetCmdArg(2, arg2, sizeof(arg2));
  healthamount = StringToInt(arg2);
  bool isnegative = healthamount < 0;
  if(StrEqual(arg2,"max",false)==true)
  {
    healthamount = 32767;
  }
  if(isnegative == true)
  {
    healthamount = 32767;
  }
  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_ALIVE,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
  	/* This function replies to the admin with a failure message */
    PrintToChat(client, "%s No Players Found!",prefix);
    PrintToChatAll("%s \x0b%N \x01set \x0b%s \x01health to \x0b%i",prefix,clientindex,arg1,healthamount);
    return Plugin_Handled;
  }

  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
  {
  SetEntityHealth(target_list[NumPlayers],healthamount);
	}
  if(healthamount == 32767)
  {
    PrintToChatAll("%s \x0b%N \x01set \x0b%s \x01health to \x0bMAX",prefix,clientindex,target_name);
    return Plugin_Handled;
  }
  PrintToChatAll("%s \x0b%N \x01set \x0b%s \x01health to \x0b%i",prefix,clientindex,target_name,healthamount);
  return Plugin_Handled;
}

public Action command_setrandomhealth(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, "%s Usage: sm_setrandomhealth/sm_randhp <#userid|name> (optional) <min health> <max health>",prefix);
    return Plugin_Handled;
  }

  char target_name[MAX_NAME_LENGTH];
  int target_list[MAXPLAYERS], target_count;
  bool tn_is_ml;

  GetCmdArg(1, arg1, sizeof(arg1));

  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  GetCmdArg(2, arg2, sizeof(arg2));
  healthmin = StringToInt(arg2);
  bool isnegative = healthamount < 0;
  if(isnegative == true)
  {
    PrintToChat(client,"%s the minimum number can't be negative.",prefix);
    return Plugin_Handled;
  }
  if(healthmin == 0)
  {
    healthmin = 1;
  }
  if ((target_count = ProcessTargetString(arg1,client,target_list,MAXPLAYERS,COMMAND_FILTER_ALIVE,target_name,sizeof(target_name),tn_is_ml)) <= 0)
	{
  	/* This function replies to the admin with a failure message */
    PrintToChat(client, "%s No Players Found!");
    return Plugin_Handled;
  }
  GetCmdArg(3, arg3, sizeof(arg3));
  healthmax = StringToInt(arg3);
  if(healthmax == 0){
    healthmax = 100;
  }
  for (NumPlayers = 0; NumPlayers < target_count; NumPlayers++)
  {
  SetEntityHealth(target_list[NumPlayers],GetRandomInt(healthmin, healthmax));
	}
  PrintToChatAll("%s \x0b%N \x01set \x0b%s \x01health to \x0brandom",prefix,clientindex,target_name,healthamount);
  return Plugin_Handled;
}
