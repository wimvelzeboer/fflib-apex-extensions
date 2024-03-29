/**
 * File Name: fflib_ComparatorTest
 * @description Unit test class for fflib_Comparator
 *
 * @author architect ir. Wilhelmus G.J. Velzeboer
 *
 * Copyright (c), W.G.J. Velzeboer,
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above author notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the author nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
@IsTest(IsParallel=true)
private with sharing class fflib_ComparatorTest
{

	private static testmethod void testNulls()
	{
		String aNull = null;
		Object aNullO = aNull;
		Object xyz = 'xyz';
		System.Assert.areEqual(-1, fflib_Comparator.compare(aNullO, xyz));
		System.Assert.areEqual(0, fflib_Comparator.compare(aNullO, aNullO));
		System.Assert.areEqual(1, fflib_Comparator.compare(xyz, aNullO));
	}

	private static testmethod void testBlob()
	{
		Object b1 = Blob.valueOf('123');
		Object b2 = Blob.valueOf('abc');
		Boolean exceptionThrown = false;
		try
		{
			fflib_Comparator.compare(b1, b2);
		}
		catch (fflib_Comparator.IllegalArgumentException e)
		{
			exceptionThrown = true;
		}
		System.Assert.isTrue(exceptionThrown);
	}

	private static testmethod void testBoolean()
	{
		assertCompareBoolean(false, true, -1);
		assertCompareBoolean(true, true, 0);
		assertCompareBoolean(false, false, 0);
		assertCompareBoolean(true, false, 1);
	}

	private static void assertCompareBoolean(Object b1, Object b2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(b1, b2));
	}

	private static testmethod void testDate()
	{
		assertCompareDate(date.newinstance(1980, 2, 17), date.newinstance(1981, 2, 17), -1);
		assertCompareDate(date.newinstance(1981, 2, 17), date.newinstance(1981, 2, 17), 0);
		assertCompareDate(date.newinstance(1981, 2, 17), date.newinstance(1980, 2, 17), 1);
	}

	private static void assertCompareDate(Object d1, Object d2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(d1, d2));
	}

	private static testmethod void testDatetime()
	{
		Object d1 = Datetime.newInstance(2010, 01, 1, 12, 30, 0);
		Object d2 = Datetime.newInstance(2020, 01, 1, 12, 30, 0);
		assertCompareDatetime(d1, d2, -1);
		assertCompareDatetime(d1, d1, 0);
		assertCompareDatetime(d2, d1, 1);
	}

	private static testmethod void testDatetimeToDate()
	{
		Object d1 = Date.newInstance(2010, 01, 1);
		Object d2 = Datetime.newInstance(2020, 01, 1, 12, 30, 0);
		assertCompareDatetime(d1, d2, -1);
		assertCompareDatetime(d1, d1, 0);
		assertCompareDatetime(d2, d1, 1);
	}

	private static void assertCompareDatetime(Object d1, Object d2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(d1, d2));
	}

	private static testmethod void testDecimal()
	{
		Decimal d1 = 123.123;
		Decimal d2 = 125.125;
		assertCompareDecimal(d1, d2, -1);
		assertCompareDecimal(d1, d1, 0);
		assertCompareDecimal(d2, d1, 1);
	}

	private static void assertCompareDecimal(Object d1, Object d2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(d1, d2));
	}

	private static testmethod void testDouble()
	{
		Double d1 = 123.123;
		Double d2 = 125.125;
		assertCompareDouble(d1, d2, -1);
		assertCompareDouble(d1, d1, 0);
		assertCompareDouble(d2, d1, 1);
	}

	private static void assertCompareDouble(Object d1, Object d2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(d1, d2));
	}

	private static testmethod void testInteger()
	{
		Integer i1 = -10;
		Integer i2 = 15;
		assertCompare(i1, i2, -1);
		assertCompare(i1, i1, 0);
		assertCompare(i2, i1, 1);
	}

	private static void assertCompare(Object i1, Object i2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(i1, i2));
	}

	private static testmethod void testLong()
	{
		Long i1 = -10;
		Long i2 = 15;
		assertCompareLong(i1, i2, -1);
		assertCompareLong(i1, i1, 0);
		assertCompareLong(i2, i1, 1);
	}

	private static void assertCompareLong(Object l1, Object l2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(l1, l2));
	}

	private static testmethod void testTime()
	{
		Time t1 = Time.newInstance(18, 30, 2, 20);
		Time t2 = Time.newInstance(18, 30, 2, 21);
		assertCompareTime(t1, t2, -1);
		assertCompareTime(t2, t2, 0);
		assertCompareTime(t2, t1, 1);
	}
	private static void assertCompareTime(Object t1, Object t2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(t1, t2));
	}

	private static testmethod void testString()
	{
		String s1 = 'abc';
		String s2 = 'def';
		assertCompareString(s1, s2, -1);
		assertCompareString(s1, s1, 0);
		assertCompareString(s2, s1, 1);
	}

	private static void assertCompareString(Object s1, Object s2, Integer expected)
	{
		System.Assert.areEqual(expected, fflib_Comparator.compare(s1, s2));
	}

	private static testMethod void assertContainsNull()
	{
		System.Assert.isTrue(fflib_Comparator.contains(null, null));
	}

	private static testMethod void assertContainsSourceNull()
	{
		System.Assert.isTrue(!fflib_Comparator.contains(null, 0));
	}

	private static testMethod void assertContainsSearchNull()
	{
		System.Assert.isTrue(!fflib_Comparator.contains(new Set<String>(), null));
	}

	private static testMethod void assertContainsDate()
	{
		Date myDate = Date.newInstance(1976, 6, 1);
		System.Assert.isTrue(fflib_Comparator.contains(new Set<Date> {myDate}, myDate));
	}

	private static testMethod void assertContainsDateTime()
	{
		Datetime myDateTime = DateTime.newInstance(1976, 6, 1, 11, 55, 0);
		System.Assert.isTrue(fflib_Comparator.contains(new Set<Datetime> {myDateTime}, myDateTime));
	}

	private static testMethod void assertContainsDouble()
	{
		Double myDouble = Double.valueOf(123);
		System.Assert.isTrue(fflib_Comparator.contains(new Set<Double> {myDouble}, myDouble));
	}

	private static testMethod void assertContainsId()
	{
		Id id = fflib_IDGenerator.generate(Account.SObjectType);
		System.Assert.isTrue(fflib_Comparator.contains(new Set<Id> {id}, id));
	}

	private static testMethod void assertContainsInteger()
	{
		Set<Integer> integerSet = new Set<Integer>
		{
				0, 1, 2, 3
		};
		Object obj = (object) integerSet;
		System.Assert.istrue(fflib_Comparator.contains(obj, 2));
		System.Assert.isfalse(fflib_Comparator.contains(obj, 5));

		Account acc = new Account(Name = 'TEST', NumberOfEmployees = 1);
		System.Assert.istrue((object) acc.get('NumberOfEmployees') instanceof integer);
	}

	private static testMethod void assertContainsLong()
	{
		Long myLong = Long.valueOf('3123');
		System.Assert.isTrue(fflib_Comparator.contains(new Set<Long> {myLong}, myLong));
	}

	private static testMethod void assertContainsObject()
	{
		Object obj = (Object) '134';
		System.Assert.istrue(fflib_Comparator.contains(new Set<Object>{obj}, obj));
	}

	private static testMethod void assertContainsTime()
	{
		Time myTime = Time.newInstance(11, 55, 0, 0);
		System.Assert.istrue(fflib_Comparator.contains(new Set<Time> {myTime}, myTime));
	}

	private static testMethod void assertContainsString()
	{
		System.Assert.istrue(fflib_Comparator.contains(new Set<String> {'Test'}, 'Test'));
	}

	private static testMethod void assertContainsSObject()
	{
		Account myAccount = new Account();
		Boolean exceptionThrown = false;
		try
		{
			fflib_Comparator.contains(new Set<SObject> {myAccount}, myAccount);
		} catch (fflib_Comparator.IllegalArgumentException e)
		{
			exceptionThrown = true;
		}
		System.Assert.istrue(exceptionThrown);

	}
}