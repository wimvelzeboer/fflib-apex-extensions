@IsTest(IsParallel=true)
private class fflib_SObjectShareTest
{
	@IsTest
	static void testEditShareCreation_single()
	{
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Id groupId = fflib_IDGenerator.generate(Schema.Group.SObjectType);
		SObject editShare = fflib_SObjectShare.createEditShare(Schema.Account.SObjectType, accountId, groupId);
		System.Assert.areEqual(accountId, editShare.get('AccountId'));
		System.Assert.areEqual(groupId, editShare.get('UserOrGroupId'));
		System.Assert.areEqual('Edit', editShare.get('AccountAccessLevel'));
		System.Assert.areEqual('Manual', editShare.get('RowCause'));
	}

	@IsTest
	static void testReadShareCreation_single()
	{
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Id groupId = fflib_IDGenerator.generate(Schema.Group.SObjectType);
		SObject editShare = fflib_SObjectShare.createReadShare(Schema.Account.SObjectType, accountId, groupId);
		System.Assert.areEqual(accountId, editShare.get('AccountId'));
		System.Assert.areEqual(groupId, editShare.get('UserOrGroupId'));
		System.Assert.areEqual('Read', editShare.get('AccountAccessLevel'));
		System.Assert.areEqual('Manual', editShare.get('RowCause'));
	}

	@IsTest
	static void testAccessLevelField()
	{
		System.Assert.areEqual(
				Schema.AccountShare.AccountAccessLevel,
				fflib_SObjectShare.getAccessLevelField(Schema.AccountShare.SObjectType));
	}

	@IsTest
	static void testParentIdField()
	{
		System.Assert.areEqual(
				Schema.AccountShare.AccountId,
				fflib_SObjectShare.getParentIdField(Schema.AccountShare.SObjectType));
	}

	@IsTest
	static void testRowClauseField()
	{
		System.Assert.areEqual(
				Schema.AccountShare.RowCause,
				fflib_SObjectShare.getRowCauseField(Schema.AccountShare.SObjectType));
	}
	@IsTest
	static void testUserOrGroupField()
	{
		System.Assert.areEqual(
				Schema.AccountShare.UserOrGroupId,
				fflib_SObjectShare.getUserOrGroupIdField(Schema.AccountShare.SObjectType));
	}
}