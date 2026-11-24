-- =============================================================================
-- PROYECTO INTEGRADOR V SEMESTRE — BOOK TRACKER
-- Asignatura: Fundamentos de Base de Datos (AEF-1031) — Criterio 2.4
-- Script 01: DDL Maestro (100 Tablas Normalizadas en BCNF | 432 FKs)
-- Motor Destino: Microsoft SQL Server 2022 (T-SQL)
-- Autores (Deslinde 50/50):
--   * Estudiante A (Tablas 001-050, A1-A9): Cesar Alexis De Luna Jimenez
--   * Estudiante B (Tablas 051-100, B1-B9): Gabriela Natalia De Leon Alvarez
-- Politica de Integridad: Baja logica simbólica (EntidadBase) y NO ACTION
-- =============================================================================

IF DB_ID(N'book_tracker') IS NULL
BEGIN
    CREATE DATABASE book_tracker;
END;
GO
USE book_tracker;
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================================
-- BLOQUE 1: ESTUDIANTE A — Cesar Alexis De Luna Jimenez (Submodulos A1-A9, Tablas 1-50)
-- =============================================================================

-- Tabla 001 [A1] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.usuario (
    id_usuario BIGINT IDENTITY(1,1) NOT NULL,
    nombre_usuario NVARCHAR(80) NOT NULL,
    correo NVARCHAR(150) NOT NULL,
    correo_confirmado BIT NOT NULL DEFAULT 0,
    ultimo_acceso DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_nombre_usuario UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT ck_usuario_c1_correo CHECK (correo LIKE '%@%.%'),
    CONSTRAINT ck_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 002 [A1] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.perfil_usuario (
    id_perfil_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100) NULL,
    fecha_nacimiento DATE NULL,
    pais NVARCHAR(80) NULL,
    biografia NVARCHAR(500) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_perfil_usuario PRIMARY KEY (id_perfil_usuario),
    CONSTRAINT uq_perfil_usuario_id_usuario UNIQUE (id_usuario),
    CONSTRAINT ck_perfil_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 003 [A1] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.credencial_usuario (
    id_credencial_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    hash_contrasena VARCHAR(255) NOT NULL,
    algoritmo_hash VARCHAR(30) NOT NULL DEFAULT 'argon2id',
    costo_hash INT NOT NULL DEFAULT 12,
    fecha_ultimo_cambio DATETIME2(0) NOT NULL,
    requiere_cambio BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_credencial_usuario PRIMARY KEY (id_credencial_usuario),
    CONSTRAINT uq_credencial_usuario_id_usuario UNIQUE (id_usuario),
    CONSTRAINT ck_credencial_usuario_c1_hash_contrasena CHECK (LEN(hash_contrasena) >= 60),
    CONSTRAINT ck_credencial_usuario_c2_algoritmo_hash CHECK (algoritmo_hash IN ('argon2id','bcrypt')),
    CONSTRAINT ck_credencial_usuario_c3_costo_hash CHECK (costo_hash >= 10),
    CONSTRAINT ck_credencial_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 004 [A1] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.historial_credencial (
    id_historial_credencial BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    hash_anterior VARCHAR(255) NOT NULL,
    algoritmo_hash VARCHAR(30) NOT NULL DEFAULT 'argon2id',
    fecha_registro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_historial_credencial PRIMARY KEY (id_historial_credencial),
    CONSTRAINT ck_historial_credencial_c1_hash_anterior CHECK (LEN(hash_anterior) >= 60),
    CONSTRAINT ck_historial_credencial_c2_algoritmo_hash CHECK (algoritmo_hash IN ('argon2id','bcrypt')),
    CONSTRAINT ck_historial_credencial_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 005 [A1] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.politica_contrasena (
    id_politica_contrasena BIGINT IDENTITY(1,1) NOT NULL,
    id_rol BIGINT NOT NULL,
    longitud_minima INT NOT NULL DEFAULT 12,
    requiere_mayuscula BIT NOT NULL DEFAULT 1,
    requiere_numero BIT NOT NULL DEFAULT 1,
    requiere_simbolo BIT NOT NULL DEFAULT 1,
    dias_vigencia INT NOT NULL DEFAULT 90,
    max_intentos_fallidos INT NOT NULL DEFAULT 5,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_politica_contrasena PRIMARY KEY (id_politica_contrasena),
    CONSTRAINT uq_politica_contrasena_id_rol UNIQUE (id_rol),
    CONSTRAINT ck_politica_contrasena_c1_longitud_minima CHECK (longitud_minima >= 8),
    CONSTRAINT ck_politica_contrasena_c2_dias_vigencia CHECK (dias_vigencia > 0),
    CONSTRAINT ck_politica_contrasena_c3_max_intentos_fallidos CHECK (max_intentos_fallidos BETWEEN 3 AND 10),
    CONSTRAINT ck_politica_contrasena_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 006 [A2] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.rol (
    id_rol BIGINT IDENTITY(1,1) NOT NULL,
    codigo_rol NVARCHAR(50) NOT NULL,
    nombre_rol NVARCHAR(255) NOT NULL,
    nivel_jerarquia INT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_rol PRIMARY KEY (id_rol),
    CONSTRAINT uq_rol_codigo_rol UNIQUE (codigo_rol),
    CONSTRAINT uq_rol_nombre_rol UNIQUE (nombre_rol),
    CONSTRAINT ck_rol_c1_nivel_jerarquia CHECK (nivel_jerarquia >= 1),
    CONSTRAINT ck_rol_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 007 [A2] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.permiso (
    id_permiso BIGINT IDENTITY(1,1) NOT NULL,
    codigo_permiso NVARCHAR(50) NOT NULL,
    modulo NVARCHAR(80) NOT NULL,
    accion NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_permiso PRIMARY KEY (id_permiso),
    CONSTRAINT uq_permiso_codigo_permiso UNIQUE (codigo_permiso),
    CONSTRAINT ck_permiso_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 008 [A2] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.rol_permiso (
    id_rol_permiso BIGINT IDENTITY(1,1) NOT NULL,
    id_rol BIGINT NOT NULL,
    id_permiso BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_rol_permiso PRIMARY KEY (id_rol_permiso),
    CONSTRAINT uq_rol_permiso_comp UNIQUE (id_rol, id_permiso),
    CONSTRAINT ck_rol_permiso_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 009 [A2] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.usuario_rol (
    id_usuario_rol BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    fecha_asignacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_expiracion DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_usuario_rol PRIMARY KEY (id_usuario_rol),
    CONSTRAINT uq_usuario_rol_comp UNIQUE (id_usuario, id_rol),
    CONSTRAINT ck_usuario_rol_c1_fecha_expiracion CHECK (fecha_expiracion IS NULL OR fecha_expiracion > fecha_asignacion),
    CONSTRAINT ck_usuario_rol_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 010 [A3] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.sesion_usuario (
    id_sesion_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_dispositivo_usuario BIGINT NOT NULL,
    hash_token VARCHAR(255) NOT NULL,
    ip_origen VARCHAR(50) NOT NULL,
    agente_usuario NVARCHAR(255) NOT NULL,
    fecha_inicio DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_expiracion DATETIME2(0) NOT NULL,
    fecha_cierre DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_sesion_usuario PRIMARY KEY (id_sesion_usuario),
    CONSTRAINT uq_sesion_usuario_hash_token UNIQUE (hash_token),
    CONSTRAINT ck_sesion_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 011 [A3] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.bitacora_acceso (
    id_bitacora_acceso BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NULL,
    id_sesion_usuario BIGINT NULL,
    correo_intentado NVARCHAR(150) NOT NULL,
    ip_origen VARCHAR(50) NOT NULL,
    resultado NVARCHAR(30) NOT NULL,
    motivo_fallo NVARCHAR(255) NULL,
    fecha_evento DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_bitacora_acceso PRIMARY KEY (id_bitacora_acceso),
    CONSTRAINT ck_bitacora_acceso_c1_resultado CHECK (resultado IN ('EXITOSO','FALLIDO','BLOQUEADO')),
    CONSTRAINT ck_bitacora_acceso_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 012 [A3] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.bloqueo_cuenta (
    id_bloqueo_cuenta BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    tipo_bloqueo NVARCHAR(30) NOT NULL,
    motivo NVARCHAR(255) NOT NULL,
    fecha_inicio DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_desbloqueo DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_bloqueo_cuenta PRIMARY KEY (id_bloqueo_cuenta),
    CONSTRAINT ck_bloqueo_cuenta_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 013 [A3] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.token_recuperacion (
    id_token_recuperacion BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    hash_token VARCHAR(255) NOT NULL,
    fecha_expiracion DATETIME2(0) NOT NULL,
    fecha_uso DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_token_recuperacion PRIMARY KEY (id_token_recuperacion),
    CONSTRAINT uq_token_recuperacion_hash_token UNIQUE (hash_token),
    CONSTRAINT ck_token_recuperacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 014 [A4] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.metodo_2fa (
    id_metodo_2fa BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    tipo_metodo NVARCHAR(30) NOT NULL,
    secreto_cifrado NVARCHAR(255) NOT NULL,
    confirmado BIT NOT NULL DEFAULT 0,
    fecha_activacion DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_metodo_2fa PRIMARY KEY (id_metodo_2fa),
    CONSTRAINT ck_metodo_2fa_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 015 [A4] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.codigo_respaldo_2fa (
    id_codigo_respaldo_2fa BIGINT IDENTITY(1,1) NOT NULL,
    id_metodo_2fa BIGINT NOT NULL,
    hash_codigo VARCHAR(255) NOT NULL,
    usado BIT NOT NULL DEFAULT 0,
    fecha_uso DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_codigo_respaldo_2fa PRIMARY KEY (id_codigo_respaldo_2fa),
    CONSTRAINT uq_codigo_respaldo_2fa_comp UNIQUE (id_metodo_2fa, hash_codigo),
    CONSTRAINT ck_codigo_respaldo_2fa_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 016 [A4] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.dispositivo_usuario (
    id_dispositivo_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_dispositivo NVARCHAR(255) NOT NULL,
    sistema_operativo NVARCHAR(100) NOT NULL,
    huella_dispositivo NVARCHAR(255) NOT NULL,
    es_confiable BIT NOT NULL DEFAULT 0,
    ultimo_acceso DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_dispositivo_usuario PRIMARY KEY (id_dispositivo_usuario),
    CONSTRAINT ck_dispositivo_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 017 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.idioma (
    id_idioma BIGINT IDENTITY(1,1) NOT NULL,
    codigo_iso VARCHAR(10) NOT NULL,
    nombre_idioma NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_idioma PRIMARY KEY (id_idioma),
    CONSTRAINT uq_idioma_codigo_iso UNIQUE (codigo_iso),
    CONSTRAINT ck_idioma_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 018 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.preferencia_usuario (
    id_preferencia_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_idioma BIGINT NOT NULL,
    zona_horaria NVARCHAR(50) NOT NULL,
    tema_visual NVARCHAR(50) NOT NULL,
    visibilidad_perfil NVARCHAR(30) NOT NULL DEFAULT 'PUBLICO',
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_preferencia_usuario PRIMARY KEY (id_preferencia_usuario),
    CONSTRAINT uq_preferencia_usuario_id_usuario UNIQUE (id_usuario),
    CONSTRAINT ck_preferencia_usuario_c1_visibilidad_perfil CHECK (visibilidad_perfil IN ('PUBLICO','PRIVADO','AMIGOS')),
    CONSTRAINT ck_preferencia_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 019 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.version_aviso_privacidad (
    id_version_aviso_privacidad BIGINT IDENTITY(1,1) NOT NULL,
    numero_version NVARCHAR(50) NOT NULL,
    contenido_legal NVARCHAR(MAX) NOT NULL,
    fecha_vigencia DATE NOT NULL,
    es_vigente BIT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_version_aviso_privacidad PRIMARY KEY (id_version_aviso_privacidad),
    CONSTRAINT uq_version_aviso_privacidad_numero_version UNIQUE (numero_version),
    CONSTRAINT ck_version_aviso_privacidad_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 020 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.consentimiento_privacidad (
    id_consentimiento_privacidad BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_version_aviso_privacidad BIGINT NOT NULL,
    fecha_aceptacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    ip_aceptacion VARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_consentimiento_privacidad PRIMARY KEY (id_consentimiento_privacidad),
    CONSTRAINT ck_consentimiento_privacidad_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 021 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.tipo_solicitud_arco (
    id_tipo_solicitud_arco BIGINT IDENTITY(1,1) NOT NULL,
    codigo_arco NVARCHAR(50) NOT NULL,
    nombre_tipo NVARCHAR(255) NOT NULL,
    plazo_dias_habiles INT NOT NULL DEFAULT 20,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_tipo_solicitud_arco PRIMARY KEY (id_tipo_solicitud_arco),
    CONSTRAINT uq_tipo_solicitud_arco_codigo_arco UNIQUE (codigo_arco),
    CONSTRAINT ck_tipo_solicitud_arco_c1_plazo_dias_habiles CHECK (plazo_dias_habiles > 0),
    CONSTRAINT ck_tipo_solicitud_arco_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 022 [A5] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.solicitud_arco (
    id_solicitud_arco BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_tipo_solicitud_arco BIGINT NOT NULL,
    folio NVARCHAR(50) NOT NULL,
    estado_solicitud NVARCHAR(50) NOT NULL DEFAULT 'RECIBIDA',
    detalle_solicitud NVARCHAR(MAX) NOT NULL,
    resolucion NVARCHAR(MAX) NULL,
    fecha_solicitud DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_resolucion DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_solicitud_arco PRIMARY KEY (id_solicitud_arco),
    CONSTRAINT uq_solicitud_arco_folio UNIQUE (folio),
    CONSTRAINT ck_solicitud_arco_c1_estado_solicitud CHECK (estado_solicitud IN ('RECIBIDA','EN_REVISION','RESUELTA','RECHAZADA')),
    CONSTRAINT ck_solicitud_arco_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 023 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.autor (
    id_autor BIGINT IDENTITY(1,1) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido_paterno NVARCHAR(100) NOT NULL,
    apellido_materno NVARCHAR(100) NULL,
    pais_origen NVARCHAR(80) NULL,
    anio_nacimiento INT NULL,
    biografia NVARCHAR(MAX) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_autor PRIMARY KEY (id_autor),
    CONSTRAINT ck_autor_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 024 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.editorial (
    id_editorial BIGINT IDENTITY(1,1) NOT NULL,
    nombre_editorial NVARCHAR(255) NOT NULL,
    pais NVARCHAR(80) NULL,
    sitio_web NVARCHAR(500) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_editorial PRIMARY KEY (id_editorial),
    CONSTRAINT uq_editorial_nombre_editorial UNIQUE (nombre_editorial),
    CONSTRAINT ck_editorial_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 025 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.libro (
    id_libro BIGINT IDENTITY(1,1) NOT NULL,
    titulo_original NVARCHAR(255) NOT NULL,
    anio_publicacion_original INT NULL,
    sinopsis NVARCHAR(MAX) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_libro PRIMARY KEY (id_libro),
    CONSTRAINT ck_libro_c1_anio_publicacion_original CHECK (anio_publicacion_original BETWEEN 1450 AND 2100),
    CONSTRAINT ck_libro_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 026 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.tipo_colaborador (
    id_tipo_colaborador BIGINT IDENTITY(1,1) NOT NULL,
    codigo_tipo NVARCHAR(50) NOT NULL,
    nombre_tipo NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_tipo_colaborador PRIMARY KEY (id_tipo_colaborador),
    CONSTRAINT uq_tipo_colaborador_codigo_tipo UNIQUE (codigo_tipo),
    CONSTRAINT ck_tipo_colaborador_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 027 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.libro_autor (
    id_libro_autor BIGINT IDENTITY(1,1) NOT NULL,
    id_libro BIGINT NOT NULL,
    id_autor BIGINT NOT NULL,
    id_tipo_colaborador BIGINT NOT NULL,
    orden_credito INT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_libro_autor PRIMARY KEY (id_libro_autor),
    CONSTRAINT uq_libro_autor_comp UNIQUE (id_libro, id_autor, id_tipo_colaborador),
    CONSTRAINT ck_libro_autor_c1_orden_credito CHECK (orden_credito >= 1),
    CONSTRAINT ck_libro_autor_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 028 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.formato_libro (
    id_formato_libro BIGINT IDENTITY(1,1) NOT NULL,
    codigo_formato NVARCHAR(50) NOT NULL,
    nombre_formato NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_formato_libro PRIMARY KEY (id_formato_libro),
    CONSTRAINT uq_formato_libro_codigo_formato UNIQUE (codigo_formato),
    CONSTRAINT ck_formato_libro_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 029 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.edicion (
    id_edicion BIGINT IDENTITY(1,1) NOT NULL,
    id_libro BIGINT NOT NULL,
    id_editorial BIGINT NOT NULL,
    id_idioma BIGINT NOT NULL,
    id_formato_libro BIGINT NOT NULL,
    isbn_10 VARCHAR(10) NULL,
    isbn_13 VARCHAR(13) NOT NULL,
    anio_edicion INT NOT NULL,
    numero_paginas INT NOT NULL,
    url_portada NVARCHAR(500) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_edicion PRIMARY KEY (id_edicion),
    CONSTRAINT uq_edicion_isbn_13 UNIQUE (isbn_13),
    CONSTRAINT ck_edicion_c1_anio_edicion CHECK (anio_edicion BETWEEN 1450 AND 2100),
    CONSTRAINT ck_edicion_c2_numero_paginas CHECK (numero_paginas > 0),
    CONSTRAINT ck_edicion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 030 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.genero (
    id_genero BIGINT IDENTITY(1,1) NOT NULL,
    id_genero_padre BIGINT NULL,
    nombre_genero NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_genero PRIMARY KEY (id_genero),
    CONSTRAINT uq_genero_nombre_genero UNIQUE (nombre_genero),
    CONSTRAINT ck_genero_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 031 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.libro_genero (
    id_libro_genero BIGINT IDENTITY(1,1) NOT NULL,
    id_libro BIGINT NOT NULL,
    id_genero BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_libro_genero PRIMARY KEY (id_libro_genero),
    CONSTRAINT uq_libro_genero_comp UNIQUE (id_libro, id_genero),
    CONSTRAINT ck_libro_genero_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 032 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.serie_libro (
    id_serie_libro BIGINT IDENTITY(1,1) NOT NULL,
    nombre_serie NVARCHAR(255) NOT NULL,
    total_volumenes INT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_serie_libro PRIMARY KEY (id_serie_libro),
    CONSTRAINT uq_serie_libro_nombre_serie UNIQUE (nombre_serie),
    CONSTRAINT ck_serie_libro_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 033 [A6] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.libro_serie (
    id_libro_serie BIGINT IDENTITY(1,1) NOT NULL,
    id_libro BIGINT NOT NULL,
    id_serie_libro BIGINT NOT NULL,
    numero_volumen DECIMAL(6,2) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_libro_serie PRIMARY KEY (id_libro_serie),
    CONSTRAINT uq_libro_serie_comp UNIQUE (id_libro, id_serie_libro),
    CONSTRAINT ck_libro_serie_c1_numero_volumen CHECK (numero_volumen > 0),
    CONSTRAINT ck_libro_serie_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 034 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.estado_lectura (
    id_estado_lectura BIGINT IDENTITY(1,1) NOT NULL,
    codigo_estado NVARCHAR(50) NOT NULL,
    nombre_estado NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_estado_lectura PRIMARY KEY (id_estado_lectura),
    CONSTRAINT uq_estado_lectura_codigo_estado UNIQUE (codigo_estado),
    CONSTRAINT ck_estado_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 035 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.ejemplar_usuario (
    id_ejemplar_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_edicion BIGINT NOT NULL,
    id_estado_lectura BIGINT NOT NULL,
    es_favorito BIT NOT NULL DEFAULT 0,
    fecha_alta_biblioteca DATE NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_ejemplar_usuario PRIMARY KEY (id_ejemplar_usuario),
    CONSTRAINT ck_ejemplar_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 036 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.etiqueta (
    id_etiqueta BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_etiqueta NVARCHAR(255) NOT NULL,
    color_hex VARCHAR(7) NOT NULL DEFAULT '#3B82F6',
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_etiqueta PRIMARY KEY (id_etiqueta),
    CONSTRAINT uq_etiqueta_comp UNIQUE (id_usuario, nombre_etiqueta),
    CONSTRAINT ck_etiqueta_c1_color_hex CHECK (color_hex LIKE '#______'),
    CONSTRAINT ck_etiqueta_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 037 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.etiqueta_ejemplar (
    id_etiqueta_ejemplar BIGINT IDENTITY(1,1) NOT NULL,
    id_etiqueta BIGINT NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_etiqueta_ejemplar PRIMARY KEY (id_etiqueta_ejemplar),
    CONSTRAINT uq_etiqueta_ejemplar_comp UNIQUE (id_etiqueta, id_ejemplar_usuario),
    CONSTRAINT ck_etiqueta_ejemplar_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 038 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.estante (
    id_estante BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_estante NVARCHAR(255) NOT NULL,
    es_publico BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_estante PRIMARY KEY (id_estante),
    CONSTRAINT uq_estante_comp UNIQUE (id_usuario, nombre_estante),
    CONSTRAINT ck_estante_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 039 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.estante_ejemplar (
    id_estante_ejemplar BIGINT IDENTITY(1,1) NOT NULL,
    id_estante BIGINT NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    orden_estante INT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_estante_ejemplar PRIMARY KEY (id_estante_ejemplar),
    CONSTRAINT uq_estante_ejemplar_comp UNIQUE (id_estante, id_ejemplar_usuario),
    CONSTRAINT ck_estante_ejemplar_c1_orden_estante CHECK (orden_estante >= 1),
    CONSTRAINT ck_estante_ejemplar_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 040 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.coleccion (
    id_coleccion BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_coleccion NVARCHAR(255) NOT NULL,
    es_publica BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_coleccion PRIMARY KEY (id_coleccion),
    CONSTRAINT uq_coleccion_comp UNIQUE (id_usuario, nombre_coleccion),
    CONSTRAINT ck_coleccion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 041 [A7] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.coleccion_ejemplar (
    id_coleccion_ejemplar BIGINT IDENTITY(1,1) NOT NULL,
    id_coleccion BIGINT NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_coleccion_ejemplar PRIMARY KEY (id_coleccion_ejemplar),
    CONSTRAINT uq_coleccion_ejemplar_comp UNIQUE (id_coleccion, id_ejemplar_usuario),
    CONSTRAINT ck_coleccion_ejemplar_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 042 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.ubicacion_fisica (
    id_ubicacion_fisica BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_ubicacion NVARCHAR(255) NOT NULL,
    referencia_espacio NVARCHAR(255) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_ubicacion_fisica PRIMARY KEY (id_ubicacion_fisica),
    CONSTRAINT uq_ubicacion_fisica_comp UNIQUE (id_usuario, nombre_ubicacion),
    CONSTRAINT ck_ubicacion_fisica_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 043 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.copia_fisica (
    id_copia_fisica BIGINT IDENTITY(1,1) NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    id_ubicacion_fisica BIGINT NULL,
    estado_conservacion NVARCHAR(50) NOT NULL,
    esta_firmado BIT NOT NULL DEFAULT 0,
    codigo_inventario NVARCHAR(50) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_copia_fisica PRIMARY KEY (id_copia_fisica),
    CONSTRAINT uq_copia_fisica_id_ejemplar_usuario UNIQUE (id_ejemplar_usuario),
    CONSTRAINT ck_copia_fisica_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 044 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.fuente_adquisicion (
    id_fuente_adquisicion BIGINT IDENTITY(1,1) NOT NULL,
    nombre_fuente NVARCHAR(255) NOT NULL,
    tipo_fuente NVARCHAR(50) NOT NULL,
    url_sitio NVARCHAR(500) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_fuente_adquisicion PRIMARY KEY (id_fuente_adquisicion),
    CONSTRAINT uq_fuente_adquisicion_nombre_fuente UNIQUE (nombre_fuente),
    CONSTRAINT ck_fuente_adquisicion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 045 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.suscripcion_lectura (
    id_suscripcion_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_fuente_adquisicion BIGINT NOT NULL,
    nombre_plan NVARCHAR(255) NOT NULL,
    estado_suscripcion NVARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_suscripcion_lectura PRIMARY KEY (id_suscripcion_lectura),
    CONSTRAINT ck_suscripcion_lectura_c1_fecha_vencimiento CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento >= fecha_inicio),
    CONSTRAINT ck_suscripcion_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 046 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.archivo_digital (
    id_archivo_digital BIGINT IDENTITY(1,1) NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    id_suscripcion_lectura BIGINT NULL,
    formato_archivo NVARCHAR(30) NOT NULL,
    ruta_almacenamiento NVARCHAR(500) NOT NULL,
    tamano_bytes BIGINT NOT NULL,
    hash_sha256 VARCHAR(64) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_archivo_digital PRIMARY KEY (id_archivo_digital),
    CONSTRAINT uq_archivo_digital_id_ejemplar_usuario UNIQUE (id_ejemplar_usuario),
    CONSTRAINT ck_archivo_digital_c1_tamano_bytes CHECK (tamano_bytes > 0),
    CONSTRAINT ck_archivo_digital_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 047 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.wishlist_item (
    id_wishlist_item BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_libro BIGINT NOT NULL,
    prioridad INT NOT NULL DEFAULT 3,
    nota_deseo NVARCHAR(255) NULL,
    fecha_agregado DATE NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_wishlist_item PRIMARY KEY (id_wishlist_item),
    CONSTRAINT uq_wishlist_item_comp UNIQUE (id_usuario, id_libro),
    CONSTRAINT ck_wishlist_item_c1_prioridad CHECK (prioridad BETWEEN 1 AND 5),
    CONSTRAINT ck_wishlist_item_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 048 [A8] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.adquisicion (
    id_adquisicion BIGINT IDENTITY(1,1) NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    id_fuente_adquisicion BIGINT NOT NULL,
    tipo_adquisicion NVARCHAR(50) NOT NULL,
    fecha_adquisicion DATE NOT NULL,
    precio_pagado DECIMAL(10,2) NULL,
    moneda VARCHAR(3) NOT NULL DEFAULT 'MXN',
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_adquisicion PRIMARY KEY (id_adquisicion),
    CONSTRAINT ck_adquisicion_c1_precio_pagado CHECK (precio_pagado >= 0),
    CONSTRAINT ck_adquisicion_c2_moneda CHECK (LEN(moneda) = 3),
    CONSTRAINT ck_adquisicion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 049 [A9] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.importacion_biblioteca (
    id_importacion_biblioteca BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    origen_plataforma NVARCHAR(80) NOT NULL,
    nombre_archivo NVARCHAR(255) NOT NULL,
    total_filas INT NOT NULL,
    filas_exitosas INT NOT NULL,
    estado_importacion NVARCHAR(50) NOT NULL,
    fecha_importacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_importacion_biblioteca PRIMARY KEY (id_importacion_biblioteca),
    CONSTRAINT ck_importacion_biblioteca_c1_total_filas CHECK (total_filas >= 0),
    CONSTRAINT ck_importacion_biblioteca_c2_filas_exitosas CHECK (filas_exitosas >= 0 AND filas_exitosas <= total_filas),
    CONSTRAINT ck_importacion_biblioteca_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 050 [A9] | Autor: Cesar Alexis De Luna Jiménez (Estudiante A)
CREATE TABLE dbo.detalle_importacion (
    id_detalle_importacion BIGINT IDENTITY(1,1) NOT NULL,
    id_importacion_biblioteca BIGINT NOT NULL,
    id_ejemplar_usuario BIGINT NULL,
    numero_fila INT NOT NULL,
    resultado_fila NVARCHAR(30) NOT NULL,
    mensaje_error NVARCHAR(255) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_detalle_importacion PRIMARY KEY (id_detalle_importacion),
    CONSTRAINT uq_detalle_importacion_comp UNIQUE (id_importacion_biblioteca, numero_fila),
    CONSTRAINT ck_detalle_importacion_c1_numero_fila CHECK (numero_fila >= 0),
    CONSTRAINT ck_detalle_importacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- =============================================================================
-- BLOQUE 2: ESTUDIANTE B — Gabriela Natalia De Leon Alvarez (Submodulos B1-B9, Tablas 51-100)
-- =============================================================================

-- Tabla 051 [B1] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.ciclo_lectura (
    id_ciclo_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_ejemplar_usuario BIGINT NOT NULL,
    numero_lectura INT NOT NULL DEFAULT 1,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado_ciclo NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_ciclo_lectura PRIMARY KEY (id_ciclo_lectura),
    CONSTRAINT uq_ciclo_lectura_comp UNIQUE (id_ejemplar_usuario, numero_lectura),
    CONSTRAINT ck_ciclo_lectura_c1_numero_lectura CHECK (numero_lectura >= 1),
    CONSTRAINT ck_ciclo_lectura_c2_fecha_fin CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT ck_ciclo_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 052 [B1] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.lugar_lectura (
    id_lugar_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_lugar NVARCHAR(255) NOT NULL,
    tipo_ambiente NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_lugar_lectura PRIMARY KEY (id_lugar_lectura),
    CONSTRAINT uq_lugar_lectura_comp UNIQUE (id_usuario, nombre_lugar),
    CONSTRAINT ck_lugar_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 053 [B1] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.sesion_lectura (
    id_sesion_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    id_lugar_lectura BIGINT NULL,
    id_dispositivo_usuario BIGINT NULL,
    fecha_inicio DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_fin DATETIME2(0) NULL,
    pagina_inicio INT NOT NULL,
    pagina_fin INT NOT NULL,
    minutos_netos INT NOT NULL,
    paginas_por_minuto DECIMAL(6,2) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_sesion_lectura PRIMARY KEY (id_sesion_lectura),
    CONSTRAINT ck_sesion_lectura_c1_pagina_inicio CHECK (pagina_inicio >= 0),
    CONSTRAINT ck_sesion_lectura_c2_pagina_fin CHECK (pagina_fin >= pagina_inicio),
    CONSTRAINT ck_sesion_lectura_c3_minutos_netos CHECK (minutos_netos >= 0),
    CONSTRAINT ck_sesion_lectura_c4_paginas_por_minuto CHECK (paginas_por_minuto >= 0),
    CONSTRAINT ck_sesion_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 054 [B1] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.pausa_sesion_lectura (
    id_pausa_sesion_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_sesion_lectura BIGINT NOT NULL,
    hora_inicio_pausa DATETIME2(0) NOT NULL,
    hora_fin_pausa DATETIME2(0) NULL,
    segundos_pausa INT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_pausa_sesion_lectura PRIMARY KEY (id_pausa_sesion_lectura),
    CONSTRAINT ck_pausa_sesion_lectura_c1_segundos_pausa CHECK (segundos_pausa >= 0),
    CONSTRAINT ck_pausa_sesion_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 055 [B1] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.progreso_lectura (
    id_progreso_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    id_sesion_lectura BIGINT NULL,
    pagina_actual INT NOT NULL,
    porcentaje_avance DECIMAL(5,2) NOT NULL,
    fecha_registro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_progreso_lectura PRIMARY KEY (id_progreso_lectura),
    CONSTRAINT ck_progreso_lectura_c1_porcentaje_avance CHECK (porcentaje_avance BETWEEN 0 AND 100),
    CONSTRAINT ck_progreso_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 056 [B2] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.tipo_nota (
    id_tipo_nota BIGINT IDENTITY(1,1) NOT NULL,
    codigo_tipo NVARCHAR(50) NOT NULL,
    nombre_tipo NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_tipo_nota PRIMARY KEY (id_tipo_nota),
    CONSTRAINT uq_tipo_nota_codigo_tipo UNIQUE (codigo_tipo),
    CONSTRAINT ck_tipo_nota_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 057 [B2] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.nota (
    id_nota BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    id_tipo_nota BIGINT NOT NULL,
    titulo_nota NVARCHAR(255) NOT NULL,
    contenido NVARCHAR(MAX) NOT NULL,
    numero_pagina INT NULL,
    capitulo NVARCHAR(80) NULL,
    es_privada BIT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_nota PRIMARY KEY (id_nota),
    CONSTRAINT ck_nota_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 058 [B2] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.cita (
    id_cita BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    texto_cita NVARCHAR(MAX) NOT NULL,
    numero_pagina INT NULL,
    comentario_personal NVARCHAR(255) NULL,
    es_favorita BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    CONSTRAINT ck_cita_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 059 [B2] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.nota_etiqueta (
    id_nota_etiqueta BIGINT IDENTITY(1,1) NOT NULL,
    id_nota BIGINT NOT NULL,
    id_etiqueta BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_nota_etiqueta PRIMARY KEY (id_nota_etiqueta),
    CONSTRAINT uq_nota_etiqueta_comp UNIQUE (id_nota, id_etiqueta),
    CONSTRAINT ck_nota_etiqueta_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 060 [B2] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.adjunto_nota (
    id_adjunto_nota BIGINT IDENTITY(1,1) NOT NULL,
    id_nota BIGINT NOT NULL,
    nombre_archivo NVARCHAR(255) NOT NULL,
    tipo_mime NVARCHAR(50) NOT NULL,
    ruta_archivo NVARCHAR(500) NOT NULL,
    tamano_bytes BIGINT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_adjunto_nota PRIMARY KEY (id_adjunto_nota),
    CONSTRAINT ck_adjunto_nota_c1_tamano_bytes CHECK (tamano_bytes > 0),
    CONSTRAINT ck_adjunto_nota_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 061 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.resena (
    id_resena BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    titulo_resena NVARCHAR(255) NOT NULL,
    contenido_resena NVARCHAR(MAX) NOT NULL,
    contiene_spoilers BIT NOT NULL DEFAULT 0,
    visibilidad NVARCHAR(30) NOT NULL DEFAULT 'PUBLICO',
    fecha_publicacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_resena PRIMARY KEY (id_resena),
    CONSTRAINT ck_resena_c1_visibilidad CHECK (visibilidad IN ('PUBLICO','PRIVADO','AMIGOS')),
    CONSTRAINT ck_resena_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 062 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.calificacion (
    id_calificacion BIGINT IDENTITY(1,1) NOT NULL,
    id_ciclo_lectura BIGINT NOT NULL,
    puntaje_global DECIMAL(3,2) NOT NULL,
    fecha_calificacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_calificacion PRIMARY KEY (id_calificacion),
    CONSTRAINT uq_calificacion_id_ciclo_lectura UNIQUE (id_ciclo_lectura),
    CONSTRAINT ck_calificacion_c1_puntaje_global CHECK (puntaje_global BETWEEN 1.0 AND 5.0),
    CONSTRAINT ck_calificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 063 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.criterio_calificacion (
    id_criterio_calificacion BIGINT IDENTITY(1,1) NOT NULL,
    codigo_criterio NVARCHAR(50) NOT NULL,
    nombre_criterio NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_criterio_calificacion PRIMARY KEY (id_criterio_calificacion),
    CONSTRAINT uq_criterio_calificacion_codigo_criterio UNIQUE (codigo_criterio),
    CONSTRAINT ck_criterio_calificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 064 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.calificacion_criterio (
    id_calificacion_criterio BIGINT IDENTITY(1,1) NOT NULL,
    id_calificacion BIGINT NOT NULL,
    id_criterio_calificacion BIGINT NOT NULL,
    puntaje_criterio DECIMAL(3,2) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_calificacion_criterio PRIMARY KEY (id_calificacion_criterio),
    CONSTRAINT uq_calificacion_criterio_comp UNIQUE (id_calificacion, id_criterio_calificacion),
    CONSTRAINT ck_calificacion_criterio_c1_puntaje_criterio CHECK (puntaje_criterio BETWEEN 1.0 AND 5.0),
    CONSTRAINT ck_calificacion_criterio_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 065 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.resena_reaccion (
    id_resena_reaccion BIGINT IDENTITY(1,1) NOT NULL,
    id_resena BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    tipo_reaccion NVARCHAR(50) NOT NULL,
    fecha_reaccion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_resena_reaccion PRIMARY KEY (id_resena_reaccion),
    CONSTRAINT uq_resena_reaccion_comp UNIQUE (id_resena, id_usuario),
    CONSTRAINT ck_resena_reaccion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 066 [B3] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.resena_comentario (
    id_resena_comentario BIGINT IDENTITY(1,1) NOT NULL,
    id_resena BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    contenido_comentario NVARCHAR(MAX) NOT NULL,
    fecha_comentario DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_resena_comentario PRIMARY KEY (id_resena_comentario),
    CONSTRAINT ck_resena_comentario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 067 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.tipo_meta (
    id_tipo_meta BIGINT IDENTITY(1,1) NOT NULL,
    codigo_tipo NVARCHAR(50) NOT NULL,
    nombre_tipo NVARCHAR(255) NOT NULL,
    unidad_medida NVARCHAR(80) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_tipo_meta PRIMARY KEY (id_tipo_meta),
    CONSTRAINT uq_tipo_meta_codigo_tipo UNIQUE (codigo_tipo),
    CONSTRAINT ck_tipo_meta_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 068 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.meta_lectura (
    id_meta_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_tipo_meta BIGINT NOT NULL,
    titulo_meta NVARCHAR(255) NOT NULL,
    valor_objetivo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado_meta NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_meta_lectura PRIMARY KEY (id_meta_lectura),
    CONSTRAINT ck_meta_lectura_c1_valor_objetivo CHECK (valor_objetivo > 0),
    CONSTRAINT ck_meta_lectura_c2_fecha_fin CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT ck_meta_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 069 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.progreso_meta (
    id_progreso_meta BIGINT IDENTITY(1,1) NOT NULL,
    id_meta_lectura BIGINT NOT NULL,
    valor_acumulado INT NOT NULL,
    porcentaje_cumplimiento DECIMAL(5,2) NOT NULL,
    fecha_corte DATE NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_progreso_meta PRIMARY KEY (id_progreso_meta),
    CONSTRAINT ck_progreso_meta_c1_valor_acumulado CHECK (valor_acumulado >= 0),
    CONSTRAINT ck_progreso_meta_c2_porcentaje_cumplimiento CHECK (porcentaje_cumplimiento BETWEEN 0 AND 100),
    CONSTRAINT ck_progreso_meta_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 070 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.habito_lectura (
    id_habito_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_habito NVARCHAR(255) NOT NULL,
    minutos_objetivo_diario INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    activo_habito BIT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_habito_lectura PRIMARY KEY (id_habito_lectura),
    CONSTRAINT ck_habito_lectura_c1_minutos_objetivo_diario CHECK (minutos_objetivo_diario > 0),
    CONSTRAINT ck_habito_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 071 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.habito_programacion (
    id_habito_programacion BIGINT IDENTITY(1,1) NOT NULL,
    id_habito_lectura BIGINT NOT NULL,
    dia_semana INT NOT NULL,
    hora_programada TIME(0) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_habito_programacion PRIMARY KEY (id_habito_programacion),
    CONSTRAINT uq_habito_programacion_comp UNIQUE (id_habito_lectura, dia_semana, hora_programada),
    CONSTRAINT ck_habito_programacion_c1_dia_semana CHECK (dia_semana BETWEEN 1 AND 7),
    CONSTRAINT ck_habito_programacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 072 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.registro_habito (
    id_registro_habito BIGINT IDENTITY(1,1) NOT NULL,
    id_habito_lectura BIGINT NOT NULL,
    id_sesion_lectura BIGINT NULL,
    fecha_cumplimiento DATE NOT NULL,
    minutos_registrados INT NOT NULL,
    cumplido BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_registro_habito PRIMARY KEY (id_registro_habito),
    CONSTRAINT uq_registro_habito_comp UNIQUE (id_habito_lectura, fecha_cumplimiento),
    CONSTRAINT ck_registro_habito_c1_minutos_registrados CHECK (minutos_registrados >= 0),
    CONSTRAINT ck_registro_habito_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 073 [B4] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.racha_lectura (
    id_racha_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_habito_lectura BIGINT NOT NULL,
    fecha_inicio_racha DATE NOT NULL,
    fecha_fin_racha DATE NULL,
    dias_consecutivos INT NOT NULL,
    es_racha_actual BIT NOT NULL DEFAULT 0,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_racha_lectura PRIMARY KEY (id_racha_lectura),
    CONSTRAINT ck_racha_lectura_c1_fecha_fin_racha CHECK (fecha_fin_racha IS NULL OR fecha_fin_racha >= fecha_inicio_racha),
    CONSTRAINT ck_racha_lectura_c2_dias_consecutivos CHECK (dias_consecutivos >= 0),
    CONSTRAINT ck_racha_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 074 [B5] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.canal_notificacion (
    id_canal_notificacion BIGINT IDENTITY(1,1) NOT NULL,
    codigo_canal NVARCHAR(50) NOT NULL,
    nombre_canal NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_canal_notificacion PRIMARY KEY (id_canal_notificacion),
    CONSTRAINT uq_canal_notificacion_codigo_canal UNIQUE (codigo_canal),
    CONSTRAINT ck_canal_notificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 075 [B5] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.tipo_evento_notificacion (
    id_tipo_evento_notificacion BIGINT IDENTITY(1,1) NOT NULL,
    codigo_evento NVARCHAR(50) NOT NULL,
    nombre_evento NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_tipo_evento_notificacion PRIMARY KEY (id_tipo_evento_notificacion),
    CONSTRAINT uq_tipo_evento_notificacion_codigo_evento UNIQUE (codigo_evento),
    CONSTRAINT ck_tipo_evento_notificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 076 [B5] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.recordatorio (
    id_recordatorio BIGINT IDENTITY(1,1) NOT NULL,
    id_habito_lectura BIGINT NULL,
    id_meta_lectura BIGINT NULL,
    id_canal_notificacion BIGINT NOT NULL,
    hora_recordatorio TIME(0) NOT NULL,
    frecuencia NVARCHAR(30) NOT NULL,
    activo_recordatorio BIT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_recordatorio PRIMARY KEY (id_recordatorio),
    CONSTRAINT ck_recordatorio_c1_id_habito_lectura CHECK (id_habito_lectura IS NOT NULL OR id_meta_lectura IS NOT NULL),
    CONSTRAINT ck_recordatorio_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 077 [B5] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.preferencia_notificacion (
    id_preferencia_notificacion BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_canal_notificacion BIGINT NOT NULL,
    id_tipo_evento_notificacion BIGINT NOT NULL,
    habilitado BIT NOT NULL DEFAULT 1,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_preferencia_notificacion PRIMARY KEY (id_preferencia_notificacion),
    CONSTRAINT uq_preferencia_notificacion_comp UNIQUE (id_usuario, id_canal_notificacion, id_tipo_evento_notificacion),
    CONSTRAINT ck_preferencia_notificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 078 [B5] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.notificacion (
    id_notificacion BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_tipo_evento_notificacion BIGINT NOT NULL,
    id_canal_notificacion BIGINT NOT NULL,
    titulo NVARCHAR(255) NOT NULL,
    mensaje NVARCHAR(MAX) NOT NULL,
    leida BIT NOT NULL DEFAULT 0,
    fecha_envio DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_lectura DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_notificacion PRIMARY KEY (id_notificacion),
    CONSTRAINT ck_notificacion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 079 [B6] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.logro (
    id_logro BIGINT IDENTITY(1,1) NOT NULL,
    codigo_logro NVARCHAR(50) NOT NULL,
    nombre_logro NVARCHAR(255) NOT NULL,
    criterio_obtencion NVARCHAR(255) NOT NULL,
    puntos_recompensa INT NOT NULL,
    icono_url NVARCHAR(100) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_logro PRIMARY KEY (id_logro),
    CONSTRAINT uq_logro_codigo_logro UNIQUE (codigo_logro),
    CONSTRAINT ck_logro_c1_puntos_recompensa CHECK (puntos_recompensa >= 0),
    CONSTRAINT ck_logro_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 080 [B6] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.logro_usuario (
    id_logro_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_logro BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    fecha_obtencion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_logro_usuario PRIMARY KEY (id_logro_usuario),
    CONSTRAINT uq_logro_usuario_comp UNIQUE (id_logro, id_usuario),
    CONSTRAINT ck_logro_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 081 [B6] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.nivel_lector (
    id_nivel_lector BIGINT IDENTITY(1,1) NOT NULL,
    numero_nivel INT NOT NULL,
    nombre_nivel NVARCHAR(255) NOT NULL,
    puntos_minimos INT NOT NULL,
    puntos_maximos INT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_nivel_lector PRIMARY KEY (id_nivel_lector),
    CONSTRAINT uq_nivel_lector_numero_nivel UNIQUE (numero_nivel),
    CONSTRAINT uq_nivel_lector_nombre_nivel UNIQUE (nombre_nivel),
    CONSTRAINT ck_nivel_lector_c1_puntos_minimos CHECK (puntos_minimos >= 0),
    CONSTRAINT ck_nivel_lector_c2_puntos_maximos CHECK (puntos_maximos >= puntos_minimos),
    CONSTRAINT ck_nivel_lector_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 082 [B6] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.movimiento_puntos (
    id_movimiento_puntos BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_logro BIGINT NULL,
    tipo_movimiento NVARCHAR(50) NOT NULL,
    cantidad_puntos INT NOT NULL,
    motivo NVARCHAR(255) NOT NULL,
    fecha_movimiento DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_movimiento_puntos PRIMARY KEY (id_movimiento_puntos),
    CONSTRAINT ck_movimiento_puntos_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 083 [B7] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.estadistica_diaria (
    id_estadistica_diaria BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    fecha_estadistica DATE NOT NULL,
    minutos_leidos INT NOT NULL,
    paginas_leidas INT NOT NULL,
    sesiones_completadas INT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_estadistica_diaria PRIMARY KEY (id_estadistica_diaria),
    CONSTRAINT uq_estadistica_diaria_comp UNIQUE (id_usuario, fecha_estadistica),
    CONSTRAINT ck_estadistica_diaria_c1_minutos_leidos CHECK (minutos_leidos >= 0),
    CONSTRAINT ck_estadistica_diaria_c2_paginas_leidas CHECK (paginas_leidas >= 0),
    CONSTRAINT ck_estadistica_diaria_c3_sesiones_completadas CHECK (sesiones_completadas >= 0),
    CONSTRAINT ck_estadistica_diaria_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 084 [B7] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.estadistica_mensual (
    id_estadistica_mensual BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_nivel_lector BIGINT NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    total_minutos INT NOT NULL,
    total_paginas INT NOT NULL,
    libros_terminados INT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_estadistica_mensual PRIMARY KEY (id_estadistica_mensual),
    CONSTRAINT uq_estadistica_mensual_comp UNIQUE (id_usuario, anio, mes),
    CONSTRAINT ck_estadistica_mensual_c1_anio CHECK (anio BETWEEN 2000 AND 2100),
    CONSTRAINT ck_estadistica_mensual_c2_mes CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT ck_estadistica_mensual_c3_total_minutos CHECK (total_minutos >= 0),
    CONSTRAINT ck_estadistica_mensual_c4_total_paginas CHECK (total_paginas >= 0),
    CONSTRAINT ck_estadistica_mensual_c5_libros_terminados CHECK (libros_terminados >= 0),
    CONSTRAINT ck_estadistica_mensual_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 085 [B7] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.reporte_generado (
    id_reporte_generado BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    tipo_reporte NVARCHAR(50) NOT NULL,
    formato_exportacion NVARCHAR(30) NOT NULL,
    ruta_archivo NVARCHAR(500) NOT NULL,
    fecha_generacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_reporte_generado PRIMARY KEY (id_reporte_generado),
    CONSTRAINT ck_reporte_generado_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 086 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.club_lectura (
    id_club_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_club NVARCHAR(255) NOT NULL,
    privacidad NVARCHAR(30) NOT NULL DEFAULT 'PUBLICO',
    limite_miembros INT NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_club_lectura PRIMARY KEY (id_club_lectura),
    CONSTRAINT uq_club_lectura_nombre_club UNIQUE (nombre_club),
    CONSTRAINT ck_club_lectura_c1_privacidad CHECK (privacidad IN ('PUBLICO','PRIVADO','AMIGOS')),
    CONSTRAINT ck_club_lectura_c2_limite_miembros CHECK (limite_miembros > 0),
    CONSTRAINT ck_club_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 087 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.rol_club (
    id_rol_club BIGINT IDENTITY(1,1) NOT NULL,
    codigo_rol_club NVARCHAR(50) NOT NULL,
    nombre_rol_club NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_rol_club PRIMARY KEY (id_rol_club),
    CONSTRAINT uq_rol_club_codigo_rol_club UNIQUE (codigo_rol_club),
    CONSTRAINT ck_rol_club_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 088 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.miembro_club (
    id_miembro_club BIGINT IDENTITY(1,1) NOT NULL,
    id_club_lectura BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_rol_club BIGINT NOT NULL,
    fecha_ingreso DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_miembro_club PRIMARY KEY (id_miembro_club),
    CONSTRAINT uq_miembro_club_comp UNIQUE (id_club_lectura, id_usuario),
    CONSTRAINT ck_miembro_club_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 089 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.libro_club (
    id_libro_club BIGINT IDENTITY(1,1) NOT NULL,
    id_club_lectura BIGINT NOT NULL,
    id_libro BIGINT NOT NULL,
    fecha_inicio_lectura DATE NOT NULL,
    fecha_fin_lectura DATE NULL,
    estado_lectura_club NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_libro_club PRIMARY KEY (id_libro_club),
    CONSTRAINT ck_libro_club_c1_fecha_fin_lectura CHECK (fecha_fin_lectura IS NULL OR fecha_fin_lectura >= fecha_inicio_lectura),
    CONSTRAINT ck_libro_club_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 090 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.reunion_club (
    id_reunion_club BIGINT IDENTITY(1,1) NOT NULL,
    id_club_lectura BIGINT NOT NULL,
    id_libro_club BIGINT NULL,
    titulo_reunion NVARCHAR(255) NOT NULL,
    fecha_reunion DATETIME2(0) NOT NULL,
    modalidad NVARCHAR(30) NOT NULL,
    enlace_o_lugar NVARCHAR(500) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_reunion_club PRIMARY KEY (id_reunion_club),
    CONSTRAINT ck_reunion_club_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 091 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.asistencia_reunion (
    id_asistencia_reunion BIGINT IDENTITY(1,1) NOT NULL,
    id_reunion_club BIGINT NOT NULL,
    id_miembro_club BIGINT NOT NULL,
    estado_asistencia NVARCHAR(50) NOT NULL,
    fecha_confirmacion DATETIME2(0) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_asistencia_reunion PRIMARY KEY (id_asistencia_reunion),
    CONSTRAINT uq_asistencia_reunion_comp UNIQUE (id_reunion_club, id_miembro_club),
    CONSTRAINT ck_asistencia_reunion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 092 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.mensaje_club (
    id_mensaje_club BIGINT IDENTITY(1,1) NOT NULL,
    id_club_lectura BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    contenido_mensaje NVARCHAR(MAX) NOT NULL,
    fecha_publicacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_mensaje_club PRIMARY KEY (id_mensaje_club),
    CONSTRAINT ck_mensaje_club_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 093 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.seguimiento_usuario (
    id_seguimiento_usuario BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario_seguidor BIGINT NOT NULL,
    id_usuario_seguido BIGINT NOT NULL,
    fecha_seguimiento DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_seguimiento_usuario PRIMARY KEY (id_seguimiento_usuario),
    CONSTRAINT uq_seguimiento_usuario_comp UNIQUE (id_usuario_seguidor, id_usuario_seguido),
    CONSTRAINT ck_seguimiento_usuario_c1_id_usuario_seguidor CHECK (id_usuario_seguidor <> id_usuario_seguido),
    CONSTRAINT ck_seguimiento_usuario_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 094 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.reto_lectura (
    id_reto_lectura BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    nombre_reto NVARCHAR(255) NOT NULL,
    meta_libros INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_reto_lectura PRIMARY KEY (id_reto_lectura),
    CONSTRAINT ck_reto_lectura_c1_meta_libros CHECK (meta_libros > 0),
    CONSTRAINT ck_reto_lectura_c2_fecha_fin CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT ck_reto_lectura_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 095 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.participante_reto (
    id_participante_reto BIGINT IDENTITY(1,1) NOT NULL,
    id_reto_lectura BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    avance_libros INT NOT NULL,
    completado BIT NOT NULL DEFAULT 0,
    fecha_inscripcion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_participante_reto PRIMARY KEY (id_participante_reto),
    CONSTRAINT uq_participante_reto_comp UNIQUE (id_reto_lectura, id_usuario),
    CONSTRAINT ck_participante_reto_c1_avance_libros CHECK (avance_libros >= 0),
    CONSTRAINT ck_participante_reto_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 096 [B8] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.recomendacion_libro (
    id_recomendacion_libro BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario_emisor BIGINT NOT NULL,
    id_usuario_receptor BIGINT NOT NULL,
    id_libro BIGINT NOT NULL,
    mensaje_recomendacion NVARCHAR(255) NULL,
    vista BIT NOT NULL DEFAULT 0,
    fecha_recomendacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_recomendacion_libro PRIMARY KEY (id_recomendacion_libro),
    CONSTRAINT ck_recomendacion_libro_c1_id_usuario_emisor CHECK (id_usuario_emisor <> id_usuario_receptor),
    CONSTRAINT ck_recomendacion_libro_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 097 [B9] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.auditoria_transaccion (
    id_auditoria_transaccion BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NULL,
    nombre_tabla NVARCHAR(80) NOT NULL,
    id_registro_afectado BIGINT NOT NULL,
    tipo_operacion NVARCHAR(30) NOT NULL,
    ip_origen VARCHAR(50) NULL,
    fecha_operacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_auditoria_transaccion PRIMARY KEY (id_auditoria_transaccion),
    CONSTRAINT ck_auditoria_transaccion_c1_tipo_operacion CHECK (tipo_operacion IN ('INSERT','UPDATE','BAJA_LOGICA')),
    CONSTRAINT ck_auditoria_transaccion_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 098 [B9] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.auditoria_detalle_cambio (
    id_auditoria_detalle_cambio BIGINT IDENTITY(1,1) NOT NULL,
    id_auditoria_transaccion BIGINT NOT NULL,
    nombre_columna NVARCHAR(80) NOT NULL,
    valor_anterior NVARCHAR(MAX) NULL,
    valor_nuevo NVARCHAR(MAX) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_auditoria_detalle_cambio PRIMARY KEY (id_auditoria_detalle_cambio),
    CONSTRAINT ck_auditoria_detalle_cambio_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 099 [B9] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.sincronizacion_dispositivo (
    id_sincronizacion_dispositivo BIGINT IDENTITY(1,1) NOT NULL,
    id_dispositivo_usuario BIGINT NOT NULL,
    tipo_sincronizacion NVARCHAR(50) NOT NULL,
    registros_sincronizados INT NOT NULL,
    resultado_sync NVARCHAR(30) NOT NULL,
    fecha_sincronizacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_sincronizacion_dispositivo PRIMARY KEY (id_sincronizacion_dispositivo),
    CONSTRAINT ck_sincronizacion_dispositivo_c1_registros_sincronizados CHECK (registros_sincronizados >= 0),
    CONSTRAINT ck_sincronizacion_dispositivo_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- Tabla 100 [B9] | Autor: Gabriela Natalia De León Alvarez (Estudiante B)
CREATE TABLE dbo.exportacion_datos (
    id_exportacion_datos BIGINT IDENTITY(1,1) NOT NULL,
    id_usuario BIGINT NOT NULL,
    formato_archivo NVARCHAR(30) NOT NULL,
    estado_exportacion NVARCHAR(50) NOT NULL,
    hash_sha256 VARCHAR(64) NOT NULL,
    fecha_solicitud DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    fecha_expiracion DATETIME2(0) NULL,
    descripcion NVARCHAR(255) NULL,
    creado_por BIGINT NOT NULL,
    fecha_creacion DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    modificado_por BIGINT NULL,
    fecha_modificacion DATETIME2(0) NULL,
    eliminado_por BIGINT NULL,
    fecha_eliminacion DATETIME2(0) NULL,
    estatus VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT pk_exportacion_datos PRIMARY KEY (id_exportacion_datos),
    CONSTRAINT ck_exportacion_datos_estatus CHECK (estatus IN ('ACTIVO','INACTIVO'))
);
GO

-- =============================================================================
-- INTEGRIDAD REFERENCIAL (132 FKs de Negocio + 300 FKs de Auditoria = 432 FKs)
-- Politica: ON DELETE NO ACTION ON UPDATE NO ACTION (Baja logica obligatoria)
-- =============================================================================

-- FKs de Tablas del Estudiante A (Cesar Alexis De Luna Jimenez)
ALTER TABLE dbo.usuario ADD CONSTRAINT fk_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario ADD CONSTRAINT fk_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario ADD CONSTRAINT fk_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.perfil_usuario ADD CONSTRAINT fk_perfil_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.perfil_usuario ADD CONSTRAINT fk_perfil_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.perfil_usuario ADD CONSTRAINT fk_perfil_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.perfil_usuario ADD CONSTRAINT fk_perfil_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.credencial_usuario ADD CONSTRAINT fk_credencial_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.credencial_usuario ADD CONSTRAINT fk_credencial_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.credencial_usuario ADD CONSTRAINT fk_credencial_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.credencial_usuario ADD CONSTRAINT fk_credencial_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.historial_credencial ADD CONSTRAINT fk_historial_credencial_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.historial_credencial ADD CONSTRAINT fk_historial_credencial_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.historial_credencial ADD CONSTRAINT fk_historial_credencial_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.historial_credencial ADD CONSTRAINT fk_historial_credencial_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.politica_contrasena ADD CONSTRAINT fk_politica_contrasena_id_rol FOREIGN KEY (id_rol) REFERENCES dbo.rol (id_rol) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.politica_contrasena ADD CONSTRAINT fk_politica_contrasena_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.politica_contrasena ADD CONSTRAINT fk_politica_contrasena_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.politica_contrasena ADD CONSTRAINT fk_politica_contrasena_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol ADD CONSTRAINT fk_rol_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol ADD CONSTRAINT fk_rol_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol ADD CONSTRAINT fk_rol_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.permiso ADD CONSTRAINT fk_permiso_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.permiso ADD CONSTRAINT fk_permiso_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.permiso ADD CONSTRAINT fk_permiso_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_permiso ADD CONSTRAINT fk_rol_permiso_id_rol FOREIGN KEY (id_rol) REFERENCES dbo.rol (id_rol) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_permiso ADD CONSTRAINT fk_rol_permiso_id_permiso FOREIGN KEY (id_permiso) REFERENCES dbo.permiso (id_permiso) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_permiso ADD CONSTRAINT fk_rol_permiso_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_permiso ADD CONSTRAINT fk_rol_permiso_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_permiso ADD CONSTRAINT fk_rol_permiso_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario_rol ADD CONSTRAINT fk_usuario_rol_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario_rol ADD CONSTRAINT fk_usuario_rol_id_rol FOREIGN KEY (id_rol) REFERENCES dbo.rol (id_rol) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario_rol ADD CONSTRAINT fk_usuario_rol_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario_rol ADD CONSTRAINT fk_usuario_rol_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.usuario_rol ADD CONSTRAINT fk_usuario_rol_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_usuario ADD CONSTRAINT fk_sesion_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_usuario ADD CONSTRAINT fk_sesion_usuario_id_dispositivo_usuario FOREIGN KEY (id_dispositivo_usuario) REFERENCES dbo.dispositivo_usuario (id_dispositivo_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_usuario ADD CONSTRAINT fk_sesion_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_usuario ADD CONSTRAINT fk_sesion_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_usuario ADD CONSTRAINT fk_sesion_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bitacora_acceso ADD CONSTRAINT fk_bitacora_acceso_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bitacora_acceso ADD CONSTRAINT fk_bitacora_acceso_id_sesion_usuario FOREIGN KEY (id_sesion_usuario) REFERENCES dbo.sesion_usuario (id_sesion_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bitacora_acceso ADD CONSTRAINT fk_bitacora_acceso_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bitacora_acceso ADD CONSTRAINT fk_bitacora_acceso_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bitacora_acceso ADD CONSTRAINT fk_bitacora_acceso_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bloqueo_cuenta ADD CONSTRAINT fk_bloqueo_cuenta_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bloqueo_cuenta ADD CONSTRAINT fk_bloqueo_cuenta_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bloqueo_cuenta ADD CONSTRAINT fk_bloqueo_cuenta_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.bloqueo_cuenta ADD CONSTRAINT fk_bloqueo_cuenta_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.token_recuperacion ADD CONSTRAINT fk_token_recuperacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.token_recuperacion ADD CONSTRAINT fk_token_recuperacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.token_recuperacion ADD CONSTRAINT fk_token_recuperacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.token_recuperacion ADD CONSTRAINT fk_token_recuperacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.metodo_2fa ADD CONSTRAINT fk_metodo_2fa_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.metodo_2fa ADD CONSTRAINT fk_metodo_2fa_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.metodo_2fa ADD CONSTRAINT fk_metodo_2fa_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.metodo_2fa ADD CONSTRAINT fk_metodo_2fa_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.codigo_respaldo_2fa ADD CONSTRAINT fk_codigo_respaldo_2fa_id_metodo_2fa FOREIGN KEY (id_metodo_2fa) REFERENCES dbo.metodo_2fa (id_metodo_2fa) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.codigo_respaldo_2fa ADD CONSTRAINT fk_codigo_respaldo_2fa_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.codigo_respaldo_2fa ADD CONSTRAINT fk_codigo_respaldo_2fa_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.codigo_respaldo_2fa ADD CONSTRAINT fk_codigo_respaldo_2fa_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.dispositivo_usuario ADD CONSTRAINT fk_dispositivo_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.dispositivo_usuario ADD CONSTRAINT fk_dispositivo_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.dispositivo_usuario ADD CONSTRAINT fk_dispositivo_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.dispositivo_usuario ADD CONSTRAINT fk_dispositivo_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.idioma ADD CONSTRAINT fk_idioma_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.idioma ADD CONSTRAINT fk_idioma_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.idioma ADD CONSTRAINT fk_idioma_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_usuario ADD CONSTRAINT fk_preferencia_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_usuario ADD CONSTRAINT fk_preferencia_usuario_id_idioma FOREIGN KEY (id_idioma) REFERENCES dbo.idioma (id_idioma) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_usuario ADD CONSTRAINT fk_preferencia_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_usuario ADD CONSTRAINT fk_preferencia_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_usuario ADD CONSTRAINT fk_preferencia_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.version_aviso_privacidad ADD CONSTRAINT fk_version_aviso_privacidad_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.version_aviso_privacidad ADD CONSTRAINT fk_version_aviso_privacidad_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.version_aviso_privacidad ADD CONSTRAINT fk_version_aviso_privacidad_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.consentimiento_privacidad ADD CONSTRAINT fk_consentimiento_privacidad_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.consentimiento_privacidad ADD CONSTRAINT fk_consentimiento_privacidad_id_version_aviso_privacidad FOREIGN KEY (id_version_aviso_privacidad) REFERENCES dbo.version_aviso_privacidad (id_version_aviso_privacidad) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.consentimiento_privacidad ADD CONSTRAINT fk_consentimiento_privacidad_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.consentimiento_privacidad ADD CONSTRAINT fk_consentimiento_privacidad_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.consentimiento_privacidad ADD CONSTRAINT fk_consentimiento_privacidad_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_solicitud_arco ADD CONSTRAINT fk_tipo_solicitud_arco_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_solicitud_arco ADD CONSTRAINT fk_tipo_solicitud_arco_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_solicitud_arco ADD CONSTRAINT fk_tipo_solicitud_arco_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.solicitud_arco ADD CONSTRAINT fk_solicitud_arco_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.solicitud_arco ADD CONSTRAINT fk_solicitud_arco_id_tipo_solicitud_arco FOREIGN KEY (id_tipo_solicitud_arco) REFERENCES dbo.tipo_solicitud_arco (id_tipo_solicitud_arco) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.solicitud_arco ADD CONSTRAINT fk_solicitud_arco_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.solicitud_arco ADD CONSTRAINT fk_solicitud_arco_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.solicitud_arco ADD CONSTRAINT fk_solicitud_arco_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.autor ADD CONSTRAINT fk_autor_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.autor ADD CONSTRAINT fk_autor_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.autor ADD CONSTRAINT fk_autor_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.editorial ADD CONSTRAINT fk_editorial_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.editorial ADD CONSTRAINT fk_editorial_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.editorial ADD CONSTRAINT fk_editorial_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro ADD CONSTRAINT fk_libro_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro ADD CONSTRAINT fk_libro_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro ADD CONSTRAINT fk_libro_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_colaborador ADD CONSTRAINT fk_tipo_colaborador_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_colaborador ADD CONSTRAINT fk_tipo_colaborador_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_colaborador ADD CONSTRAINT fk_tipo_colaborador_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_id_autor FOREIGN KEY (id_autor) REFERENCES dbo.autor (id_autor) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_id_tipo_colaborador FOREIGN KEY (id_tipo_colaborador) REFERENCES dbo.tipo_colaborador (id_tipo_colaborador) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_autor ADD CONSTRAINT fk_libro_autor_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.formato_libro ADD CONSTRAINT fk_formato_libro_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.formato_libro ADD CONSTRAINT fk_formato_libro_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.formato_libro ADD CONSTRAINT fk_formato_libro_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_id_editorial FOREIGN KEY (id_editorial) REFERENCES dbo.editorial (id_editorial) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_id_idioma FOREIGN KEY (id_idioma) REFERENCES dbo.idioma (id_idioma) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_id_formato_libro FOREIGN KEY (id_formato_libro) REFERENCES dbo.formato_libro (id_formato_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.edicion ADD CONSTRAINT fk_edicion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.genero ADD CONSTRAINT fk_genero_id_genero_padre FOREIGN KEY (id_genero_padre) REFERENCES dbo.genero (id_genero) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.genero ADD CONSTRAINT fk_genero_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.genero ADD CONSTRAINT fk_genero_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.genero ADD CONSTRAINT fk_genero_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_genero ADD CONSTRAINT fk_libro_genero_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_genero ADD CONSTRAINT fk_libro_genero_id_genero FOREIGN KEY (id_genero) REFERENCES dbo.genero (id_genero) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_genero ADD CONSTRAINT fk_libro_genero_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_genero ADD CONSTRAINT fk_libro_genero_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_genero ADD CONSTRAINT fk_libro_genero_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.serie_libro ADD CONSTRAINT fk_serie_libro_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.serie_libro ADD CONSTRAINT fk_serie_libro_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.serie_libro ADD CONSTRAINT fk_serie_libro_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_serie ADD CONSTRAINT fk_libro_serie_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_serie ADD CONSTRAINT fk_libro_serie_id_serie_libro FOREIGN KEY (id_serie_libro) REFERENCES dbo.serie_libro (id_serie_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_serie ADD CONSTRAINT fk_libro_serie_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_serie ADD CONSTRAINT fk_libro_serie_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_serie ADD CONSTRAINT fk_libro_serie_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estado_lectura ADD CONSTRAINT fk_estado_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estado_lectura ADD CONSTRAINT fk_estado_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estado_lectura ADD CONSTRAINT fk_estado_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_id_edicion FOREIGN KEY (id_edicion) REFERENCES dbo.edicion (id_edicion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_id_estado_lectura FOREIGN KEY (id_estado_lectura) REFERENCES dbo.estado_lectura (id_estado_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ejemplar_usuario ADD CONSTRAINT fk_ejemplar_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta ADD CONSTRAINT fk_etiqueta_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta ADD CONSTRAINT fk_etiqueta_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta ADD CONSTRAINT fk_etiqueta_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta ADD CONSTRAINT fk_etiqueta_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta_ejemplar ADD CONSTRAINT fk_etiqueta_ejemplar_id_etiqueta FOREIGN KEY (id_etiqueta) REFERENCES dbo.etiqueta (id_etiqueta) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta_ejemplar ADD CONSTRAINT fk_etiqueta_ejemplar_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta_ejemplar ADD CONSTRAINT fk_etiqueta_ejemplar_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta_ejemplar ADD CONSTRAINT fk_etiqueta_ejemplar_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.etiqueta_ejemplar ADD CONSTRAINT fk_etiqueta_ejemplar_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante ADD CONSTRAINT fk_estante_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante ADD CONSTRAINT fk_estante_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante ADD CONSTRAINT fk_estante_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante ADD CONSTRAINT fk_estante_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante_ejemplar ADD CONSTRAINT fk_estante_ejemplar_id_estante FOREIGN KEY (id_estante) REFERENCES dbo.estante (id_estante) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante_ejemplar ADD CONSTRAINT fk_estante_ejemplar_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante_ejemplar ADD CONSTRAINT fk_estante_ejemplar_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante_ejemplar ADD CONSTRAINT fk_estante_ejemplar_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estante_ejemplar ADD CONSTRAINT fk_estante_ejemplar_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion ADD CONSTRAINT fk_coleccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion ADD CONSTRAINT fk_coleccion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion ADD CONSTRAINT fk_coleccion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion ADD CONSTRAINT fk_coleccion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion_ejemplar ADD CONSTRAINT fk_coleccion_ejemplar_id_coleccion FOREIGN KEY (id_coleccion) REFERENCES dbo.coleccion (id_coleccion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion_ejemplar ADD CONSTRAINT fk_coleccion_ejemplar_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion_ejemplar ADD CONSTRAINT fk_coleccion_ejemplar_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion_ejemplar ADD CONSTRAINT fk_coleccion_ejemplar_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.coleccion_ejemplar ADD CONSTRAINT fk_coleccion_ejemplar_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ubicacion_fisica ADD CONSTRAINT fk_ubicacion_fisica_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ubicacion_fisica ADD CONSTRAINT fk_ubicacion_fisica_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ubicacion_fisica ADD CONSTRAINT fk_ubicacion_fisica_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ubicacion_fisica ADD CONSTRAINT fk_ubicacion_fisica_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.copia_fisica ADD CONSTRAINT fk_copia_fisica_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.copia_fisica ADD CONSTRAINT fk_copia_fisica_id_ubicacion_fisica FOREIGN KEY (id_ubicacion_fisica) REFERENCES dbo.ubicacion_fisica (id_ubicacion_fisica) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.copia_fisica ADD CONSTRAINT fk_copia_fisica_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.copia_fisica ADD CONSTRAINT fk_copia_fisica_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.copia_fisica ADD CONSTRAINT fk_copia_fisica_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.fuente_adquisicion ADD CONSTRAINT fk_fuente_adquisicion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.fuente_adquisicion ADD CONSTRAINT fk_fuente_adquisicion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.fuente_adquisicion ADD CONSTRAINT fk_fuente_adquisicion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.suscripcion_lectura ADD CONSTRAINT fk_suscripcion_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.suscripcion_lectura ADD CONSTRAINT fk_suscripcion_lectura_id_fuente_adquisicion FOREIGN KEY (id_fuente_adquisicion) REFERENCES dbo.fuente_adquisicion (id_fuente_adquisicion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.suscripcion_lectura ADD CONSTRAINT fk_suscripcion_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.suscripcion_lectura ADD CONSTRAINT fk_suscripcion_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.suscripcion_lectura ADD CONSTRAINT fk_suscripcion_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.archivo_digital ADD CONSTRAINT fk_archivo_digital_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.archivo_digital ADD CONSTRAINT fk_archivo_digital_id_suscripcion_lectura FOREIGN KEY (id_suscripcion_lectura) REFERENCES dbo.suscripcion_lectura (id_suscripcion_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.archivo_digital ADD CONSTRAINT fk_archivo_digital_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.archivo_digital ADD CONSTRAINT fk_archivo_digital_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.archivo_digital ADD CONSTRAINT fk_archivo_digital_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.wishlist_item ADD CONSTRAINT fk_wishlist_item_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.wishlist_item ADD CONSTRAINT fk_wishlist_item_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.wishlist_item ADD CONSTRAINT fk_wishlist_item_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.wishlist_item ADD CONSTRAINT fk_wishlist_item_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.wishlist_item ADD CONSTRAINT fk_wishlist_item_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adquisicion ADD CONSTRAINT fk_adquisicion_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adquisicion ADD CONSTRAINT fk_adquisicion_id_fuente_adquisicion FOREIGN KEY (id_fuente_adquisicion) REFERENCES dbo.fuente_adquisicion (id_fuente_adquisicion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adquisicion ADD CONSTRAINT fk_adquisicion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adquisicion ADD CONSTRAINT fk_adquisicion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adquisicion ADD CONSTRAINT fk_adquisicion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.importacion_biblioteca ADD CONSTRAINT fk_importacion_biblioteca_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.importacion_biblioteca ADD CONSTRAINT fk_importacion_biblioteca_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.importacion_biblioteca ADD CONSTRAINT fk_importacion_biblioteca_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.importacion_biblioteca ADD CONSTRAINT fk_importacion_biblioteca_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.detalle_importacion ADD CONSTRAINT fk_detalle_importacion_id_importacion_biblioteca FOREIGN KEY (id_importacion_biblioteca) REFERENCES dbo.importacion_biblioteca (id_importacion_biblioteca) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.detalle_importacion ADD CONSTRAINT fk_detalle_importacion_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.detalle_importacion ADD CONSTRAINT fk_detalle_importacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.detalle_importacion ADD CONSTRAINT fk_detalle_importacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.detalle_importacion ADD CONSTRAINT fk_detalle_importacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- FKs de Tablas del Estudiante B (Gabriela Natalia De Leon Alvarez)
ALTER TABLE dbo.ciclo_lectura ADD CONSTRAINT fk_ciclo_lectura_id_ejemplar_usuario FOREIGN KEY (id_ejemplar_usuario) REFERENCES dbo.ejemplar_usuario (id_ejemplar_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ciclo_lectura ADD CONSTRAINT fk_ciclo_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ciclo_lectura ADD CONSTRAINT fk_ciclo_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.ciclo_lectura ADD CONSTRAINT fk_ciclo_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.lugar_lectura ADD CONSTRAINT fk_lugar_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.lugar_lectura ADD CONSTRAINT fk_lugar_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.lugar_lectura ADD CONSTRAINT fk_lugar_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.lugar_lectura ADD CONSTRAINT fk_lugar_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_id_lugar_lectura FOREIGN KEY (id_lugar_lectura) REFERENCES dbo.lugar_lectura (id_lugar_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_id_dispositivo_usuario FOREIGN KEY (id_dispositivo_usuario) REFERENCES dbo.dispositivo_usuario (id_dispositivo_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sesion_lectura ADD CONSTRAINT fk_sesion_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.pausa_sesion_lectura ADD CONSTRAINT fk_pausa_sesion_lectura_id_sesion_lectura FOREIGN KEY (id_sesion_lectura) REFERENCES dbo.sesion_lectura (id_sesion_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.pausa_sesion_lectura ADD CONSTRAINT fk_pausa_sesion_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.pausa_sesion_lectura ADD CONSTRAINT fk_pausa_sesion_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.pausa_sesion_lectura ADD CONSTRAINT fk_pausa_sesion_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_lectura ADD CONSTRAINT fk_progreso_lectura_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_lectura ADD CONSTRAINT fk_progreso_lectura_id_sesion_lectura FOREIGN KEY (id_sesion_lectura) REFERENCES dbo.sesion_lectura (id_sesion_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_lectura ADD CONSTRAINT fk_progreso_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_lectura ADD CONSTRAINT fk_progreso_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_lectura ADD CONSTRAINT fk_progreso_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_nota ADD CONSTRAINT fk_tipo_nota_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_nota ADD CONSTRAINT fk_tipo_nota_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_nota ADD CONSTRAINT fk_tipo_nota_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota ADD CONSTRAINT fk_nota_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota ADD CONSTRAINT fk_nota_id_tipo_nota FOREIGN KEY (id_tipo_nota) REFERENCES dbo.tipo_nota (id_tipo_nota) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota ADD CONSTRAINT fk_nota_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota ADD CONSTRAINT fk_nota_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota ADD CONSTRAINT fk_nota_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.cita ADD CONSTRAINT fk_cita_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.cita ADD CONSTRAINT fk_cita_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.cita ADD CONSTRAINT fk_cita_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.cita ADD CONSTRAINT fk_cita_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota_etiqueta ADD CONSTRAINT fk_nota_etiqueta_id_nota FOREIGN KEY (id_nota) REFERENCES dbo.nota (id_nota) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota_etiqueta ADD CONSTRAINT fk_nota_etiqueta_id_etiqueta FOREIGN KEY (id_etiqueta) REFERENCES dbo.etiqueta (id_etiqueta) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota_etiqueta ADD CONSTRAINT fk_nota_etiqueta_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota_etiqueta ADD CONSTRAINT fk_nota_etiqueta_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nota_etiqueta ADD CONSTRAINT fk_nota_etiqueta_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adjunto_nota ADD CONSTRAINT fk_adjunto_nota_id_nota FOREIGN KEY (id_nota) REFERENCES dbo.nota (id_nota) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adjunto_nota ADD CONSTRAINT fk_adjunto_nota_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adjunto_nota ADD CONSTRAINT fk_adjunto_nota_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.adjunto_nota ADD CONSTRAINT fk_adjunto_nota_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena ADD CONSTRAINT fk_resena_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena ADD CONSTRAINT fk_resena_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena ADD CONSTRAINT fk_resena_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena ADD CONSTRAINT fk_resena_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion ADD CONSTRAINT fk_calificacion_id_ciclo_lectura FOREIGN KEY (id_ciclo_lectura) REFERENCES dbo.ciclo_lectura (id_ciclo_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion ADD CONSTRAINT fk_calificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion ADD CONSTRAINT fk_calificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion ADD CONSTRAINT fk_calificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.criterio_calificacion ADD CONSTRAINT fk_criterio_calificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.criterio_calificacion ADD CONSTRAINT fk_criterio_calificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.criterio_calificacion ADD CONSTRAINT fk_criterio_calificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion_criterio ADD CONSTRAINT fk_calificacion_criterio_id_calificacion FOREIGN KEY (id_calificacion) REFERENCES dbo.calificacion (id_calificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion_criterio ADD CONSTRAINT fk_calificacion_criterio_id_criterio_calificacion FOREIGN KEY (id_criterio_calificacion) REFERENCES dbo.criterio_calificacion (id_criterio_calificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion_criterio ADD CONSTRAINT fk_calificacion_criterio_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion_criterio ADD CONSTRAINT fk_calificacion_criterio_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.calificacion_criterio ADD CONSTRAINT fk_calificacion_criterio_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_reaccion ADD CONSTRAINT fk_resena_reaccion_id_resena FOREIGN KEY (id_resena) REFERENCES dbo.resena (id_resena) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_reaccion ADD CONSTRAINT fk_resena_reaccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_reaccion ADD CONSTRAINT fk_resena_reaccion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_reaccion ADD CONSTRAINT fk_resena_reaccion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_reaccion ADD CONSTRAINT fk_resena_reaccion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_comentario ADD CONSTRAINT fk_resena_comentario_id_resena FOREIGN KEY (id_resena) REFERENCES dbo.resena (id_resena) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_comentario ADD CONSTRAINT fk_resena_comentario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_comentario ADD CONSTRAINT fk_resena_comentario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_comentario ADD CONSTRAINT fk_resena_comentario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.resena_comentario ADD CONSTRAINT fk_resena_comentario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_meta ADD CONSTRAINT fk_tipo_meta_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_meta ADD CONSTRAINT fk_tipo_meta_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_meta ADD CONSTRAINT fk_tipo_meta_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.meta_lectura ADD CONSTRAINT fk_meta_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.meta_lectura ADD CONSTRAINT fk_meta_lectura_id_tipo_meta FOREIGN KEY (id_tipo_meta) REFERENCES dbo.tipo_meta (id_tipo_meta) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.meta_lectura ADD CONSTRAINT fk_meta_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.meta_lectura ADD CONSTRAINT fk_meta_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.meta_lectura ADD CONSTRAINT fk_meta_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_meta ADD CONSTRAINT fk_progreso_meta_id_meta_lectura FOREIGN KEY (id_meta_lectura) REFERENCES dbo.meta_lectura (id_meta_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_meta ADD CONSTRAINT fk_progreso_meta_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_meta ADD CONSTRAINT fk_progreso_meta_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.progreso_meta ADD CONSTRAINT fk_progreso_meta_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_lectura ADD CONSTRAINT fk_habito_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_lectura ADD CONSTRAINT fk_habito_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_lectura ADD CONSTRAINT fk_habito_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_lectura ADD CONSTRAINT fk_habito_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_programacion ADD CONSTRAINT fk_habito_programacion_id_habito_lectura FOREIGN KEY (id_habito_lectura) REFERENCES dbo.habito_lectura (id_habito_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_programacion ADD CONSTRAINT fk_habito_programacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_programacion ADD CONSTRAINT fk_habito_programacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.habito_programacion ADD CONSTRAINT fk_habito_programacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.registro_habito ADD CONSTRAINT fk_registro_habito_id_habito_lectura FOREIGN KEY (id_habito_lectura) REFERENCES dbo.habito_lectura (id_habito_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.registro_habito ADD CONSTRAINT fk_registro_habito_id_sesion_lectura FOREIGN KEY (id_sesion_lectura) REFERENCES dbo.sesion_lectura (id_sesion_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.registro_habito ADD CONSTRAINT fk_registro_habito_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.registro_habito ADD CONSTRAINT fk_registro_habito_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.registro_habito ADD CONSTRAINT fk_registro_habito_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.racha_lectura ADD CONSTRAINT fk_racha_lectura_id_habito_lectura FOREIGN KEY (id_habito_lectura) REFERENCES dbo.habito_lectura (id_habito_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.racha_lectura ADD CONSTRAINT fk_racha_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.racha_lectura ADD CONSTRAINT fk_racha_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.racha_lectura ADD CONSTRAINT fk_racha_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.canal_notificacion ADD CONSTRAINT fk_canal_notificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.canal_notificacion ADD CONSTRAINT fk_canal_notificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.canal_notificacion ADD CONSTRAINT fk_canal_notificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_evento_notificacion ADD CONSTRAINT fk_tipo_evento_notificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_evento_notificacion ADD CONSTRAINT fk_tipo_evento_notificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.tipo_evento_notificacion ADD CONSTRAINT fk_tipo_evento_notificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_id_habito_lectura FOREIGN KEY (id_habito_lectura) REFERENCES dbo.habito_lectura (id_habito_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_id_meta_lectura FOREIGN KEY (id_meta_lectura) REFERENCES dbo.meta_lectura (id_meta_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_id_canal_notificacion FOREIGN KEY (id_canal_notificacion) REFERENCES dbo.canal_notificacion (id_canal_notificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recordatorio ADD CONSTRAINT fk_recordatorio_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_id_canal_notificacion FOREIGN KEY (id_canal_notificacion) REFERENCES dbo.canal_notificacion (id_canal_notificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_id_tipo_evento_notificacion FOREIGN KEY (id_tipo_evento_notificacion) REFERENCES dbo.tipo_evento_notificacion (id_tipo_evento_notificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.preferencia_notificacion ADD CONSTRAINT fk_preferencia_notificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_id_tipo_evento_notificacion FOREIGN KEY (id_tipo_evento_notificacion) REFERENCES dbo.tipo_evento_notificacion (id_tipo_evento_notificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_id_canal_notificacion FOREIGN KEY (id_canal_notificacion) REFERENCES dbo.canal_notificacion (id_canal_notificacion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.notificacion ADD CONSTRAINT fk_notificacion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro ADD CONSTRAINT fk_logro_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro ADD CONSTRAINT fk_logro_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro ADD CONSTRAINT fk_logro_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro_usuario ADD CONSTRAINT fk_logro_usuario_id_logro FOREIGN KEY (id_logro) REFERENCES dbo.logro (id_logro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro_usuario ADD CONSTRAINT fk_logro_usuario_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro_usuario ADD CONSTRAINT fk_logro_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro_usuario ADD CONSTRAINT fk_logro_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.logro_usuario ADD CONSTRAINT fk_logro_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nivel_lector ADD CONSTRAINT fk_nivel_lector_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nivel_lector ADD CONSTRAINT fk_nivel_lector_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.nivel_lector ADD CONSTRAINT fk_nivel_lector_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.movimiento_puntos ADD CONSTRAINT fk_movimiento_puntos_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.movimiento_puntos ADD CONSTRAINT fk_movimiento_puntos_id_logro FOREIGN KEY (id_logro) REFERENCES dbo.logro (id_logro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.movimiento_puntos ADD CONSTRAINT fk_movimiento_puntos_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.movimiento_puntos ADD CONSTRAINT fk_movimiento_puntos_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.movimiento_puntos ADD CONSTRAINT fk_movimiento_puntos_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_diaria ADD CONSTRAINT fk_estadistica_diaria_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_diaria ADD CONSTRAINT fk_estadistica_diaria_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_diaria ADD CONSTRAINT fk_estadistica_diaria_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_diaria ADD CONSTRAINT fk_estadistica_diaria_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_mensual ADD CONSTRAINT fk_estadistica_mensual_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_mensual ADD CONSTRAINT fk_estadistica_mensual_id_nivel_lector FOREIGN KEY (id_nivel_lector) REFERENCES dbo.nivel_lector (id_nivel_lector) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_mensual ADD CONSTRAINT fk_estadistica_mensual_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_mensual ADD CONSTRAINT fk_estadistica_mensual_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.estadistica_mensual ADD CONSTRAINT fk_estadistica_mensual_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reporte_generado ADD CONSTRAINT fk_reporte_generado_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reporte_generado ADD CONSTRAINT fk_reporte_generado_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reporte_generado ADD CONSTRAINT fk_reporte_generado_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reporte_generado ADD CONSTRAINT fk_reporte_generado_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.club_lectura ADD CONSTRAINT fk_club_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.club_lectura ADD CONSTRAINT fk_club_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.club_lectura ADD CONSTRAINT fk_club_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.club_lectura ADD CONSTRAINT fk_club_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_club ADD CONSTRAINT fk_rol_club_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_club ADD CONSTRAINT fk_rol_club_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.rol_club ADD CONSTRAINT fk_rol_club_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_id_club_lectura FOREIGN KEY (id_club_lectura) REFERENCES dbo.club_lectura (id_club_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_id_rol_club FOREIGN KEY (id_rol_club) REFERENCES dbo.rol_club (id_rol_club) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.miembro_club ADD CONSTRAINT fk_miembro_club_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_club ADD CONSTRAINT fk_libro_club_id_club_lectura FOREIGN KEY (id_club_lectura) REFERENCES dbo.club_lectura (id_club_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_club ADD CONSTRAINT fk_libro_club_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_club ADD CONSTRAINT fk_libro_club_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_club ADD CONSTRAINT fk_libro_club_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.libro_club ADD CONSTRAINT fk_libro_club_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reunion_club ADD CONSTRAINT fk_reunion_club_id_club_lectura FOREIGN KEY (id_club_lectura) REFERENCES dbo.club_lectura (id_club_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reunion_club ADD CONSTRAINT fk_reunion_club_id_libro_club FOREIGN KEY (id_libro_club) REFERENCES dbo.libro_club (id_libro_club) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reunion_club ADD CONSTRAINT fk_reunion_club_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reunion_club ADD CONSTRAINT fk_reunion_club_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reunion_club ADD CONSTRAINT fk_reunion_club_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.asistencia_reunion ADD CONSTRAINT fk_asistencia_reunion_id_reunion_club FOREIGN KEY (id_reunion_club) REFERENCES dbo.reunion_club (id_reunion_club) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.asistencia_reunion ADD CONSTRAINT fk_asistencia_reunion_id_miembro_club FOREIGN KEY (id_miembro_club) REFERENCES dbo.miembro_club (id_miembro_club) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.asistencia_reunion ADD CONSTRAINT fk_asistencia_reunion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.asistencia_reunion ADD CONSTRAINT fk_asistencia_reunion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.asistencia_reunion ADD CONSTRAINT fk_asistencia_reunion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.mensaje_club ADD CONSTRAINT fk_mensaje_club_id_club_lectura FOREIGN KEY (id_club_lectura) REFERENCES dbo.club_lectura (id_club_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.mensaje_club ADD CONSTRAINT fk_mensaje_club_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.mensaje_club ADD CONSTRAINT fk_mensaje_club_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.mensaje_club ADD CONSTRAINT fk_mensaje_club_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.mensaje_club ADD CONSTRAINT fk_mensaje_club_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.seguimiento_usuario ADD CONSTRAINT fk_seguimiento_usuario_id_usuario_seguidor FOREIGN KEY (id_usuario_seguidor) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.seguimiento_usuario ADD CONSTRAINT fk_seguimiento_usuario_id_usuario_seguido FOREIGN KEY (id_usuario_seguido) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.seguimiento_usuario ADD CONSTRAINT fk_seguimiento_usuario_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.seguimiento_usuario ADD CONSTRAINT fk_seguimiento_usuario_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.seguimiento_usuario ADD CONSTRAINT fk_seguimiento_usuario_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reto_lectura ADD CONSTRAINT fk_reto_lectura_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reto_lectura ADD CONSTRAINT fk_reto_lectura_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reto_lectura ADD CONSTRAINT fk_reto_lectura_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.reto_lectura ADD CONSTRAINT fk_reto_lectura_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.participante_reto ADD CONSTRAINT fk_participante_reto_id_reto_lectura FOREIGN KEY (id_reto_lectura) REFERENCES dbo.reto_lectura (id_reto_lectura) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.participante_reto ADD CONSTRAINT fk_participante_reto_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.participante_reto ADD CONSTRAINT fk_participante_reto_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.participante_reto ADD CONSTRAINT fk_participante_reto_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.participante_reto ADD CONSTRAINT fk_participante_reto_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_id_usuario_emisor FOREIGN KEY (id_usuario_emisor) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_id_usuario_receptor FOREIGN KEY (id_usuario_receptor) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_id_libro FOREIGN KEY (id_libro) REFERENCES dbo.libro (id_libro) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.recomendacion_libro ADD CONSTRAINT fk_recomendacion_libro_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_transaccion ADD CONSTRAINT fk_auditoria_transaccion_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_transaccion ADD CONSTRAINT fk_auditoria_transaccion_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_transaccion ADD CONSTRAINT fk_auditoria_transaccion_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_transaccion ADD CONSTRAINT fk_auditoria_transaccion_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_detalle_cambio ADD CONSTRAINT fk_auditoria_detalle_cambio_id_auditoria_transaccion FOREIGN KEY (id_auditoria_transaccion) REFERENCES dbo.auditoria_transaccion (id_auditoria_transaccion) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_detalle_cambio ADD CONSTRAINT fk_auditoria_detalle_cambio_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_detalle_cambio ADD CONSTRAINT fk_auditoria_detalle_cambio_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.auditoria_detalle_cambio ADD CONSTRAINT fk_auditoria_detalle_cambio_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sincronizacion_dispositivo ADD CONSTRAINT fk_sincronizacion_dispositivo_id_dispositivo_usuario FOREIGN KEY (id_dispositivo_usuario) REFERENCES dbo.dispositivo_usuario (id_dispositivo_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sincronizacion_dispositivo ADD CONSTRAINT fk_sincronizacion_dispositivo_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sincronizacion_dispositivo ADD CONSTRAINT fk_sincronizacion_dispositivo_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.sincronizacion_dispositivo ADD CONSTRAINT fk_sincronizacion_dispositivo_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.exportacion_datos ADD CONSTRAINT fk_exportacion_datos_id_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.exportacion_datos ADD CONSTRAINT fk_exportacion_datos_creado_por FOREIGN KEY (creado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.exportacion_datos ADD CONSTRAINT fk_exportacion_datos_modificado_por FOREIGN KEY (modificado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE dbo.exportacion_datos ADD CONSTRAINT fk_exportacion_datos_eliminado_por FOREIGN KEY (eliminado_por) REFERENCES dbo.usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- =============================================================================
-- INDICES DE RENDIMIENTO SOBRE LLAVES FORANEAS Y FILTROS DE NEGOCIO
-- =============================================================================

CREATE INDEX idx_perfil_usuario_id_usuario ON dbo.perfil_usuario (id_usuario);
CREATE INDEX idx_credencial_usuario_id_usuario ON dbo.credencial_usuario (id_usuario);
CREATE INDEX idx_historial_credencial_id_usuario ON dbo.historial_credencial (id_usuario);
CREATE INDEX idx_politica_contrasena_id_rol ON dbo.politica_contrasena (id_rol);
CREATE INDEX idx_rol_permiso_id_rol ON dbo.rol_permiso (id_rol);
CREATE INDEX idx_rol_permiso_id_permiso ON dbo.rol_permiso (id_permiso);
CREATE INDEX idx_usuario_rol_id_usuario ON dbo.usuario_rol (id_usuario);
CREATE INDEX idx_usuario_rol_id_rol ON dbo.usuario_rol (id_rol);
CREATE INDEX idx_sesion_usuario_id_usuario ON dbo.sesion_usuario (id_usuario);
CREATE INDEX idx_sesion_usuario_id_dispositivo_usuario ON dbo.sesion_usuario (id_dispositivo_usuario);
CREATE INDEX idx_bitacora_acceso_id_usuario ON dbo.bitacora_acceso (id_usuario);
CREATE INDEX idx_bitacora_acceso_id_sesion_usuario ON dbo.bitacora_acceso (id_sesion_usuario);
CREATE INDEX idx_bloqueo_cuenta_id_usuario ON dbo.bloqueo_cuenta (id_usuario);
CREATE INDEX idx_token_recuperacion_id_usuario ON dbo.token_recuperacion (id_usuario);
CREATE INDEX idx_metodo_2fa_id_usuario ON dbo.metodo_2fa (id_usuario);
CREATE INDEX idx_codigo_respaldo_2fa_id_metodo_2fa ON dbo.codigo_respaldo_2fa (id_metodo_2fa);
CREATE INDEX idx_dispositivo_usuario_id_usuario ON dbo.dispositivo_usuario (id_usuario);
CREATE INDEX idx_preferencia_usuario_id_usuario ON dbo.preferencia_usuario (id_usuario);
CREATE INDEX idx_preferencia_usuario_id_idioma ON dbo.preferencia_usuario (id_idioma);
CREATE INDEX idx_consentimiento_privacidad_id_usuario ON dbo.consentimiento_privacidad (id_usuario);
CREATE INDEX idx_consentimiento_privacidad_id_version_aviso_privacidad ON dbo.consentimiento_privacidad (id_version_aviso_privacidad);
CREATE INDEX idx_solicitud_arco_id_usuario ON dbo.solicitud_arco (id_usuario);
CREATE INDEX idx_solicitud_arco_id_tipo_solicitud_arco ON dbo.solicitud_arco (id_tipo_solicitud_arco);
CREATE INDEX idx_libro_autor_id_libro ON dbo.libro_autor (id_libro);
CREATE INDEX idx_libro_autor_id_autor ON dbo.libro_autor (id_autor);
CREATE INDEX idx_libro_autor_id_tipo_colaborador ON dbo.libro_autor (id_tipo_colaborador);
CREATE INDEX idx_edicion_id_libro ON dbo.edicion (id_libro);
CREATE INDEX idx_edicion_id_editorial ON dbo.edicion (id_editorial);
CREATE INDEX idx_edicion_id_idioma ON dbo.edicion (id_idioma);
CREATE INDEX idx_edicion_id_formato_libro ON dbo.edicion (id_formato_libro);
CREATE INDEX idx_genero_id_genero_padre ON dbo.genero (id_genero_padre);
CREATE INDEX idx_libro_genero_id_libro ON dbo.libro_genero (id_libro);
CREATE INDEX idx_libro_genero_id_genero ON dbo.libro_genero (id_genero);
CREATE INDEX idx_libro_serie_id_libro ON dbo.libro_serie (id_libro);
CREATE INDEX idx_libro_serie_id_serie_libro ON dbo.libro_serie (id_serie_libro);
CREATE INDEX idx_ejemplar_usuario_id_usuario ON dbo.ejemplar_usuario (id_usuario);
CREATE INDEX idx_ejemplar_usuario_id_edicion ON dbo.ejemplar_usuario (id_edicion);
CREATE INDEX idx_ejemplar_usuario_id_estado_lectura ON dbo.ejemplar_usuario (id_estado_lectura);
CREATE INDEX idx_etiqueta_id_usuario ON dbo.etiqueta (id_usuario);
CREATE INDEX idx_etiqueta_ejemplar_id_etiqueta ON dbo.etiqueta_ejemplar (id_etiqueta);
CREATE INDEX idx_etiqueta_ejemplar_id_ejemplar_usuario ON dbo.etiqueta_ejemplar (id_ejemplar_usuario);
CREATE INDEX idx_estante_id_usuario ON dbo.estante (id_usuario);
CREATE INDEX idx_estante_ejemplar_id_estante ON dbo.estante_ejemplar (id_estante);
CREATE INDEX idx_estante_ejemplar_id_ejemplar_usuario ON dbo.estante_ejemplar (id_ejemplar_usuario);
CREATE INDEX idx_coleccion_id_usuario ON dbo.coleccion (id_usuario);
CREATE INDEX idx_coleccion_ejemplar_id_coleccion ON dbo.coleccion_ejemplar (id_coleccion);
CREATE INDEX idx_coleccion_ejemplar_id_ejemplar_usuario ON dbo.coleccion_ejemplar (id_ejemplar_usuario);
CREATE INDEX idx_ubicacion_fisica_id_usuario ON dbo.ubicacion_fisica (id_usuario);
CREATE INDEX idx_copia_fisica_id_ejemplar_usuario ON dbo.copia_fisica (id_ejemplar_usuario);
CREATE INDEX idx_copia_fisica_id_ubicacion_fisica ON dbo.copia_fisica (id_ubicacion_fisica);
CREATE INDEX idx_suscripcion_lectura_id_usuario ON dbo.suscripcion_lectura (id_usuario);
CREATE INDEX idx_suscripcion_lectura_id_fuente_adquisicion ON dbo.suscripcion_lectura (id_fuente_adquisicion);
CREATE INDEX idx_archivo_digital_id_ejemplar_usuario ON dbo.archivo_digital (id_ejemplar_usuario);
CREATE INDEX idx_archivo_digital_id_suscripcion_lectura ON dbo.archivo_digital (id_suscripcion_lectura);
CREATE INDEX idx_wishlist_item_id_usuario ON dbo.wishlist_item (id_usuario);
CREATE INDEX idx_wishlist_item_id_libro ON dbo.wishlist_item (id_libro);
CREATE INDEX idx_adquisicion_id_ejemplar_usuario ON dbo.adquisicion (id_ejemplar_usuario);
CREATE INDEX idx_adquisicion_id_fuente_adquisicion ON dbo.adquisicion (id_fuente_adquisicion);
CREATE INDEX idx_importacion_biblioteca_id_usuario ON dbo.importacion_biblioteca (id_usuario);
CREATE INDEX idx_detalle_importacion_id_importacion_biblioteca ON dbo.detalle_importacion (id_importacion_biblioteca);
CREATE INDEX idx_detalle_importacion_id_ejemplar_usuario ON dbo.detalle_importacion (id_ejemplar_usuario);
CREATE INDEX idx_ciclo_lectura_id_ejemplar_usuario ON dbo.ciclo_lectura (id_ejemplar_usuario);
CREATE INDEX idx_lugar_lectura_id_usuario ON dbo.lugar_lectura (id_usuario);
CREATE INDEX idx_sesion_lectura_id_ciclo_lectura ON dbo.sesion_lectura (id_ciclo_lectura);
CREATE INDEX idx_sesion_lectura_id_lugar_lectura ON dbo.sesion_lectura (id_lugar_lectura);
CREATE INDEX idx_sesion_lectura_id_dispositivo_usuario ON dbo.sesion_lectura (id_dispositivo_usuario);
CREATE INDEX idx_pausa_sesion_lectura_id_sesion_lectura ON dbo.pausa_sesion_lectura (id_sesion_lectura);
CREATE INDEX idx_progreso_lectura_id_ciclo_lectura ON dbo.progreso_lectura (id_ciclo_lectura);
CREATE INDEX idx_progreso_lectura_id_sesion_lectura ON dbo.progreso_lectura (id_sesion_lectura);
CREATE INDEX idx_nota_id_ciclo_lectura ON dbo.nota (id_ciclo_lectura);
CREATE INDEX idx_nota_id_tipo_nota ON dbo.nota (id_tipo_nota);
CREATE INDEX idx_cita_id_ciclo_lectura ON dbo.cita (id_ciclo_lectura);
CREATE INDEX idx_nota_etiqueta_id_nota ON dbo.nota_etiqueta (id_nota);
CREATE INDEX idx_nota_etiqueta_id_etiqueta ON dbo.nota_etiqueta (id_etiqueta);
CREATE INDEX idx_adjunto_nota_id_nota ON dbo.adjunto_nota (id_nota);
CREATE INDEX idx_resena_id_ciclo_lectura ON dbo.resena (id_ciclo_lectura);
CREATE INDEX idx_calificacion_id_ciclo_lectura ON dbo.calificacion (id_ciclo_lectura);
CREATE INDEX idx_calificacion_criterio_id_calificacion ON dbo.calificacion_criterio (id_calificacion);
CREATE INDEX idx_calificacion_criterio_id_criterio_calificacion ON dbo.calificacion_criterio (id_criterio_calificacion);
CREATE INDEX idx_resena_reaccion_id_resena ON dbo.resena_reaccion (id_resena);
CREATE INDEX idx_resena_reaccion_id_usuario ON dbo.resena_reaccion (id_usuario);
CREATE INDEX idx_resena_comentario_id_resena ON dbo.resena_comentario (id_resena);
CREATE INDEX idx_resena_comentario_id_usuario ON dbo.resena_comentario (id_usuario);
CREATE INDEX idx_meta_lectura_id_usuario ON dbo.meta_lectura (id_usuario);
CREATE INDEX idx_meta_lectura_id_tipo_meta ON dbo.meta_lectura (id_tipo_meta);
CREATE INDEX idx_progreso_meta_id_meta_lectura ON dbo.progreso_meta (id_meta_lectura);
CREATE INDEX idx_habito_lectura_id_usuario ON dbo.habito_lectura (id_usuario);
CREATE INDEX idx_habito_programacion_id_habito_lectura ON dbo.habito_programacion (id_habito_lectura);
CREATE INDEX idx_registro_habito_id_habito_lectura ON dbo.registro_habito (id_habito_lectura);
CREATE INDEX idx_registro_habito_id_sesion_lectura ON dbo.registro_habito (id_sesion_lectura);
CREATE INDEX idx_racha_lectura_id_habito_lectura ON dbo.racha_lectura (id_habito_lectura);
CREATE INDEX idx_recordatorio_id_habito_lectura ON dbo.recordatorio (id_habito_lectura);
CREATE INDEX idx_recordatorio_id_meta_lectura ON dbo.recordatorio (id_meta_lectura);
CREATE INDEX idx_recordatorio_id_canal_notificacion ON dbo.recordatorio (id_canal_notificacion);
CREATE INDEX idx_preferencia_notificacion_id_usuario ON dbo.preferencia_notificacion (id_usuario);
CREATE INDEX idx_preferencia_notificacion_id_canal_notificacion ON dbo.preferencia_notificacion (id_canal_notificacion);
CREATE INDEX idx_preferencia_notificacion_id_tipo_evento_notificacion ON dbo.preferencia_notificacion (id_tipo_evento_notificacion);
CREATE INDEX idx_notificacion_id_usuario ON dbo.notificacion (id_usuario);
CREATE INDEX idx_notificacion_id_tipo_evento_notificacion ON dbo.notificacion (id_tipo_evento_notificacion);
CREATE INDEX idx_notificacion_id_canal_notificacion ON dbo.notificacion (id_canal_notificacion);
CREATE INDEX idx_logro_usuario_id_logro ON dbo.logro_usuario (id_logro);
CREATE INDEX idx_logro_usuario_id_usuario ON dbo.logro_usuario (id_usuario);
CREATE INDEX idx_movimiento_puntos_id_usuario ON dbo.movimiento_puntos (id_usuario);
CREATE INDEX idx_movimiento_puntos_id_logro ON dbo.movimiento_puntos (id_logro);
CREATE INDEX idx_estadistica_diaria_id_usuario ON dbo.estadistica_diaria (id_usuario);
CREATE INDEX idx_estadistica_mensual_id_usuario ON dbo.estadistica_mensual (id_usuario);
CREATE INDEX idx_estadistica_mensual_id_nivel_lector ON dbo.estadistica_mensual (id_nivel_lector);
CREATE INDEX idx_reporte_generado_id_usuario ON dbo.reporte_generado (id_usuario);
CREATE INDEX idx_club_lectura_id_usuario ON dbo.club_lectura (id_usuario);
CREATE INDEX idx_miembro_club_id_club_lectura ON dbo.miembro_club (id_club_lectura);
CREATE INDEX idx_miembro_club_id_usuario ON dbo.miembro_club (id_usuario);
CREATE INDEX idx_miembro_club_id_rol_club ON dbo.miembro_club (id_rol_club);
CREATE INDEX idx_libro_club_id_club_lectura ON dbo.libro_club (id_club_lectura);
CREATE INDEX idx_libro_club_id_libro ON dbo.libro_club (id_libro);
CREATE INDEX idx_reunion_club_id_club_lectura ON dbo.reunion_club (id_club_lectura);
CREATE INDEX idx_reunion_club_id_libro_club ON dbo.reunion_club (id_libro_club);
CREATE INDEX idx_asistencia_reunion_id_reunion_club ON dbo.asistencia_reunion (id_reunion_club);
CREATE INDEX idx_asistencia_reunion_id_miembro_club ON dbo.asistencia_reunion (id_miembro_club);
CREATE INDEX idx_mensaje_club_id_club_lectura ON dbo.mensaje_club (id_club_lectura);
CREATE INDEX idx_mensaje_club_id_usuario ON dbo.mensaje_club (id_usuario);
CREATE INDEX idx_seguimiento_usuario_id_usuario_seguidor ON dbo.seguimiento_usuario (id_usuario_seguidor);
CREATE INDEX idx_seguimiento_usuario_id_usuario_seguido ON dbo.seguimiento_usuario (id_usuario_seguido);
CREATE INDEX idx_reto_lectura_id_usuario ON dbo.reto_lectura (id_usuario);
CREATE INDEX idx_participante_reto_id_reto_lectura ON dbo.participante_reto (id_reto_lectura);
CREATE INDEX idx_participante_reto_id_usuario ON dbo.participante_reto (id_usuario);
CREATE INDEX idx_recomendacion_libro_id_usuario_emisor ON dbo.recomendacion_libro (id_usuario_emisor);
CREATE INDEX idx_recomendacion_libro_id_usuario_receptor ON dbo.recomendacion_libro (id_usuario_receptor);
CREATE INDEX idx_recomendacion_libro_id_libro ON dbo.recomendacion_libro (id_libro);
CREATE INDEX idx_auditoria_transaccion_id_usuario ON dbo.auditoria_transaccion (id_usuario);
CREATE INDEX idx_auditoria_detalle_cambio_id_auditoria_transaccion ON dbo.auditoria_detalle_cambio (id_auditoria_transaccion);
CREATE INDEX idx_sincronizacion_dispositivo_id_dispositivo_usuario ON dbo.sincronizacion_dispositivo (id_dispositivo_usuario);
CREATE INDEX idx_exportacion_datos_id_usuario ON dbo.exportacion_datos (id_usuario);
CREATE INDEX idx_usuario_estatus ON dbo.usuario (estatus);
CREATE INDEX idx_bitacora_acceso_fecha_evento ON dbo.bitacora_acceso (fecha_evento);
CREATE INDEX idx_bitacora_acceso_resultado ON dbo.bitacora_acceso (resultado);
CREATE INDEX idx_sesion_lectura_fecha_inicio ON dbo.sesion_lectura (fecha_inicio);
CREATE INDEX idx_auditoria_transaccion_fecha_operacion ON dbo.auditoria_transaccion (fecha_operacion);
CREATE INDEX idx_auditoria_transaccion_tipo_operacion ON dbo.auditoria_transaccion (tipo_operacion);
CREATE INDEX idx_estadistica_diaria_fecha_estadistica ON dbo.estadistica_diaria (fecha_estadistica);
CREATE INDEX idx_notificacion_leida ON dbo.notificacion (leida);
GO
