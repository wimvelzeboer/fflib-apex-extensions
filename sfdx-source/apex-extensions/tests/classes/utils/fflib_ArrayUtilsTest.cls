/**
 * File Name: fflib_ArrayUtilsTest
 * @description
 *
 * @author architect ir. Wilhelmus G.J. Velzeboer | wim@velzeboer.nl
 */
@IsTest(IsParallel=true)
private class fflib_ArrayUtilsTest
{

    @IsTest
    static void testObjectToString()
    {
        System.Assert.areEqual(
                new List<String> {'123', '456', '789'},
                fflib_ArrayUtils.objectToString(
                        new List<Object> {123, 456, 789}
                )
        );
    }

    @IsTest
    static void testObjectStringToString()
    {
        System.Assert.areEqual(
                new List<String> {'123', '456', '789'},
                fflib_ArrayUtils.objectToString(
                        new List<Object> {'123', '456', '789'}
                )
        );
    }

    @IsTest
    static void itShouldCopyFields() {
        final String city = 'New York';
        final String country = 'United States';

        Account accountRecord = new Account(
                Id = fflib_IDGenerator.generate(Account.SObjectType),
                BillingCity = city,
                BillingCountry = country);
        Accounts accounts = new Accounts(new List<Account>{
                accountRecord
        });

        Contact contactRecord = new Contact(
                Id = fflib_IDGenerator.generate(Contact.SObjectType),
                AccountId = accountRecord.Id
        );
        Contacts contacts = new Contacts(new List<Contact>{
                contactRecord
        });

        System.Test.startTest();
        fflib_ArrayUtils.copyFields(accounts, contacts, Contact.AccountId,
                new Map<SObjectField, SObjectField>{
                        Account.BillingCity => Contact.MailingCity,
                        Account.BillingCountry => Contact.MailingCountry
                }
        );
        System.Test.stopTest();

        System.Assert.areEqual(city, contactRecord.MailingCity, 'Mailing City not Copied');
        System.Assert.areEqual(country, contactRecord.MailingCountry, 'Mailing Country not Copied');
    }

    @IsTest
    static void itShouldReturnEmptyListOnEmptyObjectToString()
    {
        System.Assert.areEqual(
                new List<String>(),
                fflib_ArrayUtils.objectToString(
                        new List<Object>()
                )
        );
    }

    @IsTest
    static void itShouldConvertSetToListOfString()
    {
        System.Assert.areEqual(
                new List<String> {'1', '2', '3'},
                fflib_ArrayUtils.objectToString(
                        new Set<Object> {1, 2, 3}
                )
        );
    }

    @IsTest
    static void itShouldConvertSetObjectToSetOfIds()
    {
        Id idA = fflib_IDGenerator.generate(Account.SObjectType);
        Id idB = fflib_IDGenerator.generate(Account.SObjectType);
        System.Assert.areEqual(
                new Set<Id> {idA, idB},
                fflib_ArrayUtils.objectToIds(
                        new Set<Object>
                        {
                                (Object) idA,
                                (Object) idB
                        }
                )
        );
    }

    @IsTest
    static void itShouldReturnReversedObjectList()
    {
        System.Assert.areEqual(
                new List<Object>
                {
                        (Object) 'C',
                        (Object) 'B',
                        (Object) 'A'
                },
                fflib_ArrayUtils.reverse(
                        new List<Object>
                        {
                                (Object) 'A',
                                (Object) 'B',
                                (Object) 'C'
                        }
                )
        );
    }

    @IsTest
    static void itShouldReturnReversedSObjectList()
    {
        System.Assert.areEqual(
                new List<SObject>
                {
                        (SObject) new Account(Name = 'C'),
                        (SObject) new Account(Name = 'B'),
                        (SObject) new Account(Name = 'A')
                },
                fflib_ArrayUtils.reverse(
                        new List<SObject>
                        {
                                (SObject) new Account(Name = 'A'),
                                (SObject) new Account(Name = 'B'),
                                (SObject) new Account(Name = 'C')
                        }
                )
        );
    }

    @IsTest
    static void itShouldConvertListOfStringsIntoUpperCase()
    {
        System.Assert.areEqual(
                new List<String>
                {
                        'TEST A',
                        'TEST B',
                        'TEST C'
                },
                fflib_ArrayUtils.upperCase(
                        new List<String>
                        {
                                'test a',
                                'test b',
                                'test c'
                        }
                )
        );
    }

    @IsTest
    static void testLowerCase()
    {
        System.Assert.areEqual(
                new List<String> {'abc', 'def'},
                fflib_ArrayUtils.lowerCase(
                        new List<String> {'ABC', 'DEF'}
                )
        );
    }

    @IsTest
    static void testIsEmpty()
    {
        List<String> aNull = null;
        System.Assert.isTrue(fflib_ArrayUtils.isEmpty(aNull));
        System.Assert.isTrue(fflib_ArrayUtils.isEmpty(new List<String> {}));
        System.Assert.isFalse(fflib_ArrayUtils.isEmpty(new List<String> {'a'}));
        System.Assert.isFalse(fflib_ArrayUtils.isEmpty(new List<String> {'a', 'b'}));
        System.Assert.isTrue(fflib_ArrayUtils.isEmpty(new List<Integer> {}));
        System.Assert.isFalse(fflib_ArrayUtils.isEmpty(new List<Integer> {1}));
        System.Assert.isFalse(fflib_ArrayUtils.isEmpty(new List<Integer> {1, 2}));
    }

    @IsTest
    static void testIsNotEmpty()
    {
        List<String> aNull = null;
        System.Assert.isFalse(fflib_ArrayUtils.isNotEmpty(aNull));
        System.Assert.isFalse(fflib_ArrayUtils.isNotEmpty(new List<String> {}));
        System.Assert.isTrue(fflib_ArrayUtils.isNotEmpty(new List<String> {'a'}));
        System.Assert.isTrue(fflib_ArrayUtils.isNotEmpty(new List<String> {'a', 'b'}));
        System.Assert.isFalse(fflib_ArrayUtils.isNotEmpty(new List<Integer> {}));
        System.Assert.isTrue(fflib_ArrayUtils.isNotEmpty(new List<Integer> {1}));
        System.Assert.isTrue(fflib_ArrayUtils.isNotEmpty(new List<Integer> {1, 2}));
        System.Assert.isFalse(fflib_ArrayUtils.isNotEmpty(new List<Account> {}));
        System.Assert.isTrue(fflib_ArrayUtils.isNotEmpty(new List<Account> {new Account(Name = 'test')}));
    }

    @IsTest
    static void itShouldReturnMostRecentDatetime()
    {
        // GIVEN - a list of unsorted Datetime values
        List<Datetime> datetimes = generateDateTimes();

        // WHEN - we request the maxDatetime
        Datetime maxDatetime = fflib_ArrayUtils.maxDatetime(datetimes);

        // THEN - the highest Datetime should be returned
        System.Assert.areEqual(datetimes.get(1), maxDatetime);
    }

    @IsTest
    static void itShouldReturnOldestDatetime()
    {
        // GIVEN - a list of unsorted Datetime values
        List<Datetime> datetimes = generateDateTimes();

        // WHEN - we request the maxDatetime
        Datetime maxDatetime = fflib_ArrayUtils.minDatetime(datetimes);

        // THEN - the highest Datetime should be returned
        System.Assert.areEqual(datetimes.get(4), maxDatetime);
    }

    @IsTest
    static void itShouldHandleNullInputsForMaxDatatime()
    {
        System.Assert.isNull(
                fflib_ArrayUtils.maxDatetime(new List<Datetime>()),
                'maxDatetime method was unable to handle an empty list as input'
        );
        System.Assert.isNull(
                fflib_ArrayUtils.maxDatetime(null),
                'maxDatetime method was unable to handle null as input'
        );
    }

    @IsTest
    static void itShouldCloneAndSortTheList()
    {
        // GIVEN - a list of unsorted numbers
        List<Integer> unsorted = new List<Integer>
        {
                1, 30, 2, 76, -7
        };

        // WHEN - we request the a cloned and sorted list
        List<Integer> sorted = fflib_ArrayUtils.cloneAndSort(unsorted);
        System.Assert.areNotEqual(unsorted, sorted, 'The original object was modified, something went wrong with the cloning');
        System.Assert.areEqual(new List<Integer> {-7, 1, 2, 30, 76}, sorted, 'Incorrect sorted list returned');
    }

    @IsTest
    static void itShouldReturnTheLastValueInTheList()
    {
        // GIVEN - a list of unsorted values
        List<Object> objects = new List<Object> {1, 2, 3, 9, 4, 7, 8};

        // WHEN - we request the last value
        Object result = fflib_ArrayUtils.lastValue(objects);

        // THEN - the highest Datetime should be returned
        System.Assert.areEqual(8, result, 'Did not return the last value in the list of objects');
    }

    @IsTest
    static void itShouldReplaceKeyInTheMap()
    {
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, Id> source = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => contactIdB,
                accountIdC => fflib_IDGenerator.generate(Schema.Contact.SObjectType)
        };
        Map<Id, Id> replacement = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => accountIdA
        };

        Map<Id, Id> result = fflib_ArrayUtils.replaceKey(source, replacement);

        System.Assert.areEqual(2, result.size());
        System.Assert.areEqual(contactIdA, result.get(contactIdA));
        System.Assert.areEqual(contactIdB, result.get(accountIdA));
    }

    @IsTest
    static void itShouldReplaceValueInTheMap()
    {
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, Id> source = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => contactIdB,
                accountIdC => fflib_IDGenerator.generate(Schema.Contact.SObjectType)
        };
        Map<Id, Id> replacement = new Map<Id, Id>
        {
                contactIdA => accountIdB,
                contactIdB => accountIdA
        };

        Map<Id, Id> result = fflib_ArrayUtils.replaceValue(source, replacement);

        System.Assert.areEqual(3, result.size());
        System.Assert.areEqual(accountIdB, result.get(accountIdA));
        System.Assert.areEqual(accountIdA, result.get(accountIdB));
        System.Assert.isNull(result.get(accountIdC));
    }

    @IsTest
    static void itShouldReplaceValueInTheMap_decimal()
    {
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, Id> source = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => contactIdB,
                accountIdC => fflib_IDGenerator.generate(Schema.Contact.SObjectType)
        };
        Map<Id, Decimal> replacement = new Map<Id, Decimal>
        {
                contactIdA => 10.0,
                contactIdB => 20.0
        };

        Map<Id, Decimal> result = fflib_ArrayUtils.replaceValue(source, replacement);

        System.Assert.areEqual(3, result.size());
        System.Assert.areEqual(10.0, result.get(accountIdA));
        System.Assert.areEqual(20.0, result.get(accountIdB));
        System.Assert.isNull(result.get(accountIdC));
    }

    @IsTest
    static void itShouldReplaceValueInTheMap_string()
    {
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, Id> source = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => contactIdB,
                accountIdC => fflib_IDGenerator.generate(Schema.Contact.SObjectType)
        };
        Map<Id, String> replacement = new Map<Id, String>
        {
                contactIdA => 'First',
                contactIdB => 'Second'
        };

        Map<Id, String> result = fflib_ArrayUtils.replaceValue(source, replacement);

        System.Assert.areEqual(3, result.size());
        System.Assert.areEqual('First', result.get(accountIdA));
        System.Assert.areEqual('Second', result.get(accountIdB));
        System.Assert.isNull(result.get(accountIdC));
    }

    @IsTest
    static void itShouldReplaceValueInTheMap_stringToId()
    {
        String accountName = 'AccountName';
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, String> source = new Map<Id, String>
        {
                accountIdA => accountName + 'A',
                accountIdB => accountName + 'B',
                accountIdC => accountName + 'C'
        };
        Map<String, Id> replacement = new Map<String, Id>
        {
                accountName + 'A' => contactIdA,
                accountName + 'B' => contactIdB
        };

        Map<Id, Id> result = fflib_ArrayUtils.replaceValue(source, replacement);

        System.Assert.areEqual(3, result.size());
        System.Assert.areEqual(contactIdA, result.get(accountIdA));
        System.Assert.areEqual(contactIdB, result.get(accountIdB));
        System.Assert.isNull(result.get(accountIdC));
    }

    @IsTest
    static void itShouldReplaceValueInTheMap_boolean()
    {
        Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
        Map<Id, Id> source = new Map<Id, Id>
        {
                accountIdA => contactIdA,
                accountIdB => contactIdB,
                accountIdC => fflib_IDGenerator.generate(Schema.Contact.SObjectType)
        };
        Map<Id, Boolean> replacement = new Map<Id, Boolean>
        {
                contactIdA => true,
                contactIdB => false
        };

        Map<Id, Boolean> result = fflib_ArrayUtils.replaceValue(source, replacement);

        System.Assert.areEqual(3, result.size());
        System.Assert.isTrue(result.get(accountIdA));
        System.Assert.isFalse(result.get(accountIdB));
        System.Assert.isNull(result.get(accountIdC));
    }

    @IsTest
    static void itShouldReturnAllValuesForTheGivenIds()
    {
        // GIVEN a map with String by Ids
        final Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Map<Id, String> stringsByIds = new Map<Id, String>
        {
                accountIdA => 'Account A',
                accountIdB => 'Account B',
                accountIdC => 'Account C'
        };

        // WHEN we retrieve a sub-set of Ids
        Set<String> result = fflib_ArrayUtils.getAllValues(stringsByIds, new Set<Id> {accountIdA, accountIdB});

        // THEN we get the values of the provide sub-set Ids
        System.Assert.isTrue(result.containsAll(new Set<String> {'Account A', 'Account B'}));
    }

    @IsTest
    static void itShouldReturnMergedMap()
    {
        final Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Set<Id> ids = new Set<Id> {accountIdA, accountIdB, accountIdC};

        final Map<Id, Set<String>> stringsByIdsA = new Map<Id, Set<String>>
        {
                accountIdA => new Set<String> {'A1', 'A2'},
                accountIdB => new Set<String> {'B1'}
        };
        final Map<Id, Set<String>> stringsByIdsB = new Map<Id, Set<String>>
        {
                accountIdA => new Set<String> {'A3'},
                accountIdC => new Set<String> {'C1'}
        };

        Map<Id, Set<String>> result = fflib_ArrayUtils.mergeMaps(stringsByIdsA, stringsByIdsB);

        System.Assert.isTrue(result.keySet().containsAll(ids));
        System.Assert.isTrue(result.get(accountIdA).containsAll(new Set<String>{'A1', 'A2', 'A3'}));
        System.Assert.areEqual(3, result.get(accountIdA).size());
        System.Assert.isTrue(result.get(accountIdB).contains('B1'));
        System.Assert.areEqual(1, result.get(accountIdB).size());
        System.Assert.isTrue(result.get(accountIdC).contains('C1'));
        System.Assert.areEqual(1, result.get(accountIdC).size());
    }

    @IsTest
    static void itShouldReturnMergedMap_Boolean()
    {
        final Id accountIdA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdB = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdC = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Id accountIdD = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        final Set<Id> ids = new Set<Id> {accountIdA, accountIdB, accountIdC, accountIdD};

        final Map<Id, Boolean> booleanByIdA = new Map<Id, Boolean>
        {
                accountIdA => true,
                accountIdB => false,
                accountIdD=> false
        };
        final Map<Id, Boolean> booleanByIdB = new Map<Id, Boolean>
        {
                accountIdA => false,
                accountIdB => true,
                accountIdC => true
        };

        Map<Id, Boolean> result = fflib_ArrayUtils.mergeMaps(booleanByIdA, booleanByIdB);

        System.Assert.isTrue(result.keySet().containsAll(ids));
        System.Assert.isTrue(result.get(accountIdA));
        System.Assert.isTrue(result.get(accountIdB));
        System.Assert.isTrue(result.get(accountIdC));
        System.Assert.isFalse(result.get(accountIdD));
    }

    private static List<Datetime> generateDateTimes()
    {
        return new List<Datetime>
        {
                Datetime.newInstance(2020, 01, 01, 07, 59, 7),
                Datetime.newInstance(2020, 02, 01, 07, 40, 7),
                Datetime.newInstance(2020, 02, 01, 07, 00, 7),
                Datetime.newInstance(2019, 02, 01, 07, 59, 7),
                Datetime.newInstance(2018, 07, 07, 07, 7, 7)
        };
    }

    private class Accounts extends fflib_SObjects2 {
        public Accounts(List<SObject> records) {
            super(records, Account.SObjectType);
        }

        public override SObjectType getSObjectType() {
            return Account.SObjectType;
        }
    }

    private class Contacts extends fflib_SObjects2 {
        public Contacts(List<SObject> records) {
            super(records, Account.SObjectType);
        }

        public override SObjectType getSObjectType() {
            return Contact.SObjectType;
        }
    }
}