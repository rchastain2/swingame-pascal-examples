program HowToCreateUDPProgram;
uses
	SwinGame, sgTypes, SysUtils;

const
  PEER_A_PORT = 2000;
  PEER_B_PORT = 2001;

var
  server : ServerSocket = nil;

function SelectPeerType() : Connection;
var
  lInput : String = '';
begin
  Write('Are You Hosting? [y/n]: ');
  while (lInput <> 'y') and (lInput <> 'n') do
  begin
    ReadLn(lInput);
    if (lInput = 'y') then
    begin
      server := CreateServer('UDPHost', PEER_A_PORT, UDP);
      result := nil;
			WriteLn('I am now the host');
    end else if (lInput = 'n') then
		begin
      server := CreateServer('UDPClient', PEER_B_PORT, UDP);
			result := OpenConnection('UDPToHost', '127.0.0.1', PEER_A_PORT, UDP);
			SendMessageTo('Accept Me', result);
			WriteLn('I am now the client');
		end;
  end;
end;

procedure AcceptConnection(var aPeer : Connection);
var
  lMsg : Message;
begin
  while not Assigned(aPeer) do
  begin
    CheckNetworkActivity();
		if HasMessages(server) then
		begin
      lMsg := ReadMessage(server);
			WriteLn('Host Received Message: ', MessageData(lMsg));
			aPeer := OpenConnection('UDPToClient', MessageHost(lMsg), PEER_B_PORT, UDP);
      CloseMessage(lMsg);
		end
    else
      Sleep(50);
	end;
end;


procedure HandleMessages(var aPeer : Connection; const aIsHost : Boolean);
var
  i : Integer;
const
  AUTO_MESSAGE_COUNT = 10;
  SEND_DELAY         = 1500;
begin
	for i := 0 to AUTO_MESSAGE_COUNT do
  begin
		if (aIsHost) then
			SendMessageTo('Hello. This Message is from the Host. The client should receive it.', aPeer)
		else
			SendMessageTo('Hello. This Message is from the Client. The host should receive it.', aPeer);

    Sleep(SEND_DELAY);

    CheckNetworkActivity();
    while HasMessages(server) do
      WriteLn('Received Message: ', ReadMessageData(server));
  end;
end;

procedure Main();
var
  lIsHost : Boolean = False;
  lPeer : Connection = nil;
begin
  lPeer := SelectPeerType();
  lIsHost := not Assigned(lPeer);
	if lIsHost then AcceptConnection(lPeer);

  HandleMessages(lPeer, lIsHost);

  CloseAllConnections();
  CloseAllServers();
end;

begin
  main();
end.
