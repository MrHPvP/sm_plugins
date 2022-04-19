public Action command_playercolour(int client, int args)
{
  if (args < 2)
  {

    ReplyToCommand(client, " \x0b[\x01HN\x0b]\x01 Usage: sm_playercolour/sm_pc <#userid|name> (<Red> <Green> <Blue>/<colour>");
    return Plugin_Handled;

  }

  GetCmdArg(1, arg1, sizeof(arg1));
  GetClientName(client, clientName, sizeof(clientName));
  clientindex = FindTarget(client,clientName);

  if ((targetcount = ProcessTargetString(arg1,client,targets,MAXPLAYERS,COMMAND_FILTER_ALIVE,targetName,sizeof(targetName),isml)) <= 0)
	{
  	/* This function replies to the admin with a failure message */
    PrintToChat(client, " \x0b[\x01HN\x0b]\x01 No Players Found!");
    return Plugin_Handled;
  }
  GetCmdArg(2, arg2, sizeof(arg2));
  redvalue = StringToInt(arg2);
  GetCmdArg(3, arg3, sizeof(arg3));
  greenvalue = StringToInt(arg3);
  GetCmdArg(4, arg4, sizeof(arg4));
  bluevalue = StringToInt(arg4);
  for (NumPlayers = 0; NumPlayers < targetcount; NumPlayers++)
  {
  SetEntityRenderColor(targets[NumPlayers], redvalue, greenvalue, bluevalue,alphavalue);
  }
  PrintToChatAll(" \x0b[\x01HN\x0b]\x01 \x0b%N \x01coloured \x0b%s \x0b%i\x01,\x0b%i\x01,\x0b%i",clientindex,targetName,redvalue,greenvalue,bluevalue);
  return Plugin_Handled;
}
