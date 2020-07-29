*** Settings ***
Resource    NSLCMOperationKeywords.robot   
Library     REST      localhost:8000

*** Test cases ***
Get all NS
    Set Headers      {"Version":"1.0"}
    GET             /nslcm/v1/ns_instances
    Output          request
    Output          response
    Integer         response status             200

Get all NS Bad Request
    Set Headers     {"Version":""}
    GET             /nslcm/v1/ns_instances
    Integer         response status             400

Test 1 - Network Service ID creation. Positive test
     [Documentation] 
    ...    Test purpose: The purpose of this test is to validate the creation of a NS ID.
    ...    Test type: Functional.
    ...    Related tests: None.
    ...    Priority: High.
    ...    Execution time: As required for the full test execution.
    ...    Configuration: MSNO_BASIC_CONF.
    ...    References: NS LCM API.
    ...    Applicability: None.
    ...    Pre-test conditions: NSD is onboarded in the Multi-Site Catalogue. 
    ...                         Nested NS are onboarded in each site NFVO.
    ...    Expected results: MSNO returns a positive response for the NS creation. 
    ...                      A notification is sent when NS creations process finishes.
    ...                      NS ID is stored in the DB with NOT_INSTANTIATED status and can be queried using
    ...                      external MSI API.  
    POST New nsInstance
    Check HTTP Response Status Code Is     201
    Check HTTP Response Header Contains    Location
    ${id} =     Get NS Identifier     
    Check resource not_instantiated        ${id}
    [Teardown]  DELETE nsInstance    ${id}
                

Test 1 - Network Service ID creation. Wrong version
    POST New nsInstance - Wrong version
    Check HTTP Response Status Code Is     400

Test 1 - Network Service ID creation. Wrong accept
    POST New nsInstance - Wrong accept
    Check HTTP Response Status Code Is     400

Test 1 - Network Service ID creation. Wrong content-type   
    POST New nsInstance - Wrong content-type
    Check HTTP Response Status Code Is     400

Test 1 - Network Service ID creation. Wrong CreateNsRequest. Missing nsId    
    POST New nsInstance - Wrong CreateNsRequest - Missing nsId
    Check HTTP Response Status Code Is     400
    
Test 1 - Network Service ID creation. Wrong CreateNsRequest. Missing nsName
    POST New nsInstance - Wrong CreateNsRequest - Missing nsName
    Check HTTP Response Status Code Is     400

Test 1 - Network Service ID creation. Wrong CreateNsRequest. Missing nsDescription
    POST New nsInstance - Wrong CreateNsRequest - Missing nsDescription
    Check HTTP Response Status Code Is     400
