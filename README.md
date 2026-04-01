Una primera prova escrita amb Pascal per a refrescar un poc els coneixements d'aquest llenguate que va generar diversos dialectes, com l'Object Pascal, el llenguatge de Delphi, Kilix i Lazarus.

Bàsicament és un fitxer Agenda.pas amb la pantalla principal estructurada, i un altre fitxer UnitAgenda.pas des d'on prepare els procediments que vull executar des de la pantalla principal Agenda.pas, com: AfegirUsuaris, Llistarusuaris, Esborrarusuaris, Importarusuaris i Exportarusuaris.

<img src="https://github.com/joancatala/agenda/blob/main/captura_agenda1.png" alt="Captura de pantalla 1" />

Per a fer-ho funcionar, cal compilar el fitxer Agenda.pas però no cal compilar el UnitAgenda.pas. Compilarem així l'agenda:
Copy
$ fpc ./Agenda.pas 

<img src="https://github.com/joancatala/agenda/blob/main/captura_agenda2.png" alt="Captura de pantalla 2" />
