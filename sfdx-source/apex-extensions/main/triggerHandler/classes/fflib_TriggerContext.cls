/**
 * File Name: fflib_TriggerContext
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
public virtual inherited sharing class fflib_TriggerContext
		extends fflib_SObjects2
		implements fflib_ITriggerContext
{
	/**
	 * Lazy loads the child relationships of the SObjectType used in the trigger context
	 */
	protected Map<String, ChildRelationship> childRelationshipByName
	{
		get
		{
			if (childRelationshipByName == null)
			{
				Map<String, ChildRelationship> result = new Map<String, ChildRelationship>();
				for (ChildRelationship relationship : this.getSObjectType().getDescribe().getChildRelationships())
				{
					String relationshipName = relationship.getRelationshipName();
					if (relationshipName == null) continue;
					result.put(relationshipName, relationship);
				}
				childRelationshipByName = result;
			}
			return childRelationshipByName;
		}
		private set;
	}

	/**
	 * Provides access to the Trigger.oldMap and allowing it to be mocked in unit-tests
	 */
	@TestVisible
	protected Map<Id, SObject> existingRecords
	{
		get
		{
			if (existingRecords == null)
			{
				existingRecords = Trigger.oldMap;
			}
			return existingRecords;
		}
		set;
	}

	/**
	 * Provides access to the Trigger.new and allowing it to be mocked in unit-tests
	 */
	@TestVisible
	protected List<SObject> records {
		get
		{
			if (records == null)
			{
				records = getRecords();
			}
			return records;
		}
		set;
	}

	/**
	 * Provides access to related records which are queried before the action is run
	 */
	@TestVisible
	protected Map<SObjectType, List<SObject>> relatedRecords = new Map<SObjectType, List<SObject>>();

	/**
	 * A multi SObject selector that is able to batch execute queries for the Trigger Actions
	 */
	protected fflib_MultiSObjectsSelector selector = fflib_MultiSObjectsSelector.newElevatedInstance();

	/**
	 * Provides access to the Trigger Operation and allowing it to be mocked in unit-tests
	 */
	@TestVisible
	protected System.TriggerOperation triggerOperation
	{
		get
		{
			if (triggerOperation == null)
			{
				triggerOperation = Trigger.operationType;
			}
			return triggerOperation;
		}
		set;
	}

	/**
	 * A shared instance of the UnitOfWork between all the Trigger Actions
	 */
	protected fflib_ISObjectUnitOfWork unitOfWork;

	/**
	 * The SObject Hierarchy used with the unitOfWork
	 */
	protected Map<SObjectType, SortableSObjectType> unitOfWorkHierarchy = new Map<SObjectType, SortableSObjectType>();

	public fflib_TriggerContext(List<SObject> records)
	{
		super(records);
	}

	/**
	 * Method used by the framework to clear the queried related records between trigger operations (e.g. before and after)
	 */
	public void clearRelated() {
		this.relatedRecords.clear();
		this.selector.clear();
	}

	/**
	 * Triggers the execution of the UnitOfWork,
	 * holding all the registered work by the trigger actions
	 */
	public void commitWork()
	{
		this.unitOfWork.commitWork();

		// Clear work after its executed
		this.unitOfWork = null;
		this.unitOfWorkHierarchy = new Map<SObjectType, SortableSObjectType>();
	}

	/**
	 * Method used by the framework to run the batched queries
	 *
	 * @see fflib_TriggerContext.selector
	 */
	public void fetchRelated()
	{
		this.relatedRecords = this.selector.query();
		System.debug(this.relatedRecords);
	}

	/**
     * Provides access to the data represented by this Trigger Context
     **/
	public System.TriggerOperation getTriggerOperation()
	{
		return triggerOperation;
	}

	public Set<String> getChangedFields()
	{
		Set<String> result = new Set<String>();
		for (SObject newRecord : getRecords())
		{
			Id recordId = (Id) newRecord.get('Id');
			if (getExistingRecords() == null || !getExistingRecords().containsKey(recordId)) continue;

			SObject oldRecord = getExistingRecords().get(recordId);
			Map<String, Object> oldValuesByFieldName = oldRecord.getPopulatedFieldsAsMap();
			Map<String, Object> newValuesByFieldName = newRecord.getPopulatedFieldsAsMap();
			Set<String> fieldNames = new Set<String>();
			fieldNames.addAll(oldValuesByFieldName.keySet());
			fieldNames.addAll(newValuesByFieldName.keySet());
			for (String fieldName : fieldNames)
			{
				if (oldValuesByFieldName.containsKey(fieldName) == false
						&& newValuesByFieldName.containsKey(fieldName) == false) continue;

				if ((oldValuesByFieldName.containsKey(fieldName) == false
						&& newValuesByFieldName.containsKey(fieldName))
						||
						(oldValuesByFieldName.containsKey(fieldName)
								&& newValuesByFieldName.containsKey(fieldName) == false)
						||
						(oldValuesByFieldName.get(fieldName) != newValuesByFieldName.get(fieldName))
				)
				{
					result.add(fieldName);
				}
			}
		}
		return result;
	}

	/**
     * Detects whether any values in context records have changed for given field as string
     * Returns list of SObject records that have changes in the specified fields
     **/
	public List<SObject> getChangedRecords(String fieldName)
	{
		return getChangedRecords(new Set<String> {fieldName});
	}

	/**
     * Detects whether any values in context records have changed for given fields as strings
     * Returns list of SObject records that have changes in the specified fields
     **/
	public List<SObject> getChangedRecords(Set<String> fieldNames)
	{
		List<SObject> changedRecords = new List<SObject>();
		for (SObject newRecord : getRecords())
		{
			Id recordId = (Id) newRecord.get('Id');
			if (getExistingRecords() == null || !getExistingRecords().containsKey(recordId)) continue;

			SObject oldRecord = getExistingRecords().get(recordId);
			for (String fieldName : fieldNames)
			{
				if (oldRecord.get(fieldName) != newRecord.get(fieldName))
				{
					changedRecords.add(newRecord);
					break;  // prevents the records from being added multiple times
				}
			}
		}
		return changedRecords;
	}

	/**
	 * Detects whether any values in context records have changed for given field as token
	 * Returns list of SObject records that have changes in the specified fields
	 **/
	public List<SObject> getChangedRecords(Schema.SObjectField fieldToken)
	{
		return getChangedRecords(new Set<Schema.SObjectField> {fieldToken});
	}

	/**
	 * Detects whether any values in context records have changed for given fields as tokens
	 * Returns list of SObject records that have changes in the specified fields
	 **/
	public List<SObject> getChangedRecords(Set<Schema.SObjectField> fieldTokens)
	{
		List<SObject> changedRecords = new List<SObject>();
		for (SObject newRecord : getRecords())
		{
			Id recordId = (Id) newRecord.get('Id');
			if (getExistingRecords() == null || !getExistingRecords().containsKey(recordId)) continue;

			SObject oldRecord = getExistingRecords().get(recordId);
			for (Schema.SObjectField fieldToken : fieldTokens)
			{
				if (oldRecord.get(fieldToken) != newRecord.get(fieldToken))
				{
					changedRecords.add(newRecord);
					break;  // prevents the records from being added multiple times
				}
			}
		}
		return changedRecords;
	}

	/**
	 * Provides access to Trigger.oldMap or the mock when configured in a unit-test
	 **/
	public Map<Id, SObject> getExistingRecords()
	{
		return this.existingRecords;
	}

	/**
	 * Get the records for the given SObjectType,
	 * which are queried based on the defined interests of all trigger actions
	 *
	 * @param sObjectType The SObjectType of the records to return
	 *
	 * @return Return a list of SObjects
	 * @example
	 * public override void onBeforeWork() {
	 *   if (this.triggerContext.isBefore()) {
	 *     this.triggerContext.interestedIn('Contacts',new Set<SObjectField>{ Schema.Contact.LastName });
	 *   }
	 * }
	 * public override void onBeforeUpdate() {
	 *   IContacts contacts = Contacts.newInstance(this.triggerContext.getRelated('Contacts'));
     * }
	 */
	public List<SObject> getRelated(SObjectType sObjectType) {
		if (this.relatedRecords.containsKey(sObjectType)) {
			return this.relatedRecords.get(sObjectType);
		}
		return new List<SObject>();
	}

	/**
	 * Returns the bare instance of
	 * @return
	 */
	public fflib_ISObjectUnitOfWork getUnitOfWork() {
		return this.unitOfWork;
	}

	/**
	 * Declares its interest into a related parent record
	 *
	 * @param idField The SObjectField holding the Id of the parent record
	 * @param fields a list of SObjectFields on the parent record that should be queried
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 *
	 * @example
	 * // QUERY: SELECT Name FROM Account WHERE Id IN :contacts.getAccountIds()
	 * new fflib_TriggerContext()
	 * 		.interestedIn(
	 * 			Schema.Contact.AccountId,
	 * 			new Set<SObjectField>{ Schema.Account.Name });
	 */
	public fflib_ITriggerContext interestedIn(SObjectField idField, Set<SObjectField> fields)
	{
		SObjectType sObjectType = idField.getDescribe().getReferenceTo().get(0);
		this.selector.registerQuery(
				sObjectType,
				fields,
				sObjectType.getDescribe().fields.getMap().get('Id'),
				getIdFieldValues(idField, false)
		);
		return this;
	}

	/**
	 * Declares its interest into a related child record
	 *
	 * @param relationshipName The SObject Relation Name Field holding the Id of the parent record
	 * @param fields a list of SObjectFields of the child record that should be queried
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 *
	 * @example
	 * // QUERY: SELECT Id, LastName FROM Contact WHERE AccountId IN :accounts.getRecordIds()
	 * new fflib_TriggerContext()
	 * 		.interestedIn(
	 * 			'Contacts',
	 * 			new Set<SObjectField>{ Schema.Contact.LastName });
	 */
	public fflib_ITriggerContext interestedIn(String relationshipName, Set<SObjectField> fields)
	{
		if (childRelationshipByName.containsKey(relationshipName) == false)
			throw new TriggerContextException('Unknown relationship name '+ relationshipName);

		ChildRelationship relationship = childRelationshipByName.get(relationshipName);

		this.selector.registerQuery(
				relationship.getChildSObject(),
				fields,
				relationship.getField(),
				getRecordIds()
		);
		return this;
	}

	/**
	 * Declares its interest into an unrelated record
	 *
	 * @param sObjectType The SObjectType to query
	 * @param idField The SObjectField holding the Id values to search for
	 * @param values A set of Ids values to query
	 * @param fields a list of SObjectFields on the record that should be queried
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 *
	 * @example
	 * //QUERY: SELECT Alias FROM User
	 * new fflib_TriggerContext()
	 * 		.interestedIn(
	 * 			Schema.User,
	 * 			Schema.User.Id,
	 * 			new Set<Id>{ UserInfo.getUserId() },
	 * 			new Set<SObjectField>{ Schema.User.Alias });
	 */
	public fflib_ITriggerContext interestedIn(
			Schema.SObjectType sObjectType,
			Schema.SObjectField idField,
			Set<Id> values,
			Set<SObjectField> fields)
	{
		this.selector.registerQuery(
				sObjectType,
				fields,
				idField,
				values
		);
		return this;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an INSERT operation
	 */
	public Boolean isInsert()
	{
		return this.triggerOperation == System.TriggerOperation.AFTER_INSERT
				|| this.triggerOperation == System.TriggerOperation.BEFORE_INSERT;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an UPDATE operation
	 */
	public Boolean isUpdate()
	{
		return this.triggerOperation == System.TriggerOperation.AFTER_UPDATE
				|| this.triggerOperation == System.TriggerOperation.BEFORE_UPDATE;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an DELETE operation
	 */
	public Boolean isDelete()
	{
		return this.triggerOperation == System.TriggerOperation.AFTER_DELETE
				|| this.triggerOperation == System.TriggerOperation.BEFORE_DELETE;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an UNDELETE operation
	 */
	public Boolean isUndelete()
	{
		return this.triggerOperation == System.TriggerOperation.AFTER_UNDELETE;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an BEFORE operation
	 */
	public Boolean isBefore()
	{
		return this.triggerOperation == System.TriggerOperation.BEFORE_DELETE
				|| this.triggerOperation == System.TriggerOperation.BEFORE_INSERT
				|| this.triggerOperation == System.TriggerOperation.BEFORE_UPDATE;
	}

	/**
	 * @return Returns TRUE if the Trigger Context is an AFTER operation
	 */
	public Boolean isAfter()
	{
		return this.triggerOperation == System.TriggerOperation.AFTER_DELETE
				|| this.triggerOperation == System.TriggerOperation.AFTER_INSERT
				|| this.triggerOperation == System.TriggerOperation.AFTER_UNDELETE
				|| this.triggerOperation == System.TriggerOperation.AFTER_UPDATE;
	}

	/**
	 * Registers an SObjectType with the unit of work
	 *
	 * @param childSObjectType The SObjectType to register
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public fflib_TriggerContext registerSObjectType(SObjectType childSObjectType)
	{
		return registerSObjectType(childSObjectType, new Set<SObjectType>());
	}

	/**
	 * Registers an SObjectType with the unit of work
	 *
	 * @param childSObjectType The SObjectType to register
	 * @param parentSObjectTypes A set of SObjectType that should be handled by the unit of work before the given childSObjectType
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public fflib_TriggerContext registerSObjectType(SObjectType childSObjectType, Set<SObjectType> parentSObjectTypes)
	{
		if (this.unitOfWorkHierarchy.containsKey(childSObjectType))
		{
			this.unitOfWorkHierarchy.get(childSObjectType).addParent(parentSObjectTypes);
		} else {
			this.unitOfWorkHierarchy.put(childSObjectType,
					new SortableSObjectType(childSObjectType, parentSObjectTypes));
		}
		return this;
	}

	/**
	 * Method used by the framework to create a new instance of the unit of work,
	 * with the registered SObjectTypes by the trigger actions
	 */
	public void initializeUnitOfWork() {
		List<SortableSObjectType> sortableSObjectTypes = this.unitOfWorkHierarchy.values();
		sortableSObjectTypes.sort();

		List<SObjectType> hierarchy = new List<SObjectType>();
		for (SortableSObjectType item : sortableSObjectTypes)
		{
			hierarchy.add(item.sObjectType);
		}
		this.unitOfWork = new fflib_SObjectUnitOfWork2(hierarchy);
	}

	/**
	 * Constructor to construct the Trigger Context class
	 */
	public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_IDomain construct(List<Object> objects)
		{
			return new fflib_TriggerContext((List<SObject>) objects);
		}
	}

	public class SortableSObjectType implements Comparable
	{
		public SObjectType sObjectType;
		public Set<SObjectType> parentSObjectTypes = new Set<SObjectType>();

		public SortableSObjectType(SObjectType sObjectType, Set<SObjectType> parentSObjectTypes)
		{
			this.sObjectType = sObjectType;
		}

		public SortableSObjectType addParent( Set<SObjectType> sObjectTypes)
		{
			this.parentSObjectTypes.addAll(sObjectTypes);
			return this;
		}

		public Integer compareTo(Object obj)
		{
			SortableSObjectType compareTo = (SortableSObjectType) obj;

			if (compareTo.parentSObjectTypes.contains(this.sObjectType)) return -1;
			return 1;
		}
	}

	public class TriggerContextException extends Exception {}
}