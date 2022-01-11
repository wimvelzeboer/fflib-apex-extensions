public interface I${NAME}
        extends fflib_ISObjects
{
    List<${SObject_API_Name}> get${NAME}();
    I${NAME} selectById(Set<Id> ids);
}