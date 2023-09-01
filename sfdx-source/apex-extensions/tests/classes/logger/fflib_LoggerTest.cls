/**
 * File Name: fflib_LoggerTest
 * Description: Unit test for fflib_Logger.cls
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
@IsTest
private class fflib_LoggerTest
{

	private static final List<String> ARGUMENTS = new List<String> {'A', 'B', 'C'};
	private static final String ERROR_MESSAGE = 'Some Error';
	private static final String ERROR_MESSAGE_WITH_ARGS = 'Some Error {0}, {1}, {2}';
	private static final String ERROR_MESSAGE_FORMATTED_WITH_EXCEPTION = String.format(
			'Exception: {0} {1}\n Stack trace: {2}',
			new List<String>
			{
					'LogTestMockException:[]:',
					ERROR_MESSAGE,
					'Class.fflib_LoggerTest.itShouldAppendDebugException:'
			}
	);
	private static final String ERROR_MESSAGE_FORMATTED_WITH_ARGS =
			String.format(
					ERROR_MESSAGE_WITH_ARGS,
					ARGUMENTS
			);
	private static final LogAppenderMock APPENDER_MOCK = new LogAppenderMock();
	private static final SecondLogAppenderMock APPENDER_MOCK_B = new SecondLogAppenderMock();


	@IsTest
	static void itShouldAppendAMessage()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.add(ERROR_MESSAGE);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(APPENDER_MOCK.getAppendedMessages(System.LoggingLevel.INFO).contains(ERROR_MESSAGE));
	}

	@IsTest
	static void itShouldAppendDebugMessage()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.debug(ERROR_MESSAGE);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.DEBUG)
						.contains(ERROR_MESSAGE)
		);
	}

	@IsTest
	static void itShouldAppendDebugException()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();
		Exception e = new LogTestMockException(ERROR_MESSAGE);

		// WHEN - When the error is logged
		log.debug(e);

		// THEN - It should be appended to the logAppender
		final List<String> result = APPENDER_MOCK
				.getAppendedMessages(System.LoggingLevel.DEBUG);
		System.Assert.areEqual(1, result.size(), 'Expected only one error');
		System.Assert.isTrue(result.get(0).startsWith(ERROR_MESSAGE_FORMATTED_WITH_EXCEPTION), 'Incorrect returned error message');
	}

	@IsTest
	static void itShouldAppendDebugExceptionWithUuid()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();
		final fflib_HttpException e = new fflib_HttpException(400);
		final String uuid = e.getUuid();

		// WHEN - When the error is logged
		log.debug(e);

		// THEN - It should be appended to the logAppender
		final List<fflib_LogEntry> result = APPENDER_MOCK.getEntries();
		System.Assert.areEqual(1, result.size(), 'Expected only one log entry');
		System.Assert.areEqual(uuid, result.get(0).uuid, 'Incorrect UUID on the LogEntry');
	}


	@IsTest
	static void itShouldAppendDebugMessageWithArguments()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.debug(ERROR_MESSAGE_WITH_ARGS, ARGUMENTS);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.DEBUG)
						.contains(ERROR_MESSAGE_FORMATTED_WITH_ARGS)
		);
	}

	@IsTest
	static void itShouldAppendErrorMessage()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.error(ERROR_MESSAGE);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(APPENDER_MOCK.getAppendedMessages(System.LoggingLevel.ERROR).contains(ERROR_MESSAGE));
	}

	@IsTest
	static void itShouldAppendErrorMessageWithArguments()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.error(ERROR_MESSAGE_WITH_ARGS, ARGUMENTS);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.ERROR)
						.contains(ERROR_MESSAGE_FORMATTED_WITH_ARGS)
		);
	}

	@IsTest
	static void itShouldAppendInfoMessage()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.info(ERROR_MESSAGE);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(APPENDER_MOCK.getAppendedMessages(System.LoggingLevel.INFO).contains(ERROR_MESSAGE));
	}

	@IsTest
	static void itShouldAppendInfoMessageWithArguments()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.info(ERROR_MESSAGE_WITH_ARGS, ARGUMENTS);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.INFO)
						.contains(ERROR_MESSAGE_FORMATTED_WITH_ARGS)
		);
	}

	@IsTest
	static void itShouldAppendWarningMessage()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.warning(ERROR_MESSAGE);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(APPENDER_MOCK.getAppendedMessages(System.LoggingLevel.WARN).contains(ERROR_MESSAGE));
	}

	@IsTest
	static void itShouldAppendWarningMessageWithArguments()
	{
		// GIVEN - An error message and a configured logger
		fflib_ILogger log = generatedLoggerWithMockAppender();

		// WHEN - When the error is logged
		log.warning(ERROR_MESSAGE_WITH_ARGS, ARGUMENTS);

		// THEN - It should be appended to the logAppender
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.WARN)
						.contains(ERROR_MESSAGE_FORMATTED_WITH_ARGS)
		);
	}

	@IsTest
	static void itShouldHandleTwoAppenders()
	{
		// GIVEN an error message and a logger with two appenders configured
		fflib_ILogger log = new fflib_Logger();
		log.addAppender(APPENDER_MOCK);
		log.addAppender(APPENDER_MOCK_B);
		log.setMessageFormatter(new fflib_Logger.LogMessageFormatter());

		// WHEN - When the error is logged
		log.error(ERROR_MESSAGE);

		// THEN - It Should be added to both appenders
		System.Assert.isTrue(
				APPENDER_MOCK
						.getAppendedMessages(System.LoggingLevel.ERROR)
						.contains(ERROR_MESSAGE)
		);
		System.Assert.istrue(
				APPENDER_MOCK_B
						.getAppendedMessages(System.LoggingLevel.ERROR)
						.contains(ERROR_MESSAGE)
		);
	}


	private static fflib_ILogger generatedLoggerWithMockAppender()
	{
		fflib_ILogger result = new fflib_Logger();
		result.setAppender(APPENDER_MOCK);
		result.setMessageFormatter(new fflib_Logger.LogMessageFormatter());
		return result;
	}


	private virtual class LogAppenderMock implements fflib_ILogAppender
	{
		protected List<fflib_LogEntry> appendedEntries = new List<fflib_LogEntry>();

		public void append(fflib_LogEntry logEntry)
		{
			this.appendedEntries.add(logEntry);
		}

		public List<fflib_LogEntry> getEntries()
		{
			return this.appendedEntries;
		}

		public List<String> getAppendedMessages(System.LoggingLevel loggingLevel)
		{
			List<String> result = new List<String>();
			for (fflib_LogEntry logEntry : appendedEntries)
			{
				if (logEntry.logLevel == loggingLevel)
				{
					result.add(logEntry.message);
				}
			}
			return result;
		}
	}

	private class SecondLogAppenderMock extends LogAppenderMock { }

	private class LogTestMockException extends Exception {}
}