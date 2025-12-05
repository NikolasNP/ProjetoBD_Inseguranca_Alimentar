-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: projeto_insegurancaalimentar
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

-- Dump completed on 2025-12-03 19:51:33
