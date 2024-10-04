
@IsTest
private class fflib_ParserTest
{
	@IsTest
	static void testBehavior()
	{
		fflib_Parser.AST result =
				new fflib_Parser('(2 + 2) * 2;')
						.run();

		System.debug(JSON.serializePretty(result));
	}
}