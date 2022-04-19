public Action command_position(int client,int args)
{

  if (args < 1) //Stops the plugin if the args are not met
  {

    ReplyToCommand(client, "%s Usage: sm_position/sm_pos <#userid|name>", prefix);
    return Plugin_Handled;

  }
  GetCmdArg(1,arg1,sizeof(arg1));

  target_player = FindTarget(client,arg1);

  GetClientAbsOrigin(target_player, targetpos);

  PrintToChat(client, "%s \x0b%N \x01is at \x0b%0.0f\x01,\x0b%0.0f\x01,\x0b%0.0f",prefix,target_player, targetpos[0], targetpos[1], targetpos[2]);

  return Plugin_Handled;

}

public Action command_location(int client,int args)
{

  if (args < 1) //Stops the plugin if the args are not met
  {

    ReplyToCommand(client, "%s Usage: sm_location/sm_loc <#userid|name>",prefix);
    return Plugin_Handled;

  }

  GetCmdArg(1,arg1,sizeof(arg1));

  target_player = FindTarget(client,arg1);

  GetEntPropString(target_player, Prop_Send, "m_szLastPlaceName", location, sizeof(location));

  ReplyToCommand(client, "%s \x0b%N \x01is in \x0b%s", prefix,target_player, location);

  return Plugin_Handled;

}

public Action command_teleport(int client,int args)
{

  if (args < 2) //Stops the plugin if the args are not met
  {
    ReplyToCommand(client, "%s Usage: sm_teleport/sm_tp <#userid|name> <#userid|name>",prefix);
    return Plugin_Handled;
  }

  GetCmdArg(2,arg2,sizeof(arg2));
  target_player = FindTarget(client,arg2);

  GetCmdArg(1,arg1,sizeof(arg1));
  clientindex = FindTarget(client,arg1);

  if (target_player == clientindex)
  {
    ReplyToCommand(client, "%s You cannot teleport to yourself because you are, you.",prefix);
    return Plugin_Handled;
  }
  userID = GetClientUserId(clientindex);
  GetClientAbsOrigin(clientindex, targetpos);
  Xdeathpos[userID] = targetpos[0];
  Ydeathpos[userID] = targetpos[1];
  Zdeathpos[userID] = targetpos[2];
  GetClientAbsOrigin(target_player, targetpos);
  TeleportEntity(clientindex, targetpos, NULL_VECTOR, NULL_VECTOR);
  PrintToChatAll("%s \x0b%N \x01teleported to \x0b%N",prefix,clientindex ,target_player);

  return Plugin_Handled;
}

public Action command_goto(int client,int args)
{

  if (args < 1) //Stops the plugin if the args are not met
  {

    ReplyToCommand(client, "%s Usage: sm_goto <#userid|name>",prefix);
    return Plugin_Handled;
  }

  GetCmdArg(1,arg1,sizeof(arg1));
  target_player = FindTarget(client,arg1);

  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if (target_player == clientindex)
  {

    ReplyToCommand(client, "%s You cannot goto to yourself because you are already here",prefix);
    return Plugin_Handled;

  }
  userID = GetClientUserId(client);
  GetClientAbsOrigin(client, targetpos);
  Xdeathpos[userID] = targetpos[0];
  Ydeathpos[userID] = targetpos[1];
  Zdeathpos[userID] = targetpos[2];
  GetClientAbsOrigin(target_player, targetpos);
  TeleportEntity(client, targetpos, NULL_VECTOR, NULL_VECTOR);
  PrintToChatAll("%s \x0b%N \x01went to \x0b%N",prefix,clientindex,target_player);

  return Plugin_Handled;
}

public Action command_bring(int client, int args)
{
  if (args < 1) //Stops the plugin if the args are not met
  {

    ReplyToCommand(client, "%s Usage: sm_goto <#userid|name>",prefix);
    return Plugin_Handled;

  }
  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_ALIVE,targetName,sizeof(targetName),isml)) <= 0)
	{
    PrintToChatAll("%s \x0b%N \x01brought \x0b%s \x01to them",prefix,clientindex,arg1);
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
	{
    userID = GetClientUserId(targets[NumPlayers]);
    GetClientAbsOrigin(targets[NumPlayers], targetpos);
    Xdeathpos[userID] = targetpos[0];
    Ydeathpos[userID] = targetpos[1];
    Zdeathpos[userID] = targetpos[2];
    GetClientAbsOrigin(client, targetpos);
    TeleportEntity(targets[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}

  PrintToChatAll("%s \x0b%N \x01brought \x0b%s \x01to them",prefix,clientindex,targetName);
  return Plugin_Handled;
}
public Action command_back(int client, int args)
{
  if (args < 1) //Stops the plugin if the args are not met
  {

    ReplyToCommand(client, "%s Usage: sm_back <#userid|name>",prefix);
    return Plugin_Handled;

  }
  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_ALIVE,targetName,sizeof(targetName),isml)) <= 0)
	{
    PrintToChatAll("%s Player(s) are dead or don't exist",prefix);
    return Plugin_Handled;
  }
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
	{
    userID = GetClientUserId(targets[NumPlayers]);
    targetpos[0] = Xdeathpos[userID];
    targetpos[1] = Ydeathpos[userID];
    targetpos[2] = Zdeathpos[userID];
    TeleportEntity(targets[NumPlayers], targetpos, NULL_VECTOR, NULL_VECTOR);
	}

  PrintToChatAll("%s \x0b%N \x01sent back \x0b%s \x01to where they came from",prefix,clientindex,targetName);
  return Plugin_Handled;
}
