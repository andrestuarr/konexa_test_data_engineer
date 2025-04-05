FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY function_to_activate_dag.py .

ENV FUNCTION_TARGET=trigger_dag
ENV FUNCTION_SIGNATURE_TYPE=cloudevent

CMD ["functions-framework", "--target", "trigger_dag", "--signature-type", "cloudevent", "--port", "8080"]
