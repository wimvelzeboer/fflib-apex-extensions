/**
 * File Name: fflib_SObjectFactoryTest
 * @description Unit test class for fflib_SObjectFactory
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
@IsTest
private class fflib_SObjectFactoryTest
{
	@IsTest
	static void itShouldGenerateContactRecords()
	{
		// GIVEN a set of Ids
		final Set<Id> ids = new Set<Id>
		{
				fflib_IDGenerator.generate(Schema.Contact.SObjectType),
				fflib_IDGenerator.generate(Schema.Contact.SObjectType),
				fflib_IDGenerator.generate(Schema.Contact.SObjectType)
		};

		// WHEN we generate Contact records
		List<Contact> result = (List<Contact>) new ContactsFactory().generateById(ids);

		// THEN there should be three Contact records
		System.Assert.areEqual(3, result.size(), 'Not enough records created');
		System.Assert.isTrue(new Map<Id, Contact>(result).keySet().containsAll(ids), 'Records should contain the given ids');
	}

	@IsTest
	static void itShouldGenerateContactRecordsWithAccountId()
	{
		// GIVEN a set of Ids
		final Set<Id> ids = new Set<Id>
		{
				fflib_IDGenerator.generate(Schema.Account.SObjectType),
				fflib_IDGenerator.generate(Schema.Account.SObjectType),
				fflib_IDGenerator.generate(Schema.Account.SObjectType)
		};

		// WHEN we generate Contact records
		List<Contact> result = (List<Contact>) new ContactsFactory().generateByAccountId(ids);

		// THEN there should be three Contact records
		System.Assert.areEqual(3, result.size(), 'Not enough records created');
		Set<Id> accountIds = new Set<Id>();
		for (Contact record : result) accountIds.add(record.AccountId);
		System.Assert.isTrue(accountIds.containsAll(ids), 'Records should contain the given ids');
	}

	private class ContactsFactory extends fflib_SObjectFactory
	{
		public List<Contact> generateById(Set<Id> ContactIds)
		{
			return (List<Contact>) generateSObjectById(ContactIds);
		}

		public List<Contact> generateByAccountId(Set<Id> ContactIds)
		{
			return (List<Contact>) generateSObjectByIdField(Schema.Contact.AccountId, ContactIds);
		}

		public SObjectType getSObjectType()
		{
			return Schema.Contact.SObjectType;
		}
	}
}