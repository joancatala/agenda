program PantallaPrincipal;
uses crt, UnitAgenda; { <--- AQUÍ ESTÀ EL TEU "INCLUDE" }

var opcio: char;

procedure DibuixaInterficie;
begin
  clrscr;
  { Barra superior }
  textbackground(Blue); textcolor(White);
  gotoxy(1,1); clreol;
  writeln('  SISTEMA DE GESTIO DE CONTACTES v1.0 - joan@riseup.net 2026');

  { Barra inferior }
  textbackground(Cyan); textcolor(Black);
  gotoxy(1, 28); clreol;
  write(' [1] Afegir  [2] Llistar  [3] Esborrar  [ESC] Sortir');
  
  textbackground(Black); textcolor(LightGray);
end;

begin
clrscr;
  repeat
    DibuixaInterficie;
    opcio := readkey; { Llegeix una tecla sense esperar a l'Intro }

    case opcio of
      '1': AfegirContacte;   { Cridem a la funció de la UnitAgenda }
      '2': LlistarContactes;
      '3': EsborrarContacte;
    end;
  until opcio = #27; { #27 és el codi de la tecla ESC }
  clrscr;
end.
