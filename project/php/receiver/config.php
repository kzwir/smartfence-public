<?php
Class DatabaseSettings {
    var $settings;
	const APIKEY = 'tPmAT5Ab3j7F9';

    function getSettings()
	{
		// Database variables
		// Host name
		$settings['dbhost'] = 'localhost';
		// Database name
		$settings['dbname'] = 'fence';
		// Username
		$settings['dbusername'] = 'admin';
		// Password
		$settings['dbpassword'] = 'Fe8n!3ce#123';
        // api key
        // $settings['apikey'] = 'tPmAT5Ab3j7F9';
		
		return $settings;
	}
}
?>