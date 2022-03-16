@IsTest
private class ${NAME}Test
{
    @IsTest
    static void testBehavior()
    {
    
        System.Test.startTest();
        ${NAME}.generateSomething();
        System.Test.stopTest();
        
    }
}