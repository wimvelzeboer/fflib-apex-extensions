# fflib-apex-extensions

## Primitive Domain - SObject 
The primitive domain SObject adds a lot of additional getter methods to the domain. It also includes getting Maps directly from the domain. (see the `get...By...` methods)

This class should be used to extend Domain classes.

```apex
public class Accounts extends fflib_SObjects2 implements IAccounts
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
- [getDoubleFieldValues](#getdoublefieldvalues)
- [getFieldByField](#getfieldbyfield)
- [getFieldsByField](#getfieldsbyfield)
- [getIdFieldByStringField](#getidfieldbystringfield)
- [getIdFieldByIdField](#getidfieldbyidfield)
- [getIdFieldsByIdField](#getidfieldsbyidfield)
- [getIdFieldValues](#getidfieldvalues)
- [getIntegerFieldValues](#getintegerfieldvalues)
- [getLongFieldValues](#getlongfieldvalues)
- [getSObjectByIdField](#getsobjectbyidfield)
- [getSObjectsByIdField](#getsobjectsbyidfield)
- [getSObjectByStringField](#getsobjectbystringfield)
- [getSObjectsByStringField](#getsobjectsbystringfield)
- [getStringFieldByIdField](#getstringfieldbyidfield)
- [getDateFieldByIdField](#getdatefieldbyidfield)
- [getStringFieldByStringField](#getstringfieldbystringfield)
- [getStringFieldValues](#getstringfieldvalues)
- [setFieldValue](#setfieldvalue) _(Added method overload)_





#### getSObjectById 
Returns the contents of the Domain by their primary Key ('Id' field)

`public Map<Id, SObject> getSObjectById()`
<br/><br/><br/>

#### getRecords  
Returns only the SObjects from the domain matching the given Ids.

`public List<SObject> getRecords(Ids ids)`<br/>
`public List<SObject> getRecords(Set<Id> ids)`<br/>
<br/>

   
Return the SObject records contained in the domain matching the criteria

- `public List<SObject> getRecords(fflib_Criteria criteria)`<br/>
<br/><br/><br/>


#### addError
Adds an error message to the records in the domain

`protected void addError(String message)`<br/>
`protected void addError(Schema.SObjectField sObjectField, String message)`
<br/><br/><br/>

#### clearField
Clear the field value on all the records of the domain

`protected void clearField(Schema.SObjectField sObjectField)`<br/>
`protected void clearFields(Set<Schema.SObjectField> sObjectFields)`
<br/><br/><br/>

#### getDateFieldValues
Get the Date values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected Dates getDateFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Dates getDateFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>

#### getDateTimeFieldValues
Get the Datetime values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>

#### getDecimalFieldValues	
Get the Decimal values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned.  

`protected Decimals getDecimalFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Decimals getDecimalFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>

#### getDoubleFieldValues
Get the Double values from the given SObjectField, null values will be omitted.
If a criteria is provided, only the value of the records matches the criteria will be returned. 

`protected Doubles getDoubleFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Doubles getDoubleFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>


#### getFieldByField
Get a map with the values of two fields. Key fields containing null values are omitted

`protected Map<Object, Object> getFieldByField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_
```apex
Accounts accounts = Accounts.newInstance(records);
Map<Object, Object> accountNameById = accounts.getFieldByField(Account.Name, Account.Id);
```
<br/><br/>

#### getFieldsByField
Get a map with the values of two fields. Key fields containing null values are omitted.

`protected Map<Object, Set<Object>> getFieldsByField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Contacts contacts = Contacts.newInstance(records);
Map<Object, Set<Object>> contactIdByAccountId = contacts.getFieldsByField(Contact.Id, Contact.AccountId);
```
<br/><br/>
#### getIdFieldByStringField
Get a map with the string field as the key and the ID as values. Key fields containing null values are omitted.

`protected Map<String, Id> getIdFieldByStringField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Contacts contacts = Contacts.newInstance(records);
Map<String, Id> accountIdByContactId = contacts.getIdFieldByStringField(Contact.Id, Contact.Name);
```
<br/><br/>

#### getIdFieldByIdField
Get a map with the values of two Id fields. Key fields containing null values are omitted.

`protected Map<Id, Id> getIdFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Contacts contacts = Contacts.newInstance(records);
Map<Id, Id> accountIdByContactId = contacts.getIdFieldByIdField(Contact.AccountId, Contact.Id);
```
<br/><br/>

#### getIdFieldsByIdField
Get a map with the values of two Id fields with a one to many relation. Key fields containing null values are omitted.

`protected Map<Id, Set<Id>> getIdFieldsByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Contacts contacts = Contacts.newInstance(records);
Map<Id, Set<Id>> contactIdByAccountId = contacts.getIdFieldsByIdField(Contact.Id, Contact.AccountId);
```
<br/><br/>

#### getIdFieldValues
Gets the values from the given Id field.
If a criteria is provided, only the value of the records matches the criteria will be returned.

`protected Ids getIdFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Ids getIdFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>

#### getIntegerFieldValues

Gets the values from the given Integer field.
If a criteria is provided, only the value of the records matches the criteria will be returned.

`protected Integers getIntegerFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Integers getIntegerFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>

#### getLongFieldValues

Gets the values from the given Long field.
If a criteria is provided, only the value of the records matches the criteria will be returned.

`protected Longs getLongFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Longs getLongFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/></br>

#### getSObjectByIdField
Get a map with the record mapped to the given Id field value.
Key fields containing null values are omitted.

`protected Map<Id, SObject> getSObjectByIdField(Schema.SObjectField sObjectField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<Id, SObject> accountById = account.getSObjectByIdField(Account.Id);
```
<br/><br/>

#### getSObjectsByIdField
Get a map with the records mapped to the given Id field value. Key fields containing null values are omitted.

`protected Map<Id, List<SObject>> getSObjectsByIdField(Schema.SObjectField sObjectField)`

_Example_

```apex
Contacts contacts = Contacts.newInstance(records);
Map<Id, List<SObject>> contactsByAccountId = contacts.getSObjectsByIdField(Contact.AccountId);
```
<br/><br/>

#### getSObjectByStringField
Get a map with the record mapped to the given String field value. Key fields containing null values are omitted.

`protected Map<String, SObject> getSObjectByStringField(Schema.SObjectField sObjectField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<String, SObject> accountByNumber = account.getSObjectByStringField(Account.AccountNumber);
```
<br/><br/>

#### getSObjectsByStringField
Get a map with the records mapped to the given String field value. Key fields containing null values are omitted.

`protected Map<String, List<SObject>> getSObjectsByStringField(Schema.SObjectField sObjectField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<String, SObject> accountByName = account.getSObjectsByStringField(Account.AccountName);
```
<br/><br/>

#### getStringFieldByIdField
Get a map with the given String field value mapped to the given Id field. Key fields containing null values are omitted.

`protected Map<Id, String> getStringFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<Id, String> accountNameById = account.getStringFieldByIdField(Account.AccountName, Account.Id);
```
<br/><br/>
#### getDateFieldByIdField
Get a map with the given Date field value mapped to the given Id field. Key fields containing null values are omitted.

`protected Map<Id, Date> getDateFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<Id, Date> createdDateById = account.getDateFieldByIdField(Account.CreatedDate, Account.Id);
```
<br/><br/>
#### getStringFieldByStringField
Get a map with the records mapped to the given String field value. Key fields containing null values are omitted.

`protected Map<String, String> getStringFieldByStringField(Schema.SObjectField valueField, Schema.SObjectField keyField)`

_Example_

```apex
Account account = Account.newInstance(records);
Map<Id, String> accountNameById = account.getStringFieldByStringField(Account.AccountName, Account.Id);
```
<br/><br/>

#### getStringFieldValues
Gets the values for the provided String field.
If a criteria is provided, only the value of the records matches the criteria will be returned.

`protected Strings getStringFieldValues(Schema.SObjectField sObjectField)`<br/>
`protected Strings getStringFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)`
<br/><br/><br/>


#### setFieldValue 
This method overload is added to give the value to the given field only when the criteria are met for the record.

`protected void setFieldValue(Schema.SObjectField sObjectField, Object value, fflib_Criteria criteria)`
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>














