*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Resource   variables.txt 

*** Keywords ***
Create Catalogue Session
    Create Session    catalogue    ${CATALOGUE_URL}
    [Return]    catalogue
 
Create Osm Session
    [Arguments]    ${url}
    Create Session    osm    ${url}    verify=False    disable_warnings=1
    [Return]    osm
    
Get Osm Token
    [Arguments]    ${osm}    ${username}    ${password}    ${project}
    ${headers}=      Create Dictionary    Content-Type    application/json    Accept    application/json
    ${body}=    Create Dictionary    username    ${username}    password    ${password}    project_id    ${project}    
    ${response}=    Post Request    ${osm}    /admin/v1/tokens    headers=${headers}    json=${body}
    Check HTTP Response Status Code Is    ${response}    200
    [Return]    ${response.json()['id']}

Check HTTP Response Status Code Is
    [Arguments]    ${response}    ${expected_status}    
    Should Be Equal As Integers     ${response.status_code}    ${expected_status}

*** Keywords ***
Create Multi Part    [Arguments]    ${addTo}    ${partName}     ${filePath}    ${contentType}    ${content}=${None}
    ${fileData}=    Run Keyword If    '''${content}''' != '''${None}'''    Set Variable    ${content}
    ...            ELSE    Get Binary File    ${filePath}
    ${fileDir}    ${fileName}=    Split Path    ${filePath}
    ${partData}=    Create List    ${fileName}    ${fileData}    ${contentType}
    Set To Dictionary    ${addTo}    ${partName}=${partData}
    