
public virtual class fflib_Compiler
{
	protected fflib_Parser.AST ast;
	protected Integer scopeDepth = 0;
	protected Map<Integer, Map<String, Object>> scope = new Map<Integer, Map<String, Object>>
	{
			0 => new Map<String, Object>()
	};


	public fflib_Compiler(fflib_Parser.AST ast)
	{
		this.ast = ast;
	}

	public Object run()
	{
		return compile(this.ast);
	}

	public Object compile(fflib_Parser.AST ast)
	{
		System.debug('Compiling: ' + ast.getTokenKind().name() + ' with State ' + JSON.serialize(this.scope));
		switch on ast.getTokenKind()
		{
			when ASSIGNMENT_EXPRESSION
			{
				return compileAssignmentExpression((fflib_Parser.AssignmentExpression) ast);
			}
			when BINARY_EXPRESSION
			{
				return compileBinaryExpression((fflib_Parser.BinaryExpression) ast);
			}
			when EXPRESSION_STATEMENT
			{
				return compileExpressionStatement((fflib_Parser.ExpressionStatement) ast);
			}
			when FALSEx
			{
				return false;
			}
			when IDENTIFIER
			{
				return compileIdentifier((fflib_Parser.IdentifierX) ast);
			}
			when NULLx
			{
				return null;
			}
			when NUMBERx
			{
				return compileNumber((fflib_Parser.NumericLiteral) ast);
			}
			when OBJECTx {
				return ((fflib_Parser.ObjectX) ast).value;
			}
			when STRINGx
			{
				return compileString((fflib_Parser.StringLiteral) ast);
			}
			when TRUEx
			{
				return true;
			}
			when VARIABLE_DECLARATION
			{
				return compileVariableDeclaration((fflib_Parser.VariableDeclaration) ast);
			}
			when VARIABLE_STATEMENT
			{
				return compileVariableStatement((fflib_Parser.VariableStatement) ast);
			}
			when PROGRAM
			{
				return compileProgram((fflib_Parser.Program) ast);
			}
		}

		throw new SyntaxException('Unexpected token: "' + ast.getTokenKind().name() + '"');
	}

	protected Object compileVariableDeclaration(fflib_Parser.VariableDeclaration variableDeclaration)
	{
		Object value = variableDeclaration.initializer == null ? null : compile(variableDeclaration.initializer);
		this.scope
				.get(this.scopeDepth)
				.put(variableDeclaration.identifier.name, value);
		return value;
	}

	protected Object compileVariableStatement(fflib_Parser.VariableStatement variableStatement)
	{
		Object result;
		for (Integer i = variableStatement.declarations.size() - 1; i >= 0; i--)
		{
			fflib_Parser.VariableDeclaration variableDeclaration = variableStatement.declarations.get(i);
			if (result != null) variableDeclaration.initializer = new fflib_Parser.ObjectX(result);
			result = compile(variableDeclaration);
		}
		return result;
	}

	protected Object compileAssignmentExpression(fflib_Parser.AssignmentExpression ast)
	{
		String variableName = ast.left.name;
		Object right = compile(ast.right);

		// Store variable
		Object variable = fetchVariable(variableName);

		switch on ast.operator
		{
			when '='
			{
				variable = right;
			}
		}
		return right;
	}

	protected Object fetchVariable(String variableName)
	{
		for (Integer i = this.scopeDepth; i >= 0; i--)
		{
			if (this.scope.get(i).containsKey(variableName))
				return this.scope.get(i).get(variableName);
		}
		throw new SyntaxException('Unknown variable name: ' + variableName);
	}

	protected Object compileBinaryExpression(fflib_Parser.BinaryExpression ast)
	{
		Object left = compile(ast.left);
		Object right = compile(ast.right);

		if ((left instanceof Integer) && (right instanceof Integer))
		{
			Integer leftInteger = Integer.valueOf(left);
			Integer rightInteger = Integer.valueOf(right);
			if (ast.operator == '+')
			{
				return leftInteger + rightInteger;
			}
			else if (ast.operator == '-')
			{
				return leftInteger - rightInteger;
			}
			else if (ast.operator == '*')
			{
				return leftInteger * rightInteger;
			}
			else if (ast.operator == '/')
			{
				return leftInteger / rightInteger;
			}
			else throw new SyntaxException('Binary Expression: Unexpected operator "' + ast.operator + '"');
		}
		else if ((left instanceof Double) || (right instanceof Double))
		{
			Double leftDouble = Double.valueOf(left);
			Double rightDouble = Double.valueOf(right);
			if (ast.operator == '+')
			{
				return leftDouble + rightDouble;
			}
			else if (ast.operator == '-')
			{
				return leftDouble - rightDouble;
			}
			else if (ast.operator == '*')
			{
				return leftDouble * rightDouble;
			}
			else if (ast.operator == '/')
			{
				return leftDouble / rightDouble;
			}
			else throw new SyntaxException('Binary Expression: Unexpected operator "' + ast.operator + '"');
		}
		else throw new SyntaxException('Binary Expression: Unexpected type of left of right hand');
	}

	protected Object compileExpressionStatement(fflib_Parser.ExpressionStatement ast)
	{
		return compile(ast.expression);
	}

	protected Object compileIdentifier(fflib_Parser.IdentifierX ast)
	{
		return fetchVariable(ast.name);
	}

	protected Object compileNumber(fflib_Parser.NumericLiteral ast)
	{
		return ast.value;
	}

	protected Object compileProgram(fflib_Parser.Program ast)
	{
		Object result;
		for (fflib_Parser.AST statement : ast.statements)
		{
			result = compile(statement);
		}
		return result; // Returns result of last statement.
	}

	protected Object compileString(fflib_Parser.StringLiteral ast)
	{
		return ast.value;
	}

	public class SyntaxException extends Exception
	{
	}
}