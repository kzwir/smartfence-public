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
date_default_timezone_set('Europe/Warsaw');
$date = date('Y/m/d h:i:s a ', time());
fwrite($fp, $date);
//fwrite($fp, $_SERVER["REQUEST_METHOD"]);

$api_key_value = DbLayer::getApi();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$api_key = test_input($_POST["apikey"]);
	
	// fwrite($fp, ' send apikey: ' . $_POST["apikey"] . ' internal: ' . $api_key_value);

	if($api_key == $api_key_value) {
		$centralId = test_input($_POST["cid"]);
		$centralName = test_input($_POST["cname"]);
		$msgTypeId = test_input($_POST["msgtypeid"]);
		$msgDate = test_input($_POST["msgdate"]);
		$moduleName = test_input($_POST["mname"]);
		$moduleId = test_input($_POST["mid"]);
		$msgPower = test_input($_POST["p"]);
		$voltage = test_input($_POST["v"]);
		$amperage = test_input($_POST["a"]);
		$msgTxt = test_input($_POST["msgtxt"]);

		fwrite($fp, $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt . ";\r\n");
		
		try {
			$db = new DbLayer();
			fwrite($fp, "po new dblayer" . ";\r\n");
			$db->update_msg($centralName, $centralId, $msgTypeId, $msgDate, $moduleName, $moduleId, $msgPower, $voltage, $amperage, $msgTxt);
		}
		catch(Exception $e){
			fwrite($fp, "nie utworzono obiektu: " . $e . ";\r\n");
		}
	}
	else {
		echo " Wrong API Key provided. ";
		fwrite($fp, $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt . ";\r\n");
	}
}
else {
	echo " No data posted with HTTP POST. ";
}

fclose($fp);
?>