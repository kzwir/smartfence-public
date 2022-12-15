SELECT `central`.`id_central`,
    `central`.`name_central`
FROM `fence`.`central`;

SELECT `enter`.`id_enter`,
    `enter`.`label_enter`,
    `enter`.`message_id`
FROM `fence`.`enter`;

SELECT `message`.`id_message`,
    `message`.`date`,
    `message`.`message_type_id`,
    `message`.`name_central`,
    `message`.`id_central`
FROM `fence`.`message`;

SELECT `modulmessage`.`id`,
    `modul`.`id_module`,
    `modul`.`name_module`,
    `modul`.`message_id`
FROM `fence`.`modul`;

SELECT `photovoltaics`.`id_photovoltaics`,
    `photovoltaics`.`power`,
    `photovoltaics`.`voltage`,
    `photovoltaics`.`amperage`,
    `photovoltaics`.`message_id`
FROM `fence`.`photovoltaics`;
