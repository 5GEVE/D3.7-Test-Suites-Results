*** Settings ***
Resource   ../../keywords.robot

*** Test Cases ***
NSD Onboarding from single site - OSM
    [Documentation]
    ...    Test title: Test 4 -  NSD Onboarding from single site - OSM
    ...    Test purpose: This test aims at verifying that an NSD modelling a single-site service can be successfully onboarded in the Multi-Site Catalogue through the SBI from a specific per-site OSM orchestrator.
    Log    Onboarding NSD from single site - OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    #Creating NsdInfo resource on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Post Request    ${osm}    /nsd/v1/ns_descriptors    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    201
    #Onboarding NS package to OSM
    ${headers}=      Create Dictionary    Accept    application/json    Content-Type    application/zip    Authorization    Bearer ${token_id}
    ${body}=    Get Binary File    ${NS_PACKAGE_OSM}
    ${response}=     Put Request    ${osm}    /nsd/v1/ns_descriptors/${response.json()["id"]}/nsd_content    headers=${headers}    data=${body}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    NSD onboarded to OSM
    #Waiting for NSD to be onboarded to Catalogue
    Sleep    90s
    #Checking package availability on Catalogue
    ${catalogue}=    Create Catalogue Session
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /nsd/v1/ns_descriptors?nsdId=${NSD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    NSD onboarded to Catalogue
    
    

