/**
 * File Name: ArrayTest 
 * Description: 
 *
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
@IsTest(IsParallel=true)
private class ArrayUtilsTest
{

    @IsTest
    static void testObjectToString()
    {
        System.assertEquals(
                new List<String> {'123', '456', '789'},
                ArrayUtils.objectToString(
                        new List<Object> {123, 456, 789}
                )
        );
    }

    @IsTest
    static void testObjectStringToString()
    {
        System.assertEquals(
                new List<String> {'123', '456', '789'},
                ArrayUtils.objectToString(
                        new List<Object> {'123', '456', '789'}
                )
        );
    }

    @IsTest
    static void itShouldReturnEmptyListOnEmptyObjectToString()
    {
        System.assertEquals(
                new List<String>(),
                ArrayUtils.objectToString(
                        new List<Object>()
                )
        );
    }

    @IsTest
    static void itShouldConvertSetToListOfString()
    {
        System.assertEquals(
                new List<String> {'1', '2', '3'},
                ArrayUtils.objectToString(
                        new Set<Object> {1, 2, 3}
                )
        );
    }

    @IsTest
    static void itShouldConvertSetObjectToSetOfIds()
    {
        Id idA = fflib_IDGenerator.generate(Account.SObjectType);
        Id idB = fflib_IDGenerator.generate(Account.SObjectType);
        System.assertEquals(
                new Set<Id> {idA, idB},
                ArrayUtils.objectToIds(
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
        System.assertEquals(
                new List<Object>
                {
                        (Object) 'C',
                        (Object) 'B',
                        (Object) 'A'
                },
                ArrayUtils.reverse(
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
        System.assertEquals(
                new List<SObject>
                {
                        (SObject) new Account(Name = 'C'),
                        (SObject) new Account(Name = 'B'),
                        (SObject) new Account(Name = 'A')
                },
                ArrayUtils.reverse(
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
        System.assertEquals(
                new List<String>
                {
                        'TEST A',
                        'TEST B',
                        'TEST C'
                },
                ArrayUtils.upperCase(
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
        System.assertEquals(
                new List<String> {'abc', 'def'},
                ArrayUtils.lowerCase(
                        new List<String> {'ABC', 'DEF'}
                )
        );
    }

    @IsTest
    static void testIsEmpty()
    {
        List<String> aNull = null;
        System.assertEquals(true, ArrayUtils.isEmpty(aNull));
        System.assertEquals(true, ArrayUtils.isEmpty(new List<String> {}));
        System.assertEquals(false, ArrayUtils.isEmpty(new List<String> {'a'}));
        System.assertEquals(false, ArrayUtils.isEmpty(new List<String> {'a', 'b'}));
        System.assertEquals(true, ArrayUtils.isEmpty(new List<Integer> {}));
        System.assertEquals(false, ArrayUtils.isEmpty(new List<Integer> {1}));
        System.assertEquals(false, ArrayUtils.isEmpty(new List<Integer> {1, 2}));
    }

    @IsTest
    static void testIsNotEmpty()
    {
        List<String> aNull = null;
        System.assertEquals(false, ArrayUtils.isNotEmpty(aNull));
        System.assertEquals(false, ArrayUtils.isNotEmpty(new List<String> {}));
        System.assertEquals(true, ArrayUtils.isNotEmpty(new List<String> {'a'}));
        System.assertEquals(true, ArrayUtils.isNotEmpty(new List<String> {'a', 'b'}));
        System.assertEquals(false, ArrayUtils.isNotEmpty(new List<Integer> {}));
        System.assertEquals(true, ArrayUtils.isNotEmpty(new List<Integer> {1}));
        System.assertEquals(true, ArrayUtils.isNotEmpty(new List<Integer> {1, 2}));
        System.assertEquals(false, ArrayUtils.isNotEmpty(new List<Account> {}));
        System.assertEquals(true, ArrayUtils.isNotEmpty(new List<Account> {new Account(Name = 'test')}));
    }

    @IsTest
    static void itShouldReturnMostRecentDatetime()
    {
        // GIVEN - a list of unsorted Datetime values
        List<Datetime> datetimes = generateDateTimes();

        // WHEN - we request the maxDatetime
        Datetime maxDatetime = ArrayUtils.maxDatetime(datetimes);

        // THEN - the highest Datetime should be returned
        System.assertEquals(datetimes.get(1), maxDatetime);
    }

    @IsTest
    static void itShouldReturnOldestDatetime()
    {
        // GIVEN - a list of unsorted Datetime values
        List<Datetime> datetimes = generateDateTimes();

        // WHEN - we request the maxDatetime
        Datetime maxDatetime = ArrayUtils.minDatetime(datetimes);

        // THEN - the highest Datetime should be returned
        System.assertEquals(datetimes.get(4), maxDatetime);
    }

    @IsTest
    static void itShouldHandleNullInputsForMaxDatatime()
    {
        System.assertEquals(
                null, ArrayUtils.maxDatetime(new List<Datetime>()),
                'maxDatetime method was unable to handle an empty list as input'
        );
        System.assertEquals(
                null, ArrayUtils.maxDatetime(null),
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
        List<Integer> sorted = ArrayUtils.cloneAndSort(unsorted);
        System.assertNotEquals(unsorted, sorted, 'The original object was modified, something went wrong with the cloning');
        System.assertEquals(new List<Integer> {-7, 1, 2, 30, 76}, sorted, 'Incorrect sorted list returned');
    }

    @IsTest
    static void itShouldReturnTheLastValueInTheList()
    {
        // GIVEN - a list of unsorted values
        List<Object> objects = new List<Object> {1, 2, 3, 9, 4, 7, 8};

        // WHEN - we request the last value
        Object result = ArrayUtils.lastValue(objects);

        // THEN - the highest Datetime should be returned
        System.assertEquals(8, result, 'Did not return the last value in the list of objects');
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
}