public inherited sharing class ${NAME}
        extends SObjects
        implements I${NAME}
{
    public static I${NAME} newInstance(List<${SObject_API_Name}> records)
    {
        return (I${NAME}) Application.Domain.newInstance(records);
    }

    public static I${NAME} newInstance(Set<Id> ids)
    {
        return (I${NAME}) Application.Domain.newInstance(ids);
    }

    public ${NAME}(List<${SObject_API_Name}> records)
    {
        super(records, Schema.${SObject_API_Name}.SObjectType);
    }

    public List<${SObject_API_Name}> get${NAME}()
    {
        return (List<${SObject_API_Name}>) getRecords();
    }

    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_SObjects construct(List<Object> records)
        {
            return new ${NAME}((List<SObject>) records);
        }
    }
}
