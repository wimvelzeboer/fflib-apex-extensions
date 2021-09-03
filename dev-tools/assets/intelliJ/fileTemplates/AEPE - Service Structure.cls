public with sharing class ${NAME}
{
    public static void doSomething()
    {
        service().doSomething();
    }

    private static I${NAME} service()
    {
        return (I${NAME}) Application.Service.newInstance(I${NAME}.class);
    }

    public class ${NAME}Exception extends Exception {}
}