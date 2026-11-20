program HowToCreateHost;
uses
  SwinGame, sgTypes, SysUtils;

var
  server : ServerSocket = nil;
  peer : Connection = nil;
  knownConnections : Integer = 0;

//----------------------------------------------------------------------------
// Init
//----------------------------------------------------------------------------

procedure InitPanel(var aMenuPanel : Panel);
begin
  GUISetForegroundColor(ColorBlack);
  GUISetBackgroundColor(ColorWhite);
  ShowPanel(aMenuPanel);
  ActivatePanel(aMenuPanel);
  DrawGUIAsVectors(True);
end;

procedure SetLabelText();
begin
  LabelSetText('MyIPLbl', 'My IP:');
  LabelSetText('MyIPVal', MyIP());
  LabelSetText('MyPortLbl', 'Port: ');
  LabelSetText('HostStatusLbl', 'Status: ');

  LabelSetText('MsgLbl', 'Message: ');

  LabelSetText('ServerLbl', 'Server:');
  LabelSetText('ServerPortLbl', 'Port: ');
  LabelSetText('ClientStatusLbl', 'Status: ');
  TextboxSetText('ServerVal', '127.0.0.1');
end;

procedure AddMessage(aMenuPanel : Panel; const aText : String);
begin
  ListAddItem(aMenuPanel, 'MsgList', aText);
  ListSetActiveItemIndex(aMenuPanel, 'MsgList', ListItemCount(aMenuPanel, 'MsgList') - 1);
end;

//----------------------------------------------------------------------------
// Connect
//----------------------------------------------------------------------------

procedure CreateHost(aMenuPanel : Panel; var aStatus : Boolean);
var
  lPort : Integer;
begin
  if TryStrToInt(TextBoxText('MyPortVal'), lPort) then
  begin
    server := CreateServer('P2PHost', lPort);
    if Assigned(server) then
    begin
      knownConnections := 0;
      LabelSetText('HostStatusVal', 'Listening...');
      LabelSetText('HostLbl', 'Disconnect');
      AddMessage(aMenuPanel, 'Now Listening for Connections....');
      aStatus := True;
    end;
  end;
end;

procedure ConnectToHost(aMenuPanel : Panel; var aStatus : Boolean);
var
  lPort : Integer;
begin
  if TryStrToInt(TextBoxText('ServerPortVal'), lPort) then
  begin
    peer := OpenConnection(TextBoxText('ServerVal'), lPort);
    if Assigned(peer) then
    begin
      LabelSetText('ClientStatusVal', 'Connected');
      AddMessage(aMenuPanel, 'Connected to: ' + TextBoxText('ServerVal') + ':' + IntToStr(lPort));
      LabelSetText('ConnLbl', 'Disconnect');
      aStatus := True;
    end;
  end;
end;

procedure AcceptConnection(aMenuPanel : Panel);
begin
  while ConnectionCount(server) > knownConnections do
  begin
    Inc(knownConnections);
    AddMessage(aMenuPanel, 'A peer connected.');
  end;
end;

//----------------------------------------------------------------------------
// Disconnect
//----------------------------------------------------------------------------

procedure DisconnectHost(aMenuPanel : Panel; var aStatus : Boolean);
begin
  CloseServer(server);
  server := nil;
  LabelSetText('HostStatusVal', 'Idle');
  LabelSetText('HostLbl', 'Connect');
  AddMessage(aMenuPanel, 'Listening Sockets Closed.');
  aStatus := False;
end;

procedure DisconnectFromHost(aMenuPanel : Panel; var aStatus : Boolean);
begin
  SendMessageTo('[ClientDisconnect]', peer);
  CloseConnection(peer);
  peer := nil;
  LabelSetText('ClientStatusVal', 'Disconnected');
  LabelSetText('ConnLbl', 'Connect');
  AddMessage(aMenuPanel, 'You Disconnected.');
  aStatus := False;
end;

//----------------------------------------------------------------------------
// Messages
//----------------------------------------------------------------------------

procedure ReceiveMessages(aMenuPanel : Panel);
var
  lMsg : Message;
begin
  if Assigned(server) then
    while HasMessages(server) do
    begin
      lMsg := ReadMessage(server);
      if MessageData(lMsg) = '[ClientDisconnect]' then
        AddMessage(aMenuPanel, MessageHost(lMsg) + ' Disconnected.')
      else
        AddMessage(aMenuPanel, MessageHost(lMsg) + ' said: ' + MessageData(lMsg));
      CloseMessage(lMsg);
    end;

  if Assigned(peer) then
    while HasMessages(peer) do
      AddMessage(aMenuPanel, 'Host said: ' + ReadMessageData(peer));
end;

//----------------------------------------------------------------------------
// Input
//----------------------------------------------------------------------------

procedure SendText(aChatPanel : Panel; var aClientStatus : Boolean);
var
  lText : String;
begin
  lText := TextBoxText('MsgVal');
  if lText = '' then exit;

  if Assigned(server) then
    BroadcastMessage(lText, server);

  if Assigned(peer) and not SendMessageTo(lText, peer) then
  begin
    AddMessage(aChatPanel, 'Host Disconnected.');
    DisconnectFromHost(aChatPanel, aClientStatus);
    exit;
  end;

  AddMessage(aChatPanel, 'You Say: ' + lText);
  TextboxSetText('MsgVal', '');
  GUISetActiveTextbox('MsgVal');
end;

procedure HandleGUIInput(aChatPanel : Panel; var aServerStatus, aClientStatus : Boolean);
begin
  //Server Connect and Disconnect
  if (not aServerStatus) and (RegionClickedID() = 'HostBtn') then
    CreateHost(aChatPanel, aServerStatus)
  else if (aServerStatus) and (RegionClickedID() = 'HostBtn') then
    DisconnectHost(aChatPanel, aServerStatus)
  //Client Connect and Disconnect
  else if (not aClientStatus) and (RegionClickedID() = 'ConnectBtn') then
    ConnectToHost(aChatPanel, aClientStatus)
  else if (aClientStatus) and (RegionClickedID() = 'ConnectBtn') then
    DisconnectFromHost(aChatPanel, aClientStatus)
  //Message Input
  else if GUITextEntryComplete() and (RegionOfLastUpdatedTextBox() = RegionWithID('MsgVal')) then
    SendText(aChatPanel, aClientStatus);
end;

procedure Main();
var
  lServerPanel, lClientPanel, lChatPanel : Panel;
  //True for Listening, False for Idle.
  lHostStatus : Boolean = False;
  //True for Connected, False for Disconnected
  lClientStatus : Boolean = False;
begin
  OpenGraphicsWindow('How To Create Host', 800, 600);
  LoadDefaultColors();

  LoadResourceBundle('main-menu.txt');
  lServerPanel := LoadPanel('hostpanel.txt');
  lClientPanel := LoadPanel('clientpanel.txt');
  lChatPanel := LoadPanel('chat-window-panel.txt');
  InitPanel(lServerPanel);
  InitPanel(lClientPanel);
  InitPanel(lChatPanel);
  SetLabelText();

  repeat
    ProcessEvents();
    CheckNetworkActivity();
    ClearScreen(ColorBlack);

    DrawInterface();
    UpdateInterface();
    HandleGUIInput(lChatPanel, lHostStatus, lClientStatus);
    if lHostStatus then
      AcceptConnection(lChatPanel);
    ReceiveMessages(lChatPanel);

    RefreshScreen();
  until WindowCloseRequested();

  CloseAllConnections();
  CloseAllServers();
  ReleaseAllResources();
end;

begin
  Main();
end.
