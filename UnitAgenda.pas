unit UnitAgenda;

interface

uses crt, sysutils;

procedure AfegirContacte;
procedure LlistarContactes;
procedure EsborrarContacte;
procedure ExportarContactes;
procedure ImportarContactes;
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

function LlegirLiniaCancelar(var cancelat: boolean): string;
var
  c: char;
  linea: string;
begin
  linea := '';
  cancelat := false;
  while True do
  begin
    c := readkey;
    case c of
      #13: // Enter
        begin
          writeln;
          break;
        end;
      #27: // Esc
        begin
          cancelat := true;
          writeln;
          LlegirLiniaCancelar := '';
          exit;
        end;
      #8: // Backspace
        if length(linea) > 0 then
        begin
          linea := copy(linea, 1, length(linea) - 1);
          write(#8, ' ', #8);
        end
        else
          ;
      else
        begin
          linea := linea + c;
          write(c);
        end;
    end;
  end;  LlegirLiniaCancelar := linea;
end;

procedure AfegirContacte;
var
  nom, telefon, correu: string;
  fitxer: text;
  cancelat: boolean;
begin
  NetejaZona;
  writeln('─── NOU CONTACTE ───');
  gotoxy(3, 8); write('Nom:');
  gotoxy(8, 8);
  gotoxy(3, 22); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(8, 8);
  nom := LlegirLiniaCancelar(cancelat);
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 15); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;
  if trim(nom) = '' then
  begin
    textcolor(LightRed);
    gotoxy(3, 15); writeln('>> No has escrit un nom.');
    exit;
  end;

  gotoxy(3, 9); write('Telefon:');
  gotoxy(12, 9);
  gotoxy(3, 22); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(12, 9);
  telefon := LlegirLiniaCancelar(cancelat);
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 15); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;
  if trim(telefon) = '' then
  begin
    textcolor(LightRed);
    gotoxy(3, 15); writeln('>> No has escrit un telefon.');
    exit;
  end;

  gotoxy(3, 10); write('Correu Electrònic: ');
  gotoxy(22, 10);
  gotoxy(3, 14); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(22, 10);
  correu := LlegirLiniaCancelar(cancelat);
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 15); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;
  if trim(correu) = '' then
  begin
    textcolor(LightRed);
    gotoxy(3, 15); writeln('>> No has escrit un correu.');
    exit;
  end;

  assign(fitxer, 'contactes.txt');
  {$I-} append(fitxer);
  if ioresult <> 0 then rewrite(fitxer); {$I+}

  writeln(fitxer, nom, ' - ', telefon, ' - ', correu);
  close(fitxer);
  
  textcolor(LightGreen);
  gotoxy(3, 17); writeln('>> Has afegit a ', nom, ' - ', telefon, ' - ', correu);
  gotoxy(3, 18); writeln('Prem qualsevol tecla per continuar...');
  readkey;
end;

procedure LlistarContactes;
const max_contacts = 1000;
      page_size = 12;
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
      gotoxy(3, 7 + (i - linia_inici + 1));
      writeln(i, '. ', contacts[i]);
    end;
    // Opcions
    textcolor(Yellow);
    gotoxy(3, 22); write(' ' :77); gotoxy(3, 22);
    if pagina_actual > 1 then write('P(ujar) | ');
    if pagina_actual < pagines_totals then write('B(baixar) | ');
    write('ESC per sortir');
    key := upcase(readkey);
    case key of
      'P': if pagina_actual > 1 then dec(pagina_actual);
      'B': if pagina_actual < pagines_totals then inc(pagina_actual);
      #27: exit;
    end;
  until false;
end;

procedure EsborrarContacte;
var
  fitxer, temp: text;
  comptador, num_a_esborrar, i: integer;
  cancelat: boolean;
  input_str, linia, esborrat: string;
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
  // Comptar contactes
  while not eof(fitxer) do
  begin
    readln(fitxer);
    inc(comptador);
  end;
  close(fitxer);
  if comptador = 0 then
  begin
    textcolor(LightRed);
    writeln('L''agenda esta buida.');
    exit;
  end;

  // Demanar número
  gotoxy(3, 8); write('Número de contacte a eliminar:');
  gotoxy(35, 8);
  gotoxy(3, 22); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(35, 8);
  input_str := LlegirLiniaCancelar(cancelat);
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 10); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;

  // Validar entrada
  val(trim(input_str), num_a_esborrar, i);
  if (i <> 0) or (num_a_esborrar < 1) or (num_a_esborrar > comptador) then
  begin
    textcolor(LightRed);
    gotoxy(3, 10); writeln('>> Número invàlid.');
    exit;
  end;

  // Esborrar el contacte
  assign(fitxer, 'contactes.txt');
  reset(fitxer);
  assign(temp, 'temp_agenda.txt');
  rewrite(temp);
  i := 1;
  while not eof(fitxer) do
  begin
    readln(fitxer, linia);
    if i = num_a_esborrar then
      esborrat := linia
    else
      writeln(temp, linia);
    inc(i);
  end;
  close(fitxer);
  close(temp);
  erase(fitxer);
  rename(temp, 'contactes.txt');

  textcolor(LightGreen);
  gotoxy(3, 12); writeln('>> Has esborrat a ', esborrat);
  gotoxy(3, 13); writeln('Prem qualsevol tecla per continuar...');
  readkey;
end;

procedure ExportarContactes;
var
  origen, desti: text;
  nom_desti, linia, nom, telefon, correu, resta: string;
  p1, p2: integer;
  cancelat: boolean;
begin
  NetejaZona;
  gotoxy(3, 7); writeln('─── EXPORTAR CONTACTES ───');
  gotoxy(3, 9); write('Nom del fitxer de destí: ');
  gotoxy(29, 9);
  gotoxy(3, 22); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(29, 9);
  nom_desti := trim(LlegirLiniaCancelar(cancelat));
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 11); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;
  if nom_desti = '' then
    nom_desti := 'contactes_exportats.csv';

  assign(origen, 'contactes.txt');
  {$I-} reset(origen); {$I+}
  if ioresult <> 0 then
  begin
    textcolor(LightRed);
    gotoxy(3, 11); writeln('>> No s''ha trobat contactes.txt.');
    exit;
  end;

  assign(desti, nom_desti);
  rewrite(desti);
  writeln(desti, '"Nom";"Telefon";"Correu"');
  while not eof(origen) do
  begin
    readln(origen, linia);
    p1 := pos(' - ', linia);
    nom := '';
    telefon := '';
    correu := '';

    if p1 > 0 then
    begin
      nom := trim(copy(linia, 1, p1 - 1));
      resta := copy(linia, p1 + 3, length(linia));
      p2 := pos(' - ', resta);
      if p2 > 0 then
      begin
        telefon := trim(copy(resta, 1, p2 - 1));
        correu := trim(copy(resta, p2 + 3, length(resta)));
      end
      else
        telefon := trim(resta);
    end
    else
      nom := trim(linia);

    writeln(desti, '"', nom, '";"', telefon, '";"', correu, '"');
  end;
  close(origen);
  close(desti);

  textcolor(LightGreen);
  gotoxy(3, 12); writeln('>> Contactes exportats a ', nom_desti);
  gotoxy(3, 13); writeln('Prem qualsevol tecla per continuar...');
  readkey;
end;

procedure ImportarContactes;
var
  origen, desti: text;
  nom_origen, linia, nom, telefon, correu: string;
  p1, p2: integer;
  cancelat: boolean;
begin
  NetejaZona;
  gotoxy(3, 7); writeln('─── IMPORTAR CONTACTES ───');
  gotoxy(3, 9); write('Nom del fitxer origen: ');
  gotoxy(26, 9);
  gotoxy(3, 22); textcolor(Yellow); write('(ESC per sortir)');
  textcolor(White);
  gotoxy(26, 9);
  nom_origen := trim(LlegirLiniaCancelar(cancelat));
  if cancelat then
  begin
    textcolor(Yellow);
    gotoxy(3, 11); writeln('>> Operació cancel·lada, retornant al menú.');
    exit;
  end;
  if nom_origen = '' then
    nom_origen := 'contactes_exportats.txt';

  assign(origen, nom_origen);
  {$I-} reset(origen); {$I+}
  if ioresult <> 0 then
  begin
    textcolor(LightRed);
    gotoxy(3, 11); writeln('>> No s''ha pogut obrir ', nom_origen);
    exit;
  end;

  assign(desti, 'contactes.txt');
  {$I-} append(desti);
  if ioresult <> 0 then rewrite(desti); {$I+}

  while not eof(origen) do
  begin
    readln(origen, linia);
    linia := trim(linia);
    if linia = '' then
      continue;

    p1 := pos(';', linia);
    if p1 > 0 then
    begin
      p2 := pos(';', copy(linia, p1 + 1, length(linia)));
      if p2 > 0 then
      begin
        p2 := p2 + p1;
        nom := trim(copy(linia, 1, p1 - 1));
        telefon := trim(copy(linia, p1 + 1, p2 - p1 - 1));
        correu := trim(copy(linia, p2 + 1, length(linia)));

        if (length(nom) >= 2) and (nom[1] = '"') and (nom[length(nom)] = '"') then
          nom := copy(nom, 2, length(nom) - 2);
        if (length(telefon) >= 2) and (telefon[1] = '"') and (telefon[length(telefon)] = '"') then
          telefon := copy(telefon, 2, length(telefon) - 2);
        if (length(correu) >= 2) and (correu[1] = '"') and (correu[length(correu)] = '"') then
          correu := copy(correu, 2, length(correu) - 2);

        if lowercase(nom) <> 'nom' then
          writeln(desti, nom, ' - ', telefon, ' - ', correu);
      end
      else
        writeln(desti, linia);
    end
    else
      writeln(desti, linia);
  end;
  close(origen);
  close(desti);

  textcolor(LightGreen);
  gotoxy(3, 12); writeln('>> Importació completada des de ', nom_origen);
  gotoxy(3, 13); writeln('Prem qualsevol tecla per continuar...');
  readkey;
end;

end.
