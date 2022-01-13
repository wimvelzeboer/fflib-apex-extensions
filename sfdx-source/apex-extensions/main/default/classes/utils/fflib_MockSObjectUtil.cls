/**
 * File Name: fflib_MockSObjectUtil
 *
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
public with sharing class fflib_MockSObjectUtil
{
	public static SObject addRelatedParentObject(SObject childObject, SObject parentObject, String relationshipField)
	{
		String original = JSON.serialize(childObject);
		return (SObject) JSON.deserialize(
				original.left(original.length() - 1) +
						',"' + relationshipField + '":' +
						JSON.serialize(parentObject) + '}',
				SObject.class);
	}

	// Keeping this method for backwards compatibility
	@TestVisible
	private static SObject addFieldValue(SObject record, Schema.SObjectField sObjectField, Object value)
	{
		System.debug(LoggingLevel.WARN, 'addFieldValue is deprecated and will be removed at some point, please use setFieldValue instead');
		return setFieldValue(record, sObjectField, value);
	}

	@TestVisible
	private static SObject setFieldValue(
			SObject record, SObjectField sObjectField, Object value)
	{
		String fieldName = sObjectField.getDescribe().getName();

		String serializedRecord = JSON.serialize(record);
		Map<String, Object> valuesByFieldName =
				(Map<String, Object>) JSON.deserializeUntyped(serializedRecord);

		valuesByFieldName.put(fieldName, value);
		serializedRecord = JSON.serialize(valuesByFieldName);

		return (SObject) JSON.deserialize(serializedRecord, SObject.class);
	}

	@IsTest
	static void itShouldTestAddingReadOnlyField()
	{
		final Decimal amount = 10.0;
		Opportunity opp = new Opportunity(Id = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType));
		SObject result = addFieldValue(opp, Opportunity.ExpectedRevenue, amount);
		System.assertEquals(amount, result.get(Opportunity.ExpectedRevenue));
	}

	@IsTest
	static void itShouldTestSettingDateField()
	{
		final Date today = Date.today();
		Lead record = new Lead(Id = fflib_IDGenerator.generate(Schema.Lead.SObjectType));
		SObject result = addFieldValue(record, Lead.ConvertedDate, today);
		System.assertEquals(today, result.get(Lead.ConvertedDate));
		System.debug('result: '+result);
	}
}