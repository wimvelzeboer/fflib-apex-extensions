@IsTest(IsParallel=true)
private class fflib_ClassicUnitOfWorkFactoryTest
{
	@IsTest
	static void testUnitOfWork()
	{
		new fflib_ClassicUnitOfWorkFactory(new List<SObjectType>{ Schema.Account.SObjectType });
	}

	@IsTest
	static void testUnitOfWorkMock()
	{
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork unitOfWorkMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		new fflib_ClassicUnitOfWorkFactory()
				.setMock(unitOfWorkMock);
	}
}