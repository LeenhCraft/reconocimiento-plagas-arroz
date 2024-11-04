-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 04-11-2024 a las 23:50:07
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
(2, 'valor', '{\"carpeta_img_entrenamiento\":\"img\\/entrenamiento\",\"ruta_datos_entrenamiento\":\"entrenamiento\",\"nombre_datos_entrenamiento\":\"entrenamiento\",\"ruta_datos_generados\":\"data\\/\",\"nombre_modelo\": \"modelo-yolo-v5/\",\"ruta_modelo\": \"modelo\"}', '2024-10-29 09:20:45');

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
(1, '20241104145927', '{\"train\":{\"total\":323,\"by_class\":{\"Falso medidor\":67,\"Gusano enrollador de la hoja\":48,\"Caracol manzana\":74,\"Sogata del arroz\":69,\"Gusano cogollero\":65}},\"val\":{\"total\":84,\"by_class\":{\"Falso medidor\":17,\"Caracol manzana\":19,\"Gusano cogollero\":17,\"Gusano enrollador de la hoja\":13,\"Sogata del arroz\":18}},\"total_images\":407,\"images_by_class\":{\"Caracol manzana\":93,\"Falso medidor\":84,\"Gusano cogollero\":82,\"Gusano enrollador de la hoja\":61,\"Sogata del arroz\":87}}', '{\"success\":true,\"yaml_path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\entrenamiento\\\\Clases\\\\data.yaml\",\"config\":{\"path\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\entrenamiento\\\\Clases\",\"train\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\entrenamiento\\\\Clases\\\\train\\\\images\",\"val\":\"C:\\\\laragon\\\\www\\\\plagas-arroz\\\\public_html\\\\entrenamiento\\\\Clases\\\\val\\\\images\",\"nc\":5,\"names\":[\"Caracol manzana\",\"Falso medidor\",\"Gusano cogollero\",\"Gusano enrollador de la hoja\",\"Sogata del arroz\"]}}', '{\"total_processed\":407,\"train_total\":323,\"val_total\":84,\"errors_count\":0,\"processing_success_rate\":100}', 1, '2024-11-04 14:59:27');

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
(6, 'Gusano enrollador de la hoja', 'gusano-enrollador-de-la-hoja', '/img/plagas/gusano-enrollador-de-la-hoja.png', '<p>Gusano enrollador de la hoja - Cnaphalocrocis medinalis (Lepidoptera: Crambinae)</p>', 0, '2024-11-02 15:05:37'),
(7, 'Caracol manzana', 'caracol-manzana', '/img/plagas/caracol-manzana.png', '', 0, '2024-11-02 15:06:33'),
(8, 'Falso medidor', 'falso-medidor', '/img/plagas/falso-medidor.jpg', '', 0, '2024-11-02 15:06:40'),
(9, 'Gusano cogollero', 'gusano-cogollero', '/img/plagas/gusano-cogollero.png', '', 0, '2024-11-02 15:06:45'),
(10, 'Sogata del arroz', 'sogata-del-arroz', '/img/plagas/sogata-del-arroz.jpg', '', 0, '2024-11-02 15:06:53');

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
-- Indices de la tabla `re_enfermedades`
--
ALTER TABLE `re_enfermedades`
  ADD PRIMARY KEY (`idenfermedad`);

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
-- AUTO_INCREMENT de la tabla `re_enfermedades`
--
ALTER TABLE `re_enfermedades`
  MODIFY `idenfermedad` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  MODIFY `idcentinela` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8417;

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
