
program HowToDrawAnAnimation;

uses 
  SwinGame, sgTypes, Math;

var
  rotation: Animation;
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);
  
  OpenAudio();
  OpenGraphicsWindow('Animation example', 252, 252);
  
  LoadResourceBundle('demo.txt');

  rotation := CreateAnimation('rotation', AnimationScriptNamed('rotationScript'));
  
  repeat
    ProcessEvents();
    ClearScreen(ColorWhite);
    DrawAnimation(rotation, BitmapNamed('amethystBitmap'), 84, 84);
    UpdateAnimation(rotation);
    RefreshScreen(60);
  until WindowCloseRequested();

  Delay(800);

  CloseAudio();
  ReleaseAllResources();
end.
