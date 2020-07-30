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
    Execute Command    python3 /home/${USERNAME}/metric_generator_example.py topictest
    Sleep   5s
    Pause Execution     Go to the DCM server and execute the following: 'sudo docker exec -it kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topictest --max-messages 1 --from-beginning > /tmp/kafka_elk.txt', and then, press Enter to continue
    ${stdout}=      Execute Command     cat /tmp/kafka_elk.txt
    Should Contain    ${stdout}     value_1
    Execute Command    cd /home/${USERNAME}/5geve-wp4-monitoring-dockerized-env/kafka-elk && sudo docker-compose down

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
