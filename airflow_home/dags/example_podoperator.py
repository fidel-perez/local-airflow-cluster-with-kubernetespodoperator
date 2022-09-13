import pendulum
from airflow.decorators import dag
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)


@dag(
    dag_id="example_podoperator",
    start_date=pendulum.datetime(2022, 9, 13, 0, 0, 0, tz="UTC"),
    schedule_interval=None,
    catchup=False,
    tags=["example"],
)
def example_podoperator_dag() -> None:
    KubernetesPodOperator(
        task_id="simple-podoperator",
        name="simple-podoperator",
        namespace="airflow",
        image="debian",
        cmds=["bash", "-cx"],
        arguments=["echo", "10"],
        do_xcom_push=False,
    )


my_dag = example_podoperator_dag()
