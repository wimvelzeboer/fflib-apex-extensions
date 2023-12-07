@IsTest(IsParallel=true)
private class fflib_AppBindingMetaDataModuleTest
{
	@IsTest
	static void itShouldCheckForAnException(){
		fflib_AppBindingMetaDataModule module = new fflib_AppBindingMetaDataModule();
		fflib_AppBinding__mdt binding = new fflib_AppBinding__mdt(
				BindingObjectAlternate__c = 'SomeNonExistingClass',
				DeveloperName = 'SomeNonExistingClass'
		);
		try
		{
			module.getBindingObject(binding);
			System.Assert.fail('Expected an exception');
		}
		catch (fflib_AppBindingMetaDataModule.DeveloperException e)
		{
			System.Assert.areEqual(
					e.getMessage(),
					'Failed to find (S)Object somenonexistingclass referenced by binding SomeNonExistingClass'
			);
		}
	}

	@IsTest
	static void getSystemType_failing(){
		fflib_AppBindingMetaDataModule module = new fflib_AppBindingMetaDataModule();
		fflib_AppBinding__mdt binding = new fflib_AppBinding__mdt(
				ImplementationType__c = 'SomeNonExistingClass',
				DeveloperName = 'SomeNonExistingClass'
		);
		try
		{
			module.getSystemType(binding,  fflib_AppBinding__mdt.ImplementationType__c);
			System.Assert.fail('Expected an exception');
		}
		catch (fflib_AppBindingMetaDataModule.DeveloperException e)
		{
			System.Assert.areEqual(
					e.getMessage(),
					'Unable to find SomeNonExistingClass referenced by binding SomeNonExistingClass for ImplementationType__c'
			);
		}
	}
}