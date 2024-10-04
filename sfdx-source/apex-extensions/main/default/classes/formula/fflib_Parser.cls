public virtual class fflib_Parser
{
	protected String codeBlock;
	protected fflib_Tokenizer tokenizer;
	protected fflib_Tokenizer.Token lookahead;

	private static Set<fflib_TokenKind> LITERALS = new Set<fflib_TokenKind>
	{
			fflib_TokenKind.FALSEx,
			fflib_TokenKind.NULLx,
			fflib_TokenKind.NUMBERx,
			fflib_TokenKind.STRINGx,
			fflib_TokenKind.TRUEx
	};

	private static Set<fflib_TokenKind> ASSIGNMENT_OPERATORS = new Set<fflib_TokenKind>
	{
			fflib_TokenKind.COMPLEX_ASSIGNMENT,
			fflib_TokenKind.SIMPLE_ASSIGNMENT
	};

	public fflib_Parser(String codeBlock)
	{
		this.codeBlock = codeBlock;
	}

	public AST run()
	{
		this.tokenizer = new fflib_Tokenizer(this.codeBlock);

		// Prime the tokenizer to obtain the first
		// token which is our lookahead. The lookahead is
		// used for predictive parsing.
		this.lookahead = this.tokenizer.getNextToken();

		// Parse recursively starting from the main entry point
//		return this.parseAdditiveExpression();
		return this.parseProgram();
	}

	protected fflib_Tokenizer.Token eat(fflib_TokenKind tokenKind)
	{
		if (this.lookahead == null)
			throw new SyntaxException('Unexpected end of input, expected: "' + tokenKind.name() + '"');

		fflib_Tokenizer.Token token = this.lookahead.clone();

		if (token.tokenKind != tokenKind)
			throw new SyntaxException(
					String.format('Unexpected token: "{0}", expected "{1}"',
							new List<String>
							{
									token.tokenKind.name(),
									tokenKind.name()
							}));

		// Advance to next token.
		this.lookahead = this.tokenizer.getNextToken();

		return token;
	}

	protected AST parseLiteral()
	{
		switch on this.lookahead.tokenKind
		{
			when NULLx
			{
				return parseNull();
			}
			when NUMBERx
			{
				return parseNumber();
			}
			when STRINGx
			{
				return parseString();
			}
			when TRUEx
			{
				return parseBoolean(true);
			}
			when FALSEx
			{
				return parseBoolean(false);
			}
		}
		throw new SyntaxException('Literal: unexpected literal production');
	}

	/*
	 * AdditiveExpression
	 *  : MultiplicativeExpression
	 *  | AdditiveExpression ADDITIVE_OPERATOR Literal -> Literal ADDITIVE_OPERATOR Literal ADDITIVE_OPERATOR Literal
	 *  ;
	 */
	protected AST parseAdditiveExpression()
	{
		AST left = parseMultiplicativeExpression();
		while (this.lookahead != null && this.lookahead.tokenKind == fflib_TokenKind.ADDITIVE_OPERATOR)
		{
			fflib_Tokenizer.Token operator = eat(fflib_TokenKind.ADDITIVE_OPERATOR);

			AST right = parseMultiplicativeExpression();

			left = new BinaryExpression(operator, left, right);
		}
		return left;
	}

	/**
	 * AssignmentExpression
	 *  : LogicalORExpression
	 *  | LeftHandSideExpression AssignmentOperator AssignmentExpression
	 *  ;
	 *
	 * @return
	 */
	protected AST parseAssignmentExpression()
	{
		AST left = parseAdditiveExpression();

		if (ASSIGNMENT_OPERATORS.contains(this.lookahead.tokenKind) == false) return left;

		if (left.tokenKind != fflib_TokenKind.IDENTIFIER)
			throw new SyntaxException('Invalid left-hand side in assignment expression');

		return new AssignmentExpression(
				parseAssignmentOperator().value,
				(IdentifierX) left,
				parseAssignmentExpression()
		);
	}

	protected fflib_Tokenizer.Token parseAssignmentOperator()
	{
		if (this.lookahead.tokenKind == fflib_TokenKind.SIMPLE_ASSIGNMENT)
			return eat(fflib_TokenKind.SIMPLE_ASSIGNMENT);
		else
				return eat(fflib_TokenKind.COMPLEX_ASSIGNMENT);
	}

	protected AST parseBoolean(Boolean value)
	{
		fflib_Tokenizer.Token token = eat(value ? fflib_TokenKind.TRUEx : fflib_TokenKind.FALSEx);
		return new BooleanLiteral(token, value);
	}

	protected AST parseExpression()
	{
		return this.parseAssignmentExpression();
	}

	protected AST parseExpressionStatement()
	{
		AST expression = parseExpression();
		eat(fflib_TokenKind.SEMICOLON);
		return new ExpressionStatement(expression);
	}

	protected AST parseIdentifier()
	{
		return new IdentifierX(eat(fflib_TokenKind.IDENTIFIER).value);
	}

	protected AST parseLeftHandSideExpression()
	{
		return parseIdentifier();
	}

	protected AST parseMultiplicativeExpression()
	{
		AST left = parsePrimaryExpression();
		while (this.lookahead != null && this.lookahead.tokenKind == fflib_TokenKind.MULTIPLICATIVE_OPERATOR)
		{
			fflib_Tokenizer.Token operator = eat(fflib_TokenKind.MULTIPLICATIVE_OPERATOR);

			AST right = parsePrimaryExpression();

			left = new BinaryExpression(operator, left, right);
		}
		return left;
	}

	protected AST parseNull()
	{
		fflib_Tokenizer.Token token = eat(fflib_TokenKind.NULLx);
		return new NullLiteral();
	}

	protected AST parseNumber()
	{
		fflib_Tokenizer.Token token = eat(fflib_TokenKind.NUMBERx);
		return new NumericLiteral(token);
	}

	/**
	 * ParenthesizedExpression
	 *  :   '(' Expression ')'
	 *  ;
	 *
	 * @return
	 */
	protected AST parseParenthesizedExpression()
	{
		eat(fflib_TokenKind.PARENTHESES_OPEN);
		AST expression = this.parseExpression();
		eat(fflib_TokenKind.PARENTHESES_CLOSE);
		return expression;
	}

	protected AST parsePrimaryExpression()
	{
		if (LITERALS.contains(this.lookahead.tokenKind))
		{
			return parseLiteral();
		}

		switch on this.lookahead.tokenKind
		{
			when PARENTHESES_OPEN
			{
				return parseParenthesizedExpression();
			}
			when else
			{
				return parseLeftHandSideExpression();
			}
		}
	}

	/**
	 * Main entry point
	 *
	 * Program
	 *  : StatementList
	 *  ;
	 *
	 * @return
	 */
	protected AST parseProgram()
	{
		return new Program(
				parseStatementList()
		);
	}

	/**
	 * Statement
	 *  : ExpressionStatement
	 *  | BlockStatement
	 *  | EmptyStatement
	 *  | VariableStatement
	 *  | IfStatement
	 *  ;
	 *
	 * @return
	 */
	protected AST parseStatement()
	{
		switch on this.lookahead.tokenKind
		{
			when SEMICOLON
			{
				return new EmptyStatement();
			}
			when VARIABLE
			{
				return parseVariableStatement();

			}
			when else
			{
				return parseExpressionStatement();
			}
		}
	}

	/**
	 * StatementList
	 *  : Statement
	 *  | StatementList Statement -> Statement Statement Statement
	 *  ;
	 *
	 * @return
	 */
	protected List<AST> parseStatementList()
	{
		return parseStatementList(null);
	}
	protected List<AST> parseStatementList(fflib_TokenKind stopLookahead)
	{
		List<AST> result = new List<AST> {this.parseStatement()};

		while (this.lookahead != null && this.lookahead.tokenKind != stopLookahead)
		{
			result.add(this.parseStatement());
		}

		return result;
	}

	protected AST parseString()
	{
		fflib_Tokenizer.Token token = eat(fflib_TokenKind.STRINGx);
		return new StringLiteral(token);
	}

	protected AST parseVariableStatement()
	{
		eat(fflib_TokenKind.VARIABLE);
		List<VariableDeclaration> declarations = parseVariableDeclarationList();
		eat(fflib_TokenKind.SEMICOLON);
		return new VariableStatement(declarations);
	}

	protected VariableDeclaration parseVariableDeclaration()
	{
		AST identifier = parseIdentifier();

		AST initializer =
				(this.lookahead.tokenKind != fflib_TokenKind.COMMA
						&&
						this.lookahead.tokenKind != fflib_TokenKind.SEMICOLON)
				?
				parseVariableInitializer()
						:
						null;

		return new VariableDeclaration(
				(IdentifierX) identifier,
				initializer);
	}

	protected AST parseVariableInitializer()
	{
		eat(fflib_TokenKind.SIMPLE_ASSIGNMENT);
		return parseAssignmentExpression();
	}

	protected List<VariableDeclaration> parseVariableDeclarationList()
	{
		List<VariableDeclaration> result = new List<VariableDeclaration>();
		do {
			result.add(parseVariableDeclaration());
		} while (this.lookahead.tokenKind == fflib_TokenKind.COMMA && eat(fflib_TokenKind.COMMA) != null);
		return result;
	}


	public abstract class AST
	{
		protected fflib_TokenKind tokenKind;

		public fflib_TokenKind getTokenKind()
		{
			return this.tokenKind;
		}
	}

	public class AssignmentExpression extends AST
	{
		public IdentifierX left;
		public AST right;
		public String operator;

		public AssignmentExpression(String operator, IdentifierX left, AST right)
		{
			this.tokenKind = fflib_TokenKind.ASSIGNMENT_EXPRESSION;
			this.left = left;
			this.right = right;
			this.operator = operator;
		}
	}

	public class BinaryExpression extends AST
	{
		public String operator;
		public AST left;
		public AST right;

		public BinaryExpression(fflib_Tokenizer.Token operator, AST left, AST right)
		{
			this.tokenKind = fflib_TokenKind.BINARY_EXPRESSION;
			this.left = left;
			this.operator = operator.value;
			this.right = right;
		}
	}

	public class BooleanLiteral extends AST
	{
		public Boolean value;

		public BooleanLiteral(fflib_Tokenizer.Token token, Boolean value)
		{
			this.tokenKind = token.tokenKind;
			this.value = value;
		}
	}

	public class EmptyStatement extends AST
	{
		public EmptyStatement()
		{
			this.tokenKind = fflib_TokenKind.EMPTY_STATEMENT;
		}
	}

	public class ExpressionStatement extends AST
	{
		public AST expression;

		public ExpressionStatement(AST expression)
		{
			this.tokenKind = fflib_TokenKind.EXPRESSION_STATEMENT;
			this.expression = expression;
		}
	}

	public class IdentifierX extends AST
	{
		public String name;

		public IdentifierX(String name)
		{
			this.tokenKind = fflib_TokenKind.IDENTIFIER;
			this.name = name;
		}
	}

	public class NumericLiteral extends AST
	{
		public Double value;

		public NumericLiteral(fflib_Tokenizer.Token token)
		{
			this.tokenKind = token.tokenKind;
			this.value = Double.valueOf(token.value);
		}
	}

	public class NullLiteral extends AST
	{
		public NullLiteral()
		{
			this.tokenKind = fflib_TokenKind.NULLx;
		}
	}

	public class ObjectX extends AST
	{
		public Object value;

		public ObjectX(Object value)
		{
			this.tokenKind = fflib_TokenKind.OBJECTx;
			this.value = value;
		}
	}

	public class Program extends AST
	{
		public List<AST> statements;

		public Program(List<AST> statements)
		{
			this.tokenKind = fflib_TokenKind.PROGRAM;
			this.statements = statements;
		}
	}

	public class StringLiteral extends AST
	{
		public String value;

		public StringLiteral(fflib_Tokenizer.Token token)
		{
			this.tokenKind = token.tokenKind;
			this.value = String.valueOf(token.value);
			this.value = this.value.substring(1, this.value.length() - 1);
		}
	}

	public class VariableDeclaration extends AST
	{
		public IdentifierX identifier;
		public AST initializer;
		public VariableDeclaration(IdentifierX identifier, AST initializer)
		{
			this.tokenKind = fflib_TokenKind.VARIABLE_DECLARATION;
			this.identifier = identifier;
			this.initializer = initializer;
		}
	}

	public class VariableStatement extends AST
	{
		public List<VariableDeclaration> declarations;
		public VariableStatement(List<VariableDeclaration> declarations)
		{
			this.tokenKind = fflib_TokenKind.VARIABLE_STATEMENT;
			this.declarations = declarations;
		}
	}

	public class SyntaxException extends Exception
	{
	}
}