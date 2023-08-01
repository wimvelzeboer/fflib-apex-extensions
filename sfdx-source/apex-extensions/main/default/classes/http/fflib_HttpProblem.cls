global virtual class fflib_HttpProblem
{
	protected List<fflib_HttpProblemDetail> errors;

	// A uuid that can only be set once
	protected final String uuid { get; set; }

	global fflib_HttpProblem()
	{
		this.errors = new List<fflib_HttpProblemDetail> {new fflib_HttpProblemDetail()};
		this.uuid = new fflib_Uuid().getValue();
	}


	global fflib_HttpProblem addNextProblem()
	{
		this.errors.add(new fflib_HttpProblemDetail());
		return this;
	}

	global List<fflib_HttpProblemDetail> getProblemDetails()
	{
		return this.errors;
	}

	global String getUuid()
	{
		return this.uuid;
	}

	/**
	 * Set a human-readable explanation specific to this occurrence of the problem.
	 *
	 * @param message Detailed problem description
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpProblem setDetail(String message)
	{
		getLatestProblem().detail = message;
		return this;
	}

	/**
	 * Set a URI reference that identifies the specific occurrence of the problem.
	 *
	 * @param instance URI reference to the problem location
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpProblem setInstance(String instance)
	{
		getLatestProblem().instance = instance;
		return this;
	}

	/**
	 * Sets a short, human-readable summary of the problem.
	 *
	 * @param title Short summary of the problem
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpProblem setTitle(String title)
	{
		getLatestProblem().title = title;
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
	global fflib_HttpProblem setType(String type)
	{
		getLatestProblem().type = type;
		return this;
	}

	/**
	 * Sets the HTTP status code of the problem.
	 *
	 * @param httpResponseCode A HTTP status code (https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
	 *
	 * @return Instance of itself to allow for chaining
	 */
	global fflib_HttpProblem setStatus(Integer httpResponseCode)
	{
		getLatestProblem().status = httpResponseCode;
		return this;
	}

	protected fflib_HttpProblemDetail getLatestProblem()
	{
		return this.errors.get(this.errors.size() - 1);
	}
}