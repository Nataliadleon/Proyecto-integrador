# Book Tracker — Proyecto Integrador Multidisciplinario

[![TecNM](https://img.shields.io/badge/TecNM-Instituto%20Tecnol%C3%B3gico%20Superior%20de%20Monclova-blue.svg)](https://www.tecnm.mx)
[![Carrera](https://img.shields.io/badge/Carrera-Ingenier%C3%ADa%20Inform%C3%A1tica-green.svg)](#)
[![Semestre](https://img.shields.io/badge/Semestre-Quinto%20%2F%20Sexto-orange.svg)](#)

Repositorio institucional del **Proyecto Integrador Terminal de Semestre** para la carrera de **Ingeniería Informática** del **Instituto Tecnológico Superior de Monclova (TecNM)**.

---

## 📖 Descripción del Sistema

**Book Tracker** es una plataforma integral corporativa para la gestión de lectura, biblioteca personal física y digital, registro de hábitos, analítica lectora y comunidad social. Está diseñada bajo una arquitectura orientada a objetos en 3 capas, un modelo relacional de **100 tablas** normalizadas en BCNF, infraestructura de red LAN corporativa de alta disponibilidad y estricto apego al marco jurídico mexicano (LFPDPPP y Código Penal Federal).

---

## 🏛️ Asignaturas Concurrentes del Proyecto

| Asignatura | Clave | Área de Competencia Evaluada |
| :--- | :---: | :--- |
| **Análisis y Modelado de Sistemas de Información (AMSI)** | `IFE-1005` | Análisis y modelado orientado a objetos (Requisitos, UML, Secuencia Criptográfica, Clases, Despliegue). |
| **Fundamentos de Base de Datos (FBD)** | `AEF-1031` | Modelo E-R Extendido, normalización (1FN a BCNF), 100 tablas, diccionario de datos, Álgebra Relacional e implementación Multi-SGBD (SQL Server + PostgreSQL/MariaDB). |
| **Redes de Computadoras (RC)** | `IFD-1020` | Red corporativa jerárquica (3 capas), subredes con VLSM/CIDR, cableado estructurado ANSI/TIA, diseño de SITE y seguridad en switches capa 2 (Port Security). |
| **Taller de Legislación Informática (TLI)** | `IFR-1024` | Aviso de Privacidad (LFPDPPP), Art. 16 Constitucional, contratos informáticos (SLA/EULA), registro INDAUTOR y matriz de prevención de delitos informáticos. |

---

## 👥 Matriz de Deslinde de Autoría (50/50)

Conforme a los criterios de acreditación del TecNM, cada integrante asume la autoría funcional y técnica del 50% del sistema (50 tablas y 9 submódulos cada uno):

| Integrante / Rol | Submódulos Responsables | No. Tablas | Enfoque Principal |
| :--- | :--- | :---: | :--- |
| **Estudiante A** | **A1 a A9:** Cuentas y credenciales, Roles y permisos, Sesiones y auditoría de acceso, Segundo factor (2FA) y dispositivos, Privacidad y ARCO, Catálogo bibliográfico, Biblioteca personal, Copias y adquisiciones, Importación de biblioteca. | **50** | **Seguridad, Control de Acceso y Biblioteca** |
| **Estudiante B** | **B1 a B9:** Sesiones de lectura con cronómetro, Notas y citas, Reseñas y calificaciones, Metas y hábitos, Recordatorios y notificaciones, Logros y niveles, Estadísticas y reportes, Clubes de lectura y social, Auditoría, sincronización y portabilidad. | **50** | **Lectura, Hábitos, Gamificación y Social** |

---

## 🗺️ Metodología y Fases del Proyecto

El avance del proyecto se rige por las 4 fases establecidas en el programa académico del TecNM:

```mermaid
flowchart TD
    F1["FASE 1: FUNDAMENTACIÓN (Completada)<br/>Diagnóstico contextual, delimitación del problema y matriz de distribución 50/50 tablas."] --> F2["FASE 2: ANÁLISIS Y MODELADO - AMSI (En Curso)<br/>Ingeniería de Requisitos, Casos de Uso, Secuencia Criptográfica, Clases y Despliegue."]
    F2 --> F3["FASE 3: DISEÑO TÉCNICO - FBD + REDES (Planificada)<br/>E-R Extendido, Relacional BCNF, Diseño LAN jerárquico, SITE y VLSM."]
    F3 --> F4["FASE 4: EJECUCIÓN TÉCNICA Y LEGAL - TODAS (Planificada)<br/>Scripts Multi-SGBD, Packet Tracer con Port Security, Aviso de Privacidad y Delitos."]
```

### Detalle de las Etapas Hasta Ahora:

1. **[Fase 1: Fundamentación](./Fundamentación/README.md):**
   * Diagnóstico contextual y delimitación del sistema *Book Tracker*.
   * Justificación técnica, operativa y económica.
   * Matriz de deslinde y distribución equitativa de las **100 tablas** (50 Estudiante A / 50 Estudiante B).
   * Verificación de la proporción requerida por la rúbrica (< 25% catálogos simples y $\ge$ 75% tablas transaccionales/intermedias/maestras/bitácoras).
2. **[Fase 2: Análisis y Modelado (AMSI)](./AMSI/README.md):**
   * Catálogo codificado de Requisitos Funcionales (`RF-A-xx` / `RF-B-xx`) y No Funcionales (`RNF-A-xx` / `RNF-B-xx`) disponible en [1.1_Ingenieria_de_Requisitos.pdf](./AMSI/1.
   * Modelado de Casos de Uso del negocio y del sistema con correcta sintaxis UML y especificación formal de Login disponible en [1.2 Modelado del Negocio y Casos de Uso.pdf](./AMSI/1.2%20Modelado%20del%20Negocio%20y%20Casos%20de%20Uso.pdf) 
   * Políticas de seguridad en tránsito (TLS 1.3), almacenamiento criptográfico (`bcrypt`/`Argon2`) y auditoría permanente (borrado lógico).
   * Diagrama General de Clases, Componentes, Despliegue y Prototipos Google Stitch disponible en [1.4 Diagrama General de Clases, Componentes, Despliegue y Prototipos.pdf](./AMSI/1.4%20Diagrama%20General%20de%20Clases,%20Componentes,%20Despliegue%20y%20Prototipos.pdf) 
3. **[Fase 3: Fundamentos de Base de Datos (FBD)](./FBD/README.md):**
   * Modelado Conceptual E-R Extendido y Lógico Relacional (100 tablas y 132 FKs) en [2.1_Modelado_Conceptual_ER_y_Logico_Relacional.md](./FBD/2.1_Modelado_Conceptual_ER_y_Logico_Relacional.md).
   * Magnitud, Estructura y Memoria Formal de Normalización (1FN → BCNF) en [2.2_Normalizacion_1FN_a_BCNF.pdf](./FBD/2.2_Normalizacion_1FN_a_BCNF.pdf) 

---

