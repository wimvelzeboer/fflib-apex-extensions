/**
 * File Name: fflib_Formula
 * @description A evaluator for evaluating multiple instances of the {@link FormulaEval.FormulaInstance} class
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
public with sharing class fflib_Formula
{
	/**
	 * The structure of the formulas
	 *
	 * @example '(1 OR 2) AND 3'
	 */
	private final String formulaStructure;

	private final Map<Integer, FormulaExpression> formulaByNumber;

	/**
	 * Class constructor
	 *
	 * @param formulaStructure A String holding the formula structure e.g. '1 AND (2 OR 3)'
	 * @param formulaByNumber A Map of the FormulaExpressions by their number
	 *
	 * @see fflib_Formula.FormulaExpression
	 */
	public fflib_Formula(String formulaStructure, Map<Integer, FormulaExpression> formulaByNumber)
	{
		this.formulaByNumber = formulaByNumber;
		this.formulaStructure = formulaStructure;
	}

	/**
	 * Evaluates the formula structure and the given formula expressions to a boolean value
	 *
	 * @return Returns a boolean of the evaluated result
	 */
	public Boolean evaluate()
	{
		return parse(
				tokenizer(this.formulaStructure),
				formulaByNumber
		)
				.evaluate();
	}

	/**
	 * Parse the next token into an Expression
	 *
	 * @param tokens A list of tokens from the tokenizer
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns an instance of {@link Expression}
	 *
	 * @see fflib_Formula.Expression
	 */
	@TestVisible
	private static Expression parse(List<Token> tokens, Map<Integer, FormulaExpression> formulaByNumber)
	{
		FormulaTokenType lookAhead = tokens.get(0).tokenType;

		switch on lookAhead
		{
			when PARENTHESIS_OPEN
			{
				return parseParenthesizedExpression(tokens, formulaByNumber);
			}
			when else
			{
				return parseLogicalOrExpression(tokens, formulaByNumber);
			}
		}
	}

	/**
	 * Parse a parenthesized expression
	 *      '(' expression ')'
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns the expression within the parenthesis
	 */
	private static Expression parseParenthesizedExpression(
			List<Token> tokens,
			Map<Integer, FormulaExpression> formulaByNumber)
	{
		eat(tokens, FormulaTokenType.PARENTHESIS_OPEN);
		Expression expr = parse(tokens, formulaByNumber);
		eat(tokens, FormulaTokenType.PARENTHESIS_CLOSE);
		return expr;
	}

	/**
	 * Parse a logical OR expression
	 *      expression
	 *      expression OR expression
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns an {@link fflib_Formula.OrExpression} or the expression itself
	 */
	private static Expression parseLogicalOrExpression(
			List<Token> tokens,
			Map<Integer, FormulaExpression> formulaByNumber)
	{
		Expression left = parseLogicalAndExpression(tokens, formulaByNumber);

		while (tokens.isEmpty() == false)
		{
			if (tokens.get(0).tokenType != FormulaTokenType.xOR) break;

			eat(tokens, FormulaTokenType.xOR);
			Expression right = parseLogicalAndExpression(tokens, formulaByNumber);
			left = new OrExpression(left, right);
		}
		return left;
	}

	/**
	 * Parse a logic AND expression
	 *      expression
	 *      expression AND primary-expression
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns an {@link fflib_Formula.AndExpression} or the expression itself
	 */
	private static Expression parseLogicalAndExpression(
			List<fflib_Formula.Token> tokens,
			Map<Integer, FormulaExpression> formulaByNumber)
	{
		Expression left = parsePrimaryExpression(tokens, formulaByNumber);

		while (tokens.isEmpty() == false)
		{
			if (tokens.get(0).tokenType != FormulaTokenType.xAND) break;

			eat(tokens, FormulaTokenType.xAND);
			Expression right = parsePrimaryExpression(tokens, formulaByNumber);
			left = new AndExpression(left, right);
		}

		return left;
	}

	/**
	 * Parse a primary expression
	 *      parenthesized-expression
	 *      number-expression
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns an {@link Expression} or a {@link FormulaExpression}
	 */
	private static Expression parsePrimaryExpression(
			List<fflib_Formula.Token> tokens,
			Map<Integer, FormulaExpression> formulaByNumber)
	{
		Expression result;
		if (tokens.isEmpty()) throw new FormulaEvaluationException('Unexpected end of formula, expected and expression');
		switch on tokens.get(0).tokenType
		{
			when PARENTHESIS_OPEN
			{
				result = parseParenthesizedExpression(tokens, formulaByNumber);
			}
			when FORMULA_NUMBER
			{
				result = parseNumberExpression(tokens, formulaByNumber);
			}
		}
		return result;
	}

	/**
	 * Parse a number expression
	 *      `^\\d`
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param formulaByNumber A map of FormulaExpressions by their number
	 *
	 * @return Returns the corresponding {@link FormulaExpression} from the parsed number
	 *     which is used as key in the given formulaByNumber map
	 */
	private static Expression parseNumberExpression(
			List<fflib_Formula.Token> tokens,
			Map<Integer, FormulaExpression> formulaByNumber)
	{
		Token token = eat(tokens, FormulaTokenType.FORMULA_NUMBER);

		Integer i = Integer.valueOf(token.literal);
		if (formulaByNumber.containsKey(i) == false) throw new FormulaEvaluationException('Unknown number ' + i);

		return formulaByNumber.get(i);
	}

	/**
	 * Takes first token from the list that must match the given token type
	 *
	 * @param tokens The list of tokens still to be processes
	 * @param tokenType The token type of the first token in the list
	 *
	 * @return Returns the first token of the given tokens
	 *
	 * @throws FormulaEvaluationException when there are no tokens left
	 *      or when the first token is not of the requested type
	 */
	private static Token eat(List<Token> tokens, FormulaTokenType tokenType)
	{
		if (tokens.isEmpty()) throw new FormulaEvaluationException('Unexpected end of line, expected ' + tokenType.name());
		else if (tokens.get(0).tokenType !== tokenType) throw new FormulaEvaluationException('Unexpected token \'' + tokens.get(0).literal + '\', expected ' + tokenType.name());
		return tokens.remove(0);
	}

	/**
	 * Tokenizes the given snippet into tokens that can be read by the parser
	 *
	 * @param snippet A formula structure e.g. "1 AND 2 OR 3"
	 *
	 * @return Returns the list of tokens
	 *
	 * @throws FormulaEvaluationException When encountering an unknown token
	 */
	private static List<Token> tokenizer(String snippet)
	{
		List<Token> result = new List<Token>();

		snippet = '(' + snippet + ')'; // Make sure we evaluate the whole snippet
		snippet = snippet.replaceAll('\\(', ' ( ');
		snippet = snippet.replaceAll('\\)', ' ) ');

		List<String> strings = snippet.split('(\\b|\\s)');
		for (String literal : strings)
		{
			if (String.isBlank(literal))
			{
				continue; // ignore spaces
			}
			else if (literal.trim() == '(')
			{
				result.add(new Token(literal, FormulaTokenType.PARENTHESIS_OPEN));
			}
			else if (literal.trim() == ')')
			{
				result.add(new Token(literal, FormulaTokenType.PARENTHESIS_CLOSE));
			}
			else if (literal.toUpperCase().trim() == 'OR' || literal.trim() == '||')
			{
				result.add(new Token(literal, FormulaTokenType.xOR));
			}
			else if (literal.toUpperCase().trim() == 'AND' || literal.trim() == '&&')
			{
				result.add(new Token(literal, FormulaTokenType.xAND));
			}
			else
			{
				try
				{
					Integer.valueOf(literal);
				}
				catch (Exception e)
				{
					throw new FormulaEvaluationException('Invalid token \'' + literal + '\'');
				}
				result.add(new Token(literal, FormulaTokenType.FORMULA_NUMBER));
			}
		}
		return result;
	}

	@TestVisible
	private interface Expression
	{
		/**
		 * Evaluate the Expression
		 *
		 * @return Returns a boolean value of the evaluated expression
		 */
		Boolean evaluate();
	}

	/**
	 * FormulaExpression Class
	 *
	 * Used to hold the {@link FormulaEval.FormulaInstance} and the object that should be evaluated
	 */
	public class FormulaExpression implements Expression
	{
		private final FormulaEval.FormulaInstance instance;
		private final Object objectToEvaluate;

		public FormulaExpression(FormulaEval.FormulaInstance instance, Object objectToEvaluate)
		{
			this.instance = instance;
			this.objectToEvaluate = objectToEvaluate;
		}

		public Boolean evaluate()
		{
			return (Boolean) this.instance.evaluate(this.objectToEvaluate);
		}
	}

	/**
	 * AndExpression Class
	 *
	 * Used to hold AND expressions e.g. 'expression AND expression' and is able to evaluate the expressions.
	 * NOTE: the right hand side will only be evaluated if the left hand side returned true
	 */
	@TestVisible
	private class AndExpression implements Expression
	{
		@TestVisible private final Expression left;
		@TestVisible private final Expression right;

		public AndExpression(Expression left, Expression right)
		{
			this.left = left;
			this.right = right;
		}

		public Boolean evaluate()
		{
			return left.evaluate() && right.evaluate();
		}
	}

	/**
	 * OrExpression Class
	 *
	 * Used to hold OR expressions e.g. 'expression OR expression' and is able to evaluate the expressions.
	 * NOTE: the right hand side will only be evaluated if the left hand side returned false
	 */
	@TestVisible
	private class OrExpression implements Expression
	{
		@TestVisible private final Expression left;
		@TestVisible private final Expression right;

		public OrExpression(Expression left, Expression right)
		{
			this.left = left;
			this.right = right;
		}

		public Boolean evaluate()
		{
			return left.evaluate() || right.evaluate();
		}
	}

	/**
	 * Token Class
	 *
	 * Tokens are used by the Tokenizer to translate a formula structure into tokens the parser can understand
	 */
	@TestVisible
	private class Token
	{
		private final String literal;
		private final FormulaTokenType tokenType;

		public Token(String literal, FormulaTokenType tokenType)
		{
			this.literal = literal;
			this.tokenType = tokenType;
		}
	}

	/**
	 * FormulaTokenType enum
	 *
	 * The available token types which can be used in a formula structure
	 */
	@TestVisible
	private enum FormulaTokenType
	{
		FORMULA_NUMBER,             // e.g. '\\d'
		xAND,                       // e.g. 'And', '&&'
		xOR,                        // e.g. 'OR', '||'
		PARENTHESIS_OPEN,           // e.g. '('
		PARENTHESIS_CLOSE           // e.g. ')'
	}
}