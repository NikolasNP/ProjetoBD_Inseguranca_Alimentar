-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: projeto_insegurancaalimentar
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `beneficio`
--

DROP TABLE IF EXISTS `beneficio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beneficio` (
  `id_beneficio` int NOT NULL AUTO_INCREMENT,
  `tipo_beneficio` varchar(100) DEFAULT NULL,
  `valor_estimado` decimal(10,2) DEFAULT NULL,
  `periodicidade` varchar(50) DEFAULT NULL,
  `data_recebimento` date DEFAULT NULL,
  `id_familia` int DEFAULT NULL,
  `id_programa_social` int DEFAULT NULL,
  PRIMARY KEY (`id_beneficio`),
  KEY `id_familia` (`id_familia`),
  KEY `id_programa_social` (`id_programa_social`),
  CONSTRAINT `beneficio_ibfk_1` FOREIGN KEY (`id_familia`) REFERENCES `familia` (`id_familia`),
  CONSTRAINT `beneficio_ibfk_2` FOREIGN KEY (`id_programa_social`) REFERENCES `programa_social` (`id_programa_social`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beneficio`
--

LOCK TABLES `beneficio` WRITE;
/*!40000 ALTER TABLE `beneficio` DISABLE KEYS */;
INSERT INTO `beneficio` VALUES (1,'Dinheiro',250.00,'Mensal','2025-11-15',1,1),(2,'Cesta Básica',150.00,'Quinzenal','2025-11-01',2,5),(3,'Remédios',80.00,'Mensal','2025-11-20',2,2),(4,'Auxílio Moradia',400.00,'Mensal','2025-11-10',4,4),(5,'Dinheiro',350.00,'Mensal','2025-11-15',1,1);
/*!40000 ALTER TABLE `beneficio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domicilio`
--

DROP TABLE IF EXISTS `domicilio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domicilio` (
  `id_domicilio` int NOT NULL AUTO_INCREMENT,
  `tipo_domicilio` varchar(100) DEFAULT NULL,
  `numero_comodos` int DEFAULT NULL,
  `situacao_ocupacao` varchar(100) DEFAULT NULL,
  `renda_total_domiciliar` decimal(10,2) DEFAULT NULL,
  `id_regiao` int DEFAULT NULL,
  `id_data_levantamento` int DEFAULT NULL,
  PRIMARY KEY (`id_domicilio`),
  KEY `id_regiao` (`id_regiao`),
  KEY `id_data_levantamento` (`id_data_levantamento`),
  CONSTRAINT `domicilio_ibfk_1` FOREIGN KEY (`id_regiao`) REFERENCES `regiao` (`id_regiao`),
  CONSTRAINT `domicilio_ibfk_2` FOREIGN KEY (`id_data_levantamento`) REFERENCES `levantamento` (`id_data_levantamento`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domicilio`
--

LOCK TABLES `domicilio` WRITE;
/*!40000 ALTER TABLE `domicilio` DISABLE KEYS */;
INSERT INTO `domicilio` VALUES (1,'Apartamento',4,'Aluguel',0.00,1,1),(2,'Casa',3,'Próprio',1200.00,2,2),(3,'Casa',6,'Próprio',7800.00,3,3),(4,'Barraco',2,'Ocupação irregular',850.00,4,4),(5,'Casa',5,'Próprio',4100.00,5,5),(6,'Teste',2,'Aluguel',0.00,1,1);
/*!40000 ALTER TABLE `domicilio` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `corrige_renda` BEFORE INSERT ON `domicilio` FOR EACH ROW begin
	if new.renda_total_domiciliar < 0 then
		set new.renda_total_domiciliar = 0;
        end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `corrige_renda_before_update` BEFORE UPDATE ON `domicilio` FOR EACH ROW begin
	if new.renda_total_domiciliar < 0 then
		set new.renda_total_domiciliar = 0;
	end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `domicilio_regiao`
--

DROP TABLE IF EXISTS `domicilio_regiao`;
/*!50001 DROP VIEW IF EXISTS `domicilio_regiao`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `domicilio_regiao` AS SELECT 
 1 AS `id_domicilio`,
 1 AS `tipo_domicilio`,
 1 AS `numero_comodos`,
 1 AS `renda_total_domiciliar`,
 1 AS `nome_regiao`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `familia`
--

DROP TABLE IF EXISTS `familia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `familia` (
  `id_familia` int NOT NULL AUTO_INCREMENT,
  `situacao_inseguranca_alimentar` varchar(100) DEFAULT NULL,
  `recebe_beneficio` varchar(100) DEFAULT NULL,
  `chefe_familia` varchar(100) DEFAULT NULL,
  `id_domicilio` int DEFAULT NULL,
  `id_indice_inseguranca` int DEFAULT NULL,
  PRIMARY KEY (`id_familia`),
  KEY `id_domicilio` (`id_domicilio`),
  KEY `id_indice_inseguranca` (`id_indice_inseguranca`),
  CONSTRAINT `familia_ibfk_1` FOREIGN KEY (`id_domicilio`) REFERENCES `domicilio` (`id_domicilio`),
  CONSTRAINT `familia_ibfk_2` FOREIGN KEY (`id_indice_inseguranca`) REFERENCES `indice` (`id_indice_inseguranca`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `familia`
--

LOCK TABLES `familia` WRITE;
/*!40000 ALTER TABLE `familia` DISABLE KEYS */;
INSERT INTO `familia` VALUES (1,'Insegurança Alimentar Leve','Sim','Maria Conceição',1,1),(2,'Insegurança Alimentar Grave','Sim','João da Silva',2,2),(3,'Segurança Alimentar','Não','Ana Lúcia',3,3),(4,'Insegurança Alimentar Grave','Sim','Pedro Santos',4,4),(5,'Segurança Alimentar','Não','Luciana Lima',5,5),(6,'Segurança Alimentar','Sim','Raimundo Teste',1,1);
/*!40000 ALTER TABLE `familia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indice`
--

DROP TABLE IF EXISTS `indice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indice` (
  `id_indice_inseguranca` int NOT NULL AUTO_INCREMENT,
  `pontuacao` decimal(5,2) DEFAULT NULL,
  `escala_usada` varchar(100) DEFAULT NULL,
  `observacoes` varchar(255) DEFAULT NULL,
  `classificacao` varchar(100) DEFAULT NULL,
  `id_data_levantamento` int DEFAULT NULL,
  PRIMARY KEY (`id_indice_inseguranca`),
  KEY `id_data_levantamento` (`id_data_levantamento`),
  CONSTRAINT `indice_ibfk_1` FOREIGN KEY (`id_data_levantamento`) REFERENCES `levantamento` (`id_data_levantamento`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indice`
--

LOCK TABLES `indice` WRITE;
/*!40000 ALTER TABLE `indice` DISABLE KEYS */;
INSERT INTO `indice` VALUES (1,4.50,'EBIA','Vulnerabilidade alta','Insegurança Alimentar Grave',1),(2,2.10,'EBIA','Baixa renda, mas com apoio','Insegurança Alimentar Leve',2),(3,0.80,'EBIA','Renda estável','Segurança Alimentar',3),(4,5.00,'EBIA','Sem acesso a serviços','Insegurança Alimentar Grave',4),(5,1.50,'EBIA','Acesso pleno a alimentos','Segurança Alimentar',5);
/*!40000 ALTER TABLE `indice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instituicao`
--

DROP TABLE IF EXISTS `instituicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instituicao` (
  `id_instituicao` int NOT NULL AUTO_INCREMENT,
  `area_atuacao` varchar(100) DEFAULT NULL,
  `nome_instituicao` varchar(100) DEFAULT NULL,
  `responsavel_instituicao` varchar(100) DEFAULT NULL,
  `tipo_instituicao` varchar(100) DEFAULT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `contato` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_instituicao`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instituicao`
--

LOCK TABLES `instituicao` WRITE;
/*!40000 ALTER TABLE `instituicao` DISABLE KEYS */;
INSERT INTO `instituicao` VALUES (1,'Assistência Social','CRAS Central','Marta Oliveira','Governamental','Rua das Flores, 100','(11) 98765-4321'),(2,'Saúde','UBS Leste','Dr. Ricardo Silva','Governamental','Av. Principal, 500','(11) 91234-5678'),(3,'Educação','ONG Saber Mais','João Pedro','Não Governamental','Praça da Liberdade, 22','(11) 99887-7665'),(4,'Habitação','Cohab Municipal','Ana Paula Costa','Governamental','Setor Público, Bloco C','(11) 95544-3322'),(5,'Alimentação','Banco de Alimentos','Maria Lúcia','Não Governamental','R. Armazém, 30','(11) 97766-5544');
/*!40000 ALTER TABLE `instituicao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `levantamento`
--

DROP TABLE IF EXISTS `levantamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `levantamento` (
  `id_data_levantamento` int NOT NULL AUTO_INCREMENT,
  `data` date DEFAULT NULL,
  `responsavel` varchar(100) DEFAULT NULL,
  `numero_equipamentos_publicos` int DEFAULT NULL,
  `metodo` varchar(100) DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_data_levantamento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `levantamento_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `levantamento`
--

LOCK TABLES `levantamento` WRITE;
/*!40000 ALTER TABLE `levantamento` DISABLE KEYS */;
INSERT INTO `levantamento` VALUES (1,'2025-10-01','Ana Silva',12,'Entrevista Presencial',1),(2,'2025-10-05','Carlos Rocha',5,'Questionário Online',2),(3,'2025-10-10','Ana Silva',18,'Entrevista Presencial',1),(4,'2025-10-15','Lucia Tec',3,'Observação',5),(5,'2025-10-20','Carlos Rocha',25,'Questionário Online',2);
/*!40000 ALTER TABLE `levantamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa`
--

DROP TABLE IF EXISTS `pessoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa` (
  `id_pessoa` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  `emprego` varchar(100) DEFAULT NULL,
  `nivel_escolaridade` varchar(100) DEFAULT NULL,
  `renda_individual` decimal(10,2) DEFAULT NULL,
  `parentesco_na_familia` varchar(100) DEFAULT NULL,
  `PDC` varchar(50) DEFAULT NULL,
  `id_familia` int DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`),
  KEY `id_familia` (`id_familia`),
  CONSTRAINT `pessoa_ibfk_1` FOREIGN KEY (`id_familia`) REFERENCES `familia` (`id_familia`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` VALUES (1,'Maria Conceição','1985-05-10','Feminino','Doméstica','Fundamental Incompleto',1500.00,'Chefe','Não',1),(2,'João da Silva','1970-12-01','Masculino','Desempregado','Ensino Médio',0.00,'Chefe','Não',2),(3,'Ana Lúcia','1995-02-25','Feminino','Analista de Sistemas','Superior Completo',7800.00,'Chefe','Não',3),(4,'Pedro Santos','1980-08-18','Masculino','Catador','Fundamental Completo',850.00,'Chefe','Sim',4),(5,'Luciana Lima','2000-04-05','Feminino','Vendedor','Ensino Médio',4100.00,'Chefe','Não',5);
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programa_social`
--

DROP TABLE IF EXISTS `programa_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programa_social` (
  `id_programa_social` int NOT NULL AUTO_INCREMENT,
  `nome_programa` varchar(100) DEFAULT NULL,
  `orgao_responsavel` varchar(100) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `publico_alvo` varchar(100) DEFAULT NULL,
  `id_instituicao` int DEFAULT NULL,
  PRIMARY KEY (`id_programa_social`),
  KEY `id_instituicao` (`id_instituicao`),
  CONSTRAINT `programa_social_ibfk_1` FOREIGN KEY (`id_instituicao`) REFERENCES `instituicao` (`id_instituicao`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programa_social`
--

LOCK TABLES `programa_social` WRITE;
/*!40000 ALTER TABLE `programa_social` DISABLE KEYS */;
INSERT INTO `programa_social` VALUES (1,'Bolsa Família Municipal','CRAS Central','Transferência de Renda','Famílias de Baixa Renda',1),(2,'Farmácia Comunitária','UBS Leste','Saúde','População Local',2),(3,'Reforço Escolar','ONG Saber Mais','Educação','Crianças e Adolescentes',3),(4,'Meu Primeiro Imóvel','Cohab Municipal','Moradia','Famílias sem Casa Própria',4),(5,'Cesta Básica Solidária','Banco de Alimentos','Alimentação','Famílias em Risco Alimentar',5);
/*!40000 ALTER TABLE `programa_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regiao`
--

DROP TABLE IF EXISTS `regiao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regiao` (
  `id_regiao` int NOT NULL AUTO_INCREMENT,
  `numero_habitantes` int DEFAULT NULL,
  `indice_desenvolvimento_local` decimal(5,2) DEFAULT NULL,
  `numero_equipamentos_publicos` int DEFAULT NULL,
  `nome_regiao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_regiao`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regiao`
--

LOCK TABLES `regiao` WRITE;
/*!40000 ALTER TABLE `regiao` DISABLE KEYS */;
INSERT INTO `regiao` VALUES (1,15000,0.85,12,'Centro'),(2,8500,0.62,5,'Periferia Leste'),(3,22000,0.78,18,'Zona Sul'),(4,5500,0.55,3,'Área Rural Norte'),(5,12500,0.91,25,'Bairro Nobre');
/*!40000 ALTER TABLE `regiao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `relatorio_basico`
--

DROP TABLE IF EXISTS `relatorio_basico`;
/*!50001 DROP VIEW IF EXISTS `relatorio_basico`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `relatorio_basico` AS SELECT 
 1 AS `chefe_familia`,
 1 AS `situacao_inseguranca_alimentar`,
 1 AS `nome_regiao`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nome_usuario` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `senha` varchar(100) DEFAULT NULL,
  `ativo` int DEFAULT NULL,
  `ultimo_login` datetime DEFAULT NULL,
  `perfil` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'ana_silva','ana@email.com','$2y$10$HASH1',1,'2025-11-20 10:30:00','Administrador'),(2,'carlos_rocha','carlos@email.com','$2y$10$HASH2',1,'2025-11-19 15:45:00','Pesquisador'),(3,'fernanda_adm','fernanda@email.com','$2y$10$HASH3',1,'2025-11-20 08:00:00','Administrador'),(4,'pedro_pesq','pedro@email.com','$2y$10$HASH4',0,NULL,'Pesquisador'),(5,'lucia_tec','lucia@email.com','$2y$10$HASH5',1,'2025-11-18 11:20:00','Técnico');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'projeto_insegurancaalimentar'
--

--
-- Dumping routines for database 'projeto_insegurancaalimentar'
--
/*!50003 DROP PROCEDURE IF EXISTS `inserir_familia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_familia`(
in p_situacao varchar(100),
in p_recebe_beneficio varchar(10),
in p_chefe varchar(100),
in p_id_domicilio int,
in p_id_indice int
)
begin 
	insert into familia (
		situacao_inseguranca_alimentar,
        recebe_beneficio,
        chefe_familia,
        id_domicilio,
        id_indice_inseguranca
    )
    values (
		p_situacao,
        p_recebe_beneficio,
        p_chefe,
        p_id_domicilio,
        p_id_indice
    );
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `domicilio_regiao`
--

/*!50001 DROP VIEW IF EXISTS `domicilio_regiao`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `domicilio_regiao` AS select `domicilio`.`id_domicilio` AS `id_domicilio`,`domicilio`.`tipo_domicilio` AS `tipo_domicilio`,`domicilio`.`numero_comodos` AS `numero_comodos`,`domicilio`.`renda_total_domiciliar` AS `renda_total_domiciliar`,`regiao`.`nome_regiao` AS `nome_regiao` from (`domicilio` join `regiao` on((`domicilio`.`id_regiao` = `regiao`.`id_regiao`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `relatorio_basico`
--

/*!50001 DROP VIEW IF EXISTS `relatorio_basico`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `relatorio_basico` AS select `familia`.`chefe_familia` AS `chefe_familia`,`familia`.`situacao_inseguranca_alimentar` AS `situacao_inseguranca_alimentar`,`regiao`.`nome_regiao` AS `nome_regiao` from ((`familia` join `domicilio` on((`familia`.`id_domicilio` = `domicilio`.`id_domicilio`))) join `regiao` on((`domicilio`.`id_regiao` = `regiao`.`id_regiao`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01 20:56:35
