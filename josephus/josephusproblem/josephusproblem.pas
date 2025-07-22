
unit JosephusProblem;

{
  Problème de Flavius Josèphe
  http://irem.u-strasbg.fr/php/articles/109_Lefort.pdf
}

interface

uses
  SysUtils;
  
const
  NOMBRE_DE_PERSONNES = 41;
  NOMBRE_MORTEL = 3;
  
procedure AnnonceElimination(const i, e: integer); overload;
procedure AnnonceElimination(const i: integer); overload;
procedure AnnonceDernierVivant(const i: integer);

implementation

procedure AnnonceElimination(const i, e: integer);
begin
  WriteLn(Format(
    'Élimination du n°%0.2d. Nombre de personnes éliminées : %0.2d',
    [i, e]
  ));
end;

procedure AnnonceElimination(const i: integer);
begin
  WriteLn(Format(
    'Élimination du n°%0.2d.',
    [i]
  ));
end;

procedure AnnonceDernierVivant(const i: integer);
begin
  WriteLn(Format(
    'La dernière personne vivante est le n°%0.2d.',
    [i]
  ));
end;

end.
