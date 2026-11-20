
program Demo;

uses
  SwinGame, sgTypes, SysUtils, Math;

const
  WINDOW_WIDTH = 640;
  WINDOW_HEIGHT = 480;
  BALL_KINDS = 24;
  MIN_SPEED = 1;
  MAX_SPEED = 4;
  INITIAL_BALLS = 10;
  MAX_BALLS = 60;

var
  ballBitmaps: array[0..BALL_KINDS - 1] of Bitmap;
  balls: array of Sprite;

procedure LoadBallBitmaps;
var
  i: integer;
begin
  for i := 0 to BALL_KINDS - 1 do
    ballBitmaps[i] := LoadBitmap(Format('sphere-%0.2d.png', [i]));
end;

function Overlaps(s: Sprite): boolean;
var
  i: integer;
begin
  result := FALSE;
  for i := 0 to High(balls) do
    if CircleCircleCollision(SpriteCollisionCircle(s), SpriteCollisionCircle(balls[i])) then
      Exit(TRUE);
end;

function Inside(s: Sprite): boolean;
begin
  result := (SpriteX(s) >= 0) and (SpriteY(s) >= 0)
    and (SpriteX(s) + SpriteWidth(s) <= ScreenWidth())
    and (SpriteY(s) + SpriteHeight(s) <= ScreenHeight());
end;

function AddBall(x, y: single): boolean;
var
  s: Sprite;
  radius: single;
begin
  result := FALSE;
  if Length(balls) >= MAX_BALLS then
    Exit;

  s := CreateSprite(ballBitmaps[Random(BALL_KINDS)]);
  radius := SpriteWidth(s) / 2;
  SpriteSetX(s, x - radius);
  SpriteSetY(s, y - radius);

  if Overlaps(s) or not Inside(s) then
  begin
    FreeSprite(s);
    Exit;
  end;

  SpriteSetVelocity(s, VectorFromAngle(Random(360), MIN_SPEED + Random * (MAX_SPEED - MIN_SPEED)));
  SpriteSetMass(s, radius * radius);
  SetLength(balls, Length(balls) + 1);
  balls[High(balls)] := s;
  result := TRUE;
end;

procedure AddRandomBalls(count: integer);
var
  added, attempts: integer;
begin
  added := 0;
  attempts := 0;
  while (added < count) and (attempts < 1000) do
  begin
    if AddBall(Random(ScreenWidth()), Random(ScreenHeight())) then
      Inc(added);
    Inc(attempts);
  end;
end;

procedure RemoveAllBalls;
var
  i: integer;
begin
  for i := 0 to High(balls) do
    FreeSprite(balls[i]);
  SetLength(balls, 0);
end;

procedure BounceOnWalls(s: Sprite);
var
  v: Vector;
begin
  v := SpriteVelocity(s);

  if SpriteX(s) < 0 then
  begin
    SpriteSetX(s, 0);
    v.x := Abs(v.x);
  end else if SpriteX(s) + SpriteWidth(s) > ScreenWidth() then
  begin
    SpriteSetX(s, ScreenWidth() - SpriteWidth(s));
    v.x := -Abs(v.x);
  end;

  if SpriteY(s) < 0 then
  begin
    SpriteSetY(s, 0);
    v.y := Abs(v.y);
  end else if SpriteY(s) + SpriteHeight(s) > ScreenHeight() then
  begin
    SpriteSetY(s, ScreenHeight() - SpriteHeight(s));
    v.y := -Abs(v.y);
  end;

  SpriteSetVelocity(s, v);
end;

procedure HandleCollisions;
var
  i, j: integer;
begin
  for i := 0 to High(balls) - 1 do
    for j := i + 1 to High(balls) do
      if CircleCircleCollision(SpriteCollisionCircle(balls[i]), SpriteCollisionCircle(balls[j])) then
        CollideCircles(balls[i], balls[j]);
end;

procedure UpdateBalls;
var
  i: integer;
begin
  for i := 0 to High(balls) do
  begin
    UpdateSprite(balls[i]);
    BounceOnWalls(balls[i]);
  end;
  HandleCollisions;
end;

procedure DrawBalls;
var
  i: integer;
begin
  for i := 0 to High(balls) do
    DrawSprite(balls[i]);
end;

procedure DrawInformation;
begin
  DrawText(Format('Balls: %d/%d', [Length(balls), MAX_BALLS]), ColorWhite, 10, 10);
  DrawText('Click: add a ball   R: random balls   C: clear   Esc: quit', ColorWhite, 10, WINDOW_HEIGHT - 20);
end;

var
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);

  Randomize;
  OpenGraphicsWindow('Bouncing balls', WINDOW_WIDTH, WINDOW_HEIGHT);
  LoadBallBitmaps;
  AddRandomBalls(INITIAL_BALLS);

  repeat
    ProcessEvents();

    if MouseClicked(LeftButton) then
      AddBall(MouseX(), MouseY());
    if KeyTyped(RKey) then
      AddRandomBalls(INITIAL_BALLS);
    if KeyTyped(CKey) then
      RemoveAllBalls;

    UpdateBalls;

    ClearScreen(RGBColor(40, 40, 40));
    DrawBalls;
    DrawInformation;
    RefreshScreen(60);
  until WindowCloseRequested() or KeyTyped(EscapeKey);

  RemoveAllBalls;
  ReleaseAllResources();
end.
