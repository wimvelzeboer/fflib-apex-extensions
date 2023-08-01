public  class fflib_HttpStatusCode
{
	// --- 1xx Informational ---
	public static final Integer INFO_CONTINUE = 100;
	public static final Integer INFO_SWITCHING_PROTOCOLS = 101;
	public static final Integer INFO_PROCESSING = 102;

	//  --- 2xx Success ---
	public static final Integer SUCCESS_OK = 200;
	public static final Integer SUCCESS_CREATED = 201;
	public static final Integer SUCCESS_ACCEPTED = 202;
	public static final Integer SUCCESS_NON_AUTHORITATIVE_INFORMATION = 203;
	public static final Integer SUCCESS_NO_CONTENT = 204;
	public static final Integer SUCCESS_RESET_CONTENT = 205;
	public static final Integer SUCCESS_PARTIAL_CONTENT = 206;
	public static final Integer SUCCESS_MULTI_STATUS = 207;

	//  --- 3xx Redirection ---
	public static final Integer REDIRECT_MULTIPLE_CHOICES = 300;
	public static final Integer REDIRECT_MOVED_PERMANENTLY = 301;
	public static final Integer REDIRECT_MOVED_TEMPORARILY = 302;
	public static final Integer REDIRECT_SEE_OTHER = 303;
	public static final Integer REDIRECT_NOT_MODIFIED = 304;
	public static final Integer REDIRECT_USE_PROXY = 305;
	public static final Integer REDIRECT_TEMPORARY_REDIRECT = 307;

	//  --- 4xx Client Error ---
	public static final Integer CLIENT_ERROR_BAD_REQUEST = 400;
	public static final Integer CLIENT_ERROR_UNAUTHORIZED = 401;
	public static final Integer CLIENT_ERROR_PAYMENT_REQUIRED = 402;
	public static final Integer CLIENT_ERROR_FORBIDDEN = 403;
	public static final Integer CLIENT_ERROR_NOT_FOUND = 404;
	public static final Integer CLIENT_ERROR_METHOD_NOT_ALLOWED = 405;
	public static final Integer CLIENT_ERROR_NOT_ACCEPTABLE = 406;
	public static final Integer CLIENT_ERROR_PROXY_AUTHENTICATION_REQUIRED = 407;
	public static final Integer CLIENT_ERROR_REQUEST_TIMEOUT = 408;
	public static final Integer CLIENT_ERROR_CONFLICT = 409;
	public static final Integer CLIENT_ERROR_GONE = 410;
	public static final Integer CLIENT_ERROR_LENGTH_REQUIRED = 411;
	public static final Integer CLIENT_ERROR_PRECONDITION_FAILED = 412;
	public static final Integer CLIENT_ERROR_REQUEST_TOO_LONG = 413;
	public static final Integer CLIENT_ERROR_REQUEST_URI_TOO_LONG = 414;
	public static final Integer CLIENT_ERROR_UNSUPPORTED_MEDIA_TYPE = 415;
	public static final Integer CLIENT_ERROR_REQUESTED_RANGE_NOT_SATISFIABLE = 416;
	public static final Integer CLIENT_ERROR_EXPECTATION_FAILED = 417;
	public static final Integer CLIENT_ERROR_INSUFFICIENT_SPACE_ON_RESOURCE = 419;
	public static final Integer CLIENT_ERROR_METHOD_FAILURE = 420;
	public static final Integer CLIENT_ERROR_UNPROCESSABLE_ENTITY = 422;
	public static final Integer CLIENT_ERROR_LOCKED = 423;
	public static final Integer CLIENT_ERROR_FAILED_DEPENDENCY = 424;

	//  --- 5xx Server Error ---
	public static final Integer SERVER_ERROR_INTERNAL_SERVER_ERROR = 500;
	public static final Integer SERVER_ERROR_NOT_IMPLEMENTED = 501;
	public static final Integer SERVER_ERROR_BAD_GATEWAY = 502;
	public static final Integer SERVER_ERROR_SERVICE_UNAVAILABLE = 503;
	public static final Integer SERVER_ERROR_GATEWAY_TIMEOUT = 504;
	public static final Integer SERVER_ERROR_HTTP_VERSION_NOT_SUPPORTED = 505;
	public static final Integer SERVER_ERROR_INSUFFICIENT_STORAGE = 507;

	public static final Map<Integer, String> MESSAGE_BY_STATUS_CODE = new Map<Integer, String>
	{
			100 => 'Continue',
			101 => 'Switching Protocols',
			102 => 'Processing',

			200 => 'Ok',
			201 => 'Created',
			202 => 'Accepted',
			203 => 'Non authoritative information',
			204 => 'No content',
			205 => 'Reset content',
			206 => 'Partial content',
			207 => 'Multi status',

			300 => 'Multiple choices',
			301 => 'Moved permanently',
			302 => 'Moved temporarily',
			303 => 'See other',
			304 => 'Not modified',
			305 => 'Use proxy',
			307 => 'Temporary redirect',

			400 => 'Bad request',
			401 => 'Unauthorized',
			402 => 'Payment required',
			403 => 'Forbidden',
			404 => 'Not found',
			405 => 'Method not allowed',
			406 => 'Not acceptable',
			407 => 'Proxy authentication required',
			408 => 'Request timeout',
			409 => 'Conflict',
			410 => 'Gone',
			411 => 'Length required',
			412 => 'Precondition failed',
			413 => 'Request too long',
			414 => 'Request uri too long',
			415 => 'Unsupported media type',
			416 => 'Requested range not satisfiable',
			417 => 'Expectation failed',
			419 => 'Insufficient space on resource',
			420 => 'Method failure',
			422 => 'Unprocessable entity',
			423 => 'Locked',
			424 => 'Failed dependency',

			500 => 'Internal server error',
			501 => 'Not implemented',
			502 => 'Bad gateway',
			503 => 'Service unavailable',
			504 => 'Gateway timeout',
			505 => 'Http version not supported',
			507 => 'Insufficient storage'
	};

	public static String getTitle(Integer statusCode)
	{
		if (MESSAGE_BY_STATUS_CODE.containsKey(statusCode))
		{
			return MESSAGE_BY_STATUS_CODE.get(statusCode);
		}
		else
		{
			return null;
		}
	}
}