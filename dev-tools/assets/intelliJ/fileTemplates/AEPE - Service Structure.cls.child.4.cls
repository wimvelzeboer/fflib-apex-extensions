@IsTest
private class ${NAME}Test
{
    @IsTest
    static void testBehavior()
    {
    
        System.Test.startTest();
        ${NAME}.doSomething();        
        System.Test.stopTest();
        
    }
}