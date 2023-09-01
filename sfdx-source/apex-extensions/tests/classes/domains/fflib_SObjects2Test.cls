/**
 * File Name: SObjects
 * @description Primitive domain for the object type SObject
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
private class fflib_SObjects2Test
{
	@IsTest
	static void itShouldAddErrorMessage()
	{
		SObjectType accountSObjectType = Schema.Account.SObjectType;
		final Id idA = fflib_IDGenerator.generate(accountSObjectType);
		final Id idB = fflib_IDGenerator.generate(accountSObjectType);

		DomainAccounts domain = new DomainAccounts(
				new List<SObject>
				{
						new Account(Id = idA),
						new Account(Id = idB)
				}
		);

		domain.addError(Schema.Account.Name,'Oops');

		System.Assert.areEqual(
				2,
				fflib_SObjects.Errors.getAll().size()
		);
	}

	@IsTest
	static void itShouldClearTheField()
	{
		Account record = new Account(ShippingCountry = 'Holland');
		DomainAccounts domain = new DomainAccounts(new List<Account> {record});
		System.Assert.isFalse(domain.selectByShippingCountry('Holland').isEmpty(), 'Incorrect test data');

		domain.clearShippingCountry();

		System.Assert.isTrue(domain.selectByShippingCountry('Holland').isEmpty(), 'Field should have been nullified');
	}

	@IsTest
	static void itShouldReturnTheCreatedData()
	{
		System.Assert.areEqual(
				(Object) Schema.Account.SObjectType,
				new DomainAccounts(new List<Account>())
						.getType(),
				'Unexpected Domain Type'
		);
		System.Assert.areEqual(
				Schema.Account.SObjectType,
				new DomainAccounts(new List<Account>())
						.getSObjectType(),
				'Unexpected Domain SObjectType'
		);
	}

	@IsTest
	static void itShouldReturnTheDomainsType()
	{
		fflib_Criteria criteria = new fflib_Criteria().equalTo(Account.Name, 'A');

		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'A', ShippingCountry = 'USA', AnnualRevenue = 5, BillingLatitude = 121.0),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'B', ShippingCountry = 'Ireland', AnnualRevenue = 3),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'C', ShippingCountry = 'UK', AnnualRevenue = 2),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'D', ShippingCountry = '', AnnualRevenue = 1),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'E'),
						new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), BillingLatitude = 121.0 )
				}
		);
		domain.getDateTimeFieldValues(Account.LastActivityDate);
		domain.getDateTimeFieldValues(Account.CreatedDate, criteria);
		domain.getFieldByField(Account.Name, Account.AnnualRevenue);
		domain.getFieldsByField(Account.Id, Account.AnnualRevenue);
		domain.getFieldByField(Account.Id, Account.Id);
		domain.getIdFieldsByIdField(Account.Id, Account.Id);
		domain.getIdFieldValues(Account.Id);
		domain.getIdFieldValues(Account.Id, criteria);
		domain.getDecimalFieldValues(Account.BillingLatitude, criteria);
		domain.getDoubleFieldValues(Account.BillingLatitude);
		domain.getDoubleFieldValues(Account.BillingLatitude, criteria);
		domain.getSObjectByIdField(Account.Id);
		domain.getSObjectsByIdField(Account.Id);
		domain.getSObjectByStringField(Account.Name);
		domain.getSObjectsByStringField(Account.Name);
		domain.getStringFieldByStringField(Account.Name, Account.AccountNumber);
		domain.getStringFieldValues(Account.Name, criteria);

		// todo - add assertions
	}

	@IsTest
	static void itShouldReturnTheRelatedChildDomainId_deprecated()
	{
		// GIVEN a case A & Z related to contact A related to Account,
		Id caseIdA = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdZ = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdB = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdC = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Account accountRecord = new Account(Id = accountId);
		Contact contactRecordA = new Contact(Id = contactIdA, AccountId = accountId);
		Contact contactRecordB = new Contact(Id = contactIdB);
		Case caseRecordA = new Case(Id = caseIdA, ContactId = contactIdA);
		Case caseRecordZ = new Case(Id = caseIdZ, ContactId = contactIdA);
		Case caseRecordB = new Case(Id = caseIdB, ContactId = contactIdB);
		Case caseRecordC = new Case(Id = caseIdC);

		DomainAccounts accountDomain = new DomainAccounts(new List<Account> {accountRecord});
		DomainContacts contactDomain = new DomainContacts(new List<Contact> {contactRecordA, contactRecordB});
		DomainCases caseDomain = new DomainCases(new List<Case> {caseRecordA, caseRecordB, caseRecordC, caseRecordZ});

		// WHEN we request the relation between Case and Account
		System.Test.startTest();
		Map<Id, Set<Id>> result = accountDomain.getChildIdsById(
				new List<fflib_SObjects2>
				{
						contactDomain,
						caseDomain
				}
		);
		System.Test.stopTest();

		// THEN it should return the AccountId By CaseId
		System.Assert.areEqual(1, result.size(), 'Expected one account');
		System.Assert.isTrue(result.containsKey(accountId), 'Account Id should be the main key');
		System.Assert.areEqual(2, result.get(accountId).size(), 'Incorrect amount of related cases to the account');
		System.Assert.isTrue(result.get(accountId).containsAll(new Set<Id>{ caseIdA, caseIdZ }));
	}
	@IsTest
	static void itShouldReturnTheRelatedChildDomainId()
	{
		// GIVEN a case A & Z related to contact A related to Account,
		Id caseIdA = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdZ = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdB = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdC = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Account accountRecord = new Account(Id = accountId);
		Contact contactRecordA = new Contact(Id = contactIdA, AccountId = accountId);
		Contact contactRecordB = new Contact(Id = contactIdB);
		Case caseRecordA = new Case(Id = caseIdA, ContactId = contactIdA);
		Case caseRecordZ = new Case(Id = caseIdZ, ContactId = contactIdA);
		Case caseRecordB = new Case(Id = caseIdB, ContactId = contactIdB);
		Case caseRecordC = new Case(Id = caseIdC);

		DomainAccounts accountDomain = new DomainAccounts(new List<Account> {accountRecord});
		DomainContacts contactDomain = new DomainContacts(new List<Contact> {contactRecordA, contactRecordB});
		DomainCases caseDomain = new DomainCases(new List<Case> {caseRecordA, caseRecordB, caseRecordC, caseRecordZ});

		// WHEN we request the relation between Case and Account
		System.Test.startTest();
		Map<Id, Set<Id>> result = accountDomain.getChildIdsById(
				new Map<Schema.SObjectField, fflib_SObjects2>
				{
						Contact.AccountId => contactDomain,
						Case.ContactId => caseDomain
				}
		);
		System.Test.stopTest();

		// THEN it should return the AccountId By CaseId
		System.Assert.areEqual(1, result.size(), 'Expected one account');
		System.Assert.isTrue(result.containsKey(accountId), 'Account Id should be the main key');
		System.Assert.areEqual(2, result.get(accountId).size(), 'Incorrect amount of related cases to the account');
		System.Assert.isTrue(result.get(accountId).containsAll(new Set<Id>{ caseIdA, caseIdZ }));
	}

	@IsTest
	static void itShouldReturnTheRelatedParentDomainId()
	{
		// GIVEN a case related to contact related to Account ,
		//   a case record related to contact but not to Account,
		//   and a case record related to nothing.
		//   All encapsulated in domains.
		Id caseIdA = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdB = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdC = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Account accountRecord = new Account(Id = accountId);
		Contact contactRecordA = new Contact(Id = contactIdA, AccountId = accountId);
		Contact contactRecordB = new Contact(Id = contactIdB);
		Case caseRecordA = new Case(Id = caseIdA, ContactId = contactIdA);
		Case caseRecordB = new Case(Id = caseIdB, ContactId = contactIdB);
		Case caseRecordC = new Case(Id = caseIdC);

		DomainAccounts accountDomain = new DomainAccounts(new List<Account> {accountRecord});
		DomainContacts contactDomain = new DomainContacts(new List<Contact> {contactRecordA, contactRecordB});
		DomainCases caseDomain = new DomainCases(new List<Case> {caseRecordA, caseRecordB, caseRecordC});

		// WHEN we request the relation between Case and Account
		System.Test.startTest();
		Map<Id, Id> result = caseDomain.getParentIdById(
				new Map<Schema.SObjectField, fflib_SObjects2>
				{
						Schema.Case.ContactId => contactDomain,
						Schema.Contact.AccountId => accountDomain
				}
		);
		System.Test.stopTest();

		// THEN it should return the AccountId By CaseId
		System.Assert.areEqual(3, result.size(), 'Expected one related account to the case');
		System.Assert.isTrue(result.containsKey(caseIdA));
		System.Assert.isTrue(result.containsKey(caseIdB));
		System.Assert.isTrue(result.containsKey(caseIdC));
		System.Assert.areEqual(accountId, result.get(caseIdA), 'Account Id should be related to the Case Id A');
		System.Assert.isNull(result.get(caseIdB), 'Case Id B should have no related Account Id');
		System.Assert.isNull(result.get(caseIdC), 'Case Id B should have no related Account Id');
	}

	/** Unit test for the deprecated method **/
	@IsTest
	static void itShouldReturnTheRelatedParentDomainId_deprecated()
	{
		// GIVEN a case related to contact related to Account ,
		//   a case record related to contact but not to Account,
		//   and a case record related to nothing.
		//   All encapsulated in domains.
		Id caseIdA = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdB = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id caseIdC = fflib_IDGenerator.generate(Schema.Case.SObjectType);
		Id contactIdA = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id contactIdB = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Account accountRecord = new Account(Id = accountId);
		Contact contactRecordA = new Contact(Id = contactIdA, AccountId = accountId);
		Contact contactRecordB = new Contact(Id = contactIdB);
		Case caseRecordA = new Case(Id = caseIdA, ContactId = contactIdA);
		Case caseRecordB = new Case(Id = caseIdB, ContactId = contactIdB);
		Case caseRecordC = new Case(Id = caseIdC);

		DomainAccounts accountDomain = new DomainAccounts(new List<Account> {accountRecord});
		DomainContacts contactDomain = new DomainContacts(new List<Contact> {contactRecordA, contactRecordB});
		DomainCases caseDomain = new DomainCases(new List<Case> {caseRecordA, caseRecordB, caseRecordC});

		// WHEN we request the relation between Case and Account
		System.Test.startTest();
		Map<Id, Id> result = caseDomain.getGrandParentIdById(
				new List<fflib_SObjects2>
				{
						contactDomain,
						accountDomain
				}
		);
		System.Test.stopTest();

		// THEN it should return the AccountId By CaseId
		System.Assert.areEqual(3, result.size(), 'Expected one related account to the case');
		System.Assert.isTrue(result.containsKey(caseIdA));
		System.Assert.isTrue(result.containsKey(caseIdB));
		System.Assert.isTrue(result.containsKey(caseIdC));
		System.Assert.areEqual(accountId, result.get(caseIdA), 'Account Id should be related to the Case Id A');
		System.Assert.isNull(result.get(caseIdB), 'Case Id B should have no related Account Id');
		System.Assert.isNull(result.get(caseIdC), 'Case Id B should have no related Account Id');
	}

	@IsTest
	static void itShouldReturnDecimalById() {
		final Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		final Account record = new Account(Id = accountId, AnnualRevenue = 123.45);
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Account>{ record });
		System.Test.startTest();
		Map<Id, Decimal> result = domain.getDecimalById(Schema.Account.AnnualRevenue, Schema.Account.Id);
		System.Test.stopTest();
	}

	@IsTest
	static void itShouldReturnStringById()
	{
		final String accountName = 'My Account';
		final Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		final Account record = new Account(Id = accountId, Name = accountName);
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Account>{ record });
		System.Test.startTest();
		Map<String, Id> nameById = domain.getIdFieldByStringField(Schema.Account.Id, Schema.Account.Name);
		System.Test.stopTest();
		System.Assert.isTrue(nameById.containsKey(accountName));
		System.Assert.areEqual(accountId, nameById.get(accountName));
	}

	@IsTest
	static void itShouldReturnStringFieldByIdField()
	{
		final String accountName = 'My Account';
		final Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Id = accountId, Name = accountName),
						new Account(Name = accountName + ' 2')              // This one should be ignored
				});

		System.Test.startTest();
		Map<Id, String> result = domain.getStringFieldByIdField(Account.Name, Account.Id);
		System.Test.stopTest();

		System.Assert.areEqual(1, result.size(), 'Incorrect returned amount of results');
		System.Assert.isTrue(result.keySet().contains(accountId), 'The accountId is missing from the results');
		System.Assert.areEqual(accountName, result.get(accountId), 'Incorrect returned account name');
	}

	@IsTest
	static void itShouldReturnDateFieldByIdField()
	{
		final Date today = Date.today();
		final Datetime todayDatetime = Datetime.newInstance(today.year(), today.month(), today.day());
		final String accountName = 'My Account';
		final Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						(Account) fflib_MockSObjectUtil.addFieldValue(new Account(Id = accountId), Account.CreatedDate, todayDatetime),
						new Account(Name = accountName + ' 2')              // This one should be ignored
				});

		System.Test.startTest();
		Map<Id, Date> result = domain.getDateFieldByIdField(Account.CreatedDate, Account.Id);
		System.Test.stopTest();

		System.Assert.areEqual(1, result.size(), 'Incorrect returned amount of results');
		System.Assert.istrue(result.keySet().contains(accountId), 'The accountId is missing from the results');
		System.Assert.areEqual(today, result.get(accountId), 'Incorrect returned date');
	}

	@IsTest
	static void itShouldReturnIntegerFieldValues()
	{
		final Integer numberOfEmployees = 10;
		final String accountName = 'Test Account';
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(NumberOfEmployees = numberOfEmployees),
						new Account(Name = accountName, NumberOfEmployees = numberOfEmployees * 2),
						new Account()              // This one should be ignored
				});

		System.Test.startTest();
		Set<Integer> result = domain.getIntegerFieldValues(Account.NumberOfEmployees).getIntegerSet();
		Set<Integer> result2 =
				domain.getIntegerFieldValues(
						Account.NumberOfEmployees,
						new fflib_Criteria().equalTo(Schema.Account.Name, accountName)
				)
						.getIntegerSet();
		System.Test.stopTest();

		System.Assert.areEqual(2, result.size(), 'Incorrect amount of results');
		System.Assert.istrue(result.contains(numberOfEmployees), 'The expected numberOfEmployees was not returned');
		System.Assert.istrue(result.contains(numberOfEmployees * 2), 'The expected numberOfEmployees was not returned');

		System.Assert.areEqual(1, result2.size(), 'Incorrect amount of results');
		System.Assert.istrue(result2.contains(numberOfEmployees * 2), 'The expected numberOfEmployees was not returned');
	}

	@IsTest
	static void itShouldReturnLongFieldValues()
	{
		final Integer numberOfEmployees = 10;
		final String accountName = 'Test Account';
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(NumberOfEmployees = numberOfEmployees),
						new Account(Name = accountName, NumberOfEmployees = numberOfEmployees * 2),
						new Account()              // This one should be ignored
				});

		System.Test.startTest();
		Set<Long> result = domain.getLongFieldValues(Account.NumberOfEmployees).getLongSet();
		Set<Long> result2 =
				domain.getLongFieldValues(
						Account.NumberOfEmployees,
						new fflib_Criteria().equalTo(Schema.Account.Name, accountName)
				)
						.getLongSet();
		System.Test.stopTest();

		System.Assert.areEqual(2, result.size(), 'Incorrect amount of results');
		System.Assert.istrue(result.contains(numberOfEmployees), 'The expected numberOfEmployees was not returned');
		System.Assert.istrue(result.contains(numberOfEmployees * 2), 'The expected numberOfEmployees was not returned');

		System.Assert.areEqual(1, result2.size(), 'Incorrect amount of results');
		System.Assert.istrue(result2.contains(numberOfEmployees * 2), 'The expected numberOfEmployees was not returned');
	}

	@IsTest
	static void itShouldReturnRecordIdById()
	{
		final Id contactId = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		final Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		final Contact record = new Contact(Id = contactId, AccountId = accountId);
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Contact>{ record });
		System.Test.startTest();
		Map<Id, Id> accountIdByContactId = domain.getIdFieldByIdField(Schema.Contact.AccountId, Schema.Contact.Id);
		System.Test.stopTest();
		System.Assert.istrue(accountIdByContactId.containsKey(contactId));
		System.Assert.areEqual(accountId, accountIdByContactId.get(contactId));
	}

	@IsTest
	static void itShouldReturnRecordByIds()
	{
		SObjectType accountSObjectType = Schema.Account.SObjectType;
		final Id idA = fflib_IDGenerator.generate(accountSObjectType);
		final Id idB = fflib_IDGenerator.generate(accountSObjectType);
		final Id idC = fflib_IDGenerator.generate(accountSObjectType);

		DomainAccounts domain = new DomainAccounts(
				new List<SObject>
				{
						new Account(Id = idA),
						new Account(Id = idB),
						new Account(Id = idC)
				}
		);

		Set<Id> recordIds = new Set<Id> {idA, idB, idC};
		System.Assert.istrue(
				domain.getSObjectById().keySet().containsAll(recordIds),
				'The domain should return all the record Ids'
		);
	}


	@IsTest
	static void itShouldReturnRecordsIds()
	{
		SObjectType accountSObjectType = Schema.Account.SObjectType;
		Id idA = fflib_IDGenerator.generate(accountSObjectType);
		Id idB = fflib_IDGenerator.generate(accountSObjectType);
		Id idC = fflib_IDGenerator.generate(accountSObjectType);

		DomainAccounts domain = new DomainAccounts(
				new List<SObject>
				{
						new Account(Id = idA),
						new Account(Id = idB),
						new Account(Id = idC)
				}
		);

		Set<Id> recordIds = new Set<Id> {idA, idB, idC};
		System.Assert.istrue(
				domain.getRecordIds().containsAll(recordIds),
				'The domain should return all the record Ids'
		);
	}

	@IsTest
	static void itShouldReturnRecords()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(6, domain.getRecords().size());
	}

	@IsTest
	static void itShouldReturnRecordByCriteria()
	{
		final Id idA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Name = 'A', Id = idA),
						new Account(Name = 'B', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType))
				});

		System.Assert.areEqual(
				'A',
				domain.getRecords(
						new fflib_Criteria()
								.equalTo(Schema.Account.Id, idA)
				)
						.get(0)
						.get('Name')
		);
	}

	@IsTest
	static void itShouldReturnRecordById()
	{
		final Id idA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Name = 'A', Id = idA),
						new Account(Name = 'B', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType))
				});

		System.Assert.areEqual('A', domain.getRecord(idA).get('Name'));
	}

	@IsTest
	static void itShouldReturnRecordsById()
	{
		final Id idA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		final fflib_Ids ids = new fflib_Ids(new Set<Id> {idA});
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Name = 'A', Id = idA),
						new Account(Name = 'B', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType))
				});

		System.Assert.areEqual('A', domain.getRecords(ids).get(0).get('Name'));
	}

	@IsTest
	static void itShouldReturnRecordsByIds()
	{
		final Id idA = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Name = 'A', Id = idA),
						new Account(Name = 'B', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType))
				});

		System.Assert.areEqual('A', domain.getRecords(new Set<Id> {idA}).get(0).get('Name'));
	}

	@IsTest
	static void itShouldReturnRecordsWithFieldValues()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(1, domain.selectByShippingCountry('USA').size());
	}

	@IsTest
	static void itShouldReturnRecordsWithoutFieldValues()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(3, domain.selectWithoutShippingCountry().size());
	}

	@IsTest
	static void itShouldReturnRecordsWithoutAllFieldValues()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(1, domain.selectWithEmptyRecord().size());
	}

	@IsTest
	static void itShouldReturnRecordsWithShippingCountry()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(3, domain.selectWithShippingCountry().size());
	}

	@IsTest
	static void itShouldReturnRecordsWithAllFieldValues()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.areEqual(3, domain.selectPopulatedRecords().size());
	}

	@IsTest
	static void itShouldReturnFieldValues()
	{
		DomainAccounts domain = generateDomain();

		System.Assert.istrue(
				domain.getStringFieldValues(Schema.Account.ShippingCountry)
						.containsAll(
						new Set<String>
						{
								'USA',
								'Ireland',
								'UK',
								''
						}
				)
		);
	}

	@IsTest
	static void itShouldSetFieldValue()
	{
		DomainAccounts domain = generateDomain();
		String country = 'Holland';
		domain.setShippingCountry(country);

		System.Assert.areEqual(6, domain.selectByShippingCountry(country).size());
	}

	@IsTest
	static void itShouldSetFieldValueByCondition()
	{
		DomainAccounts domain = generateDomain();
		domain.setRatingByShippingCountry(
				new Map<Object, Object>
				{
						'USA' => 'Hot'
				}
		);

		System.Assert.areEqual(1, domain.selectByRating('Hot').size());
	}

	@IsTest
	static void itShouldGetTheSumOfAnnualRevenue()
	{
		DomainAccounts domain = generateDomain();
		System.Assert.areEqual(11, domain.getDecimalFieldSum(Account.AnnualRevenue));
		System.Assert.isTrue(domain.getDecimalFieldValues(Account.AnnualRevenue).contains((Decimal) 5));
	}

	@IsTest
	static void itShouldSetFieldByIdField()
	{
		Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
		Account record = new Account(Id = accountId, Name = '');
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Account>{ record });

		domain.setFieldValue(
				Schema.Account.Id,
				Schema.Account.Name,
				new Map<Id, String>
				{
						accountId => 'Hello'
				}
		);

		System.Assert.areEqual('Hello', domain.getFirstSObject().get('Name'));
	}

	@IsTest
	static void itShouldSetFieldByStringField()
	{
		Account record = new Account(Name = 'Hello', Rating = 'Cold');
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Account>{ record });

		domain.setFieldValue(
				Schema.Account.Name,
				Schema.Account.Rating,
				new Map<String, String>
				{
						'Hello' => 'Warm'
				}
		);

		System.Assert.areEqual('Warm', domain.getFirstSObject().get('Rating'));
	}

	@IsTest
	static void itShouldSetField()
	{
		Account record = new Account(Name = 'Hello', Rating = 'Cold');
		fflib_SObjects2 domain = new fflib_SObjects2(new List<Account>{ record });

		domain.setFieldValue(Account.Name, 'Hello World', new fflib_Criteria().equalTo(Account.Rating, 'Cold'));

		System.Assert.areEqual('Hello World', domain.getFirstSObject().get('Name'));
	}

	private static DomainAccounts generateDomain()
	{
		DomainAccounts domain = new DomainAccounts(
				new List<Account>
				{
						new Account(Name = 'A', ShippingCountry = 'USA', AnnualRevenue = 5),
						new Account(Name = 'B', ShippingCountry = 'Ireland', AnnualRevenue = 3),
						new Account(Name = 'C', ShippingCountry = 'UK', AnnualRevenue = 2),
						new Account(Name = 'D', ShippingCountry = '', AnnualRevenue = 1),
						new Account(Name = 'E'),
						new Account()
				}
		);
		return domain;
	}


	private class DomainAccounts extends fflib_SObjects2
	{
		public DomainAccounts(List<SObject> records)
		{
			super(records, Schema.Account.SObjectType);
		}

		public List<Account> selectByShippingCountry(String country)
		{
			return (List<Account>) getRecordsByFieldValues(
					Schema.Account.ShippingCountry,
					new Set<Object> {country}
			);
		}

		public List<Account> selectByRating(String rating)
		{
			return (List<Account>) getRecordsByFieldValue(
					Schema.Account.Rating,
					rating
			);
		}

		public List<Account> selectWithoutShippingCountry()
		{
			return (List<Account>) getRecordsWithBlankFieldValues(
					Schema.Account.ShippingCountry
			);
		}

		public List<Account> selectWithShippingCountry()
		{
			return (List<Account>) getRecordsWithNotBlankFieldValues(
					Schema.Account.ShippingCountry
			);
		}

		public List<Account> selectWithEmptyRecord()
		{
			return (List<Account>) getRecordsWithAllBlankFieldValues(
					new Set<Schema.SObjectField>
					{
							Schema.Account.Name,
							Schema.Account.ShippingCountry
					}
			);
		}

		public List<Account> selectPopulatedRecords()
		{
			return (List<Account>) getRecordsWithAllNotBlankFieldValues(
					new Set<Schema.SObjectField>
					{
							Schema.Account.Name,
							Schema.Account.ShippingCountry
					}
			);
		}

		public void setShippingCountry(String country)
		{
			setFieldValue(Schema.Account.ShippingCountry, country);
		}

		public void setRatingByShippingCountry(Map<Object, Object> ratingByCountry)
		{
			setFieldValueByMap(
					Schema.Account.ShippingCountry,
					Schema.Account.Rating,
					ratingByCountry);
		}

		public void addNameError(String message)
		{
			addError(Schema.Account.Name, message);
		}

		public void clearShippingCountry()
		{
			clearField(Schema.Account.ShippingCountry);
		}

		protected override Map<SObjectType, Schema.SObjectField> getRelatedFieldByDomainType()
		{
			return new Map<SObjectType, Schema.SObjectField>
			{
					Schema.Contact.SObjectType => Contact.AccountId
			};
		}
	}

	private class DomainContacts extends fflib_SObjects2
	{
		public DomainContacts(List<SObject> records)
		{
			super(records, Schema.Contact.SObjectType);
		}

		protected override Map<SObjectType, Schema.SObjectField> getRelatedFieldByDomainType()
		{
			return new Map<SObjectType, Schema.SObjectField>
			{
					Schema.Account.SObjectType => Contact.AccountId,
					Schema.Case.SObjectType => Case.ContactId
			};
		}
	}

	private class DomainCases extends fflib_SObjects2
	{
		public DomainCases(List<SObject> records)
		{
			super(records, Schema.Case.SObjectType);
		}

		protected override Map<SObjectType, Schema.SObjectField> getRelatedFieldByDomainType()
		{
			return new Map<SObjectType, Schema.SObjectField>
			{
					Schema.Contact.SObjectType => Case.ContactId
			};
		}
	}
}
