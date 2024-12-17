# Importar as bibliotecas
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

# Abrir connect
#   curl -X POST -H "Content-Type: application/json" --data @$KAFKA_HOME/connect/debezium-connector-mongodb/mongodb.json http://master:8083/connectors

# Como executar:
#   spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.1 main.py

# Comandos Kafka
#   kafka-topics.sh --list --bootstrap-server master:9092
#   kafka-topics.sh --bootstrap-server master:9092 --delete --topic meu-topico
#   kafka-console-consumer.sh --topic meu-topico.engdados.alunos --from-beginning --bootstrap-server master:9092

# Inicializar SparkSession
spark = SparkSession.builder \
    .appName("KafkaDebeziumStreaming") \
    .getOrCreate()

# Configuração para leitura do Kafka
df = (spark.readStream
    .format("kafka")
    .option("kafka.bootstrap.servers", "master:9092")
    .option("subscribe", "meu-topico.engdados.alunos")
    .option("startingOffsets", "earliest")  # Começa do início
    .load()
)

# Manter o streaming em execução até ser interrompido
query.awaitTermination()