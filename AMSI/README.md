# Fase 2: Análisis y Modelado de Sistemas de Información (AMSI)

> **Clave de la Asignatura:** IFE-1005  
> **Competencia Específica:** Analiza y modela proyectos de sistemas de información aplicando el paradigma orientado a objetos.  
> **Proyecto:** *Book Tracker* — Plataforma Integral de Gestión de Lectura y Hábitos  


---

## 1. Alcance y Objetivos de la Fase

Esta fase formaliza la ingeniería de software de *Book Tracker* mediante modelos orientados a objetos con notación estándar UML, cubriendo desde la captura y clasificación rigurosa de requisitos hasta el diseño de la arquitectura física y lógica en 3 capas.

Todos los entregables de esta etapa están diseñados para alcanzar el nivel **Excelente (100%)** de acuerdo con la **Rúbrica Analítica de AMSI**.

---

## 2. Estructura de Entregables según la Rúbrica Oficial

### Criterio 1.1: [Ingeniería de Requisitos](./1.1%20Ingenier%C3%ADa%20de%20Requisitos.docx) (Ponderación: 20%)

> 📄 **Documento de entrega:** [1.1 Ingeniería de Requisitos.docx](./1.1%20Ingenier%C3%ADa%20de%20Requisitos.docx)

* **Catálogo Formal y Codificado:** Requisitos Funcionales (`RF-A-xx` y `RF-B-xx`) y Requisitos No Funcionales (`RNF-A-xx` y `RNF-B-xx`), cubriendo los 18 submódulos del sistema con autoría explícita:
  * **Estudiante A:** Submódulos A1 a A9 (Seguridad, Control de Acceso, Privacidad/ARCO, Catálogo Bibliográfico y Biblioteca Personal).
  * **Estudiante B:** Submódulos B1 a B9 (Sesiones con Cronómetro, Notas, Reseñas, Metas/Hábitos, Notificaciones, Gamificación, Estadísticas, Social y Auditoría).
* **Especificaciones Críticas de Seguridad:**
  * **Seguridad en Tránsito:** Cifrado obligatorio TLS 1.3 en todas las comunicaciones cliente-servidor.
  * **Almacenamiento Criptográfico:** Persistencia de credenciales exclusivamente mediante funciones hash robustas y salting (`bcrypt` con factor de costo $\ge 12$ o `Argon2id`). Prohibición absoluta de texto plano.
  * **Políticas de Acceso y Sesión:** Control de sesiones concurrentes, revocación de tokens JWT/Bearer, bloqueo automático tras intentos fallidos y bitácora de auditoría inmutable.
  * **Regla Transversal de Auditoría:** Todas las tablas y entidades registran `creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion` y `activo` (eliminación lógica).

---

### Criterio 1.2: Modelado del Negocio y Casos de Uso (Ponderación: 25%)

* **Diagramas UML de Casos de Uso:**
  * Diagrama general del sistema y diagramas por submódulo.
  * Aplicación estricta de estereotipos y relaciones estándar: `«include»`, `«extend»` y jerarquías de generalización entre actores (Lector, Administrador, Soporte).
* **Especificación Tabular Expandida:**
  * Documentación exhaustiva con: Código, Nombre, Actor(es), Precondiciones, Poscondiciones, Flujo Principal (paso a paso), Flujos Alternos y Escenarios de Excepción.
* **Caso de Uso Crítico Obligatorio:**  
  * **CU-A-01: Autenticación de Usuario y Control de Sesión (Login)**, modelando validación de credenciales, derivación de hash, generación de token de sesión, registro en bitácora de acceso y contingencia por bloqueo de cuenta.

---

### Criterio 1.3: Modelado de Interacción y Secuencia Criptográfica (Ponderación: 25%)

* **Diagrama de Secuencia del Proceso de Autenticación Segura (Login):**
  Modela el ciclo de vida e intercambio sincrónico y asincrónico entre cuatro capas bien delimitadas:
  1. **Capa de Presentación (Vista / UI):** Captura de credenciales y envío seguro por HTTPS/TLS.
  2. **Capa de Control (Controlador de Seguridad / AuthController):** Orquestación de la petición, verificación de directivas de bloqueo y llamada al servicio criptográfico.
  3. **Capa de Servicios Criptográficos (CryptoService):** Verificación de salting y función de derivación hash (`bcrypt.verify` / `Argon2`).
  4. **Capa de Persistencia (Repositorio de Datos / UserRepository):** Consulta del usuario activo, recuperación del hash y registro inmediato en `bitacora_acceso` y `sesion_usuario`.
* **Diagramas de Secuencia Transaccionales:**
  Diagramas de interacción para las 4 transacciones de mayor complejidad del negocio:
  * Registro de sesión de lectura con cronómetro y cálculo de páginas/minuto (Submódulo B1).
  * Préstamo de ejemplar físico con validación de disponibilidad y fecha límite (Submódulo A8).
  * Ejercicio de derecho ARCO (Rectificación / Cancelación) con confirmación criptográfica (Submódulo A5).
  * Creación de reunión de club de lectura con notificación masiva a miembros (Submódulo B8).

---

### Criterio 1.4: Arquitectura del Dominio y Modelos de Implementación (Ponderación: 30%)

* **Diagrama de Clases del Dominio:**
  * Clases de dominio con atributos tipificados, visibilidad (`+`, `-`, `#`) y métodos operacionales.
  * Modelado riguroso de entidades transversales de seguridad: `Usuario`, `Rol`, `Permiso`, `UsuarioRol`, `RolPermiso`, `BitacoraAcceso` y `SesionUsuario`.
  * Tipos de relación formalmente representados: composición, agregación, asociación navegable y herencia.
* **Diagrama de Componentes:**
  * Organización modular del software: Componentes de interfaz de usuario, API Gateway / Controladores REST, Servicios de Negocio, Módulo Criptográfico, Conectores ORM/DAO y Capa Multi-SGBD.
* **Diagrama de Despliegue:**
  * Distribución física y lógica en topología de 3 capas: Estaciones de trabajo de clientes (navegadores/móviles), Servidor de Aplicaciones Web y Granja de Servidores de Base de Datos (nodo SQL Server corporativo y nodo PostgreSQL en software libre).
* **Prototipos de Interfaces (Mockups):**
  * Pantallas clave navegables y de alta fidelidad: Login y autenticación 2FA, Dashboard del Lector, Ficha bibliográfica, Cronómetro de lectura activa y Panel de Administración de Roles y Seguridad.

---

## 3. Estado de los Documentos de esta Carpeta

* 📄 **[1.1 Ingeniería de Requisitos.docx](./1.1%20Ingenier%C3%ADa%20de%20Requisitos.docx):** Documento oficial con el catálogo exhaustivo de Requisitos Funcionales y No Funcionales de los 18 submódulos, deslindado 50/50 por autor, con requerimientos de seguridad, rendimiento y auditoría.
* *(En desarrollo / Próximos entregables)*:
  * `2.2 Diagramas y Especificaciones de Casos de Uso.pdf`
  * `2.3 Diagrama de Secuencia de Login Criptográfico y Transacciones.pdf`
  * `2.4 Diagrama General de Clases, Componentes y Despliegue.pdf`
  * `2.5 Prototipos de Interfaces y Mockups de Alta Fidelidad.pdf`

