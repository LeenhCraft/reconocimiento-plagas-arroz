-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 20-12-2024 a las 18:13:59
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_plagas_arroz`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_configuracion`
--

CREATE TABLE `re_configuracion` (
  `idconfig` int NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_configuracion`
--

INSERT INTO `re_configuracion` (`idconfig`, `nombre`, `valor`, `date`) VALUES
(2, 'valor', '{\"carpeta_img_entrenamiento\":\"img\\/entrenamiento\",\"ruta_datos_entrenamiento\":\"datos_entrenamiento\",\"nombre_datos_entrenamiento\":\"entrenamiento\",\"ruta_datos_generados\":\"json\\/\",\"nombre_modelo\":\"modelo-yolo-v5\",\"ruta_modelo\":\"modelo_entrenado\",\"epochs\":\"100\",\"batch_size\":\"32\",\"img_size\":\"640\",\"model_size\":\"n\",\"path_weights\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\models\\\\yolov5n.pt\",\"weights\":1,\"debug\":0,\"ruta_detecciones\":\"predicciones\"}', '2024-10-29 09:20:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_datos_generados`
--

CREATE TABLE `re_datos_generados` (
  `identrenamiento` int NOT NULL,
  `code` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stats` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `yaml` text COLLATE utf8mb4_unicode_ci,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `ent_default` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_datos_generados`
--

INSERT INTO `re_datos_generados` (`identrenamiento`, `code`, `stats`, `yaml`, `summary`, `ent_default`, `fecha_registro`) VALUES
(1, '20241201221605', '{\"train\":{\"total\":1600,\"by_class\":{\"Caracol manzana\":320,\"Falso medidor\":320,\"Sogata del arroz\":320,\"Gusano cogollero\":320,\"Gusano enrollador de la hoja\":320}},\"val\":{\"total\":400,\"by_class\":{\"Sogata del arroz\":80,\"Gusano enrollador de la hoja\":80,\"Falso medidor\":80,\"Caracol manzana\":80,\"Gusano cogollero\":80}},\"total_images\":2000,\"images_by_class\":{\"Caracol manzana\":400,\"Falso medidor\":400,\"Gusano cogollero\":400,\"Gusano enrollador de la hoja\":400,\"Sogata del arroz\":400}}', '{\"success\":true,\"yaml_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"config\":{\"path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\",\"train\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\train\\\\images\",\"val\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\val\\\\images\",\"nc\":5,\"names\":[\"Caracol manzana\",\"Falso medidor\",\"Gusano cogollero\",\"Gusano enrollador de la hoja\",\"Sogata del arroz\"]}}', '{\"total_processed\":2000,\"train_total\":1600,\"val_total\":400,\"errors_count\":0,\"processing_success_rate\":100}', 0, '2024-12-01 22:16:17'),
(2, '20241208232110', '{\"train\":{\"total\":1600,\"by_class\":{\"Gusano cogollero\":320,\"Caracol manzana\":320,\"Sogata del arroz\":320,\"Falso medidor\":320,\"Gusano enrollador de la hoja\":320}},\"val\":{\"total\":400,\"by_class\":{\"Gusano cogollero\":80,\"Gusano enrollador de la hoja\":80,\"Falso medidor\":80,\"Caracol manzana\":80,\"Sogata del arroz\":80}},\"total_images\":2000,\"images_by_class\":{\"Caracol manzana\":400,\"Falso medidor\":400,\"Gusano cogollero\":400,\"Gusano enrollador de la hoja\":400,\"Sogata del arroz\":400}}', '{\"success\":true,\"yaml_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\\\\data.yaml\",\"config\":{\"path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\",\"train\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\\\\train\\\\images\",\"val\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\\\\val\\\\images\",\"nc\":5,\"names\":[\"Caracol manzana\",\"Falso medidor\",\"Gusano cogollero\",\"Gusano enrollador de la hoja\",\"Sogata del arroz\"]}}', '{\"total_processed\":2000,\"train_total\":1600,\"val_total\":400,\"errors_count\":0,\"processing_success_rate\":100}', 1, '2024-12-08 23:21:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_detalle_modelo`
--

CREATE TABLE `re_detalle_modelo` (
  `id_detalle_modelo` int NOT NULL,
  `idmodelo` int NOT NULL,
  `identrenamiento` int NOT NULL,
  `det_ruta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `det_nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `det_precision` decimal(9,4) NOT NULL DEFAULT '0.0000',
  `det_default` tinyint(1) NOT NULL DEFAULT '0',
  `det_tiempo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `det_inicio` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `det_fin` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `det_salida` text COLLATE utf8mb4_unicode_ci,
  `det_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_detalle_modelo`
--

INSERT INTO `re_detalle_modelo` (`id_detalle_modelo`, `idmodelo`, `identrenamiento`, `det_ruta`, `det_nombre`, `det_precision`, `det_default`, `det_tiempo`, `det_inicio`, `det_fin`, `det_salida`, `det_fecha`) VALUES
(1, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241201_222639', 'modelo-yolo-v5_20241201_222639', 56.9794, 0, '00:17:45', '2024-12-01 22:26:39', '2024-12-01 22:44:24', '{\"success\":true,\"stats\":{\"final_epoch\":15,\"training_time\":\"00:16:03\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_222639\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_222639\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.5163360017413422,0.5697937047260605,0.5527937505096296,0.5327939135439825,0,0,0],\"recall\":[0.43147214446653726,0.4763822368108489,0.32843882055356866,0.7912945518080579,0.6363818140808994],\"mAP50\":[0.45567174592407267,0.48167439938528367,0.34982425211946255,0.8169279765937916,0.6598703785255373],\"mAP50_95\":[0.306154659816197,10.741701807294573,1.4527654647827148]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_222639\",\"epochs\":15,\"batch_size\":16,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-01 22:44:24'),
(2, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241201_231856', 'modelo-yolo-v5_20241201_231856', 56.9794, 0, '00:16:40', '2024-12-01 23:18:56', '2024-12-01 23:35:36', '{\"success\":true,\"stats\":{\"final_epoch\":15,\"training_time\":\"00:15:10\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_231856\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_231856\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.5163360017413422,0.5697937047260605,0.5527937505096296,0.5327939135439825,0,0,0],\"recall\":[0.43147214446653726,0.4763822368108489,0.32843882055356866,0.7912945518080579,0.6363818140808994],\"mAP50\":[0.45567174592407267,0.48167439938528367,0.34982425211946255,0.8169279765937916,0.6598703785255373],\"mAP50_95\":[0.3035259246826172,10.53058351789202,1.5439816883632116]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241201_231856\",\"epochs\":15,\"batch_size\":16,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-01 23:35:36'),
(3, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241202_004052', 'modelo-yolo-v5_20241202_004052', 80.1794, 0, '00:28:47', '2024-12-02 00:40:52', '2024-12-02 01:09:39', '{\"success\":true,\"stats\":{\"final_epoch\":30,\"training_time\":\"00:27:11\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_004052\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_004052\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.8017942821855932,0.6313938252750158,0.6800196521096521,0.6724652754390735,0,0,0],\"recall\":[0.5389344354189399,0.6642021851614414,0.6096522719321225,0.8512936519879271,0.6982438326949365],\"mAP50\":[0.5403130029370211,0.6764308109680928,0.6226522029623022,0.8571649581241566,0.7035372855566878],\"mAP50_95\":[0.305239132472447,10.364857401166644,1.6076231002807617]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_004052\",\"epochs\":30,\"batch_size\":16,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-02 01:09:39'),
(4, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241202_080705', 'modelo-yolo-v5_20241202_080705', 81.6234, 0, '00:26:45', '2024-12-02 08:07:05', '2024-12-02 08:33:50', '{\"success\":true,\"stats\":{\"final_epoch\":30,\"training_time\":\"00:25:21\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.8162337211343956,0.6485899390533696,0.683337734676083,0.6724936487705893,0,0,0],\"recall\":[0.5352547311381005,0.7089521370879139,0.5745172444502499,0.8486590887179604,0.695085042458721],\"mAP50\":[0.5423256358388788,0.7134209794517421,0.5784365237202451,0.8791716237068061,0.7033339106627432],\"mAP50_95\":[0.2748032978602818,10.117483139038086,1.442976679120745]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\",\"epochs\":30,\"batch_size\":16,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-02 08:33:50'),
(5, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241205_152855', 'modelo-yolo-v5_20241205_152855', 87.6367, 0, '01:20:59', '2024-12-05 15:28:55', '2024-12-05 16:49:54', '{\"success\":true,\"stats\":{\"final_epoch\":100,\"training_time\":\"01:19:21\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241205_152855\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241205_152855\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.8763671730131655,0.7534892304001244,0.8029204647696881,0.8000032085201975,0,0,0],\"recall\":[0.6208822785555312,0.7787556502054382,0.7204159723100174,0.9689924035591986,0.9109697379708017],\"mAP50\":[0.6208822785555312,0.7883870129341418,0.7253708908287675,0.9689924035591986,0.9109697379708015],\"mAP50_95\":[0.3928313936505999,9.838895797729492,1.8572201047624861]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241205_152855\",\"epochs\":100,\"batch_size\":32,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-05 16:49:54'),
(6, 1, 2, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241219_221114', 'modelo-yolo-v5_20241219_221114', 86.4600, 0, '01:59:36', '2024-12-19 22:11:14', '2024-12-20 00:10:50', '{\"success\":true,\"stats\":{\"final_epoch\":100,\"training_time\":\"01:58:15\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241219_221114\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241219_221114\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.864600172843493,0.6519547687145784,0.699593511234559,0.5345517602350552,0,0,0],\"recall\":[0.31450494567833387,0.666057870315058,0.44708140007651015,0.5984420678996488,0.6466725172057254],\"mAP50\":[0.4657116559667879,0.7925355994916327,0.6975533213105813,0.7424195434552704,0.7997474359485232],\"mAP50_95\":[0.24187564849853516,9.182456731796265,1.093430519104004]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241219_221114\",\"epochs\":100,\"batch_size\":32,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-20 00:10:50'),
(7, 1, 2, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241220_100607', 'modelo-yolo-v5_20241220_100607', 94.1695, 1, '02:51:06', '2024-12-20 10:06:07', '2024-12-20 12:57:13', '{\"success\":true,\"stats\":{\"final_epoch\":100,\"training_time\":\"02:49:23\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241220_100607\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241220_100607\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.9416952938386671,0.6871431672400442,0.737803883634835,0.5668206089409376,0,0,0],\"recall\":[0.3124791468223567,0.6625569848668011,0.43032881035072645,0.7835498363140125,0.6451882663507909],\"mAP50\":[0.48491743398309295,0.7906405177742394,0.6678547900658238,0.9252081322600021,0.8203985440910166],\"mAP50_95\":[0.2749931812286377,9.870077967643738,1.110355257987976]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241208232110\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241220_100607\",\"epochs\":100,\"batch_size\":32,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-20 12:57:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_enfermedades`
--

CREATE TABLE `re_enfermedades` (
  `idenfermedad` int NOT NULL,
  `nombre_cientifico` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `desactivado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_enfermedades`
--

INSERT INTO `re_enfermedades` (`idenfermedad`, `nombre_cientifico`, `nombre`, `slug`, `imagen_url`, `descripcion`, `desactivado`, `fecha_registro`) VALUES
(6, 'Cnaphalocrocis medinalis (Lepidoptera: Crambinae', 'Gusano enrollador de la hoja', 'gusano-enrollador-de-la-hoja', '/img/plagas/gusano-enrollador-de-la-hoja.jpg', '<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)</p>', 0, '2024-11-02 15:05:37'),
(7, 'Pomacea canaliculata (Gastropoda: Ampullariidae)', 'Caracol manzana', 'caracol-manzana', '/img/plagas/caracol-manzana.jpeg', '', 0, '2024-11-02 15:06:33'),
(8, 'Mocis latipes (Lepidoptera: Erebidae)', 'Falso medidor', 'falso-medidor', '/img/plagas/falso-medidor.jpeg', '', 0, '2024-11-02 15:06:40'),
(9, 'Spodoptera frugiperda (Lepidoptera: Noctuidae)', 'Gusano cogollero', 'gusano-cogollero', '/img/plagas/gusano-cogollero.jpg', '', 0, '2024-11-02 15:06:45'),
(10, 'Tagosodes orizicolus (Homoptera: Delphacidae)', 'Sogata del arroz', 'sogata-del-arroz', '/img/plagas/sogata-del-arroz.png', '', 0, '2024-11-02 15:06:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_historial_identificacion`
--

CREATE TABLE `re_historial_identificacion` (
  `idhistorial` int NOT NULL,
  `id_detalle_modelo` int NOT NULL,
  `idusuario` int NOT NULL DEFAULT '0',
  `his_img` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `his_tiempo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `his_inicio` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `his_fin` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `his_index` int NOT NULL,
  `his_prediccion` text COLLATE utf8mb4_unicode_ci,
  `his_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_historial_identificacion`
--

INSERT INTO `re_historial_identificacion` (`idhistorial`, `id_detalle_modelo`, `idusuario`, `his_img`, `his_tiempo`, `his_inicio`, `his_fin`, `his_index`, `his_prediccion`, `his_fecha`) VALUES
(1, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e0555451162.05552492\\/enrrollador-de-la-hoja-6724099308500.jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.8570408225059509,\"bbox\":{\"x1\":2,\"y1\":0,\"x2\":498,\"y2\":374},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\"}}],\"timestamp\":\"2024-12-02T14:07:16.222021\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.8570408225059509},\"output_dir\":\"predicciones\\/20241202140701\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 14:07:17'),
(2, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e3edb22c554.56688513\\/download (73).jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.3578399419784546,\"bbox\":{\"x1\":0,\"y1\":11,\"x2\":1024,\"y2\":782},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\"}},{\"class\":\"Gusano cogollero\",\"confidence\":0.3561653792858124,\"bbox\":{\"x1\":0,\"y1\":13,\"x2\":1024,\"y2\":786},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\"}}],\"timestamp\":\"2024-12-02T18:12:42.818812\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Falso medidor\":1,\"Gusano cogollero\":1},\"average_confidence\":0.3570026606321335},\"output_dir\":\"predicciones\\/20241202181227\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 18:12:43'),
(3, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e3f91de9741.51297279\\/download (192).jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.6768941879272461,\"bbox\":{\"x1\":0,\"y1\":0,\"x2\":1024,\"y2\":965},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\"}}],\"timestamp\":\"2024-12-02T18:15:44.447000\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Falso medidor\":1},\"average_confidence\":0.6768941879272461},\"output_dir\":\"predicciones\\/20241202181529\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 18:15:45'),
(4, 4, 1, '', '17s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e40b4cf9720.30605400\\/TG9666_Spodoptera_frugiperda1.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.4539601504802704,\"bbox\":{\"x1\":0,\"y1\":1,\"x2\":300,\"y2\":224},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\"}}],\"timestamp\":\"2024-12-02T18:20:36.076755\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.4539601504802704},\"output_dir\":\"predicciones\\/20241202182020\",\"execution_time\":\"17s\",\"idmodelo\":4}', '2024-12-02 18:20:37'),
(5, 4, 1, '', '15s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e41892d59c8.63131369\\/TG9666_Spodoptera_frugiperda1.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.4539601504802704,\"bbox\":{\"x1\":0,\"y1\":1,\"x2\":300,\"y2\":224},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\"}}],\"timestamp\":\"2024-12-02T18:24:07.627748\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.4539601504802704},\"output_dir\":\"predicciones\\/20241202182353\",\"execution_time\":\"15s\",\"idmodelo\":4}', '2024-12-02 18:24:08'),
(6, 4, 1, '', '17s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e4480efd664.71281616\\/TG9666_Spodoptera_frugiperda1.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.4539601504802704,\"bbox\":{\"x1\":0,\"y1\":1,\"x2\":300,\"y2\":224},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\"}}],\"timestamp\":\"2024-12-02T18:36:48.365394\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.4539601504802704},\"output_dir\":\"predicciones\\/20241202183632\",\"execution_time\":\"17s\",\"idmodelo\":4}', '2024-12-02 18:36:49'),
(7, 4, 1, '', '15s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e449e664507.17613637\\/TG9666_Spodoptera_frugiperda1.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.4539601504802704,\"bbox\":{\"x1\":0,\"y1\":1,\"x2\":300,\"y2\":224},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\"}}],\"timestamp\":\"2024-12-02T18:37:16.508898\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.4539601504802704},\"output_dir\":\"predicciones\\/20241202183702\",\"execution_time\":\"15s\",\"idmodelo\":4}', '2024-12-02 18:37:17'),
(8, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e4a8e851f56.71026344\\/download (1).jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.9209484457969666,\"bbox\":{\"x1\":16,\"y1\":0,\"x2\":1010,\"y2\":673},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\"}}],\"timestamp\":\"2024-12-02T19:02:37.117387\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.9209484457969666},\"output_dir\":\"predicciones\\/20241202190222\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 19:02:38'),
(9, 4, 1, '', '17s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e4c32561ca7.90559643\\/download (1).jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.9209484457969666,\"bbox\":{\"x1\":16,\"y1\":0,\"x2\":1010,\"y2\":673},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\"}}],\"timestamp\":\"2024-12-02T19:09:38.242892\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.9209484457969666},\"output_dir\":\"predicciones\\/20241202190922\",\"execution_time\":\"17s\",\"idmodelo\":4}', '2024-12-02 19:09:39'),
(10, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e4dc139df58.19741567\\/download (1).jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.9209484457969666,\"bbox\":{\"x1\":16,\"y1\":0,\"x2\":1010,\"y2\":673},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\",\"nombre_cientifico\":\"Cnaphalocrocis medinalis (Lepidoptera: Crambinae\"}}],\"timestamp\":\"2024-12-02T19:16:16.803338\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.9209484457969666},\"output_dir\":\"predicciones\\/20241202191601\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 19:16:17'),
(11, 4, 1, '', '20s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674fe9ede2a9c2.50610960\\/download - 2024-11-06T095229.078.jpg\",\"detections\":[{\"class\":\"Caracol manzana\",\"confidence\":0.8995388150215149,\"bbox\":{\"x1\":11,\"y1\":0,\"x2\":571,\"y2\":1015},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}}],\"timestamp\":\"2024-12-04T00:34:56.296827\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Caracol manzana\":1},\"average_confidence\":0.8995388150215149},\"output_dir\":\"predicciones\\/20241204003437\",\"execution_time\":\"20s\",\"idmodelo\":4}', '2024-12-04 00:34:57'),
(12, 6, 1, '', '12s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd06bd87e2.97310512\\/caracol-manzana-0001.jpg\",\"detections\":[{\"class\":\"Caracol manzana\",\"confidence\":0.9279829859733582,\"bbox\":{\"x1\":1345,\"y1\":373,\"x2\":1597,\"y2\":571},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}},{\"class\":\"Caracol manzana\",\"confidence\":0.8976308107376099,\"bbox\":{\"x1\":280,\"y1\":777,\"x2\":458,\"y2\":971},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}}],\"timestamp\":\"2024-12-20T00:13:53.334405\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Caracol manzana\":2},\"average_confidence\":0.912806898355484},\"output_dir\":\"predicciones\\/20241220001342\",\"execution_time\":\"12s\",\"idmodelo\":6}', '2024-12-20 00:13:54'),
(13, 6, 1, '', '9s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd1a4acbc3.91813576\\/caracol-manzana-0017.jpg\",\"detections\":[{\"class\":\"Caracol manzana\",\"confidence\":0.9566436409950256,\"bbox\":{\"x1\":138,\"y1\":343,\"x2\":634,\"y2\":787},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}}],\"timestamp\":\"2024-12-20T00:14:11.353794\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Caracol manzana\":1},\"average_confidence\":0.9566436409950256},\"output_dir\":\"predicciones\\/20241220001402\",\"execution_time\":\"9s\",\"idmodelo\":6}', '2024-12-20 00:14:11'),
(14, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd2e814cc6.93141252\\/caracol-manzana-0051.jpg\",\"detections\":[{\"class\":\"Caracol manzana\",\"confidence\":0.9196942448616028,\"bbox\":{\"x1\":206,\"y1\":333,\"x2\":705,\"y2\":707},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}},{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.35605600476264954,\"bbox\":{\"x1\":533,\"y1\":0,\"x2\":764,\"y2\":47},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\",\"nombre_cientifico\":\"Cnaphalocrocis medinalis (Lepidoptera: Crambinae\"}}],\"timestamp\":\"2024-12-20T00:14:31.538240\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Caracol manzana\":1,\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.6378751248121262},\"output_dir\":\"predicciones\\/20241220001422\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:14:32'),
(15, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd4a4d7391.39634352\\/falso-medidor-0004.jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.8721069693565369,\"bbox\":{\"x1\":183,\"y1\":451,\"x2\":605,\"y2\":590},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\",\"nombre_cientifico\":\"Mocis latipes (Lepidoptera: Erebidae)\"}}],\"timestamp\":\"2024-12-20T00:14:59.973978\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Falso medidor\":1},\"average_confidence\":0.8721069693565369},\"output_dir\":\"predicciones\\/20241220001450\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:15:00'),
(16, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd5edaff62.51552861\\/falso-medidor-0055.jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.7736831307411194,\"bbox\":{\"x1\":206,\"y1\":207,\"x2\":716,\"y2\":664},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\",\"nombre_cientifico\":\"Mocis latipes (Lepidoptera: Erebidae)\"}}],\"timestamp\":\"2024-12-20T00:15:20.369105\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Falso medidor\":1},\"average_confidence\":0.7736831307411194},\"output_dir\":\"predicciones\\/20241220001510\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:15:21'),
(17, 6, 1, '', '9s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd721a5a32.52735589\\/falso-medidor-0166.jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.950247585773468,\"bbox\":{\"x1\":369,\"y1\":357,\"x2\":608,\"y2\":648},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\",\"nombre_cientifico\":\"Mocis latipes (Lepidoptera: Erebidae)\"}}],\"timestamp\":\"2024-12-20T00:15:39.304729\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Falso medidor\":1},\"average_confidence\":0.950247585773468},\"output_dir\":\"predicciones\\/20241220001530\",\"execution_time\":\"9s\",\"idmodelo\":6}', '2024-12-20 00:15:39'),
(18, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fd9379c054.87259198\\/falso-medidor-0393.jpg\",\"detections\":[],\"timestamp\":\"2024-12-20T00:16:13.154389\",\"summary\":{\"total_detections\":0,\"classes_detected\":[],\"average_confidence\":0},\"output_dir\":\"predicciones\\/20241220001603\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:16:13'),
(19, 6, 1, '', '9s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fda71ed501.11199053\\/falso-medidor-0392.jpg\",\"detections\":[{\"class\":\"Falso medidor\",\"confidence\":0.8746659755706787,\"bbox\":{\"x1\":373,\"y1\":579,\"x2\":580,\"y2\":705},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/falso-medidor\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/falso-medidor.jpeg\",\"nombre_cientifico\":\"Mocis latipes (Lepidoptera: Erebidae)\"}},{\"class\":\"Sogata del arroz\",\"confidence\":0.42140254378318787,\"bbox\":{\"x1\":459,\"y1\":140,\"x2\":516,\"y2\":212},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:16:32.156500\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Falso medidor\":1,\"Sogata del arroz\":1},\"average_confidence\":0.6480342596769333},\"output_dir\":\"predicciones\\/20241220001623\",\"execution_time\":\"9s\",\"idmodelo\":6}', '2024-12-20 00:16:32'),
(20, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fdbe287201.85534414\\/gusano-cogollero-0001.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.8531612753868103,\"bbox\":{\"x1\":2,\"y1\":3,\"x2\":300,\"y2\":186},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\",\"nombre_cientifico\":\"Spodoptera frugiperda (Lepidoptera: Noctuidae)\"}}],\"timestamp\":\"2024-12-20T00:16:55.520456\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.8531612753868103},\"output_dir\":\"predicciones\\/20241220001646\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:16:56'),
(21, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fdd36defb6.83924716\\/gusano-cogollero-0055.jpg\",\"detections\":[{\"class\":\"Gusano cogollero\",\"confidence\":0.8611892461776733,\"bbox\":{\"x1\":453,\"y1\":185,\"x2\":624,\"y2\":560},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-cogollero\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-cogollero.jpg\",\"nombre_cientifico\":\"Spodoptera frugiperda (Lepidoptera: Noctuidae)\"}}],\"timestamp\":\"2024-12-20T00:17:17.200435\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano cogollero\":1},\"average_confidence\":0.8611892461776733},\"output_dir\":\"predicciones\\/20241220001707\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:17:17'),
(22, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fde7c14f11.16197129\\/gusano-enrollador-de-la-hoja-0007.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9387994408607483,\"bbox\":{\"x1\":122,\"y1\":230,\"x2\":367,\"y2\":403},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}},{\"class\":\"Sogata del arroz\",\"confidence\":0.9360587000846863,\"bbox\":{\"x1\":493,\"y1\":243,\"x2\":710,\"y2\":402},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}},{\"class\":\"Sogata del arroz\",\"confidence\":0.9009432792663574,\"bbox\":{\"x1\":822,\"y1\":209,\"x2\":1020,\"y2\":419},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:17:37.126420\",\"summary\":{\"total_detections\":3,\"classes_detected\":{\"Sogata del arroz\":3},\"average_confidence\":0.9252671400705973},\"output_dir\":\"predicciones\\/20241220001727\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:17:37'),
(23, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fdfe0ca167.30154574\\/gusano-enrollador-de-la-hoja-0020.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9376266598701477,\"bbox\":{\"x1\":192,\"y1\":167,\"x2\":784,\"y2\":560},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:17:59.568301\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.9376266598701477},\"output_dir\":\"predicciones\\/20241220001750\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:18:00'),
(24, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fe161db492.92356526\\/sogata-del-arroz-0001.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9436200261116028,\"bbox\":{\"x1\":212,\"y1\":366,\"x2\":495,\"y2\":595},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:18:23.819928\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.9436200261116028},\"output_dir\":\"predicciones\\/20241220001814\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:18:24'),
(25, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fe2f960704.96269275\\/gusano-enrollador-de-la-hoja-0001.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9439112544059753,\"bbox\":{\"x1\":413,\"y1\":282,\"x2\":755,\"y2\":544},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:18:48.874940\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.9439112544059753},\"output_dir\":\"predicciones\\/20241220001839\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:18:49'),
(26, 6, 1, '', '9s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fe4d6f8f35.08741670\\/gusano-enrollador-de-la-hoja-0002.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.8256851434707642,\"bbox\":{\"x1\":222,\"y1\":124,\"x2\":875,\"y2\":846},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:19:18.394577\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.8256851434707642},\"output_dir\":\"predicciones\\/20241220001909\",\"execution_time\":\"9s\",\"idmodelo\":6}', '2024-12-20 00:19:18'),
(27, 6, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6764fe767864f4.39372387\\/gusano-enrollador-de-la-hoja-0037.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.8641002178192139,\"bbox\":{\"x1\":109,\"y1\":35,\"x2\":759,\"y2\":627},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}},{\"class\":\"Sogata del arroz\",\"confidence\":0.16942653059959412,\"bbox\":{\"x1\":433,\"y1\":210,\"x2\":760,\"y2\":611},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T00:19:59.987595\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Sogata del arroz\":2},\"average_confidence\":0.516763374209404},\"output_dir\":\"predicciones\\/20241220001950\",\"execution_time\":\"10s\",\"idmodelo\":6}', '2024-12-20 00:20:00'),
(28, 7, 1, '', '13s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6765b359801ac3.06494014\\/gusano-enrollador-de-la-hoja-0001.jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.9627386927604675,\"bbox\":{\"x1\":413,\"y1\":286,\"x2\":750,\"y2\":544},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\",\"nombre_cientifico\":\"Cnaphalocrocis medinalis (Lepidoptera: Crambinae\"}}],\"timestamp\":\"2024-12-20T13:11:49.350360\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.9627386927604675},\"output_dir\":\"predicciones\\/20241220131137\",\"execution_time\":\"13s\",\"idmodelo\":7}', '2024-12-20 13:11:50'),
(29, 7, 1, '', '10s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6765b37a8e7ba3.95206774\\/gusano-enrollador-de-la-hoja-0035.jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.9425876140594482,\"bbox\":{\"x1\":431,\"y1\":313,\"x2\":618,\"y2\":512},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\",\"nombre_cientifico\":\"Cnaphalocrocis medinalis (Lepidoptera: Crambinae\"}},{\"class\":\"Caracol manzana\",\"confidence\":0.2454744577407837,\"bbox\":{\"x1\":335,\"y1\":646,\"x2\":799,\"y2\":1017},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/caracol-manzana\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/caracol-manzana.jpeg\",\"nombre_cientifico\":\"Pomacea canaliculata (Gastropoda: Ampullariidae)\"}}],\"timestamp\":\"2024-12-20T13:12:20.268961\",\"summary\":{\"total_detections\":2,\"classes_detected\":{\"Gusano enrollador de la hoja\":1,\"Caracol manzana\":1},\"average_confidence\":0.594031035900116},\"output_dir\":\"predicciones\\/20241220131210\",\"execution_time\":\"10s\",\"idmodelo\":7}', '2024-12-20 13:12:20'),
(30, 7, 1, '', '11s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6765b39849ba13.76786606\\/sogata-del-arroz-0001.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9468782544136047,\"bbox\":{\"x1\":204,\"y1\":375,\"x2\":494,\"y2\":595},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T13:12:50.613697\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.9468782544136047},\"output_dir\":\"predicciones\\/20241220131240\",\"execution_time\":\"11s\",\"idmodelo\":7}', '2024-12-20 13:12:51'),
(31, 7, 1, '', '11s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_6765b3b36bb905.36600439\\/sogata-del-arroz-0018.jpg\",\"detections\":[{\"class\":\"Sogata del arroz\",\"confidence\":0.9166736006736755,\"bbox\":{\"x1\":444,\"y1\":279,\"x2\":639,\"y2\":375},\"additional_info\":{\"description\":\"\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/sogata-del-arroz\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/sogata-del-arroz.png\",\"nombre_cientifico\":\"Tagosodes orizicolus (Homoptera: Delphacidae)\"}}],\"timestamp\":\"2024-12-20T13:13:17.642402\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Sogata del arroz\":1},\"average_confidence\":0.9166736006736755},\"output_dir\":\"predicciones\\/20241220131307\",\"execution_time\":\"11s\",\"idmodelo\":7}', '2024-12-20 13:13:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_modelo`
--

CREATE TABLE `re_modelo` (
  `idmodelo` int NOT NULL,
  `mo_nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_clasificador` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_descriptor` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_default` tinyint(1) NOT NULL DEFAULT '0',
  `mo_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `re_modelo`
--

INSERT INTO `re_modelo` (`idmodelo`, `mo_nombre`, `mo_clasificador`, `mo_descriptor`, `mo_default`, `mo_fecha`) VALUES
(1, 'YOLOv5', 'YOLO', 'YOLO', 1, '2024-11-12 10:44:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_centinela`
--

CREATE TABLE `sis_centinela` (
  `idcentinela` int NOT NULL,
  `codigo` int NOT NULL,
  `ip` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `agente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_centinela`
--

INSERT INTO `sis_centinela` (`idcentinela`, `codigo`, `ip`, `agente`, `method`, `url`, `fecha_registro`) VALUES
(10596, 2596, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 14:16:48'),
(10597, 2308, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:09:21'),
(10598, 5923, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:11:10'),
(10599, 2358, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:11:11'),
(10600, 9080, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:11:39'),
(10601, 3463, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:11:39'),
(10602, 9586, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:12:01'),
(10603, 5097, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:12:01'),
(10604, 8024, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:12:47'),
(10605, 1234, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:12:47'),
(10606, 6678, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:12:57'),
(10607, 2524, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:12:57'),
(10608, 3151, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:29:00'),
(10609, 1640, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:29:02'),
(10610, 3564, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:29:40'),
(10611, 4643, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:29:40'),
(10612, 8324, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:29:57'),
(10613, 8206, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:29:57'),
(10614, 3032, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 17:30:22'),
(10615, 2133, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 17:30:22'),
(10616, 1657, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:12:03'),
(10617, 2692, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:12:05'),
(10618, 2262, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:12:27'),
(10619, 9834, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:14:46'),
(10620, 7666, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:14:46'),
(10621, 2356, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:15:29'),
(10622, 1752, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:16:00'),
(10623, 7388, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:16:01'),
(10624, 6744, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:16:21'),
(10625, 1899, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:16:22'),
(10626, 1952, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:18:59'),
(10627, 3228, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:18:59'),
(10628, 1045, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:19:42'),
(10629, 4331, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:19:42'),
(10630, 7757, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:20:01'),
(10631, 6295, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:20:02'),
(10632, 6528, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:20:20'),
(10633, 8928, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:21:42'),
(10634, 3570, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:21:42'),
(10635, 6351, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:23:38'),
(10636, 4833, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:23:38'),
(10637, 6339, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:23:53'),
(10638, 6563, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/5', '2024-12-02 18:24:24'),
(10639, 2580, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 18:36:27'),
(10640, 8206, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 18:36:27'),
(10641, 3475, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:36:32'),
(10642, 9446, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/6', '2024-12-02 18:36:53'),
(10643, 7858, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 18:37:02'),
(10644, 6042, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:37:24'),
(10645, 2057, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:37:24'),
(10646, 2261, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:37:24'),
(10647, 3283, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:38:24'),
(10648, 6127, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:38:24'),
(10649, 6256, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:38:24'),
(10650, 7479, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:38:55'),
(10651, 4305, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:38:55'),
(10652, 6041, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:38:55'),
(10653, 3031, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:39:25'),
(10654, 9421, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:39:25'),
(10655, 4674, ' IP: 127.0.0.1', 'No existe', 'GET', '/logo.png', '2024-12-02 18:39:25'),
(10656, 7315, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:41:55'),
(10657, 3963, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:42:20'),
(10658, 7562, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:43:44'),
(10659, 5154, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:47:19'),
(10660, 1446, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:48:21'),
(10661, 4052, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:48:49'),
(10662, 8714, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:49:49'),
(10663, 5336, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:50:25'),
(10664, 1278, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:51:24'),
(10665, 7879, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:52:41'),
(10666, 6816, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:54:35'),
(10667, 8768, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:55:06'),
(10668, 9459, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:56:13'),
(10669, 9133, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:56:30'),
(10670, 3644, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:57:30'),
(10671, 9693, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:58:11'),
(10672, 2017, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 18:58:30'),
(10673, 6896, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/7', '2024-12-02 19:01:56'),
(10674, 3051, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 19:02:16'),
(10675, 1366, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 19:02:17'),
(10676, 7337, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 19:02:22'),
(10677, 8229, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/8', '2024-12-02 19:02:42'),
(10678, 7824, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/8', '2024-12-02 19:03:04'),
(10679, 5411, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/8', '2024-12-02 19:05:52'),
(10680, 3851, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/gusano-enrollador-de-la-hoja', '2024-12-02 19:07:03'),
(10681, 6620, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-02 19:07:09'),
(10682, 2752, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/sogata-del-arroz', '2024-12-02 19:07:13'),
(10683, 7041, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/search', '2024-12-02 19:07:14'),
(10684, 6617, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-02 19:07:17'),
(10685, 3146, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 19:09:20'),
(10686, 6518, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 19:09:22'),
(10687, 3062, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 19:15:54'),
(10688, 8031, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 19:15:55'),
(10689, 8984, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-02 19:16:01'),
(10690, 2671, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 19:16:36'),
(10691, 9414, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 22:28:17'),
(10692, 5700, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-02 22:28:21'),
(10693, 1226, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 22:29:22'),
(10694, 9855, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 22:30:27'),
(10695, 8127, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 22:30:49'),
(10696, 9555, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion/pdf/10', '2024-12-02 22:30:55'),
(10697, 3339, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-02 22:31:46'),
(10698, 8425, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/logout', '2024-12-02 22:36:13'),
(10699, 5791, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-02 22:36:13'),
(10700, 2256, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-03 20:09:06'),
(10701, 8727, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-03 20:09:08'),
(10702, 1223, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-03 20:09:10'),
(10703, 2815, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-03 20:09:10'),
(10704, 1455, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-03 20:09:12'),
(10705, 2614, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733274552816', '2024-12-03 20:09:13'),
(10706, 7620, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-03 23:46:45'),
(10707, 6976, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-03 23:48:19'),
(10708, 8967, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-03 23:48:20'),
(10709, 6832, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-03 23:48:20'),
(10710, 2887, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-04 00:25:31'),
(10711, 7736, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733289932976', '2024-12-04 00:25:33'),
(10712, 8779, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-04 00:30:20'),
(10713, 7125, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-04 00:30:21'),
(10714, 8994, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-04 00:31:08'),
(10715, 7634, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-04 00:31:09'),
(10716, 7418, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/save', '2024-12-04 00:31:14'),
(10717, 1121, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-04 00:31:17'),
(10718, 6811, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/save', '2024-12-04 00:31:21'),
(10719, 5121, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-04 00:31:24'),
(10720, 3650, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/save', '2024-12-04 00:31:29'),
(10721, 5958, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/sogata-del-arroz', '2024-12-04 00:31:42'),
(10722, 2209, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-04 00:31:44'),
(10723, 2721, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/upload', '2024-12-04 00:31:55'),
(10724, 4608, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-04 00:31:56'),
(10725, 6173, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/upload', '2024-12-04 00:32:20'),
(10726, 7514, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-04 00:32:20'),
(10727, 1477, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/destroy', '2024-12-04 00:33:51'),
(10728, 7520, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-04 00:33:51'),
(10729, 9874, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/destroy', '2024-12-04 00:33:53'),
(10730, 4933, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-04 00:33:53'),
(10731, 4605, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-04 00:33:57'),
(10732, 5401, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-04 00:34:37'),
(10733, 4996, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-04 01:40:49'),
(10734, 4426, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733294449796', '2024-12-04 01:40:49'),
(10735, 8232, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-04 01:44:27'),
(10736, 8970, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-04 01:44:28'),
(10737, 8792, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-04 01:44:31'),
(10738, 6160, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733294671321', '2024-12-04 01:44:31'),
(10739, 8166, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/logout', '2024-12-04 01:49:11'),
(10740, 6315, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-04 01:49:11'),
(10741, 7734, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-05 15:27:26'),
(10742, 9516, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-05 15:27:28'),
(10743, 4704, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-05 15:27:30'),
(10744, 5622, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-05 15:27:30'),
(10745, 2526, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-05 15:27:32'),
(10746, 8105, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733430452636', '2024-12-05 15:27:32'),
(10747, 8858, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/entrenar/configurar', '2024-12-05 15:27:57'),
(10748, 5765, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-05 15:28:02'),
(10749, 8664, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733430482845', '2024-12-05 15:28:03'),
(10750, 1061, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/entrenar', '2024-12-05 15:28:55'),
(10751, 6097, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733430482846', '2024-12-05 16:49:54'),
(10752, 7616, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-05 17:17:34'),
(10753, 1371, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-05 17:17:34'),
(10754, 2160, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-05 17:17:36'),
(10755, 3413, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1733437056832', '2024-12-05 17:17:37'),
(10756, 8876, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-07 12:46:24'),
(10757, 2007, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-08 17:52:49'),
(10758, 3881, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-08 17:52:51'),
(10759, 7644, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-08 17:52:53'),
(10760, 3395, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-08 17:52:53'),
(10761, 4766, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-08 17:52:56'),
(10762, 2502, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/caracol-manzana', '2024-12-08 17:52:58'),
(10763, 2186, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 17:53:00'),
(10764, 6398, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 17:54:39'),
(10765, 6863, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/dropzone-min.js.map', '2024-12-08 17:54:41'),
(10766, 2257, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-08 17:54:41'),
(10767, 3941, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/upload', '2024-12-08 17:54:50'),
(10768, 4904, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 17:54:50'),
(10769, 3512, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:16:14'),
(10770, 3317, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:16:48'),
(10771, 2888, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:16:54'),
(10772, 2763, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:16:58'),
(10773, 8005, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:17:14'),
(10774, 9097, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:18:18'),
(10775, 3038, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:18:26'),
(10776, 6982, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:24:55'),
(10777, 2610, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:26:38'),
(10778, 7225, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:27:27'),
(10779, 2668, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:29:23'),
(10780, 6858, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:31:43'),
(10781, 2042, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:32:01'),
(10782, 6979, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:32:49'),
(10783, 3493, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:33:07'),
(10784, 8690, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:33:29'),
(10785, 4941, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/escanear', '2024-12-08 19:33:45'),
(10786, 6603, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-08 20:51:14'),
(10787, 8398, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/js/popper.min.js.map', '2024-12-08 20:51:16'),
(10788, 1778, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/caracol-manzana', '2024-12-08 20:51:18'),
(10789, 6780, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 20:51:20'),
(10790, 3176, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/upload', '2024-12-08 20:58:31'),
(10791, 5018, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 20:58:31'),
(10792, 6699, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/destroy', '2024-12-08 20:59:00'),
(10793, 4072, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 20:59:00'),
(10794, 2815, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/upload', '2024-12-08 20:59:04'),
(10795, 1888, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 20:59:05'),
(10796, 3085, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/caracol-manzana', '2024-12-08 23:04:50'),
(10797, 6521, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas', '2024-12-08 23:05:01'),
(10798, 5799, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/plagas/sogata-del-arroz', '2024-12-08 23:05:02'),
(10799, 9776, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/plagas/view', '2024-12-08 23:05:04'),
(10800, 2798, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:09:27'),
(10801, 8250, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:09:38'),
(10802, 8276, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:09:56'),
(10803, 2047, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:10:12'),
(10804, 5332, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:11:12'),
(10805, 7495, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:12:35'),
(10806, 1993, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:13:44'),
(10807, 3169, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:14:15'),
(10808, 9471, ' IP: 127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:14:55'),
(10809, 9883, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:15:09'),
(10810, 9948, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:17:10'),
(10811, 2138, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:17:17'),
(10812, 8929, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/match', '2024-12-08 23:17:34'),
(10813, 3799, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/', '2024-12-08 23:21:00'),
(10814, 9601, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-08 23:21:04'),
(10815, 8731, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-08 23:21:06'),
(10816, 3207, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-08 23:21:07'),
(10817, 9431, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/datos/generar', '2024-12-08 23:21:10'),
(10818, 5370, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-08 23:21:16'),
(10819, 1245, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-08 23:57:25'),
(10820, 9696, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-08 23:57:26'),
(10821, 7360, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-09 18:35:10'),
(10822, 2857, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-09 18:35:14'),
(10823, 9226, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-09 18:35:16'),
(10824, 4486, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-09 18:35:16'),
(10825, 6804, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/logout', '2024-12-09 18:38:08'),
(10826, 3286, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/login', '2024-12-09 18:38:08'),
(10827, 1475, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-17 15:00:33'),
(10828, 7028, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-17 15:01:05'),
(10829, 1588, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-17 15:01:07'),
(10830, 6438, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-17 15:01:07'),
(10831, 7762, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-17 15:01:30'),
(10832, 6507, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-17 15:02:01'),
(10833, 8802, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-17 15:20:34'),
(10834, 3646, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734466870732', '2024-12-17 15:21:10'),
(10835, 8689, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos', '2024-12-17 15:45:21'),
(10836, 2180, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/datos/list', '2024-12-17 15:45:34'),
(10837, 6252, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-19 22:10:23'),
(10838, 2977, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-19 22:10:25'),
(10839, 5229, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-19 22:10:26'),
(10840, 1174, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-19 22:10:26'),
(10841, 5526, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-19 22:10:44'),
(10842, 1022, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734664244734', '2024-12-19 22:10:44'),
(10843, 9358, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/entrenar', '2024-12-19 22:11:14'),
(10844, 2140, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734664244735', '2024-12-20 00:10:50'),
(10845, 9660, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-20 00:11:30'),
(10846, 3263, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734671491344', '2024-12-20 00:11:31'),
(10847, 9230, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-20 00:12:52'),
(10848, 2113, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:13:42'),
(10849, 9835, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:14:02'),
(10850, 7384, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:14:22'),
(10851, 3353, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:14:50'),
(10852, 7784, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:15:10'),
(10853, 6830, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:15:30'),
(10854, 2447, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:16:03'),
(10855, 8082, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:16:23'),
(10856, 7903, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:16:46'),
(10857, 4662, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:17:07'),
(10858, 7332, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:17:27');
INSERT INTO `sis_centinela` (`idcentinela`, `codigo`, `ip`, `agente`, `method`, `url`, `fecha_registro`) VALUES
(10859, 9869, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:17:50'),
(10860, 4875, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:18:14'),
(10861, 1860, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:18:39'),
(10862, 9941, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:19:09'),
(10863, 5959, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 00:19:50'),
(10864, 1481, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-20 00:24:35'),
(10865, 7065, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-20 01:04:13'),
(10866, 7848, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-20 01:04:13'),
(10867, 8869, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-20 01:04:16'),
(10868, 7469, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734674656235', '2024-12-20 01:04:16'),
(10869, 3404, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-20 10:05:57'),
(10870, 6634, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/login', '2024-12-20 10:06:00'),
(10871, 2345, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/', '2024-12-20 10:06:01'),
(10872, 7744, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin', '2024-12-20 10:06:01'),
(10873, 5069, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar', '2024-12-20 10:06:03'),
(10874, 1843, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734707163331', '2024-12-20 10:06:03'),
(10875, 6149, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/entrenar', '2024-12-20 10:06:07'),
(10876, 1410, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/entrenar/list?_=1734707163332', '2024-12-20 12:57:16'),
(10877, 1639, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'GET', '/admin/prediccion', '2024-12-20 13:11:23'),
(10878, 5237, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 13:11:37'),
(10879, 6922, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 13:12:10'),
(10880, 3873, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 13:12:40'),
(10881, 1683, ' IP: ::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'POST', '/admin/prediccion', '2024-12-20 13:13:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_menus`
--

CREATE TABLE `sis_menus` (
  `idmenu` int NOT NULL,
  `men_nombre` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_controlador` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `men_icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_url_si` tinyint(1) NOT NULL DEFAULT '0',
  `men_orden` int NOT NULL,
  `men_visible` tinyint(1) NOT NULL,
  `men_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_menus`
--

INSERT INTO `sis_menus` (`idmenu`, `men_nombre`, `men_url`, `men_controlador`, `men_icono`, `men_url_si`, `men_orden`, `men_visible`, `men_fecha`) VALUES
(1, 'Maestras', '#', NULL, 'bx bx-lock-open-alt', 0, 20, 1, '2023-03-06 12:39:09'),
(4, 'Modulo usuarios', '#', NULL, 'text-success bx bx-user-circle', 0, 4, 1, '2024-10-22 13:02:36'),
(5, 'Modelo AI', '#', NULL, 'bx bxl-codepen text-warning fw-normal', 0, 1, 1, '2024-10-28 22:53:20'),
(6, 'Plagas de arroz', '#', NULL, 'bx bxs-brain text-danger', 0, 2, 1, '2024-10-29 19:04:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_permisos`
--

CREATE TABLE `sis_permisos` (
  `idpermisos` int NOT NULL,
  `idrol` int NOT NULL,
  `idsubmenu` int NOT NULL,
  `perm_r` int DEFAULT NULL,
  `perm_w` int DEFAULT NULL,
  `perm_u` int DEFAULT NULL,
  `perm_d` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_permisos`
--

INSERT INTO `sis_permisos` (`idpermisos`, `idrol`, `idsubmenu`, `perm_r`, `perm_w`, `perm_u`, `perm_d`) VALUES
(3, 1, 2, 1, 1, 1, 1),
(4, 1, 3, 1, 1, 1, 1),
(5, 1, 1, 1, 1, 1, 1),
(9, 1, 6, 1, 1, 1, 1),
(10, 1, 7, 1, 1, 1, 1),
(11, 1, 8, 1, 1, 1, 1),
(12, 1, 9, 1, 1, 1, 1),
(13, 1, 10, 1, 1, 1, 1),
(14, 1, 11, 1, 1, 1, 1),
(15, 1, 12, 1, 1, 1, 1),
(16, 1, 13, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_personal`
--

CREATE TABLE `sis_personal` (
  `idpersona` int NOT NULL,
  `per_dni` int NOT NULL,
  `per_nombre` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `per_celular` int DEFAULT NULL,
  `per_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_direcc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_foto` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_estado` tinyint(1) NOT NULL DEFAULT '1',
  `per_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_personal`
--

INSERT INTO `sis_personal` (`idpersona`, `per_dni`, `per_nombre`, `per_celular`, `per_email`, `per_direcc`, `per_foto`, `per_estado`, `per_fecha`) VALUES
(1, 1, 'Personal Developer', 987654321, 'developer@developer.com', '', '/images/personal/developer.png', 1, '2022-07-22 01:09:20'),
(3, 2, 'Personal Administrador', 964897058, 'admin@admin.com', '', '/img/default.png', 1, '2024-10-22 22:06:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_rol`
--

CREATE TABLE `sis_rol` (
  `idrol` int NOT NULL,
  `rol_cod` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol_descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_estado` tinyint(1) NOT NULL,
  `rol_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_rol`
--

INSERT INTO `sis_rol` (`idrol`, `rol_cod`, `rol_nombre`, `rol_descripcion`, `rol_estado`, `rol_fecha`) VALUES
(1, '/', 'developer', NULL, 1, '2022-07-22 01:09:56'),
(2, 'ADM', 'Administrador', NULL, 1, '2024-10-22 17:50:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_submenus`
--

CREATE TABLE `sis_submenus` (
  `idsubmenu` int NOT NULL,
  `idmenu` int NOT NULL,
  `sub_nombre` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_externo` tinyint(1) NOT NULL DEFAULT '0',
  `sub_controlador` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_metodo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'index',
  `sub_icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_orden` int NOT NULL DEFAULT '1',
  `sub_visible` tinyint(1) NOT NULL DEFAULT '1',
  `sub_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_submenus`
--

INSERT INTO `sis_submenus` (`idsubmenu`, `idmenu`, `sub_nombre`, `sub_url`, `sub_externo`, `sub_controlador`, `sub_metodo`, `sub_icono`, `sub_orden`, `sub_visible`, `sub_fecha`) VALUES
(1, 1, 'Menús', '/admin/menus', 0, 'MenusController', 'index', 'bx-menu', 1, 1, '2023-03-06 12:41:05'),
(2, 1, 'Submenús', '/admin/submenus', 0, 'SubMenusController', 'index', 'bx-menu-alt-right', 2, 1, '2023-03-06 12:41:44'),
(3, 1, 'Permisos', '/admin/permisos', 0, 'PermisosController', 'index', 'bx-key', 4, 1, '2023-03-06 12:42:10'),
(6, 4, 'Usuarios', '/admin/usuarios', 0, 'UsuariosController', 'index', 'bx-circle', 1, 1, '2024-10-22 14:26:55'),
(7, 4, 'roles', '/admin/roles', 0, 'RolesController', 'index', 'bx-circle', 2, 1, '2024-10-22 14:27:08'),
(8, 4, 'personal', '/admin/personas', 0, 'PersonasController', 'index', 'bx-circle', 3, 1, '2024-10-22 14:27:22'),
(9, 5, 'Identificar', '/admin/prediccion', 0, 'IAController', 'index', 'bx bx-circle', 1, 1, '2024-10-28 22:54:20'),
(10, 5, 'Entrenar modelo', '/admin/entrenar', 0, 'GenerarDatosController', 'index', 'bx-circle', 2, 1, '2024-10-28 22:54:47'),
(11, 5, 'Generar Datos', '/admin/datos', 0, 'GenerarDatosController', 'index', 'bx-circle', 4, 1, '2024-10-28 22:56:07'),
(12, 5, 'Historial ID', '/admin/historial', 0, 'HistorialController', 'index', 'bx-circle', 5, 1, '2024-10-28 22:56:31'),
(13, 6, 'Plagas enfermedades', '/admin/plagas', 0, 'PlagasController', 'index', 'bx-circle text-info', 1, 1, '2024-10-29 19:07:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_usuarios`
--

CREATE TABLE `sis_usuarios` (
  `idusuario` int NOT NULL,
  `idrol` int NOT NULL,
  `idpersona` int NOT NULL,
  `usu_usuario` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_pass` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usu_activo` tinyint(1) NOT NULL,
  `usu_estado` tinyint(1) NOT NULL,
  `usu_primera` tinyint(1) NOT NULL,
  `usu_twoauth` tinyint(1) NOT NULL,
  `usu_code_twoauth` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_usuarios`
--

INSERT INTO `sis_usuarios` (`idusuario`, `idrol`, `idpersona`, `usu_usuario`, `usu_pass`, `usu_token`, `usu_activo`, `usu_estado`, `usu_primera`, `usu_twoauth`, `usu_code_twoauth`, `usu_fecha`) VALUES
(1, 1, 1, 'developer', '$2y$10$Fit/2psoTtAP.pctt2qiluYnf4vYcKqbGvFbZa.8/ngskf1HlwZvW', NULL, 1, 1, 0, 0, '', '2022-07-22 01:10:31'),
(4, 2, 3, 'administrador', '$2y$10$CFBmCu6DY5qTiApFpPbF8uFan7aXUFauIFaxAJy/FDRdkwG3TPTrK', NULL, 1, 1, 0, 0, '0', '2024-10-22 23:07:27');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `re_configuracion`
--
ALTER TABLE `re_configuracion`
  ADD PRIMARY KEY (`idconfig`);

--
-- Indices de la tabla `re_datos_generados`
--
ALTER TABLE `re_datos_generados`
  ADD PRIMARY KEY (`identrenamiento`);

--
-- Indices de la tabla `re_detalle_modelo`
--
ALTER TABLE `re_detalle_modelo`
  ADD PRIMARY KEY (`id_detalle_modelo`);

--
-- Indices de la tabla `re_enfermedades`
--
ALTER TABLE `re_enfermedades`
  ADD PRIMARY KEY (`idenfermedad`);

--
-- Indices de la tabla `re_historial_identificacion`
--
ALTER TABLE `re_historial_identificacion`
  ADD PRIMARY KEY (`idhistorial`);

--
-- Indices de la tabla `re_modelo`
--
ALTER TABLE `re_modelo`
  ADD PRIMARY KEY (`idmodelo`);

--
-- Indices de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  ADD PRIMARY KEY (`idcentinela`);

--
-- Indices de la tabla `sis_menus`
--
ALTER TABLE `sis_menus`
  ADD PRIMARY KEY (`idmenu`);

--
-- Indices de la tabla `sis_permisos`
--
ALTER TABLE `sis_permisos`
  ADD PRIMARY KEY (`idpermisos`);

--
-- Indices de la tabla `sis_personal`
--
ALTER TABLE `sis_personal`
  ADD PRIMARY KEY (`idpersona`);

--
-- Indices de la tabla `sis_rol`
--
ALTER TABLE `sis_rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `sis_submenus`
--
ALTER TABLE `sis_submenus`
  ADD PRIMARY KEY (`idsubmenu`);

--
-- Indices de la tabla `sis_usuarios`
--
ALTER TABLE `sis_usuarios`
  ADD PRIMARY KEY (`idusuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `re_configuracion`
--
ALTER TABLE `re_configuracion`
  MODIFY `idconfig` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `re_datos_generados`
--
ALTER TABLE `re_datos_generados`
  MODIFY `identrenamiento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `re_detalle_modelo`
--
ALTER TABLE `re_detalle_modelo`
  MODIFY `id_detalle_modelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `re_enfermedades`
--
ALTER TABLE `re_enfermedades`
  MODIFY `idenfermedad` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `re_historial_identificacion`
--
ALTER TABLE `re_historial_identificacion`
  MODIFY `idhistorial` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `re_modelo`
--
ALTER TABLE `re_modelo`
  MODIFY `idmodelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  MODIFY `idcentinela` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10882;

--
-- AUTO_INCREMENT de la tabla `sis_menus`
--
ALTER TABLE `sis_menus`
  MODIFY `idmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `sis_permisos`
--
ALTER TABLE `sis_permisos`
  MODIFY `idpermisos` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `sis_personal`
--
ALTER TABLE `sis_personal`
  MODIFY `idpersona` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `sis_rol`
--
ALTER TABLE `sis_rol`
  MODIFY `idrol` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `sis_submenus`
--
ALTER TABLE `sis_submenus`
  MODIFY `idsubmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `sis_usuarios`
--
ALTER TABLE `sis_usuarios`
  MODIFY `idusuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
