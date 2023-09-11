public virtual without sharing class ${NAME}
        extends fflib_SObjectSelector
        implements I${NAME}
{
	/**
	 * Runs the query in User Mode, respecting FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
    public static I${NAME} newInstance()
    {
        return (I${NAME})
				((fflib_SObjectSelector) Application.Selector.newInstance(Schema.${SObject_API_Name}.SObjectType))
				.setDataAccess(fflib_SObjectSelector.DataAccess.USER_MODE);
    }

	/**
	 * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
    public static I${NAME} newWithoutSharingInstance()
	{
        return (I${NAME})
				((fflib_SObjectSelector) Application.Selector.newInstance(Schema.${SObject_API_Name}.SObjectType))
				.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
	}

	/**
	 * Class constructor
	 * This should not be used directly by an application but only by fflib
     */
	public ${NAME}()
	{
		super();
	}

	/**
	 * The fields to always include in all queries
	 *
	 * @return Returns a list of default fields that are always queried
     */
    public virtual List<Schema.SObjectField> getSObjectFieldList()
    {
        List<SObjectField> sObjectFields = new List<Schema.SObjectField>
        {
                ${SObject_API_Name}.Id
        };
		// Uncomment the following line if this selector is extended from another selector
		// result.addAll(super.getSObjectFieldList());
		return sObjectFields;
    }

	/**
	 * Gets the SObjectType of the records returned by this selector class
	 *
     * @return Returns the SObjectType of the returned records
	 */
	public Schema.SObjectType getSObjectType()
    {
        return Schema.${SObject_API_Name}.SObjectType;
    }

	/**
	 * Gets ${SObject_API_Name} records by their Id
	 *
	 * @param idSet The Ids to query
	 *
	 * @return Returns a list of ${SObject_API_Name} records matching the idSet
	 */
	public virtual List<${SObject_API_Name}> selectById(Set<Id> idSet)
	{
		return (List<${SObject_API_Name}>) selectSObjectsById(idSet);
	}
}