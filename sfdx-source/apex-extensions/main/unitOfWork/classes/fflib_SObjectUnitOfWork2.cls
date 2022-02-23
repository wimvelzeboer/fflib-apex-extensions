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

	public virtual void registerDirty(fflib_ISObjects domain)
	{
		registerDirty(domain.getRecords());
	}
}