# Konexa Test - Data Engineer

Este proyecto es una solución integral para una prueba técnica de ingeniería de datos. La solución aborda tres requerimientos principales mediante una arquitectura basada en eventos:

## 🧩 Objetivo

1. Procesar automáticamente un archivo cuando se carga a un bucket en GCS.
2. Desplegar automáticamente una Cloud Function para manejar el procesamiento.
3. Ejecutar un DAG en Cloud Composer para cargar el archivo en BigQuery y aplicar una transformación.

---

## ⚙️ Arquitectura de la solución

La solución implementa una **arquitectura orientada a eventos** que cubre las tres preguntas:

<img src="imagenes/arquitectura.jpg" alt="Descripción" width="750">


1. ✅ **Subida de archivo a GCS**  
   Dispara un evento que activa una Cloud Function.

2. 🚀 **Cloud Function (Event Trigger)**  
   La función obtiene los metadatos del archivo y lanza un DAG en Cloud Composer.

3. 📈 **DAG en Composer (Airflow)**  
   El DAG:
   - Asegura la existencia del dataset en BigQuery.
   - Carga el archivo desde GCS a BigQuery.
   - Ejecuta una transformación SQL directamente sobre los datos cargados.



   <img src="imagenes/dag.png" alt="Descripción" width="750">

---

## 📁 Estructura del proyecto



---

## 🛠️ Tecnologías usadas

- **Google Cloud Platform (GCP)**  
  - Cloud Functions  
  - Cloud Storage  
  - BigQuery  
  - Cloud Composer (Airflow)

- **Terraform** — Para Infraestructura como Código  
- **GitHub Actions** — Para CI/CD automatizado  
- **Python** — Lógica de Cloud Function y DAG

---

## 🚀 Despliegue

1. Clonar el repositorio y configurar credenciales GCP.
2. Editar las variables en los archivos `variables.tf`.
3. Ejecutar los comandos de Terraform:
   ```bash
   terraform init
   terraform apply