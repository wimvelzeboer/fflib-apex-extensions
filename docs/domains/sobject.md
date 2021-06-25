# fflib-apex-extensions

## Primitive Domain - SObject 
This class should be used to extend Domain classes.

```apex
public class Accounts extends SObjects implements IAccounts
{
    ...
}
```

### Method reference

Public methods

- [getSObjectById](#getSObjectById)
- [getRecords](#getRecords)


Protected methods
- [addError](#adderror)
- [clearField / clearFields](#clearField)
- [getDateFieldValues](#getDateFieldValues)
- [getDateTimeFieldValues](#getDateTimeFieldValues)
- [getDecimalFieldValues](#getDecimalFieldValues)


#### getSObjectById 
Returns the contents of the Domain by their primary Key ('Id' field)

`public Map<Id, SObject> getSObjectById()`
<br/><br/>

#### getRecords  
Returns only the SObjects from the domain matching the given Ids.

`public List<SObject> getRecords(Ids ids)`<br/>
`public List<SObject> getRecords(Set<Id> ids)`<br/>
<br/>

   
Return the SObject records contained in the domain matching the criteria

- `public List<SObject> getRecords(fflib_Criteria criteria)`<br/>
<br/><br/>


#### addError
Adds an error message to the records in the domain

`protected void addError(String message)`<br/>
`protected void addError(Schema.SObjectField sObjectField, String message)`
<br/><br/>

#### clearField
Clear the field value on all the records of the domain

`protected void clearField(Schema.SObjectField sObjectField)`<br/>
`protected void clearFields(Set<Schema.SObjectField> sObjectFields)`
<br/><br/>

#### getDateFieldValues
Get the Date values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected Dates getDateFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Dates getDateFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/>

#### getDateTimeFieldValues
Get the Datetime values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/>

#### getDecimalFieldValues	
Get the Decimal values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected Decimals getDecimalFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Decimals getDecimalFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
