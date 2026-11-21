# Fase 2: Análisis y Modelado de Sistemas de Información (AMSI)

> **Asignatura:** IFE-1005 — Análisis y Modelado de Sistemas de Información  
> **Proyecto:** *Book Tracker* — Plataforma Integral de Gestión de Lectura  

---

## 📌 Resumen Ejecutivo

Esta fase formaliza la ingeniería de software de *Book Tracker* bajo el paradigma orientado a objetos (UML 2.5), deslindado al **50/50** entre los dos integrantes (18 submódulos y 100 tablas). Comprende el levantamiento formal de requisitos, modelado de negocio y casos de uso, diseño de interacción criptográfica y la arquitectura lógica, física y de interfaces del sistema.

---


| Criterio y Ponderación | Lo que se Califica (Rúbrica Oficial) | Lo que Tenemos (Entregables y Contenido) | Notas y Estado |
| :--- | :--- | :--- | :---: |
| **1.1 Ingeniería de Requisitos**<br>`(20%)` | • Catálogo codificado de RF y RNF.<br>• Deslinde equitativo explícito (50/50).<br>• Especificación formal de seguridad y criptografía (prohibido texto plano).<br>• Auditoría y políticas de baja lógica. | • **85 Requisitos Funcionales** (`RF-A-01` a `42`, `RF-B-01` a `43`).<br>• **30 Requisitos No Funcionales** (`RNF-A-01` a `15`, `RNF-B-01` a `15`).<br>• Cifrado TLS 1.3 en tránsito y hashing `Argon2id` / `bcrypt` ($\ge 12$).<br>• Regla obligatoria de 9 campos de auditoría y baja simbólica transversal en las 100 tablas. | **100% Excelente**<br>*(Trazabilidad total con la base de datos de 100 tablas)* |
| **1.2 Modelado del Negocio y Casos de Uso**<br>`(25%)` | • Diagramas UML con sintaxis formal (`«include»`, `«extend»`, actores).<br>• Casos de uso de negocio y de sistema.<br>• Especificación tabular expandida formal.<br>• Inclusión obligatoria del caso de uso crítico de **Autenticación (Login)**. | • **13 Diagramas UML Mermaid** con código de color por actor (`D00` a `D12`): Jerarquía (`D00`), Negocio (`D01`), General del Sistema (`D02`) y 10 sub-diagramas específicos.<br>• **20 Casos de Uso Expandidos** (A1-A11 y B1-B9) con precondiciones, flujos principal/alternos/excepciones.<br>• **CU-A-01 Login con 2FA** modelado como proceso crítico. | **100% Excelente**<br>*(Diagramas PNG en alta resolución incrustados en el documento final)* |
| **1.3 Modelado de Interacción y Secuencia Criptográfica**<br>`(25%)` | • Diagrama de secuencia formal de Autenticación Segura (Login).<br>• Arquitectura desacoplada en capas.<br>• Manejo riguroso de tokens, derivación criptográfica y bitácora.<br>• Secuencias transaccionales distribuidas 50/50. | • **Secuencia de Login Seguro en 4 capas** (Presentación UI, SecurityController, CryptoService y DatabaseRepository).<br>• **4 Diagramas de Secuencia Transaccionales**:<br>&nbsp;&nbsp;– *Estudiante A:* Catalogación con ISBN y Adquisición con SHA-256.<br>&nbsp;&nbsp;– *Estudiante B:* Cronómetro activo con PPM y Convocatoria de Club con despacho SMTP. | **100% Excelente**<br>*(Procesos sincrónicos y asincrónicos con blindaje criptográfico)* |
| **1.4 Arquitectura del Dominio y Modelos de Implementación**<br>`(30%)` | • Diagrama General de Clases (UML 2.5) con herencia y visibilidad.<br>• Diagrama de Componentes de software.<br>• Diagrama de Despliegue Físico y Lógico (red y servidores).<br>• Prototipos de interfaz de usuario de vistas críticas. | • **Diagrama de Clases del Dominio**: Herencia transversal de `EntidadBase` (9 campos de auditoría) y modelo RBAC/Seguridad.<br>• **Diagrama de Componentes**: 4 capas modulares desacopladas.<br>• **Diagrama de Despliegue Corporativo**: Topología en 3 niveles, DMZ con Nginx y SITE Multi-SGBD (**SQL Server 2022** + **PostgreSQL 16**).<br>• **5 Prototipos de Pantallas Maestras** generados en **Google Stitch** con fichas técnicas y prompts reproducibles. | **100% Excelente**<br>*(Diseño integral de software, hardware y UX/UI moderno)* |

---

## 📂 Entregables Oficiales

| Criterio | Documento Oficial | Descripción Clave |
| :--- | :--- | :--- |
| **1.1 Requisitos** | 📄 [1.1_Ingenieria_de_Requisitos.pdf](./1.1_Ingenieria_de_Requisitos.pdf) | Catálogo formal de 85 RF y 30 RNF codificados, deslindados 50/50 y directivas de seguridad criptográfica. |
| **1.2 Casos de Uso** | 📄 [1.2 Modelado del Negocio y Casos de Uso.pdf](./1.2%20Modelado%20del%20Negocio%20y%20Casos%20de%20Uso.pdf) | Familia de 13 diagramas UML con código de colores por actor y 20 especificaciones tabulares expandidas. |
| **1.3 Secuencia Criptográfica** | 📄 [1.3 Modelado de Interacción y Secuencia Criptográfica.pdf](./1.3%20Modelado%20de%20Interacci%C3%B3n%20y%20Secuencia%20Criptogr%C3%A1fica.pdf) | Secuencia de Login Seguro en 4 capas y 4 secuencias transaccionales críticas del negocio. |
| **1.4 Clases, Despliegue y Prototipos** | 📄 [1.4 Diagrama General de Clases, Componentes, Despliegue y Prototipos.pdf](./1.4%20Diagrama%20General%20de%20Clases,%20Componentes,%20Despliegue%20y%20Prototipos.pdf) | Clases con `EntidadBase`, arquitectura de componentes, topología Multi-SGBD y prototipos Google Stitch. |

---

## 👥 Resumen del Deslinde de Responsabilidades (50/50)

* **Estudiante A (Seguridad, Control de Acceso y Biblioteca):**
  * Submódulos A1 a A9 (50 tablas del modelo relacional).
  * Seguridad perimetral, autenticación 2FA, control de acceso RBAC, solicitudes ARCO y gestión del catálogo/copias bibliográficas.
  * Casos de uso `CU-A-01` a `CU-A-11` e interfaces `UI-A-01`, `UI-A-02` y `UI-A-03`.

* **Estudiante B (Hábitos, Lectura, Gamificación y Comunidad):**
  * Submódulos B1 a B9 (50 tablas del modelo relacional).
  * Monitoreo de sesiones en vivo con cronómetro, notas y citas, reseñas con spoilers, hábitos, metas, logros sociales y auditoría analítica.
  * Casos de uso `CU-B-01` a `CU-B-09` e interfaces `UI-B-01` y `UI-B-02`.

---

## 🗂️ Estructura del Directorio

```text
AMSI/
├── 📄 1.1_Ingenieria_de_Requisitos.pdf
├── 📄 1.2 Modelado del Negocio y Casos de Uso.pdf
├── 📄 1.3 Modelado de Interacción y Secuencia Criptográfica.pdf
├── 📄 1.4 Diagrama General de Clases, Componentes, Despliegue y Prototipos.pdf
├── 📘 README.md                             # Índice general y matriz analítica de evaluación
└── 📁 diagramas/
    ├── 📁 mmd/                              # Código fuente Mermaid original (.mmd)
    └── 📁 png/                              # Diagramas renderizados en alta resolución
```
