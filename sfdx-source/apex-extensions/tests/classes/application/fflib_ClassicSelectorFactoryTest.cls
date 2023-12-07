
@IsTest(IsParallel=true)
private class fflib_ClassicSelectorFactoryTest
{
	@IsTest
	static void testSelectById()
	{
		fflib_ClassicSelectorFactory classicSelectorFactory =
				new fflib_ClassicSelectorFactory(
						new Map<SObjectType, Type> {Schema.Account.SObjectType => TestAccountSelector.class});
		List<SObject> sObjects = classicSelectorFactory.selectById(
				new Set<Id> {fflib_IDGenerator.generate(Schema.Account.SObjectType)},
				Schema.Account.SObjectType);
		System.Assert.isTrue(sObjects.isEmpty());
	}

	private class TestAccountSelector implements fflib_ISObjectSelector
	{
		public List<SObject> selectSObjectsById(Set<Id> idSet)
		{
			return new List<SObject>();
		}

		public SObjectType sObjectType()
		{
			return Schema.Account.SObjectType;
		}
	}
}