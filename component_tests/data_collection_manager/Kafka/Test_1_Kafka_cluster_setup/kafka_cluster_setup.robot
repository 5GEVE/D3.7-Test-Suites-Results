*** Settings ***
Suite Teardown    Close All Connections
Library           SSHLibrary
Library           String
Library           Collections
Library           BuiltIn

*** Variables ***

${ADDRESS}          10.9.8.204
${USERNAME}         user
${PASSWORD}         root

*** Test Cases ***
Execute command
    Open Connection to DCM and Log In
    Execute Command    sudo systemctl stop dcm
    Execute Command    sudo systemctl stop kafka
    Execute Command    sudo systemctl stop zookeeper
    Execute Command    sudo systemctl start zookeeper
    Execute Command    sudo systemctl start kafka
    Sleep    5s
    Execute Command    sudo systemctl start dcm
    ${stdout_zookeeper}=    Execute Command    sudo systemctl status zookeeper
    Should Contain    ${stdout_zookeeper}    active (running)
    ${stdout_kafka}=    Execute Command    sudo systemctl status kafka
    Should Contain    ${stdout_kafka}    active (running)
    ${stdout_dcm}=    Execute Command    sudo systemctl status dcm
    Should Contain    ${stdout_dcm}    active (running)

*** Keywords ***
Open Connection to DCM and Log In
    Open Connection    ${ADDRESS}
    Login    ${USERNAME}    ${PASSWORD}
