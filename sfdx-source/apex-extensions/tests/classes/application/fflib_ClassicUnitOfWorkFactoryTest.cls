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
		new fflib_ClassicUnitOfWorkFactory()
				.setMock(newUnitOfWorkStub());
	}

	private static fflib_ISObjectUnitOfWork newUnitOfWorkStub() {
		return (fflib_ISObjectUnitOfWork) Test.createStub(
				fflib_ISObjectUnitOfWork.class,
				new UnitOfWorkStubProvider()
		);
	}

	private class UnitOfWorkStubProvider implements System.StubProvider {
		public Object handleMethodCall(
				Object stubbedObject,
				String stubbedMethodName,
				System.Type returnType,
				List<System.Type> listOfParamTypes,
				List<String> listOfParamNames,
				List<Object> listOfArgs
		) {
			return null;
		}
	}
}