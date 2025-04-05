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
    `{{ dag_run.conf['project_id'] }}.{{ dag_run.conf['bucket_name'] }}.{{ dag_run.conf['file_name'].split('/')[-1] }}`