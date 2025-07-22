
uses
  SysUtils, JosephusProblem;

var
{ Nombre de personnes éliminées }
  e: integer;
{ Index de la personne }
  i: integer;
{ Compteur }
  c: integer;
{ Tableau des vivants }
  v: array[1..NOMBRE_DE_PERSONNES] of boolean;
  
begin
  for i := 1 to NOMBRE_DE_PERSONNES do
    v[i] := TRUE;
  
  e := 0;
  i := 0;
  c := 0;
  
  repeat
    i := i mod NOMBRE_DE_PERSONNES + 1;
    if v[i] then
    begin
      if e = NOMBRE_DE_PERSONNES - 1 then
      begin
        AnnonceDernierVivant(i);
        Break;
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
  until FALSE;
end.
