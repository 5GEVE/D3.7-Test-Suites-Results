*** Settings ***
Suite Teardown    Close All Connections
Library           SSHLibrary
Library           String
Library           Collections
Library           BuiltIn
Library           Dialogs

*** Variables ***

${ADDRESS}          10.9.8.203
${USERNAME}         testbed
${PASSWORD}         5g_€v$.!9

*** Test Cases ***
Execute command
    Open Connection to DCM and Log In
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/kafka-elk && sudo docker-compose up -d
    Sleep   30s
    Pause Execution     Go to the DCM server and execute the following: 'cd /home/<user>/5geve-wp4-monitoring-dockerized-env/filebeat && sudo docker run -d --name filebeat filebeat'
    Pause Execution     Go to the DCM server and execute the following: 'sudo docker exec -it kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topictest --max-messages 13323 --from-beginning > /tmp/filebeat_change.txt', and then, press Enter to continue
    Pause Execution     Go to the DCM server and execute the following in a different terminal: 'sudo docker exec -u root -it filebeat /bin/bash'. Then, execute, within the filebeat container: 'cat /tmp/asti-metrics-json-chains.txt', and next, 'echo "value_2" | tee -a /tmp/asti-metrics-json-chain.txt > /dev/null'. Finally, execute 'exit' within the container and then, press Enter to continue
    ${stdout}=      Execute Command     cat /tmp/filebeat_change.txt
    Should Contain    ${stdout}     Processed a total of 13323 messages
    Should Contain    ${stdout}     value_2
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/kafka-elk && sudo docker-compose down
    Pause Execution     Go to the DCM server and execute the following: 'sudo docker container stop filebeat && sudo docker container rm filebeat'

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
