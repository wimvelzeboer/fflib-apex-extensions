public with sharing class ${NAME}
{
    public static void generateSomething()
    {
        factory().generateSomething();
    }

    private static I${NAME} factory()
    {
        return (I${NAME}) Application.Factories.newInstance(I${NAME}.class);
    }
}