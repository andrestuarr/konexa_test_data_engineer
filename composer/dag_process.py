from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyDatasetOperator, BigQueryInsertJobOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
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
    description='Carga y transformación de datos de GCS a BigQuery',
    schedule_interval=None,
)

bucket_name = '{{ dag_run.conf["bucket_name"] }}'
file_name = '{{ dag_run.conf["file_name"] }}'
project_id = '{{ dag_run.conf["project_id"] }}'
table_name = "{{ dag_run.conf['file_name'].split('/')[-1] }}"
transform_table_name = "{{ dag_run.conf['file_name'].split('/')[-1] }}_transform"

# 1. Crear dataset si no existe
create_dataset = BigQueryCreateEmptyDatasetOperator(
    task_id='ensure_exist_dataset_raw',
    dataset_id=bucket_name,
    project_id=project_id,
    location='US',
    exists_ok=True,
    dag=dag,
)

# 2. Cargar CSV desde GCS a BQ
gcs_to_bq = GCSToBigQueryOperator(
    task_id='gcs_to_bq',
    bucket=bucket_name,
    source_objects=[file_name],
    destination_project_dataset_table=f'{project_id}.{bucket_name}.{table_name}',
    schema_object_bucket='konexa-schema-bucket-at',
    schema_object='Telecom_Customers_Churn.json',
    source_format='CSV',
    skip_leading_rows=1,
    field_delimiter=',',
    write_disposition='WRITE_TRUNCATE',
    create_disposition='CREATE_IF_NEEDED',
    dag=dag,
)

# 3. Transformación con SQL directamente en el DAG
transform_query = f"""
SELECT 
    CAST(customerID AS STRING) AS customerID,
    CAST(gender AS STRING) AS gender,
    CAST(SeniorCitizen AS INT64) AS SeniorCitizen,
    CAST(Partner AS STRING) AS Partner,
    CAST(Dependents AS STRING) AS Dependents,
    CAST(tenure AS INT64) AS tenure,
    CAST(PhoneService AS STRING) AS PhoneService,
    CAST(MultipleLines AS STRING) AS MultipleLines,
    CAST(InternetService AS STRING) AS InternetService,
    CAST(OnlineSecurity AS STRING) AS OnlineSecurity,
    CAST(OnlineBackup AS STRING) AS OnlineBackup,
    CAST(DeviceProtection AS STRING) AS DeviceProtection,
    CAST(TechSupport AS STRING) AS TechSupport,
    CAST(StreamingTV AS STRING) AS StreamingTV,
    CAST(StreamingMovies AS STRING) AS StreamingMovies,
    CAST(Contract AS STRING) AS Contract,
    CAST(PaperlessBilling AS STRING) AS PaperlessBilling,
    CAST(PaymentMethod AS STRING) AS PaymentMethod,
    CAST(MonthlyCharges AS FLOAT64) AS MonthlyCharges,
    CAST(TotalCharges AS FLOAT64) AS TotalCharges,
    CAST(Churn AS STRING) AS Churn
FROM 
    `{project_id}.{bucket_name}.{table_name}`
"""

bq_transform = BigQueryInsertJobOperator(
    task_id='bq_transform',
    configuration={
        "query": {
            "query": transform_query,
            "useLegacySql": False,
            "destinationTable": {
                "projectId": project_id,
                "datasetId": bucket_name,
                "tableId": transform_table_name,
            },
            "writeDisposition": "WRITE_TRUNCATE",
            "createDisposition": "CREATE_IF_NEEDED",
        }
    },
    location="US",
    dag=dag,
)

create_dataset >> gcs_to_bq >> bq_transform
