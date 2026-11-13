# Fase 1: Fundamentación y Delimitación del Proyecto

> **Proyecto Integrador Multidisciplinario V**  
> **Tecnológico Nacional de México — Instituto Tecnológico Superior de Monclova**  
> **Sistema:** *Book Tracker* — Plataforma Integral de Gestión de Lectura, Biblioteca Personal, Hábitos y Analítica  
> **Asignaturas Concurrentes:** AMSI (IFE-1005) · FBD (AEF-1031) · RC (IFD-1020) · TLI (IFR-1024)

---

## 1. Diagnóstico Contextual y Definición del Problema

En la actualidad, los lectores enfrentan una notable dispersión de herramientas para gestionar sus hábitos de lectura, sus bibliotecas personales (físicas y digitales) y sus registros de progreso. Las soluciones comerciales existentes presentan limitaciones críticas:
1. **Falta de soberanía y privacidad sobre los datos:** Plataformas propietarias comercializan los hábitos de lectura y carecen de mecanismos claros de ejercicio de derechos ARCO o cumplimiento estricto con la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP).
2. **Desconexión entre la gestión bibliográfica y los hábitos cuantitativos:** Rara vez se integran en un mismo sistema el control físico/digital de ejemplares, préstamos a terceros, cronometraje de sesiones de lectura en tiempo real y analíticas de productividad lectora.
3. **Ausencia de infraestructura corporativa segura:** La mayoría de soluciones carecen de un modelo de datos transaccional normalizado, auditoría de eventos a bajo nivel y esquemas de seguridad multi-SGBD con cifrado robusto.

**Book Tracker** surge como una solución tecnológica corporativa y segura orientada a resolver esta problemática mediante una arquitectura orientada a objetos, un esquema relacional normalizado en BCNF de alta escala (100 tablas) y una infraestructura de red jerárquica con respaldo legal integral.

---

## 2. Justificación Técnica, Operativa y Económica

* **Justificación Técnica:** El proyecto integra un modelo de datos robusto sin entidades huérfanas, preparado para operar en un entorno **Multi-SGBD** (Microsoft SQL Server y PostgreSQL / MariaDB). Incorpora algoritmos criptográficos robustos (bcrypt / Argon2) para proteger credenciales y datos sensibles, cumpliendo con los principios de seguridad de la información.
* **Justificación Operativa:** Estandariza los flujos de trabajo de los lectores: catalogación bibliográfica, seguimiento de metas anuales y mensuales, control de préstamos, bitácoras de cambios y gamificación mediante logros y rachas.
* **Justificación Económica:** Ofrece una alternativa eficiente basada en estándares abiertos y arquitectura en capas que reduce costos de licenciamiento, optimizando recursos de hardware y almacenamiento en el centro de datos.

---

## 3. Objetivos del Proyecto

### Objetivo General
Diseñar e implementar una solución integral de software y arquitectura tecnológica corporativa (*Book Tracker*) que permita a los usuarios gestionar su biblioteca personal, registrar hábitos y sesiones de lectura en tiempo real, interactuar en comunidades lectoras y proteger su información personal, cumpliendo rigurosamente con los lineamientos académicos del TecNM y las normativas técnicas y legales vigentes.

### Objetivos Específicos
1. **Modelado y Requisitos (AMSI):** Elaborar el catálogo formal codificado de requisitos funcionales y no funcionales, diagramas de casos de uso expandidos, diagramas de secuencia criptográfica y arquitectura orientada a objetos en 3 capas.
2. **Diseño de Base de Datos (FBD):** Construir un modelo relacional de **100 tablas** normalizadas hasta la Forma Normal de Boyce-Codd (BCNF), garantizando una distribución equitativa de 50 tablas por integrante, con menos del 25% de catálogos simples y más del 75% de entidades transaccionales, maestras, intermedias y bitácoras.
3. **Infraestructura de Red (RC):** Diseñar una red LAN corporativa bajo el modelo jerárquico de 3 capas (Acceso, Distribución, Núcleo) con direccionamiento IPv4 optimizado con VLSM/CIDR, cableado estructurado bajo normas TIA/EIA y seguridad conmutada en capa 2 (Port Security).
4. **Marco Legal y Normativo (TLI):** Fundamentar el sistema bajo el Artículo 16 Constitucional y la LFPDPPP, redactar contratos de software a medida, SLA, EULA, aviso de privacidad integral, expediente INDAUTOR y matriz de prevención contra delitos informáticos del Código Penal Federal.

---

## 4. Matriz de Deslinde y Asignación Equitativa (50/50 Tablas)

Conforme a la rúbrica oficial (Criterio 2.2 y 2.3 de FBD), el sistema divide su universo de **100 tablas** de forma estrictamente equitativa (50 tablas por autor) con autoría explícita y trazabilidad en diccionario de datos y scripts:

```
                            PROYECTO BOOK TRACKER (100 TABLAS)
                     ┌───────────────────────┴───────────────────────┐
                     ▼                                               ▼
         ESTUDIANTE A (50 Tablas)                        ESTUDIANTE B (50 Tablas)
          Seguridad + Biblioteca                          Lectura + Hábitos + Social
   ┌─────────────────────────────────────┐         ┌─────────────────────────────────────┐
   │ A1: Cuentas y credenciales      (5) │         │ B1: Sesiones lectura y cronómetro(5)│
   │ A2: Roles y permisos            (4) │         │ B2: Notas y citas                (5)│
   │ A3: Sesiones y auditoría acceso (4) │         │ B3: Reseñas y calificaciones     (6)│
   │ A4: Segundo factor y dispositiv.(3) │         │ B4: Metas y hábitos              (7)│
   │ A5: Privacidad, preferencias/ARCO(6)│         │ B5: Recordatorios y notificacion.(5)│
   │ A6: Catálogo bibliográfico     (11) │         │ B6: Logros y niveles             (4)│
   │ A7: Biblioteca personal         (8) │         │ B7: Estadísticas y reportes      (3)│
   │ A8: Copias, compras y préstamos (7) │         │ B8: Clubes de lectura y social  (11)│
   │ A9: Importación de biblioteca   (2) │         │ B9: Auditoría, sincroniz./export.(4)│
   └─────────────────────────────────────┘         └─────────────────────────────────────┘
```

### Detalle de Módulos y Entidades — Estudiante A (Seguridad + Biblioteca)

| Submódulo | No. Tablas | Tablas del Submódulo | Caso de Uso Principal | Prefijo Requisitos |
| :--- | :---: | :--- | :--- | :--- |
| **A1. Cuentas y credenciales** | 5 | `usuario`, `perfil_usuario`, `credencial_usuario`, `historial_credencial`, `politica_contrasena` | Registrar usuario y gestionar perfil | `RF-A-01` a `06` |
| **A2. Roles y permisos** | 4 | `rol`, `permiso`, `rol_permiso`, `usuario_rol` | Administrar roles y permisos | `RF-A-07` a `10` |
| **A3. Sesiones y auditoría de acceso** | 4 | `sesion_usuario`, `bitacora_acceso`, `bloqueo_cuenta`, `token_recuperacion` | Autenticación y Control de Sesión | `RF-A-11` a `16` |
| **A4. Segundo factor y dispositivos** | 3 | `metodo_2fa`, `codigo_respaldo_2fa`, `dispositivo_usuario` | Configurar segundo factor y dispositivos | `RF-A-17` a `20` |
| **A5. Preferencias, privacidad y ARCO** | 6 | `idioma`, `preferencia_usuario`, `version_aviso_privacidad`, `consentimiento_privacidad`, `tipo_solicitud_arco`, `solicitud_arco` | Gestionar consentimiento y solicitudes ARCO | `RF-A-21` a `26` |
| **A6. Catálogo bibliográfico** | 11 | `autor`, `editorial`, `libro`, `tipo_colaborador`, `libro_autor`, `formato_libro`, `edicion`, `genero`, `libro_genero`, `serie_libro`, `libro_serie` | Consultar y registrar libro y edición | `RF-A-27` a `34` |
| **A7. Biblioteca personal** | 8 | `estado_lectura`, `ejemplar_usuario`, `etiqueta`, `etiqueta_ejemplar`, `estante`, `estante_ejemplar`, `coleccion`, `coleccion_ejemplar` | Organizar biblioteca personal y estantes | `RF-A-35` a `40` |
| **A8. Copias, adquisiciones y préstamos** | 7 | `copia_fisica`, `archivo_digital`, `contacto_prestamo`, `prestamo`, `wishlist_item`, `fuente_adquisicion`, `adquisicion` | Registrar compra, copia y préstamo | `RF-A-41` a `46` |
| **A9. Importación de biblioteca** | 2 | `importacion_biblioteca`, `detalle_importacion` | Importar biblioteca desde archivo (CSV/Goodreads) | `RF-A-47` a `50` |

### Detalle de Módulos y Entidades — Estudiante B (Lectura + Hábitos + Social)

| Submódulo | No. Tablas | Tablas del Submódulo | Caso de Uso Principal | Prefijo Requisitos |
| :--- | :---: | :--- | :--- | :--- |
| **B1. Sesiones de lectura y cronómetro** | 5 | `sesion_lectura`, `pausa_sesion_lectura`, `progreso_lectura`, `ciclo_lectura`, `lugar_lectura` | Registrar sesión con cronómetro | `RF-B-01` a `06` |
| **B2. Notas y citas** | 5 | `tipo_nota`, `nota`, `cita`, `nota_etiqueta`, `adjunto_nota` | Guardar notas, citas y destacados | `RF-B-07` a `11` |
| **B3. Reseñas y calificaciones** | 6 | `resena`, `calificacion`, `criterio_calificacion`, `calificacion_criterio`, `resena_reaccion`, `resena_comentario` | Escribir reseña y calificar por criterios | `RF-B-12` a `17` |
| **B4. Metas y hábitos** | 7 | `tipo_meta`, `meta_lectura`, `progreso_meta`, `habito_lectura`, `habito_programacion`, `registro_habito`, `racha_lectura` | Establecer metas de lectura y hábitos | `RF-B-18` a `23` |
| **B5. Recordatorios y notificaciones** | 5 | `recordatorio`, `canal_notificacion`, `tipo_evento_notificacion`, `preferencia_notificacion`, `notificacion` | Configurar recordatorios y alertas | `RF-B-24` a `28` |
| **B6. Logros y niveles** | 4 | `logro`, `logro_usuario`, `nivel_lector`, `movimiento_puntos` | Desbloquear logros y subir de nivel | `RF-B-29` a `33` |
| **B7. Estadísticas y reportes** | 3 | `estadistica_diaria`, `estadistica_mensual`, `reporte_generado` | Consultar métricas y generar reportes | `RF-B-34` a `38` |
| **B8. Clubes de lectura y social** | 11 | `club_lectura`, `rol_club`, `miembro_club`, `libro_club`, `reunion_club`, `asistencia_reunion`, `mensaje_club`, `seguimiento_usuario`, `reto_lectura`, `participante_reto`, `recomendacion_libro` | Clubes de lectura, reuniones y retos | `RF-B-39` a `46` |
| **B9. Auditoría, sincroniz. y portabilidad** | 4 | `auditoria_transaccion`, `auditoria_detalle_cambio`, `sincronizacion_dispositivo`, `exportacion_datos` | Auditar cambios y exportar datos (ARCO) | `RF-B-47` a `50` |

---

## 5. Cumplimiento de Criterios de la Rúbrica Oficial TecNM

| Criterio de la Rúbrica | Parámetro Exigido | Estado en el Proyecto |
| :--- | :--- | :---: |
| **Magnitud Total** | Mínimo 50 tablas por estudiante (100 en total) | ✅ **100 Tablas** (50 Estudiante A / 50 Estudiante B) |
| **Proporción de Catálogos** | Máximo 25% catálogos simples | ✅ **Cumple (< 25%)** |
| **Entidades Complejas** | Mínimo 75% transaccionales, intermedias, maestras y bitácoras | ✅ **Cumple (>= 75%)** |
| **Integridad Referencial** | Cero tablas huérfanas; 100% conectadas con PK/FK activas | ✅ **Cumple** |
| **Regla de Auditoría** | Campos de trazabilidad (`creado_por`, `fecha_creacion`, `modificado_por`, `fecha_modificacion`, `activo`) y borrado lógico | ✅ **Estandarizado en el 100% de tablas** |

---

## 6. Documentos y Artefactos de la Carpeta

* [Lista_100_Tablas_y_Matriz_Deslinde.xlsx](file:///c:/Users/Nat/OneDrive%20-%20Instituto%20Tecnol%C3%B3gico%20Superior%20de%20Monclova/Escritorio/Proyecto%20Integrador/Fundamentaci%C3%B3n/Lista_100_Tablas_y_Matriz_Deslinde.xlsx): Matriz oficial con la distribución de los 18 submódulos, detalle de las 100 tablas, clasificación tipológica y verificación de reglas de deslinde.
* [plantilla_diccionario_datos.xlsx](file:///c:/Users/Nat/OneDrive%20-%20Instituto%20Tecnol%C3%B3gico%20Superior%20de%20Monclova/Escritorio/Proyecto%20Integrador/Fundamentaci%C3%B3n/plantilla_diccionario_datos.xlsx): Plantilla técnica estandarizada para la documentación campo a campo de las 100 tablas (tipos de datos, longitudes, restricciones de integridad y descripción semántica).

