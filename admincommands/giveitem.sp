


public Action command_giveitem(int client,int args)
{
  if (args < 2)
  {

    ReplyToCommand(client, "%s Usage: sm_give <#userid|name> <item>",prefix);
    return Plugin_Handled;

  }
  valid_weapon=false;
  GetCmdArg(1, arg1, sizeof(arg1));
  GetCmdArg(2, arg2, sizeof(arg2));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);
  if(StrContains(arg2, "weapon_") == -1)
  {
    FormatEx(weapon_prefix, 31, "weapon_");
    StrCat(weapon_prefix, 31, arg2);
    strcopy(arg2, 31, weapon_prefix);
  }
  for(int i = 0; i < MAX_WEAPONS; ++i)
	{
      if(StrEqual(arg2, g_weapons[i]))
      {
       valid_weapon = true;
       break;
      }
	}

  if(valid_weapon==false)
	{
		 GetCmdArg(2, arg2, sizeof(arg2));
	}

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_ALIVE,targetName,sizeof(targetName),isml)) <= 0)
	{
  	/* This function replies to the admin with a failure message */
    PrintToChat(client, "%s No Players Found!",prefix);
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
  {
  GivePlayerItem(targets[NumPlayers], arg2, iSubType);
	}
  PrintToChatAll("%s \x0b%N \x01gave \x0b%s \x01to \x0b%s",prefix,clientindex,arg2,targetName);
  return Plugin_Handled;
}

public Action command_list(int client,int args)
{
  ReplyToCommand(client,"%s Check console for output.",prefix);
  for(int i = 0; i < MAX_WEAPONS; ++i)
  {
    PrintToConsole(client, "%s", g_weapons[i]);
  }
  return Plugin_Handled;
}
