# fflib-apex-extensions
Extensions for the fflib-apex-common Library.  Introducing many advanced features on top of the Apex Enterprise Patterns

**Dependencies:**<br/>
This extension package is dependent on the following packages:
- [fflib-apex-mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks)
- [fflib-apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common)

## Extensions pack contents
These features are offered in this extension package:

- [**Application class redesigned**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/application-factories) <br/>A Force-DI like feature using dependency injection with the Separation of Concerns design pattern.
- [**Criteria evaluator**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/criteria-based-filter) <br/> Ability to use the same criteria filters for domains and selectors. Build SOQL WHERE clauses in an object-oriented manner. It can also evaluate a list of records against predefined conditions "(1 AND 2 AND (3 OR 4))".
- [**Generic UnitOfWork**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/UnitOfWork) <br/> Ever want to execute a bunch of work items in a dynamic manner, and be able to control their order of execution, and run some of it in a separate execution context? Wow... that's a lot to ask.. But, the UnitOfWork will do that for you in just **88 line of code!!** <br/> Be ware, this fflib_**UnitOfWork** is something different than the fflib_**SObject**UnitOfwork
- [**Persitant Logger**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/Logger) <br/>
Ever want to log error messages in a Custom Object? The fflib_Logger will do it for you, even if you have a database-rollback.
- [**Extended domain features**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/Domain-Layer) <br/> Tons of extra methods in the domains to access the (S)Objects.
- [**TriggerHandler Redesigned**](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/Trigger-Handler) <br/> A complete redesign of the trigger handler, using the new Force-DI like [application class](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/application-factories) in combination with the [generic UnitOfWork](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki/UnitOfWork). It brings new advanced features like; enqueueing certain parts of trigger logic, separating trigger logic clearly in a readable structure and the ability to use dependency injection.

## Wiki
A full overview of the features in this extension pack and how to use them 
can be found in [the Wiki pages of this repository](https://github.com/wimvelzeboer/fflib-apex-extensions/wiki).
It is written in an easy readable format with lots of explanations on the design pattern Separation of Concerns, and how that apply those patterns.

A hands-on training session is also available to learn how to translate a user-story into Apex code. 

## Method Reference
When you rather prefer the bare overview of classes, methods and their examples,
then you can find a full overview of the methods, their signatures and description in the
[ApexDocs](./docs/README.asciidoc). 

## Example Application
You can look at 
[these examples](https://github.com/wimvelzeboer/fflib-apex-extensions-samplecode) 
if you like to see this extension package in action.

## Migrating from apex-commons

- [How to adapt](./docs/how-to-adapt.md) when coming from fflib-apex-common 

## Contributing
Anyone is welcome to fork this repository and propose changes or complete new features via raising a pull-requests. 

Please have read the [contributing guide](./CONTRIBUTING.md) that will through the process to making your first contribution! 

You can also have a look at the open items in the [project(s)](./projects), feel free to pick an item from the kanban board!

----
# Change Log
Some of the changes that have major impact are listed here;

### Updates 2026
- **fflib_ArrayUtils** <br/>
  _replaceKey_,<br/>Add method to replace the key of a given map.</br>
  _replaceValue_,<br/>Add three method overloads for merging a source map of idById and replacement map of idByString, idByDecimal or idByBoolean.</br>
  _mergeMaps_,<br/>Add method overload to merge two maps of idByBoolean<br/><br/>
- **fflib_SObjects2**<br/>
  The following methods have been added to the SObjects2 class:<br/>
  _getBooleanFieldByIdField_<br/>
  _getParentBooleanFieldById_<br/> 
  _getParentDecimalFieldById_<br/> 
  _getParentStringFieldById_<br/> <br/>
  Added new method overloads for Decimal values to `getRecords`, `getRecordsNotIn` and `getRecordsIsNot`<br/><br/>
- **API Upgrades** 
  Upgraded to API 65.0 

### Several updates during 2022

- **fflib_MockSObjectUtil** 
  _SetFieldvalue_ method overload added to fflib_MockSObjectUtil. With this you can set multiple readonly fields. 
- **fflib_Ids**
  _Join_ method added to simply join all Id values into a string, using a provided separator
- **fflib_ArrayUtils**
  _replaceValue_, Takes two maps and replaces the value of the source with the value of the replacement, where the source value matches the replacement key.
- **Minor bug fixes**
   fflib_ClassicDomainFactory: Avoid unexpected exceptions when the recordIds contains incorrect data

### October 2021
- **Logger functionality** <br/>A replacement of System.Debug that is using Platform events to store log messages in a Custom Object for you to monitor
- **API Upgrade to Winter'22** <br/> All Apex classes are upgraded to API 53.0
- **UnitOfWork** <br/> Generic UnitOfWork, capable of executing work items in batch at a single instance. Each item will be executed based on its priority and can be queued in a separate execution context when necessary.
- **TriggerHandler** <br/> A redesigned trigger handler using custom metadata and the generic UnitOfWork, to dynamicaly call trigger actions.

### August 2021
**Added criteria based on formula;  (1 OR 2) AND 3)**

```apex
new fflib_Criteria()
        .formulaCriteria('(1 OR 2) AND 3')
        .equalTo(Account.AccountNumber, '0001')
        .equalTo(Account.AccountNumber, '0002')
        .equalTo(Account.ShippingCountry, 'USA')
	 
Evaluates:
     (AccountNumber = '0001' OR AccountNumber = '0001') AND ShippingCountry = 'USA'
```

---

## Donations

We are pleased to announce that the fflib-apex-extensions Project is accepting donations in the privacy-oriented cryptocurrency Monero (XMR) at the following address:

> 8BMsQrdLiBvKaP87GFMPE9Wa1US79ygcp3b9kwoDq1iBW9JEYbcgpDS3hMp2p7ePWiCEKg2fdTucUbpNTtGbnvCCQZTMSu1

Thank you for your donations!