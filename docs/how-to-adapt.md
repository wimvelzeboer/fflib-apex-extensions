# fflib-apex-extensions

## How to adapt
When you are familiar with using fflib-apex-common, then you need to be aware of a few differences that you will encounter when adopting this extension package.

### Contents

1. [The Application class](#changes-to-the-application)
1. [Domain class changes](#changes-to-the-domain)

### Changes to the Application
The factories in the fflib_Application are replaced by an interface structure. 
To use the backwards compatible version of the factories, change your Application class into the example below.
Pay special attention to the interface types and implementation classes of the factories. 

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


### Changes to the domain
A Domain class is extended from the domain class `SObjects` instead of `fflib_SObjects`.

