*** Settings ***
Library    RequestsLibrary
Resource   ../../keywords.robot

*** Test Cases ***
VNF Onboarding from site - OSM
    [Documentation]
    ...    Test title: Test 1 - VNF Onboarding from site - OSM
    ...    Test purpose: This test aims at verifying that a VNF can be successfully onboarded in the Multi-Site Catalogue through the SBI from a specific per-site OSM orchestrator.
    Log    Onboarding VNF from site - OSM
    ${osm}=    Create Osm Session    ${OSM1_URL}
    ${token_id}=    Get Osm Token    ${osm}    ${OSM1_USERNAME}    ${OSM1_PASSWORD}    ${OSM1_PROJECT}
    #Creating VnfPkgInfo resource on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Post Request    ${osm}    /vnfpkgm/v1/vnf_packages    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    201
    #Onboarding VNF package to OSM
    ${headers}=      Create Dictionary    Accept    application/json    Content-Type    application/zip    Authorization    Bearer ${token_id}
    ${body}=    Get Binary File    ${VNF_PACKAGE_OSM}
    ${response}=     Put Request    ${osm}    /vnfpkgm/v1/vnf_packages/${response.json()["id"]}/package_content    headers=${headers}    data=${body}
    Check HTTP Response Status Code Is    ${response}    204
    #Checking package availability on OSM
    ${headers}=      Create Dictionary    Accept    application/json    Authorization    Bearer ${token_id}
    ${response}=     Get Request    ${osm}    /vnfpkgm/v1/vnf_packages_content?id=${VNFD_ID}    headers=${headers} 
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    VNF onboarded to OSM
    #Waiting for VNF to be onboarded to Catalogue
    Sleep    90s
    #Checking package availability on Catalogue
    ${catalogue}=    Create Catalogue Session
    ${headers}=      Create Dictionary    Accept    application/json  
    ${response}=    Get Request    ${catalogue}   /vnfpkgm/v1/vnf_packages?vnfdId=${VNFD_ID}    headers=${headers}
    Check HTTP Response Status Code Is    ${response}    200
    Length Should Be    ${response.json()}    1
    Log    VNF onboarded to Catalogue
    
    

