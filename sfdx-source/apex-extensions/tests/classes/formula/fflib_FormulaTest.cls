@IsTest
private class fflib_FormulaTest
{
	@IsTest
	static void testAdditiveOperator_Integer()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('{1 + 1;}')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(2, result);
	}

//	@IsTest
//	static void testAdditiveOperator_PlusPlus()
//	{
//		System.Test.startTest();
//		Integer result = new fflib_formula('1++;')
//				.evaluate()
//				.toInteger();
//		System.Test.stopTest();
//
//		System.Assert.areEqual(2, result);
//	}

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
	static void testAssignmentExpression_additive()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 1; x += 1;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(2, result);
	}

	@IsTest
	static void testAssignmentExpression_subtraction()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 1; x -= 1;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(0, result);
	}

	@IsTest
	static void testBlockStatement()
	{
		System.Test.startTest();
		Integer result = new fflib_formula(
				'let x = 1;\n' +
						'{' +
							'let y = 2;' +
							'if (x < 2) { x = y + 1;}' +
							'else if (x < 1) { x = 0;}' +
							'else { x = 2;}' +
						'}\n' +
						'x;')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(3, result);
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
	static void testEqualsValue()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('1 < 2 == true;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
	}

	@IsTest
	static void testIfStatement_Consequent()
	{
		System.Test.startTest();
		Integer result = new fflib_formula(
				'let x = 1;\n' +
						'if (x < 2) { 42;}' +
						'else { 0;}')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(42, result);
	}

	@IsTest
	static void testIfStatement_Alternate()
	{
		System.Test.startTest();
		Integer result = new fflib_formula(
				'let x = 3;\n' +
						'if (x < 2) { 42;}' +
						'else { 0;}')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(0, result);
	}

	@IsTest
	static void testIfStatement_TwoConditions()
	{
		System.Test.startTest();
		Integer result = new fflib_formula(
				'let x = 3;\n' +
						'if (x < 2) { 40;}' +
						'else if (x < 5) { 42;}' +
						'else { 0;}')
				.evaluate()
				.toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(42, result);
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
	static void testLogicalExpression_And_Success()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('1 < 2 && 2 < 3;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
	}

	@IsTest
	static void testLogicalExpression_And_Failing()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('1 > 2 AND 2 < 3;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isFalse(result);
	}

	@IsTest
	static void testLogicalExpression_Or_Success()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('1 > 2 || 2 < 3;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
	}

	@IsTest
	static void testLogicalExpression_Or_Failing()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('1 > 2 OR 2 < 3;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
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

	@IsTest
	static void testUnaryExpression_Not()
	{
		System.Test.startTest();
		Boolean result = new fflib_formula('let x = false; !x;')
		    .evaluate()
		    .toBoolean();
		System.Test.stopTest();

		System.Assert.isTrue(result);
	}

	@IsTest
	static void testUnaryExpression_Negative()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 5; -x;')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(-5, result);
	}

	@IsTest
	static void testWhile()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 5; while (x < 10) { x = x + 1; }')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(10, result);
	}

	@IsTest
	static void testWhile_DoWhile()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 5; do { x = x + 1; } while (x < 10)')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(10, result);
	}

	@IsTest
	static void testForILoop()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 0; for (let i =0; i < 10; i +=1) { x += i; }')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(45, result);
	}

	@IsTest
	static void testForLoop_Object()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 0; for (let i =0; i < 10; i +=1) { x += i; }')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(45, result);
	}

	@IsTest
	static void testForObjectLoop()
	{
		System.Test.startTest();
		Integer result = new fflib_formula('let x = 0; for (let i =0; i < 10; i++) { x += i; }')
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(10, result);
	}

	@IsTest
	static void testWithVariables_Primitive()
	{
		System.Test.startTest();
		Integer result = new fflib_formula(
				'let number = 0;' +
						'if (x) { number = y + 10; }' +
						'if (z == "value") { number += 1; }' +
						'number;',
				new Map<String, Object>
				{
						'x' => true,
						'y' => 31,
						'z' => 'value'
				})
		    .evaluate()
		    .toInteger();
		System.Test.stopTest();

		System.Assert.areEqual(42, result);
	}

	@IsTest
	static void testWithVariables_Object()
	{
		System.Test.startTest();
		String result = new fflib_formula(
				'if (obj.Name == "Test Account") { obj.Name; }' +
						'else { "Unknown"; }',
				new Map<String, Object>
				{
						'obj' => new Account(
								Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
								Name ='Test Account')
				})
		    .evaluate()
		    .toString();
		System.Test.stopTest();

		System.Assert.areEqual('Test Account', result);
	}
}