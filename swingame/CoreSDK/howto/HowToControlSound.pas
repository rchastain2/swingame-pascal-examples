program HowToControlSound;
uses
  SwinGame, sgTypes;  
procedure Main();
var
  sndEffect : SoundEffect;	
begin
  OpenAudio();
  
  OpenGraphicsWindow('How To Control Sound', 320, 240);
  LoadDefaultColors();  

  sndEffect := LoadSoundEffect('chipmunk.ogg');
  LoadSoundEffect('bells.ogg');
  LoadSoundEffect('camera.ogg');      
  LoadSoundEffect('comedy-boing.ogg'); 
  LoadSoundEffect('dinosaur.ogg');
  LoadSoundEffect('dog-bark.ogg');      
  
  repeat // The game loop...
    ProcessEvents();
    
    if KeyDown(RightCtrlKey) OR KeyDown(LeftCtrlKey) then
    begin
      if KeyTyped(Num1Key) then sndEffect := SoundEffectNamed('chipmunk.ogg');
      if KeyTyped(Num2Key) then sndEffect := SoundEffectNamed('bells.ogg');
      if KeyTyped(Num3Key) then sndEffect := SoundEffectNamed('camera.ogg');
      if KeyTyped(Num4Key) then sndEffect := SoundEffectNamed('comedy-boing.ogg');
      if KeyTyped(Num5Key) then sndEffect := SoundEffectNamed('dinosaur.ogg');
      if KeyTyped(Num6Key) then sndEffect := SoundEffectNamed('dog-bark.ogg');
    end
    else
    begin
      if KeyTyped(Num1Key) then PlaySoundEffect(sndEffect);
      if KeyTyped(Num2Key) then PlaySoundEffect(sndEffect, 0.5);
      if KeyTyped(Num3Key) then PlaySoundEffect(sndEffect, 3, 0.25);
      if KeyTyped(Num4Key) then PlaySoundEffect(sndEffect, -1, 0.1);
      if KeyTyped(Num5Key) then if SoundEffectPlaying(sndEffect) then StopSoundEffect(sndEffect);
    end;
    
    ClearScreen(ColorWhite);
    DrawText('Control Sound (Escape or q to quit)', ColorRed, 'arial.ttf', 18, 15, 15);
    DrawText('1: Play Sound At Full Volume', ColorBlue, 'arial.ttf', 14, 20, 50);
    DrawText('2: Play Sound At 50% Volume', ColorBlue, 'arial.ttf', 14, 20, 80);
    DrawText('3: Play Sound At 25% Volume 3 Times', ColorBlue, 'arial.ttf', 14, 20, 110);
    DrawText('4: Play Sound Continuously at 10%', ColorBlue, 'arial.ttf', 14, 20, 140);
    DrawText('5: Stop Playing Current Sound', ColorBlue, 'arial.ttf', 14, 20, 170);
    DrawText('CTRL + (1-6) load different sound effects', ColorBlue, 'arial.ttf', 14, 20, 200);		
    
    RefreshScreen(60);
  until WindowCloseRequested() OR KeyTyped(EscapeKey) OR KeyTyped(QKey);

  CloseAudio();
  ReleaseAllResources();
end;
begin
  Main();
end.