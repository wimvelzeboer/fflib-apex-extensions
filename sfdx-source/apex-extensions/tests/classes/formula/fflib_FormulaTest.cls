@IsTest
private class fflib_FormulaTest
{
	@IsTest
	static void testAdditiveOperator_Integer()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('1 + 1;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(2, result);
	}

	@IsTest
	static void testAdditiveOperator_Double()
	{
		System.Test.startTest();
		Double result = new fflib_formula('1.5 + 1.7;')
				.evaluate()
				.toDouble();
		System.Test.stopTest();

		System.Assert.areEqual(3.2, result);
	}

	@IsTest
	static void testAdditiveOperator_IntegerAndDouble()
	{
		System.Test.startTest();
		Double result = new fflib_formula('1 + 1.7;')
				.evaluate()
				.toDouble();
		System.Test.stopTest();

		System.Assert.areEqual(2.7, result);
	}

	@IsTest
	static void testAssignmentExpression()
	{
		System.Test.startTest();
		Double result = new fflib_formula('let x, y = 42;\nx;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(42, result);
	}

	@IsTest
	static void testBooleanValue_True()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('true;')
				.evaluate()
				.toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
	}

	@IsTest
	static void testBooleanValue_False()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('false;')
				.evaluate()
				.toBoolean();
		System.Test.stopTest();

		System.Assert.isFalse(result);
	}

	@IsTest
	static void testDoubleValue()
	{
		System.Test.startTest();
		Double result = new fflib_formula('5.1; // a number')
		    .evaluate()
		    .toDouble();
		System.Test.stopTest();

		System.Assert.areEqual(5.1, result);
	}

	@IsTest
	static void testIntegerValue()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('5;')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(5, result);
	}

	@IsTest
	static void testMultiplicativeOperator()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('2 + 2 * 2;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(6, result);
	}

	@IsTest
	static void testMultiplicativeOperator_withParentheses()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('(2 + 2) * 2;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(8, result);
	}

	@IsTest
	static void testNullValue()
	{
		System.Test.startTest();
		Object result = new fflib_formula('null;')
		    .evaluate()
		    .getValue();
		System.Test.stopTest();

		System.Assert.isNull(result);
	}

	@IsTest
	static void testStringValue_SingleQuotes()
	{
		System.Test.startTest();
		String result = new fflib_formula('\'Hello\\tWorld!\';')
		    .evaluate()
		    .toString();
		System.Test.stopTest();

		System.Assert.areEqual('Hello\\tWorld!', result);
	}

	@IsTest
	static void testStringValue_DoubleQuotes()
	{
		System.Test.startTest();
		String result = new fflib_formula('"Hello\\tWorld!";')
		    .evaluate()
		    .toString();
		System.Test.stopTest();

		System.Assert.areEqual('Hello\\tWorld!', result);
	}
}