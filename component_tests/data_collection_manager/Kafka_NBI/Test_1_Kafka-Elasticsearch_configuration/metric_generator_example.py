from kafka import KafkaProducer
from kafka.errors import KafkaError
from kafka.future import log
import json
import random
import time
import re
import csv
import sys

# usage: python3 metric_generator.py {topic}
# e.g.   python3 metric_generator.py uc.4.france_nice.infrastructure_metric.expb_metricId

def publish(producer, topic_name):
    value = "value_1"
    print("Publishing in Kafka: %s", value)
    futures = producer.send(topic=topic_name, value=value)
    response = futures.get()
    print(response)

broker_ip_address = "10.9.8.203:9092"
topic_name = sys.argv[1]

producer = KafkaProducer(bootstrap_servers = broker_ip_address, value_serializer=lambda x: json.dumps(x).encode('utf-8'))

publish(producer, topic_name)
time.sleep(interval_value)

print("Script finished")
