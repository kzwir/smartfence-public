<?php
/*
  Krzysztof Żwirek
  Szczegóły połączenia z esp32:
	- https://microdigisoft.com/esp32-insert-data-into-mysql-database-using-php-and-arduino-ide/
	- https://esp32io.com/tutorials/esp32-mysql
	- https://randomnerdtutorials.com/esp32-esp8266-mysql-database-php/

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
require_once "config.php";
include "dblayer.php";

function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

$api_key= $sensor = $location = $value1 = $value2 = $value3 = "";

$fp = fopen('zwir.txt', 'a');
	// fwrite($fp, $_SERVER["REQUEST_METHOD"]);
	$api_key_value = DbLayer::getApi();
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$api_key = test_input($_POST["apikey"]);
		
		// fwrite($fp, ' send apikey: ' . $_POST["apikey"] . ' internal: ' . $api_key_value);

		if($api_key == $api_key_value) {
			$centralId = test_input($_POST["cid"]);
			$centralName = test_input($_POST["cname"]);
			$messageTypeId = test_input($_POST["msgtypeid"]);
			$mesageDate = test_input($_POST["msgdate"]);
			$moduleName = test_input($_POST["mname"]);
			$moduleId = test_input($_POST["mid"]);
			$power = test_input($_POST["p"]);
			$voltage = test_input($_POST["v"]);
			$amperage = test_input($_POST["a"]);
			$messageTxt = test_input($_POST["msgtxt"]);

			// fwrite($fp, "\r\n Otrzymane dane: \r\ncentralId: " . $centralId . ";\r\ncentralName: " . $centralName . ";\r\n messageTypeId: " . $messageTypeId . ";\r\n meesageDate: " . $mesageDate . ";\r\n moduleName: " . $moduleName . ";\r\n moduleId: " . $moduleId . ";\r\n power: " . $power . ";\r\n voltage: " . $voltage . ";\r\n amperage: " . $amperage . ";\r\n messageTxt: " . $messageTxt);
			fwrite($fp, $centralId . "; " . $centralName . "; " . $messageTypeId . "; " . $mesageDate . "; " . $moduleName . "; " . $moduleId . "; " . $power . "; " . $voltage . "; " . $amperage . "; " . $messageTxt . ";\r\n");
			
			$db = new DbLayer();
			$db->update_msg($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId, $power, $voltage, $amperage, $messageTxt);

	/*
			switch($messageTypeId) {
				case '1': 
					$moduleName = test_input($_POST["modulename"]);
					$moduleId = test_input($_POST["moduleid"]);
					$power = test_input($_POST["power"]);
					$voltage = test_input($_POST["voltage"]);
					$amperage = test_input($_POST["amperage"]);
					// Nazwa Centrali ID Centrali	Rodzaj komunikatu (1)	Data RRRR/MM/DD/hh24/mi/ss	# Nazwa Modułu	* ID Modułu	Moc	Napięcie 	Prąd
					$db->update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId, $power, $voltage, $amperage);
				case 'A':
				case 'B':
					// Nazwa Centrali ID Centrali Rodzaj komunikatu (A/B) Data RRRR/MM/DD/hh24/mi/ss Nazwa Modułu ID Modułu Nazwa breloka RFID/Nazwa rozpoznanej twarzy
					$moduleName = test_input($_POST["modulename"]);
					$moduleId = test_input($_POST["moduleid"]);
					$messageTxt = test_input($_POST["messagetxt"]);
					$db->update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId, $messageTxt);
				case 'C':
				case 'D':
				case 'E':
				case 'F':
					// Nazwa Centrali ID Centrali Rodzaj komunikatu (C/D/E/F) Data RRRR/MM/DD/hh24/mi/ss
					$db->update_db($centralName, $centralId, $messageTypeId, $meesageDate);
				case 'G':
					// Nazwa Centrali ID Centrali Rodzaj komunikatu (G) Data RRRR/MM/DD/hh24/mi/ss Nazwa Modułu ID Modułu
					$moduleName = test_input($_POST["modulename"]);
					$moduleId = test_input($_POST["moduleid"]);
					$db->update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId);
			}
			$db = null;
	*/
		}
		else {
			echo " Wrong API Key provided. ";
			fwrite($fp, $centralId . "; " . $centralName . "; " . $messageTypeId . "; " . $mesageDate . "; " . $moduleName . "; " . $moduleId . "; " . $power . "; " . $voltage . "; " . $amperage . "; " . $messageTxt . ";\r\n");
		}
	}
	else {
		echo " No data posted with HTTP POST. ";
	}

fclose($fp);
?>