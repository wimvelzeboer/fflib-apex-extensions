/**
 * File Name: fflib_FormulaTest
 * @description A test class for {@link fflib_Formula} class
 *
 * @author architect ir. Wilhelmus G.J. Velzeboer
 *
 * Copyright (c), W.G.J. Velzeboer,
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above author notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the author nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
@IsTest
private class fflib_FormulaTest
{
	@IsTest
	static void itShouldTestSingleFormula()
	{
		final String formulaStructure = '1';
		fflib_Formula.FormulaExpression expression = generateAccountSiteFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expression
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}

	@IsTest
	static void itShouldTestSingleFormula_parenthesized()
	{
		final String formulaStructure = '(1)';
		fflib_Formula.FormulaExpression expression = generateContactCountryFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expression
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}

	@IsTest
	static void itShouldTestSingleFormula_failing()
	{
		final String formulaStructure = 'unknown';
		fflib_Formula.FormulaExpression expression = generateAccountSiteFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
				{
						1 => expression
				};

		System.Test.startTest();
		try
		{
			new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
			System.Assert.fail('Expected an exception, but got none');
		}
		catch (FormulaEvaluationException e)
		{
			System.Assert.areEqual('Invalid token \'unknown\'', e.getMessage(), 'Incorrect error message');
		}
		System.Test.stopTest();
	}

	@IsTest
	static void itShouldTestAndFormula()
	{
		final String formulaStructure = '1 AND 2';
		fflib_Formula.FormulaExpression expr1 = generateAccountSiteFormula();
		fflib_Formula.FormulaExpression expr2 = generateContactCountryFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expr1,
				2 => expr2
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}

	@IsTest
	static void itShouldTestOrFormula()
	{
		final String formulaStructure = '1 || 2';
		fflib_Formula.FormulaExpression expr1 = generateLeadCountryFormula();
		fflib_Formula.FormulaExpression expr2 = generateContactCountryFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expr1,
				2 => expr2
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}

	@IsTest
	static void itShouldTestOrFormula_Text()
	{
		final String formulaStructure = '1 OR 2';
		fflib_Formula.FormulaExpression expr1 = generateLeadCountryFormula();
		fflib_Formula.FormulaExpression expr2 = generateContactCountryFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expr1,
				2 => expr2
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}

	/**
	 * OR expression
	 *  left = AND Expression
	 *          left = 1
	 *          right = 2
	 *  right = 3
	 */
	@IsTest
	static void itShouldParseAndOrFormula()
	{
		List<fflib_Formula.Token> tokens = new List<fflib_Formula.Token>
		{
				new fflib_Formula.Token('1', fflib_Formula.FormulaTokenType.FORMULA_NUMBER),
				new fflib_Formula.Token('AND', fflib_Formula.FormulaTokenType.xAND),
				new fflib_Formula.Token('2', fflib_Formula.FormulaTokenType.FORMULA_NUMBER),
				new fflib_Formula.Token('OR', fflib_Formula.FormulaTokenType.xOR),
				new fflib_Formula.Token('3', fflib_Formula.FormulaTokenType.FORMULA_NUMBER)
		};
		Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber = new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => null,
				2 => null,
				3 => null
		};

		System.Test.startTest();
		fflib_Formula.Expression result = fflib_Formula.parse(tokens, formulaByNumber);
		System.Test.stopTest();

		System.Assert.isTrue(result instanceof fflib_Formula.OrExpression, 'Expected an OR expression');
		fflib_Formula.OrExpression orExpression = (fflib_Formula.OrExpression) result;
		System.Assert.isTrue(orExpression.left instanceof fflib_Formula.AndExpression, 'Expected an AND expression');
		System.Assert.isNull(orExpression.right, 'Expected null for right hand side in OR expression');

		fflib_Formula.AndExpression andExpression = (fflib_Formula.AndExpression) orExpression.left;
		System.Assert.isNull(andExpression.left, 'Expected null for left hand side in AND expression');
		System.Assert.isNull(andExpression.right, 'Expected null for right hand side in AND expression');
	}

	@IsTest
	static void itShouldTestAndOrFormula()
	{
		final String formulaStructure = '1 AND (2 OR 3)';
		fflib_Formula.FormulaExpression expr1 = generateAccountSiteFormula();
		fflib_Formula.FormulaExpression expr2 = generateContactCountryFormula();
		fflib_Formula.FormulaExpression expr3 = generateLeadCountryFormula();

		final Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber =
				new Map<Integer, fflib_Formula.FormulaExpression>
		{
				1 => expr1,
				2 => expr3,
				3 => expr2
		};

		System.Test.startTest();
		Boolean result = new fflib_Formula(formulaStructure, formulaByNumber).evaluate();
		System.Test.stopTest();

		System.Assert.isTrue(result, 'Incorrect result for evaluated formula');
	}


	private static fflib_Formula.FormulaExpression generateAccountSiteFormula()
	{
		return new fflib_Formula.FormulaExpression(
				Formula.builder()
						.withReturnType(FormulaEval.FormulaReturnType.Boolean)
						.withType(Account.SObjectType)
						.withFormula('ISBLANK(Site) = FALSE')
						.build(),
				new Account(Site = 'Test')
		);
	}

	private static fflib_Formula.FormulaExpression generateContactCountryFormula()
	{
		return new fflib_Formula.FormulaExpression(
				Formula.builder()
						.withReturnType(FormulaEval.FormulaReturnType.Boolean)
						.withType(Contact.SObjectType)
						.withFormula('MailingCountry = "Belgium"')
						.build(),
				new Contact(MailingCountry = 'Belgium')
		);
	}

	private static fflib_Formula.FormulaExpression generateLeadCountryFormula()
	{
		return new fflib_Formula.FormulaExpression(
				Formula.builder()
						.withReturnType(FormulaEval.FormulaReturnType.Boolean)
						.withType(Lead.SObjectType)
						.withFormula('Country = "Germany"')
						.build(),
				new Lead(Country = 'Holland')
		);
	}
}