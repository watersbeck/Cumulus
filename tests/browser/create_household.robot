*** Settings ***

Resource        tests/NPSP.robot
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser

*** Test Cases ***

Create Household With Name Only
    ${contact_id} =  Create Contact
    &{contact} =  Salesforce Get  Contact  ${contact_id}
    Page Should Contain  &{contact}[LastName] Household
    Header Field Should Have Link  Account Name
    
Create Household With Name and Email
    ${contact_id} =  Create Contact with Email
    &{contact} =  Salesforce Get  Contact  ${contact_id}
    Page Should Contain  &{contact}[LastName] Household
    Header Field Should Have Link  Account Name
    
Create Household with Name and Address
    ${contact_id} =  Create Contact with Address
    &{contact} =  Salesforce Get  Contact  ${contact_id}
    Page Should Contain  &{contact}[LastName] Household
    Header Field Should Have Link  Account Name   
         