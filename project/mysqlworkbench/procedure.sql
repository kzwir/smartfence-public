 INSERT IGNORE INTO central(id_central, name_central) VALUES (
       p_centralId, p_centralName
 );

 -- messageTypeId = 'C' or 'D' or 'E' or 'F'
 INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (
       DEFAULT, p_messageDate, p_messageTypeId, p_centralName, p_centralId
 );

SET messageId = LAST_INSERT_ID();
CASE 
	WHEN p_messageTypeId = '1' THEN 
		INSERT IGNORE INTO photovoltaics (id_photovoltaics, power, voltage, amperage, message_id) VALUES(
				DEFAULT, p_power, p_voltage, p_amperage, messageId);
		INSERT IGNORE INTO modul (id, id_module, name_module, message_id) VALUES(
			DEFAULT, p_moduleId, p_moduleName, messageId);
	WHEN p_messageTypeId = 'A' OR p_messageTypeId = 'B' THEN
		INSERT IGNORE INTO enter (id_enter, label_enter, message_id) VALUES(
			DEFAULT, p_messageText, messageId);
		INSERT IGNORE INTO module (id, id_module, name_module, message_id) VALUES(
			DEFAULT, p_moduleId, p_moduleName, messageId);
	WHEN p_messageTypeId = 'G' THEN
		INSERT IGNORE INTO module (id, id_module, name_module, message_id) VALUES(
			DEFAULT, p_moduleId, p_moduleName, messageId);
END CASE;
	commit;
END;

INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaMC");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/11/15/19/14/2", '1', "CentralaMC", "30:AE:A4:07:0D:64");
/*
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaPS");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/11/19/8/8", 'A', "CentralaPS", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "MojaCentrala");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/11/19/8/8", 'B', "MojaCentrala", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "Centralna");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/11/1/8/8", 'C', "Centralna", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaMC");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/8/0/8/8", 'D', "CentralaMC", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaMC");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/11/19/59/8", 'E', "CentralaMC", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaMC");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/14/5/8/8", 'F', "CentralaMC", "30:AE:A4:07:0D:64");
INSERT IGNORE INTO central(id_central, name_central) VALUES ("30:AE:A4:07:0D:64", "CentralaMC");
INSERT IGNORE INTO message(id_message, date, message_type_id, name_central, id_central) VALUES (DEFAULT, "2022/09/11/19/8/8", 'G', "CentralaMC", "30:AE:A4:07:0D:64");
*/