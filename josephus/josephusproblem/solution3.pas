
uses
  SysUtils, JosephusProblem;

type
  link = ^node;
  node = record
    key: integer;
    next: link;
  end;

const
  N = NOMBRE_DE_PERSONNES;
  M = NOMBRE_MORTEL;
  
var
  i: integer; 
  t, x: link;

begin
  New(t);
  t^.key := 1;
  x := t;
  for i := 2 to N do
  begin
    New(t^.next);
    t := t^.next;
    t^.key := i
  end;
  
  t^.next := x;
  while t <> t^.next do
  begin
    for i := 1 to M - 1 do
      t := t^.next;
    
    AnnonceElimination(t^.next^.key);
    
    x := t^.next;
    t^.next := t^.next^.next;
    Dispose(x);
  end;
  
  AnnonceDernierVivant(t^.key);
end.
