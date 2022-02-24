public inherited sharing class ${NAME}
        extends fflib_SObjects2
        implements I${NAME}
{
    public static I${NAME} newInstance(List<${SObject_API_Name}> records)
    {
        return (I${NAME}) Application.Domain.newInstance(records, Schema.${SObject_API_Name}.SObjectType);
    }

    public static I${NAME} newInstance(Set<Id> ids)
    {
        return (I${NAME}) Application.Domain.newInstance(ids, Schema.${SObject_API_Name}.SObjectType);
    }

    public ${NAME}(List<${SObject_API_Name}> records)
    {
        super(records, Schema.${SObject_API_Name}.SObjectType);
    }

    public List<${SObject_API_Name}> get${NAME}()
    {
        return (List<${SObject_API_Name}>) getRecords();
    }

    public Map<Id, ${SObject_API_Name}> getById()
    {
        return new Map<Id, ${SObject_API_Name}>(get${NAME}());
    }

    public I${NAME} selectById(Set<Id> ids)
    {
        return new ${NAME}(getRecords(ids));
    }

    private I${NAME} get${NAME}ByIdField(Schema.SObjectField sObjectField)
    {
        Map<Id, List<SObject>> sObjectsById = getSObjectsById(sObjectField);
        Map<Id, I${NAME}> result = new Map<Id, I${NAME}>();
        for (Id idValue : sObjectsById.keySet())
        {
            result.put(idValue, new ${NAME}(sObjectsById.get(idValue)));
        }
        return result;
    }

    private I${NAME} selectBy(fflib_Criteria criteria)
    {
        return new ${NAME}(getRecords(criteria));
    }

    private I${NAME} selectBlank(Schema.SObjectField sObjectField)
    {
        List<${SObject_API_Name}> result = new List<${SObject_API_Name}>();
        for (${SObject_API_Name} record : get${NAME}())
        {
            if (String.isNotBlank((String) record.get(sObjectField))) continue;

            result.add(record);
        }
        return new ${NAME}(result);
    }

    private I${NAME} selectNonBlank(Schema.SObjectField sObjectField)
    {
        List<${SObject_API_Name}> result = new List<${SObject_API_Name}>();
        for (${SObject_API_Name} record : get${NAME}())
        {
            if (String.isBlank((String) record.get(sObjectField))) continue;

            result.add(record);
        }
        return new ${NAME}(result);
    }

    private I${NAME} selectNull(Schema.SObjectField sObjectField)
    {
        List<${SObject_API_Name}> result = new List<${SObject_API_Name}>();
        for (${SObject_API_Name} record : get${NAME}())
        {
            if (record.get(sObjectField) != null) continue;

            result.add(record);
        }
        return new ${NAME}(result);
    }

    private I${NAME} selectWith(Schema.SObjectField sObjectField)
    {
        List<${SObject_API_Name}> result = new List<${SObject_API_Name}>();
        for (${SObject_API_Name} record : get${NAME}())
        {
            if (record.get(sObjectField) == null) continue;

            result.add(record);
        }
        return new ${NAME}(result);
    }

    private I${NAME} selectWithout(Schema.SObjectField sObjectField)
    {
        List<${SObject_API_Name}> result = new List<${SObject_API_Name}>();
        for (${SObject_API_Name} record : get${NAME}())
        {
            if (record.get(sObjectField) != null) continue;

            result.add(record);
        }
        return new ${NAME}(result);
    }

    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_SObjects construct(List<Object> records)
        {
            return new ${NAME}((List<SObject>) records);
        }
    }
}
