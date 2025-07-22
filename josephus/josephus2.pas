
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
  
type
  ppersonne = ^tpersonne;
  tpersonne = record
    index: integer;
    suivante: ppersonne;
  end;

var
  personne, autre, premiere: ppersonne;
  
procedure Init;
begin
  New(premiere);
  premiere^.index := 1;
  personne := premiere;
  for i := 2 to NOMBRE_DE_PERSONNES do
  begin
    New(autre);
    autre^.index := i;
    personne^.suivante := autre;
    personne := autre;
  end;
  personne^.suivante := premiere;
  personne := premiere;
  
  e := 0;
  c := 0;
end;

function Solve: boolean;
begin
  result := FALSE;
  if e = NOMBRE_DE_PERSONNES - 1 then
  begin
    AnnonceDernierVivant(personne^.index);
    result := TRUE;
  end else
  begin
    c := c mod NOMBRE_MORTEL + 1;
    if c = NOMBRE_MORTEL then
    begin
      Inc(e);
      autre^.suivante := personne^.suivante;
      AnnonceElimination(personne^.index, e);
      Dispose(personne);
      personne := autre;
    end else
      autre := personne;
    personne := personne^.suivante;
  end;
end;

procedure Show;
const
  FONT = 'lavinia.otf';
  SIZE = 28;
var
  w, h: integer;
  
  procedure DrawPerson(const index: integer; const c: Color);
  var
    x, y: integer;
  begin
    x := w * (Pred(index) div 10) + w;
    y := h * (Pred(index) mod 10) + h;
    DrawText(Format('%0.2d', [index]), c, FONT, SIZE, x, y);
  end;

var
  i: integer;
  p: ppersonne;
begin
  w := ScreenWidth() div 8;
  h := ScreenHeight() div 12;
  
  for i := 1 to NOMBRE_DE_PERSONNES do
    DrawPerson(i, ColorGray);
  
  p := personne;
  repeat
    DrawPerson(p^.index, ColorYellow);
    p := p^.suivante;
  until p^.suivante = personne;
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
