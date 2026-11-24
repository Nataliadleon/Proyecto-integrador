# Fase 3: Fundamentos de Base de Datos (FBD)

> **Asignatura:** AEF-1031 — Fundamentos de Base de Datos  
> **Proyecto:** *Book Tracker* — Plataforma Integral de Gestión de Lectura  
> **Arquitectura de Datos:** 100 Tablas Normalizadas en BCNF · Multi-SGBD (*Hot-Swap* SQL Server 2022 ↔ PostgreSQL 16)

---

## 📌 Matriz de Avance contra Rúbrica Oficial (FBD)

| Criterio y Ponderación | Lo que se Califica (Rúbrica Oficial) | Entregable del Proyecto | Estado |
| :--- | :--- | :--- | :---: |
| **2.1 Modelado Conceptual E-R y Lógico Relacional**<br>`(20%)` | • Diagrama E-R Extendido completo (jerarquías, cardinalidades, atributos compuestos/multivaluados).<br>• Conversión rigurosa al Modelo Relacional con PKs, FKs y restricciones de integridad. | • [2.1_Modelado_Conceptual_ER_y_Logico_Relacional.md](./2.1_Modelado_Conceptual_ER_y_Logico_Relacional.md)<br>• Diagrama Maestro Consolidado (100 tablas): [PNG](./diagramas/png/ER_General_Completo_100_Tablas.png) · [SVG](./diagramas/ER_General_Completo_100_Tablas.svg) · [MMD](./diagramas/mmd/ER_General_Completo_100_Tablas.mmd)<br>• 5 Diagramas Modulares en PNG (`ER01` a `ER05`). | **Completado** |
| **2.2 Magnitud, Estructura y Normalización**<br>`(30%)` | • 50 tablas por integrante (100 en total).<br>• Catálogos simples $\le 25\%$ y tablas complejas $\ge 75\%$.<br>• Memoria formal demostrativa de 1FN → 2FN → 3FN → BCNF. | • 📄 [2.2_Normalizacion_1FN_a_BCNF.pdf](./2.2_Normalizacion_1FN_a_BCNF.pdf) *(Documento oficial)*<br>• 📝 [2.2_Normalizacion_1FN_a_BCNF.md](./2.2_Normalizacion_1FN_a_BCNF.md) *(Resumen ejecutivo)*<br>• 📘 [2.2_Normalizacion_1FN_a_BCNF.docx](../wordFBD/2.2_Normalizacion_1FN_a_BCNF.docx) *(Word editable)* | **Completado** |
| **2.3 Diccionario de Datos y Asignación Equitativa**<br>`(15%)` | • Diccionario exhaustivo de las 100 tablas con autoría (50/50), tipos, tamaño, nulabilidad, PK/FK/CHECK/UNIQUE y descripción semántica. | • `2.3_Diccionario_de_Datos_100_Tablas.xlsx` *(Pendiente)* | **Siguiente** |
| **2.4 Implementación Multi-SGBD, Álgebra Relacional y SQL**<br>`(35%)` | • Scripts DDL y DML 100% ejecutables en SQL Server y PostgreSQL.<br>• Contraseñas hasheadas (`Argon2id`/`bcrypt`).<br>• Álgebra Relacional básica y extendida + SQL equivalente. | • `scripts/sqlserver/` y `scripts/postgresql/` *(Pendiente)*<br>• `2.4_Algebra_Relacional_y_Consultas_SQL.md` *(Pendiente)* | **Pendiente** |

---

## 🗂️ Estructura del Directorio

```text
FBD/
├── 📘 README.md                                          # Índice general y matriz de evaluación FBD
├── 📄 2.1_Modelado_Conceptual_ER_y_Logico_Relacional.md  # E-R Extendido, conversión relacional y paridad Multi-SGBD
├── 📄 2.2_Normalizacion_1FN_a_BCNF.md                    # Memoria formal de normalización y auditoría 1FN -> BCNF
└── 📁 diagramas/
    ├── ER_General_Completo_100_Tablas.svg                # Diagrama Maestro E-R Vectorial (100 tablas + 132 FKs)
    ├── 📁 mmd/                                           # Código fuente Mermaid (.mmd)
    │   ├── ER_General_Completo_100_Tablas.mmd            # Diagrama E-R Maestro Consolidado (100 tablas)
    │   ├── ER00_Mapa_General_Dominios_y_Jerarquias_EER.mmd
    │   ├── ER01_A1_A5_Seguridad_RBAC_Privacidad_ARCO.mmd
    │   ├── ER02_A6_A9_Catalogo_Biblioteca_Copias_Importacion.mmd
    │   ├── ER03_B1_B3_Sesiones_Notas_Resenas.mmd
    │   ├── ER04_B4_B6_Metas_Habitos_Notificaciones_Logros.mmd
    │   └── ER05_B7_B9_Estadisticas_Clubes_Social_Auditoria.mmd
    └── 📁 png/                                           # Diagramas renderizados en PNG para Word editable
        ├── ER_General_Completo_100_Tablas.png            # Diagrama E-R Consolidado (100 tablas completas)
        ├── ER00_Mapa_General_Dominios_y_Jerarquias_EER.png
        ├── ER01_A1_A5_Seguridad_RBAC_Privacidad_ARCO.png
        ├── ER02_A6_A9_Catalogo_Biblioteca_Copias_Importacion.png
        ├── ER03_B1_B3_Sesiones_Notas_Resenas.png
        ├── ER04_B4_B6_Metas_Habitos_Notificaciones_Logros.png
        └── ER05_B7_B9_Estadisticas_Clubes_Social_Auditoria.png
```
