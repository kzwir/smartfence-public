CREATE PROCEDURE `populate_message` (IN `p_centralId` INT, IN `p_centralName` VARCHAR(100) CHARSET utf8, IN `p_messageTypeId` INT, IN `p_meesageDate` DATETIME, IN `p_moduleName` VARCHAR(100) CHARSET utf8, IN `p_moduleId` INT, IN `p_power` DECIMAL(5,2), IN `p_voltage` DECIMAL(5,2), IN `p_amperage` DECIMAL(5,2), IN `p_messageTxt` VARCHAR(100) CHARSET utf8)
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
B MojaCentrala;30:AE:A4:07:0D:64;B;2022/09/11/19/8/8;Bramofon2;30:AE:B4:08:AD:64;Twarzyczka1;								
C Centralna;30:AE:A4:07:0D:64;C;2022/09/11/1/8/8;								
D CentralaMC;30:AE:A4:07:0D:64;D;2022/09/8/0/8/8;								
E CentralaMC;30:AE:A4:07:0D:64;E;2022/09/11/19/59/8;								
F CentralaMC;30:AE:A4:07:0D:64;F;2022/09/14/5/8/8;								
G CentralaMC;30:AE:A4:07:0D:64;G;2022/09/11/19/8/8;PodLasem;30:AE:B4:08:AD:64;								

Wszystkie powyższe dane będą przesyłane w formie zmiennej tekstowej.									
Oznaczenie * unikalne- bez możliwości zmiany								
Oznaczenie # możliwość zmiany								
Data będzie znacznikiem z której godziny jest dany pomiar - pomiary uśredniane są przez 30 s i do centrali wysyłany jest komunikat średniej mocy, prądu, napięcia za ostatnie 30s. Centrala po zebraniu wszystkich pomiarów z modułów prześlę poszczególne wyniki do serwera.

call populate_message("30:AE:A4:07:0D:64", "CentralaMC", "1", "2022/11/15/19/14/2", "Plot1", "30:AE:B4:08:AD:64", 53.0, 25, 1.5, "");
call populate_message("30:AE:A4:07:0D:64", "CentralaPS", "A", "2022/09/11/19/8/8", "Bramofon2", "30:AE:B4:08:AD:64", -1, -1, -1, "brelok1");
call populate_message("30:AE:A4:07:0D:64", "MojaCentrala", "B", "2022/09/11/19/8/8", "Bramofon2", "30:AE:B4:08:AD:64", -1, -1, -1, "Twarzyczka1");
call populate_message("30:AE:A4:07:0D:64", "Centralna", "C", "2022/09/11/1/8/8", "", "", -1, -1, -1, "");
call populate_message("30:AE:A4:07:0D:64", "CentralaMC", "D", "2022/09/8/0/8/8", "", "", -1, -1, -1, "");
call populate_message("30:AE:A4:07:0D:64", "CentralaMC", "E", "2022/09/11/19/59/8", "", "", -1, -1, -1, "");
call populate_message("30:AE:A4:07:0D:64", "CentralaMC", "F", "2022/09/14/5/8/8", "", "", -1, -1, -1, "");
call populate_message("30:AE:A4:07:0D:64", "CentralaMC",  "G", "2022/09/11/19/8/8", "PodLasem", "30:AE:B4:08:AD:64", -1, -1, -1, "");
*/

	DECLARE messageId INT DEFAULT 0;
    INSERT IGNORE INTO central(id, id_central, name_central) VALUES (
        DEFAULT, p_centralId, p_centralName
    );
		
	-- messageTypeId = 'C' or 'D' or 'E' or 'F'
	SET messageId = LAST_INSERT_ID();
	INSERT message(id_message, date, central_id, message_type_id) VALUES (
		DEFAULT, p_messageDate, messageId, p_messageTypeId
	);
	
	SET messageId = LAST_INSERT_ID();  
	CASE p_messageTypeId 
      WHEN p_messageTypeId = '1' THEN 
		INSERT INTO photovoltaics (id, power, voltage, amperage, message_id) VALUES(
				default, p_power, p_voltage, p_amperage, messageId
        );
      WHEN p_messageTypeId = 'A' OR p_messageTypeId = 'B' THEN
		INSERT INTO enter (id, label_enter, message_id) VALUES(
				default, p_messageText, messageId
        );
	  WHEN p_messageTypeId = 'G' THEN
		INSERT IGNORE INTO module (id, id_module, name_module, message_id) VALUES(
			DEFAULT, p_moduleId, p_moduleName, messageId
		);
    END CASE;
	
    commit;
END