CREATE PROCEDURE `populate_message` (IN `p_centralId` INT, IN `p_centralName` VARCHAR(100) CHARSET utf8, IN `p_messageTypeId` INT, IN `p_meesageDate` DATETIME, IN `p_moduleName` VARCHAR(100) CHARSET utf8, IN `p_moduleId` INT, IN `p_power` DECIMAL(5,2), IN `p_voltage` DECIMAL(5,2), IN `p_amperage` DECIMAL(5,2), IN `p_messageTxt` VARCHAR(100) CHARSET utf8)
BEGIN
	DELETE FROM central;
	DELETE FROM enter;
	DELETE FROM message;
	DELETE FROM modul;
	DELETE FROM photovoltaics;
END;