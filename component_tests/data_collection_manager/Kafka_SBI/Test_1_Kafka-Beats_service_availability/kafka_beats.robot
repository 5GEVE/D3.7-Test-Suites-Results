*** Settings ***
Suite Teardown    Close All Connections
Library           SSHLibrary
Library           String
Library           Collections
Library           BuiltIn
Library           Dialogs

*** Variables ***

${ADDRESS}          10.9.8.204
${USERNAME}         user
${PASSWORD}         root

*** Test Cases ***
Execute command
    Open Connection to DCM and Log In
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/kafka-elk && sudo docker-compose up -d
    Sleep   30s
    ${filebeat_id}=     Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/filebeat && sudo docker run -d --name filebeat filebeat
    Sleep   15s
    Pause Execution     Go to the DCM server and execute the following: 'sudo docker exec -it kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topictest --max-messages 6661 --from-beginning > /tmp/kafka_beats.txt', and then, press Enter to continue
    ${stdout}=      Execute Command     cat /tmp/kafka_beats.txt
    Should Contain    ${stdout}     Processed a total of 6661 messages
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/kafka-elk && sudo docker-compose down
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/filebeat && sudo docker container stop ${filebeat_id} && sudo docker container rm ${filebeat_id}

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
