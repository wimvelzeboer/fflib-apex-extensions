
@IsTest
private class fflib_ParserTest
{
	@IsTest
	static void testBehavior()
	{
		fflib_Parser.AST result =
				new fflib_Parser(
						'x > 0 == true;')
						.run();

		System.debug(JSON.serializePretty(result));
	}
}