/******************************************************************************************
 * This file is part of the Apex UUID project, released under the MIT License.             *
 * See LICENSE file or go to https://github.com/jongpie/ApexUuid for full license details. *
 ******************************************************************************************/
/**
 * Changes made:
 * - Renamed class into fflib_Uuid
 * - Renamed some parameters to resolve dictionary warnings
 * - Added the fflib Apex styling
 */
public without sharing class fflib_Uuid
{
	private static final Integer HEX_BASE = HEX_CHARACTERS.length();
	private static final String HEX_CHARACTERS = '0123456789abcdef';
	private static final String HEX_PREFIX = '0x';
	private static final List<String> HEX_CHARACTER_LIST = HEX_CHARACTERS.split('');
	private static final Integer UUID_V4_LENGTH = 36;
	private static final String UUID_V4_REGEX = '[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}';

	private static final String ERROR_MESSAGE_INVALID_UUID = '{0} is not a valid UUID value';

	public static String formatValue(String unformattedValue)
	{
		// Remove any non-alphanumeric characters
		String nonformattedValue = unformattedValue.replaceAll('[^a-zA-Z0-9]', '');

		// If the nonformatted value isn't even the right length to be valid, then throw an exception
		// Subtract 4 because the UUID_V4_LENGTH includes 4 '-' characters in the UUID pattern
		if (nonformattedValue.length() != (UUID_V4_LENGTH - 4))
		{
			throw new UuidException(String.format(ERROR_MESSAGE_INVALID_UUID, new List<String> {unformattedValue}));
		}

		// UUID Pattern: 8-4-4-4-12
		String formattedValue =
				nonformattedValue.substring(0, 8) +
						'-' +
						nonformattedValue.substring(8, 12) +
						'-' +
						nonformattedValue.substring(12, 16) +
						'-' +
						nonformattedValue.substring(16, 20) +
						'-' +
						nonformattedValue.substring(20);

		formattedValue = formattedValue.toLowerCase();

		if (!fflib_Uuid.isValid(formattedValue))
		{
			throw new UuidException(String.format(ERROR_MESSAGE_INVALID_UUID, new List<String> {nonformattedValue}));
		}

		return formattedValue;
	}

	public static Boolean isValid(String uuidValue)
	{
		if (String.isBlank(uuidValue) || uuidValue.length() != UUID_V4_LENGTH)
		{
			return false;
		}

		Pattern uuidPattern = Pattern.compile(UUID_V4_REGEX.toLowerCase());
		Matcher uuidMatcher = uuidPattern.matcher(uuidValue.toLowerCase());

		return uuidMatcher.matches();
	}

	public static fflib_Uuid valueOf(String uuidValue)
	{
		return new fflib_Uuid(uuidValue);
	}

	private final String value;

	public fflib_Uuid() {
		this.value = this.generateValue();
	}

	private fflib_Uuid(String uuidValue) {
		this.value = fflib_Uuid.formatValue(uuidValue);
	}

	public String getValue()
	{
		return this.value;
	}

	private String generateValue()
	{
		String hexValue = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

		// Version Calculation: (i & 0x0f) | 0x40
		// Version Format: Always begins with 4
		String versionShiftedHexBits = this.getShiftedHexBits(
				hexValue.substring(14, 16),
				this.convertHexToInteger('0x0f'),
				this.convertHexToInteger('0x40')
		);

		// Variant Calculation: (i & 0x3f) | 0x80
		// Variant Format: Always begins with 8, 9, A or B
		String variantShiftedHexBits = this.getShiftedHexBits(
				hexValue.substring(18, 20),
				this.convertHexToInteger('0x3f'),
				this.convertHexToInteger('0x80')
		);

		String uuidValue =
				hexValue.substring(0, 8) + // time-low
						hexValue.substring(8, 12) + // time-mid
						versionShiftedHexBits +
						hexValue.substring(14, 16) + // time-high-and-version
						variantShiftedHexBits +
						hexValue.substring(18, 20) + // clock-seq-and-reserved + clock-seq-low
						hexValue.substring(20); // node

		return fflib_Uuid.formatValue(uuidValue);
	}

	private String getShiftedHexBits(
			String hexSubstring,
			Integer lowerThreshold,
			Integer upperThreshold
	)
	{
		Integer shiftedIntegerBits =
				(this.convertHexToInteger(hexSubstring) & lowerThreshold) |
						upperThreshold;
		return this.convertIntegerToHex(shiftedIntegerBits);
	}

	private Integer convertHexToInteger(String hexValue)
	{
		hexValue = hexValue.toLowerCase();

		if (hexValue.startsWith(HEX_PREFIX))
		{
			hexValue = hexValue.substringAfter(HEX_PREFIX);
		}

		Integer integerValue = 0;
		for (String hexCharacter : hexValue.split(''))
		{
			Integer hexCharacterIndex = HEX_CHARACTERS.indexOf(hexCharacter);

			integerValue = HEX_BASE * integerValue + hexCharacterIndex;
		}
		return integerValue;
	}

	private String convertIntegerToHex(Integer integerValue)
	{
		String hexValue = '';
		while (integerValue > 0)
		{
			Integer hexCharacterIndex = Math.mod(integerValue, HEX_BASE);

			hexValue = HEX_CHARACTER_LIST[hexCharacterIndex] + hexValue;
			integerValue = integerValue / HEX_BASE;
		}
		return hexValue;
	}

	private class UuidException extends Exception {}
}