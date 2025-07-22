
program Demo;

uses 
  SwinGame, sgTypes, Math;
  
var
  anim: Animation;
  name: string;
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);
  
  OpenAudio();
  OpenGraphicsWindow('Animation Demo', 384, 99);
  LoadResourceBundle('demo.txt');
  
  name := 'idle';
  anim := CreateAnimation(name, AnimationScriptNamed('script_bear_' + name));
  
  repeat
    ProcessEvents();
    
    if KeyTyped(IKey) then
    begin
      name := 'idle';
      AssignAnimation(anim, name, AnimationScriptNamed('script_bear_' + name));
    end else if KeyTyped(RKey) then
    begin
      name := 'run';
      AssignAnimation(anim, name, AnimationScriptNamed('script_bear_' + name));
    end else if KeyTyped(WKey) then
    begin
      name := 'walk';
      AssignAnimation(anim, name, AnimationScriptNamed('script_bear_' + name));
    end else if KeyTyped(EscapeKey) then
      Break;
    
    ClearScreen(ColorSkyBlue);
    
    FillRectangle(ColorWhite, 192, 0, 192, 99);
    DrawText('I=Idle',   ColorBlack, 'lavinia.otf', 14, 200, 6);
    DrawText('R=Run',    ColorBlack, 'lavinia.otf', 14, 200, 26);
    DrawText('W=Walk',   ColorBlack, 'lavinia.otf', 14, 200, 46);
    DrawText('ESC=Quit', ColorBlack, 'lavinia.otf', 14, 200, 66);
    
    DrawAnimation(anim, BitmapNamed('bitmap_bear_' + name), 64, 33);
    UpdateAnimation(anim);
    
    if ((name = 'run') or (name = 'walk')) and AnimationEnded(anim) then
    begin
       name := 'idle'; AssignAnimation(anim, name, AnimationScriptNamed('script_bear_' +  name));
    end;
    
    RefreshScreen(60);

  until WindowCloseRequested();

  CloseAudio();
  ReleaseAllResources();
end.
