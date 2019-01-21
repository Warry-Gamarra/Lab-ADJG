--
-- Table structure for table `accounts_contacts`
--

DROP TABLE IF EXISTS `accounts_contacts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `accounts_contacts` (
`id` varchar(36) NOT NULL,
`contact_id` varchar(36) default NULL,
`account_id` varchar(36) default NULL,
`date_modified` datetime default NULL,
`deleted` tinyint(1) NOT NULL default '0',
PRIMARY KEY  (`id`),
KEY `idx_account_contact` (`account_id`,`contact_id`),
KEY `idx_contid_del_accid` (`contact_id`,`deleted`,`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `accounts_contacts`
--

LOCK TABLES `accounts_contacts` WRITE;
/*!40000 ALTER TABLE `accounts_contacts` DISABLE KEYS */;
INSERT INTO `accounts_contacts` VALUES ('6ff90374-26d1-5fd8-b844-4873b2e42091',
'11ba0239-c7cf-e87e-e266-4873b218a3f9','503a06a8-0650-6fdd-22ae-4873b245ae53',
'2008-07-23 05:24:30',1),
('83126e77-eeda-f335-dc1b-4873bc805541','7c525b1c-8a11-d803-94a5-4873bc4ff7d2',
'80a6add6-81ed-0266-6db5-4873bc54bfb5','2008-07-23 05:24:30',1),
('4e800b97-c09f-7896-d3d7-48751d81d5ee','f241c222-b91a-d7a9-f355-48751d6bc0f9',
'27060688-1f44-9f10-bdc4-48751db40009','2008-07-23 05:24:30',1),
('c94917ea-3664-8430-e003-487be0817f41','c564b7f3-2923-30b5-4861-487be0f70cb3',
'c71eff65-b76b-cbb0-d31a-487be06e4e0b','2008-07-23 05:24:30',1),
('7dab11e1-64d3-ea6a-c62c-487ce17e4e41','79d6f6e5-50e5-9b2b-034b-487ce1dae5af',
'7b886f23-571b-595b-19dd-487ce1eee867','2008-07-23 05:24:30',1);
/*!40000 ALTER TABLE `accounts_contacts` ENABLE KEYS */;
UNLOCK TABLES;
