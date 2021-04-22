*** Settings ***
Resource    NSLCMOperationKeywords.robot   
Library     REST      localhost:8000


*** Test cases ***
Test 2 - Network Service instantiation. Positive test
     [Documentation] 
    ...    Test purpose: The purpose of this test is to validate the instantiation of a NS.
    ...    Test type: Functional.
    ...    Related tests: ms-nso-id-creation.
    ...    Priority: High.
    ...    Execution time: As required for the full test execution.
    ...    Configuration: MSNO_BASIC_CONF.
    ...    References: NS LCM API.
    ...    Applicability: None.
    ...    Pre-test conditions: NSD is onboarded in the Multi-Site Catalogue.
    ...                         Nested NS are onboarded in each site NFVO.
    ...                         NS ID is created (see ms-nso-id-creation test).
    ...    Test sequence: 1. Send a instantiate request to the MSNO.
    ...    Expected results: 1. MSNO returns a positive response for the instantiation.
    ...                      2. A notification is sent when NS creations process starts and finish. 
    ...                      3. NS ID is stored in the DB with INSTANTIATED status and can be queried using external MS Inventory API. 
    ...                      4. Each nested NS is instantiated in each site NFVO.   
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    #Waiting for NSI to be instantiated
    Sleep    300s
    #Checking the information related to the NS before the instantiation
    Check resource instantiated        ${id}
    
Test 2 - Network Service instantiation. Conflict
    [Documentation]  
    ...    Test purpose: The objective is to test that the operation cannot be performed due to a conflict with the state of resource (i.e. the resource is in INSTANTIATED state)
    ...    Pre-conditions: resource is in INSTANTIATED state
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    POST Instantiate nsInstance            ${id}
    Check HTTP Response Status Code Is   409 
    
Test 3 - Terminate Network Service instance.
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    #Waiting for NSI to be instantiated
    Sleep    300s
    #Checking the information related to the NS before the instantiation
    Check resource instantiated        ${id}
    POST Terminate NSInstance          ${id} 
    Check HTTP Response Status Code Is      202
    Check HTTP Response Header Contains     Location
    #Waiting for NSI to be terminated
    Sleep    300s
    #Checking the information related to the NS before the termination
    Check resource not_instantiated         ${id} 

Test 3 - Terminate Network Service instance with time.
    ${id}=    ms-nso-id-creation
    Check resource not_instantiated        ${id}
    POST Instantiate nsInstance            ${id}    
    Check HTTP Response Status Code Is     202
    Check HTTP Response Header Contains    Location
    #Waiting for NSI to be instantiated
    Sleep    300s
    #Checking the information related to the NS before the instantiation
    Check resource instantiated        ${id}
    POST Terminate nsInstance with time    ${id}
    Check HTTP Response Status Code Is      202
    Check HTTP Response Header Contains     Location
    #Waiting for NSI to be terminated
    Sleep    300s
    #Checking the information related to the NS before the termination
    Check resource not_instantiated         ${id} 
    
