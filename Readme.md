# Plantilla de Proyecto Looker con CI/CD (LAMS & Spectacles)

Este repositorio sirve como plantilla base para iniciar nuevos proyectos de desarrollo en Looker. Incluye una estructura de carpetas organizada según las mejores prácticas y un flujo de trabajo de GitHub Actions preconfigurado para Integración Continua y Despliegue Continuo (CI/CD).

El objetivo es estandarizar el desarrollo, asegurar la calidad del código mediante linters y validadores automáticos, y facilitar el despliegue a producción.

---

## 1. Estructura del Proyecto

El proyecto sigue una estructura modular para mantener el código LookML organizado y escalable:


```
.
├── .github/workflows/    # Contiene la definición del pipeline de CI/CD
│   └── lookml-ci-checks.yml
├── dashboards/           # Archivos LookML Dashboard (*.dashboard.lkml)
├── data_test/            # Tests de datos (*.lkml) para verificar la integridad
├── models/               # Archivos de Modelo (*.model.lkml). Aquí se definen las conexiones y explores.
│   └── template_model.model
├── views/                # Todas las vistas del proyecto
│   ├── base_layer/       # Vistas base generadas directamente de tablas físicas (1:1)
│   ├── derived_tables/   # Vistas basadas en consultas SQL o NDTs
│   ├── parameters/       # Vistas que solo contienen parámetros para interactividad
│   └── refinements/      # Extensiones o refinamientos de otras vistas
└── manifest.lkml         # Archivo de manifiesto del proyecto (nombre, dependencias, etc.) y definición de LAMS rules.
```

---

## 2. Funcionamiento del Workflow de CI/CD

Este repositorio incluye un workflow de GitHub Actions (`.github/workflows/lookml-ci-checks.yml`) y otra versión igual para CircleCI que se ejecuta automáticamente en `pull_request` y `push` a la rama principal (ej. `develop` o `master`).

El pipeline utiliza dos herramientas principales:

### A. LAMS (Look At Me Sideways)
Es un "linter" o guía de estilo para LookML.
* **Función:** Analiza el código en busca de errores de estilo, sintaxis o malas prácticas definidas por el equipo.
* **En el workflow:** Se instala y ejecuta para asegurar que el código nuevo cumpla con los estándares de calidad antes de ser fusionado.

### B. Spectacles
Es la herramienta principal de validación y testing para Looker. Realiza comprobaciones funcionales contra la instancia de Looker.

El workflow ejecuta diferentes comprobaciones según el evento:

* **En un Pull Request (Rama de feature):**
    * `spectacles sql`: Verifica que el SQL generado por los explores sea válido en el data warehouse.
    * `spectacles lookml`: Realiza la validación estándar de LookML (equivalente al botón "Validate LookML" en el IDE).
    * `spectacles content`: Verifica que los cambios no rompan dashboards o looks existentes.
    * `spectacles assert`: Ejecuta los Tests de Datos (definidos en la carpeta `data_test/`) para asegurar la calidad de los datos.

* **Al hacer Merge a la rama principal (ej. `develop`):**
    * Ejecuta las mismas validaciones anteriores (SQL, LookML, Content) sobre la rama principal.
    * **Deploy Webhook:** Si todas las pruebas pasan, llama a un webhook de Looker para desplegar los cambios automáticamente en la instancia.

---

## 3. Pasos para iniciar un proyecto nuevo desde esta plantilla

Para comenzar un nuevo proyecto utilizando esta base:

1.  **Crear el Repositorio en GitHub:**
    * Ve a la página principal de este repositorio plantilla en GitHub.
    * Haz clic en el botón verde **"Use this template"** y selecciona "Create a new repository".
    * Asigna un nombre a tu nuevo repositorio (ej. `analytics-proyecto-ventas`) y créalo.

2.  **Clonar y Personalizar:**
    * Clona tu *nuevo* repositorio en tu máquina local.
    * **Renombrar el modelo:** Ve a la carpeta `models/` y cambia el nombre de `template_model.model` al nombre deseado para tu proyecto (ej. `ventas.model`).
    * **Configurar la conexión:** Abre el archivo `.model` renombrado y cambia `connection: "..."` por el nombre de la conexión real en tu instancia de Looker que usará este modelo.
    * Haz commit y push de estos cambios iniciales a tu nuevo repositorio.

---

## 4. Configuración del Proyecto (Looker y GitHub)

Una vez creado el repositorio, es necesario configurar la instancia de Looker y los secretos de GitHub para que el CI/CD funcione.

### A. Configuración en la Instancia de Looker

1.  **Crear el Proyecto:** En Looker, ve a **Develop > Manage LookML Projects** y crea un nuevo proyecto en blanco.
2.  **Conectar a Git:** Configura la conexión de Git usando la URL HTTPS de tu **nuevo repositorio de GitHub** (el que creaste en el paso 3).
3.  **Activar Advanced Deploy Mode:** Una vez conectado Git, en la página de configuración del proyecto en Looker, busca la sección de opciones de despliegue y activa el **"Advanced Deploy Mode"**. Esto es obligatorio para que el webhook de despliegue del workflow funcione.
4.  **Obtener el Webhook Secret:** Al activar el modo avanzado, Looker te proporcionará un "Deploy Webhook Secret". Cópialo, lo necesitarás para los secretos de GitHub.

### B. Configuración de Secretos en GitHub

Para que Spectacles y el Deploy funcionen, el workflow necesita credenciales. Ve a la configuración de tu nuevo repositorio en GitHub -> **Settings > Secrets and variables > Actions** y crea los siguientes "Repository secrets":

| Nombre del Secreto | Descripción / Valor |
| :--- | :--- |
| `INSTANCE_URL` | La URL base de tu instancia de Looker (ej. `https://miempresa.cloud.looker.com`, sin barra al final). |
| `LOOKER_CLIENT_ID` | Client ID de una API Key de Looker (preferiblemente de un usuario servicio con permisos de Admin o Desarrollador). |
| `LOOKER_CLIENT_SECRET`| Client Secret correspondiente al ID anterior. |
| `PROJECT_NAME` | El nombre exacto del proyecto tal como se definió en Looker al crearlo. |
| `LOOKER_WEBHOOK_SECRET` | El secreto del deploy webhook obtenido en el paso de configuración de "Advanced Deploy Mode" en Looker. |

---

## 5. Resolución de Problemas Comunes

### Error: "Spectacles testing 0/0 explores" o el modelo no aparece en Model Sets

**Síntoma:** El workflow de GitHub falla indicando que Spectacles no encontró explores para testear, o al intentar crear un Model Set en Looker, tu nuevo modelo no aparece en la lista.

**Causa:** Aunque el archivo `.model.lkml` existe en el repositorio, Looker no lo "activa" automáticamente para su uso en la API o en la gestión de permisos por seguridad hasta que se configura explícitamente.

**Solución:**

1.  Asegúrate de que estás fuera del "Modo Desarrollo" en Looker.
2.  Navega al menú **Develop** (arriba a la derecha) y selecciona **Projects**.
3.  Busca tu proyecto en la lista y si aparece el modelo al que quieres hacer referencia. Entoces, haz clic en el botón **Configure** (Configurar) a su derecha.
    *(Si aparece un icono de advertencia amarillo al lado del proyecto, es indicativo de que falta esta configuración).*
4.  En la pantalla de configuración, desplázate hasta la lista de Modelos. Verás tu archivo `.model` con la casilla desmarcada (y posiblemente el texto en rojo).
5.  **Marca la casilla de verificación** al lado de tu modelo.
6.  Haz clic en **Save Project Configuration**.

Una vez hecho esto, vuelve a ejecutar el workflow en GitHub y Spectacles debería detectar el modelo correctamente.

```
