-- Active: 1668522799726@@127.0.0.1@33060@fence
BEGIN
    DECLARE centralId INT;
    -- DECLARE centralName VARCHAR;
    DECLARE centralTypeId INT;
    DECLARE messageTypeId INT;
    DECLARE meesageDate DATETIME;
    /*DECLARE moduleName VARCHAR(45);
    DECLARE moduleId INT;
    DECLARE power DECIMAL(5,2);
    DECLARE voltage DECIMAL(5,2);
    DECLARE amperage DECIMAL(5,2);
    DECLARE messageTxt VARCHAR(45);*/

    select * from central;
/*
    centralId = get_int();
    centralName = get_string(45);
    centralTypeId = FLOOR(1 + RAND() * 2);
    messageTypeId = FLOOR(1 + RAND() * 2);
    meesageDate = get_date();
    moduleId = get_int();
    moduleName = get_string(45);
    power = get_float(5,2);
    voltage = get_int(5,2);
    amperage = get_int(5,2);
    messageTxt = get_string(45);


    call populate_message(centralId, centralName, centralTypeId, messageTypeId, meesageDate, moduleId, moduleName, power, voltage, amperage, messageTxt);
    */
END

/* dane mock do testów b.d.
Rodzaje komunikatów:
1. photovoltaics:
    Nazwa Centrali
    ID Centrali (unikalne - bez możliwości zmiany)
    Rodzaj komunikatu 1
    Data RRRR/MM/DD hh24:mi:ss
    Nazwa Modułu (domyślnie będzie to np. segment1 - ale użytkownik może zmienić tą nazwę na np. obokLasu)
    ID Modułu (unikalne - bez możliwości zmiany)
    Moc
    Napięcie 
    Prąd
2. security:
    Nazwa Centrali
    ID Centrali (unikalne - bez możliwości zmiany)
    Rodzaj komunikatu 2A
    Data RRRR/MM/DD hh24:mi:ss
    Nazwa Modułu (domyślnie będzie to np. Furtka1 - ale użytkownik może zmienić tą nazwę na np. Wejscie Od Tylu)
    ID Modułu (unikalne - bez możliwości zmiany)
    Nazwa breloka RFID (domyślnie brelok1...brelok10
*/

-- wstawienie mockowych danych do b.d.