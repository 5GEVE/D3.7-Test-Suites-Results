*** Settings ***
Resource    ../NSLCMOperationKeywords.robot   
Library     REST      msno:8000

*** Test Cases ***
Test 1 - NSI status
    [Documentation] 
    ...    Test purpose: This test aims at verifying that after the Multi-Site NSO 
    ...    requests the information for an existing NSI, the Multi-Site Inventory 
    ...    provides such information, including the forming VNFs/PNFs and Virtual Links.
    ...
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    #Waiting for NSI to be instantiated
    Sleep    300s
    #Checking the information related to the NS before the instantiation
    Check resource                         ${id}
    [Teardown]  POST Terminate NSInstance  ${id} 
                AND DELETE nsInstance      ${id}   

Test 2 - Infrastructure status
    [Documentation] 
    ...    Test purpose: This test aims at verifying that after the Multi-Site NSO 
    ...    requests the information for all existing NSIs, the Multi-Site Inventory 
    ...    provides such information, including the forming VNFs/PNFs and Virtual Links
    ...    of each of the NSs. The response when there are no active NSIs yet has to be 
    ...    checked as well.
    ... 
    Get all NSI  
   

Test 3 - Non-existing NSI status
    [Documentation] 
    ...    This test aims at verifying that appropriate error handling is done in case
    ...    the Multi-Site NSO requests information about a non-existing NSI index at 
    ...    the Multi-Site Inventory.   
    ...    
    ${id}=  Set Variable   "identifier"
    Check resource         ${id}
     