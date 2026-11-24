-- =============================================================================
-- PROYECTO INTEGRADOR V SEMESTRE — BOOK TRACKER
-- Asignatura: Fundamentos de Base de Datos (AEF-1031) — Criterio 2.4
-- Script 03: 10 Consultas Equivalentes de Algebra Relacional
-- Motor Destino: PostgreSQL 16
-- Autores: Cesar Alexis De Luna Jimenez (Est. A) & Gabriela Natalia De Leon Alvarez (Est. B)
-- =============================================================================

SET search_path TO public;

-- =============================================================================
-- Q1 [A1-A3]: Usuarios activos con perfil, rol vigente y metadatos criptograficos
-- Operadores AR: Seleccion (sigma), Combinacion natural/theta (bowtie), Proyeccion (pi)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    CONCAT(p.nombre, ' ', p.apellido_paterno) AS nombre_completo,
    p.pais,
    r.codigo_rol,
    r.nivel_jerarquia,
    c.algoritmo_hash,
    c.costo_hash,
    c.requiere_cambio
FROM usuario u
INNER JOIN perfil_usuario p
    ON p.id_usuario = u.id_usuario AND p.estatus = 'ACTIVO'
INNER JOIN usuario_rol ur
    ON ur.id_usuario = u.id_usuario AND ur.estatus = 'ACTIVO'
INNER JOIN rol r
    ON r.id_rol = ur.id_rol AND r.estatus = 'ACTIVO'
INNER JOIN credencial_usuario c
    ON c.id_usuario = u.id_usuario AND c.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
  AND u.correo_confirmado = TRUE
ORDER BY r.nivel_jerarquia ASC, u.id_usuario ASC;

-- =============================================================================
-- Q2 [A6-A7]: Libros del catalogo con autor principal, editorial, formato y >= 2 lectores
-- Operadores AR: Seleccion, Combinacion, Agrupacion (gamma), Filtro sobre agregado
-- =============================================================================
SELECT
    l.id_libro,
    l.titulo_original,
    CONCAT(a.nombre, ' ', a.apellido_paterno) AS autor_principal,
    ed.nombre_editorial,
    f.nombre_formato,
    COUNT(DISTINCT eu.id_usuario) AS total_lectores_unicos,
    COUNT(DISTINCT eu.id_ejemplar_usuario) AS total_ejemplares
FROM libro l
INNER JOIN libro_autor la
    ON la.id_libro = l.id_libro AND la.orden_credito = 1 AND la.estatus = 'ACTIVO'
INNER JOIN autor a
    ON a.id_autor = la.id_autor AND a.estatus = 'ACTIVO'
INNER JOIN edicion e
    ON e.id_libro = l.id_libro AND e.estatus = 'ACTIVO'
INNER JOIN editorial ed
    ON ed.id_editorial = e.id_editorial AND ed.estatus = 'ACTIVO'
INNER JOIN formato_libro f
    ON f.id_formato_libro = e.id_formato_libro AND f.estatus = 'ACTIVO'
INNER JOIN ejemplar_usuario eu
    ON eu.id_edicion = e.id_edicion AND eu.estatus = 'ACTIVO'
WHERE l.estatus = 'ACTIVO'
GROUP BY l.id_libro, l.titulo_original, a.nombre, a.apellido_paterno, ed.nombre_editorial, f.nombre_formato
HAVING COUNT(DISTINCT eu.id_usuario) >= 2
ORDER BY total_lectores_unicos DESC, l.titulo_original ASC;

-- =============================================================================
-- Q3 [A7-A8]: Inversion total de lectura por usuario combinando copias fisicas y digitales
-- Operadores AR: Combinacion externa izquierda (LEFT JOIN), Agrupacion (gamma), Seleccion
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    adq.moneda,
    COUNT(DISTINCT cf.id_copia_fisica) AS total_copias_fisicas,
    COUNT(DISTINCT ad.id_archivo_digital) AS total_archivos_digitales,
    SUM(COALESCE(adq.precio_pagado, 0)) AS inversion_total
FROM usuario u
INNER JOIN ejemplar_usuario eu
    ON eu.id_usuario = u.id_usuario AND eu.estatus = 'ACTIVO'
INNER JOIN adquisicion adq
    ON adq.id_ejemplar_usuario = eu.id_ejemplar_usuario AND adq.estatus = 'ACTIVO'
LEFT JOIN copia_fisica cf
    ON cf.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cf.estatus = 'ACTIVO'
LEFT JOIN archivo_digital ad
    ON ad.id_ejemplar_usuario = eu.id_ejemplar_usuario AND ad.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
GROUP BY u.id_usuario, u.nombre_usuario, adq.moneda
HAVING SUM(COALESCE(adq.precio_pagado, 0)) > 0
ORDER BY inversion_total DESC;

-- =============================================================================
-- Q4 [A1+A5]: Usuarios activos pendientes de aceptar el Aviso de Privacidad vigente
-- Operadores AR: Diferencia de conjuntos (-) / Antijoin (EXCEPT)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM usuario u
WHERE u.estatus = 'ACTIVO'
EXCEPT
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM usuario u
INNER JOIN consentimiento_privacidad cp
    ON cp.id_usuario = u.id_usuario AND cp.estatus = 'ACTIVO'
INNER JOIN version_aviso_privacidad vap
    ON vap.id_version_aviso_privacidad = cp.id_version_aviso_privacidad
   AND vap.es_vigente = TRUE
   AND vap.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
ORDER BY id_usuario ASC;

-- =============================================================================
-- Q5 [A6+A7+B1]: Velocidad lectora (PPM) y minutos por usuario y genero sobre el promedio global
-- Operadores AR: Combinacion multicapa, Agrupacion (gamma), Subconsulta escalar
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    g.nombre_genero,
    SUM(sl.minutos_netos) AS minutos_totales,
    CAST(AVG(sl.paginas_por_minuto) AS NUMERIC(6,2)) AS promedio_ppm
FROM usuario u
INNER JOIN ejemplar_usuario eu
    ON eu.id_usuario = u.id_usuario AND eu.estatus = 'ACTIVO'
INNER JOIN edicion e
    ON e.id_edicion = eu.id_edicion AND e.estatus = 'ACTIVO'
INNER JOIN libro_genero lg
    ON lg.id_libro = e.id_libro AND lg.estatus = 'ACTIVO'
INNER JOIN genero g
    ON g.id_genero = lg.id_genero AND g.estatus = 'ACTIVO'
INNER JOIN ciclo_lectura cl
    ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
INNER JOIN sesion_lectura sl
    ON sl.id_ciclo_lectura = cl.id_ciclo_lectura AND sl.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
GROUP BY u.id_usuario, u.nombre_usuario, g.nombre_genero
HAVING AVG(sl.paginas_por_minuto) > (
    SELECT AVG(sl2.paginas_por_minuto)
    FROM sesion_lectura sl2
    WHERE sl2.estatus = 'ACTIVO'
)
ORDER BY promedio_ppm DESC;

-- =============================================================================
-- Q6 [B1-B3]: Obras mejor evaluadas con puntaje multicriterio, resenas sin spoilers y reacciones
-- Operadores AR: Combinacion interna + LEFT JOIN, Agrupacion, HAVING
-- =============================================================================
SELECT
    l.id_libro,
    l.titulo_original,
    CAST(AVG(cal.puntaje_global) AS NUMERIC(4,2)) AS puntaje_global_promedio,
    CAST(AVG(cc.puntaje_criterio) AS NUMERIC(4,2)) AS promedio_criterios,
    COUNT(DISTINCT CASE WHEN r.contiene_spoilers = FALSE AND r.visibilidad = 'PUBLICO' THEN r.id_resena END) AS resenas_sin_spoilers,
    COUNT(DISTINCT rr.id_resena_reaccion) AS total_reacciones
FROM libro l
INNER JOIN edicion e
    ON e.id_libro = l.id_libro AND e.estatus = 'ACTIVO'
INNER JOIN ejemplar_usuario eu
    ON eu.id_edicion = e.id_edicion AND eu.estatus = 'ACTIVO'
INNER JOIN ciclo_lectura cl
    ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
INNER JOIN calificacion cal
    ON cal.id_ciclo_lectura = cl.id_ciclo_lectura AND cal.estatus = 'ACTIVO'
LEFT JOIN calificacion_criterio cc
    ON cc.id_calificacion = cal.id_calificacion AND cc.estatus = 'ACTIVO'
LEFT JOIN resena r
    ON r.id_ciclo_lectura = cl.id_ciclo_lectura AND r.estatus = 'ACTIVO'
LEFT JOIN resena_reaccion rr
    ON rr.id_resena = r.id_resena AND rr.estatus = 'ACTIVO'
WHERE l.estatus = 'ACTIVO'
GROUP BY l.id_libro, l.titulo_original
HAVING COUNT(DISTINCT cal.id_calificacion) >= 1
ORDER BY puntaje_global_promedio DESC, total_reacciones DESC;

-- =============================================================================
-- Q7 [B4-B6]: Lectores con racha activa, nivel lector, puntos acumulados y >= 2 logros
-- Operadores AR: Combinacion, Subconsulta correlacionada, Agrupacion, HAVING
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    nl.nombre_nivel,
    MAX(rl.dias_consecutivos) AS dias_racha_actual,
    COUNT(DISTINCT lu.id_logro) AS total_logros_desbloqueados,
    (
        SELECT SUM(mp2.cantidad_puntos)
        FROM movimiento_puntos mp2
        WHERE mp2.id_usuario = u.id_usuario
          AND mp2.estatus = 'ACTIVO'
    ) AS puntos_acumulados
FROM usuario u
INNER JOIN habito_lectura hl
    ON hl.id_usuario = u.id_usuario AND hl.activo_habito = TRUE AND hl.estatus = 'ACTIVO'
INNER JOIN racha_lectura rl
    ON rl.id_habito_lectura = hl.id_habito_lectura AND rl.es_racha_actual = TRUE AND rl.estatus = 'ACTIVO'
INNER JOIN estadistica_mensual em
    ON em.id_usuario = u.id_usuario AND em.estatus = 'ACTIVO'
INNER JOIN nivel_lector nl
    ON nl.id_nivel_lector = em.id_nivel_lector AND nl.estatus = 'ACTIVO'
INNER JOIN logro_usuario lu
    ON lu.id_usuario = u.id_usuario AND lu.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
  AND (
      SELECT COALESCE(SUM(mp3.cantidad_puntos), 0)
      FROM movimiento_puntos mp3
      WHERE mp3.id_usuario = u.id_usuario
        AND mp3.estatus = 'ACTIVO'
  ) >= nl.puntos_minimos
GROUP BY u.id_usuario, u.nombre_usuario, nl.nombre_nivel, nl.puntos_minimos
HAVING COUNT(DISTINCT lu.id_logro) >= 2
ORDER BY puntos_acumulados DESC;

-- =============================================================================
-- Q8 [B8]: Clubes de lectura activos con miembros, libros asignados y reuniones (incl. 0)
-- Operadores AR: Combinacion externa izquierda (LEFT JOIN), Agrupacion, HAVING
-- =============================================================================
SELECT
    cl.id_club_lectura,
    cl.nombre_club,
    cl.privacidad,
    COUNT(DISTINCT mc.id_miembro_club) AS total_miembros,
    COUNT(DISTINCT lc.id_libro_club) AS total_libros_asignados,
    COUNT(DISTINCT rc.id_reunion_club) AS total_reuniones
FROM club_lectura cl
INNER JOIN miembro_club mc
    ON mc.id_club_lectura = cl.id_club_lectura AND mc.estatus = 'ACTIVO'
LEFT JOIN libro_club lc
    ON lc.id_club_lectura = cl.id_club_lectura AND lc.estatus = 'ACTIVO'
LEFT JOIN reunion_club rc
    ON rc.id_club_lectura = cl.id_club_lectura AND rc.estatus = 'ACTIVO'
WHERE cl.estatus = 'ACTIVO'
GROUP BY cl.id_club_lectura, cl.nombre_club, cl.privacidad
HAVING COUNT(DISTINCT mc.id_miembro_club) >= 1
ORDER BY total_miembros DESC, total_reuniones DESC;

-- =============================================================================
-- Q9 [A3+B9]: Linea temporal unificada de incidentes de acceso y bajas logicas
-- Operadores AR: Union de conjuntos (U), Seleccion, Proyeccion con renombramiento (rho)
-- =============================================================================
SELECT
    'SEGURIDAD_ACCESO' AS origen_evento,
    ba.resultado AS tipo_evento,
    COALESCE(u.nombre_usuario, ba.correo_intentado) AS sujeto_o_correo,
    ba.ip_origen,
    COALESCE(ba.motivo_fallo, 'Sin detalle') AS detalle,
    ba.fecha_evento AS fecha_utc
FROM bitacora_acceso ba
LEFT JOIN usuario u
    ON u.id_usuario = ba.id_usuario
WHERE ba.estatus = 'ACTIVO'
  AND ba.resultado IN ('FALLIDO', 'BLOQUEADO')

UNION ALL

SELECT
    'AUDITORIA_DATOS' AS origen_evento,
    atx.tipo_operacion AS tipo_evento,
    COALESCE(u.nombre_usuario, 'SISTEMA') AS sujeto_o_correo,
    COALESCE(atx.ip_origen, '127.0.0.1') AS ip_origen,
    CONCAT(atx.nombre_tabla, ' #', CAST(atx.id_registro_afectado AS VARCHAR(20))) AS detalle,
    atx.fecha_operacion AS fecha_utc
FROM auditoria_transaccion atx
LEFT JOIN usuario u
    ON u.id_usuario = atx.id_usuario
WHERE atx.estatus = 'ACTIVO'
  AND atx.tipo_operacion = 'BAJA_LOGICA'
ORDER BY fecha_utc DESC;

-- =============================================================================
-- Q10 [A6+A7+B1]: DIVISION RELACIONAL — Lectores que completaron ciclos en TODOS
-- los formatos objetivo ('FISICO' y 'EBOOK')
-- Operadores AR: Division relacional (R ÷ S) equivalente a doble negacion (NOT EXISTS)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM usuario u
WHERE u.estatus = 'ACTIVO'
  AND NOT EXISTS (
      SELECT 1
      FROM formato_libro fl
      WHERE fl.estatus = 'ACTIVO'
        AND fl.codigo_formato IN ('FISICO', 'EBOOK')
        AND NOT EXISTS (
            SELECT 1
            FROM ejemplar_usuario eu
            INNER JOIN edicion e
                ON e.id_edicion = eu.id_edicion AND e.estatus = 'ACTIVO'
            INNER JOIN ciclo_lectura cl
                ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
            WHERE eu.id_usuario = u.id_usuario
              AND eu.estatus = 'ACTIVO'
              AND e.id_formato_libro = fl.id_formato_libro
              AND cl.estado_ciclo = 'COMPLETADO'
        )
  )
ORDER BY u.id_usuario ASC;
