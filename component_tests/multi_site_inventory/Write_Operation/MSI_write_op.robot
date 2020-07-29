*** Settings ***
Resource    ../NSLCMOperationKeywords.robot   
Library     REST      msno:8000

*** Test Cases ***
Test 1 - NSI instantiation at single site
     [Documentation] 
    ...    Test purpose: This test aims at verifying that after the Multi-Site NSO instantiates
    ...    a NS in a single site, it correctly updates the Multi-Site Inventory, creating a 
    ...    new entry. The entry must include all the information related to the NS, in 
    ...    particular, its VNFs/PNFs and Virtual Links.
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

Test 4 - NSI termination at single site
    [Documentation] 
    ...    Test purpose: This test aims at verifying that after the Multi-Site NSO terminates
    ...    a NS in a single site, it correctly deletes the appropriate existing entry at the
    ...    Multi-Site Inventory.
    ...      
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    #Waiting for NSI to be instantiated
    Sleep    300s
    POST Terminate NSInstance  ${id}
    #Waiting for NSI to be terminated
    Sleep    300s
    #Checking the information related to the NS before the termination
    Check resource             ${id}
    [Teardown]  DELETE nsInstance      ${id}

Test 9 - Non-existing NSI
    [Documentation]     
    ...  This test aims at verifying that appropriate error handling is done in case 
    ...  the Multi-Site NSO tries an operation over a non-existing NSI index at the 
    ...  Multi-Site Inventory.
    ...          
    ${id}=  Set Variable   "identifier"
    POST Instantiate nsInstance        ${id}     
    