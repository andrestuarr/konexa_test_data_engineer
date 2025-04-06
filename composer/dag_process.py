from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator, BigQueryInsertJobOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.google.cloud.transfers.gcs import GCSToLocalOperator
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from datetime import timedelta
import os

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'gcs_to_bigquery_with_transformation',
    default_args=default_args,
    description='Carga de datos de GCS a BigQuery y transformación de datos',
    schedule_interval=None,
)

# Variables inyectadas vía dag_run.conf
bucket_name = '{{ dag_run.conf["bucket_name"] }}'
file_name = '{{ dag_run.conf["file_name"] }}'
project_id = os.environ.get("GCP_PROJECT")

# Variables para el nombre de la tabla y la tabla transformada
table_name = "{{ dag_run.conf['file_name'].split('/')[-1] }}"
transform_table_name = "{{ dag_run.conf['file_name'].split('/')[-1] }}_transform"

# Step 1: Asegura que exista el dataset en BigQuery.
create_dataset = BigQueryCreateEmptyDatasetOperator(
    task_id='ensure_exist_dataset_raw',
    dataset_id=bucket_name,
    project_id=project_id,
    location='US',
    exists_ok=True,
    dag=dag,
)

# Step 2: Cargar datos desde GCS a BigQuery.
gcs_to_bq = GCSToBigQueryOperator(
    task_id='gcs_to_bq',
    bucket=bucket_name,
    source_objects=[file_name],
    destination_project_dataset_table=f'{project_id}.{bucket_name}.{table_name}',
    schema_object_bucket='bucket-de-esquemas',
    schema_object='esquemas/mi_tabla_schema.json',
    source_format='CSV',
    skip_leading_rows=1,
    field_delimiter=',',
    write_disposition='WRITE_TRUNCATE',
    create_disposition='CREATE_IF_NEEDED',
    dag=dag,
)

# Step 3: Descargar el archivo SQL desde GCS.
download_sql_file = GCSToLocalOperator(
    task_id='download_sql_file',
    bucket_name='bucket-de-transformaciones',
    object_name=f'transformaciones/{file_name}_query.sql',
    local_file='/tmp/template_query.sql',
    google_cloud_storage_conn_id='google_cloud_default',
    dag=dag,
)

# Step 4: Leer el contenido del archivo SQL descargado.
def read_sql_file(**kwargs):
    with open('/tmp/template_query.sql', 'r') as f:
        return f.read()

read_sql = PythonOperator(
    task_id='read_sql_file',
    python_callable=read_sql_file,
    provide_context=True,
    dag=dag,
)

# Step 5: Ejecutar la transformación en BigQuery usando el contenido del archivo SQL.
bq_transform = BigQueryInsertJobOperator(
    task_id='bq_transform',
    configuration={
        "query": {
            "query": "{{ task_instance.xcom_pull(task_ids='read_sql_file') }}",
            "useLegacySql": False,
            "destinationTable": {
                "projectId": project_id,
                "datasetId": bucket_name,
                "tableId": transform_table_name
            },
            "writeDisposition": "WRITE_TRUNCATE",
            "createDisposition": "CREATE_IF_NEEDED"
        }
    },
    location="US",
    dag=dag,
)

create_dataset >> gcs_to_bq >> download_sql_file >> read_sql >> bq_transform
