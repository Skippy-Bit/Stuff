-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: booking
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `booking` (
  `booking_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `checkin` date DEFAULT NULL,
  `checkout` date DEFAULT NULL,
  `property_id` bigint(20) unsigned DEFAULT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `contact_email` varchar(254) DEFAULT NULL,
  `contact_phone` varchar(50) DEFAULT NULL,
  `contact_address_street` varchar(50) DEFAULT NULL,
  `contact_address_zipcode` varchar(20) DEFAULT NULL,
  `contact_address_city` varchar(50) DEFAULT NULL,
  `contact_address_country` varchar(50) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `booking_id` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `property` (
  `property_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `property_name` varchar(50) DEFAULT NULL,
  `property_description` text,
  `property_details` text,
  `property_location` varchar(100) DEFAULT NULL,
  `property_photo` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `property_id` (`property_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property`
--

LOCK TABLES `property` WRITE;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` VALUES (1,'Holiday home Røros','The property features views of the sea and is 23 km from Røros.','Vestibulum risus sem, dictum at faucibus vel, ultricies nec felis. Praesent a mattis diam. Ut sit amet lectus et orci tempor consectetur laoreet vitae leo. Mauris rutrum dolor a commodo laoreet. Mauris sollicitudin, odio id condimentum dapibus, enim arcu tincidunt elit, mollis porta tortor ligula eget metus. In eleifend luctus sapien in semper. In ornare feugiat consequat.','Røros, Sør-Trøndelag','property_1.png'),(2,'Oppdal Turisthotell','It offers free parking and rooms with free WiFi and a private bathroom. Oppdal Ski Centre is a 10-minute walk away.','Vivamus finibus nisl vitae justo ullamcorper pulvinar. Integer ut justo nec risus sollicitudin imperdiet. Nam tellus ante, euismod sed maximus et, mattis sed metus. Ut id condimentum sapien. Sed ex nibh, rhoncus vel efficitur in, tincidunt et odio. Suspendisse gravida lorem a lacus condimentum, ac venenatis arcu pellentesque. Phasellus at faucibus mauris. Mauris facilisis, mi et ullamcorper aliquet, sem quam tristique nulla, nec dignissim augue elit eu dui. Curabitur ac eleifend odio. Etiam at sapien justo. Nam leo purus, vulputate ut porttitor venenatis, pulvinar at odio. Nam finibus, nibh non convallis tempor, eros lacus ultrices leo, ut vestibulum nulla velit sit amet leo. Donec sodales, erat eget bibendum molestie, lorem quam fringilla leo, non malesuada urna quam non nisi.','Oppdal, Sør-Trøndelag','property_2.png'),(3,'Granmo Camping','Granmo Camping is scenically situated in Oppdal, right by Dovrefjell National Park. Facilities include a mini-market and, a snack bar and a shared kitchen.','Sed ac hendrerit dui, sed tincidunt erat. Duis ut malesuada lorem. Nulla venenatis vitae enim at rhoncus. Nunc vitae libero eget odio viverra congue eget et nulla. Nam vulputate risus neque, non feugiat velit malesuada et. Cras elementum, erat vel ultricies laoreet, nunc est pretium nisl, id placerat elit nisl eu massa. Pellentesque finibus nibh id leo porta cursus. Curabitur venenatis, ipsum id venenatis blandit, enim justo pulvinar ex, id ornare sem neque non tellus. Phasellus euismod eu tellus in egestas. Vivamus tempor euismod auctor. Nunc vel nunc nunc. Cras in nisl tortor. Nunc eleifend lectus ut ex malesuada, sit amet pretium dolor tempus.','Røros, Sør-Trøndelag','property_3.png'),(4,'Sjøberg Ferie','These modern apartments are set on Rennesøy island. Boats can be rented on site.','Morbi sit amet massa eu urna vestibulum finibus. Sed feugiat magna lorem, eget dictum augue posuere vitae. Ut ligula erat, bibendum non vestibulum id, lacinia faucibus diam. Integer eu elit dignissim, pellentesque augue eu, pellentesque metus. Vestibulum volutpat purus ligula, at scelerisque arcu aliquet sed. Praesent fermentum dolor eu quam placerat bibendum. Integer non neque leo.','Østhusvik, Rogaland','property_4.png'),(5,'Holiday home Jørpeland Høllesli','Holiday home Jørpeland Høllesli offers accommodation in Forsand, 21 km from Stavanger and 23 km from Sandnes.','Vestibulum quis accumsan quam. Nulla eu magna vitae tortor semper vestibulum. Vestibulum laoreet ligula non eros finibus scelerisque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nunc in tellus tellus. Aliquam euismod, nisl ut mollis malesuada, elit ligula dictum quam, et sollicitudin sem eros eu sapien. Sed est est, iaculis et viverra sit amet, rhoncus sit amet risus. Praesent facilisis risus vitae diam ultrices, at hendrerit ex volutpat. Donec sed eleifend nulla. Integer at urna vitae libero consectetur congue. In dignissim massa in neque accumsan, in venenatis diam vestibulum. Suspendisse mattis lectus mollis sem imperdiet, id faucibus lacus efficitur. Fusce nisi lorem, convallis vel quam sed, sollicitudin fermentum mauris. Vestibulum lobortis, mi a commodo malesuada, sem lacus fermentum sapien, eget dictum felis ipsum vitae nisl. Vivamus laoreet dolor id imperdiet tempor. Etiam lobortis et nisi eu pretium.','Forsand, Rogaland','property_5.png'),(6,'Høiland Gard','This self catering accommodation, Høiland Gard, is located 5 minutes’ drive from Årdal village. Eventyrskogen Hiking Trail is 1 km away.','Donec porta metus vitae faucibus consequat. Donec sed arcu quis mauris maximus ultrices. Praesent in congue tortor, vel porttitor nulla. Donec id nulla in lacus posuere consequat. Etiam vitae elit et sem placerat accumsan eu vitae orci. Suspendisse vulputate scelerisque ipsum, eu varius augue ultricies eu. Ut sed ligula nec magna varius dapibus. Proin nec condimentum lacus, ut eleifend dolor.','Årdal, Rogaland','property_6.png');
/*!40000 ALTER TABLE `property` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-23 17:57:04
