*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
VNF Deletion from site - OSM
    [Documentation]
    ...    Test title: Test 3 - VNF Deletion from site - OSM
    ...    Test purpose: This test aims at verifying that an existing VNF can be deleted in the Multi-Site Catalogue through its SBI from a specific per-site OSM orchestrator.
    Log    Deleting VNF from single site - OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    #Getting VnfPkgInfo from OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /vnfpkgm/v1/vnf_packages_content?id=${VNFD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    #Deleting VNF package to OSM
    ${response}=    Delete Request    ${osm}   /vnfpkgm/v1/vnf_packages/${response.json()[0]["_id"]}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /vnfpkgm/v1/vnf_packages_content?id=${VNFD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    VNF deleted to OSM
    #Waiting for VNF to be deleted to Catalogue
    Sleep    90s
    #Checking package availability on Catalogue
    ${catalogue}=    Create Catalogue Session
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /vnfpkgm/v1/vnf_packages?vnfdId=${VNFD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    0
    Log    VNF deleted to Catalogue
    

