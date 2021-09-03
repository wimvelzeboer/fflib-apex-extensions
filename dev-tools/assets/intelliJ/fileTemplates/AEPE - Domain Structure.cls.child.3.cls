@IsTest
private class ${NAME}Test
{
	@IsTest
	static void testNewInstanceWithIds()
	{
		final Id id = fflib_IDGenerator.generate(Schema.${SObject_API_Name}.SObjectType);
		final Set<Id> ids = new Set<Id>{ id };
		final List<${SObject_API_Name}> records = new List<${SObject_API_Name}>{ new ${SObject_API_Name}(Id = id) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		I${NAME}Selector selectorMock = (I${NAME}Selector) mocks.mock(I${NAME}Selector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectSObjectsById(ids)).thenReturn(records);
		mocks.stopStubbing();

		Application.Selector.setMock(Schema.${SObject_API_Name}.SObjectType, selectorMock);

		System.Test.startTest();
		I${NAME} result = ${NAME}.newInstance(ids);
		System.Test.stopTest();

		System.assertEquals(records, result.get${NAME}());
	}

	@IsTest
	static void testNewInstanceWithRecords()
	{
		final List<${SObject_API_Name}> records = new List<${SObject_API_Name}>{ new ${SObject_API_Name}(Id = fflib_IDGenerator.generate(Schema.${SObject_API_Name}.SObjectType)) };

		System.Test.startTest();
		I${NAME} result = ${NAME}.newInstance(records);
		System.Test.stopTest();

		System.assertEquals(records, result.get${NAME}());
	}
}