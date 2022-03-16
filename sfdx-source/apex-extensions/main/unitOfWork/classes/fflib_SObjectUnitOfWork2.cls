public virtual with sharing class fflib_SObjectUnitOfWork2
		extends fflib_SObjectUnitOfWork
		implements fflib_ISObjectUnitOfWork
{
	public fflib_SObjectUnitOfWork2(List<SObjectType> sObjectTypes)
	{
		super(sObjectTypes);
	}
	public fflib_SObjectUnitOfWork2(List<SObjectType> sObjectTypes, IDML dml)
	{
		super(sObjectTypes, dml);
	}

	public void registerNew(fflib_ISObjects domain, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord)
	{
		registerNew(domain.getRecords(), relatedToParentField, relatedToParentRecord);
	}
	/**
	 * Register newly created records to be inserted when commitWork is called,
	 * it also provides a reference to the single parent record instance (should also be registered as new separately)
	 *
	 * @param records newly created records of the same SObjectType to be inserted during commitWork
	 * @param relatedToParentField A SObjectField reference to the child field that associates the child record with its parent
	 * @param relatedToParentRecord A SObject instance of the parent record (should also be registered as new separately)
	 *
	 * To be removed after merged of https://github.com/apex-enterprise-patterns/fflib-apex-common/pull/400
	 **/
	public void registerNew(List<SObject> records, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord)
	{
		if (records.isEmpty()) return;

		// Only validate the first record, by definition of the method signature all records should be new and of the same type.
		Schema.SObjectType sObjectType = records.get(0).getSObjectType();
		String sObjectName = sObjectType.getDescribe().getName();
		assertForNonEventSObjectType(sObjectName);
		assertForSupportedSObjectType(m_newListByType, sObjectName);

		for (SObject record : records)
		{
			if (record.getSObjectType() != sObjectType)
				throw new UnitOfWorkException('All records should be of the same SObjectType');
			if (record.Id != null)
				throw new UnitOfWorkException('Only new records can be registered as new');

			m_newListByType.get(sObjectName).add(record);
			if (relatedToParentRecord != null && relatedToParentField != null)
				registerRelationship(record, relatedToParentField, relatedToParentRecord);
		}
	}

	public void registerDirty(fflib_ISObjects domain, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord)
	{
		registerDirty(domain.getRecords(), relatedToParentField, relatedToParentRecord);
	}
	/**
	 * Register existing records to be updated when commitWork is called,
	 * it provide a reference to the parent record instance (should also be registered as new separately)
	 *
	 * @param records Existing records to be updated during commitWork
	 * @param relatedToParentField A SObjectField reference to the child field that associates the child record with its parent
	 * @param relatedToParentRecord A SObject instance of the parent record (should also be registered as new separately)
	 *
	 * To be removed after merged of https://github.com/apex-enterprise-patterns/fflib-apex-common/pull/400
	 **/
	public void registerDirty(List<SObject> records, Schema.SObjectField relatedToParentField, SObject relatedToParentRecord)
	{
		if (records.isEmpty()) return;

		// Only validate the first record, by definition of the method signature all records should be new and of the same type.
		Schema.SObjectType sObjectType = records.get(0).getSObjectType();
		String sObjectName = sObjectType.getDescribe().getName();
		assertForNonEventSObjectType(sObjectName);
		assertForSupportedSObjectType(m_dirtyMapByType, sObjectName);

		for (SObject record : records)
		{
			if (record.getSObjectType() != sObjectType)
				throw new UnitOfWorkException('All records should be of the same SObjectType');
			if (record.Id == null)
				throw new UnitOfWorkException('New records cannot be registered as dirty');

			m_dirtyMapByType.get(sObjectName).put(record.Id, record);
			if (relatedToParentRecord != null && relatedToParentField != null)
				registerRelationship(record, relatedToParentField, relatedToParentRecord);
		}
	}

	// To be removed after merged of https://github.com/apex-enterprise-patterns/fflib-apex-common/pull/400
	private void assertForNonEventSObjectType(String sObjectType)
	{
		if (sObjectType.length() > 3 && sObjectType.right(3)  == '__e')
		{
			throw new UnitOfWorkException(
					String.format(
							'SObject type {0} must use registerPublishBeforeTransaction or ' +
									'registerPublishAfterTransaction methods to be used within this unit of work',
							new List<String> { sObjectType }
					)
			);
		}
	}

	// To be removed after merged of https://github.com/apex-enterprise-patterns/fflib-apex-common/pull/400
	private void assertForSupportedSObjectType(Map<String, Object> theMap, String sObjectType)
	{
		if (!theMap.containsKey(sObjectType))
		{
			throw new UnitOfWorkException(
					String.format(
							'SObject type {0} is not supported by this unit of work',
							new List<String> { sObjectType }
					)
			);
		}
	}
}