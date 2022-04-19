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

    ReplyToCommand(client, "%s Usage: sm_respawndeath/sm_rd <#userid|name>",prefix);
    return Plugin_Handled;

  }

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_DEAD,targetName,sizeof(targetName),isml)) <= 0)
	{
  PrintToChat(client, " \x0b[\x01HN\x0b]\x01 No Players Found!");
  if (StrEqual(arg1,"@t",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bTerrorists \x01where they died",prefix,clientindex);}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bCounter-Terrorists \x01where they died",prefix,clientindex);}
  if (StrEqual(arg1,"@all",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bAll Players \x01where they died",prefix,clientindex);}
  return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
	{
    userID = GetClientUserId(targets[NumPlayers]);
    targetpos[0] = Xdeathpos[userID];
    targetpos[1] = Ydeathpos[userID];
    targetpos[2] = Zdeathpos[userID]-64;
    CS_RespawnPlayer(targets[NumPlayers]);
    TeleportEntity(targets[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bCounter-Terrorists \x01where they died",prefix,clientindex);return Plugin_Handled;}
  PrintToChatAll("%s \x0b%N \x01respawned \x0b%s \x01where they died",prefix,clientindex,targetName);
  return Plugin_Handled;
}

public Action command_respawn(int client, int args)
{
  if (args < 1)
  {

    ReplyToCommand(client, "%s Usage: sm_respawn/sm_r <#userid|name>",prefix);
    return Plugin_Handled;

  }

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_DEAD,targetName,sizeof(targetName),isml)) <= 0)
	{
   PrintToChat(client, "%s No Players Found!",prefix);
   if (StrEqual(arg1,"@t",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bTerrorists",prefix,clientindex);}
   if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bCounter-Terrorists",prefix,clientindex);}
   if (StrEqual(arg1,"@all",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bAll Players",prefix,clientindex);}
   return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
	{
  	  CS_RespawnPlayer(targets[NumPlayers]);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bCounter-Terrorists",prefix,clientindex); return Plugin_Handled;}
  PrintToChatAll("%s \x0b%N \x01respawned \x0b%s \x01",prefix,clientindex,targetName);
  return Plugin_Handled;
}

public Action command_respawnteleport(int client, int args)
{
  if (args < 1)
  {
    ReplyToCommand(client, "%s Usage: sm_respawnteleport/sm_rt <#userid|name>",prefix);
    return Plugin_Handled;
  }

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);
  GetClientAbsOrigin(client, targetpos);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_DEAD,targetName,sizeof(targetName),isml)) <= 0)
	{
    PrintToChat(client, "%s No Players Found!",prefix);
    if (StrEqual(arg1,"@t",false)==true){PrintToChatAll("%s \x0b%N \x01respawned and brought \x0bTerrorists \x01to them",prefix,clientindex);}
    if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned and brought \x0bCounter-Terrorists \x01to them",prefix,clientindex);}
    if (StrEqual(arg1,"@all",false)==true){PrintToChatAll("%s \x0b%N \x01respawned and brought \x0bAll Players \x01to them",prefix,clientindex);}
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
	{
    CS_RespawnPlayer(targets[NumPlayers]);
    TeleportEntity(targets[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}
  if (StrEqual(arg1,"@ct",false)==true){PrintToChatAll("%s \x0b%N \x01respawned \x0bCounter-Terrorists",prefix,clientindex); return Plugin_Handled;}
  PrintToChatAll("%s \x0b%N \x01respawned and brought \x0b%s \x01to them",prefix,clientindex,targetName);
  return Plugin_Handled;
}
