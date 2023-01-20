<?php
function test_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

$api_key= $sensor = $location = $value1 = $value2 = $value3 = "";

$api_key_value = 'tPmAT5Ab3j7F9';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    print_r($_POST);
	$api_key = test_input($_POST["apikey"]);

    try {
        $fp = fopen('zwir.txt', 'a');
        date_default_timezone_set('Europe/Warsaw');
        $date = date('Y/m/d h:i:s a ', time());
        fwrite($fp, $date);
        echo $api_key . "; ";
        fwrite($fp, $api_key."; ");
        
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

            echo $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt;
            fwrite($fp, $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt; . "\r\n";
        }
        else {
            echo " Wrong API Key provided. ";
        }

        fclose($fp);

    }
    catch (Exception $e) {
        echo "Błąd w trakcie łączenia z b.d.: " . $e->getMessage() . "<br/>";
        if($this->fp)
                fwrite($this->fp, "Błąd w trakcie łączenia z b.d.: " . $e->getMessage() . ";\r\n");
    }
*/
}
else {
	echo " No data posted with HTTP POST. ";

    /*
        curl -d "name=Angelo&website=unixcop" -X POST https://unixcop.com/
        curl -d "apikey=tPmAT5Ab3j7F9&cid=AE:30:9E:9A:B3:69&cname=quisquam&msgtypeid=C&msgdate=2014/09/26 17:22:09&mname=voluptatem&mid=F3:B5:EA:DC:A3:22&p=0&v=0&a=0&msgtxt=" -X POST http://51.75.252.91/info.php
    */
}
?>