*** Settings ***
Library    REST    localhost:8000
Library    DateTime

***Variables***
${apiName}        nslcm
${apiVersion}     v1

*** Keywords ***
POST New nsInstance
    Log    Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances
    Set Headers      {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsName":"TEST1 NS","nsDescription": "NS for test1"}
    Post    /${apiName}/${apiVersion}/ns_instances  ${body}  
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

POST nsInstance
    [Arguments]    ${headers}    ${body} 
    Log    Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances.
    Set Headers    ${headers}      
    Post    /${apiName}/${apiVersion}/ns_instances  ${body}  
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}

POST New nsInstance - Wrong version
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with a wrong version parameter.
    ${headers}=  Set Variable  {"Version":""}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsName":"TEST1 NS","nsDescription": "NS for test1"}
    POST nsInstance     ${headers}     ${body}

POST New nsInstance - Wrong accept
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with a wrong accept.
    ${headers}=  Set Variable  {"Accept":"", "Version":"1.0"}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsName":"TEST1 NS","nsDescription": "NS for test1"}
    POST nsInstance     ${headers}      ${body}
    
POST New nsInstance - Wrong content-type
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with a wrong content-type.
    ${headers}=  Set Variable  {"Accept":"application/json", "Content-Type":"", "Version":"1.0"}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsName":"TEST1 NS","nsDescription": "NS for test1"}
    POST nsInstance     ${headers}      ${body}
    
POST New nsInstance - Wrong CreateNsRequest - Missing nsId
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with missing nsId parameter.
    ${headers}=  Set Variable  {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"nsdid":"TEST1","nsName":"TEST1 NS","nsDescription": "NS for test1"}
    POST nsInstance     ${headers}      ${body}
    
POST New nsInstance - Wrong CreateNsRequest - Missing nsName
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with missing nsName
    ${headers}=  Set Variable   {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsname":"TEST1 NS","nsDescription": "NS for test1"}
    POST nsInstance     ${headers}      ${body}
    
POST New nsInstance - Wrong CreateNsRequest - Missing nsDescription
    Log  Create NS instance by POST to /${apiName}/${apiVersion}/ns_instances with missing nsDescription
    ${headers}=  Set Variable   {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"nsdId":"TEST1","nsName":"TEST1 NS","nsdescription": "NS for test1"}
    POST nsInstance     ${headers}      ${body}
    
Get NS Identifier
    Log    Get NS identifier from a response     
    [Return]    ${response[0]['body']['id']}
    
Get all NSI
    Set Headers      {"Version":"1.0"}
    GET             /nslcm/v1/ns_instances
    Output          response
    Integer         response status             200

DELETE nsInstance
    [Arguments]    ${id}
    Log    Delete a network service instance
    DELETE  /${apiName}/${apiVersion}/ns_instances/${id}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}	
	
Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    Log    Validate Status code    
    Should Be Equal as Strings  ${response[0]['status']}    ${expected_status}
    Log    Status code validated      

Check HTTP Response Header Contains
    [Arguments]        ${HEADER_TOCHECK}
    Should Contain     ${response[0]['headers']}    ${HEADER_TOCHECK}
    Log    Header is present  
    
 Check resource 
   [Arguments]    ${nsInstanceId} 
   Set Headers     {"Version":"1.0", "Accept":"application/json"} 
   Get             /${apiName}/${apiVersion}/ns_instances/${nsInstanceId} 
   ${outputResponse}=    Output    response  
    
Check resource not_instantiated
    [Arguments]    ${nsInstanceId} 
    Set Headers     {"Version":"1.0", "Accept":"application/json"} 
    Get             /${apiName}/${apiVersion}/ns_instances/${nsInstanceId} 
    ${outputResponse}=    Output    response
    String  response body nsState    NOT_INSTANTIATED
    
Check resource instantiated
    [Arguments]    ${nsInstanceId} 
    Set Headers     {"Version":"1.0", "Accept":"application/json"} 
    Get             /${apiName}/${apiVersion}/ns_instances/${nsInstanceId}
    ${outputResponse}=    Output    response 
    String  response body nsState    INSTANTIATED

ms-nso-id-creation
    ${headers}=  Set Variable    {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"nsdId":"TEST2","nsName":"TEST2 NS","nsDescription": "NS for test2"}
    POST nsInstance     ${headers}      ${body}
    Check HTTP Response Status Code Is     201
    Check HTTP Response Header Contains    Location
    ${id} =     Get NS Identifier     
    [Return]    ${id}  
    
POST Instantiate nsInstance
    [Arguments]    ${nsInstanceId}
    Log    Trying to Instantiate a ns Instance
    Set Headers    {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${body}=  Set Variable  {"additionalParamsForNs":{"kvs":[{"key":"target-site","value":"ITALY_TURIN"}]},"nsFlavourId":""}
    Post    /${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/instantiate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}      
	
POST Terminate nsInstance
    [Arguments]    ${nsInstanceId}
	Log    Trying to Instantiate a Terminate NS Instance
    Set Headers    {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}  
    ${body}=  Set Variable   {"terminationTime": ""}  
	Post    /${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse} 
		      
POST Terminate nsInstance with time
    [Arguments]    ${nsInstanceId}
	Log    Trying to Instantiate a Terminate NS Instance
    Set Headers    {"Version":"1.0", "Content-Type":"application/json", "Accept":"application/json"}
    ${time} =    Evaluate    datetime.datetime.now()    modules=datetime  
    ${body}=  Set Variable   {"terminationTime": "${time}"}  
	Post    /${apiName}/${apiVersion}/ns_instances/${nsInstanceId}/terminate    ${body}
    ${outputResponse}=    Output    response
	Set Global Variable    @{response}    ${outputResponse}         
	

    
    