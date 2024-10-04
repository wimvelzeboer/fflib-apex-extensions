/**
 * A formula evaluator
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
public virtual class fflib_formula
{
	protected List<SObject> records;
	protected String formula;
	protected Object result;


//	Pattern.compile('^SUM');

	public fflib_formula(String formula)
	{
		this.records = new List<SObject>();
		this.formula = formula;
	}

	public fflib_formula(List<SObject> records, String formula)
	{
		this.records = records;
		this.formula = formula;
	}

	public fflib_formula evaluate()
	{
		if (String.isBlank(this.formula))
		{
			this.result = null;
			return this;
		}

		// fixme - inline code and remove debug statement
		fflib_Parser.AST ast = new fflib_Parser(this.formula)
				.run();
		System.debug(JSON.serializePretty(ast));

		this.result = new fflib_Compiler(
				ast)
				.run();

		return this;
	}

	public virtual String getFormula()
	{
		return this.formula;
	}

	public virtual Object getValue()
	{
		return this.result;
	}

	public Boolean toBoolean()
	{
		return Boolean.valueOf(this.result);
	}

	public Double toDouble()
	{
		return Double.valueOf(this.result);
	}

	public Integer toInteger()
	{
		return Integer.valueOf(this.result);
	}

	public override String toString()
	{
		return String.valueOf(this.result);
	}


	public class SyntaxException extends Exception
	{
	}
}