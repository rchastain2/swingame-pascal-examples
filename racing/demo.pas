
program Game;

uses
  SwinGame, sgTypes, SysUtils, Math;

type
  TPointArray = array [0..5] of Point2D;

const
  GRASS1_LEFT = 4;
  GRASS1_WIDTH = 57;
  GRASS1_TOP = 4;
  GRASS1_HEIGHT = 192;
  GRASS2_LEFT = 197;
  ROAD_LEFT = 61;
  ROAD_WIDTH = 136;
  FILE_WIDTH = 32;
  LINE_WIDTH = 2;
  LATERAL_LINE_WIDTH = 1;
  FILE1_LEFT = ROAD_LEFT + LATERAL_LINE_WIDTH;
  FILE2_LEFT = FILE1_LEFT + FILE_WIDTH + LINE_WIDTH;
  FILE3_LEFT = FILE2_LEFT + FILE_WIDTH + LINE_WIDTH;
  FILE4_LEFT = FILE3_LEFT + FILE_WIDTH + LINE_WIDTH;
  SCORE_LEFT = 259;
  SCORE_TOP = 20;
  SCORE_WIDTH = 57;
  SCORE_HEIGHT = 9;
  FUEL_LEFT = 259;
  FUEL_TOP = 50;
  FUEL_WIDTH = SCORE_WIDTH;
  FUEL_HEIGHT = SCORE_HEIGHT;
  SPEED_LEFT = 277;
  SPEED_TOP = 80;
  SPEED_WIDTH = 21;
  SPEED_HEIGHT = SCORE_HEIGHT;
  SPEED = 1;
  ENEMYSPEED = 3/2;
  ENEMY2SPEED = 1/2;
  FILE_LEFT: array[0..3] of integer = (FILE1_LEFT, FILE2_LEFT, FILE3_LEFT, FILE4_LEFT);
  
var
  LFontBmp: Bitmap;
  
procedure DrawRectangles;
begin
  FillRectangle(ColorBlue, GRASS1_LEFT + 1, GRASS1_TOP + 1, GRASS1_WIDTH - 2, GRASS1_HEIGHT - 2);
  FillRectangle(ColorBlue, GRASS2_LEFT + 1, GRASS1_TOP + 1, GRASS1_WIDTH - 2, GRASS1_HEIGHT - 2);
 {FillRectangle(ColorBlue, ROAD_LEFT + 1, GRASS1_TOP + 1, ROAD_WIDTH - 2, GRASS1_HEIGHT - 2);}
  FillRectangle(ColorOrange, FILE1_LEFT + 1, GRASS1_TOP + 1, FILE_WIDTH - 2, GRASS1_HEIGHT - 2);
  FillRectangle(ColorOrange, FILE2_LEFT + 1, GRASS1_TOP + 1, FILE_WIDTH - 2, GRASS1_HEIGHT - 2);
  FillRectangle(ColorOrange, FILE3_LEFT + 1, GRASS1_TOP + 1, FILE_WIDTH - 2, GRASS1_HEIGHT - 2);
  FillRectangle(ColorOrange, FILE4_LEFT + 1, GRASS1_TOP + 1, FILE_WIDTH - 2, GRASS1_HEIGHT - 2);
  FillRectangle(ColorYellow, SCORE_LEFT + 1, SCORE_TOP + 1, SCORE_WIDTH - 2, SCORE_HEIGHT - 2);
  FillRectangle(ColorYellow, FUEL_LEFT + 1, FUEL_TOP + 1, FUEL_WIDTH - 2, FUEL_HEIGHT - 2);
  FillRectangle(ColorYellow, SPEED_LEFT + 1, SPEED_TOP + 1, SPEED_WIDTH - 2, SPEED_HEIGHT - 2);
end;

procedure InitTrees(var ATrees: TPointArray; ABitmapWidth, ABitmapHeight: integer);
const
  SECTOR_HEIGHT = GRASS1_HEIGHT div 3;
var
  i, LLeft: integer;
begin
  for i := Low(ATrees) to High(ATrees) do
  begin
    if i mod 2 = 0 then LLeft := GRASS1_LEFT else LLeft := GRASS2_LEFT;
    ATrees[i].x := Random(GRASS1_WIDTH - ABitmapWidth) + LLeft;
    ATrees[i].y := Random(SECTOR_HEIGHT - ABitmapHeight) + SECTOR_HEIGHT * (i div 2) + GRASS1_TOP;
  end;
end;

procedure InitFuel(var AFuel: Point2D; ABitmapWidth, ABitmapHeight: integer);
begin
  AFuel.x := FILE_LEFT[Random(4)] + (32 - ABitmapWidth) div 2;
  AFuel.y := GRASS1_TOP - ABitmapHeight - Random(8) - GRASS1_HEIGHT;
end;

function CharToCell(c: char): integer;
var
  i: integer;
begin
  if c in ['1'..'9'] then result := Ord(c) - Ord('1')
  else if c in ['a'..'z', 'A'..'Z'] then result := Ord(UpCase(c)) - Ord('A') + 10
  else result := 9;
end;

procedure DrawFuelLevel(AFuel: integer);
begin
  if AFuel < FUEL_WIDTH - 2 then
    FillRectangle(ColorRed, AFuel + FUEL_LEFT + 1, FUEL_TOP + 1, (FUEL_WIDTH - 2) - AFuel, FUEL_HEIGHT - 2);
end;

procedure DrawScore(AScore: integer);
var
  s: string;
  i: integer;
begin
  s := Format('%0.9d', [AScore]);
  for i := 1 to Length(s) do
    DrawCell(LFontBmp, ChartoCell(s[i]), 6 * Pred(i) + SCORE_LEFT + 1, SCORE_TOP + 1);
end;

procedure DrawSpeed(ASpeed: integer);
var
  s: string;
  i: integer;
begin
  if ASpeed < 0 then
    ASpeed := 0;
  s := Format('%0.3d', [ASpeed]);
  for i := 1 to Length(s) do
    DrawCell(LFontBmp, ChartoCell(s[i]), 6 * Pred(i) + SPEED_LEFT + 1, SPEED_TOP + 1);
end;
  
var
  LBgBmp, LUiBmp, LRoadBmp, LPlayerBmp, LTreeBmp, LCarEnemyBmp, LCarEnemy2Bmp, LFuelBmp: Bitmap;
  LPlayer, LCarEnemy, LCarEnemy2, LFuel: Point2D;
  LTrees: TPointArray;
  LRoadTop, LSpeed, LScore, LFuelLevel: double;
  LMusic: Music;
  LCrashSE, LGetFuelSE, LGameOverSE: SoundEffect;
  LFont: Font;
  LGameOver: boolean;
  i: integer;

procedure LoadBitmaps;
begin
  LBgBmp := LoadBitmap('bg.png');
  LUiBmp := LoadBitmap('ui.png');
  LTreeBmp := LoadBitmap('tree.png');
  LRoadBmp := LoadBitmap('road.png');
  LPlayerBmp := LoadBitmap('car-player.png');
  LCarEnemyBmp := LoadBitmap('car-enemy.png');
  LCarEnemy2Bmp := LoadBitmap('car-enemy2.png');
  LFuelBmp := LoadBitmap('fuel.png');
  LFontBmp := LoadBitmap('ui-font [5x5].png');
  BitmapSetCellDetails(LFontBmp, 6, 6, 10, 4, 36);
  LFont := LoadFont('supermariobros2.ttf', 8);
  LCrashSE := LoadSoundEffect('sfx_damage_hit2.wav');
  LGetFuelSE := LoadSoundEffect('sfx_sounds_powerup13.wav');
  LGameOverSE := LoadSoundEffect('GameOver.wav');
  LMusic := LoadMusic('CrocoRocket.mp3');
end;

procedure InitGame;
begin
  InitTrees(LTrees, BitmapWidth(LTreeBmp), BitmapHeight(LTreeBmp));
  LRoadTop := GRASS1_TOP;
  LPlayer.x := FILE_LEFT[Random(2) + 2] + (32 - BitmapWidth(LPlayerBmp)) div 2;
  LPlayer.y := GRASS1_TOP + (GRASS1_HEIGHT - BitmapHeight(LPlayerBmp)) div 2;
  LCarEnemy.x := FILE_LEFT[Random(2) + 2] + (32 - BitmapWidth(LCarEnemyBmp)) div 2;
  LCarEnemy.y := GRASS1_TOP + GRASS1_HEIGHT;
  LCarEnemy2.x := FILE_LEFT[Random(2)] + (32 - BitmapWidth(LCarEnemy2Bmp)) div 2;
  LCarEnemy2.y := GRASS1_TOP - BitmapHeight(LCarEnemy2Bmp) - Random(8);
  LSpeed := SPEED;
  LScore := 0;
  LFuelLevel := FUEL_WIDTH - 2;
  InitFuel(LFuel, BitmapWidth(LFuelBmp), BitmapHeight(LFuelBmp));
end;

procedure DrawGame;
begin
  DrawBitmap(LBgBmp, 0, 0);
  for i := Low(LTrees) to High(LTrees) do
  begin
    DrawBitmap(LTreeBmp, LTrees[i].x, LTrees[i].y);
  end;
  DrawBitmap(LRoadBmp, ROAD_LEFT, LRoadTop);
  DrawBitmap(LRoadBmp, ROAD_LEFT, LRoadTop + BitmapHeight(LRoadBmp));
  DrawBitmap(LRoadBmp, ROAD_LEFT, LRoadTop + 2 * BitmapHeight(LRoadBmp));
  with LPlayer do DrawBitmap(LPlayerBmp, x, y);
  with LCarEnemy do DrawBitmap(LCarEnemyBmp, x, y);
  with LCarEnemy2 do DrawBitmap(LCarEnemy2Bmp, x, y);
  DrawBitmap(LUiBmp, 0, 0);
  DrawScore(Round(10 * Trunc(LScore)));
  DrawSpeed(Round(10 * LSpeed));
  DrawFuelLevel(Round(LFuelLevel));
  with LFuel do DrawBitmap(LFuelBmp, x, y);
 {DrawRectangles;}
end;

procedure HandleInput;
const
 {DX = FILE_WIDTH + LINE_WIDTH;}
  DX = 1;
begin
  if KeyTyped(UpKey) then LSpeed := LSpeed + 1/2;
  if KeyTyped(DownKey) then LSpeed := LSpeed - 1/2;
  if {KeyTyped}KeyDown(LeftKey) then if LPlayer.x > (FILE_LEFT[0] + (32 - BitmapWidth(LPlayerBmp)) div 2) then LPlayer.x := LPlayer.x - DX;
  if {KeyTyped}KeyDown(RightKey) then if LPlayer.x < (FILE_LEFT[3] + (32 - BitmapWidth(LPlayerBmp)) div 2) then LPlayer.x := LPlayer.x + DX;
end;

procedure UpdateGame;
begin
  for i := Low(LTrees) to High(LTrees) do
  begin
    LTrees[i].y := LTrees[i].y + LSpeed;
    if LTrees[i].y > GRASS1_TOP + GRASS1_HEIGHT then
      LTrees[i].y := GRASS1_TOP - BitmapHeight(LTreeBmp) - Random(8);
  end;
  
  LRoadTop := LRoadTop + LSpeed;
  if LRoadTop > GRASS1_TOP then
    LRoadTop := LRoadTop - BitmapHeight(LRoadBmp);
  LCarEnemy.y := LCarEnemy.y + LSpeed - ENEMYSPEED;
  LCarEnemy2.y := LCarEnemy2.y + LSpeed + ENEMY2SPEED;
  
  if LCarEnemy.y < GRASS1_TOP - BitmapHeight(LCarEnemyBmp) then
  begin
    LCarEnemy.x := FILE_LEFT[Random(2) + 2] + (32 - BitmapWidth(LCarEnemyBmp)) div 2;
    LCarEnemy.y := GRASS1_TOP + GRASS1_HEIGHT + Random(8);
  end else
  if LCarEnemy.y > GRASS1_TOP + GRASS1_HEIGHT then
  begin
    LCarEnemy.x := FILE_LEFT[Random(2) + 2] + (32 - BitmapWidth(LCarEnemyBmp)) div 2;
    LCarEnemy.y := GRASS1_TOP - BitmapHeight(LCarEnemyBmp) - Random(8);
  end;
  
  if LCarEnemy2.y < GRASS1_TOP - BitmapHeight(LCarEnemy2Bmp) then
  begin
    LCarEnemy2.x := FILE_LEFT[Random(2)] + (32 - BitmapWidth(LCarEnemy2Bmp)) div 2;
    LCarEnemy2.y := GRASS1_TOP + GRASS1_HEIGHT + Random(8);
  end else
  if LCarEnemy2.y > GRASS1_TOP + GRASS1_HEIGHT then
  begin
    LCarEnemy2.x := FILE_LEFT[Random(2)] + (32 - BitmapWidth(LCarEnemy2Bmp)) div 2;
    LCarEnemy2.y := GRASS1_TOP - BitmapHeight(LCarEnemy2Bmp) - Random(8);
  end;
  
  LFuel.y := LFuel.y + LSpeed;
  if LFuel.y > GRASS1_TOP + GRASS1_HEIGHT then
    LFuel.y := GRASS1_TOP - BitmapHeight(LFuelBmp) - Random(8);
end;

procedure HandleCollisions;
begin
  if BitmapCollision(LPlayerBmp, LPlayer, LCarEnemyBmp, LCarEnemy)
  or BitmapCollision(LPlayerBmp, LPlayer, LCarEnemy2Bmp, LCarEnemy2) then
  begin
    PlaySoundEffect(LCrashSE); Sleep(500);
    PlaySoundEffect(LGameOverSE);
    LGameOver := TRUE;
  end else
  begin
    if LSpeed > 0 then
    begin
      LScore := LScore + LSpeed;
      LFuelLevel := LFuelLevel - LSpeed / 60;
    end;
  end;
  
  if BitmapCollision(LPlayerBmp, LPlayer, LFuelBmp, LFuel) then
  begin
    InitFuel(LFuel, BitmapWidth(LFuelBmp), BitmapHeight(LFuelBmp));
    LFuelLevel := Min(LFuelLevel + 3, FUEL_WIDTH - 2);
    PlaySoundEffect(LGetFuelSE);
  end else
  if BitmapCollision(LCarEnemyBmp, LCarEnemy, LFuelBmp, LFuel)
  or BitmapCollision(LCarEnemy2Bmp, LCarEnemy2, LFuelBmp, LFuel) then
  begin
    InitFuel(LFuel, BitmapWidth(LFuelBmp), BitmapHeight(LFuelBmp));
  end;
end;

procedure DrawGameOver;
const
  CText = 'Press S to start' + LineEnding + 'or' + LineEnding + 'Esc to quit';
  CRect: Rectangle = (
    x: GRASS1_LEFT;
    y: GRASS1_TOP + 3 * GRASS1_HEIGHT div 4;
    width: 2 * GRASS1_WIDTH + ROAD_WIDTH;
    height: GRASS1_HEIGHT div 4
  );
begin
  FillRectangle(ColorGray, CRect);
  DrawText(CText, ColorYellow, ColorGray, LFont, AlignCenter, CRect);
end;

var
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);
  
  Randomize;
  LoadBitmaps;
  OpenGraphicsWindow('C64 Style Racing', 320, 200);
  PlayMusic(LMusic);
  InitGame;
  repeat
    ProcessEvents();
    if LGameOver then
    begin
      StopMusic;
      DrawGameOver;
      RefreshScreen(60);
      if KeyTyped(SKey) then
      begin
        PlayMusic(LMusic);
        InitGame;
        LGameOver := FALSE;
      end;
    end else
    begin
     {ClearScreen(ColorWhite);}
      DrawGame;
      RefreshScreen(60);
      HandleInput;
      UpdateGame;
      HandleCollisions;
    end;
  until WindowCloseRequested() or KeyTyped(EscapeKey);
end.
