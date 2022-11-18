<?php
/**
 
 Krzysztof Żwirek
 Obsługa bazy danych MySQL
 2022.11.18

*/
class DbLayer {

    // flaga połączenia z bazą,
    // jeśli true — mamy połączenie
    // jeśli false — nie mamy połączenia
    private $connected = null;

    private $db_conn = null;

    /**
    * Łączy z bazą danych
    *
    * Dostęp do tej metody jest jedynie dla funkcji z tej klasy.
    * Klasa została zaprojektowana tak, aby nie trzeba było
    * zewnętrznie inicjować połączeń z SQL.
    * @return bool
    */
    final protected function conn() {
        // czy jesteśmy połączeni?
        if($this->connected) {
            return;
        } else {
            // nie, więc łączymy do SQL…
            $db_conn = new PDO("mysql:host={self::DB_HOST};dbname={self::DB_NAME}", self::DB_USER, self::DB_PASS, array(PDO::MYSQL_ATTR_INIT_COMMAND=>"SET NAMES utf8", PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
/*
            if(!@mysql_connect(self::DB_HOST, self::DB_USER, self::DB_PASS)) {
                throw new Exception('Błąd — brak dostępu do SQL.');
                return false;
            }

            // wybieramy bazę danych…
            if(!@mysql_select_db(self::DB_NAME)) {
                throw new Exception(‚Błąd — brak połączenia z bazą danych.’);
                return false;
            } else {
                // wybieramy kodowanie znaków UTF-8
                // to zapewnia obsługę polskich znaków w operacjach
                // skrypt — SQL.
                @mysql_query("SET NAMES 'utf8'");
                return true;

                // ustawiamy flagę na true
                $this->connected = true;
            }*/
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
}