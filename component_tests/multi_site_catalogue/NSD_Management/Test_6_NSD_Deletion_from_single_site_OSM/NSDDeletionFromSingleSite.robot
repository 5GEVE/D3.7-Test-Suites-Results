*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
NSD Deletion from single site - OSM
    [Documentation]
    ...    Test title: Test 6 - NSD Deletion from single site - OSM
    ...    Test purpose: This test aims at verifying that an existing NSD modelling a per-site service (previously onboarded from a per-site OSM orchestrator) can be deleted in the Multi-Site Catalogue from its SBI when it is removed in the original per-site OSM orchestrator.
    Log    Deleting NSD from single site - OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    #Getting NsdInfoResource from OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    #Deleting NS package to OSM
    ${response}=    Delete Request    ${osm}   /nsd/v1/ns_descriptors/${response.json()[0]["_id"]}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to OSM
    #Waiting for NSD to be deleted to Catalogue
    Sleep    90s
    #Checking package availability on Catalogue
    ${catalogue}=    Create Catalogue Session
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /nsd/v1/ns_descriptors?nsdId=${NSD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to Catalogue
    

