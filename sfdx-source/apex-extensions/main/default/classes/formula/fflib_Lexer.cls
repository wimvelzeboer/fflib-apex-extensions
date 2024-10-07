/**
 * File Name: fflib_Formula
 * @description A formula evaluator
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
public virtual with sharing class fflib_Lexer
{
	private Map<LexerTokenType, Pattern> patternsByTokens = new Map<LexerTokenType, Pattern>
	{
			LexerTokenType.INTEGERx => Pattern.compile('^-?(?<![\\d.])[0-9]+(?![\\d.])'),
			LexerTokenType.FLOATx => Pattern.compile('^(-?[0-9]+\\.[0-9]+)'),
			LexerTokenType.STRINGx => Pattern.compile('^".*?"(?<!\\\\")'),
			LexerTokenType.PLUS => Pattern.compile('^\\+')
	};

	protected String codeBlock;

	public fflib_Lexer(String codeBlock)
	{
		this.codeBlock = codeBlock;
	}

	public List<Token> parse()
	{
		List<Token> result = new List<Token>();
		while (codeBlock.length() > 0)
		{
			Token token;
			for (LexerTokenType tokenType : patternsByTokens.keySet())
			{
				Matcher matcher = patternsByTokens.get(tokenType).matcher(codeBlock);
				if (matcher.find())
				{
					String match = matcher.group();
					token = new Token(tokenType, match);
					this.codeBlock = this.codeBlock.right(this.codeBlock.length() - match.length());
					break;
				}
			}
			if (token == null) throw new LexerException('Unknown token: ' + codeBlock.left(10) + '...');

			result.add(token);
		}
		return result;
	}

	public class Token
	{
		public LexerTokenType tokenType;
		public String value;

		public Token(LexerTokenType tokenType, String value)
		{
			this.tokenType = tokenType;
			this.value = value;
		}
	}

	public enum LexerTokenType
	{
		FLOATx,
		INTEGERx,
		STRINGx,
		PLUS
	}

	public class LexerException extends Exception {}
}

/**
*
sfdeploy \
--source-dir sfdx-source/apex-extensions/tests/classes/formula/fflib_FormulaTest.cls \
--source-dir sfdx-source/apex-extensions/tests/classes/formula/fflib_ParserTest.cls \
--source-dir sfdx-source/apex-extensions/main/default/classes/formula/fflib_formula.cls \
--source-dir sfdx-source/apex-extensions/main/default/classes/formula/fflib_TokenKind.cls \
--source-dir sfdx-source/apex-extensions/main/default/classes/formula/fflib_Tokenizer.cls \
--source-dir sfdx-source/apex-extensions/main/default/classes/formula/fflib_Parser.cls \
--source-dir sfdx-source/apex-extensions/main/default/classes/formula/fflib_Compiler.cls

*
*
*/