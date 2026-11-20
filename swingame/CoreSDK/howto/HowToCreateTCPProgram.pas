program HowToCreateTCPProgram;
uses
	SwinGame, SysUtils;

const
  HOST_PORT = 2000;

var
  server : ServerSocket = nil;

function SelectPeerType() : Boolean;
var
  lInput : String = '';
begin
  Write('Are You Hosting? [y/n]: ');
  while (lInput <> 'y') and (lInput <> 'n') do
  begin
    ReadLn(lInput);
    if (lInput = 'y') then
    begin
      server := CreateServer('TCPHost', HOST_PORT);
      result := True;
			WriteLn('I am now the host');
    end else if (lInput = 'n') then
		begin
      result := False;
			WriteLn('I am now the client');
		end;
  end;
end;

function WaitForConnections() : Connection;
begin
  WriteLn('Waiting for Connections....');
  result := nil;
  while (result = nil) do
  begin
    CheckNetworkActivity();
    if ConnectionCount(server) > 0 then
      result := LastConnection(server)
    else
      Sleep(50);
  end;
  WriteLn('Connection Established.');
end;

function WaitToConnectToHost() : Connection;
begin
  WriteLn('Connecting to Host....');
  result := nil;
  while (result = nil) do
  begin
    result := OpenConnection('127.0.0.1', HOST_PORT);
    if result = nil then
      Sleep(500);
  end;
  WriteLn('Connected to Host');
end;

procedure HandleMessages(const aPeer : Connection; aIsHost : Boolean);
var
  i : Integer;
const
  AUTO_MESSAGE_COUNT = 10;
  SEND_DELAY         = 1500;
begin
	for i := 0 to AUTO_MESSAGE_COUNT do
  begin
		if (aIsHost) then
			SendMessageTo('Hello. This Message Number is from the Host. The client should receive it.', aPeer)
		else
			SendMessageTo('Hello. This Message Number is from the Client. The host should receive it.', aPeer);

    Sleep(SEND_DELAY);

    CheckNetworkActivity();
    while HasMessages(aPeer) do
      WriteLn('Received Message: ', ReadMessageData(aPeer));
  end;
end;

procedure Main();
var
  lIsHost : Boolean = False;
  lPeer : Connection = nil;
begin
  lIsHost := SelectPeerType();

  if (lIsHost) then
    lPeer := WaitForConnections()
  else
    lPeer := WaitToConnectToHost();

  HandleMessages(lPeer, lIsHost);

  CloseAllConnections();
  CloseAllServers();
  ReleaseAllResources();
end;

begin
  main();
end.
