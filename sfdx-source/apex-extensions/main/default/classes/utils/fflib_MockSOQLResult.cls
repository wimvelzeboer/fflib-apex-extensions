/**
 * File Name: fflib_MockSOQLResult
 */
public with sharing class fflib_MockSOQLResult
{
	/**
	 * This method works on the principle that serializing and deserialising child records is supported
	 *
	 *   System.assertEquals(1, ((List<Master__c>)
	 *    JSON.deserialize(
	 *	    JSON.serialize(
	 *         [select Id, Name,
	 *            (select Id, Name from Children__r) from Master__c]), List<Master__c>.class))
	 *               [0].Children__r.size());
	 *
	 * This method results internally in constructing this JSON, before deserialising it back into SObject's
	 *
	 *		[
	 *		    {
	 *		        "attributes": {
	 *		            "type": "Master__c",
	 *		            "url": "/services/data/v32.0/sobjects/Master__c/a0YG0000005Jn5uMAC"
	 *		        },
	 *		        "Name": "Fred",
	 *		        "Id": "a0YG0000005Jn5uMAC",
	 *		        "Children__r": {
	 *		            "totalSize": 1,
	 *		            "done": true,
	 *		            "records": [
	 *		                {
	 *		                    "attributes": {
	 *		                        "type": "Child__c",
	 *		                        "url": "/services/data/v32.0/sobjects/Child__c/a0ZG0000006JGPAMA4"
	 *		                    },
	 *		                    "Name": "Bob",
	 *		                    "Id": "a0ZG0000006JGPAMA4",
	 *		                    "Master__c": "a0YG0000005Jn5uMAC"
	 *		                }
	 *		            ]
	 *		        }
	 * 		]
	 */
	public static Object makeRelationship(Type parentsType, List<SObject> parents, SObjectField relationshipField, List<List<SObject>> children) {

		// Find out more about this relationship...
		String relationshipFieldName = relationshipField.getDescribe().getName();
		DescribeSObjectResult parentDescribe = parents.getSObjectType().getDescribe();
		List<Schema.ChildRelationship> childRelationships = parentDescribe.getChildRelationships();
		String relationshipName = null;
		for(Schema.ChildRelationship childRelationship : childRelationships) {
			if(childRelationship.getField() == relationshipField) {
				relationshipName = childRelationship.getRelationshipName();
				break;
			}
		}

		// Stream the parsed JSON representation of the parent objects back out, injecting children as it goes
		JSONParser parentsParser = JSON.createParser(JSON.serialize(parents));
		JSONParser childrenParser = JSON.createParser(JSON.serialize(children));
		JSONGenerator combinedOutput = JSON.createGenerator(false);
		streamTokens(parentsParser, combinedOutput, new InjectChildrenEventHandler(childrenParser, relationshipName, children) );

		// Derserialise back into SObject list complete with children
		return JSON.deserialize(combinedOutput.getAsString(), parentsType);
	}

	/**
	 * Exposes an instance an Id factory
	 **/
	public static final IDGenerator Id = new IDGenerator();

	/**
	 * Simple Id factory
	 **/
	public with sharing class IDGenerator
	{
		private Integer fakeIdCount = 0;
		private final String ID_PATTERN = '000000000000';

		private IDGenerator() {}

		/**
		 * Generate a fake Salesforce Id for the given SObjectType
		 */
		public Id generate(Schema.SObjectType sobjectType)
		{
			String keyPrefix = sobjectType.getDescribe().getKeyPrefix();
			fakeIdCount++;
			String fakeIdPrefix = ID_PATTERN.substring(0, 12 - fakeIdCount.format().length());
			return System.Id.valueOf(keyPrefix + fakeIdPrefix + fakeIdCount);
		}
	}

	/**
	 * Monitors stream events for end of object for each SObject contained in the parent list
	 *   then injects the respective childs record list into the stream
	 **/
	private class InjectChildrenEventHandler implements JSONParserEvents {
		private JSONParser childrenParser;
		private String relationshipName;
		private List<List<SObject>> children;
		private Integer childListIdx = 0;

		public InjectChildrenEventHandler(JSONParser childrenParser, String relationshipName, List<List<SObject>> children) {
			this.childrenParser = childrenParser;
			this.relationshipName = relationshipName;
			this.children = children;
			this.childrenParser.nextToken(); // Consume the outer array token
		}

		public void nextToken(JSONParser fromStream, Integer depth, JSONGenerator toStream) {
			// Inject children?
			JSONToken currentToken = fromStream.getCurrentToken();
			if(depth == 2 && currentToken == JSONToken.END_OBJECT ) {
				toStream.writeFieldName(relationshipName);
				toStream.writeStartObject();
				toStream.writeNumberField('totalSize', children[childListIdx].size());
				toStream.writeBooleanField('done', true);
				toStream.writeFieldName('records');
				streamTokens(childrenParser, toStream, null);
				toStream.writeEndObject();
				childListIdx++;
			}
		}
	}

	/**
	 * Utility function to stream tokens from a reader to a write, while providing a basic eventing model
	 **/
	private static void streamTokens(JSONParser fromStream, JSONGenerator toStream, JSONParserEvents events) {
		Integer depth = 0;
		while (fromStream.nextToken()!=null)
		{
			// Give event handler chance to inject
			if(events!=null)
				events.nextToken(fromStream, depth, toStream);
			// Forward to output stream
			JSONToken currentToken = fromStream.getCurrentToken();
			if(currentToken == JSONToken.START_ARRAY) {
				toStream.writeStartArray();
				depth++;
			}
			else if(currentToken == JSONToken.START_OBJECT) {
				toStream.writeStartObject();
				depth++;
			}
			else if(currentToken == JSONToken.FIELD_NAME)
				toStream.writeFieldName(fromStream.getCurrentName());
			else if(currentToken == JSONToken.VALUE_STRING ||
					currentToken == JSONToken.VALUE_FALSE ||
					currentToken == JSONToken.VALUE_TRUE ||
					currentToken == JSONToken.VALUE_NUMBER_FLOAT ||
					currentToken == JSONToken.VALUE_NUMBER_INT)
				toStream.writeString(fromStream.getText());
			else if(currentToken == JSONToken.END_OBJECT) {
				toStream.writeEndObject();
				depth--;
			}
			else if(currentToken == JSONToken.END_ARRAY) {
				toStream.writeEndArray();
				depth--;
			}
			// Don't continue to stream beyond the initial starting point
			if(depth==0)
				break;
		}
	}

	/**
	 * Basic event used during the above streaming
	 **/
	private interface JSONParserEvents {
		void nextToken(JSONParser fromStream, Integer depth, JSONGenerator toStream);
	}
}