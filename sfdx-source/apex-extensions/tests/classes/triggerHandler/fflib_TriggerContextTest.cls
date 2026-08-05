/**
 * File Name: fflib_TriggerContextTest
 *
 * Test class for fflib_TriggerContext
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
private class fflib_TriggerContextTest
{
	@IsTest
	static void testBehavior()
	{
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Account existing = new Account(Id = accountId, Name = 'Existing Account');
		Account updated = new Account(Id = accountId, Name = 'Updated Account');

		System.Test.startTest();
		fflib_TriggerContext ctx = new fflib_TriggerContext(new List<Account> {updated});
		ctx.existingRecords = new Map<Id, SObject> {accountId => existing};
		ctx.triggerOperation = TriggerOperation.BEFORE_INSERT;
		ctx.registerSObjectType(Schema.Account.SObjectType);
		ctx.initializeUnitOfWork();
		ctx.commitWork();
		System.Test.stopTest();

		System.Assert.isTrue(ctx.getChangedFields().contains('Name'), 'Expected Name field to be changed');
		System.Assert.areEqual(1, ctx.getChangedRecords('Name').size());
		System.Assert.areEqual(1, ctx.getChangedRecords(Schema.Account.Name).size());
		System.Assert.isTrue(ctx.getExistingRecords().containsKey(accountId));
		System.Assert.isTrue(ctx.isBefore());
		System.Assert.isTrue(ctx.isInsert());
		System.Assert.areEqual(TriggerOperation.BEFORE_INSERT, ctx.getTriggerOperation());
	}

	@IsTest
	static void testRelatedBehavior()
	{
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Id contactId = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		Contact record = new Contact(Id = contactId, AccountId = accountId, LastName = 'Smith');

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_MultiSObjectsSelector selectorMock = (fflib_MultiSObjectsSelector) mocks.mock(fflib_MultiSObjectsSelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.query()).thenReturn(
				new Map<SObjectType, List<SObject>> {
						Schema.Account.SObjectType => new List<SObject>{
								new Account(Id = accountId)
						},
						Schema.Case.SObjectType => new List<SObject>{
								new Case(ContactId = contactId)
						}
				}
		);
		mocks.stopStubbing();
		fflib_MultiSObjectsSelector.replaceWith(selectorMock);

		System.Test.startTest();
		fflib_TriggerContext ctx = new fflib_TriggerContext(new List<Contact> {record});
		ctx.triggerOperation = TriggerOperation.AFTER_UPDATE;
		ctx.interestedIn(Schema.Contact.AccountId, new Set<SObjectField> {Schema.Account.Name});
		ctx.interestedIn('Cases', new Set<SObjectField> {Schema.Case.Subject});
		ctx.interestedIn(
				Schema.User.SObjectType,
				Schema.User.Id,
				new Set<Id> {UserInfo.getUserId()},
				new Set<SObjectField> {Schema.User.LastName});
		ctx.fetchRelated();
		System.Test.stopTest();

		System.Assert.areEqual(1, ctx.getRelated(Schema.Account.SObjectType).size(), 'Expected one Account record');
		System.Assert.areEqual(1, ctx.getRelated(Schema.Case.SObjectType).size(), 'Expected one Case record');
		System.Assert.isTrue(ctx.isAfter());
		System.Assert.isTrue(ctx.isUpdate());

		// Parent relationship
		((fflib_MultiSObjectsSelector) mocks.verify(selectorMock, 1))
				.registerQuery(
						Schema.Account.SObjectType,
						new Set<SObjectField> {Schema.Account.Name},
						Schema.Account.Id,
						new Set<Id> {accountId}
				);

		// Child relationship
		((fflib_MultiSObjectsSelector) mocks.verify(selectorMock, 1))
				.registerQuery(
						Schema.Case.SObjectType,
						new Set<SObjectField> {Schema.Case.Subject},
						Schema.Case.ContactId,
						new Set<Id> {contactId}
				);

		// Unrelated relationship
		((fflib_MultiSObjectsSelector) mocks.verify(selectorMock, 1))
				.registerQuery(
						Schema.User.SObjectType,
						new Set<SObjectField> {Schema.User.LastName},
						Schema.User.Id,
						new Set<Id> {UserInfo.getUserId()}
				);

		((fflib_MultiSObjectsSelector) mocks.verify(selectorMock, 1)).query();
		ctx.clearRelated();
		System.Assert.areEqual(0, ctx.getRelated(Schema.Account.SObjectType).size(), 'Expected no Account records');
		System.Assert.areEqual(0, ctx.getRelated(Schema.Case.SObjectType).size(), 'Expected no Case records');
	}
}