
uses
  SysUtils, JosephusProblem;
  
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
  
  repeat
    if e = NOMBRE_DE_PERSONNES - 1 then
    begin
      AnnonceDernierVivant(personne^.index);
      Break;
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
  until FALSE;
end.
