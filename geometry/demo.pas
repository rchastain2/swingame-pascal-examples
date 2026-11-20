
program Demo;

uses
  SwinGame, sgTypes, SysUtils, Math;

type
  TScene = record
    title: string;
    count: integer;
    points: array[0..4] of Point2D;
  end;

const
  WINDOW_WIDTH = 640;
  WINDOW_HEIGHT = 480;
  SCENE_COUNT = 4;
  HANDLE_RADIUS = 6;
  GRAB_DISTANCE = 10;
  MARKER_RADIUS = 5;
  CIRCLE_RADIUS = 70;
  RECT_WIDTH = 150;
  RECT_HEIGHT = 90;
  MIN_LENGTH = 1;

var
  scenes: array[1..SCENE_COUNT] of TScene;
  current: integer = 1;
  dragged: integer = -1;
  wasDown: boolean = FALSE;
  info: string;

procedure SetScene(index: integer; const title: string; const coords: array of single);
var
  i: integer;
begin
  scenes[index].title := title;
  scenes[index].count := Length(coords) div 2;
  for i := 0 to scenes[index].count - 1 do
    scenes[index].points[i] := PointAt(coords[2 * i], coords[2 * i + 1]);
end;

procedure InitScenes;
begin
  SetScene(1, 'Segment intersection', [100, 120, 520, 380, 120, 380, 460, 90]);
  SetScene(2, 'Closest point and distance', [90, 390, 280, 110, 460, 250]);
  SetScene(3, 'Point inside a shape', [70, 400, 170, 120, 270, 380, 340, 90, 470, 340]);
  SetScene(4, 'Tangents and segment-circle intersection', [420, 250, 80, 120, 330, 420]);
end;

function P(index: integer): Point2D;
begin
  result := scenes[current].points[index];
end;

function Segment(a, b: integer): LineSegment;
begin
  result := LineFrom(P(a), P(b));
end;

function CircleAround(index: integer): Circle;
begin
  result := CircleAt(P(index), CIRCLE_RADIUS);
end;

function LongEnough(const line: LineSegment): boolean;
begin
  result := PointPointDistance(line.startPoint, line.endPoint) >= MIN_LENGTH;
end;

procedure HandleKeyboard;
var
  i, previous: integer;
begin
  previous := current;
  for i := 1 to SCENE_COUNT do
    if KeyTyped(KeyCode(Ord(Num1Key) + i - 1)) then
      current := i;
  if KeyTyped(TabKey) then
    current := current mod SCENE_COUNT + 1;
  if current <> previous then
    dragged := -1;
end;

procedure HandleMouse;
var
  i: integer;
  m: Point2D;
  down: boolean;
begin
  m := MousePosition();
  down := MouseDown(LeftButton);

  if not down then
    dragged := -1
  else if not wasDown then
    for i := 0 to scenes[current].count - 1 do
      if PointPointDistance(m, P(i)) <= GRAB_DISTANCE then
      begin
        dragged := i;
        Break;
      end;

  if dragged <> -1 then
    scenes[current].points[dragged] := PointAt(EnsureRange(m.x, 0, WINDOW_WIDTH - 1), EnsureRange(m.y, 0, WINDOW_HEIGHT - 1));

  wasDown := down;
end;

procedure DrawMarker(clr: Color; const pt: Point2D);
begin
  FillCircle(clr, pt.x, pt.y, MARKER_RADIUS);
end;

procedure DrawThickLine(clr: Color; const line: LineSegment);
begin
  DrawLine(clr, line, OptionLineWidth(3));
end;

function PointText(const pt: Point2D): string;
begin
  result := Format('(%.0f, %.0f)', [pt.x, pt.y]);
end;

procedure DrawIntersectionScene;
var
  s1, s2: LineSegment;
  pt: Point2D;
begin
  s1 := Segment(0, 1);
  s2 := Segment(2, 3);
  DrawThickLine(ColorDodgerBlue, s1);
  DrawThickLine(ColorOrange, s2);

  if not (LongEnough(s1) and LongEnough(s2)) then
    info := 'A segment is too short'
  else if not LineIntersectionPoint(s1, s2, pt) then
    info := 'The segments are parallel'
  else if LineSegmentsIntersect(s1, s2) then
  begin
    DrawMarker(ColorRed, pt);
    info := 'The segments intersect at ' + PointText(pt);
  end else
  begin
    DrawLine(ColorGray, LineMidPoint(s1), pt);
    DrawLine(ColorGray, LineMidPoint(s2), pt);
    DrawCircle(ColorGray, pt.x, pt.y, MARKER_RADIUS);
    info := 'The segments do not intersect, their lines meet at ' + PointText(pt);
  end;
end;

procedure DrawClosestPointScene;
var
  line: LineSegment;
  c: Circle;
  m, onLine, onCircle: Point2D;
begin
  line := Segment(0, 1);
  c := CircleAround(2);
  m := MousePosition();
  DrawThickLine(ColorDodgerBlue, line);
  DrawCircle(ColorOrange, c, OptionLineWidth(3));

  if PointPointDistance(m, c.center) >= MIN_LENGTH then
  begin
    onCircle := ClosestPointOnCircle(m, c);
    DrawLine(ColorGray, m, onCircle);
    DrawMarker(ColorOrange, onCircle);
  end;

  if LongEnough(line) then
  begin
    onLine := ClosestPointOnLine(m, line);
    DrawLine(ColorGray, m, onLine);
    DrawMarker(ColorDodgerBlue, onLine);
    info := Format('Distance to the segment: %.0f   to the circle: %.0f',
      [PointLineDistance(m, line), Abs(PointPointDistance(m, c.center) - c.radius)]);
  end else
    info := 'The segment is too short';
end;

procedure DrawInsideScene;
var
  tri: Triangle;
  rect: Rectangle;
  c: Circle;
  m: Point2D;
  names: string;

  procedure Add(const name: string);
  begin
    if names <> '' then
      names := names + ', ';
    names := names + name;
  end;

begin
  tri := TriangleFrom(P(0), P(1), P(2));
  rect := RectangleFrom(P(3), RECT_WIDTH, RECT_HEIGHT);
  c := CircleAround(4);
  m := MousePosition();
  names := '';

  if PointInTriangle(m, tri) then
  begin
    FillTriangle(ColorDodgerBlue, tri);
    Add('triangle');
  end else
    DrawTriangle(ColorDodgerBlue, tri);

  if PointInRect(m, rect) then
  begin
    FillRectangle(ColorOrange, rect);
    Add('rectangle');
  end else
    DrawRectangle(ColorOrange, rect);

  if PointInCircle(m, c) then
  begin
    FillCircle(ColorLimeGreen, c);
    Add('circle');
  end else
    DrawCircle(ColorLimeGreen, c);

  if names = '' then
    info := 'The mouse is outside every shape'
  else
    info := 'The mouse is inside the ' + names;
end;

procedure DrawTangentScene;
var
  c: Circle;
  line: LineSegment;
  m, t1, t2: Point2D;
  crossing: boolean;
begin
  c := CircleAround(0);
  line := Segment(1, 2);
  m := MousePosition();
  crossing := LongEnough(line) and LineIntersectsCircle(line, c);

  DrawCircle(ColorOrange, c, OptionLineWidth(3));
  if crossing then
    DrawThickLine(ColorRed, line)
  else
    DrawThickLine(ColorDodgerBlue, line);

  if TangentPoints(m, c, t1, t2) then
  begin
    DrawLine(ColorGray, m, t1);
    DrawLine(ColorGray, m, t2);
    DrawMarker(ColorOrange, t1);
    DrawMarker(ColorOrange, t2);
    info := 'Tangent points ' + PointText(t1) + ' and ' + PointText(t2);
  end else
    info := 'The mouse is inside the circle';

  if crossing then
    info := info + '   The segment crosses the circle';
end;

procedure DrawHandles;
var
  i: integer;
begin
  for i := 0 to scenes[current].count - 1 do
  begin
    FillCircle(ColorWhite, P(i).x, P(i).y, HANDLE_RADIUS);
    DrawCircle(ColorBlack, P(i).x, P(i).y, HANDLE_RADIUS);
  end;
end;

procedure Draw;
begin
  ClearScreen(RGBColor(30, 30, 35));

  case current of
    1: DrawIntersectionScene;
    2: DrawClosestPointScene;
    3: DrawInsideScene;
    4: DrawTangentScene;
  end;
  DrawHandles;

  FillRectangle(RGBColor(50, 50, 60), 0, 0, WINDOW_WIDTH, 44);
  DrawText(Format('%d/%d  %s', [current, SCENE_COUNT, scenes[current].title]), ColorWhite, 10, 8);
  DrawText(info, ColorLightGray, 10, 26);
  DrawText('Drag the white handles   1-4, Tab: scene   Esc: quit', ColorWhite, 10, WINDOW_HEIGHT - 20);
end;

var
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);

  OpenGraphicsWindow('Geometry', WINDOW_WIDTH, WINDOW_HEIGHT);
  InitScenes;

  repeat
    ProcessEvents();
    HandleKeyboard;
    HandleMouse;
    Draw;
    RefreshScreen(60);
  until WindowCloseRequested() or KeyTyped(EscapeKey);

  ReleaseAllResources();
end.
