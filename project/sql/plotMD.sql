--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
CREATE TABLE `device` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `device_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `device_device_type_id_306a1819_fk_devicetype_id` (`device_type_id`),
  CONSTRAINT `device_device_type_id_306a1819_fk_devicetype_id` FOREIGN KEY (`device_type_id`) REFERENCES `devicetype` (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `device_params`
--

DROP TABLE IF EXISTS `device_params`;
CREATE TABLE `device_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL,
  `parameter_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `device_params_device_id_parameter_id_7dc3ef98_uniq` (`device_id`,`parameter_id`),
  KEY `device_params_parameter_id_9279c5c5_fk_parameter_code` (`parameter_id`),
  CONSTRAINT `device_params_device_id_956c6e9a_fk_device_id` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `devicetype`;
CREATE TABLE `devicetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `devicetype_params`;
CREATE TABLE `devicetype_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `devicetype_id` int(11) NOT NULL,
  `parameter_id` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `devicetype_params_devicetype_id_parameter_id_027b8fe8_uniq` (`devicetype_id`,`parameter_id`),
  KEY `devicetype_para_parameter_id_a9c116d9_fk_para` (`parameter_id`),
  CONSTRAINT `devicetype_para_devicetype_id_0f4a8039_fk_devi` FOREIGN KEY (`devicetype_id`) REFERENCES `devicetype` (`id`),
  CONSTRAINT `devicetype_para_parameter_id_a9c116d9_fk_para` FOREIGN KEY (`parameter_id`) REFERENCES `parameter` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `measurement`;
CREATE TABLE `measurement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` decimal(10,2) DEFAULT NULL,
  `measure_time` datetime(6) NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `parameter_id` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `measurement_device_id_600167bb_fk_device_id` (`device_id`),
  KEY `measurement_parameter_id_9aa38b6e_fk_parameter_code` (`parameter_id`),
  CONSTRAINT `measurement_device_id_600167bb_fk_device_id` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`),
  CONSTRAINT `measurement_parameter_id_9aa38b6e_fk` FOREIGN KEY (`parameter_id`) REFERENCES `parameter` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2190905 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `parameter`;
CREATE TABLE `parameter` (
  `code` varchar(30) NOT NULL,
  `name` varchar(50) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;