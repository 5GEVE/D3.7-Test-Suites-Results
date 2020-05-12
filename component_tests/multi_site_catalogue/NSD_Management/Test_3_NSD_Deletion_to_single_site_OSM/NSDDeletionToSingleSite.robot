*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
NSD Deletion to single site - OSM
    [Documentation]
    ...    Test title: Test 3 - NSD Deletion to single site - OSM
    ...    Test purpose: This test aims at verifying that an existing NSD modelling a vertical experiment can be deleted in the Multi-Site Catalogue from its NBI and removed from a specific per-site OSM orchestrator.
    Log    Deleting NSD to single site - OSM
    ${catalogue}=    Create Catalogue Session
    #Getting NsdInfoResource from Catalogue
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /nsd/v1/ns_descriptors?nsdId=${NSD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    ${nsdInfoid}=    Set Variable    ${response.json()[0]["id"]} 
    #Disabling NS package
    ${headers}=      Create Dictionary    Accept    application/json    Content-Type    application/json 
    ${body}=    Create Dictionary    nsdOperationalState    DISABLED
    ${response}=    Patch Request    ${catalogue}   /nsd/v1/ns_descriptors/${nsdInfoid}   headers=${headers}    json=${body}
    Check HTTP Response Status Code Is    ${response}    200
    #Deleting NS package to Catalogue
    ${response}=    Delete Request    ${catalogue}   /nsd/v1/ns_descriptors/${nsdInfoid}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on Catalogue
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /nsd/v1/ns_descriptors?nsdId=${NSD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to Catalogue
    #Waiting for NSD to be deleted to OSM
    Sleep    10s
    #Checking package availability on OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to OSM

