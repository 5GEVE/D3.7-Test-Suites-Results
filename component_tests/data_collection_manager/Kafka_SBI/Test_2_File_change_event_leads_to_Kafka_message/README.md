# Test 2 - File change event leads to Kafka message

For this test, the Kafka-ELK Dockerized environment with Filebeat available [here](https://github.com/5GEVE/5geve-wp4-monitoring-dockerized-env) must be built beforehand (in this example, the repository has been set in the $HOME directory). To do this, just follow steps 1 and 2 described in the README file.

In order to test it:

```sh
# 1. Install modules for enabling Dialogs library in your server (for Python 2.7)
sudo apt-get install python-tk tk-dev

# 2. Modify the variables defined in filebeat_change.robot to fit in your scenario.

# 3. Execute the Robot Framework script.
robot filebeat_change.robot
```
