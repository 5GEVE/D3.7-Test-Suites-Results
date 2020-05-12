*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
NSD Onboarding to single site - OSM
    [Documentation]
    ...    Test title: Test 1 -   NSD Onboarding to single site - OSM
    ...    Test purpose: This test aims at verifying that an NSD modelling a vertical experiment (in TOSCA format) can be successfully onboarded in the Multi-Site Catalogue from its NBI and delivered to a specific per-site OSM orchestrator.
    Log    Onboarding NSD to single site - OSM
    ${catalogue}=    Create Catalogue Session
    #Creating NsdInfo resource on Catalogue
    ${headers}=      Create Dictionary    Accept    application/json    Content-Type    application/json   
    ${site}=    Create Dictionary    ${OSM1_ID}    yes
    ${body}=    Create Dictionary    userDefinedData    ${site}
    ${response}=    Post Request    ${catalogue}   /nsd/v1/ns_descriptors    headers=${headers}    json=${body}
    Check HTTP Response Status Code Is    ${response}    201
    #Onboarding NS package to Catalogue
    ${body}=    Create Dictionary
    Create Multi Part    ${body}    file    ${NS_PACKAGE_CAT}    application/zip  
    ${response}=    Put Request    ${catalogue}   ${response.json()["_links"]["nsd_content"]}    files=${body}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on Catalogue
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /nsd/v1/ns_descriptors?nsdId=${NSD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    NSD onboarded to Catalogue
    #Waiting for NSD to be onboarded to OSM
    Sleep    10s
    #Checking package availability on OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    NSD onboarded to OSM

