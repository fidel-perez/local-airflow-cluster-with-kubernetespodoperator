minikube delete
# Remove any active port forwarding / volume sharing
pkill -f 'minikube'

minikube start --vm-driver=docker --cpus 8 --memory 16g --kubernetes-version v1.21.14
helm repo add apache-airflow https://airflow.apache.org
helm repo update
minikube kubectl -- create namespace airflow
minikube mount ${PWD}/airflow-home:/opt/airflow/mounted-from-host &

minikube kubectl -- apply -f volumes.yaml

# Load a custom Airflow image into the cluster.
# This also shows how to be able to install requirements.txt into our Airflow setup.
docker build -t custom-airflow-image:latest .
minikube image load custom-airflow-image:latest

helm install airflow apache-airflow/airflow --namespace airflow -f override.yaml --version 1.6.0 --debug
minikube kubectl -- port-forward svc/airflow-webserver 58080:8080 --namespace airflow --address=0.0.0.0 &