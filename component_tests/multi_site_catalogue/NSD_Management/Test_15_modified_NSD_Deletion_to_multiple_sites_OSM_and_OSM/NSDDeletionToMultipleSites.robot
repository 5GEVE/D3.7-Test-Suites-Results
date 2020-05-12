*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
NSD Deletion to multiple sites – OSM and OSM
    [Documentation]
    ...    Test title: Test 15 (modified) - NSD Deletion to multiple sites – OSM and OSM
    ...    Test purpose: This test aimed originally (i.e. as per D3.6) at verifying that an existing NSD modelling a vertical experiment can be deleted in the Multi-Site Catalogue from its NBI and removed simultaneously from the specific per-site OSM and ONAP orchestrators. However, as the Multi-Site Catalogue full support of ONAP local site orchestrators is planned to be completed not before late Q2-2020, the test purpose has been temporarily updated to simultaneous delete an NSD in to two different per-site OSM orchestrators. This version of the test is anyway sufficient to validate the NSD deletion to multiple sites.
    Log    Deleting NSD to multiple sites - OSM and OSM
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
    #Checking package availability on OSM1
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to OSM1
    #Checking package availability on OSM2
    ${osm}=    Create Osm Session    ${OSM2_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM2_USERNAME}    ${OSM2_PASSWORD}    ${OSM2_PROJECT}
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /nsd/v1/ns_descriptors_content?id=${NSD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    NSD deleted to OSM2

