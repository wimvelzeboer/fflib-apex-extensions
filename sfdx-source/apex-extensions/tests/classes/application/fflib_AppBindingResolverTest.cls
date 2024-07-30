@IsTest(IsParallel=true)
private class fflib_AppBindingResolverTest
{
	@IsTest
	static void testWithEmptyRouter()
	{
		fflib_IAppBindingResolver resolver = fflib_AppBindingResolver.newInstance();
		System.Assert.areEqual([SELECT COUNT() FROM fflib_AppBinding__mdt], resolver.resolve().size());
	}


	@IsTest
	static void testWithCustomRouter(){
		fflib_IAppBindingResolver resolver = new fflib_AppBindingResolver(new CustomRouter());
		System.Assert.areEqual([SELECT COUNT() FROM fflib_AppBinding__mdt], resolver.resolve().size());
	}

	private class CustomRouter implements fflib_IAppBindingRouter
	{
		public Map<Type, Type> getRoutes()
		{
			return new Map<Type, Type>{ fflib_AppBindingResolverTest.class => fflib_AppBindingResolverTest.class };
		}
	}
}