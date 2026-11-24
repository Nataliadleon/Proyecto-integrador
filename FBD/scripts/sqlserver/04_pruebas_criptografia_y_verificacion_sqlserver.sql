-- =============================================================================
-- PROYECTO INTEGRADOR V SEMESTRE — BOOK TRACKER
-- Asignatura: Fundamentos de Base de Datos (AEF-1031) — Criterio 2.4
-- Script 04: Verificacion Estructural, Integridad y Pruebas Criptograficas
-- Motor Destino: Microsoft SQL Server 2022 (T-SQL)
-- =============================================================================

USE book_tracker;
GO

-- 1. Verificacion de magnitud del esquema (debe retornar 100 tablas y 432 FKs)
SELECT
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE') AS total_tablas,
    (SELECT COUNT(*) FROM sys.foreign_keys) AS total_llaves_foraneas,
    (SELECT COUNT(*) FROM sys.indexes WHERE is_primary_key = 0 AND is_unique_constraint = 0 AND name LIKE 'idx_%') AS total_indices_negocio;
GO

-- 2. Auditoria de filas pobladas por tabla (umbral minimo rubrica: 5 a 10 registros)
SELECT
    t.name AS tabla_fisica,
    SUM(p.rows) AS total_registros
FROM sys.tables t
INNER JOIN sys.partitions p
    ON p.object_id = t.object_id AND p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY total_registros ASC, t.name ASC;
GO

-- 3. Verificacion criptografica: cero contrasenas en texto plano en credencial_usuario
SELECT
    u.nombre_usuario,
    cu.algoritmo_hash,
    cu.costo_hash,
    LEN(cu.hash_contrasena) AS longitud_hash,
    LEFT(cu.hash_contrasena, 18) AS prefijo_phc,
    CASE
        WHEN cu.algoritmo_hash IN ('argon2id', 'bcrypt')
         AND cu.costo_hash >= 12
         AND LEN(cu.hash_contrasena) >= 60
         AND (cu.hash_contrasena LIKE '$argon2id$%' OR cu.hash_contrasena LIKE '$2b$12$%')
        THEN N'CUMPLIMIENTO CRIPTOGRAFICO OK'
        ELSE N'ALERTA: HASH DEBIL O TEXTO PLANO'
    END AS dictamen_seguridad
FROM dbo.credencial_usuario cu
INNER JOIN dbo.usuario u
    ON u.id_usuario = cu.id_usuario
ORDER BY u.id_usuario;
GO

-- 4. Verificacion de hashes historicos y tokens de sesion/recuperacion (cero texto claro)
SELECT
    N'historial_credencial' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN LEN(hash_anterior) >= 60 AND (hash_anterior LIKE '$2b$%' OR hash_anterior LIKE '$argon2id$%') THEN 1 ELSE 0 END) AS hashes_validos
FROM dbo.historial_credencial
UNION ALL
SELECT
    N'sesion_usuario',
    COUNT(*),
    SUM(CASE WHEN LEN(hash_token) = 64 THEN 1 ELSE 0 END)
FROM dbo.sesion_usuario
UNION ALL
SELECT
    N'token_recuperacion',
    COUNT(*),
    SUM(CASE WHEN LEN(hash_token) = 64 THEN 1 ELSE 0 END)
FROM dbo.token_recuperacion
UNION ALL
SELECT
    N'archivo_digital',
    COUNT(*),
    SUM(CASE WHEN LEN(hash_sha256) = 64 THEN 1 ELSE 0 END)
FROM dbo.archivo_digital;
GO

-- 5. Prueba viva de hashing SHA-256 con salt en SQL Server (transaccion reversible)
BEGIN TRANSACTION;
DECLARE @salt NVARCHAR(36) = CAST(NEWID() AS NVARCHAR(36));
DECLARE @pass_prueba NVARCHAR(100) = N'LecturaSegura#2026!';
DECLARE @digest VARCHAR(64) = LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', CONCAT(@salt, N':', @pass_prueba)), 2));

SELECT
    @salt AS salt_aleatorio,
    @digest AS sha256_salted_hex,
    LEN(@digest) AS longitud_digest_hex;
ROLLBACK TRANSACTION;
GO
