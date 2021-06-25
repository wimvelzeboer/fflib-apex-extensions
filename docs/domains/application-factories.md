# fflib-apex-extensions

## Application Factory Interface Structure

1. [Interface structure](#interface-structure)
1. [Classic](#classic), a backwards compatible implementation 
1. Dependency Injection, a dynamic factory that can be configured instead of using hard reference maps

### Interface structure
The existing Application factories of the 
[apex-commons](https://github.com/apex-enterprise-patterns/fflib-apex-common)
do not have interfaces, therefore it is hard to replace their implementations. The fflib-apex-extensions add an interface structure and includes multiple implementations for you to choose from.

The [classic](#classic) implementation is fully backward compatible and in the well known familiar structure.

The interfaces adds the following added features

- fflib_IServiceFactory
    - [replaceWith](#fflib_iservicefactory---replacewith)
- fflib_ISelectorFactory
    - [selectById](#fflib_iselectorfactory---selectbyid) _(method overload)_
    - [replaceWith](#fflib_iselectorfactory---replacewith)
    - [setMock](#fflib_iselectorfactory---setmock) _(method overload)_
- fflib_IDomainFactory
    - [newInstance](#fflib_idomainfactory---newinstance) _(method overload)_
    - [replaceWith](#fflib_idomainfactory---replacewith)
    - [setMock](#fflib_idomainfactory---setmock) _(method overload)_


##### fflib_IServiceFactory - replaceWith
This will create or replaces an existing binding for another.

###### Syntax
`void replaceWith(Type serviceInterfaceType, Type replacementImplType)`

###### Example
Let's assume we have two implementation for AccountsService `AccountsServiceImpl` and `AlternativeAccountsServiceImpl`.
In the Service Factory `IAccountsService` is bound to the `AccountsServiceImpl` implementation.
```apex
IAccountsService accountsService = (IAccountsService) Application.Service.newInstance();
System.assert(accountsService instanceof AccountsServiceImpl);

// Replace the implementation binding
Application.Service.replaceWith(IAccountsService.class, MyAlternateAccountsServiceImpl.class);

IAccountsService accountsService = (IAccountsService) Application.Service.newInstance();
System.assert(accountsService instanceof AlternativeAccountsServiceImpl);
```

##### fflib_ISelectorFactory - selectById
This method overload accepts an extra argument named `sObjectType`. 
By providing the SObjectType, the method assumes that all the provided Ids are of the given SObjectType.
Thereby executing faster as the original method doesn't need to iterate over all the ids 
to validate that they are all from the same SObjectType.

###### Syntax
`List<SObject> selectById(Set<Id> recordIds, SObjectType sObjectType)`

##### fflib_ISelectorFactory - replaceWith
This will create or replaces an existing binding for another.

###### Syntax
`void replaceWith(SObjectType sObjectType, Type replacementImplType)`

##### fflib_ISelectorFactory - setMock
This method overload avoids the need to stub the selector mock to return its SObjectType

###### Syntax
`void setMock(SObjectType sObjectType, fflib_ISObjectSelector selectorInstance)`

###### Example
Instead of doing this:
```apex
fflib_ApexMocks mocks = new fflib_ApexMocks();
AccountsSelector serviceMock = (AccountsSelector) mocks.mock(AccountsSelector.class);
mocks.startStubbing();
mocks.when(selectorMock.sObjectType()).thenReturn(Schema.Account.SObjectType);
mocks.stopStubbing();
Application.Selector.setMock(serviceMock);
```
You can now do the same without the need to stub it:
```apex
fflib_ApexMocks mocks = new fflib_ApexMocks();
AccountsSelector serviceMock = (AccountsSelector) mocks.mock(AccountsSelector.class);
Application.Selector.setMock(Schema.Account.SObjectType, serviceMock);
```

##### fflib_IDomainFactory - newInstance
The added argument `sObjectType` avoids the selector to iterate over the given record Ids to validate them.

###### Syntax
`fflib_IDomain newInstance(Set<Id> recordIds, Schema.SObjectType sObjectType)`

##### fflib_IDomainFactory - replaceWith
This will create or replaces an existing binding for another.
###### Syntax
`void replaceWith(Schema.SObjectType sObjectType, Type replacementImplType)`

##### fflib_IDomainFactory - setMock
This method overload avoids the need to stub the selector mock to return its SObjectType

###### Syntax
`void setMock(Schema.SObjectType sObjectType, fflib_ISObjectDomain mockDomain)`

###### Example
Instead of doing this:
```apex
fflib_ApexMocks mocks = new fflib_ApexMocks();
IAccounts domainMock = (IAccounts) mocks.mock(IAccounts.class);
mocks.startStubbing();
mocks.when(domainMock.getType()).thenReturn(Schema.Account.SObjectType);
mocks.stopStubbing();
Application.Domain.setMock(domainMock);
```
You can now do the same without the need to stub it:
```apex
fflib_ApexMocks mocks = new fflib_ApexMocks();
IAccounts domainMock = (IAccounts) mocks.mock(IAccounts.class);
Application.Domain.setMock(Schema.Account.SObjectType, domainMock);
```

### Classic
This is the implementation you are looking for when you are used to the 
[Application Factories](https://github.com/apex-enterprise-patterns/fflib-apex-common/blob/master/sfdx-source/apex-common/main/classes/fflib_Application.cls) 
of the 
[apex-commons](https://github.com/apex-enterprise-patterns/fflib-apex-common)
and you do not want to change anything about the structure based on maps, 
but do like to use the added features of fflib-apex-extensions.

It is fully backwards compatible, and you only need to make a few small changes to your existing Application class, to use the added features.

#### Application Class
The Application class is slightly different than the stafactories in the fflib_Application are replaced by an interface structure.
To use the backwards compatible version of the factories, change your Application class into the example below.
Pay special attention to the interface types and implementation classes of the factories.

**Example**
```apex
public class Application
{
    public static final fflib_IUnitOfWorkFactory UnitOfWork =
            new fflib_ClassicUnitOfWorkFactory(
                    new List<SObjectType>
                    {
                            Schema.Account.SObjectType,
                            Schema.Contact.SObjectType,
                            ...
                    }
            );

    public static final fflib_IServiceFactory Service =
            new fflib_ClassicServiceFactory(
                    new Map<Type, Type>
                    {
                            IAccountsService.class => AccountsServiceImpl.class,
                            IContactsService.class => ContactsServiceImpl.class,
                            ...
                    }
            );

    public static final fflib_ISelectorFactory Selector =
            new fflib_ClassicSelectorFactory(
                    new Map<SObjectType, Type>
                    {
                            Schema.Account.SObjectType => AccountsSelector.class,
                            Schema.Contact.SObjectType => ContactsSelector.class,
                            ...
                    }
            );

    public static final fflib_IDomainFactory Domain =
            new fflib_ClassicDomainFactory(
                    Application.Selector,
                    new Map<SObjectType, Type>
                    {
                            Schema.Account.SObjectType => Accounts.Constructor.class,
                            Schema.Contact.SObjectType => Contacts.Constructor.class,
                            ...
                    }
            );
}
```