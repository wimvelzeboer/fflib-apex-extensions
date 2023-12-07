@IsTest
private class fflib_AppBindingsTest
{
	@IsTest
	static void testBehavior()
	{
		fflib_AppBinding binding = new fflib_AppBinding();
		binding.setImplementationType(fflib_AppBindingsTest.class);
		binding.setInterfaceType(fflib_AppBindingsTest.class);
		binding.setBindingObject(fflib_AppBindingsTest.class);
		binding.setNamespacePrefix('test');
		binding.setSequence(1);

		fflib_AppBindings appBindings = new fflib_AppBindings(new List<fflib_IAppBinding>());
		appBindings.addBinding(binding);
		System.Assert.areEqual(fflib_AppBindingsTest.class, appBindings.getImplementations().get(0), 'Incorrect returned implementation');
		System.Assert.areEqual(1, appBindings.selectByInterfaceType(fflib_AppBindingsTest.class).getObjects().size(), 'Incorrect returned interface type');
		System.Assert.areEqual(1, appBindings.selectByNamespacePrefix('test').getObjects().size(), 'Incorrect returned namespace prefix');
		System.Assert.areEqual(1, appBindings.selectByObject(fflib_AppBindingsTest.class).getObjects().size(), 'Incorrect returned object');
		System.Assert.areEqual(fflib_IAppBinding.class, appBindings.getType(), 'Incorrect returned type');
		appBindings.selectBySequence(1);
	}
}