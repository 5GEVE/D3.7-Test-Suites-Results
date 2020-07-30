*** Settings ***
Suite Teardown    Close All Connections
Library           SSHLibrary
Library           String
Library           Collections
Library           BuiltIn
Library           REST    10.9.8.205:8091
Library           DateTime

*** Variables ***

${ADDRESS}          10.9.8.204
${USERNAME}         user
${PASSWORD}         root

*** Test Cases ***
POST start_signalling in DCS-DV to create signalling topics
    Post    /portal/dcs/start_signalling    headers={"Content-Type":"application/json"}
    ${output}=  Output  response status
    ${output_string}=   Convert To String   ${output}
    Should Be Equal    ${output_string}    201

Execute command
    Open Connection to DCM and Log In
    ${stdout}=    Execute Command    /opt/kafka/bin/kafka-topics.sh --list --zookeeper 127.0.0.1:2181
    Should Contain    ${stdout}    signalling.kpi
    Should Contain    ${stdout}    signalling.metric.application
    Should Contain    ${stdout}    signalling.metric.infrastructure

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
