# fflib-apex-extensions

## Criteria based filter for Domains and Selectors

A common criteria based filter for domains and SOQL condition generator for Selectors.


It is very often that we have the same filters in domain and elector classes. The Criteria feature provides a solution that extracts the filter conditions into a single reusable criteria class. These filter conditions are dynamic and can be evaluated in run-time, or be converted to a SOQL statement condition.
```
                + - - - - - - - - +
        + - - - | Filter Criteria | - - - +  
        |       + - - - - - - - - +       |
        |                                 | 
        |                                 |
+ - - - - - - - +                 + - - - - - - - +
|    Domain     |                 |    Selector   |
+ - - - - - - - +                 + - - - - - - - +
```
Here is an example on how its used:

The criteria class is the place where all the filter conditions are stored for a single SObjectType.

```apex
public with sharing class AccountCriteria extends fflib_Criteria
{
    public AccountCriteria shippingCountryEquals(String countryName)
    { 
        equalTo(Schema.Account.ShippingCountry, countryName);
        return this;                
    }
    
    public AccountCriteria numberOfEmployeesGreaterThan(Integer numberOfEmployees)
    {
        greaterThan(Schema.Account.NumberOfEmployees, numberOfEmployees);
        return this;
    }
}
```

How it can be applied in a Domain class:

```apex
public with sharing class Accounts
        extends SObjects
        implements IAccounts
{
    private static final Integer LARGE_ACCOUNT_EMPLOYEE_NUMBERS = 500;

    public Accounts getByCountry(String countryName)
    {
        return new Accounts(
                getRecords(
                        new AccountCriteria().shippingCountryEquals(countryName)
                )
        );
    }
    
    public Accounts getByNumberOfEmployeesGreaterThan(Integer numberOfEmployees)
    {
        return new Accounts(
                getRecords(
                       new AccountCriteria().numberOfEmployeesGreaterThan(numberOfEmployees)
                )
        );
    }
    
    public Accounts getByLargeAccountsInCountry(String countryName)
    {
        return new Accounts(
                getRecords(
                       new AccountCriteria()
                               .shippingCountryEquals(countryName)
                               .numberOfEmployeesGreaterThan(numberOfEmployees)
                )
        );
    }
}
```
In this example we see three filters; one for country, another for checking minimal number of employees and a third that combines the first two.
It is important not to have a filter with too many conditions.
One filter criteria condition per method is ideal to have maximum flexibility and a high chance on code-reuse.


How the same filters can be used in the Selector class:

```apex
public with sharing class AccountsSelector
        extends fflib_SObjectSelector
        implements IAccountsSelector
{
    ...
    public List<Account> selectByCountryWithMinimalNumberOfEmployees(String country, Integer minimalNumberOfEmployees)
    {
        return (List<Account>)  Database.query(
                newQueryFactory()
                        .setCondition(
                                new AccountCriteria()
                                        .ShippingCountryEquals(country)
                                        .NumberOfEmployeesGreaterThan(minimalNumberOfEmployees)
                                        .toSOQL()
                        )
        );
    }
    ...
}
```

With this feature developers can avoid a lot of code duplications.
Hope you like it!
