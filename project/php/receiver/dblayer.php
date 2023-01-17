<?php
/********************************************************************************************/
/* Krzysztof Żwirek                                                                         */
/*  Obsługa bazy danych MySQL                                                               */
/*  2022.11.18                                                                              */
/********************************************************************************************/

require_once( 'config.php' );

class DbLayer extends DatabaseSettings
{
    // flaga połączenia z bazą,
    // jeśli true — mamy połączenie
    // jeśli false — nie mamy połączenia
    private $connected = false;

    private $db_conn = null;

    private $fp = null;

    public static function getApi() {
        return DatabaseSettings::APIKEY;
    }

    /**
    * Łączy z bazą danych
    *
    * Dostęp do tej metody jest jedynie dla funkcji z tej klasy.
    * Klasa została zaprojektowana tak, aby nie trzeba było
    * zewnętrznie inicjować połączeń z SQL.
    * @return bool
    */
    final protected function conn() {
//        if($this->fp)
//            fwrite($this->fp, "funkcja conn() " . ";\r\n");

        // czy jesteśmy połączeni?
        if($this->connected) {
//            if($this->fp)
//                    fwrite($this->fp, "return true jestesmy polaczeni." . ";\r\n");
            return;
        } else {
            // nie, więc łączymy do SQL…
            try {
                // Load settings from parent class
                $settings = DatabaseSettings::getSettings();                
                $host = $settings['dbhost'];
                $dbName = $settings['dbname'];
                $user = $settings['dbusername'];
                $pass = $settings['dbpassword'];
//                if($this->fp)
//                    fwrite($this->fp, 'host: ' . $host . ' dbname: ' . $dbName . ' user: ' . $user . ' pswd: ' . $pass . ";\r\n");

                $this->db_conn = new PDO("mysql:host={$host};dbname={$dbName}", $user, $pass);
                $this->db_conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                $this->connected = true;

                /*if($this->fp){
                    if($this->connected){
                        fwrite($this->fp, "connected true ;\r\n");
                    }

                    $sql = "SELECT count(*) FROM fence.message_type";
                    $res = $this->db_conn->query($sql);
                    $count = $res->fetchColumn();
                    fwrite($this->fp, "polaczono z b.d. i odczytano: " .  $count  . " rekordów.\r\n");
                }*/
            }
            catch (Exception $e) {
                print "Błąd w trakcie łączenia z b.d.: " . $e->getMessage() . "<br/>";
                if($this->fp)
                    fwrite($this->fp, "Błąd w trakcie łączenia z b.d.: " . $e->getMessage() . ";\r\n");
            }
        }
    }

    /**
    * Escape dla wszelkich danych wrzucanych do bazy
    *
    * Pozwala to zapobiec atakom SQL Injection poprzez wysyłanie
    * do SQL zapytań zawierających niedozwolone znaki.
    *
    * @param string $str — tekst do escape’owania
    * @return string — poprawiony text
    */
    final public function esc( $str ) {
        if(!$this->connected) 
            $this->conn();
        
        // wyrzucamy tagi html
        $zle_znaki = array('<','>','=');
        $poprawione = str_replace($zle_znaki, “, $str);
        
        // zamieniamy n na
        $poprawione = nl2br($poprawione);
        return mysql_real_escape_string($poprawione);
    }

    /**
    * Formatuj datę z SQL z komórki o typie danych DATETIME
    * @param db $db — tablica z wynikami zapytania SQL
    * @return string
    */
    public function putdate( $db ) {
        // zakładamy, że komórka ma nazwę ‚created_at’.
        $rok = substr($db['created_at'], 0, 4);
        $miesiac = substr($db['created_at'], 5, 2);
        $dzien = substr($db['created_at'], 8, 2);
        
        // zamień miesiące na skróty
        switch($miesiac) {
            case '01': $miesiac = 'Stycznia'; break;
            case '02': $miesiac = 'Lutego'; break;
            case '03': $miesiac = 'Marca'; break;
            case '04': $miesiac = 'Kwietnia'; break;
            case '05': $miesiac = 'Maja'; break;
            case '06': $miesiac = 'Czerwca'; break;
            case '07': $miesiac = 'Lipca'; break;
            case '08': $miesiac = 'Sierpnia'; break;
            case '09': $miesiac = 'Września'; break;
            case '10': $miesiac = 'Października'; break;
            case '11': $miesiac = 'Listopada'; break;
            case '12': $miesiac = 'Grudnia'; break;
        }
        // pozbądź się zera z dni
        if( $dzien < 10 )
            $dzien = substr($dzien, 1, 1);

        $godzina = substr($db['created_at'], 11, 2);
        $minuta = substr($db['created_at'], 14, 2);
        
        // pozbądź się zera z godziny
        if( $godzina < 10 )
            $godzina = substr($godzina, 1, 1);
        
        $data = $dzien.' '.$miesiac.' '.$rok.' o godz. '.$godzina.':'.$minuta;
        return $data;
    }

    /**
    * Funkcja wstawia dane do bazy danych fence dane z komunikatu.
    * Wywoływana jest procedura wbudowana, która na podstawie rodzaju wiadomości wstawia odpowiednie dane do tabel.
    *
    * @param string $query
    * @param string $centralName
    * @param int $centralId
    * @param int $msgTypeId
    * @param datetime $msgDate
    * @param string $moduleName
    * @param int $moduleId
    * @param decimal $msgPower
    * @param decimal $voltage
    * @param decimal $amperage
    * @param string $msgTxt;
    * @return bool
    */
    public function update_msg($centralName, $centralId, $msgTypeId, $msgDate, $moduleName, $moduleId, $msgPower, $voltage, $amperage, $msgTxt) {
        $this->fp = fopen('zwirdblayer.txt', 'a');
        date_default_timezone_set('Europe/Warsaw');
        $date = date('Y/m/d h:i:s a ', time());
        fwrite($this->fp, $date);

        if(!$this->connected){
            $this->conn();
        }

        try {
            // calling stored procedure command
            $sql = 'CALL fence.populate_message(:p_centralId, :p_centralName, :p_msgTypeId, :p_msgDate, :p_moduleName, :p_moduleId, :p_power, :p_voltage, :p_amperage, :p_msgTxt)';

            fwrite($this->fp, "parametry: " . $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt . ";\r\n");

            // prepare for execution of the stored procedure
//            if(!$this->db_conn)
//                fwrite($this->fp, "db_conn false line 175" . ";\r\n");

            if($this->db_conn){
                $stmt = $this->db_conn->prepare($sql);
//                fwrite($this->fp, "po prepare line 179" . ";\r\n");

/* do testow
                $centralName = 'quas';
                $centralId = 'A6:8B:55:11:3E:BF';
                $msgTypeId = '1';
                $msgDate = '1996/03/02 03:00:49';
                $moduleName = 'molestiae';
                $moduleId = 'A6:8B:7C:DB:B6:34';
                $msgPower = 1.1;
                $voltage = 2.2;
                $amperage = 3.3;
                $msgTxt = '4.4';
                fwrite($this->fp, "parametry: " . $centralId . "; " . $centralName . "; " . $msgTypeId . "; " . $msgDate . "; " . $moduleName . "; " . $moduleId . "; " . $msgPower . "; " . $voltage . "; " . $amperage . "; " . $msgTxt . ";\r\n");
*/
                // pass value to the command
                $stmt->bindParam(':p_centralId', $centralId, PDO::PARAM_STR);
                $stmt->bindParam(':p_centralName', $centralName, PDO::PARAM_STR);
                $stmt->bindParam(':p_msgTypeId', $msgTypeId);
                $stmt->bindParam(':p_msgDate', $msgDate);
                $stmt->bindParam(':p_moduleName', $moduleName, PDO::PARAM_STR);
                $stmt->bindParam(':p_moduleId', $moduleId, PDO::PARAM_STR);
                $stmt->bindParam(':p_power', $msgPower);
                $stmt->bindParam(':p_voltage', $voltage);
                $stmt->bindParam(':p_amperage', $amperage);
                $stmt->bindParam(':p_msgTxt', $msgTxt, PDO::PARAM_STR);

//                fwrite($this->fp, "po bind params;\r\n");

                // execute the stored procedure
                $stmt->execute();

//                fwrite($this->fp, "po execute;\r\n");

                $stmt->closeCursor();

//                fwrite($this->fp, "po closecursor;\r\n");
            }
            else {
                fwrite($this->fp, "db_conn jest null." . ";\r\n");
            }
        }
        // catch (PDOException $e) {
        catch (Exception $e) {
            print "Błąd update_proc_db: " . $e->getMessage() . "<br/>";
            fwrite($this->fp, "Błąd update_proc_db: " . $e->getMessage() . ";\r\n");
            // die();
        }

        fclose($this->fp);
    }

    /**
    * Funkcja wstawia dane do bazy danych fence dane z komunikatu 1
    *
    * @param string $query
    * @param string $centralName
    * @param int $centralId
    * @param int $messageTypeId
    * @param datetime $meesageDate
    * @param string $moduleName
    * @param int $moduleId
    * @param decimal $power
    * @param decimal $voltage
    * @param decimal $amperage
    * @return bool
    */
    public function update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId, $power, $voltage, $amperage ) {
        if(!$this->connected)
            $this->conn();
        try {
            $dodaj = $db_conn->prepare("INSERT IGNORE INTO central(id, name, central_type_id) VALUES (:centralId, :centralName)");
            $dodaj = execute(array(':centralId'=>$centralId,':centralName'=>$centralName));

            $dodaj = $db_conn->prepare("INSERT IGNORE INTO module (id, name, central_id) VALUES(:moduleId, :moduleName, :centralId)");
            $dodaj = execute(array(':moduleId'=>$moduleId,':moduleName'=>$moduleName, ':centralId'=>centralId));
        
            $dodaj = $db_conn->prepare("INSERT INTO photovoltaics (id, central_id, date, power, voltage, amperage, message_type_id) VALUES(:default, :centralId, :meesageDate, :power, :voltage, :amperage, :lastparam");
            $dodaj = execute(array('default'=>"default", ':centralId'=>$centralId,':meesageDate'=>$meesageDate, ':power'=>$power, ':voltage'=>$voltage, ':amperage'=>$amperage, ':latsparam'=>"1"));

            $db_conn = null;
        }
        catch (PDOException $e) {
            print "Błąd update_db v. 1: " . $e->getMessage() . "<br/>";
            die();
        }
    }



/*

    public function update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId, $messageTxt ) {
        if(!$this->connected)
            $this->conn();
        try {
            $dodaj = $db_conn->prepare("INSERT IGNORE INTO central(id, name, central_type_id) VALUES (:centralId, :centralName)");
            $dodaj = execute(array(':centralId'=>$centralId,':centralName'=>$centralName));

            $dodaj = $db_conn->prepare("INSERT IGNORE INTO module (id, name, central_id) VALUES(:moduleId, :moduleName, :centralId)");
            $dodaj = execute(array(':moduleId'=>$moduleId,':moduleName'=>$moduleName, ':centralId'=>centralId));
        
            $dodaj = $db_conn->prepare("INSERT INTO security (id, central_id, date, value, message_type_id) VALUES(:default, :centralId, :meesageDate, :messageTxt, :messageTypeId");
            $dodaj = execute(array('default'=>"default", ':centralId'=>$centralId,':meesageDate'=>$meesageDate, ':messageTxt'=>$messageTxt, ':messageTypeId'=>$messageTypeId));

            $db_conn = null;
        }
        catch (PDOException $e) {
            print "Błąd update_db v. 2: " . $e->getMessage() . "<br/>";
            die();
        }
    }

    public function update_db($centralName, $centralId, $messageTypeId, $meesageDate ) {
        if(!$this->connected)
            $this->conn();
        try {
            $dodaj = $db_conn->prepare("INSERT IGNORE INTO central(id, name, central_type_id) VALUES (:centralId, :centralName)");
            $dodaj = execute(array(':centralId'=>$centralId,':centralName'=>$centralName));
        
            $dodaj = $db_conn->prepare("INSERT INTO security (id, central_id, date, value, message_type_id) VALUES(:default, :centralId, :meesageDate, :messageTxt, :messageTypeId");
            $dodaj = execute(array('default'=>"default", ':centralId'=>$centralId,':meesageDate'=>$meesageDate, ':messageTxt'=>"null", ':messageTypeId'=>$messageTypeId));

            $db_conn = null;
        }
        catch (PDOException $e) {
            print "Błąd update_db v. 3: " . $e->getMessage() . "<br/>";
            die();
        }
    }

    public function update_db($centralName, $centralId, $messageTypeId, $meesageDate, $moduleName, $moduleId) {
        if(!$this->connected)
            $this->conn();
        try {
            $dodaj = $db_conn->prepare("INSERT IGNORE INTO central(id, name, central_type_id) VALUES (:centralId, :centralName)");
            $dodaj = execute(array(':centralId'=>$centralId,':centralName'=>$centralName));

            $dodaj = $db_conn->prepare("INSERT IGNORE INTO module (id, name, central_id) VALUES(:moduleId, :moduleName, :centralId)");
            $dodaj = execute(array(':moduleId'=>$moduleId,':moduleName'=>$moduleName, ':centralId'=>centralId));
        
            $dodaj = $db_conn->prepare("INSERT INTO security (id, central_id, date, value, message_type_id) VALUES(:default, :centralId, :meesageDate, :messageTxt, :messageTypeId");
            $dodaj = execute(array('default'=>"default", ':centralId'=>$centralId,':meesageDate'=>$meesageDate, ':messageTxt'=>"null", ':messageTypeId'=>$messageTypeId));

            $db_conn = null;
        }
        catch (PDOException $e) {
            print "Błąd update_db v. 4: " . $e->getMessage() . "<br/>";
            die();
        }
    }
*/
}

