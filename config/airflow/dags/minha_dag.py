from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime
# Criacao da DAG
mydag = DAG('minha_dag', description="Uma DAG",

schedule_interval=None, start_date=datetime(2024,7,30),
catchup=False)
# Criacao das tarefas
tarefa1 = BashOperator(task_id="t1", bash_command="sleep 5", dag=mydag)
tarefa2 = BashOperator(task_id="t2", bash_command="echo oi", dag=mydag)
# Ordem de execucao das tarefas
tarefa1 >> tarefa2