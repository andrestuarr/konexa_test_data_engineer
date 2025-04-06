import functions_framework
import requests
import google.auth
from google.auth.transport.requests import Request
import os
import logging
import json

# Configuración de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Variables de entorno
COMPOSER_REGION = os.getenv("COMPOSER_REGION")
COMPOSER_ENV_NAME = os.getenv("COMPOSER_ENV_NAME")
DAG_ID = 'gcs_to_bigquery_with_transformation'
PROJECT_ID = os.getenv("GCP_PROJECT")

def trigger_dag(dag_id: str, payload: dict):
    try:
        logger.info("Obteniendo credenciales por defecto...")
        credentials, _ = google.auth.default(scopes=["https://www.googleapis.com/auth/cloud-platform"])
        credentials.refresh(Request())

        logger.info("Consultando detalles del entorno de Composer...")
        env_url = f"https://composer.googleapis.com/v1/projects/{PROJECT_ID}/locations/{COMPOSER_REGION}/environments/{COMPOSER_ENV_NAME}"
        env_resp = requests.get(env_url, headers={"Authorization": f"Bearer {credentials.token}"})
        env_resp.raise_for_status()

        airflow_uri = env_resp.json()["config"]["airflowUri"]
        logger.info(f"Airflow URI obtenido: {airflow_uri}")

        dag_endpoint = f"{airflow_uri}/api/v1/dags/{dag_id}/dagRuns"
        dag_run_id = f"triggered_{payload['file_name'].replace('/', '_')}"

        body = {
            "dag_run_id": dag_run_id,
            "conf": payload,
        }

        logger.info(f"Enviando solicitud para disparar DAG '{dag_id}' con run_id '{dag_run_id}'")
        response = requests.post(
            dag_endpoint,
            headers={
                "Authorization": f"Bearer {credentials.token}",
                "Content-Type": "application/json",
            },
            json=body,
        )
        response.raise_for_status()

        logger.info(f"DAG '{dag_id}' disparado exitosamente. Respuesta: {response.json()}")
        return response.json()

    except requests.HTTPError as http_err:
        logger.error(f"HTTP error al disparar DAG: {http_err.response.status_code} - {http_err.response.text}")
        raise
    except Exception as e:
        logger.exception("Error inesperado al disparar el DAG.")
        raise

@functions_framework.cloud_event
def gcs_trigger(cloud_event):
    try:
        data = cloud_event.data
        relevant_info = {
            "bucket": data.get("bucket"),
            "file_name": data.get("name"),
            "size": data.get("size"),
            "content_type": data.get("contentType"),
            "created": data.get("timeCreated"),
            "event_type": cloud_event.get("type"),
        }

        logger.info(f"Evento GCS recibido: {json.dumps(relevant_info, indent=2)}")

        payload = {
            "bucket_name": data["bucket"],
            "file_name": data["name"],
            "project_id": PROJECT_ID,
        }

        trigger_dag(DAG_ID, payload)

    except Exception as e:
        logger.exception("Error procesando el evento de GCS.")

