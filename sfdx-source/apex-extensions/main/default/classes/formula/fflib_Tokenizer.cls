public virtual class fflib_Tokenizer
{
	private Map<Pattern, fflib_TokenKind> specifications = new Map<Pattern, fflib_TokenKind>
	{
			Pattern.compile('^\\s+') => null,

			//--------------------------------------------------------------
			// Comments:

			// Skip single-line comments:
			Pattern.compile('^\\/\\/.*') => null,

			// Skip multi-line comments:
			Pattern.compile('^\\/\\*[\\s\\S]*?\\*\\/') => null,

			//--------------------------------------------------------------
			// Symbols, delimiters:
			Pattern.compile('^\\.') => fflib_TokenKind.DOT,
			Pattern.compile('^,') => fflib_TokenKind.COMMA,
			Pattern.compile('^;') => fflib_TokenKind.SEMICOLON,
			Pattern.compile('^:') => fflib_TokenKind.COLON,
			Pattern.compile('^\\{') => fflib_TokenKind.CURLY_BRACKET_OPEN,
			Pattern.compile('^\\}') => fflib_TokenKind.CURLY_BRACKET_CLOSE,
			Pattern.compile('^\\(') => fflib_TokenKind.PARENTHESES_OPEN,
			Pattern.compile('^\\)') => fflib_TokenKind.PARENTHESES_CLOSE,

			//--------------------------------------------------------------
			// Keywords
			Pattern.compile('^(?i)\\belse\\b') => fflib_TokenKind.ELSEx,
			Pattern.compile('^(?i)\\bif\\b') => fflib_TokenKind.IFx,
			Pattern.compile('^(?i)\\bfalse\\b') => fflib_TokenKind.FALSEx,
			Pattern.compile('^(?i)\\blet\\b') => fflib_TokenKind.VARIABLE,
			Pattern.compile('^(?i)\\bnull\\b') => fflib_TokenKind.NULLx,
			Pattern.compile('^(?i)\\btrue\\b') => fflib_TokenKind.TRUEx,
			Pattern.compile('^(?i)\\band\\b') => fflib_TokenKind.LOGICAL_AND,
			Pattern.compile('^(?i)\\bor\\b') => fflib_TokenKind.LOGICAL_OR,
			Pattern.compile('^(?i)\\bdo\\b') => fflib_TokenKind.DOx,
			Pattern.compile('^(?i)\\bfor\\b') => fflib_TokenKind.FORx,
			Pattern.compile('^(?i)\\bwhile\\b') => fflib_TokenKind.WHILEx,

			//--------------------------------------------------------------
			// Numbers:
			Pattern.compile('^(-?[0-9]+(\\.[0-9])*)') => fflib_TokenKind.NUMBERx,

			//--------------------------------------------------------------
			// Identifiers:
			Pattern.compile('^\\w+') => fflib_TokenKind.IDENTIFIER,

			//--------------------------------------------------------------
			// Identifiers:
//			Pattern.compile('^\\w+(\\.\\w+)*') => fflib_TokenKind.IDENTIFIER,

			//--------------------------------------------------------------
			// Equality operators: ==. !=
			Pattern.compile('^[=!]=') => fflib_TokenKind.EQUALITY_OPERATOR,

			//--------------------------------------------------------------
			// Assignment operator: =, *=, /=, +=, -=
			Pattern.compile('^=') => fflib_TokenKind.SIMPLE_ASSIGNMENT,
			Pattern.compile('^[\\*\\/\\+\\-]=') => fflib_TokenKind.COMPLEX_ASSIGNMENT,

			//--------------------------------------------------------------
			// Math operators: +, -, *, /
			Pattern.compile('^[+\\-]') => fflib_TokenKind.ADDITIVE_OPERATOR,
			Pattern.compile('^[*\\/]') => fflib_TokenKind.MULTIPLICATIVE_OPERATOR,

			//--------------------------------------------------------------
			// Relational operators: >, >=, <, <=
			Pattern.compile('^[><]=?') => fflib_TokenKind.RELATIONAL_OPERATOR,

			//--------------------------------------------------------------
			// Logical operators: &&, ||
			Pattern.compile('^&&') => fflib_TokenKind.LOGICAL_AND,
			Pattern.compile('^\\|\\|') => fflib_TokenKind.LOGICAL_OR,
			Pattern.compile('^!') => fflib_TokenKind.LOGICAL_NOT,

			//--------------------------------------------------------------
			// Strings:
			Pattern.compile('^".*?"(?<!\\\\")') => fflib_TokenKind.STRINGx,
			Pattern.compile('^\'.*?\'(?<!\\\\")') => fflib_TokenKind.STRINGx
	};

	protected String input;
	protected Integer pointer;
	protected Integer line;
	protected Integer position;

	public fflib_Tokenizer(String input)
	{
		this.input = input;
		this.pointer = 0;
		this.line = 1;
		this.position = 0;
	}

	public Boolean hasMoreTokens()
	{
		return this.pointer < this.input.length();
	}

	public Token getNextToken()
	{
		if (this.hasMoreTokens() == false) {
			System.debug('No more tokens');
			return null;
		}

		String codeBlock = this.input.substring(this.pointer);

		for (Pattern pattern : specifications.keySet())
		{
			String tokenValue = match(pattern, codeBlock);
			if (tokenValue == null) continue; // Couldn't match the pattern

			fflib_TokenKind tokenKind = specifications.get(pattern);


			// Should skip token, e.g. whitespaces or comments
			if (tokenKind == null) {
				advancePosition(tokenValue);
				return getNextToken();
			}

			Token result = new Token(tokenKind, tokenValue, this.line, this.position);
			advancePosition(tokenValue);
			return result;
		}

		throw newSyntaxException('Unexpected token at: "' + codeBlock.left(10) + '"');
	}

	private void advancePosition(String tokenValue)
	{
		Integer newLineCharacters = tokenValue.countMatches('\n');
		if (newLineCharacters > 0)
		{
			this.line += newLineCharacters;
			this.position = 0;
		}
		else
		{
			this.position += tokenValue.length();
		}
	}

	protected String match(Pattern pattern, String codeBlock)
	{
		Matcher matcher = pattern.matcher(codeBlock);
		if (matcher.find())
		{
			String match = matcher.group();
			this.pointer += match.length();
			return match;
		}
		return null;
	}

	protected SyntaxException newSyntaxException(String message)
	{
		return new SyntaxException(
		String.format(
				'{2} ({0}:{1})',
				new List<String>
				{
						String.valueOf(this.line),
						String.valueOf(this.position),
						message
				}));
	}

	public class Token
	{
		public fflib_TokenKind tokenKind;
		public String value;
		public Integer line;
		public Integer position;

		public Token(fflib_TokenKind tokenKind, String value, Integer line, Integer position)
		{
			System.debug('New Token: ' + line + ':' + position + ' ' + tokenKind + ' ' + value);
			this.tokenKind = tokenKind;
			this.value = value;
			this.line = line;
			this.position = position;
		}
	}

    public class SyntaxException extends Exception{ }
}