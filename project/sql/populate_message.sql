CREATE PROCEDURE `populate_message` (IN `centralId` INT, IN `centralName` VARCHAR(100) CHARSET utf8, IN `messageTypeId` INT, IN `meesageDate` DATETIME, IN `moduleName` VARCHAR(100) CHARSET utf8, IN `moduleId` INT, IN `power` DECIMAL(5,2), IN `voltage` DECIMAL(5,2), IN `amperage` DECIMAL(5,2), IN `messageTxt` VARCHAR(100) CHARSET utf8)
BEGIN
/*
Rodzaje komunikatów:
1 komunikaty o produkcji fotowoltaiki
2 komunikaty bezpieczeństwa
A komunikat o wejściu na teren brelokiem RFID
B komunikat o wejściu na teren po rozpoznaniu twarzy
C rozbrojenie alarmu
D uzbrojenie alarmu
E utrata energii - przejście na zasilanie bateryjne
F uruchomienie urządzenia
G włamanie

Składowe ramek									
1 Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (1)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Moc	Napięcie 	Prąd
A Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (A)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Nazwa breloka RFID		
B Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (B)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Nazwa rozpoznanej twarzy		
C Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (C)	Data RRRR/MM/DD/hh24/mi/ss					
D Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (D)	Data RRRR/MM/DD/hh24/mi/ss					
E Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (E)	Data RRRR/MM/DD/hh24/mi/ss					
F Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (F)	Data RRRR/MM/DD/hh24/mi/ss					
G Nazwa Centrali	* ID Centrali	Rodzaj komunikatu (G)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu			

Przykładowe ramki									
1 CentralaMC;30:AE:A4:07:0D:64;1;2022/11/15/19/14/2;Plot1;30:AE:B4:08:AD:64;53,0;25,0;1,5;								
A CentralaPS;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;Bramofon2;30:AE:B4:08:AD:64;brelok1;								
B MojaCentrala;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;Bramofon2;30:AE:B4:08:AD:64;Twarzyczka1;								
C Centralna;30:AE:A4:07:0D:64;A;2022/09/11/1/8/8;								
D CentralaMC;30:AE:A4:07:0D:64;A;2022/09/8/0/8/8;								
E CentralaMC;30:AE:A4:07:0D:64;A;2022/09/11/19/59/8;								
F CentralaMC;30:AE:A4:07:0D:64;A;2022/09/14/5/8/8;								
G CentralaMC;30:AE:A4:07:0D:64;A;2022/09/11/19/8/8;PodLasem;30:AE:B4:08:AD:64;								

Wszystkie powyższe dane będą przesyłane w formie zmiennej tekstowej.									
Oznaczenie * unikalne- bez możliwości zmiany								
Oznaczenie # możliwość zmiany								
Data będzie znacznikiem z której godziny jest dany pomiar - pomiary uśredniane są przez 30 s i do centrali wysyłany jest komunikat średniej mocy, prądu, napięcia za ostatnie 30s. Centrala po zebraniu wszystkich pomiarów z modułów prześlę poszczególne wyniki do serwera. 									
*/

	DECLARE messageId INT DEFAULT 0;
    INSERT IGNORE INTO central(id, id_central, name_central) VALUES (
        DEFAULT, centralId, centralName
    );
		
	-- messageTypeId = 'C' or 'D' or 'E' or 'F'
	SET messageId = LAST_INSERT_ID();
	INSERT message(id_message, date, central_id, message_type_id) VALUES (
		DEFAULT, messageDate, messageId, messageTypeId
	);
  
	CASE messageTypeId 
      WHEN messageTypeId = '1' THEN 
		INSERT INTO photovoltaics (id, power, voltage, amperage, message_id) VALUES(
				default, power, voltage, amperage, messageId
        );
      WHEN messageTypeId = 'A' OR messageTypeId = 'B' THEN
		INSERT INTO enter (id, label_enter, message_id) VALUES(
				default, messageText, messageId
        );
	  WHEN messageTypeId = 'G' THEN
		INSERT IGNORE INTO module (id, id_module, name_module, message_id) VALUES(
			DEFAULT, moduleId, moduleName, messageId
		);
    END CASE;
	
    commit;
END