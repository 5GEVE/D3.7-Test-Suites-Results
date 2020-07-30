# Test 1 - Kafka-Elasticsearch configuration

For this test, the Kafka-ELK Dockerized environment available [here](https://github.com/5GEVE/5geve-wp4-monitoring-dockerized-env) must be built beforehand (in this example, the repository has been set in the $HOME directory). To do this, just follow steps 1 and 2 described in the README file (only running the kafka-elk module, not the filebeat one).

Moreover, you have to put the metric_generator_example.py script in the $HOME directory of the targeted server.

The last test step, related to check the data in Kibana, can be followed after executing this test case. The instructions are present in the Dockerized environment Github repository aforementioned.

In order to test it:

```sh
# 1. Install modules for enabling Dialogs library in your server (for Python 2.7)
sudo apt-get install python-tk tk-dev

# 2. Modify the variables defined in kafka_elk.robot to fit in your scenario.

# 3. Execute the Robot Framework script.
robot kafka_elk.robot
```
