-- =============================================================================
-- PROYECTO INTEGRADOR V SEMESTRE — BOOK TRACKER
-- Asignatura: Fundamentos de Base de Datos (AEF-1031) — Criterio 2.4
-- Script 04: Verificacion Estructural, Integridad y Pruebas Criptograficas
-- Motor Destino: PostgreSQL 16 (con extension pgcrypto)
-- =============================================================================

SET search_path TO public;

-- 1. Verificacion de magnitud del esquema (debe retornar 100 tablas y 432 FKs)
SELECT
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE') AS total_tablas,
    (SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema = 'public' AND constraint_type = 'FOREIGN KEY') AS total_llaves_foraneas,
    (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public' AND indexname LIKE 'idx_%') AS total_indices_negocio;

-- 2. Auditoria de filas pobladas por tabla (via estadisticas exactas de pg_stat_user_tables / xml count)
SELECT
    c.relname AS tabla_fisica,
    (xpath('/row/cnt/text()', query_to_xml(format('SELECT count(*) AS cnt FROM %I.%I', n.nspname, c.relname), false, true, '')))[1]::text::int AS total_registros
FROM pg_class c
INNER JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relkind = 'r'
ORDER BY total_registros ASC, c.relname ASC;

-- 3. Verificacion criptografica: cero contrasenas en texto plano en credencial_usuario
SELECT
    u.nombre_usuario,
    cu.algoritmo_hash,
    cu.costo_hash,
    CHAR_LENGTH(cu.hash_contrasena) AS longitud_hash,
    LEFT(cu.hash_contrasena, 18) AS prefijo_phc,
    CASE
        WHEN cu.algoritmo_hash IN ('argon2id', 'bcrypt')
         AND cu.costo_hash >= 12
         AND CHAR_LENGTH(cu.hash_contrasena) >= 60
         AND (cu.hash_contrasena LIKE '$argon2id$%' OR cu.hash_contrasena LIKE '$2b$12$%')
        THEN 'CUMPLIMIENTO CRIPTOGRAFICO OK'
        ELSE 'ALERTA: HASH DEBIL O TEXTO PLANO'
    END AS dictamen_seguridad
FROM credencial_usuario cu
INNER JOIN usuario u
    ON u.id_usuario = cu.id_usuario
ORDER BY u.id_usuario;

-- 4. Verificacion de hashes historicos y tokens de sesion/recuperacion (cero texto claro)
SELECT
    'historial_credencial' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN CHAR_LENGTH(hash_anterior) >= 60 AND (hash_anterior LIKE '$2b$%' OR hash_anterior LIKE '$argon2id$%') THEN 1 ELSE 0 END) AS hashes_validos
FROM historial_credencial
UNION ALL
SELECT
    'sesion_usuario',
    COUNT(*),
    SUM(CASE WHEN CHAR_LENGTH(hash_token) = 64 THEN 1 ELSE 0 END)
FROM sesion_usuario
UNION ALL
SELECT
    'token_recuperacion',
    COUNT(*),
    SUM(CASE WHEN CHAR_LENGTH(hash_token) = 64 THEN 1 ELSE 0 END)
FROM token_recuperacion
UNION ALL
SELECT
    'archivo_digital',
    COUNT(*),
    SUM(CASE WHEN CHAR_LENGTH(hash_sha256) = 64 THEN 1 ELSE 0 END)
FROM archivo_digital;

-- 5. Prueba viva de hashing bcrypt (costo 12) y SHA-256 con pgcrypto (transaccion reversible)
BEGIN;
WITH prueba AS (
    SELECT
        'LecturaSegura#2026!' AS clave_temporal_entrada,
        crypt('LecturaSegura#2026!', gen_salt('bf', 12)) AS hash_bcrypt_12,
        encode(digest('LecturaSegura#2026!', 'sha256'), 'hex') AS digest_sha256
)
SELECT
    LEFT(hash_bcrypt_12, 29) AS prefijo_bcrypt_generado,
    CHAR_LENGTH(hash_bcrypt_12) AS longitud_bcrypt,
    (hash_bcrypt_12 = crypt(clave_temporal_entrada, hash_bcrypt_12)) AS verificacion_correcta,
    (hash_bcrypt_12 = crypt('ClaveIncorrecta!', hash_bcrypt_12)) AS rechazo_clave_erronea,
    digest_sha256
FROM prueba;
ROLLBACK;
