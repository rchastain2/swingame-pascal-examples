program HowToRespondToKeystrokes;
uses
  SwinGame, sgTypes;  
  
procedure Main();
var
  clr: Color;  
begin  
  OpenGraphicsWindow('Keyboard Input', 240, 180);    
  LoadDefaultColors();  

  clr := RGBAColor(255, 255, 255, 64);
  ClearScreen(ColorWhite);
  repeat // The game loop...
    ProcessEvents();
    
    FillRectangle(clr, 0, 0, 240, 180);
    
    if KeyReleased(aKey) then DrawText('A Release', ColorBlue, 'arial.ttf', 14, 20, 40);
    
    if KeyTyped(aKey) then DrawText('A Typed', ColorGreen, 'arial.ttf', 14, 20, 70);         
    
    if KeyDown(aKey) then DrawText('A Down', ColorRed, 'arial.ttf', 14, 20, 100);      
        
    if KeyUp(aKey) then DrawText('A Up', ColorTurquoise, 'arial.ttf', 14, 20, 130);      
        
    DrawText('KeyBoard Input', ColorRed, 'arial.ttf', 18, 60, 15);
    
    RefreshScreen(60);    
  until WindowCloseRequested() OR KeyTyped(ESCAPEKey) OR KeyTyped(QKey);  
  
  ReleaseAllResources();
end;

begin
  Main();
end.