@IsTest(IsParallel=true)
private class fflib_SObjectUnitOfWork2Test
{
	private static List<SObjectType> SOBJECT_LIST = new List<SObjectType> {Schema.Account.SObjectType};

	@IsTest
	static void testRegisterNewOfDomain()
	{
		Account parentRecord = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Parent');
		Account record = new Account(Name = 'Child');
		List<Account> records = new List<Account> {record};
		TestDomain domain = new TestDomain(records);

		TestDML testDML = new TestDML();
		fflib_SObjectUnitOfWork2 unitOfWork = new fflib_SObjectUnitOfWork2(SOBJECT_LIST, testDML);
		unitOfWork.registerNew(domain, Schema.Account.ParentId, parentRecord);
		unitOfWork.commitWork();

		System.Assert.areEqual(1, testDML.toInsert.size(), 'Expected one record to be inserted');
		System.Assert.areEqual(parentRecord.Id, ((Account) testDML.toInsert.get(0)).ParentId, 'Expected the record to be linked to the parent');
	}

	@IsTest
	static void testRegisterDirtyOfDomain()
	{
		Account parentRecord = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Parent');
		Account record = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Child');
		List<Account> records = new List<Account> {record};
		TestDomain domain = new TestDomain(records);

		TestDML testDML = new TestDML();
		fflib_SObjectUnitOfWork2 unitOfWork = new fflib_SObjectUnitOfWork2(SOBJECT_LIST, testDML);
		unitOfWork.registerDirty(domain, Schema.Account.ParentId, parentRecord);
		unitOfWork.commitWork();

		System.Assert.areEqual(1, testDML.toUpdate.size(), 'Expected one record to be inserted');
		System.Assert.areEqual(parentRecord.Id, ((Account) testDML.toUpdate.get(0)).ParentId, 'Expected the record to be linked to the parent');
	}

	@IsTest
	static void testRegisterNewOfDomain_failing_NotTheSameType()
	{
		Account parentRecord = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Parent');
		Account accountRecord = new Account(Name = 'Account');
		Contact contactRecord = new Contact(LastName = 'Contact');
		List<SObject> records = new List<SObject> {accountRecord, contactRecord};

		TestDML testDML = new TestDML();
		try
		{
			fflib_SObjectUnitOfWork2 unitOfWork = new fflib_SObjectUnitOfWork2(SOBJECT_LIST, testDML);
			unitOfWork.registerNew(records, Schema.Account.ParentId, parentRecord);
			System.Assert.fail('The UnitOfWork should have thrown an exception');
		}
		catch (fflib_SObjectUnitOfWork.UnitOfWorkException e)
		{
			System.Assert.areEqual(e.getMessage(), 'All records should be of the same SObjectType');
		}
	}

	@IsTest
	static void testRegisterNewOfDomain_failing_NotSupportedType()
	{
		Account parentRecord = new Account(
				Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
				Name = 'Parent');
		Contact contactRecord = new Contact(LastName = 'Contact');
		List<SObject> records = new List<SObject> {contactRecord};

		TestDML testDML = new TestDML();
		try
		{
			fflib_SObjectUnitOfWork2 unitOfWork = new fflib_SObjectUnitOfWork2(SOBJECT_LIST, testDML);
			unitOfWork.registerNew(records, Schema.Account.ParentId, parentRecord);
			System.Assert.fail('The UnitOfWork should have thrown an exception');
		}
		catch (fflib_SObjectUnitOfWork.UnitOfWorkException e)
		{
			System.Assert.areEqual(e.getMessage(), 'SObject type Contact is not supported by this unit of work');
		}
	}

	private class TestDomain extends fflib_SObjects
	{
		private TestDomain(List<SObject> records)
		{
			super(records);
		}

		private TestDomain(List<SObject> records, SObjectType sObjectType)
		{
			super(records, sObjectType);
		}

		public override SObjectType getSObjectType()
		{
			return Schema.Account.SObjectType;
		}
	}

	private class TestDML implements fflib_SObjectUnitOfWork.IDML
	{
		public List<SObject> toDelete = new List<SObject>();
		public List<SObject> toInsert = new List<SObject>();
		public List<SObject> toUpdate = new List<SObject>();
		public List<SObject> toEmptyRecycleBin = new List<SObject>();
		public List<SObject> toPublish = new List<SObject>();
		public void dmlDelete(List<SObject> objList)
		{
			this.toDelete.addAll(objList);
		}

		public void dmlInsert(List<SObject> objList)
		{
			this.toInsert.addAll(objList);
		}

		public void dmlUpdate(List<SObject> objList)
		{
			this.toUpdate.addAll(objList);
		}

		public void emptyRecycleBin(List<SObject> objList)
		{
			this.toEmptyRecycleBin.addAll(objList);
		}

		public void eventPublish(List<SObject> objList)
		{
			this.toPublish.addAll(objList);
		}
	}
}