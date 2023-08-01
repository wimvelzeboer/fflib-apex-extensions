/**
 * A RRC 7807 structured Problem Detail Object
 */
global virtual class fflib_HttpProblemDetail
{
	/**
	 * A human-readable explanation specific to this occurrence of the problem.
	 */
	global String detail { get; set; }

	/**
	 * A URI reference that identifies the specific occurrence of the problem.
	 * It may or may not yield further information if de-referenced.
	 */
	global String instance { get; set; }

	/**
	 * A short, human-readable summary of the problem type.
	 * It SHOULD NOT change from occurrence to occurrence of the
	 * problem, except for purposes of localization (e.g., using
	 * proactive content negotiation; see [RFC7231], Section 3.4).
	 */
	global String title { get; set; }

	/**
	 *	A URI reference that identifies the problem type.
	 *	This specification encourages that, when problem type (e.g., using HTML [W3C.REC-html5-20141028]).
     */
	global String type { get; set; }

	/**
	 * The HTTP status code
	 */
	global Integer status { get; set; }

	global fflib_HttpProblemDetail() {}
}