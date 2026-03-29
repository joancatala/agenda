unit UnitAgenda;

interface

uses crt, sysutils;

procedure AfegirContacte;
procedure LlistarContactes;
procedure EsborrarContacte;
procedure DibuixaMarcTreball;

implementation

procedure DibuixaMarcTreball;
var i: integer;
begin
  textcolor(Cyan);
  for i := 2 to 79 do
  begin
    gotoxy(i, 4); write('═');
    gotoxy(i, 23); write('═');
  end;
  for i := 5 to 22 do
  begin
    gotoxy(1, i); write('║');
    gotoxy(80, i); write('║');
  end;
  gotoxy(1, 4); write('╠');
  gotoxy(80, 4); write('╣');
  gotoxy(1, 23); write('╚');
  gotoxy(80, 23); write('╝');
end;

procedure NetejaZona;
var i: integer;
begin
  textbackground(Black);
  for i := 5 to 22 do
  begin
    gotoxy(2, i); clreol;
    gotoxy(80, i); write('║');
  end;
  gotoxy(3, 6);
  textcolor(White);
end;

procedure AfegirContacte;
var
  nom, telefon: string;
  fitxer: text;
begin
  NetejaZona;
  writeln('─── NOU CONTACTE ───');
  gotoxy(3, 8); write('Nom: '); readln(nom);
  gotoxy(3, 9); write('Telefon: '); readln(telefon);

  assign(fitxer, 'contactes.txt');
  {$I-} append(fitxer);
  if ioresult <> 0 then rewrite(fitxer); {$I+}

  writeln(fitxer, nom, ' - ', telefon);
  close(fitxer);
  
  textcolor(LightGreen);
  gotoxy(3, 11); writeln('>> Contacte desat correctament!');
end;

procedure LlistarContactes;
const max_contacts = 1000;
      page_size = 15;
var
  contacts: array[1..max_contacts] of string;
  fitxer: text;
  comptador, pagina_actual, pagines_totals, i, linia_inici, linia_fi: integer;
  key: char;
begin
  NetejaZona;
  comptador := 0;
  assign(fitxer, 'contactes.txt');
  {$I-} reset(fitxer); {$I+}
  if ioresult <> 0 then
  begin
    textcolor(LightRed);
    writeln('L''agenda esta buida o el fitxer no existeix.');
    exit;
  end;
  // Carregar tots els contactes a l'array
  while not eof(fitxer) and (comptador < max_contacts) do
  begin
    readln(fitxer, contacts[comptador + 1]);
    inc(comptador);
  end;
  close(fitxer);
  if comptador = 0 then
  begin
    textcolor(LightRed);
    writeln('L''agenda esta buida.');
    exit;
  end;
  pagines_totals := (comptador + page_size - 1) div page_size;
  pagina_actual := 1;
  repeat
    NetejaZona;
    writeln('─── LLISTA DE CONTACTES (pàgina ', pagina_actual, ' de ', pagines_totals, ') ───');
    linia_inici := (pagina_actual - 1) * page_size + 1;
    linia_fi := linia_inici + page_size - 1;
    if linia_fi > comptador then linia_fi := comptador;
    for i := linia_inici to linia_fi do
    begin
      gotoxy(3, 6 + (i - linia_inici + 1));
      writeln(i, '. ', contacts[i]);
    end;
    // Opcions
    textcolor(Yellow);
    gotoxy(3, 22);
    if pagina_actual > 1 then write('P ') else write('  ');
    if pagina_actual < pagines_totals then write('N ') else write('  ');
    write('Q per sortir');
    key := upcase(readkey);
    case key of
      'P': if pagina_actual > 1 then dec(pagina_actual);
      'N': if pagina_actual < pagines_totals then inc(pagina_actual);
      'Q': exit;
    end;
  until false;
end;

procedure EsborrarContacte;
var
  fitxer, temp: text;
  linia, cerca: string;
  trobat: boolean;
begin
  NetejaZona;
  writeln('─── ESBORRAR CONTACTE ───');
  gotoxy(3, 8); write('Nom a eliminar: '); readln(cerca);

  if trim(cerca) = '' then
  begin
    textcolor(LightRed);
    gotoxy(3, 10); writeln('>> No has escrit un nom, no faig res.');
    exit;
  end;

  assign(fitxer, 'contactes.txt');
  assign(temp, 'temp_agenda.txt');

  {$I-} reset(fitxer); {$I+}
  if ioresult <> 0 then
    writeln('No hi ha dades.')
  else
  begin
    rewrite(temp);
    trobat := false;
    while not eof(fitxer) do
    begin
      readln(fitxer, linia);
      if pos(upcase(cerca), upcase(linia)) = 0 then
        writeln(temp, linia)
      else
        trobat := true;
    end;
    close(fitxer); close(temp);
    erase(fitxer); rename(temp, 'contactes.txt');

    gotoxy(3, 12);
    if trobat then textcolor(LightRed) else textcolor(White);
    if trobat then writeln('>> Contacte eliminat.') else writeln('>> No trobat.');
  end;
end;

end.
