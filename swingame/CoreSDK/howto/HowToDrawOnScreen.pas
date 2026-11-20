program HowToDrawOnScreen;
uses
  SwinGame;

procedure Main();
begin  
  OpenGraphicsWindow('Drawing On Screen', 800, 600);  
  LoadDefaultColors();
  repeat // The game loop...
    ProcessEvents();
  
    ClearScreen(ColorWhite);
    
    DrawText('How To Draw On Screen', ColorRed, 330, 40, OptionToScreen());        
    
    FillRectangle(RGBColor(205,201,201), 400, 300, 100, 100, OptionToScreen());    
    FillEllipse(RandomColor(), 100, 100, 60, 30, OptionToScreen());    
    DrawCircle(RandomColor(), 105, 420, 30, OptionToScreen());        
    
    RefreshScreen(60);
  until WindowCloseRequested();

  ReleaseAllResources();
end;

begin
  Main();
end.