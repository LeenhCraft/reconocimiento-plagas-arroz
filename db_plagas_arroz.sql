-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 02-12-2024 a las 19:12:13
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
(2, 'valor', '{\"carpeta_img_entrenamiento\":\"img\\/entrenamiento\",\"ruta_datos_entrenamiento\":\"datos_entrenamiento\",\"nombre_datos_entrenamiento\":\"entrenamiento\",\"ruta_datos_generados\":\"json\\/\",\"nombre_modelo\":\"modelo-yolo-v5\",\"ruta_modelo\":\"modelo_entrenado\",\"epochs\":\"30\",\"batch_size\":\"16\",\"img_size\":\"640\",\"model_size\":\"n\",\"path_weights\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\models\\\\yolov5n.pt\",\"weights\":1,\"debug\":0,\"ruta_detecciones\":\"predicciones\"}', '2024-10-29 09:20:45');

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
(1, '20241201221605', '{\"train\":{\"total\":1600,\"by_class\":{\"Caracol manzana\":320,\"Falso medidor\":320,\"Sogata del arroz\":320,\"Gusano cogollero\":320,\"Gusano enrollador de la hoja\":320}},\"val\":{\"total\":400,\"by_class\":{\"Sogata del arroz\":80,\"Gusano enrollador de la hoja\":80,\"Falso medidor\":80,\"Caracol manzana\":80,\"Gusano cogollero\":80}},\"total_images\":2000,\"images_by_class\":{\"Caracol manzana\":400,\"Falso medidor\":400,\"Gusano cogollero\":400,\"Gusano enrollador de la hoja\":400,\"Sogata del arroz\":400}}', '{\"success\":true,\"yaml_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"config\":{\"path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\",\"train\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\train\\\\images\",\"val\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\val\\\\images\",\"nc\":5,\"names\":[\"Caracol manzana\",\"Falso medidor\",\"Gusano cogollero\",\"Gusano enrollador de la hoja\",\"Sogata del arroz\"]}}', '{\"total_processed\":2000,\"train_total\":1600,\"val_total\":400,\"errors_count\":0,\"processing_success_rate\":100}', 1, '2024-12-01 22:16:17');

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
(4, 1, 1, 'C:\\laragon\\www\\plagas-arroz\\public_html\\modelo_entrenado\\modelo-yolo-v5_20241202_080705', 'modelo-yolo-v5_20241202_080705', 81.6234, 1, '00:26:45', '2024-12-02 08:07:05', '2024-12-02 08:33:50', '{\"success\":true,\"stats\":{\"final_epoch\":30,\"training_time\":\"00:25:21\",\"model_paths\":{\"best\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\\\\weights\\\\best.pt\",\"last\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\\\\weights\\\\last.pt\"}},\"evaluation\":{\"precision\":[0.8162337211343956,0.6485899390533696,0.683337734676083,0.6724936487705893,0,0,0],\"recall\":[0.5352547311381005,0.7089521370879139,0.5745172444502499,0.8486590887179604,0.695085042458721],\"mAP50\":[0.5423256358388788,0.7134209794517421,0.5784365237202451,0.8791716237068061,0.7033339106627432],\"mAP50_95\":[0.2748032978602818,10.117483139038086,1.442976679120745]},\"config\":{\"data_yaml\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\datos_entrenamiento\\\\20241201221605\\\\data.yaml\",\"output_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\modelo_entrenado\\\\modelo-yolo-v5_20241202_080705\",\"epochs\":30,\"batch_size\":16,\"img_size\":640,\"device\":\"0\",\"model_size\":\"n\"}}', '2024-12-02 08:33:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `re_enfermedades`
--

CREATE TABLE `re_enfermedades` (
  `idenfermedad` int NOT NULL,
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

INSERT INTO `re_enfermedades` (`idenfermedad`, `nombre`, `slug`, `imagen_url`, `descripcion`, `desactivado`, `fecha_registro`) VALUES
(6, 'Gusano enrollador de la hoja', 'gusano-enrollador-de-la-hoja', '/img/plagas/gusano-enrollador-de-la-hoja.jpg', '<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)</p>', 0, '2024-11-02 15:05:37'),
(7, 'Caracol manzana', 'caracol-manzana', '/img/plagas/caracol-manzana.jpeg', '', 0, '2024-11-02 15:06:33'),
(8, 'Falso medidor', 'falso-medidor', '/img/plagas/falso-medidor.jpeg', '', 0, '2024-11-02 15:06:40'),
(9, 'Gusano cogollero', 'gusano-cogollero', '/img/plagas/gusano-cogollero.jpg', '', 0, '2024-11-02 15:06:45'),
(10, 'Sogata del arroz', 'sogata-del-arroz', '/img/plagas/sogata-del-arroz.png', '', 0, '2024-11-02 15:06:53');

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
(1, 4, 1, '', '16s', 'no disponible', 'no disponible', 0, '{\"success\":true,\"image_path\":\"C:\\\\Users\\\\LEENH\\\\AppData\\\\Local\\\\Temp\\/detection-ai_upload_674e0555451162.05552492\\/enrrollador-de-la-hoja-6724099308500.jpg\",\"detections\":[{\"class\":\"Gusano enrollador de la hoja\",\"confidence\":0.8570408225059509,\"bbox\":{\"x1\":2,\"y1\":0,\"x2\":498,\"y2\":374},\"additional_info\":{\"description\":\"<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)<\\/p>\",\"url\":\"http:\\/\\/plagas-arroz.localhost\\/admin\\/plagas\\/gusano-enrollador-de-la-hoja\",\"image\":\"http:\\/\\/plagas-arroz.localhost\\/\\/img\\/plagas\\/gusano-enrollador-de-la-hoja.jpg\"}}],\"timestamp\":\"2024-12-02T14:07:16.222021\",\"summary\":{\"total_detections\":1,\"classes_detected\":{\"Gusano enrollador de la hoja\":1},\"average_confidence\":0.8570408225059509},\"output_dir\":\"predicciones\\/20241202140701\",\"execution_time\":\"16s\",\"idmodelo\":4}', '2024-12-02 14:07:17');

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
  MODIFY `identrenamiento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `re_detalle_modelo`
--
ALTER TABLE `re_detalle_modelo`
  MODIFY `id_detalle_modelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `re_enfermedades`
--
ALTER TABLE `re_enfermedades`
  MODIFY `idenfermedad` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `re_historial_identificacion`
--
ALTER TABLE `re_historial_identificacion`
  MODIFY `idhistorial` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `re_modelo`
--
ALTER TABLE `re_modelo`
  MODIFY `idmodelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  MODIFY `idcentinela` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10596;

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
