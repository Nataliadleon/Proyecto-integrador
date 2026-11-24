-- =============================================================================
-- PROYECTO INTEGRADOR V SEMESTRE — BOOK TRACKER
-- Asignatura: Fundamentos de Base de Datos (AEF-1031) — Criterio 2.4
-- Script 03: 10 Consultas Equivalentes de Algebra Relacional
-- Motor Destino: Microsoft SQL Server 2022 (T-SQL)
-- Autores: Cesar Alexis De Luna Jimenez (Est. A) & Gabriela Natalia De Leon Alvarez (Est. B)
-- =============================================================================

USE book_tracker;
GO

-- =============================================================================
-- Q1 [A1-A3]: Usuarios activos con perfil, rol vigente y metadatos criptograficos
-- Operadores AR: Seleccion (sigma), Combinacion natural/theta (bowtie), Proyeccion (pi)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    CONCAT(p.nombre, N' ', p.apellido_paterno) AS nombre_completo,
    p.pais,
    r.codigo_rol,
    r.nivel_jerarquia,
    c.algoritmo_hash,
    c.costo_hash,
    c.requiere_cambio
FROM dbo.usuario u
INNER JOIN dbo.perfil_usuario p
    ON p.id_usuario = u.id_usuario AND p.estatus = 'ACTIVO'
INNER JOIN dbo.usuario_rol ur
    ON ur.id_usuario = u.id_usuario AND ur.estatus = 'ACTIVO'
INNER JOIN dbo.rol r
    ON r.id_rol = ur.id_rol AND r.estatus = 'ACTIVO'
INNER JOIN dbo.credencial_usuario c
    ON c.id_usuario = u.id_usuario AND c.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
  AND u.correo_confirmado = 1
ORDER BY r.nivel_jerarquia ASC, u.id_usuario ASC;
GO

-- =============================================================================
-- Q2 [A6-A7]: Libros del catalogo con autor principal, editorial, formato y >= 2 lectores
-- Operadores AR: Seleccion, Combinacion, Agrupacion (gamma), Filtro sobre agregado
-- =============================================================================
SELECT
    l.id_libro,
    l.titulo_original,
    CONCAT(a.nombre, N' ', a.apellido_paterno) AS autor_principal,
    ed.nombre_editorial,
    f.nombre_formato,
    COUNT(DISTINCT eu.id_usuario) AS total_lectores_unicos,
    COUNT(DISTINCT eu.id_ejemplar_usuario) AS total_ejemplares
FROM dbo.libro l
INNER JOIN dbo.libro_autor la
    ON la.id_libro = l.id_libro AND la.orden_credito = 1 AND la.estatus = 'ACTIVO'
INNER JOIN dbo.autor a
    ON a.id_autor = la.id_autor AND a.estatus = 'ACTIVO'
INNER JOIN dbo.edicion e
    ON e.id_libro = l.id_libro AND e.estatus = 'ACTIVO'
INNER JOIN dbo.editorial ed
    ON ed.id_editorial = e.id_editorial AND ed.estatus = 'ACTIVO'
INNER JOIN dbo.formato_libro f
    ON f.id_formato_libro = e.id_formato_libro AND f.estatus = 'ACTIVO'
INNER JOIN dbo.ejemplar_usuario eu
    ON eu.id_edicion = e.id_edicion AND eu.estatus = 'ACTIVO'
WHERE l.estatus = 'ACTIVO'
GROUP BY l.id_libro, l.titulo_original, a.nombre, a.apellido_paterno, ed.nombre_editorial, f.nombre_formato
HAVING COUNT(DISTINCT eu.id_usuario) >= 2
ORDER BY total_lectores_unicos DESC, l.titulo_original ASC;
GO

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
FROM dbo.usuario u
INNER JOIN dbo.ejemplar_usuario eu
    ON eu.id_usuario = u.id_usuario AND eu.estatus = 'ACTIVO'
INNER JOIN dbo.adquisicion adq
    ON adq.id_ejemplar_usuario = eu.id_ejemplar_usuario AND adq.estatus = 'ACTIVO'
LEFT JOIN dbo.copia_fisica cf
    ON cf.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cf.estatus = 'ACTIVO'
LEFT JOIN dbo.archivo_digital ad
    ON ad.id_ejemplar_usuario = eu.id_ejemplar_usuario AND ad.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
GROUP BY u.id_usuario, u.nombre_usuario, adq.moneda
HAVING SUM(COALESCE(adq.precio_pagado, 0)) > 0
ORDER BY inversion_total DESC;
GO

-- =============================================================================
-- Q4 [A1+A5]: Usuarios activos pendientes de aceptar el Aviso de Privacidad vigente
-- Operadores AR: Diferencia de conjuntos (-) / Antijoin (NOT EXISTS)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM dbo.usuario u
WHERE u.estatus = 'ACTIVO'
EXCEPT
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM dbo.usuario u
INNER JOIN dbo.consentimiento_privacidad cp
    ON cp.id_usuario = u.id_usuario AND cp.estatus = 'ACTIVO'
INNER JOIN dbo.version_aviso_privacidad vap
    ON vap.id_version_aviso_privacidad = cp.id_version_aviso_privacidad
   AND vap.es_vigente = 1
   AND vap.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
ORDER BY id_usuario ASC;
GO

-- =============================================================================
-- Q5 [A6+A7+B1]: Velocidad lectora (PPM) y minutos por usuario y genero sobre el promedio global
-- Operadores AR: Combinacion multicapa, Agrupacion (gamma), Subconsulta escalar
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    g.nombre_genero,
    SUM(sl.minutos_netos) AS minutos_totales,
    CAST(AVG(sl.paginas_por_minuto) AS DECIMAL(6,2)) AS promedio_ppm
FROM dbo.usuario u
INNER JOIN dbo.ejemplar_usuario eu
    ON eu.id_usuario = u.id_usuario AND eu.estatus = 'ACTIVO'
INNER JOIN dbo.edicion e
    ON e.id_edicion = eu.id_edicion AND e.estatus = 'ACTIVO'
INNER JOIN dbo.libro_genero lg
    ON lg.id_libro = e.id_libro AND lg.estatus = 'ACTIVO'
INNER JOIN dbo.genero g
    ON g.id_genero = lg.id_genero AND g.estatus = 'ACTIVO'
INNER JOIN dbo.ciclo_lectura cl
    ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
INNER JOIN dbo.sesion_lectura sl
    ON sl.id_ciclo_lectura = cl.id_ciclo_lectura AND sl.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
GROUP BY u.id_usuario, u.nombre_usuario, g.nombre_genero
HAVING AVG(sl.paginas_por_minuto) > (
    SELECT AVG(sl2.paginas_por_minuto)
    FROM dbo.sesion_lectura sl2
    WHERE sl2.estatus = 'ACTIVO'
)
ORDER BY promedio_ppm DESC;
GO

-- =============================================================================
-- Q6 [B1-B3]: Obras mejor evaluadas con puntaje multicriterio, resenas sin spoilers y reacciones
-- Operadores AR: Combinacion interna + LEFT JOIN, Agrupacion, HAVING
-- =============================================================================
SELECT
    l.id_libro,
    l.titulo_original,
    CAST(AVG(cal.puntaje_global) AS DECIMAL(4,2)) AS puntaje_global_promedio,
    CAST(AVG(cc.puntaje_criterio) AS DECIMAL(4,2)) AS promedio_criterios,
    COUNT(DISTINCT CASE WHEN r.contiene_spoilers = 0 AND r.visibilidad = N'PUBLICO' THEN r.id_resena END) AS resenas_sin_spoilers,
    COUNT(DISTINCT rr.id_resena_reaccion) AS total_reacciones
FROM dbo.libro l
INNER JOIN dbo.edicion e
    ON e.id_libro = l.id_libro AND e.estatus = 'ACTIVO'
INNER JOIN dbo.ejemplar_usuario eu
    ON eu.id_edicion = e.id_edicion AND eu.estatus = 'ACTIVO'
INNER JOIN dbo.ciclo_lectura cl
    ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
INNER JOIN dbo.calificacion cal
    ON cal.id_ciclo_lectura = cl.id_ciclo_lectura AND cal.estatus = 'ACTIVO'
LEFT JOIN dbo.calificacion_criterio cc
    ON cc.id_calificacion = cal.id_calificacion AND cc.estatus = 'ACTIVO'
LEFT JOIN dbo.resena r
    ON r.id_ciclo_lectura = cl.id_ciclo_lectura AND r.estatus = 'ACTIVO'
LEFT JOIN dbo.resena_reaccion rr
    ON rr.id_resena = r.id_resena AND rr.estatus = 'ACTIVO'
WHERE l.estatus = 'ACTIVO'
GROUP BY l.id_libro, l.titulo_original
HAVING COUNT(DISTINCT cal.id_calificacion) >= 1
ORDER BY puntaje_global_promedio DESC, total_reacciones DESC;
GO

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
        FROM dbo.movimiento_puntos mp2
        WHERE mp2.id_usuario = u.id_usuario
          AND mp2.estatus = 'ACTIVO'
    ) AS puntos_acumulados
FROM dbo.usuario u
INNER JOIN dbo.habito_lectura hl
    ON hl.id_usuario = u.id_usuario AND hl.activo_habito = 1 AND hl.estatus = 'ACTIVO'
INNER JOIN dbo.racha_lectura rl
    ON rl.id_habito_lectura = hl.id_habito_lectura AND rl.es_racha_actual = 1 AND rl.estatus = 'ACTIVO'
INNER JOIN dbo.estadistica_mensual em
    ON em.id_usuario = u.id_usuario AND em.estatus = 'ACTIVO'
INNER JOIN dbo.nivel_lector nl
    ON nl.id_nivel_lector = em.id_nivel_lector AND nl.estatus = 'ACTIVO'
INNER JOIN dbo.logro_usuario lu
    ON lu.id_usuario = u.id_usuario AND lu.estatus = 'ACTIVO'
WHERE u.estatus = 'ACTIVO'
  AND (
      SELECT COALESCE(SUM(mp3.cantidad_puntos), 0)
      FROM dbo.movimiento_puntos mp3
      WHERE mp3.id_usuario = u.id_usuario
        AND mp3.estatus = 'ACTIVO'
  ) >= nl.puntos_minimos
GROUP BY u.id_usuario, u.nombre_usuario, nl.nombre_nivel, nl.puntos_minimos
HAVING COUNT(DISTINCT lu.id_logro) >= 2
ORDER BY puntos_acumulados DESC;
GO

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
FROM dbo.club_lectura cl
INNER JOIN dbo.miembro_club mc
    ON mc.id_club_lectura = cl.id_club_lectura AND mc.estatus = 'ACTIVO'
LEFT JOIN dbo.libro_club lc
    ON lc.id_club_lectura = cl.id_club_lectura AND lc.estatus = 'ACTIVO'
LEFT JOIN dbo.reunion_club rc
    ON rc.id_club_lectura = cl.id_club_lectura AND rc.estatus = 'ACTIVO'
WHERE cl.estatus = 'ACTIVO'
GROUP BY cl.id_club_lectura, cl.nombre_club, cl.privacidad
HAVING COUNT(DISTINCT mc.id_miembro_club) >= 1
ORDER BY total_miembros DESC, total_reuniones DESC;
GO

-- =============================================================================
-- Q9 [A3+B9]: Linea temporal unificada de incidentes de acceso y bajas logicas
-- Operadores AR: Union de conjuntos (U), Seleccion, Proyeccion con renombramiento (rho)
-- =============================================================================
SELECT
    N'SEGURIDAD_ACCESO' AS origen_evento,
    ba.resultado AS tipo_evento,
    COALESCE(u.nombre_usuario, ba.correo_intentado) AS sujeto_o_correo,
    ba.ip_origen,
    COALESCE(ba.motivo_fallo, N'Sin detalle') AS detalle,
    ba.fecha_evento AS fecha_utc
FROM dbo.bitacora_acceso ba
LEFT JOIN dbo.usuario u
    ON u.id_usuario = ba.id_usuario
WHERE ba.estatus = 'ACTIVO'
  AND ba.resultado IN (N'FALLIDO', N'BLOQUEADO')

UNION ALL

SELECT
    N'AUDITORIA_DATOS' AS origen_evento,
    atx.tipo_operacion AS tipo_evento,
    COALESCE(u.nombre_usuario, N'SISTEMA') AS sujeto_o_correo,
    COALESCE(atx.ip_origen, '127.0.0.1') AS ip_origen,
    CONCAT(atx.nombre_tabla, N' #', CAST(atx.id_registro_afectado AS NVARCHAR(20))) AS detalle,
    atx.fecha_operacion AS fecha_utc
FROM dbo.auditoria_transaccion atx
LEFT JOIN dbo.usuario u
    ON u.id_usuario = atx.id_usuario
WHERE atx.estatus = 'ACTIVO'
  AND atx.tipo_operacion = N'BAJA_LOGICA'
ORDER BY fecha_utc DESC;
GO

-- =============================================================================
-- Q10 [A6+A7+B1]: DIVISION RELACIONAL — Lectores que completaron ciclos en TODOS
-- los formatos objetivo ('FISICO' y 'EBOOK')
-- Operadores AR: Division relacional (R ÷ S) equivalente a doble negacion (NOT EXISTS)
-- =============================================================================
SELECT
    u.id_usuario,
    u.nombre_usuario,
    u.correo
FROM dbo.usuario u
WHERE u.estatus = 'ACTIVO'
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.formato_libro fl
      WHERE fl.estatus = 'ACTIVO'
        AND fl.codigo_formato IN (N'FISICO', N'EBOOK')
        AND NOT EXISTS (
            SELECT 1
            FROM dbo.ejemplar_usuario eu
            INNER JOIN dbo.edicion e
                ON e.id_edicion = eu.id_edicion AND e.estatus = 'ACTIVO'
            INNER JOIN dbo.ciclo_lectura cl
                ON cl.id_ejemplar_usuario = eu.id_ejemplar_usuario AND cl.estatus = 'ACTIVO'
            WHERE eu.id_usuario = u.id_usuario
              AND eu.estatus = 'ACTIVO'
              AND e.id_formato_libro = fl.id_formato_libro
              AND cl.estado_ciclo = N'COMPLETADO'
        )
  )
ORDER BY u.id_usuario ASC;
GO
