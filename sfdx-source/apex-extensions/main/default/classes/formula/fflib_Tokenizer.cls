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
			Pattern.compile('^,') => fflib_TokenKind.COMMA,
			Pattern.compile('^;') => fflib_TokenKind.SEMICOLON,
			Pattern.compile('^\\(') => fflib_TokenKind.PARENTHESES_OPEN,
			Pattern.compile('^\\)') => fflib_TokenKind.PARENTHESES_CLOSE,

			//--------------------------------------------------------------
			// Keywords
			Pattern.compile('^\\blet\\b') => fflib_TokenKind.VARIABLE,
			Pattern.compile('^\\btrue\\b') => fflib_TokenKind.TRUEx,
			Pattern.compile('^\\bfalse\\b') => fflib_TokenKind.FALSEx,
			Pattern.compile('^\\bnull\\b') => fflib_TokenKind.NULLx,

			//--------------------------------------------------------------
			// Numbers:
			Pattern.compile('^(-?[0-9]+(\\.[0-9])*)') => fflib_TokenKind.NUMBERx,

			//--------------------------------------------------------------
			// Identifiers:
			Pattern.compile('^\\w+') => fflib_TokenKind.IDENTIFIER,

			//--------------------------------------------------------------
			// Identifiers:
			Pattern.compile('^\\w+(\\.\\w+)*') => fflib_TokenKind.IDENTIFIER,

			//--------------------------------------------------------------
			// Assignment operator: =, *=, /=, +=, -=
			Pattern.compile('^=') => fflib_TokenKind.SIMPLE_ASSIGNMENT,
			Pattern.compile('^[\\*\\/\\+\\-]=') => fflib_TokenKind.COMPLEX_ASSIGNMENT,

			//--------------------------------------------------------------
			// Math operators: +, -, *, /

			Pattern.compile('^[+\\-]') => fflib_TokenKind.ADDITIVE_OPERATOR,
			Pattern.compile('^[*\\/]') => fflib_TokenKind.MULTIPLICATIVE_OPERATOR,

			//--------------------------------------------------------------
			// Strings:
			Pattern.compile('^".*?"(?<!\\\\")') => fflib_TokenKind.STRINGx,
			Pattern.compile('^\'.*?\'(?<!\\\\")') => fflib_TokenKind.STRINGx
	};

	protected String input;
	protected Integer pointer;

	public fflib_Tokenizer(String input)
	{
		this.input = input;
		this.pointer = 0;
	}

	public Boolean isEOF()
	{
		return this.pointer == this.input.length();
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
				return getNextToken();
			}

			return new Token(tokenKind, tokenValue);
		}

		throw new SyntaxException('Unexpected token at: "' + codeBlock.left(10) + '"');
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

	public class Token
	{
		public fflib_TokenKind tokenKind;
		public String value;

		public Token(fflib_TokenKind tokenKind, String value)
		{
			System.debug('New Token: ' + tokenKind + ' ' + value);
			this.tokenKind = tokenKind;
			this.value = value;
		}
	}

    public class SyntaxException extends Exception {}
}