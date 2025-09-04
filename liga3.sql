-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-09-2025 a las 02:48:16
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `liga3`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_equipo` (IN `p_id` INT, IN `p_nombre` VARCHAR(50))   BEGIN
    UPDATE equipos SET nombre = p_nombre WHERE id_equipo = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_jugador` (IN `p_cedula` INT, IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_posicion` VARCHAR(30), IN `p_dorsal` INT, IN `p_equipo` INT)   BEGIN
    UPDATE jugadores
    SET nombre = p_nombre, apellido = p_apellido,
        posicion = p_posicion, dorsal = p_dorsal, id_equipo = p_equipo
    WHERE cedula = p_cedula;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_resultado_partido` (IN `p_id` INT, IN `p_goles_local` INT, IN `p_goles_visitante` INT)   BEGIN
    UPDATE partidos
    SET goles_local = p_goles_local, goles_visitante = p_goles_visitante, estado = 'Finalizado'
    WHERE id_partido = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_arbitro` (IN `p_cedula` INT, IN `p_partido` INT)   BEGIN
    INSERT INTO arbitros_partido (cedula, id_partido) VALUES (p_cedula, p_partido);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_equipo` (IN `p_id` INT)   BEGIN
    SELECT * FROM equipos WHERE id_equipo = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_jugador` (IN `p_cedula` INT)   BEGIN
    SELECT * FROM jugadores WHERE cedula = p_cedula;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_equipo` (IN `p_id` INT)   BEGIN
    DELETE FROM equipos WHERE id_equipo = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_jugador` (IN `p_cedula` INT)   BEGIN
    DELETE FROM jugadores WHERE cedula = p_cedula;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_partido` (IN `p_id` INT)   BEGIN
    DELETE FROM partidos WHERE id_partido = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `goles_jugador` (IN `p_jugador` INT)   BEGIN
    SELECT COUNT(*) AS total_goles FROM goles WHERE cedula = p_jugador;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `goles_partido` (IN `p_partido` INT)   BEGIN
    SELECT g.minuto, CONCAT(j.nombre,' ',j.apellido) AS jugador
    FROM goles g
    JOIN jugadores j ON g.cedula = j.cedula
    WHERE g.id_partido = p_partido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_arbitro` (IN `p_cedula` INT, IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50))   BEGIN
    INSERT INTO arbitros (cedula, nombre, apellido) VALUES (p_cedula, p_nombre, p_apellido);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_equipo` (IN `p_nombre` VARCHAR(50), IN `p_liga` INT)   BEGIN
    INSERT INTO equipos (nombre, id_liga) VALUES (p_nombre, p_liga);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_jugador` (IN `p_cedula` INT, IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_fecha_nacimiento` DATE, IN `p_posicion` VARCHAR(30), IN `p_dorsal` INT, IN `p_equipo` INT, IN `p_pais` VARCHAR(50))   BEGIN
    INSERT INTO jugadores (cedula, nombre, apellido, fecha_nacimiento, posicion, dorsal, id_equipo, pais)
    VALUES (p_cedula, p_nombre, p_apellido, p_fecha_nacimiento, p_posicion, p_dorsal, p_equipo, p_pais);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_liga` (IN `p_nombre` VARCHAR(50), IN `p_pais` VARCHAR(50))   BEGIN
    INSERT INTO ligas (nombre, país) VALUES (p_nombre, p_pais);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_partido` (IN `p_liga` INT, IN `p_local` INT, IN `p_visitante` INT, IN `p_fecha` DATE, IN `p_estado` VARCHAR(20))   BEGIN
    INSERT INTO partidos (id_liga, id_local, id_visitante, fecha, estado, goles_local, goles_visitante)
    VALUES (p_liga, p_local, p_visitante, p_fecha, p_estado, 0, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `jugadores_por_equipo` (IN `p_equipo` INT)   BEGIN
    SELECT j.cedula, CONCAT(j.nombre,' ',j.apellido) AS jugador, j.posicion, j.dorsal
    FROM jugadores j WHERE j.id_equipo = p_equipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_arbitros` ()   BEGIN
    SELECT * FROM arbitros;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_equipos` ()   BEGIN
    SELECT * FROM equipos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_jugadores` ()   BEGIN
    SELECT * FROM jugadores;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_ligas` ()   BEGIN
    SELECT * FROM ligas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_partidos` ()   BEGIN
    SELECT * FROM partidos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `maximos_goleadores` ()   BEGIN
    SELECT CONCAT(j.nombre,' ',j.apellido) AS jugador, e.nombre AS equipo, COUNT(g.id_gol) AS goles
    FROM jugadores j
    JOIN equipos e ON j.id_equipo = e.id_equipo
    LEFT JOIN goles g ON j.cedula = g.cedula
    GROUP BY j.cedula
    ORDER BY goles DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `partidos_por_equipo` (IN `p_equipo` INT)   BEGIN
    SELECT * FROM partidos
    WHERE id_local = p_equipo OR id_visitante = p_equipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_gol` (IN `p_partido` INT, IN `p_jugador` INT, IN `p_minuto` INT)   BEGIN
    INSERT INTO goles (id_partido, cedula, minuto) VALUES (p_partido, p_jugador, p_minuto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_tarjeta` (IN `p_partido` INT, IN `p_jugador` INT, IN `p_tipo` VARCHAR(20))   BEGIN
    INSERT INTO tarjetas (id_partido, cedula, tipo) VALUES (p_partido, p_jugador, p_tipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `resumen_partido` (IN `p_id` INT)   BEGIN
    SELECT p.id_partido, el.nombre AS local, ev.nombre AS visitante,
           p.goles_local, p.goles_visitante, p.estado
    FROM partidos p
    JOIN equipos el ON p.id_local = el.id_equipo
    JOIN equipos ev ON p.id_visitante = ev.id_equipo
    WHERE p.id_partido = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tabla_posiciones` ()   BEGIN
    SELECT e.nombre, c.puntos, c.partidos_ganados, c.partidos_empatados, c.partidos_perdidos
    FROM clasificacion c
    JOIN equipos e ON c.id_equipo = e.id_equipo
    ORDER BY c.puntos DESC, c.diferencia_goles DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tarjetas_jugador` (IN `p_jugador` INT)   BEGIN
    SELECT tipo, COUNT(*) AS total FROM tarjetas
    WHERE cedula = p_jugador GROUP BY tipo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tarjetas_partido` (IN `p_partido` INT)   BEGIN
    SELECT t.tipo, CONCAT(j.nombre,' ',j.apellido) AS jugador
    FROM tarjetas t
    JOIN jugadores j ON t.cedula = j.cedula
    WHERE t.id_partido = p_partido;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros`
--

CREATE TABLE `arbitros` (
  `cedula` bigint(20) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `arbitros`
--

INSERT INTO `arbitros` (`cedula`, `nombre`, `apellido`, `pais`, `fecha_nacimiento`) VALUES
(1001234567, 'Ricardo', 'Morales', 'Colombia', '1980-02-15'),
(1001234584, 'Pedro', 'Silva', 'Brasil', '1975-06-25');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `arbitros_partido`
--

CREATE TABLE `arbitros_partido` (
  `cedula` bigint(20) NOT NULL,
  `id_partido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `arbitros_partido`
--

INSERT INTO `arbitros_partido` (`cedula`, `id_partido`) VALUES
(1001234601, 1),
(1001234618, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clasificacion`
--

CREATE TABLE `clasificacion` (
  `id_clasificacion` int(11) NOT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `partidos_jugados` int(11) DEFAULT NULL,
  `partidos_ganados` int(11) DEFAULT NULL,
  `partidos_empatados` int(11) DEFAULT NULL,
  `partidos_perdidos` int(11) DEFAULT NULL,
  `goles_a_favor` int(11) DEFAULT NULL,
  `goles_en_contra` int(11) DEFAULT NULL,
  `diferencia_goles` int(11) DEFAULT NULL,
  `puntos` int(11) DEFAULT NULL,
  `temporada` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clasificacion`
--

INSERT INTO `clasificacion` (`id_clasificacion`, `id_liga`, `id_equipo`, `partidos_jugados`, `partidos_ganados`, `partidos_empatados`, `partidos_perdidos`, `goles_a_favor`, `goles_en_contra`, `diferencia_goles`, `puntos`, `temporada`) VALUES
(1001234635, 1, 1, 1, 1, 0, 0, 2, 1, 1, 3, '2025'),
(1001234652, 1, 2, 1, 0, 0, 1, 1, 2, -1, 0, '2025');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

CREATE TABLE `equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL,
  `fundado` int(11) DEFAULT NULL,
  `presidente` varchar(100) DEFAULT NULL,
  `entrenador` varchar(100) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipos`
--

INSERT INTO `equipos` (`id_equipo`, `nombre`, `ciudad`, `estadio`, `fundado`, `presidente`, `entrenador`, `id_liga`) VALUES
(1001234669, 'Águilas Doradas', 'Medellín', 'Estadio Dorado', 1995, 'Carlos Ríos', 'Miguel Gómez', 1),
(1001234686, 'Tiburones FC', 'Barranquilla', 'Estadio Caribe', 1980, 'Luis Pardo', 'Javier Hernández', 1),
(1001234703, 'Leones Verdes', 'São Paulo', 'Arena Verde', 1975, 'João Silva', 'Rafael Costa', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `goles`
--

CREATE TABLE `goles` (
  `id_gol` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `cedula` int(11) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `goles`
--

INSERT INTO `goles` (`id_gol`, `id_partido`, `cedula`, `minuto`, `tipo`, `descripcion`) VALUES
(1001234720, 1, 1, 23, 'Normal', 'Remate de cabeza'),
(1001234737, 1, 2, 55, 'Autogol', 'Desviación en propia puerta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadores`
--

CREATE TABLE `jugadores` (
  `cedula` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `posicion` varchar(30) DEFAULT NULL,
  `dorsal` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `jugadores`
--

INSERT INTO `jugadores` (`cedula`, `nombre`, `apellido`, `fecha_nacimiento`, `pais`, `posicion`, `dorsal`, `id_equipo`) VALUES
(1001234754, 'Juan', 'Pérez', '1998-05-20', 'Colombia', 'Delantero', 9, 1),
(1001234771, 'Carlos', 'López', '2000-10-11', 'Colombia', 'Defensa', 4, 1),
(1001234788, 'Andrés', 'Gómez', '1996-03-15', 'Colombia', 'Portero', 1, 2),
(1001234805, 'Paulo', 'Santos', '1995-07-12', 'Brasil', 'Mediocampista', 10, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ligas`
--

CREATE TABLE `ligas` (
  `id_liga` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `país` varchar(50) DEFAULT NULL,
  `temporada` varchar(10) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ligas`
--

INSERT INTO `ligas` (`id_liga`, `nombre`, `país`, `temporada`, `fecha_inicio`, `fecha_fin`) VALUES
(1001234822, 'Liga Nacional', 'Colombia', '2025', '2025-01-15', '2025-06-15'),
(1001234839, 'Copa Continental', 'Brasil', '2025', '2025-02-01', '2025-07-20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partidos`
--

CREATE TABLE `partidos` (
  `id_partido` int(11) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL,
  `id_local` int(11) DEFAULT NULL,
  `id_visitante` int(11) DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `jornada` int(11) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `partidos`
--

INSERT INTO `partidos` (`id_partido`, `fecha`, `estadio`, `id_local`, `id_visitante`, `goles_local`, `goles_visitante`, `id_liga`, `jornada`, `estado`) VALUES
(1001234856, '2025-02-15 15:00:00', 'Estadio Dorado', 1, 2, 2, 1, 1, 1, 'Finalizado'),
(1001234873, '2025-02-20 18:00:00', 'Estadio Caribe', 2, 1, 0, 0, 2, 1, 'Programado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjetas`
--

CREATE TABLE `tarjetas` (
  `id_tarjeta` int(11) NOT NULL,
  `id_partido` int(11) DEFAULT NULL,
  `cedula` int(11) DEFAULT NULL,
  `minuto` int(11) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `motivo` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tarjetas`
--

INSERT INTO `tarjetas` (`id_tarjeta`, `id_partido`, `cedula`, `minuto`, `tipo`, `motivo`) VALUES
(1001234890, 1, 2, 60, 'Amarilla', 'Falta táctica'),
(1001234907, 1, 1, 75, 'Roja', 'Agresión');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_arbitros_partidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_arbitros_partidos` (
`arbitro` varchar(101)
,`partidos_dirigidos` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_dorsales_repetidos`
--

CREATE TABLE `vista_dorsales_repetidos` (
  `dorsal` int(11) DEFAULT NULL,
  `id_liga` int(11) DEFAULT NULL,
  `liga` varchar(100) DEFAULT NULL,
  `jugadores` mediumtext DEFAULT NULL,
  `cantidad_jugadores` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_equipos_empates`
--

CREATE TABLE `vista_equipos_empates` (
  `equipo` varchar(100) DEFAULT NULL,
  `partidos_empatados` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_equipos_liga`
--

CREATE TABLE `vista_equipos_liga` (
  `id_equipo` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL,
  `liga` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_equipos_mas_victorias`
--

CREATE TABLE `vista_equipos_mas_victorias` (
  `equipo` varchar(100) DEFAULT NULL,
  `partidos_ganados` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estadisticas_ligas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estadisticas_ligas` (
`liga` varchar(100)
,`total_partidos` bigint(21)
,`total_goles` decimal(33,0)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_goleadores`
--

CREATE TABLE `vista_goleadores` (
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `equipo` varchar(100) DEFAULT NULL,
  `goles` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_jugadores_equipo`
--

CREATE TABLE `vista_jugadores_equipo` (
  `cedula` int(11) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `posicion` varchar(30) DEFAULT NULL,
  `equipo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_jugadores_extranjeros`
--

CREATE TABLE `vista_jugadores_extranjeros` (
  `jugador` varchar(101) DEFAULT NULL,
  `pais_jugador` varchar(50) DEFAULT NULL,
  `pais_liga` varchar(50) DEFAULT NULL,
  `equipo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_jugadores_por_posicion`
--

CREATE TABLE `vista_jugadores_por_posicion` (
  `equipo` varchar(100) DEFAULT NULL,
  `posicion` varchar(30) DEFAULT NULL,
  `total_jugadores` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_ligas_resumen`
--

CREATE TABLE `vista_ligas_resumen` (
  `id_liga` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `país` varchar(50) DEFAULT NULL,
  `temporada` varchar(10) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `duracion_dias` int(7) DEFAULT NULL,
  `total_equipos` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_maximos_goleadores`
--

CREATE TABLE `vista_maximos_goleadores` (
  `cedula` int(11) DEFAULT NULL,
  `jugador` varchar(101) DEFAULT NULL,
  `equipo` varchar(100) DEFAULT NULL,
  `total_goles` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_partidos_programados`
--

CREATE TABLE `vista_partidos_programados` (
  `id_partido` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `estadio` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_partidos_resultados`
--

CREATE TABLE `vista_partidos_resultados` (
  `id_partido` int(11) DEFAULT NULL,
  `local` varchar(100) DEFAULT NULL,
  `visitante` varchar(100) DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_partidos_sin_goles`
--

CREATE TABLE `vista_partidos_sin_goles` (
  `id_partido` int(11) DEFAULT NULL,
  `equipo_local` varchar(100) DEFAULT NULL,
  `equipo_visitante` varchar(100) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_promedio_edad_equipo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_promedio_edad_equipo` (
`equipo` varchar(100)
,`edad_promedio` decimal(24,4)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_promedio_goles_partido`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_promedio_goles_partido` (
`id_partido` int(11)
,`total_goles` bigint(12)
,`promedio_goles` decimal(16,4)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_ranking_diferencia_goles`
--

CREATE TABLE `vista_ranking_diferencia_goles` (
  `equipo` varchar(100) DEFAULT NULL,
  `diferencia_goles` int(11) DEFAULT NULL,
  `posicion` bigint(21) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_resultados_partidos`
--

CREATE TABLE `vista_resultados_partidos` (
  `id_partido` int(11) DEFAULT NULL,
  `equipo_local` varchar(100) DEFAULT NULL,
  `equipo_visitante` varchar(100) DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vista_tabla_general`
--

CREATE TABLE `vista_tabla_general` (
  `equipo` varchar(100) DEFAULT NULL,
  `partidos_jugados` int(11) DEFAULT NULL,
  `partidos_ganados` int(11) DEFAULT NULL,
  `partidos_empatados` int(11) DEFAULT NULL,
  `partidos_perdidos` int(11) DEFAULT NULL,
  `goles_a_favor` int(11) DEFAULT NULL,
  `goles_en_contra` int(11) DEFAULT NULL,
  `diferencia_goles` int(11) DEFAULT NULL,
  `puntos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tarjetas_jugadores`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_tarjetas_jugadores` (
`cedula` int(11)
,`jugador` varchar(101)
,`amarillas` decimal(22,0)
,`rojas` decimal(22,0)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_arbitros_partidos`
--
DROP TABLE IF EXISTS `vista_arbitros_partidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_arbitros_partidos`  AS SELECT concat(`a`.`nombre`,' ',`a`.`apellido`) AS `arbitro`, count(`ap`.`id_partido`) AS `partidos_dirigidos` FROM (`arbitros` `a` left join `arbitros_partido` `ap` on(`a`.`cedula` = `ap`.`cedula`)) GROUP BY `a`.`cedula` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estadisticas_ligas`
--
DROP TABLE IF EXISTS `vista_estadisticas_ligas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_estadisticas_ligas`  AS SELECT `l`.`nombre` AS `liga`, count(distinct `p`.`id_partido`) AS `total_partidos`, sum(`p`.`goles_local` + `p`.`goles_visitante`) AS `total_goles` FROM (`ligas` `l` left join `partidos` `p` on(`l`.`id_liga` = `p`.`id_liga`)) GROUP BY `l`.`id_liga` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_promedio_edad_equipo`
--
DROP TABLE IF EXISTS `vista_promedio_edad_equipo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_promedio_edad_equipo`  AS SELECT `e`.`nombre` AS `equipo`, avg(timestampdiff(YEAR,`j`.`fecha_nacimiento`,curdate())) AS `edad_promedio` FROM (`equipos` `e` join `jugadores` `j` on(`e`.`id_equipo` = `j`.`id_equipo`)) GROUP BY `e`.`id_equipo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_promedio_goles_partido`
--
DROP TABLE IF EXISTS `vista_promedio_goles_partido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_promedio_goles_partido`  AS SELECT `p`.`id_partido` AS `id_partido`, `p`.`goles_local`+ `p`.`goles_visitante` AS `total_goles`, (`p`.`goles_local` + `p`.`goles_visitante`) / 1.0 AS `promedio_goles` FROM `partidos` AS `p` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tarjetas_jugadores`
--
DROP TABLE IF EXISTS `vista_tarjetas_jugadores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tarjetas_jugadores`  AS SELECT `j`.`cedula` AS `cedula`, concat(`j`.`nombre`,' ',`j`.`apellido`) AS `jugador`, sum(case when `t`.`tipo` = 'Amarilla' then 1 else 0 end) AS `amarillas`, sum(case when `t`.`tipo` = 'Roja' then 1 else 0 end) AS `rojas` FROM (`jugadores` `j` left join `tarjetas` `t` on(`j`.`cedula` = `t`.`cedula`)) GROUP BY `j`.`cedula` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `arbitros`
--
ALTER TABLE `arbitros`
  ADD PRIMARY KEY (`cedula`);

--
-- Indices de la tabla `arbitros_partido`
--
ALTER TABLE `arbitros_partido`
  ADD PRIMARY KEY (`cedula`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
