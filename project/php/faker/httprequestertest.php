<?php
    class HTTPRequesterCase extends TestCase {
        /**
         * @description test static method HTTPGet
         */
        public function testHTTPGet() {
            $requestArr = array("getLicenses" => 1);
            $url        = "http://localhost/project/req/licenseService.php";
            $this->assertEquals(HTTPRequester::HTTPGet($url, $requestArr), '[{"error":false,"val":["NONE","AGPL","GPLv3"]}]');
        }
        /**
         * @description test static method HTTPPost
         */
        public function testHTTPPost() {
            $requestArr = array("addPerson" => array("foo", "bar"));
            $url        = "http://localhost/project/req/personService.php";
            $this->assertEquals(HTTPRequester::HTTPPost($url, $requestArr), '[{"error":false}]');
        }
        /**
         * @description test static method HTTPPut
         */
        public function testHTTPPut() {
            $requestArr = array("updatePerson" => array("foo", "bar"));
            $url        = "http://localhost/project/req/personService.php";
            $this->assertEquals(HTTPRequester::HTTPPut($url, $requestArr), '[{"error":false}]');
        }
        /**
         * @description test static method HTTPDelete
         */
        public function testHTTPDelete() {
            $requestArr = array("deletePerson" => array("foo", "bar"));
            $url        = "http://localhost/project/req/personService.php";
            $this->assertEquals(HTTPRequester::HTTPDelete($url, $requestArr), '[{"error":false}]');
        }
    }
?>