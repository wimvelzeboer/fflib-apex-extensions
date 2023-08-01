global virtual class fflib_HttpException extends Exception
{
	protected fflib_HttpProblem problems;

	global fflib_HttpException(Integer statusCode)
	{
		this(statusCode, fflib_HttpStatusCode.getTitle(statusCode));
	}

	global fflib_HttpException(Integer statusCode, String title)
	{
		this(statusCode, title, null);
	}

	global fflib_HttpException(Integer statusCode, String title, String detail)
	{
		this.problems =
				new fflib_HttpProblem()
						.setStatus(statusCode)
						.setTitle(title)
						.setDetail(detail);

		addMessage(
				String.valueOf(statusCode)
				+ (String.isNotBlank(title) ? + ' - ' + title : '')
				+ (String.isNotBlank(detail) ? ', ' + detail : '')
		);
	}

	global fflib_HttpException addProblem(Integer statusCode)
	{
		return this.addProblem(statusCode, fflib_HttpStatusCode.getTitle(statusCode));
	}

	global fflib_HttpException addProblem(Integer statusCode, String title)
	{
		return this.addProblem(statusCode, title, null);
	}

	global fflib_HttpException addProblem(Integer statusCode, String title, String detail)
	{
		this.problems.addNextProblem()
				.setStatus(statusCode)
				.setTitle(title)
				.setDetail(detail);

		addMessage(
				String.valueOf(statusCode)
						+ (String.isNotBlank(title) ? + ' - ' + title : '')
						+ (String.isNotBlank(detail) ? ': ' + detail : '')
		);
		return this;
	}

	global List<fflib_HttpProblemDetail> getProblemDetails()
	{
		return this.problems.getProblemDetails();
	}

	global String getUuid()
	{
		return this.problems.getUuid();
	}

	/**
	 * Set a URI reference that identifies the specific occurrence of the problem.
	 *
	 * @param instance URI reference to the problem location
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpException setInstance(String instance)
	{
		this.problems.setInstance(instance);
		return this;
	}

	/**
	 * Sets the URI reference [RFC3986] that identifies the problem type.
	 * This specification encourages that, when dereferenced,
	 * it provide human-readable documentation for the problem type
	 * (e.g., using HTML [W3C.REC-html5-20141028]).
	 * When this member is not present, its value is assumed to be "about:blank".
	 *
	 * @param type URI to human-readable documentation of the occurred problem
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpException setType(String type)
	{
		this.problems.setType(type);
		return this;
	}

	/**
	 * @return Returns a RFC-7807 Json object
	 */
	global String toJson()
	{
		return JSON.serialize(this.problems);
	}

	global String toPrettyJson()
	{
		return JSON.serializePretty(this.problems);
	}

	global Blob toJsonBlob()
	{
		return Blob.valueOf(toJson());
	}

	global void addToRestResponse()
	{
		RestResponse response = RestContext.response;
		if (response == null)
		{
			response = new RestResponse();
			RestContext.response = response;
		}

		response.statusCode = this.problems.getProblemDetails().get(0)?.status;
		response.responseBody = this.toJsonBlob();
	}

	protected void addMessage(String message)
	{
		if (this.problems.getProblemDetails().size() > 1)
		{

			setMessage(getMessage() + ', ' + message);
		}
		else
		{
			setMessage(message);
		}
	}
}