/**
 * File Name: fflib_TriggerHandlerTest
 * Description: Unit Test class for fflib_TriggerHandler implementation
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
private class fflib_TriggerHandlerTest
{
	private static Boolean handlerGotInvoked = false;
	@IsTest
	static void testBehavior()
	{
		// GIVEN a set of records with a configured trigger handler

		fflib_LogEntry__c record = new fflib_LogEntry__c(LogLevel__c = 'INFO', Message__c = 'Unit Test');
		List<fflib_LogEntry__c> records = new List<fflib_LogEntry__c> {record};

		fflib_TriggerAction__mdt triggerAction = new fflib_TriggerAction__mdt(
				ObjectType__c = null,
				ObjectTypeAlternate__c = Schema.fflib_LogEntry__c.SObjectType.getDescribe().getName(),
				BeforeInsert__c = true,
				ImplementationType__c = 'fflib_TriggerHandlerTest.MyTriggerAction',
				ExecutionContext__c = 'Realtime'
		);

		fflib_TriggerHandler triggerHandler = new fflib_TriggerHandler();
		String ctxClassName = triggerHandler.triggerContextType.getName() + '.Constructor';
		fflib_TriggerContext ctx =
				(fflib_TriggerContext)
						((fflib_IDomainConstructor) Type.forName(ctxClassName).newInstance())
								.construct(new List<fflib_LogEntry__c> {record});
		ctx.triggerOperation = System.TriggerOperation.BEFORE_INSERT;

		// WHEN a record is inserted
		System.Test.startTest();
		triggerHandler.loadConfiguration();
		triggerHandler.addTriggerActionConfig(triggerAction);
		triggerHandler
				.setTriggerContextType(fflib_TriggerContext.class)
				.setTriggerContext(ctx)
				.run();
		System.Test.stopTest();

		// THEN the trigger handler should be invoked
		System.Assert.isTrue(handlerGotInvoked, 'Whoops, the Trigger Action was not invoked');
		System.Assert.areEqual(records, ctx.records);
		System.Assert.isTrue(ctx.isInsert());
		System.Assert.isTrue(ctx.isBefore());
		System.Assert.isFalse(ctx.isDelete());
		System.Assert.isFalse(ctx.isUndelete());
	}

	@IsTest
	private static void itShouldReturnTheChangedRecordsBySObjectFields()
	{
		// GIVEN a domain with old and changed records

		Id idLuke = fflib_IDGenerator.generate(Account.SObjectType);
		Id idHan = fflib_IDGenerator.generate(Account.SObjectType);
		Id idLeia = fflib_IDGenerator.generate(Account.SObjectType);
		List<Account> oldRecords = new List<Account>
		{
				new Account(Id = idLuke, Name = 'Luke', Description = 'Jedi'),
				new Account(Id = idHan, Name = 'Han', Description = 'Pilot'),
				new Account(Id = idLeia, Name = 'Leia')
		};

		List<Account> newRecords = oldRecords.deepClone(true, true, true);
		newRecords.get(0).Name = 'Luke SkyWalker';
		newRecords.get(0).Description = 'Jedi Master';
		newRecords.get(1).Name = 'Han Solo';

		fflib_TriggerContext ctx = new fflib_TriggerContext(newRecords);
		ctx.existingRecords = new Map<Id, SObject>(oldRecords);

		// WHEN we create a domain with ExistingRecords and request the changed records
		List<SObject> result = ctx.getChangedRecords(Account.Name);

		// THEN it should only return the changed records
		Map<Id, SObject> resultMap = new Map<Id, SObject>(result);
		System.Assert.areEqual(2, result.size());
		System.Assert.istrue(resultMap.containsKey(idLuke));
		System.Assert.istrue(resultMap.containsKey(idHan));
	}

	@IsTest
	private static void itShouldReturnTheChangedRecordsByStringFields()
	{
		// GIVEN a domain with old and changed records

		Id idLuke = fflib_IDGenerator.generate(Account.SObjectType);
		Id idHan = fflib_IDGenerator.generate(Account.SObjectType);
		Id idLeia = fflib_IDGenerator.generate(Account.SObjectType);
		List<Account> oldRecords = new List<Account>
		{
				new Account(Id = idLuke, Name = 'Luke', Description = 'Jedi'),
				new Account(Id = idHan, Name = 'Han', Description = 'Pilot'),
				new Account(Id = idLeia, Name = 'Leia')
		};

		List<Account> newRecords = oldRecords.deepClone(true, true, true);
		newRecords.get(0).Name = 'Luke SkyWalker';
		newRecords.get(0).Description = 'Jedi Master';
		newRecords.get(1).Name = 'Han Solo';

		fflib_TriggerContext ctx = new fflib_TriggerContext(newRecords);
		ctx.existingRecords = new Map<Id, SObject>(oldRecords);

		// WHEN we create a domain with ExistingRecords and request the changed records
		List<SObject> result = ctx.getChangedRecords('Description');

		// THEN it should only return the changed records
		Map<Id, SObject> resultMap = new Map<Id, SObject>(result);
		System.Assert.areEqual(1, result.size());
		System.Assert.istrue(resultMap.containsKey(idLuke));
	}

	@IsTest
	private static void itShouldCallTriggerActionOnAfterDelete()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.AFTER_DELETE;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isAfter());
		System.Assert.istrue(ctx.isDelete());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnAfterInsert()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.AFTER_INSERT;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isAfter());
		System.Assert.istrue(ctx.isInsert());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnAfterUndelete()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.AFTER_UNDELETE;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isAfter());
		System.Assert.istrue(ctx.isUndelete());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnAfterUpdate()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.AFTER_UPDATE;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isAfter());
		System.Assert.istrue(ctx.isUpdate());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnBeforeDelete()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.BEFORE_DELETE;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isBefore());
		System.Assert.istrue(ctx.isDelete());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnBeforeInsert()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.BEFORE_INSERT;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isBefore());
		System.Assert.istrue(ctx.isInsert());
	}

	@IsTest
	private static void itShouldCallTriggerActionOnBeforeUpdate()
	{
		List<Account> records = new List<Account>
		{
				new Account(Id = fflib_IDGenerator.generate(Account.SObjectType))
		};

		fflib_TriggerContext ctx = new fflib_TriggerContext(records);
		ctx.triggerOperation = System.TriggerOperation.BEFORE_UPDATE;
		new MyTriggerAction().setContext(ctx).doWork();

		System.Assert.istrue(ctx.isBefore());
		System.Assert.istrue(ctx.isUpdate());
	}

	@IsTest
	private static void itShouldUseTheStatefulTriggerActionClass()
	{
		fflib_LogEntry__c record = new fflib_LogEntry__c(LogLevel__c = 'INFO', Message__c = 'Unit Test');
		List<fflib_LogEntry__c> records = new List<fflib_LogEntry__c> {record};

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ITriggerAction triggerActionMock = (fflib_ITriggerAction) mocks.mock(fflib_ITriggerAction.class);

		mocks.startStubbing();
		mocks.when(triggerActionMock.isQueueable()).thenReturn(false);
		mocks.when(triggerActionMock.isNotQueueable()).thenReturn(true);
		mocks.stopStubbing();

		fflib_TriggerHandler.triggerActionStateByClass =
				new Map<Type, fflib_ITriggerAction>{ MyTriggerAction.class => triggerActionMock };

		fflib_TriggerAction__mdt triggerAction = new fflib_TriggerAction__mdt(
				ObjectType__c = null,
				ObjectTypeAlternate__c = Schema.fflib_LogEntry__c.SObjectType.getDescribe().getName(),
				BeforeInsert__c = true,
				ImplementationType__c = 'fflib_TriggerHandlerTest.MyTriggerAction',
				ExecutionContext__c = 'Realtime',
				Stateful__c = true
		);

		fflib_TriggerHandler triggerHandler = new fflib_TriggerHandler();
		String ctxClassName = triggerHandler.triggerContextType.getName() + '.Constructor';
		fflib_TriggerContext ctx =
				(fflib_TriggerContext)
						((fflib_IDomainConstructor) Type.forName(ctxClassName).newInstance())
								.construct(new List<fflib_LogEntry__c> {record});
		ctx.triggerOperation = System.TriggerOperation.BEFORE_INSERT;

		// WHEN a record is inserted
		System.Test.startTest();
		triggerHandler.addTriggerActionConfig(triggerAction);
		triggerHandler.setTriggerContext(ctx).run();
		System.Test.stopTest();

		// THEN the stateful trigger action should be re-used
		((fflib_ITriggerAction)	mocks.verify(triggerActionMock)).doWork();
	}

	public class MyTriggerAction extends fflib_TriggerAction // Todo - rename handler to action
	{
		public override void onBeforeInsert()
		{
			fflib_TriggerHandlerTest.handlerGotInvoked = true;

			List<SObject> records = triggerContext.getRecords();
		}
	}
}