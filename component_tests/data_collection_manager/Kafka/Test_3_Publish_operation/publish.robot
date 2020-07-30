*** Settings ***
Suite Teardown    Close All Connections
Library           SSHLibrary
Library           String
Library           Collections
Library           BuiltIn
Library           REST    10.9.8.204:8090
Library           DateTime

*** Variables ***

${ADDRESS}          10.9.8.204
${USERNAME}         user
${PASSWORD}         root

*** Test Cases ***
POST publish in DCM to create topics
    Post    /dcm/publish/signalling.metric.application    headers={"Content-Type":"application/json"}   body=subscribe.json
    ${output}=  Output  response status
    ${output_string}=   Convert To String   ${output}
    Should Be Equal    ${output_string}    201

Check created topics
    Open Connection to DCM and Log In
    ${stdout}=    Execute Command    /opt/kafka/bin/kafka-topics.sh --list --zookeeper 127.0.0.1:2181
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracked_devices
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.processed_records
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracking_response_time
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracking_memory_usage

POST publish in DCM to delete topics
    Post    /dcm/publish/signalling.metric.application    headers={"Content-Type":"application/json"}   body=unsubscribe.json
    ${output}=  Output  response status
    ${output_string}=   Convert To String   ${output}
    Should Be Equal    ${output_string}    201

Check deleted topics
    Open Connection to DCM and Log In
    ${stdout}=    Execute Command    /opt/kafka/bin/kafka-topics.sh --list --zookeeper 127.0.0.1:2181
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracked_devices - marked for deletion
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.processed_records - marked for deletion
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracking_response_time - marked for deletion
    Should Contain    ${stdout}    uc.4.france_nice.application_metric.tracking_memory_usage - marked for deletion

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
