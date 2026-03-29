program PantallaPrincipal;
uses crt, UnitAgenda; { <--- AQUÍ ESTÀ EL TEU "INCLUDE" }

var opcio: char;

procedure AmagaCursor;
begin
  CursorOff;
  write(#27, '[?25l');
end;

procedure MostraCursor;
begin
  CursorOn;
  write(#27, '[?25h');
end;

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
  write(' [1] Afegir [2] Llistar [3] Esborrar [i] Importar [e] Exportar [ESC] Sortir');

  { Logo central dins de la pantalla principal }
  textbackground(Black);
  textcolor(LightCyan);
  gotoxy(1, 8);  writeln('    AAAA       GGGGGGGG   EEEEEEEEE   N      N   DDDDDDD      AAAA     ');
  gotoxy(1, 9);  writeln('   AA  AA     GG          EE          NN     N   DD    D     AA  AA    ');
  gotoxy(1, 10); writeln('  AA    AA   GG           EE          N N    N   DD     D   AA    AA   ');
  gotoxy(1, 11); writeln('  AAAAAAAA   GG   GGGGG   EEEEEEE     N  N   N   DD     D   AAAAAAAA   ');
  gotoxy(1, 12); writeln('  AA    AA   GG     GGG   EE          N   N  N   DD     D   AA    AA   ');
  gotoxy(1, 13); writeln('  AA    AA    GG      G   EE          N    N N   DD    D    AA    AA   ');
  gotoxy(1, 14); writeln('  AA    AA     GGGGGGGG   EEEEEEEEE   N     NN   DDDDDDD    AA    AA   ');

  textcolor(White);
  gotoxy(22, 17); writeln('Sistema de gestió de contactes');
  
  textbackground(Black); textcolor(LightGray);
end;

begin
  AmagaCursor;
  repeat
    DibuixaInterficie;
    AmagaCursor;
    opcio := readkey; { Llegeix una tecla sense esperar a l'Intro }

    case opcio of
      '1': AfegirContacte;   { Cridem a la funció de la UnitAgenda }
      '2': LlistarContactes;
      '3': EsborrarContacte;
      'i', 'I': ImportarContactes;
      'e', 'E': ExportarContactes;
    end;
  until opcio = #27; { #27 és el codi de la tecla ESC }
  MostraCursor;
  clrscr;
end.
