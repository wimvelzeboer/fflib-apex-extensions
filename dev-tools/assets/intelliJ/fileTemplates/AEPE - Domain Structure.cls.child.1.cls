public interface I${NAME}
        extends fflib_ISObjects
{
    List<${SObject_API_Name}> get${NAME}();
    Map<Id, ${SObject_API_Name}> getById();
    I${NAME} selectById(Set<Id> ids);
}