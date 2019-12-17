-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: cbcommerce
-- ------------------------------------------------------
-- Server version	10.4.11-MariaDB-1:10.4.11+maria~bionic

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `cbcommerce`
--

CREATE DATABASE IF NOT EXISTS `cbcommerce` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `cbcommerce`;

--
-- Table structure for table `cachebox_content`
--

DROP TABLE IF EXISTS `cachebox_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cachebox_content` (
  `id` varchar(100) NOT NULL,
  `objectKey` varchar(255) NOT NULL,
  `objectValue` longtext NOT NULL,
  `hits` int(11) NOT NULL DEFAULT 1,
  `timeout` int(11) NOT NULL,
  `lastAccessTimeout` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `lastAccessed` datetime NOT NULL,
  `isExpired` tinyint(4) NOT NULL DEFAULT 1,
  `isSimple` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cachebox_content`
--

LOCK TABLES `cachebox_content` WRITE;
/*!40000 ALTER TABLE `cachebox_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `cachebox_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cachebox_sessions`
--

DROP TABLE IF EXISTS `cachebox_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cachebox_sessions` (
  `id` varchar(100) NOT NULL,
  `objectKey` varchar(255) NOT NULL,
  `objectValue` longtext NOT NULL,
  `hits` int(11) NOT NULL DEFAULT 1,
  `timeout` int(11) NOT NULL,
  `lastAccessTimeout` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `lastAccessed` datetime NOT NULL,
  `isExpired` tinyint(4) NOT NULL DEFAULT 1,
  `isSimple` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cachebox_sessions`
--

LOCK TABLES `cachebox_sessions` WRITE;
/*!40000 ALTER TABLE `cachebox_sessions` DISABLE KEYS */;
INSERT INTO `cachebox_sessions` VALUES ('BB25DFFAD7A726BAC02D8E6D2527F616','cbstorage:contentbox-docker-_d2326e46-cdbd-4d3e-9881-c769a359b3fa_0','rO0ABXNyAB1sdWNlZS5ydW50aW1lLnR5cGUuU3RydWN0SW1wbBO7DyUhSuS5AgABTAADbWFwdAAhTGx1Y2VlL2NvbW1vbnMvY29sbGVjdGlvbi9NYXBQcm87eHIAJWx1Y2VlLnJ1bnRpbWUudHlwZS51dGlsLlN0cnVjdFN1cHBvcnRnKbKJGDmF4wIAAHhwc3IAOGx1Y2VlLmNvbW1vbnMuY29sbGVjdGlvbi5jb25jdXJyZW50LkNvbmN1cnJlbnRIYXNoTWFwUHJvZJneEp2HKT0MAAB4cgAnbHVjZWUuY29tbW9ucy5jb2xsZWN0aW9uLkFic3RyYWN0TWFwUHJvlyz7VteiVMwMAAB4cHNyABFqYXZhLnV0aWwuSGFzaE1hcAUH2sHDFmDRAwACRgAKbG9hZEZhY3RvckkACXRocmVzaG9sZHhwP0AAAAAAAAZ3CAAAAAgAAAADc3IAGmx1Y2VlLnJ1bnRpbWUudHlwZS5LZXlJbXBshPm/L2n0b2cMAAB4cHQACXNlc3Npb25pZHh0AENjYnN0b3JhZ2U6Q29udGVudEJveC1Eb2NrZXItX2QyMzI2ZTQ2LWNkYmQtNGQzZS05ODgxLWM3NjlhMzU5YjNmYV8wc3EAfgAJdAALdGltZWNyZWF0ZWR4c3IAImx1Y2VlLnJ1bnRpbWUudHlwZS5kdC5EYXRlVGltZUltcGyL7K30ezFucgIAAHhyAB5sdWNlZS5ydW50aW1lLnR5cGUuZHQuRGF0ZVRpbWUfMrJraWnmvwIAAHhyAA5qYXZhLnV0aWwuRGF0ZWhqgQFLWXQZAwAAeHB3CAAAAW8T9fEFeHNxAH4ACXQAEGxvZ2dlZEluQXV0aG9ySUR4c3IAEWphdmEubGFuZy5JbnRlZ2VyEuKgpPeBhzgCAAFJAAV2YWx1ZXhyABBqYXZhLmxhbmcuTnVtYmVyhqyVHQuU4IsCAAB4cAAAAAF4eA==',45,60,0,'2019-12-17 13:09:13','2019-12-17 13:09:26',0,0);
/*!40000 ALTER TABLE `cachebox_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_author`
--

DROP TABLE IF EXISTS `cb_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_author` (
  `authorID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `isActive` bit(1) NOT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `biography` longtext DEFAULT NULL,
  `preferences` longtext DEFAULT NULL,
  `isPasswordReset` bit(1) NOT NULL DEFAULT b'0',
  `is2FactorAuth` bit(1) NOT NULL DEFAULT b'0',
  `APIToken` varchar(255) DEFAULT NULL,
  `FK_roleID` int(11) NOT NULL,
  PRIMARY KEY (`authorID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `APIToken` (`APIToken`),
  KEY `FK6847396B9724FA40` (`FK_roleID`),
  KEY `idx_login` (`username`,`password`,`isActive`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_apitoken` (`APIToken`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_activeAuthor` (`isActive`),
  KEY `idx_passwordReset` (`isPasswordReset`),
  KEY `idx_email` (`email`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_2factorauth` (`is2FactorAuth`),
  CONSTRAINT `FK6847396B9724FA40` FOREIGN KEY (`FK_roleID`) REFERENCES `cb_role` (`roleID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_author`
--

LOCK TABLES `cb_author` WRITE;
/*!40000 ALTER TABLE `cb_author` DISABLE KEYS */;
INSERT INTO `cb_author` VALUES (1,'2019-12-16 16:46:18','2019-12-17 13:09:13','\0','Jon','Clausen','jclausen@ortussolutions.com','admin','$2a$12$mo.I90Cd2//rMZfyLC9/W.703Ohw7hn.ZCIpS.gzRtoBYglvwiZzm','','2019-12-17 13:09:13','','{\"sidemenuCollapse\":\"yes\"}','\0','\0','38103B8C679D63D97D42AC484168870200D529E2E9A47C9BA3BAF39C3A4F8E2030161AA27947B5359232C1FED8B1F03A43A0D5CFCD4D8EAAFD548432E04BDE54',2);
/*!40000 ALTER TABLE `cb_author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_authorPermissionGroups`
--

DROP TABLE IF EXISTS `cb_authorPermissionGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_authorPermissionGroups` (
  `FK_permissionGroupID` int(11) NOT NULL,
  `FK_authorID` int(11) NOT NULL,
  KEY `FK7443FC0EAA6AC0EA` (`FK_authorID`),
  KEY `FK7443FC0EF4497DC2` (`FK_permissionGroupID`),
  CONSTRAINT `FK7443FC0EAA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`),
  CONSTRAINT `FK7443FC0EF4497DC2` FOREIGN KEY (`FK_permissionGroupID`) REFERENCES `cb_permissionGroup` (`permissionGroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_authorPermissionGroups`
--

LOCK TABLES `cb_authorPermissionGroups` WRITE;
/*!40000 ALTER TABLE `cb_authorPermissionGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_authorPermissionGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_authorPermissions`
--

DROP TABLE IF EXISTS `cb_authorPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_authorPermissions` (
  `FK_authorID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FKE167E219AA6AC0EA` (`FK_authorID`),
  KEY `FKE167E21937C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FKE167E21937C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FKE167E219AA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_authorPermissions`
--

LOCK TABLES `cb_authorPermissions` WRITE;
/*!40000 ALTER TABLE `cb_authorPermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_authorPermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_category`
--

DROP TABLE IF EXISTS `cb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_category` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `category` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  PRIMARY KEY (`categoryID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_categorySlug` (`slug`),
  KEY `idx_categoryName` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_category`
--

LOCK TABLES `cb_category` WRITE;
/*!40000 ALTER TABLE `cb_category` DISABLE KEYS */;
INSERT INTO `cb_category` VALUES (1,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','News','news'),(2,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ColdFusion','coldfusion'),(3,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ColdBox','coldbox'),(4,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ContentBox','contentbox');
/*!40000 ALTER TABLE `cb_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_comment`
--

DROP TABLE IF EXISTS `cb_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_comment` (
  `commentID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `content` longtext NOT NULL,
  `author` varchar(100) NOT NULL,
  `authorIP` varchar(100) NOT NULL,
  `authorEmail` varchar(255) NOT NULL,
  `authorURL` varchar(255) DEFAULT NULL,
  `isApproved` bit(1) NOT NULL,
  `FK_contentID` int(11) NOT NULL,
  PRIMARY KEY (`commentID`),
  KEY `FKFFCED27F91F58374` (`FK_contentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_approved` (`isApproved`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_contentComment` (`isApproved`,`FK_contentID`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKFFCED27F91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_comment`
--

LOCK TABLES `cb_comment` WRITE;
/*!40000 ALTER TABLE `cb_comment` DISABLE KEYS */;
INSERT INTO `cb_comment` VALUES (1,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','What an amazing blog entry, congratulations!','Awesome Joe','172.27.0.1','awesomejoe@contentbox.org','www.ortussolutions.com','',1),(2,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','I am some bad words and bad comment not approved','Bad Joe','172.27.0.1','badjoe@contentbox.org','www.ortussolutions.com','\0',1);
/*!40000 ALTER TABLE `cb_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_commentSubscriptions`
--

DROP TABLE IF EXISTS `cb_commentSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_commentSubscriptions` (
  `subscriptionID` int(11) NOT NULL,
  `FK_contentID` int(11) NOT NULL,
  PRIMARY KEY (`subscriptionID`),
  KEY `FK41716EB791F58374` (`FK_contentID`),
  KEY `FK41716EB71D33B614` (`subscriptionID`),
  KEY `idx_contentCommentSubscription` (`FK_contentID`),
  CONSTRAINT `FK41716EB71D33B614` FOREIGN KEY (`subscriptionID`) REFERENCES `cb_subscriptions` (`subscriptionID`),
  CONSTRAINT `FK41716EB791F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_commentSubscriptions`
--

LOCK TABLES `cb_commentSubscriptions` WRITE;
/*!40000 ALTER TABLE `cb_commentSubscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_commentSubscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_content`
--

DROP TABLE IF EXISTS `cb_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_content` (
  `contentID` int(11) NOT NULL AUTO_INCREMENT,
  `contentType` varchar(255) NOT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `publishedDate` datetime DEFAULT NULL,
  `expireDate` datetime DEFAULT NULL,
  `isPublished` bit(1) NOT NULL,
  `allowComments` bit(1) NOT NULL,
  `passwordProtection` varchar(100) DEFAULT NULL,
  `HTMLKeywords` varchar(160) DEFAULT NULL,
  `HTMLDescription` varchar(160) DEFAULT NULL,
  `HTMLTitle` varchar(255) DEFAULT NULL,
  `cache` bit(1) NOT NULL,
  `cacheLayout` bit(1) NOT NULL,
  `cacheTimeout` int(11) DEFAULT NULL,
  `cacheLastAccessTimeout` int(11) DEFAULT NULL,
  `markup` varchar(100) NOT NULL,
  `showInSearch` bit(1) NOT NULL,
  `featuredImage` varchar(255) DEFAULT NULL,
  `featuredImageURL` varchar(255) DEFAULT NULL,
  `FK_authorID` int(11) NOT NULL,
  `FK_parentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`contentID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `FKFFE01899AA6AC0EA` (`FK_authorID`),
  KEY `FKFFE018996FDC2C99` (`FK_parentID`),
  KEY `idx_cachelastaccesstimeout` (`cacheLastAccessTimeout`),
  KEY `idx_publishedSlug` (`slug`,`isPublished`),
  KEY `idx_slug` (`slug`),
  KEY `idx_expireDate` (`expireDate`),
  KEY `idx_publishedDate` (`publishedDate`),
  KEY `idx_cache` (`cache`),
  KEY `idx_published` (`contentType`,`isPublished`,`passwordProtection`),
  KEY `idx_cachetimeout` (`cacheTimeout`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_showInSearch` (`showInSearch`),
  KEY `idx_cachelayout` (`cacheLayout`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_search` (`title`,`isPublished`),
  KEY `idx_discriminator` (`contentType`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKFFE018996FDC2C99` FOREIGN KEY (`FK_parentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKFFE01899AA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_content`
--

LOCK TABLES `cb_content` WRITE;
/*!40000 ALTER TABLE `cb_content` DISABLE KEYS */;
INSERT INTO `cb_content` VALUES (1,'Entry','2019-12-16 16:46:19','2019-12-16 16:46:19','\0','My first entry','my-first-entry','2019-12-16 16:46:18',NULL,'','','','cool,first entry, contentbox','The most amazing ContentBox blog entry in the world','','','',0,0,'HTML','','','',1,NULL),(2,'Page','2019-12-16 16:46:19','2019-12-16 16:46:19','\0','About','about','2019-12-16 16:46:19',NULL,'','\0','','about, contentbox,coldfusion,coldbox','The most amazing ContentBox page in the world','','','',0,0,'HTML','','','',1,NULL),(3,'ContentStore','2019-12-16 16:46:19','2019-12-16 16:46:19','\0','Contact Info','contentbox','2019-12-16 16:46:19',NULL,'','\0','','','','','','',0,0,'HTML','','','',1,NULL);
/*!40000 ALTER TABLE `cb_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_contentCategories`
--

DROP TABLE IF EXISTS `cb_contentCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_contentCategories` (
  `FK_contentID` int(11) NOT NULL,
  `FK_categoryID` int(11) NOT NULL,
  KEY `FKD96A0F9591F58374` (`FK_contentID`),
  KEY `FKD96A0F95F10ECD0` (`FK_categoryID`),
  CONSTRAINT `FKD96A0F9591F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKD96A0F95F10ECD0` FOREIGN KEY (`FK_categoryID`) REFERENCES `cb_category` (`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_contentCategories`
--

LOCK TABLES `cb_contentCategories` WRITE;
/*!40000 ALTER TABLE `cb_contentCategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_contentCategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_contentStore`
--

DROP TABLE IF EXISTS `cb_contentStore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_contentStore` (
  `contentID` int(11) NOT NULL,
  `description` longtext DEFAULT NULL,
  `order` int(11) DEFAULT 0,
  PRIMARY KEY (`contentID`),
  KEY `FKEA4C67C8C960893B` (`contentID`),
  CONSTRAINT `FKEA4C67C8C960893B` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_contentStore`
--

LOCK TABLES `cb_contentStore` WRITE;
/*!40000 ALTER TABLE `cb_contentStore` DISABLE KEYS */;
INSERT INTO `cb_contentStore` VALUES (3,'Our contact information',0);
/*!40000 ALTER TABLE `cb_contentStore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_contentVersion`
--

DROP TABLE IF EXISTS `cb_contentVersion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_contentVersion` (
  `contentVersionID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `content` longtext NOT NULL,
  `changelog` longtext DEFAULT NULL,
  `version` int(11) NOT NULL,
  `isActive` bit(1) NOT NULL,
  `FK_authorID` int(11) NOT NULL,
  `FK_contentID` int(11) NOT NULL,
  PRIMARY KEY (`contentVersionID`),
  KEY `FKE166DFFAA6AC0EA` (`FK_authorID`),
  KEY `FKE166DFF91F58374` (`FK_contentID`),
  KEY `idx_version` (`version`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_contentVersions` (`isActive`,`FK_contentID`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_activeContentVersion` (`isActive`),
  CONSTRAINT `FKE166DFF91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FKE166DFFAA6AC0EA` FOREIGN KEY (`FK_authorID`) REFERENCES `cb_author` (`authorID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_contentVersion`
--

LOCK TABLES `cb_contentVersion` WRITE;
/*!40000 ALTER TABLE `cb_contentVersion` DISABLE KEYS */;
INSERT INTO `cb_contentVersion` VALUES (1,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','Hey everybody, this is my first blog entry made from ContentBox.  Isn\'t this amazing!\'','Initial creation',1,'',1,1),(2,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','<p>Hey welcome to my about page for ContentBox, isn\'t this great!</p><p>{{{ContentStore slug=\'contentbox\'}}}</p>','First creation',1,'',1,2),(3,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','<p style=\"text-align: center;\">\n	<a href=\"https://www.ortussolutions.com/products/contentbox\"><img alt=\"\" src=\"/index.cfm/__media/ContentBox_300.png\" /></a></p>\n<p style=\"text-align: center;\">\n	Created by <a href=\"https://www.ortussolutions.com\">Ortus Solutions, Corp</a> and powered by <a href=\"http://coldbox.org\">ColdBox Platform</a>.</p>','First creation',1,'',1,3);
/*!40000 ALTER TABLE `cb_contentVersion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_customfield`
--

DROP TABLE IF EXISTS `cb_customfield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_customfield` (
  `customFieldID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `FK_contentID` int(11) DEFAULT NULL,
  PRIMARY KEY (`customFieldID`),
  KEY `FK1844684991F58374` (`FK_contentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_contentCustomFields` (`FK_contentID`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FK1844684991F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_customfield`
--

LOCK TABLES `cb_customfield` WRITE;
/*!40000 ALTER TABLE `cb_customfield` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_customfield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_entry`
--

DROP TABLE IF EXISTS `cb_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_entry` (
  `contentID` int(11) NOT NULL,
  `excerpt` longtext DEFAULT NULL,
  PRIMARY KEY (`contentID`),
  KEY `FK141674927FFF6A7` (`contentID`),
  CONSTRAINT `FK141674927FFF6A7` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_entry`
--

LOCK TABLES `cb_entry` WRITE;
/*!40000 ALTER TABLE `cb_entry` DISABLE KEYS */;
INSERT INTO `cb_entry` VALUES (1,'');
/*!40000 ALTER TABLE `cb_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_groupPermissions`
--

DROP TABLE IF EXISTS `cb_groupPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_groupPermissions` (
  `FK_permissionGroupID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FK72ECB065F4497DC2` (`FK_permissionGroupID`),
  KEY `FK72ECB06537C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FK72ECB06537C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FK72ECB065F4497DC2` FOREIGN KEY (`FK_permissionGroupID`) REFERENCES `cb_permissionGroup` (`permissionGroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_groupPermissions`
--

LOCK TABLES `cb_groupPermissions` WRITE;
/*!40000 ALTER TABLE `cb_groupPermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_groupPermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_loginAttempts`
--

DROP TABLE IF EXISTS `cb_loginAttempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_loginAttempts` (
  `loginAttemptsID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `value` varchar(255) NOT NULL,
  `attempts` int(11) NOT NULL,
  `lastLoginSuccessIP` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`loginAttemptsID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_values` (`value`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_loginAttempts`
--

LOCK TABLES `cb_loginAttempts` WRITE;
/*!40000 ALTER TABLE `cb_loginAttempts` DISABLE KEYS */;
INSERT INTO `cb_loginAttempts` VALUES (4,'2019-12-16 20:48:49','2019-12-16 20:48:49','\0','',0,'172.27.0.1'),(5,'2019-12-16 21:53:33','2019-12-16 21:53:33','\0','',0,'172.27.0.1'),(6,'2019-12-16 23:32:22','2019-12-16 23:32:22','\0','',0,'172.27.0.1'),(7,'2019-12-17 13:09:13','2019-12-17 13:09:13','\0','',0,'172.27.0.1');
/*!40000 ALTER TABLE `cb_loginAttempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_menu`
--

DROP TABLE IF EXISTS `cb_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_menu` (
  `menuID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `title` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `menuClass` varchar(160) DEFAULT NULL,
  `listClass` varchar(160) DEFAULT NULL,
  `listType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`menuID`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_menuslug` (`slug`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_menutitle` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_menu`
--

LOCK TABLES `cb_menu` WRITE;
/*!40000 ALTER TABLE `cb_menu` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_menuItem`
--

DROP TABLE IF EXISTS `cb_menuItem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_menuItem` (
  `menuItemID` int(11) NOT NULL AUTO_INCREMENT,
  `menuType` varchar(255) NOT NULL,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `title` varchar(200) NOT NULL,
  `label` varchar(200) DEFAULT NULL,
  `itemClass` varchar(200) DEFAULT NULL,
  `data` varchar(255) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `FK_menuID` int(11) NOT NULL,
  `FK_parentID` int(11) DEFAULT NULL,
  `mediaPath` varchar(255) DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `urlClass` varchar(255) DEFAULT NULL,
  `menuSlug` varchar(255) DEFAULT NULL,
  `contentSlug` varchar(255) DEFAULT NULL,
  `js` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`menuItemID`),
  KEY `FKF9F1DCF28E0E8DD2` (`FK_menuID`),
  KEY `FKF9F1DCF2D3B42410` (`FK_parentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_menuitemtitle` (`title`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FKF9F1DCF28E0E8DD2` FOREIGN KEY (`FK_menuID`) REFERENCES `cb_menu` (`menuID`),
  CONSTRAINT `FKF9F1DCF2D3B42410` FOREIGN KEY (`FK_parentID`) REFERENCES `cb_menuItem` (`menuItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_menuItem`
--

LOCK TABLES `cb_menuItem` WRITE;
/*!40000 ALTER TABLE `cb_menuItem` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_menuItem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_module`
--

DROP TABLE IF EXISTS `cb_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_module` (
  `moduleID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  `entryPoint` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `webURL` longtext DEFAULT NULL,
  `forgeBoxSlug` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `isActive` bit(1) NOT NULL,
  `moduleType` varchar(255) DEFAULT 'unknown',
  PRIMARY KEY (`moduleID`),
  KEY `idx_moduleName` (`name`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_moduleType` (`moduleType`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_activeModule` (`isActive`),
  KEY `idx_entryPoint` (`entryPoint`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_module`
--

LOCK TABLES `cb_module` WRITE;
/*!40000 ALTER TABLE `cb_module` DISABLE KEYS */;
INSERT INTO `cb_module` VALUES (1,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','Hello','HelloContentBox','','HelloContentBox','Ortus Solutions, Corp','https://www.ortussolutions.com','','This is an awesome hello world module','\0','core'),(2,'2019-12-16 16:59:45','2019-12-17 13:09:26','\0','cbCommerce','cbCommerce ','1.0.0-alpha1','store','Jon Clausen <jclausen@ortussolutions.com>','https://github.com/jclausen/cbCommerce','','cbCommerce is the eCommerce Platform for the ContentBox Modular CMS','','core');
/*!40000 ALTER TABLE `cb_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_page`
--

DROP TABLE IF EXISTS `cb_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_page` (
  `contentID` int(11) NOT NULL,
  `layout` varchar(200) DEFAULT NULL,
  `mobileLayout` varchar(200) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `showInMenu` bit(1) NOT NULL,
  `excerpt` longtext DEFAULT NULL,
  `SSLOnly` bit(1) NOT NULL,
  PRIMARY KEY (`contentID`),
  KEY `FK21B2F26F9636A2E2` (`contentID`),
  KEY `idx_ssl` (`SSLOnly`),
  KEY `idx_showInMenu` (`showInMenu`),
  CONSTRAINT `FK21B2F26F9636A2E2` FOREIGN KEY (`contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_page`
--

LOCK TABLES `cb_page` WRITE;
/*!40000 ALTER TABLE `cb_page` DISABLE KEYS */;
INSERT INTO `cb_page` VALUES (2,'pages','',0,'','','\0');
/*!40000 ALTER TABLE `cb_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_permission`
--

DROP TABLE IF EXISTS `cb_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_permission` (
  `permissionID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `permission` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`permissionID`),
  UNIQUE KEY `permission` (`permission`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_permissionName` (`permission`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_permission`
--

LOCK TABLES `cb_permission` WRITE;
/*!40000 ALTER TABLE `cb_permission` DISABLE KEYS */;
INSERT INTO `cb_permission` VALUES (1,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_MODIFIERS','Ability to view the content modifiers panel'),(2,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','CONTENTSTORE_ADMIN','Ability to manage the content store, default is view only'),(3,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','WIDGET_ADMIN','Ability to manage widgets, default is view only'),(4,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','TOOLS_IMPORT','Ability to import data into ContentBox'),(5,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_HTML_ATTRIBUTES','Ability to view the content HTML attributes panel'),(6,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SYSTEM_UPDATES','Ability to view and apply ContentBox updates'),(7,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SECURITYRULES_ADMIN','Ability to manage the system\'s security rules, default is view only'),(8,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SYSTEM_AUTH_LOGS','Access to the system auth logs'),(9,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ENTRIES_EDITOR','Ability to manage blog entries but not publish entries'),(10,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','THEME_ADMIN','Ability to manage layouts, default is view only'),(11,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_CATEGORIES','Ability to view the content categories panel'),(12,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','GLOBALHTML_ADMIN','Ability to manage the system\'s global HTML content used on layouts'),(13,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','RELOAD_MODULES','Ability to reload modules'),(14,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EMAIL_TEMPLATE_ADMIN','Ability to admin and preview email templates'),(15,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','GLOBAL_SEARCH','Ability to do global searches in the ContentBox Admin'),(16,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_RELATED_CONTENT','Ability to view the related content panel'),(17,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','CATEGORIES_ADMIN','Ability to manage categories, default is view only'),(18,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','COMMENTS_ADMIN','Ability to manage comments, default is view only'),(19,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','PAGES_EDITOR','Ability to manage content pages but not publish pages'),(20,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','MODULES_ADMIN','Ability to manage ContentBox Modules'),(21,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_EDITOR_SELECTOR','Ability to change the editor to another registered online editor'),(22,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','PERMISSIONS_ADMIN','Ability to manage permissions, default is view only'),(23,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','VERSIONS_DELETE','Ability to delete past content versions'),(24,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','MENUS_ADMIN','Ability to manage the menu builder'),(25,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','MEDIAMANAGER_LIBRARY_SWITCHER','Ability to switch media manager libraries for management'),(26,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','MEDIAMANAGER_ADMIN','Ability to manage the system\'s media manager'),(27,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','CONTENTSTORE_EDITOR','Ability to manage content store elements but not publish them'),(28,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','FORGEBOX_ADMIN','Ability to manage ForgeBox installations and connectivity.'),(29,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_CUSTOM_FIELDS','Ability to manage custom fields in any content editors'),(30,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','VERSIONS_ROLLBACK','Ability to rollback content versions'),(31,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ENTRIES_ADMIN','Ability to manage blog entries, default is view only'),(32,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','PAGES_ADMIN','Ability to manage content pages, default is view only'),(33,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_CACHING','Ability to view the content caching panel'),(34,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SYSTEM_TAB','Access to the ContentBox System tools'),(35,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_LINKED_CONTENT','Ability to view the linked content panel'),(36,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','TOOLS_EXPORT','Ability to export data from ContentBox'),(37,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','AUTHOR_ADMIN','Ability to manage authors, default is view only'),(38,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','ROLES_ADMIN','Ability to manage roles, default is view only'),(39,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SYSTEM_SAVE_CONFIGURATION','Ability to update global configuration data'),(40,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_FEATURED_IMAGE','Ability to view the featured image panel'),(41,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','SYSTEM_RAW_SETTINGS','Access to the ContentBox raw geek settings panel'),(42,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','EDITORS_DISPLAY_OPTIONS','Ability to view the content display options panel'),(43,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','CONTENTBOX_ADMIN','Access to the enter the ContentBox administrator console');
/*!40000 ALTER TABLE `cb_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_permissionGroup`
--

DROP TABLE IF EXISTS `cb_permissionGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_permissionGroup` (
  `permissionGroupID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`permissionGroupID`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_permissionGroupName` (`name`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_permissionGroup`
--

LOCK TABLES `cb_permissionGroup` WRITE;
/*!40000 ALTER TABLE `cb_permissionGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_permissionGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_relatedContent`
--

DROP TABLE IF EXISTS `cb_relatedContent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_relatedContent` (
  `FK_contentID` int(11) NOT NULL,
  `FK_relatedContentID` int(11) NOT NULL,
  KEY `FK9C2F71AE91F58374` (`FK_contentID`),
  KEY `FK9C2F71AEDF61AADD` (`FK_relatedContentID`),
  CONSTRAINT `FK9C2F71AE91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`),
  CONSTRAINT `FK9C2F71AEDF61AADD` FOREIGN KEY (`FK_relatedContentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_relatedContent`
--

LOCK TABLES `cb_relatedContent` WRITE;
/*!40000 ALTER TABLE `cb_relatedContent` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_relatedContent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_role`
--

DROP TABLE IF EXISTS `cb_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_role` (
  `roleID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `role` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`roleID`),
  UNIQUE KEY `role` (`role`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_roleName` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_role`
--

LOCK TABLES `cb_role` WRITE;
/*!40000 ALTER TABLE `cb_role` DISABLE KEYS */;
INSERT INTO `cb_role` VALUES (1,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','Editor','A ContentBox editor'),(2,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','Administrator','A ContentBox Administrator');
/*!40000 ALTER TABLE `cb_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_rolePermissions`
--

DROP TABLE IF EXISTS `cb_rolePermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_rolePermissions` (
  `FK_roleID` int(11) NOT NULL,
  `FK_permissionID` int(11) NOT NULL,
  KEY `FKDCCC1A4E9724FA40` (`FK_roleID`),
  KEY `FKDCCC1A4E37C1A3F2` (`FK_permissionID`),
  CONSTRAINT `FKDCCC1A4E37C1A3F2` FOREIGN KEY (`FK_permissionID`) REFERENCES `cb_permission` (`permissionID`),
  CONSTRAINT `FKDCCC1A4E9724FA40` FOREIGN KEY (`FK_roleID`) REFERENCES `cb_role` (`roleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_rolePermissions`
--

LOCK TABLES `cb_rolePermissions` WRITE;
/*!40000 ALTER TABLE `cb_rolePermissions` DISABLE KEYS */;
INSERT INTO `cb_rolePermissions` VALUES (1,18),(1,27),(1,19),(1,17),(1,9),(1,10),(1,12),(1,26),(1,30),(1,43),(1,35),(1,42),(1,16),(1,1),(1,33),(1,11),(1,5),(1,21),(1,29),(1,15),(1,24),(1,40),(1,14),(2,1),(2,4),(2,3),(2,2),(2,6),(2,5),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),(2,13),(2,14),(2,15),(2,18),(2,17),(2,16),(2,19),(2,20),(2,21),(2,22),(2,23),(2,25),(2,24),(2,26),(2,27),(2,28),(2,29),(2,31),(2,30),(2,32),(2,34),(2,33),(2,36),(2,35),(2,37),(2,39),(2,38),(2,41),(2,40),(2,43),(2,42);
/*!40000 ALTER TABLE `cb_rolePermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_securityRule`
--

DROP TABLE IF EXISTS `cb_securityRule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_securityRule` (
  `ruleID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `whitelist` varchar(255) DEFAULT NULL,
  `securelist` varchar(255) NOT NULL,
  `roles` varchar(255) DEFAULT NULL,
  `permissions` longtext DEFAULT NULL,
  `redirect` longtext NOT NULL,
  `useSSL` bit(1) DEFAULT NULL,
  `order` int(11) NOT NULL,
  `match` varchar(50) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `messageType` varchar(50) DEFAULT 'info',
  PRIMARY KEY (`ruleID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_securityRule`
--

LOCK TABLES `cb_securityRule` WRITE;
/*!40000 ALTER TABLE `cb_securityRule` DISABLE KEYS */;
INSERT INTO `cb_securityRule` VALUES (1,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:modules\\..*','','MODULES_ADMIN','cbadmin/security/login','\0',1,'event','','info'),(2,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:mediamanager\\..*','','MEDIAMANAGER_ADMIN','cbadmin/security/login','\0',1,'event','','info'),(3,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:versions\\.(remove)','','VERSIONS_DELETE','cbadmin/security/login','\0',1,'event','','info'),(4,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:versions\\.(rollback)','','VERSIONS_ROLLBACK','cbadmin/security/login','\0',1,'event','','info'),(5,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:widgets\\.(remove|upload|edit|save|create|doCreate)$','','WIDGET_ADMIN','cbadmin/security/login','\0',2,'event','','info'),(6,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:tools\\.(importer|doImport)','','TOOLS_IMPORT','cbadmin/security/login','\0',3,'event','','info'),(7,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:(settings|permissions|roles|securityRules)\\..*','','SYSTEM_TAB','cbadmin/security/login','\0',4,'event','','info'),(8,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:settings\\.save','','SYSTEM_SAVE_CONFIGURATION','cbadmin/security/login','\0',5,'event','','info'),(9,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:settings\\.(raw|saveRaw|flushCache|flushSingletons|mappingDump|viewCached|remove)','','SYSTEM_RAW_SETTINGS','cbadmin/security/login','\0',6,'event','','info'),(10,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:securityRules\\.(remove|save|changeOrder|apply)','','SECURITYRULES_ADMIN','cbadmin/security/login','\0',7,'event','','info'),(11,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:roles\\.(remove|removePermission|save|savePermission)','','ROLES_ADMIN','cbadmin/security/login','\0',8,'event','','info'),(12,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:permissions\\.(remove|save)','','PERMISSIONS_ADMIN','cbadmin/security/login','\0',9,'event','','info'),(13,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:dashboard\\.reload','','RELOAD_MODULES','cbadmin/security/login','\0',10,'event','','info'),(14,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:pages\\.(changeOrder|remove)','','PAGES_ADMIN','cbadmin/security/login','\0',11,'event','','info'),(15,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:themes\\.(remove|upload|rebuildRegistry|activate)','','THEME_ADMIN','cbadmin/security/login','\0',12,'event','','info'),(16,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:entries\\.(quickPost|remove)','','ENTRIES_ADMIN','cbadmin/security/login','\0',13,'event','','info'),(17,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:contentStore\\.(editor|remove|save)','','CONTENTSTORE_ADMIN','cbadmin/security/login','\0',14,'event','','info'),(18,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:comments\\.(doStatusUpdate|editor|moderate|remove|save|saveSettings)','','COMMENTS_ADMIN','cbadmin/security/login','\0',15,'event','','info'),(19,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:categories\\.(remove|save)','','CATEGORIES_ADMIN','cbadmin/security/login','\0',16,'event','','info'),(20,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:authors\\.(remove|removePermission|savePermission|doPasswordReset|new|doNew)','','AUTHOR_ADMIN','cbadmin/security/login','\0',17,'event','','info'),(21,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','^contentbox-admin:security\\.','^contentbox-admin:.*','','CONTENTBOX_ADMIN','cbadmin/security/login','\0',18,'event','','info'),(22,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-filebrowser:.*','','MEDIAMANAGER_ADMIN','cbadmin/security/login','\0',19,'event','','info'),(23,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.importAll$','','TOOLS_IMPORT','cbadmin/security/login','\0',20,'event','','info'),(24,'2019-12-16 16:46:18','2019-12-16 16:46:18','\0','','^contentbox-admin:(authors|categories|permissions|roles|settings|pages|entries|contentStore|securityrules)\\.(export|exportAll)$','','TOOLS_EXPORT','cbadmin/security/login','\0',20,'event','','info');
/*!40000 ALTER TABLE `cb_securityRule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_setting`
--

DROP TABLE IF EXISTS `cb_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_setting` (
  `settingID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `name` varchar(100) NOT NULL,
  `value` longtext NOT NULL,
  `isCore` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`settingID`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_core` (`isCore`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_setting`
--

LOCK TABLES `cb_setting` WRITE;
/*!40000 ALTER TABLE `cb_setting` DISABLE KEYS */;
INSERT INTO `cb_setting` VALUES (1,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_media_allowDelete','true',''),(2,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_security_login_blocker','true',''),(3,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_versions_max_history','',''),(4,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_html_preArchivesDisplay','',''),(5,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_security_login_signin_text','',''),(6,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_security_rate_limiter_duration','1',''),(7,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_rss_description','ContentBox RSS Feed',''),(8,'2019-12-16 16:43:59','2019-12-16 16:46:19','\0','cb_site_name','cbCommerce Test Platform',''),(9,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_html_postCommentForm','',''),(10,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_media_html5uploads_maxFiles','25',''),(11,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_site_mail_password','',''),(12,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_comments_notifyemails','',''),(13,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_rss_cacheName','Template',''),(14,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_editors_markup','HTML',''),(15,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_content_cacheName','Template',''),(16,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_editors_ckeditor_toolbar','[\n		{ \"name\": \"document\",    \"items\" : [ \"Source\",\"-\",\"Maximize\",\"ShowBlocks\" ] },\n		{ \"name\": \"clipboard\",   \"items\" : [ \"Cut\",\"Copy\",\"Paste\",\"PasteText\",\"PasteFromWord\",\"-\",\"Undo\",\"Redo\" ] },\n		{ \"name\": \"editing\",     \"items\" : [ \"Find\",\"Replace\",\"SpellChecker\"] },\n		{ \"name\": \"forms\",       \"items\" : [ \"Form\", \"Checkbox\", \"Radio\", \"TextField\", \"Textarea\", \"Select\", \"Button\",\"HiddenField\" ] },\n		\"/\",\n		{ \"name\": \"basicstyles\", \"items\" : [ \"Bold\",\"Italic\",\"Underline\",\"Strike\",\"Subscript\",\"Superscript\",\"-\",\"RemoveFormat\" ] },\n		{ \"name\": \"paragraph\",   \"items\" : [ \"NumberedList\",\"BulletedList\",\"-\",\"Outdent\",\"Indent\",\"-\",\"Blockquote\",\"CreateDiv\",\"-\",\"JustifyLeft\",\"JustifyCenter\",\"JustifyRight\",\"JustifyBlock\",\"-\",\"BidiLtr\",\"BidiRtl\" ] },\n		{ \"name\": \"links\",       \"items\" : [ \"Link\",\"Unlink\",\"Anchor\" ] },\n		\"/\",\n		{ \"name\": \"styles\",      \"items\" : [ \"Styles\",\"Format\" ] },\n		{ \"name\": \"colors\",      \"items\" : [ \"TextColor\",\"BGColor\" ] },\n		{ \"name\": \"insert\",      \"items\" : [ \"Image\",\"Table\",\"HorizontalRule\",\"Smiley\",\"SpecialChar\",\"Iframe\",\"InsertPre\"] },\n		{ \"name\": \"contentbox\",  \"items\" : [ \"MediaEmbed\",\"cbIpsumLorem\",\"cbWidgets\",\"cbContentStore\",\"cbLinks\",\"cbEntryLinks\" ] }\n		]',''),(17,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_security_rate_limiter_logging','true',''),(18,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_site_settings_cache','Template',''),(19,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_site_adminbar','true',''),(20,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_versions_commit_mandatory','false',''),(21,'2019-12-16 16:43:59','2019-12-16 16:43:59','\0','cb_html_afterSideBar','',''),(22,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_notify_page','true',''),(23,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_mail_username','',''),(24,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_postPageDisplay','',''),(25,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_webmaster','',''),(26,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_title','RSS Feed by ContentBox',''),(27,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_acceptMimeTypes','',''),(28,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_notify_author','true',''),(29,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_welcome_title','Dashboard',''),(30,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_poweredby','true',''),(31,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_beforeSideBar','',''),(32,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_page_excerpts','true',''),(33,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_enabled','true',''),(34,'2019-12-16 16:44:00','2019-12-16 16:46:19','\0','cb_site_outgoingEmail','jclausen@ortussolutions.com',''),(35,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_newsfeed','https://www.ortussolutions.com/blog/rss',''),(36,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_createFolders','true',''),(37,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_min_password_length','8',''),(38,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_notify','true',''),(39,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_newsfeed_count','5',''),(40,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_afterBodyStart','',''),(41,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_preIndexDisplay','',''),(42,'2019-12-16 16:44:00','2019-12-16 16:46:19','\0','cb_site_tagline','Making eCommerce Awesome since 2018',''),(43,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_cachingTimeout','60',''),(44,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_cachingTimeoutIdle','15',''),(45,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_html5uploads_maxFileSize','100',''),(46,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_mail_server','',''),(47,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_salt','07FB91518129241AA81FD48FDAF1A7661D42CEDA1A780E73E7D55DF523CA9FB96BD4DE92C01D9484FA9F2B7E24C57C1627190346CAF75DE19BC6ACE3AEABB494',''),(48,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_quickViewWidth','400',''),(49,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_preEntryDisplay','',''),(50,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_urltranslations','true',''),(51,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_2factorAuth_trusted_days','30',''),(52,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_generator','ContentBox by Ortus Solutions',''),(53,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_homepage','cbBlog',''),(54,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_bot_regex','Google|msnbot|Rambler|Yahoo|AbachoBOT|accoona|AcioRobot|ASPSeek|CocoCrawler|Dumbot|FAST-WebCrawler|GeonaBot|Gigabot|Lycos|MSRBOT|Scooter|AltaVista|IDBot|eStyle|Scrubby',''),(55,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_editors_ckeditor_excerpt_toolbar','[\n		{ \"name\": \"document\",    \"items\" : [ \"Source\",\"-\",\"Maximize\",\"ShowBlocks\" ] },\n		{ \"name\": \"basicstyles\", \"items\" : [ \"Bold\",\"Italic\",\"Underline\",\"Strike\",\"Subscript\",\"Superscript\"] },\n		{ \"name\": \"paragraph\",   \"items\" : [ \"NumberedList\",\"BulletedList\",\"-\",\"Outdent\",\"Indent\",\"CreateDiv\"] },\n		{ \"name\": \"links\",       \"items\" : [ \"Link\",\"Unlink\",\"Anchor\" ] },\n		{ \"name\": \"insert\",      \"items\" : [ \"Image\",\"Flash\",\"Table\",\"HorizontalRule\",\"Smiley\",\"SpecialChar\" ] },\n		{ \"name\": \"contentbox\",  \"items\" : [ \"MediaEmbed\",\"cbIpsumLorem\",\"cbWidgets\",\"cbContentStore\",\"cbLinks\",\"cbEntryLinks\" ] }\n		]',''),(56,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_theme','default',''),(57,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_blocktime','5',''),(58,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_moderation_expiration','30',''),(59,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_disable_blog','false',''),(60,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_prePageDisplay','',''),(61,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_description','',''),(62,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_contentstore_caching','true',''),(63,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_gravatar_rating','PG',''),(64,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_maintenance_message','<h1>This site is down for maintenance.<br /> Please check back again soon.</h1>',''),(65,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_admin_theme','contentbox-default',''),(66,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_postIndexDisplay','',''),(67,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_recentcontentstore','5',''),(68,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_cachingTimeout','60',''),(69,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_moderation_blockedlist','',''),(70,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_login_signout_url','',''),(71,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_mail_ssl','false',''),(72,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_paging_bandgap','5',''),(73,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_maxComments','10',''),(74,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_rate_limiter','true',''),(75,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_allowDownloads','true',''),(76,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_beforeHeadEnd','',''),(77,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_caching','true',''),(78,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_hit_ignore_bots','false',''),(79,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_keywords','',''),(80,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_copyright','Ortus Solutions, Corp (www.ortussolutions.com)',''),(81,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_maintenance','false',''),(82,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_moderation','true',''),(83,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_rss_cachingTimeoutIdle','15',''),(84,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_admin_ssl','false',''),(85,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_recentComments','5',''),(86,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_paging_maxentries','10',''),(87,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_content_cachingHeader','true',''),(88,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_latest_logins','10',''),(89,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_search_adapter','contentbox.models.search.DBSearch',''),(90,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_notify_entry','true',''),(91,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_mail_smtp','25',''),(92,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_paging_maxrows','20',''),(93,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_2factorAuth_force','false',''),(94,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_rate_limiter_message','<p>You are making too many requests too fast, please slow down and wait {duration} seconds</p>',''),(95,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_rate_limiter_count','4',''),(96,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_moderation_notify','true',''),(97,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_max_attempts','5',''),(98,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_admin_quicksearch_max','5',''),(99,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_whoisURL','http://whois.arin.net/ui/query.do?q',''),(100,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_2factorAuth_provider','email',''),(101,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_comments_moderation_blacklist','',''),(102,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_dashboard_recentPages','5',''),(103,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_security_max_auth_logs','500',''),(104,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_editors_default','ckeditor',''),(105,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_mail_tls','false',''),(106,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_ssl','false',''),(107,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_media_provider','CFContentMediaProvider',''),(108,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_afterContent','',''),(109,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_site_sitemap','true',''),(110,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_gravatar_display','true',''),(111,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_editors_ckeditor_extraplugins','cbKeyBinding,cbWidgets,cbLinks,cbEntryLinks,cbContentStore,cbIpsumLorem,wsc,mediaembed,insertpre,justify,colorbutton,showblocks,find,div,smiley,specialchar,iframe',''),(112,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_postArchivesDisplay','',''),(113,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_html_beforeContent','',''),(114,'2019-12-16 16:44:00','2019-12-16 16:46:19','\0','cb_site_email','jclausen@ortussolutions.com',''),(115,'2019-12-16 16:44:00','2019-12-16 16:44:00','\0','cb_notify_contentstore','true',''),(116,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_paging_maxRSSComments','10',''),(117,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_html_afterFooter','',''),(118,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_media_provider_caching','true',''),(119,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_media_allowUploads','true',''),(120,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_site_blog_entrypoint','blog',''),(121,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_media_directoryRoot','/contentbox-custom/_content',''),(122,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_dashboard_welcome_body','',''),(123,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_search_maxResults','20',''),(124,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_content_uiexport','true',''),(125,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_security_rate_limiter_bots_only','true',''),(126,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_content_hit_count','true',''),(127,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_entry_caching','true',''),(128,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_html_postEntryDisplay','',''),(129,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_comments_moderation_whitelist','true',''),(130,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_comments_maxDisplayChars','500',''),(131,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_html_beforeBodyEnd','',''),(132,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_rss_caching','true',''),(133,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_security_rate_limiter_redirectURL','',''),(134,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_dashboard_recentEntries','5',''),(135,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_html_preCommentForm','',''),(136,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_rss_maxEntries','10',''),(137,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_cbBootswatchTheme','green','\0'),(138,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_overrideHeaderColors','false','\0'),(139,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_overrideHeaderBGColor','','\0'),(140,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_overrideHeaderTextColor','','\0'),(141,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_cssStyleOverrides','','\0'),(142,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_headerLogo','','\0'),(143,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showSiteSearch','true','\0'),(144,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_footerBox','','\0'),(145,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderTitle','','\0'),(146,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderText','','\0'),(147,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderLink','','\0'),(148,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBtnText','','\0'),(149,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBtnStyle','primary','\0'),(150,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBg','green','\0'),(151,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderImgBg','','\0'),(152,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBgPos','Top Center','\0'),(153,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBgPaddingTop','100px','\0'),(154,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_hpHeaderBgPaddingBottom','50px','\0'),(155,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_rssDiscovery','true','\0'),(156,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showCategoriesBlogSide','true','\0'),(157,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showRecentEntriesBlogSide','true','\0'),(158,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showSiteUpdatesBlogSide','true','\0'),(159,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showEntryCommentsBlogSide','true','\0'),(160,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showArchivesBlogSide','true','\0'),(161,'2019-12-16 16:44:01','2019-12-16 16:44:01','\0','cb_theme_default_showEntriesSearchBlogSide','true','\0'),(162,'2019-12-16 16:46:19','2019-12-16 16:46:19','\0','cb_active','true','\0');
/*!40000 ALTER TABLE `cb_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_stats`
--

DROP TABLE IF EXISTS `cb_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_stats` (
  `statsID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `hits` bigint(20) DEFAULT NULL,
  `FK_contentID` int(11) NOT NULL,
  PRIMARY KEY (`statsID`),
  UNIQUE KEY `FK_contentID` (`FK_contentID`),
  KEY `FK14DE30BF91F58374` (`FK_contentID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  CONSTRAINT `FK14DE30BF91F58374` FOREIGN KEY (`FK_contentID`) REFERENCES `cb_content` (`contentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_stats`
--

LOCK TABLES `cb_stats` WRITE;
/*!40000 ALTER TABLE `cb_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_subscribers`
--

DROP TABLE IF EXISTS `cb_subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_subscribers` (
  `subscriberID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `subscriberEmail` varchar(255) NOT NULL,
  `subscriberToken` varchar(255) NOT NULL,
  PRIMARY KEY (`subscriberID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_subscriberEmail` (`subscriberEmail`),
  KEY `idx_deleted` (`isDeleted`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_subscribers`
--

LOCK TABLES `cb_subscribers` WRITE;
/*!40000 ALTER TABLE `cb_subscribers` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_subscribers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cb_subscriptions`
--

DROP TABLE IF EXISTS `cb_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cb_subscriptions` (
  `subscriptionID` int(11) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `modifiedDate` datetime NOT NULL,
  `isDeleted` bit(1) NOT NULL DEFAULT b'0',
  `subscriptionToken` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `FK_subscriberID` int(11) NOT NULL,
  PRIMARY KEY (`subscriptionID`),
  KEY `FKE92A1716F2A66EE4` (`FK_subscriberID`),
  KEY `idx_createDate` (`createdDate`),
  KEY `idx_modifiedDate` (`modifiedDate`),
  KEY `idx_deleted` (`isDeleted`),
  KEY `idx_subscriber` (`FK_subscriberID`),
  CONSTRAINT `FKE92A1716F2A66EE4` FOREIGN KEY (`FK_subscriberID`) REFERENCES `cb_subscribers` (`subscriberID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cb_subscriptions`
--

LOCK TABLES `cb_subscriptions` WRITE;
/*!40000 ALTER TABLE `cb_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cb_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_SKUs`
--

DROP TABLE IF EXISTS `cbc_SKUs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_SKUs` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isVirtual` tinyint(1) NOT NULL DEFAULT 0,
  `isConsigned` tinyint(1) NOT NULL DEFAULT 0,
  `cost` decimal(8,2) NOT NULL,
  `basePrice` decimal(8,2) NOT NULL,
  `conditionDescription` text DEFAULT NULL,
  `minimumPrice` decimal(8,2) DEFAULT NULL,
  `MSRP` decimal(8,2) DEFAULT NULL,
  `discontinueOn` timestamp NULL DEFAULT NULL,
  `packagedWeight` decimal(8,2) NOT NULL DEFAULT 0.00,
  `packagingX` decimal(8,2) NOT NULL DEFAULT 0.00,
  `packagingY` decimal(8,2) NOT NULL DEFAULT 0.00,
  `packagingZ` decimal(8,2) NOT NULL DEFAULT 0.00,
  `FK_product` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_consignor` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `FK_condition` char(36) CHARACTER SET utf8 NOT NULL DEFAULT '253FFEB2-EB17-4341-ACBDC45885830ABA',
  `FK_subCondition` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `externalId` varchar(255) DEFAULT NULL,
  `modelNumber` varchar(255) DEFAULT NULL,
  `allowBackorder` tinyint(1) NOT NULL DEFAULT 1,
  `isFeatured` tinyint(1) NOT NULL DEFAULT 0,
  `MAP` decimal(8,2) DEFAULT NULL,
  `summary` varchar(1000) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `FK_consignmentBatch` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `showPricing` tinyint(1) NOT NULL DEFAULT 1,
  `pickUpInStore` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_SKUs_FK_product` (`FK_product`),
  KEY `fk_cbc_SKUs_FK_condition` (`FK_condition`),
  KEY `fk_cbc_SKUs_FK_subCondition` (`FK_subCondition`),
  KEY `fk_cbc_SKUs_FK_consignmentBatch` (`FK_consignmentBatch`),
  KEY `fk_cbc_SKUs_FK_consignor` (`FK_consignor`),
  CONSTRAINT `fk_cbc_SKUs_FK_condition` FOREIGN KEY (`FK_condition`) REFERENCES `cbc_productConditions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_SKUs_FK_consignee` FOREIGN KEY (`FK_consignor`) REFERENCES `cbc_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_SKUs_FK_consignmentBatch` FOREIGN KEY (`FK_consignmentBatch`) REFERENCES `cbc_consignmentBatches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_SKUs_FK_consignor` FOREIGN KEY (`FK_consignor`) REFERENCES `cbc_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_SKUs_FK_product` FOREIGN KEY (`FK_product`) REFERENCES `cbc_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_SKUs_FK_subCondition` FOREIGN KEY (`FK_subCondition`) REFERENCES `cbc_productConditions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_SKUs`
--

LOCK TABLES `cbc_SKUs` WRITE;
/*!40000 ALTER TABLE `cbc_SKUs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_SKUs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_carts`
--

DROP TABLE IF EXISTS `cbc_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_carts` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `contents` text NOT NULL,
  `audit` text DEFAULT NULL,
  `FK_user` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `FK_order` char(36) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_carts_FK_user` (`FK_user`),
  KEY `fk_cbc_carts_FK_order` (`FK_order`),
  CONSTRAINT `fk_cbc_carts_FK_order` FOREIGN KEY (`FK_order`) REFERENCES `cbc_orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_carts_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_carts`
--

LOCK TABLES `cbc_carts` WRITE;
/*!40000 ALTER TABLE `cbc_carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_consignmentBatchFees`
--

DROP TABLE IF EXISTS `cbc_consignmentBatchFees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_consignmentBatchFees` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `amount` decimal(8,2) NOT NULL DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `isPaid` tinyint(1) NOT NULL DEFAULT 0,
  `FK_batch` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_feeType` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_createdBy` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_consignmentBatchFees_FK_batch` (`FK_batch`),
  KEY `fk_cbc_consignmentBatchFees_FK_feeType` (`FK_feeType`),
  KEY `fk_cbc_consignmentBatchFees_FK_createdBy` (`FK_createdBy`),
  CONSTRAINT `fk_cbc_consignmentBatchFees_FK_batch` FOREIGN KEY (`FK_batch`) REFERENCES `cbc_consignmentBatches` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_consignmentBatchFees_FK_createdBy` FOREIGN KEY (`FK_createdBy`) REFERENCES `cbc_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_consignmentBatchFees_FK_feeType` FOREIGN KEY (`FK_feeType`) REFERENCES `cbc_consignmentFeeTypes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_consignmentBatchFees`
--

LOCK TABLES `cbc_consignmentBatchFees` WRITE;
/*!40000 ALTER TABLE `cbc_consignmentBatchFees` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_consignmentBatchFees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_consignmentBatches`
--

DROP TABLE IF EXISTS `cbc_consignmentBatches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_consignmentBatches` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `externalId` varchar(75) DEFAULT NULL,
  `summary` varchar(400) NOT NULL,
  `description` text DEFAULT NULL,
  `consignorPercent` decimal(8,2) NOT NULL DEFAULT 0.00,
  `cleaningHourlyRate` decimal(8,2) NOT NULL DEFAULT 0.00,
  `repairHourlyRate` decimal(8,2) NOT NULL DEFAULT 0.00,
  `FK_consignor` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_consignmentBatches_FK_consignor` (`FK_consignor`),
  CONSTRAINT `fk_cbc_consignmentBatches_FK_consignor` FOREIGN KEY (`FK_consignor`) REFERENCES `cbc_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_consignmentBatches`
--

LOCK TABLES `cbc_consignmentBatches` WRITE;
/*!40000 ALTER TABLE `cbc_consignmentBatches` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_consignmentBatches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_consignmentFeeTypes`
--

DROP TABLE IF EXISTS `cbc_consignmentFeeTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_consignmentFeeTypes` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `name` varchar(300) NOT NULL,
  `description` varchar(750) NOT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_consignmentFeeTypes`
--

LOCK TABLES `cbc_consignmentFeeTypes` WRITE;
/*!40000 ALTER TABLE `cbc_consignmentFeeTypes` DISABLE KEYS */;
INSERT INTO `cbc_consignmentFeeTypes` VALUES ('4AC1C54D-3A66-4B7C-BA710A45E1BA25F8','Repair','Fees for repair and maintenance of consigment items',3),('8D16934E-18B8-4116-B6845BF5BD94A1FD','Other','Other fees, not listed',6),('A71333C9-218A-46A4-BB75720500182FF1','Storage','Fees for storage or warehousing of consigment items',1),('B0408C32-CEAE-43E5-8F364B4C089CAEB4','Cleaning','Fees for cleaning or prepping consigment items',2),('C7C49A74-565E-4118-9CA0906C21B00E48','Shipping','Fees for shipping or return shipping of consignment items',5),('E29BBCAF-AE22-4D42-BB1E8D8100FD24AD','Disposal','Fees for disposal of consignment items',4);
/*!40000 ALTER TABLE `cbc_consignmentFeeTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_customerAddresses`
--

DROP TABLE IF EXISTS `cbc_customerAddresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_customerAddresses` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `designation` varchar(25) NOT NULL,
  `address1` varchar(255) NOT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `province` varchar(3) NOT NULL,
  `postalCode` varchar(15) NOT NULL,
  `country` varchar(3) NOT NULL DEFAULT 'USA',
  `isPrimary` tinyint(1) NOT NULL DEFAULT 0,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_customerAddresses_FK_user` (`FK_user`),
  CONSTRAINT `fk_cbc_customerAddresses_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_customerAddresses`
--

LOCK TABLES `cbc_customerAddresses` WRITE;
/*!40000 ALTER TABLE `cbc_customerAddresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_customerAddresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_inventoryLocationStock`
--

DROP TABLE IF EXISTS `cbc_inventoryLocationStock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_inventoryLocationStock` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `available` int(11) NOT NULL DEFAULT 0,
  `unaccounted` int(11) NOT NULL DEFAULT 0,
  `countRequired` tinyint(1) NOT NULL DEFAULT 0,
  `allowBackorder` tinyint(1) NOT NULL DEFAULT 0,
  `FK_sku` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_inventoryLocation` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_inventoryLocationStock_FK_sku` (`FK_sku`),
  KEY `fk_cbc_inventoryLocationStock_FK_inventoryLocation` (`FK_inventoryLocation`),
  CONSTRAINT `fk_cbc_inventoryLocationStock_FK_inventoryLocation` FOREIGN KEY (`FK_inventoryLocation`) REFERENCES `cbc_inventoryLocations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_inventoryLocationStock_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_inventoryLocationStock`
--

LOCK TABLES `cbc_inventoryLocationStock` WRITE;
/*!40000 ALTER TABLE `cbc_inventoryLocationStock` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_inventoryLocationStock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_inventoryLocations`
--

DROP TABLE IF EXISTS `cbc_inventoryLocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_inventoryLocations` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province` varchar(3) DEFAULT NULL,
  `postalCode` varchar(15) DEFAULT NULL,
  `country` varchar(3) NOT NULL DEFAULT 'USA',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_inventoryLocations`
--

LOCK TABLES `cbc_inventoryLocations` WRITE;
/*!40000 ALTER TABLE `cbc_inventoryLocations` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_inventoryLocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_lookups_products_categories`
--

DROP TABLE IF EXISTS `cbc_lookups_products_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_lookups_products_categories` (
  `increments` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FK_product` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_category` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`increments`),
  KEY `fk_cbc_lookups_products_categories_FK_product` (`FK_product`),
  KEY `fk_cbc_lookups_products_categories_FK_category` (`FK_category`),
  CONSTRAINT `fk_cbc_lookups_products_categories_FK_category` FOREIGN KEY (`FK_category`) REFERENCES `cbc_productCategories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_lookups_products_categories_FK_product` FOREIGN KEY (`FK_product`) REFERENCES `cbc_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_lookups_products_categories`
--

LOCK TABLES `cbc_lookups_products_categories` WRITE;
/*!40000 ALTER TABLE `cbc_lookups_products_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_lookups_products_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_lookups_roles_permissions`
--

DROP TABLE IF EXISTS `cbc_lookups_roles_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_lookups_roles_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FK_permission` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_user_role` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_lookups_roles_permissions_FK_permission` (`FK_permission`),
  KEY `fk_cbc_lookups_roles_permissions_FK_user_role` (`FK_user_role`),
  CONSTRAINT `fk_cbc_lookups_roles_permissions_FK_permission` FOREIGN KEY (`FK_permission`) REFERENCES `cbc_userPermissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cbc_lookups_roles_permissions_FK_user_role` FOREIGN KEY (`FK_user_role`) REFERENCES `cbc_userRoles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_lookups_roles_permissions`
--

LOCK TABLES `cbc_lookups_roles_permissions` WRITE;
/*!40000 ALTER TABLE `cbc_lookups_roles_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_lookups_roles_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_lookups_users_explicitPermissions`
--

DROP TABLE IF EXISTS `cbc_lookups_users_explicitPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_lookups_users_explicitPermissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FK_permission` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_lookups_users_explicitPermissions_FK_permission` (`FK_permission`),
  KEY `fk_cbc_lookups_users_explicitPermissions_FK_user` (`FK_user`),
  CONSTRAINT `fk_cbc_lookups_users_explicitPermissions_FK_permission` FOREIGN KEY (`FK_permission`) REFERENCES `cbc_userPermissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cbc_lookups_users_explicitPermissions_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_lookups_users_explicitPermissions`
--

LOCK TABLES `cbc_lookups_users_explicitPermissions` WRITE;
/*!40000 ALTER TABLE `cbc_lookups_users_explicitPermissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_lookups_users_explicitPermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_lookups_users_roles`
--

DROP TABLE IF EXISTS `cbc_lookups_users_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_lookups_users_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_user_role` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_lookups_users_roles_FK_user` (`FK_user`),
  KEY `fk_cbc_lookups_users_roles_FK_user_role` (`FK_user_role`),
  CONSTRAINT `fk_cbc_lookups_users_roles_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cbc_lookups_users_roles_FK_user_role` FOREIGN KEY (`FK_user_role`) REFERENCES `cbc_userRoles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_lookups_users_roles`
--

LOCK TABLES `cbc_lookups_users_roles` WRITE;
/*!40000 ALTER TABLE `cbc_lookups_users_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_lookups_users_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_media`
--

DROP TABLE IF EXISTS `cbc_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_media` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `designation` varchar(255) NOT NULL DEFAULT 'image',
  `title` varchar(255) DEFAULT NULL,
  `caption` varchar(750) DEFAULT NULL,
  `originalFileName` varchar(255) NOT NULL,
  `fileLocation` varchar(255) NOT NULL,
  `fileSizeBytes` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_media`
--

LOCK TABLES `cbc_media` WRITE;
/*!40000 ALTER TABLE `cbc_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_orderInvoices`
--

DROP TABLE IF EXISTS `cbc_orderInvoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_orderInvoices` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `internalId` varchar(255) NOT NULL,
  `externalId` varchar(255) DEFAULT NULL,
  `terms` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `FK_wishlist` char(36) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_orderInvoices_FK_wishlist` (`FK_wishlist`),
  CONSTRAINT `fk_cbc_orderInvoices_FK_wishlist` FOREIGN KEY (`FK_wishlist`) REFERENCES `cbc_wishlists` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_orderInvoices`
--

LOCK TABLES `cbc_orderInvoices` WRITE;
/*!40000 ALTER TABLE `cbc_orderInvoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_orderInvoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_orderItems`
--

DROP TABLE IF EXISTS `cbc_orderItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_orderItems` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isVirtual` tinyint(1) NOT NULL DEFAULT 0,
  `quantityOrdered` int(11) NOT NULL DEFAULT 1,
  `quantityCancelled` int(11) NOT NULL DEFAULT 0,
  `quantityRefunded` int(11) NOT NULL DEFAULT 0,
  `quantityDownloaded` int(11) DEFAULT NULL,
  `originalPrice` decimal(8,2) NOT NULL,
  `originalCost` decimal(8,2) NOT NULL,
  `productSnapshot` text DEFAULT NULL,
  `FK_order` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_orderItems_FK_order` (`FK_order`),
  CONSTRAINT `fk_cbc_orderItems_FK_order` FOREIGN KEY (`FK_order`) REFERENCES `cbc_orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_orderItems`
--

LOCK TABLES `cbc_orderItems` WRITE;
/*!40000 ALTER TABLE `cbc_orderItems` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_orderItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_orderShipments`
--

DROP TABLE IF EXISTS `cbc_orderShipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_orderShipments` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `quantity` int(11) NOT NULL,
  `carrierReferenceNumber` varchar(125) NOT NULL,
  `FK_order` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_inventoryLocation` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_orderShipments_FK_order` (`FK_order`),
  KEY `fk_cbc_orderShipments_FK_inventoryLocation` (`FK_inventoryLocation`),
  CONSTRAINT `fk_cbc_orderShipments_FK_inventoryLocation` FOREIGN KEY (`FK_inventoryLocation`) REFERENCES `cbc_inventoryLocations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_orderShipments_FK_order` FOREIGN KEY (`FK_order`) REFERENCES `cbc_orderItems` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_orderShipments`
--

LOCK TABLES `cbc_orderShipments` WRITE;
/*!40000 ALTER TABLE `cbc_orderShipments` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_orderShipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_orders`
--

DROP TABLE IF EXISTS `cbc_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_orders` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `approvalTime` timestamp NULL DEFAULT NULL,
  `fulfilledTime` timestamp NULL DEFAULT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  `shipping` decimal(8,2) NOT NULL,
  `fees` decimal(8,2) NOT NULL,
  `tax` decimal(8,2) NOT NULL,
  `discount` decimal(8,2) NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `paidInFull` timestamp NULL DEFAULT NULL,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_shippingAddress` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_billingAddress` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_invoice` char(36) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_orders_FK_user` (`FK_user`),
  KEY `fk_cbc_orders_FK_shippingAddress` (`FK_shippingAddress`),
  KEY `fk_cbc_orders_FK_billingAddress` (`FK_billingAddress`),
  KEY `fk_cbc_orders_FK_invoice` (`FK_invoice`),
  CONSTRAINT `fk_cbc_orders_FK_billingAddress` FOREIGN KEY (`FK_billingAddress`) REFERENCES `cbc_customerAddresses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_orders_FK_invoice` FOREIGN KEY (`FK_invoice`) REFERENCES `cbc_orderInvoices` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_orders_FK_shippingAddress` FOREIGN KEY (`FK_shippingAddress`) REFERENCES `cbc_customerAddresses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_orders_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_orders`
--

LOCK TABLES `cbc_orders` WRITE;
/*!40000 ALTER TABLE `cbc_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_payments`
--

DROP TABLE IF EXISTS `cbc_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_payments` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `externalTransactionID` varchar(255) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `comment` text DEFAULT NULL,
  `lastFour` int(11) NOT NULL,
  `paymentMethod` varchar(255) NOT NULL,
  `FK_order` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_externalTransactionID` (`externalTransactionID`),
  KEY `fk_cbc_payments_FK_order` (`FK_order`),
  CONSTRAINT `fk_cbc_payments_FK_order` FOREIGN KEY (`FK_order`) REFERENCES `cbc_orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_payments`
--

LOCK TABLES `cbc_payments` WRITE;
/*!40000 ALTER TABLE `cbc_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productCategories`
--

DROP TABLE IF EXISTS `cbc_productCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productCategories` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `FK_parent` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `isFeatured` tinyint(1) NOT NULL DEFAULT 0,
  `hitCount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productCategories_FK_parent` (`FK_parent`),
  KEY `idx_cbc_productCategories_name` (`name`),
  CONSTRAINT `fk_cbc_productCategories_FK_parent` FOREIGN KEY (`FK_parent`) REFERENCES `cbc_productCategories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productCategories`
--

LOCK TABLES `cbc_productCategories` WRITE;
/*!40000 ALTER TABLE `cbc_productCategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productCategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productCategoryMedia`
--

DROP TABLE IF EXISTS `cbc_productCategoryMedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productCategoryMedia` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isPrimary` tinyint(1) NOT NULL DEFAULT 0,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `FK_media` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_category` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productCategoryMedia_FK_media` (`FK_media`),
  KEY `fk_cbc_productCategoryMedia_FK_category` (`FK_category`),
  KEY `idx_productCategoryMedia_isPrimary` (`isPrimary`),
  KEY `idx_productCategoryMedia_sort` (`displayOrder`,`createdTime`),
  CONSTRAINT `fk_cbc_productCategoryMedia_FK_category` FOREIGN KEY (`FK_category`) REFERENCES `cbc_productCategories` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_productCategoryMedia_FK_media` FOREIGN KEY (`FK_media`) REFERENCES `cbc_media` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productCategoryMedia`
--

LOCK TABLES `cbc_productCategoryMedia` WRITE;
/*!40000 ALTER TABLE `cbc_productCategoryMedia` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productCategoryMedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productConditions`
--

DROP TABLE IF EXISTS `cbc_productConditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productConditions` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(25) NOT NULL,
  `FK_parent` char(36) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productConditions_FK_parent` (`FK_parent`),
  CONSTRAINT `fk_cbc_productConditions_FK_parent` FOREIGN KEY (`FK_parent`) REFERENCES `cbc_productConditions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productConditions`
--

LOCK TABLES `cbc_productConditions` WRITE;
/*!40000 ALTER TABLE `cbc_productConditions` DISABLE KEYS */;
INSERT INTO `cbc_productConditions` VALUES ('1301F67E-630A-4B7F-B58FA013C05F685F','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Excellent','F0189B2F-E0AC-41A8-95718596864D76A3'),('18B5652B-4EE6-4961-A6B50465278901A0','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Good','F0189B2F-E0AC-41A8-95718596864D76A3'),('1BD5B757-B887-4390-8B3F34B93E895565','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Unopened','253FFEB2-EB17-4341-ACBDC45885830ABA'),('253FFEB2-EB17-4341-ACBDC45885830ABA','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'New',NULL),('5E07DFE8-F7E8-411B-AF831CDFE17998AF','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Poor','F0189B2F-E0AC-41A8-95718596864D76A3'),('667F165D-A93F-433F-8443D13152CDAD50','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Like New','F0189B2F-E0AC-41A8-95718596864D76A3'),('9EEC133E-C345-45A5-BEAB0C99F7E39CF1','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Fair','F0189B2F-E0AC-41A8-95718596864D76A3'),('F0189B2F-E0AC-41A8-95718596864D76A3','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Used',NULL);
/*!40000 ALTER TABLE `cbc_productConditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productMedia`
--

DROP TABLE IF EXISTS `cbc_productMedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productMedia` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isPrimary` tinyint(1) NOT NULL DEFAULT 0,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `FK_media` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_product` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productMedia_FK_media` (`FK_media`),
  KEY `fk_cbc_productMedia_FK_product` (`FK_product`),
  KEY `idx_productMedia_isPrimary` (`isPrimary`),
  KEY `idx_productMedia_sort` (`displayOrder`,`createdTime`),
  CONSTRAINT `fk_cbc_productMedia_FK_media` FOREIGN KEY (`FK_media`) REFERENCES `cbc_media` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_cbc_productMedia_FK_product` FOREIGN KEY (`FK_product`) REFERENCES `cbc_products` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productMedia`
--

LOCK TABLES `cbc_productMedia` WRITE;
/*!40000 ALTER TABLE `cbc_productMedia` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productMedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productReviews`
--

DROP TABLE IF EXISTS `cbc_productReviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productReviews` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isPublished` tinyint(1) NOT NULL DEFAULT 0,
  `rating` decimal(8,2) NOT NULL,
  `relevancyScore` decimal(8,2) NOT NULL DEFAULT 0.00,
  `summary` varchar(255) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `FK_product` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_sku` char(36) CHARACTER SET utf8 DEFAULT NULL,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productReviews_FK_product` (`FK_product`),
  KEY `fk_cbc_productReviews_FK_sku` (`FK_sku`),
  KEY `fk_cbc_productReviews_FK_user` (`FK_user`),
  CONSTRAINT `fk_cbc_productReviews_FK_product` FOREIGN KEY (`FK_product`) REFERENCES `cbc_products` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_productReviews_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_productReviews_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productReviews`
--

LOCK TABLES `cbc_productReviews` WRITE;
/*!40000 ALTER TABLE `cbc_productReviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productReviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productSKUMedia`
--

DROP TABLE IF EXISTS `cbc_productSKUMedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productSKUMedia` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `isPrimary` tinyint(1) NOT NULL DEFAULT 0,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `FK_media` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_sku` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productSKUMedia_FK_media` (`FK_media`),
  KEY `fk_cbc_productSKUMedia_FK_sku` (`FK_sku`),
  CONSTRAINT `fk_cbc_productSKUMedia_FK_media` FOREIGN KEY (`FK_media`) REFERENCES `cbc_media` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_cbc_productSKUMedia_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productSKUMedia`
--

LOCK TABLES `cbc_productSKUMedia` WRITE;
/*!40000 ALTER TABLE `cbc_productSKUMedia` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productSKUMedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_productSKUOptions`
--

DROP TABLE IF EXISTS `cbc_productSKUOptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_productSKUOptions` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL,
  `value` varchar(255) NOT NULL,
  `FK_sku` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_productSKUOptions_FK_sku` (`FK_sku`),
  CONSTRAINT `fk_cbc_productSKUOptions_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_productSKUOptions`
--

LOCK TABLES `cbc_productSKUOptions` WRITE;
/*!40000 ALTER TABLE `cbc_productSKUOptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_productSKUOptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_products`
--

DROP TABLE IF EXISTS `cbc_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_products` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(300) NOT NULL,
  `shortDescription` varchar(1000) NOT NULL,
  `description` text NOT NULL,
  `hasOptions` tinyint(1) NOT NULL,
  `requiredOptions` text NOT NULL,
  `displayOrder` int(11) NOT NULL DEFAULT 0,
  `externalId` varchar(255) DEFAULT NULL,
  `manufacturer` varchar(255) DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT 0,
  `hitCount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_cbc_products_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_products`
--

LOCK TABLES `cbc_products` WRITE;
/*!40000 ALTER TABLE `cbc_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_tenantSettings`
--

DROP TABLE IF EXISTS `cbc_tenantSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_tenantSettings` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_tenantSettings`
--

LOCK TABLES `cbc_tenantSettings` WRITE;
/*!40000 ALTER TABLE `cbc_tenantSettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_tenantSettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_userPermissions`
--

DROP TABLE IF EXISTS `cbc_userPermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_userPermissions` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `prefix` varchar(75) NOT NULL,
  `suffix` varchar(75) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_userPermissions`
--

LOCK TABLES `cbc_userPermissions` WRITE;
/*!40000 ALTER TABLE `cbc_userPermissions` DISABLE KEYS */;
INSERT INTO `cbc_userPermissions` VALUES ('05D51BF6-F3F2-4985-88A05C87D4D90300','2019-12-17 13:09:25','2019-12-17 13:09:25','Order','Approve'),('07A3D79F-DDF6-47DC-86BA0025046EFFD8','2019-12-17 13:09:25','2019-12-17 13:09:25','Return','Configure'),('15435527-DA36-4FD3-B834D77B3131450B','2019-12-17 13:09:25','2019-12-17 13:09:25','System','Configure'),('24793278-4909-4A0A-A1DFCF45D1177E54','2019-12-17 13:09:25','2019-12-17 13:09:25','Return','Delete'),('2AA982CF-D329-4AEF-85098A89E717D25A','2019-12-17 13:09:25','2019-12-17 13:09:25','Order','Edit'),('37876915-C6C2-4CAC-B05603F01186EBF0','2019-12-17 13:09:25','2019-12-17 13:09:25','System','Delete'),('457EDADE-758C-4011-A37F3F5D39640D66','2019-12-17 13:09:25','2019-12-17 13:09:25','Product','Delete'),('5E0BCC05-C82A-450F-9D5D7CA67C257045','2019-12-17 13:09:25','2019-12-17 13:09:25','Order','Configure'),('62EB438F-2E49-4D6D-98119E8B6BF46D85','2019-12-17 13:09:25','2019-12-17 13:09:25','Product','Manage'),('81031903-C482-4685-B54516FBDA3DE2A4','2019-12-17 13:09:25','2019-12-17 13:09:25','Return','Approve'),('8D81EAC7-8201-4F08-AE793CEBBB7DF4CC','2019-12-17 13:09:25','2019-12-17 13:09:25','System','Edit'),('ABE36CBF-8661-4D1E-8982AABE5A0E8767','2019-12-17 13:09:25','2019-12-17 13:09:25','Product','Approve'),('BD34E1A6-369E-46F3-B3F612E61355667B','2019-12-17 13:09:25','2019-12-17 13:09:25','Order','Manage'),('C5976436-C246-4449-9B63641C047F5D3E','2019-12-17 13:09:25','2019-12-17 13:09:25','System','Approve'),('C86D9B3A-93B5-4842-A770671489AE6F62','2019-12-17 13:09:25','2019-12-17 13:09:25','System','Manage'),('D24AA556-65DF-4E85-88583A519DF9721E','2019-12-17 13:09:25','2019-12-17 13:09:25','Order','Delete'),('D3118FB8-3A23-4E7A-BF137845D9B075B3','2019-12-17 13:09:25','2019-12-17 13:09:25','Return','Manage'),('E4BAC0C7-9D22-49B8-ADC0F7095A26BA73','2019-12-17 13:09:25','2019-12-17 13:09:25','Product','Edit'),('E63BD4E8-833D-4DA8-923B266E0C246F84','2019-12-17 13:09:25','2019-12-17 13:09:25','Return','Edit'),('FD04E719-4DB1-47E9-BEC3D07317C2F1CC','2019-12-17 13:09:25','2019-12-17 13:09:25','Product','Configure');
/*!40000 ALTER TABLE `cbc_userPermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_userRoles`
--

DROP TABLE IF EXISTS `cbc_userRoles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_userRoles` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(75) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_userRoles`
--

LOCK TABLES `cbc_userRoles` WRITE;
/*!40000 ALTER TABLE `cbc_userRoles` DISABLE KEYS */;
INSERT INTO `cbc_userRoles` VALUES ('13C6088A-BF47-413B-8EF30F232FE79FF4','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Administrator'),('4288D24D-84FE-4C8D-B884507D80B1891D','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'User'),('474E7EF3-C8C4-4341-B71B0F351DCF2512','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Editor'),('5348D388-D70B-4B4A-A9DD1E833D518138','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Manager'),('6B022515-6191-47DC-BC5E82A0220F5220','2019-12-17 13:09:26','2019-12-17 13:09:26',1,'Consignor'),('87FC240F-192D-4013-AE4C7DAA2591EC3A','2019-12-17 13:09:25','2019-12-17 13:09:25',1,'Marketer');
/*!40000 ALTER TABLE `cbc_userRoles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_users`
--

DROP TABLE IF EXISTS `cbc_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_users` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `primaryPhone` char(25) CHARACTER SET utf8 DEFAULT NULL,
  `secondaryPhone` char(25) CHARACTER SET utf8 DEFAULT NULL,
  `resetToken` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_users`
--

LOCK TABLES `cbc_users` WRITE;
/*!40000 ALTER TABLE `cbc_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_virtualSKUs`
--

DROP TABLE IF EXISTS `cbc_virtualSKUs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_virtualSKUs` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `location` varchar(255) NOT NULL,
  `FK_sku` char(36) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_virtualSKUs_FK_sku` (`FK_sku`),
  CONSTRAINT `fk_cbc_virtualSKUs_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_virtualSKUs`
--

LOCK TABLES `cbc_virtualSKUs` WRITE;
/*!40000 ALTER TABLE `cbc_virtualSKUs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_virtualSKUs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_wishlistItems`
--

DROP TABLE IF EXISTS `cbc_wishlistItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_wishlistItems` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `baselinePrice` decimal(10,0) NOT NULL,
  `FK_sku` char(36) CHARACTER SET utf8 NOT NULL,
  `FK_wishlist` char(36) CHARACTER SET utf8 NOT NULL,
  `discountPrice` decimal(10,0) NOT NULL DEFAULT 0,
  `quantity` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_wishlistItems_FK_sku` (`FK_sku`),
  KEY `fk_cbc_wishlistItems_FK_wishlist` (`FK_wishlist`),
  CONSTRAINT `fk_cbc_wishlistItems_FK_sku` FOREIGN KEY (`FK_sku`) REFERENCES `cbc_SKUs` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_cbc_wishlistItems_FK_wishlist` FOREIGN KEY (`FK_wishlist`) REFERENCES `cbc_wishlists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_wishlistItems`
--

LOCK TABLES `cbc_wishlistItems` WRITE;
/*!40000 ALTER TABLE `cbc_wishlistItems` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_wishlistItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cbc_wishlists`
--

DROP TABLE IF EXISTS `cbc_wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cbc_wishlists` (
  `id` char(36) CHARACTER SET utf8 NOT NULL,
  `createdTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifiedTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(255) NOT NULL,
  `FK_user` char(36) CHARACTER SET utf8 NOT NULL,
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  `isPublic` tinyint(1) NOT NULL DEFAULT 0,
  `description` varchar(750) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cbc_wishlists_FK_user` (`FK_user`),
  CONSTRAINT `fk_cbc_wishlists_FK_user` FOREIGN KEY (`FK_user`) REFERENCES `cbc_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cbc_wishlists`
--

LOCK TABLES `cbc_wishlists` WRITE;
/*!40000 ALTER TABLE `cbc_wishlists` DISABLE KEYS */;
/*!40000 ALTER TABLE `cbc_wishlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cf_session_data`
--

DROP TABLE IF EXISTS `cf_session_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cf_session_data` (
  `expires` varchar(64) NOT NULL,
  `cfid` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `data` longtext NOT NULL,
  UNIQUE KEY `ix_cf_session_data` (`cfid`,`name`,`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cf_session_data`
--

LOCK TABLES `cf_session_data` WRITE;
/*!40000 ALTER TABLE `cf_session_data` DISABLE KEYS */;
INSERT INTO `cf_session_data` VALUES ('1576591766949','d2326e46-cdbd-4d3e-9881-c769a359b3fa','ContentBox-Docker-','rO0ABXNyAC9sdWNlZS5ydW50aW1lLnR5cGUuc2NvcGUuc3RvcmFnZS5JS1N0b3JhZ2VWYWx1ZSXcdnpeLxPxAgACSgAMbGFzdE1vZGlmaWVkWwAEYmFycnQAAltCeHAAAAFvE/pHOnVyAAJbQqzzF/gGCFTgAgAAeHAAAAQ7rO0ABXNyADhsdWNlZS5jb21tb25zLmNvbGxlY3Rpb24uY29uY3VycmVudC5Db25jdXJyZW50SGFzaE1hcFByb2SZ3hKdhyk9DAAAeHIAJ2x1Y2VlLmNvbW1vbnMuY29sbGVjdGlvbi5BYnN0cmFjdE1hcFByb5cs+1bXolTMDAAAeHBzcgARamF2YS51dGlsLkhhc2hNYXAFB9rBwxZg0QMAAkYACmxvYWRGYWN0b3JJAAl0aHJlc2hvbGR4cD9AAAAAAAAMdwgAAAAQAAAAB3NyABpsdWNlZS5ydW50aW1lLnR5cGUuS2V5SW1wbIT5vy9p9G9nDAAAeHB0AARjZmlkeHNyADNsdWNlZS5ydW50aW1lLnR5cGUuc2NvcGUuc3RvcmFnZS5JS1N0b3JhZ2VTY29wZUl0ZW2OXwiJ9eeLTgIAA0oAC2xhc3RNb2RpZmVkWgAHcmVtb3ZlZEwABXZhbHVldAASTGphdmEvbGFuZy9PYmplY3Q7eHAAAAFvE/pG2QB0ACRkMjMyNmU0Ni1jZGJkLTRkM2UtOTg4MS1jNzY5YTM1OWIzZmFzcQB+AAV0ABBjYm94X2ZsYXNoX3Njb3BleHNxAH4ACAAAAW8T+kc4AHNyAB1sdWNlZS5ydW50aW1lLnR5cGUuU3RydWN0SW1wbBO7DyUhSuS5AgABTAADbWFwdAAhTGx1Y2VlL2NvbW1vbnMvY29sbGVjdGlvbi9NYXBQcm87eHIAJWx1Y2VlLnJ1bnRpbWUudHlwZS51dGlsLlN0cnVjdFN1cHBvcnRnKbKJGDmF4wIAAHhwc3EAfgAAc3EAfgADP0AAAAAAAAB3CAAAABAAAAAAeHhzcQB+AAV0AAlsYXN0dmlzaXR4c3EAfgAIAAABbxP6RzkAc3IAImx1Y2VlLnJ1bnRpbWUudHlwZS5kdC5EYXRlVGltZUltcGyL7K30ezFucgIAAHhyAB5sdWNlZS5ydW50aW1lLnR5cGUuZHQuRGF0ZVRpbWUfMrJraWnmvwIAAHhyAA5qYXZhLnV0aWwuRGF0ZWhqgQFLWXQZAwAAeHB3CAAAAW8T+kbEeHNxAH4ABXQACXNlc3Npb25pZHhzcQB+AAgAAAFvE/pG2QB0ADlDb250ZW50Qm94LURvY2tlci1fZDIzMjZlNDYtY2RiZC00ZDNlLTk4ODEtYzc2OWEzNTliM2ZhXzBzcQB+AAV0AAt0aW1lY3JlYXRlZHhzcQB+AAgAAAFvE/pHOQBzcQB+ABh3CAAAAW8T86T0eHNxAH4ABXQACHVybHRva2VueHNxAH4ACAAAAW8T+kbZAHQAM0NGSUQ9ZDIzMjZlNDYtY2RiZC00ZDNlLTk4ODEtYzc2OWEzNTliM2ZhJkNGVE9LRU49MHNxAH4ABXQAB2NmdG9rZW54c3EAfgAIAAABbxP6RtkAdAABMHh4');
/*!40000 ALTER TABLE `cf_session_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cfmigrations`
--

DROP TABLE IF EXISTS `cfmigrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cfmigrations` (
  `name` varchar(190) NOT NULL,
  `migration_ran` datetime NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cfmigrations`
--

LOCK TABLES `cfmigrations` WRITE;
/*!40000 ALTER TABLE `cfmigrations` DISABLE KEYS */;
INSERT INTO `cfmigrations` VALUES ('2018_03_31_083126_cbCommerce_Install','2019-12-17 13:09:25'),('2018_10_11_072448_createOrderInvoices','2019-12-17 13:09:25'),('2018_12_04_070709_AddCategorySortOrder','2019-12-17 13:09:25'),('2018_12_04_082801_AddProductSKUSortOrder','2019-12-17 13:09:25'),('2018_12_04_083224_AddProductSKUExternalRefs','2019-12-17 13:09:25'),('2018_12_04_084946_AddSkuModelNumber','2019-12-17 13:09:25'),('2018_12_05_163318_AddManufacturerColumn','2019-12-17 13:09:25'),('2018_12_11_122144_AddSkuBackorderColumns','2019-12-17 13:09:25'),('2018_12_18_085919_AddWishlistBooleans','2019-12-17 13:09:25'),('2018_12_20_162533_CreateCategoryMediaTable','2019-12-17 13:09:26'),('2018_12_20_191257_ChangeOrderColumnName','2019-12-17 13:09:26'),('2018_12_26_102959_AddReviewsSchema','2019-12-17 13:09:26'),('2018_12_27_113301_AddFeatureColumns','2019-12-17 13:09:26'),('2019_01_01_232014_AllowSkuDiscontinueNulls','2019-12-17 13:09:26'),('2019_01_02_123225_FixSKUMediaFKSKUCasing','2019-12-17 13:09:26'),('2019_01_03_105127_AddHitsColumns','2019-12-17 13:09:26'),('2019_01_03_205645_AddConsigneeRole','2019-12-17 13:09:26'),('2019_01_08_151221_AllowNull','2019-12-17 13:09:26'),('2019_01_08_155951_AddFullNameColumn','2019-12-17 13:09:26'),('2019_02_11_152956_AddOptionsEntity','2019-12-17 13:09:26'),('2019_02_11_193830_AddMAPColumnToSKUs','2019-12-17 13:09:26'),('2019_02_11_220408_AddSKUDescriptionFields','2019-12-17 13:09:26'),('2019_03_05_220524_AddConsignmentBatchTable','2019-12-17 13:09:26'),('2019_03_06_073658_RenameConsigneeToConsignor','2019-12-17 13:09:26'),('2019_03_12_224716_CreateTenantSettingsTable','2019-12-17 13:09:26'),('2019_03_19_110458_AddSkuDisplyPricingField','2019-12-17 13:09:26'),('2019_03_21_084255_AddWishlistItemDiscountPrice','2019-12-17 13:09:26'),('2019_03_23_180323_AddDescriptionToWishlist','2019-12-17 13:09:26'),('2019_03_25_081915_AddWishlistItemQuantity','2019-12-17 13:09:26'),('2019_04_17_085301_AddUserResetToken','2019-12-17 13:09:26'),('2019_04_17_191912_AddCategoryAndProductIndexes','2019-12-17 13:09:26'),('2019_04_23_172348_IncreaseResetTokenLength','2019-12-17 13:09:26'),('2019_05_06_072840_AddStorePickupColumnToSkus','2019-12-17 13:09:26');
/*!40000 ALTER TABLE `cfmigrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-17 13:10:30
