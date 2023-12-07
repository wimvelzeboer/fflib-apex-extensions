@IsTest(IsParallel=true)
private class fflib_SObjectTriggerHandlerTest
{
	@IsTest
	static void testNewRecords()
	{
		Account record = new Account(Name = 'Account');
		List<Account> records = new List<Account> {record};
		fflib_SObjectTriggerHandler handler = new fflib_SObjectTriggerHandler(records);
		System.Assert.areEqual(0, handler.getChangedRecords('Name').size());
	}

	@IsTest
	static void testUpdateRecords()
	{
		Account record = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Account');
		Account existingRecord = new Account(
				Id = record.Id,
				Name = '');

		List<Account> records = new List<Account> {record};
		fflib_SObjectTriggerHandler handler = new fflib_SObjectTriggerHandler(records, Schema.Account.SObjectType);
		handler.ExistingRecords = new Map<Id, SObject>{ record.Id => existingRecord};
		System.Assert.areEqual(1, handler.getChangedRecords(Schema.Account.Name).size());
	}
}