
public virtual class fflib_Compiler
{
	protected fflib_Parser.AST ast;
	protected Integer scopeDepth;
	protected Map<Integer, Map<String, Object>> scope;

	private static final Map<String, fflib_Operator> OPERATORS = new Map<String, fflib_Operator>
	{
			'==' => fflib_Operator.EQUALS,
			'>' => fflib_Operator.GREATER_THAN,
			'<' => fflib_Operator.LESS_THAN
	};

	public fflib_Compiler(fflib_Parser.AST ast)
	{
		this.scopeDepth = 1;
		this.scope = new Map<Integer, Map<String, Object>>
		{
				0 => new Map<String, Object>(),
				1 => new Map<String, Object>()
		};
		this.ast = ast;
	}

	public fflib_Compiler(fflib_Parser.AST ast, Map<String, Object> vars)
	{
		this.scopeDepth = 1;
		this.scope = new Map<Integer, Map<String, Object>>
		{
				0 => vars,
				1 => new Map<String, Object>()
		};
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
			when BLOCK_STATEMENT
			{
				return compileBlockStatement((fflib_Parser.BlockStatement) ast);
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
			when IF_STATEMENT
			{
				return compileIfStatement((fflib_Parser.IfStatement) ast);
			}
			when FOR_STATEMENT
			{
				return compileForStatement((fflib_Parser.ForStatement) ast);
			}
			when FOR_OBJECT_STATEMENT
			{
				return compileForObjectStatement((fflib_Parser.ForObjectStatement) ast);
			}
			when LOGICAL_EXPRESSION
			{
				return compileLogicalExpression((fflib_Parser.LogicalExpression) ast);
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
			when UNARY_EXPRESSION
			{
				return compileUnaryExpression((fflib_Parser.UnaryExpression) ast);
			}
			when VARIABLE_DECLARATION
			{
				return compileVariableDeclaration((fflib_Parser.VariableDeclaration) ast);
			}
			when VARIABLE_STATEMENT
			{
				return compileVariableStatement((fflib_Parser.VariableStatement) ast);
			}
			when WHILE_STATEMENT
			{
				return compileWhileStatement((fflib_Parser.WhileStatement) ast);
			}
			when PROGRAM
			{
				return compileProgram((fflib_Parser.Program) ast);
			}
		}

		throw new SyntaxException('Unexpected token: "' + ast.getTokenKind().name() + '"');
	}

	protected Object compileForObjectStatement(fflib_Parser.ForObjectStatement statement)
	{
		addScopeDepth();
		compile(statement.variable);
		String variableName = statement.variable.identifier.name;

		Object variableValue = fetchVariable(variableName);

		if ((variableValue instanceof List<SObject>) == false)
			throw new SyntaxException('Require an iterable value for a FOR loop');

		Object result;
		for (SObject record : (List<SObject>) variableValue)
		{
			addScopeDepth(new Map<String, Object>
			{
					variableName => record.getPopulatedFieldsAsMap()
			});
			result = compile(statement.body);

			dropScope();
		}
		dropScope();
		return result;
	}

	protected Object compileForStatement(fflib_Parser.ForStatement statement)
	{
		Object result;
		addScopeDepth();
		compile(statement.init);
		while (Boolean.valueOf(compile(statement.condition)))
		{
			System.debug('-- For body --- ');
			result = compile(statement.body);

			System.debug('-- For updater --- ');
			compile(statement.updater);
		}
		dropScope();
		return result;
	}

	protected Object compileWhileStatement(fflib_Parser.WhileStatement statement)
	{
		Object result;
		if (statement.testConditionFirst)
			while (Boolean.valueOf(compile(statement.condition)))
			{
				result = compile(statement.body);
			}
		else
				do
				{
					result = compile(statement.body);
				}
				while (Boolean.valueOf(compile(statement.condition)));
		return result;
	}

	protected Object compileUnaryExpression(fflib_Parser.UnaryExpression expression)
	{
		Object argument = compile(expression.argument);
		switch on expression.operatorKind
		{
			when ADDITIVE_OPERATOR
			{
				if (expression.operator == '-')
				{
					if (argument instanceof Integer) return -Integer.valueOf(argument);
					else if (argument instanceof Long) return -Long.valueOf(String.valueOf(argument));
					else if (argument instanceof Double) return -Double.valueOf(argument);
					else if (argument instanceof Decimal) return -Decimal.valueOf(Double.valueOf(argument));
					else throw new SyntaxException('Unary expression failed for argument. Expected Integer, Long, Double or Decimal');

				}
				else if (expression.operator == '+')
				{
					if (argument instanceof Integer) return +Integer.valueOf(argument);
					else if (argument instanceof Long) return +Long.valueOf(String.valueOf(argument));
					else if (argument instanceof Double) return +Double.valueOf(argument);
					else if (argument instanceof Decimal) return +Decimal.valueOf(Double.valueOf(argument));
					else throw new SyntaxException('Unary expression failed for argument. Expected Integer, Long, Double or Decimal');
				}
			}
			when LOGICAL_NOT
			{
				if (argument instanceof Boolean) return !Boolean.valueOf(argument);
				else throw new SyntaxException('Unary expression failed for argument. Expected Boolean');
			}
		}

		throw new SyntaxException('Unary expression failed for provided operator');
	}

	protected Object compileLogicalExpression(fflib_Parser.LogicalExpression expression)
	{
		Boolean left = Boolean.valueOf(compile(expression.left));
		Boolean right = Boolean.valueOf(compile(expression.right));
		switch on expression.operator
		{
			when LOGICAL_AND
			{
				return left && right;
			}
			when LOGICAL_OR
			{
				return left || right;
			}
			when else
			{
				throw new SyntaxException('Unknown Logical Operator');
			}
		}
	}

	protected Object compileIfStatement(fflib_Parser.IfStatement ifStatement)
	{
		Object result;
		Object condition = compile(ifStatement.condition);
		if ((condition instanceof Boolean) == false)
			throw new SyntaxException('IF conditions require a boolean expression');

		if (Boolean.valueOf(condition))
		{
			result = compile(ifStatement.consequent);
		}
		else if (ifStatement.alternate != null)
		{
			result = compile(ifStatement.alternate);
		}

		return result;
	}

	protected Object compileBlockStatement(fflib_Parser.BlockStatement blockStatement)
	{
		// Add scope for variables
		addScopeDepth();

		Object result;
		for (fflib_Parser.AST statement : blockStatement.body)
		{
			result = compile(statement);
		}

		// Drop variables of scope;
		dropScope();
		return result;
	}

	private void dropScope()
	{
		this.scope.remove(this.scopeDepth);
		this.scopeDepth--;
	}

	private void addScopeDepth()
	{
		this.scopeDepth++;
		this.scope.put(this.scopeDepth, new Map<String, Object>());
	}

	private void addScopeDepth(Map<String, Object> vars)
	{
		this.scopeDepth++;
		this.scope.put(this.scopeDepth, vars);
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
			when '+='
			{
				if (variable instanceof Integer) variable = Integer.valueOf(variable) + Integer.valueOf(right);
				else if (variable instanceof Long) variable = Long.valueOf(String.valueOf(variable)) + Long.valueOf(String.valueOf(right));
				else if (variable instanceof Double) variable = Double.valueOf(variable) + Double.valueOf(right);
				else if (variable instanceof Decimal) variable = Decimal.valueOf(Double.valueOf(variable)) + Decimal.valueOf(Double.valueOf(right));
				else throw new SyntaxException('Unary expression failed for argument. Expected Integer, Long, Double or Decimal');
			}
			when '-='
			{
				if (variable instanceof Integer) variable = Integer.valueOf(variable) - Integer.valueOf(right);
				else if (variable instanceof Long) variable = Long.valueOf(String.valueOf(variable)) - Long.valueOf(String.valueOf(right));
				else if (variable instanceof Double) variable = Double.valueOf(variable) - Double.valueOf(right);
				else if (variable instanceof Decimal) variable = Decimal.valueOf(Double.valueOf(variable)) - Decimal.valueOf(Double.valueOf(right));
				else throw new SyntaxException('Unary expression failed for argument. Expected Integer, Long, Double or Decimal');
			}
			when else
			{
				throw new SyntaxException('Unknown assignment operator: ' + ast.operator);
			}
		}
		updateVariable(variableName, variable);
		return variable;
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

	protected void updateVariable(String variableName, Object value)
	{
		System.debug('Setting variable: ' + variableName + ' => ' + value);
		for (Integer i = this.scopeDepth; i >= 0; i--)
		{
			if (this.scope.get(i).containsKey(variableName))
			{
				this.scope.get(i).put(variableName, value);
				return;
			}
		}
		throw new SyntaxException('Unknown variable name: ' + variableName);
	}

	protected Object compileBinaryExpression(fflib_Parser.BinaryExpression ast)
	{
		Object left = compile(ast.left);
		Object right = compile(ast.right);

		// Relational
		if (OPERATORS.containsKey(ast.operator))
			return fflib_Comparator.compareTo(left, OPERATORS.get(ast.operator), right);

		// Mathematical
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
		if (ast.relatedIdentifier == null ) return fetchVariable(ast.name);

		Object obj = fetchVariable(ast.name);

		Map<String, Object> fieldsMap;

		if (obj instanceof fflib_formula.IObject)
		{
			fieldsMap = ((fflib_formula.IObject) obj).getPopulatedFieldsAsMap();
		}
		else if (obj instanceof SObject)
		{
			fieldsMap = ((SObject) obj).getPopulatedFieldsAsMap();
		}
		else if (obj instanceof Map<String,Object>) {
			fieldsMap = (Map<String, Object>) obj;
		}
		else throw new SyntaxException('Identifier related fields can only use SObjects or instance of fflib_formula.IObject');

		addScopeDepth(fieldsMap);
		Object result = compileIdentifier(ast.relatedIdentifier);
		dropScope();
		return result;
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