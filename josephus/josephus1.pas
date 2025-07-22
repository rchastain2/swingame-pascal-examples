
program Josephus;

uses
  SwinGame, sgTypes, JosephusProblem, SysUtils, Math;

var
{ Nombre de personnes éliminées }
  e: integer;
{ Index de la personne }
  i: integer;
{ Compteur }
  c: integer;
{ Tableau des vivants }
  v: array[1..NOMBRE_DE_PERSONNES] of boolean;

procedure Init;
begin
  for i := 1 to NOMBRE_DE_PERSONNES do
    v[i] := TRUE;
  
  e := 0;
  i := 0;
  c := 0;
end;

function Solve: boolean;
begin
  result := FALSE;
  i := i mod NOMBRE_DE_PERSONNES + 1;
  if v[i] then
  begin
    if e = NOMBRE_DE_PERSONNES - 1 then
    begin
      AnnonceDernierVivant(i);
      result := TRUE;
    end else
    begin
      c := c mod NOMBRE_MORTEL + 1;
      if c = NOMBRE_MORTEL then
      begin
        Inc(e);
        v[i] := FALSE;
        AnnonceElimination(i, e);
      end;
    end;
  end;
end;

procedure Show;
const
  FONT = 'lavinia.otf';
  SIZE = 28;
var
  w, h, i, x, y: integer;
  c: Color;
begin
  w := ScreenWidth() div 8;
  h := ScreenHeight() div 12;
  for i := 1 to NOMBRE_DE_PERSONNES do
  begin
    x := w * (Pred(i) div 10) + w;
    y := h * (Pred(i) mod 10) + h;
    if v[i] then
      c := ColorYellow
    else
      c := ColorGray;
    DrawText(Format('%0.2d', [i]), c, FONT, SIZE, x, y);
  end;
end;

var
  solved: boolean;
  FPUExceptionMask: TFPUExceptionMask;

begin
  FPUExceptionMask := GetExceptionMask;
  SetExceptionMask(FPUExceptionMask + [exZeroDivide, exInvalidOp]);
  
  OpenGraphicsWindow('Josephus Problem Solver', 512, 512);
  Init;
  solved := FALSE;
  repeat
    ProcessEvents();
    ClearScreen(ColorBlack);
    if not solved then solved := Solve;
    Show;    
    RefreshScreen(60);
  until WindowCloseRequested() or AnyKeyPressed();
end.
