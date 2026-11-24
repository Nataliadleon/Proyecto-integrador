# Contrato de Adaptador Multi-SGBD (*Hot-Swap* SQL Server 2022 ↔ PostgreSQL 16)

Este documento define la interfaz desacoplada de persistencia (`IDatabaseProvider`) que permite conmutar en caliente (*hot-swap*) el motor de base de datos de **Book Tracker** sin modificar la lógica de negocio ni el modelo de 100 tablas.

---

## 1. Arquitectura de Abstracción

```text
SecurityController / LibraryService / ReadingSessionService
                        │
                        ▼
             IDatabaseProvider (Puerto)
          ┌─────────────┴─────────────┐
          ▼                           ▼
  SqlServerProvider            PostgresProvider
(Microsoft.Data.SqlClient)        (Npgsql)
```

## 2. Contrato de Métodos e Invariantes de Paridad

1. **Identificadores idénticos:** Los 100 nombres de tablas, 1,339 columnas, 100 PKs (`id_<tabla>`), 432 FKs y restricciones `UNIQUE`/`CHECK` son idénticos en `dbo.*` (SQL Server) y `public.*` (PostgreSQL).
2. **Parámetros tipados:** Todas las consultas utilizan parámetros enlazados (`@p_nombre`), nunca concatenación de cadenas, mitigando inyección SQL.
3. **Baja lógica uniforme:** Ningún repositorio emite `DELETE FROM ...`; toda eliminación ejecuta `UPDATE <tabla> SET estatus = 'INACTIVO', eliminado_por = @id_actor, fecha_eliminacion = <UTC_NOW> WHERE id_<tabla> = @id`.
4. **Cifrado y hashing en capa de servicio:** `CryptoService` genera y valida hashes `Argon2id` / `bcrypt` ($\ge 12$) en la capa de aplicación antes de persistir en `credencial_usuario`, garantizando independencia total del motor SQL para la autenticación.
5. **Dialecto encapsulado en el adaptador:**
   - Retorno de identidad insertada: `OUTPUT INSERTED.id_<tabla>` (SQL Server) ↔ `RETURNING id_<tabla>` (PostgreSQL).
   - Paginación: `OFFSET @skip ROWS FETCH NEXT @take ROWS ONLY` (SQL-2012 estándar, soportado nativamente por **ambos** motores).
   - Marca temporal UTC: `SYSUTCDATETIME()` ↔ `CURRENT_TIMESTAMP`.
   - Booleanos: `1`/`0` (`BIT`) ↔ `TRUE`/`FALSE` (`BOOLEAN`).
