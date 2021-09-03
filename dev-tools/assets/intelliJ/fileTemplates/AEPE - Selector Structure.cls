public virtual inherited sharing class ${NAME}
        extends fflib_SObjectSelector
        implements I${NAME}
{
    public static I${NAME} newInstance()
    {
        return (I${NAME}) Application.Selector.newInstance(Schema.${SObject_API_Name}.SObjectType);
    }
    
    public static IContactsSelector newWithoutSharingInstance()
	{
		return (IContactsSelector) Application.ElevatedSelector.newInstance(Schema.${SObject_API_Name}.SObjectType);
	}
	
	public static IContactsSelector newInheritedSharingInstance()
	{
		return (IContactsSelector) Application.NoSharingSelector.newInstance(Schema.${SObject_API_Name}.SObjectType);
	}
	
	public ${NAME}()
	{
		super();
	}

	public ${NAME}(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS)
	{
		super(includeFieldSetFields, enforceCRUD, enforceFLS);
	}

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
                ${SObject_API_Name}.Id
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Schema.${SObject_API_Name}.SObjectType;
    }
    
    public virtual List<${SObject_API_Name}> selectById(Set<Id> idSet)
	{
		return (List<${SObject_API_Name}>) selectSObjectsById(idSet);
	}
	
    public with sharing class WithSharing extends ${NAME}
	{
		// Constructor that will enforce CRUD and FLS
		public WithSharing()
		{
			super(true, true, true);
		}

		public override List<${SObject_API_Name}> selectById(Set<Id> idSet)
		{
			return super.selectById(idSet);
		}
    }
    
    public without sharing class WithoutSharing extends ${NAME}
	{
		// Constructor that will enforce CRUD and FLS
		public WithoutSharing()
		{
			super(true, false, false);
		}

		public override List<${SObject_API_Name}> selectById(Set<Id> idSet)
		{
			return super.selectById(idSet);
		}
    }
}