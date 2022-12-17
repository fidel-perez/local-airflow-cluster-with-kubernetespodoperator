FROM apache/airflow:2.3.4
COPY requirements.txt .
RUN pip install -r requirements.txt