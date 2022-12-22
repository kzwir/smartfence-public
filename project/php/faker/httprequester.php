<?php
/**
 * from: https://stackoverflow.com/questions/5647461/how-do-i-send-a-post-request-with-php
 * GET
 * $response = HTTPRequester::HTTPGet("http://localhost/service/foobar.php", array("getParam" => "foobar"));
 * POST
 * $response = HTTPRequester::HTTPPost("http://localhost/service/foobar.php", array("postParam" => "foobar"));
 * PUT
 * $response = HTTPRequester::HTTPPut("http://localhost/service/foobar.php", array("putParam" => "foobar"));
 * DELETE
 * $response = HTTPRequester::HTTPDelete("http://localhost/service/foobar.php", array("deleteParam" => "foobar"));
 * 
 */
    class HTTPRequester {

        public static function httpRequesterUrlEncode($string) {
            $entities = array('%21', '%2A', '%27', '%28', '%29', '%3B', '%3A', '%40', '%26', '%3D', '%2B', '%24', '%2C', '%2F', '%3F', '%25', '%23', '%5B', '%5D');
            $replacements = array('!', '*', "'", "(", ")", ";", ":", "@", "&", "=", "+", "$", ",", "/", "?", "%", "#", "[", "]");
            return str_replace($entities, $replacements, urlencode($string));
        }

        public static function preparePostFields($array) {
            $params = array();
          
            foreach ($array as $key => $value) {
              $params[] = $key . '=' . urlencode($value);
              echo $key . '; ' . $value . '</br>';
            }
            
            print_r($params);
            echo '</br> nastepny wiersz </br>';
            print_r(implode('&', $params)) ;
            echo '</br>';
            return implode('&', $params);
          }

        /**
         * @description Make HTTP-GET call
         * @param       $url
         * @param       array $params
         * @return      HTTP-Response body or an empty string if the request fails or is empty
         */
        public static function HTTPGet($url, array $params) {
            $query = http_build_query($params); 
            $ch    = curl_init($url.'?'.$query);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HEADER, false);
            $response = curl_exec($ch);
            curl_close($ch);
            return $response;
        }
        /**
         * @description Make HTTP-POST call
         * @param       $url
         * @param       array $params
         * @return      HTTP-Response body or an empty string if the request fails or is empty
         */
        public static function HTTPPost($url, array $params) {
            $query = http_build_query($params);          
            $ch    = curl_init();
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HEADER, false);
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $query);
            
            $response = curl_exec($ch);

            // Check if any error occurred
            if (empty($response)) {
                // some kind of an error happened
                die(curl_error($ch));
                curl_close($ch); // close cURL handler
            } else {
                $info = curl_getinfo($ch);
                curl_close($ch); // close cURL handler
            
                if (empty($info['http_code'])) {
                        die("No HTTP code was returned");
                } else {
                    // load the HTTP codes
                    $http_codes = parse_ini_file("curlini.ini");
                   
                    // echo results
                    echo "The server responded: <br />";
                    echo $info['http_code'] . " " . $http_codes[$info['http_code']];
                }
            
            }

            curl_close($ch);
            return $response;
        }
        /**
         * @description Make HTTP-PUT call
         * @param       $url
         * @param       array $params
         * @return      HTTP-Response body or an empty string if the request fails or is empty
         */
        public static function HTTPPut($url, array $params) {
            $query = \http_build_query($params);
            $ch    = \curl_init();
            \curl_setopt($ch, \CURLOPT_RETURNTRANSFER, true);
            \curl_setopt($ch, \CURLOPT_HEADER, false);
            \curl_setopt($ch, \CURLOPT_URL, $url);
            \curl_setopt($ch, \CURLOPT_CUSTOMREQUEST, 'PUT');
            \curl_setopt($ch, \CURLOPT_POSTFIELDS, $query);
            $response = \curl_exec($ch);
            \curl_close($ch);
            return $response;
        }
        /**
         * @category Make HTTP-DELETE call
         * @param    $url
         * @param    array $params
         * @return   HTTP-Response body or an empty string if the request fails or is empty
         */
        public static function HTTPDelete($url, array $params) {
            $query = \http_build_query($params);
            $ch    = \curl_init();
            \curl_setopt($ch, \CURLOPT_RETURNTRANSFER, true);
            \curl_setopt($ch, \CURLOPT_HEADER, false);
            \curl_setopt($ch, \CURLOPT_URL, $url);
            \curl_setopt($ch, \CURLOPT_CUSTOMREQUEST, 'DELETE');
            \curl_setopt($ch, \CURLOPT_POSTFIELDS, $query);
            $response = \curl_exec($ch);
            \curl_close($ch);
            return $response;
        }
    }
?>