@IsTest
private class fflib_HttpExceptionTest
{
	@IsTest
	static void itShouldThrowExceptionWithOnlyHttpSResponseStatusCode()
	{
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST);
		}
		catch (fflib_HttpException e)
		{
			final List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(1, problemDetails.size(), 'Expected only one problem');
			final fflib_HttpProblemDetail problem = problemDetails.get(0);
			System.Assert.areEqual(400, problem.status, 'Incorrect returned http response status code');
			System.Assert.areEqual(
					fflib_HttpStatusCode.getTitle(400),
					problem.title,
					'Incorrect returned http response status title');
			System.Assert.isNull(problem.detail, 'Expected problem detail to be blank');
			System.Assert.isNull(problem.instance, 'Expected problem instance to be blank');
			System.Assert.isNull(problem.type, 'Expected problem type to be blank');
			System.Assert.areEqual(
					'400 - ' + fflib_HttpStatusCode.getTitle(400),
					e.getMessage(),
					'Incorrect returned exception message'
			);
			System.Assert.isTrue(fflib_Uuid.isValid(e.getUuid()), 'Invalid Uuid');
		}
	}

	@IsTest
	static void itShouldThrowExceptionWithStatusCodeAndCustomTitle()
	{
		final String myTitle = 'My Error message Title';
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST, myTitle);
		}
		catch (fflib_HttpException e)
		{
			final List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(1, problemDetails.size(), 'Expected only one problem');
			final fflib_HttpProblemDetail problem = problemDetails.get(0);
			System.Assert.areEqual(400, problem.status, 'Incorrect returned http response status code');
			System.Assert.areEqual(
					myTitle,
					problem.title,
					'Incorrect returned http response status title');
			System.Assert.isNull(problem.detail, 'Expected problem detail to be blank');
			System.Assert.isNull(problem.instance, 'Expected problem instance to be blank');
			System.Assert.isNull(problem.type, 'Expected problem type to be blank');
			System.Assert.areEqual(
					'400 - ' + myTitle,
					e.getMessage(),
					'Incorrect returned exception message'
			);
		}
	}

	@IsTest
	static void itShouldThrowExceptionWithStatusCodeAndCustomTitleAndDetail()
	{
		final String myTitle = 'My Error message Title';
		final String myDetail = 'Very lengthy description of the error';
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST, myTitle, myDetail);
		}
		catch (fflib_HttpException e)
		{
			final List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(1, problemDetails.size(), 'Expected only one problem');
			final fflib_HttpProblemDetail problem = problemDetails.get(0);
			System.Assert.areEqual(400, problem.status, 'Incorrect returned http response status code');
			System.Assert.areEqual(
					myTitle,
					problem.title,
					'Incorrect returned http response status title');
			System.Assert.areEqual(
					myDetail,
					problem.detail,
					'Incorrect returned problem detail');
			System.Assert.isNull(problem.instance, 'Expected problem instance to be blank');
			System.Assert.isNull(problem.type, 'Expected problem type to be blank');
			System.Assert.areEqual(
					'400 - ' + myTitle + ', ' + myDetail,
					e.getMessage(),
					'Incorrect returned exception message'
			);
		}
	}

	@IsTest
	static void itShouldThrowExceptionWithInstance()
	{
		final String instanceUri = '/somewhere/over/the/rainbow';
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST)
					.setInstance(instanceUri);
		}
		catch (fflib_HttpException e)
		{
			final List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(1, problemDetails.size(), 'Expected only one problem');
			final fflib_HttpProblemDetail problem = problemDetails.get(0);
			System.Assert.areEqual(400, problem.status, 'Incorrect returned http response status code');
			System.Assert.areEqual(
					fflib_HttpStatusCode.getTitle(400),
					problem.title,
					'Incorrect returned http response status title');
			System.Assert.isNull(problem.detail, 'Expected problem instance to be blank');
			System.Assert.areEqual(instanceUri, problem.instance, 'Incorrect returned problem instance');
			System.Assert.isNull(problem.type, 'Expected problem type to be blank');
			System.Assert.areEqual(
					'400 - ' + fflib_HttpStatusCode.getTitle(400),
					e.getMessage(),
					'Incorrect returned exception message'
			);
		}
	}

	@IsTest
	static void itShouldThrowException()
	{
		final String myTitle = 'My Error message Title';
		final String myDetail = 'Very lengthy description of the error';
		final String instanceUri = '/somewhere/over/the/rainbow';
		final String typeUri = '/somewhere/very/knowledgeable';
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST, myTitle, myDetail)
					.setInstance(instanceUri)
					.setType(typeUri);
		}
		catch (fflib_HttpException e)
		{
			final List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(1, problemDetails.size(), 'Expected only one problem');
			final fflib_HttpProblemDetail problem = problemDetails.get(0);
			System.Assert.areEqual(400, problem.status, 'Incorrect returned http response status code');
			System.Assert.areEqual(myTitle, problem.title, 'Incorrect returned http response status title');
			System.Assert.areEqual(myDetail, problem.detail, 'Incorrect returned problem detail');
			System.Assert.areEqual(instanceUri, problem.instance, 'Incorrect returned problem instance');
			System.Assert.areEqual(typeUri, problem.type, 'Incorrect returned problem type');
			System.Assert.areEqual(
					'400 - ' + myTitle + ', ' + myDetail,
					e.getMessage(),
					'Incorrect returned exception message'
			);
		}
	}

	@IsTest
	static void itShouldThrowExceptionWithMultipleProblems()
	{
		try
		{
			throw new fflib_HttpException(fflib_HttpStatusCode.CLIENT_ERROR_BAD_REQUEST)
					.addProblem(fflib_HttpStatusCode.CLIENT_ERROR_METHOD_NOT_ALLOWED);
		}
		catch (fflib_HttpException e)
		{
			List<fflib_HttpProblemDetail> problemDetails = e.getProblemDetails();
			System.Assert.areEqual(2, problemDetails.size(), 'Expected only one firstProblem');
			final fflib_HttpProblemDetail firstProblem = problemDetails.get(0);
			System.Assert.areEqual(400, firstProblem.status, 'Incorrect returned http response status code for first problem');
			final fflib_HttpProblemDetail secondProblem = problemDetails.get(1);
			System.Assert.areEqual(405, secondProblem.status, 'Incorrect returned http response status code for second problem');
			System.Assert.areEqual(
					'400 - ' + fflib_HttpStatusCode.getTitle(400) +
					', 405 - ' + fflib_HttpStatusCode.getTitle(405),
					e.getMessage(),
					'Incorrect returned exception message'
			);
		}
	}
}