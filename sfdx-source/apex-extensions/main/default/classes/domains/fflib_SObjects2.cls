/**
 * File Name: fflib_SObjects2
 * @description Primitive domain for the object type SObject
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
public virtual class fflib_SObjects2
		extends fflib_SObjects
		implements fflib_ISObjects2
{
	protected Schema.DescribeSObjectResult SObjectDescribe { get; private set; }

	/**
	 * Class constructors
	 *
	 * @param objects The Objects of type SObjectType, to contain inside the domain
	 */
	public fflib_SObjects2(List<Object> objects)
	{
		// todo - assert of objects of type SObject
		this((List<SObject>) objects);
	}

	/**
	 * Class constructor
	 *
	 * @param records The records to contain inside the domain
	 */
	public fflib_SObjects2(List<SObject> records)
	{
		this(records, records.getSObjectType());
	}

	/**
	 * Class constructor
	 *
	 * @param records The records to contain inside the domain
	 * @param sObjectType The SObjectType of the records
	 */
	public fflib_SObjects2(List<SObject> records, Schema.SObjectType sObjectType)
	{
		super(records, sObjectType);
		SObjectDescribe = sObjectType.getDescribe();
	}

	/**
	 * Get a map with the given Boolean field value mapped to the given Id field
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Boolean field to use as value for the map
	 * @param keyField The Id field to use as key for the map
	 *
	 * @return a map with the given Boolean field value mapped to the given Id field
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, Boolean> isDeletedById = account.getBooleanFieldByIdField(Account.IsDeleted, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, Boolean> getBooleanFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, Boolean> result = new Map<Id, Boolean>();
		Map<Object, Object> fieldByField = getFieldByField(valueField, keyField);
		for (Object obj : fieldByField.keySet())
		{
			result.put((Id) obj, (Boolean) fieldByField.get(obj));
		}
		return result;
	}

	/**
	 * @param id Domain containing primary key (Id field) values
	 *
	 * @return Returns only the SObjects from the domain matching the given Ids.
	 */
	public virtual SObject getRecord(Id id)
	{
		List<SObject> result = getRecords(new Set<Id> {id});

		return (result.size() == 0) ? null : result.get(0);
	}

	/**
	 * Gets the field value from the last given grandparent domain by the record Id
	 *
	 * @param valueField The field use return as value for the map
	 * @param domainsByRelationshipField A Map of domains and the in hierarchical order from first parent to grandparent
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The value of the given valueField of the last grandparent record listed in the relatedDomains,
	 *   null if no grandparent exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, String> accountNameByCaseId =
	 *         casesDomain.getParentStringFieldById(
	 *                 Schema.Account.Name,
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Case.ContactId => contactDomain,
	 *                         Schema.Contact.AccountId => accountDomain
	 *                 });
	 */
	public virtual Map<Id, String> getParentStringFieldById(
			Schema.SObjectField valueField,
			Map<Schema.SObjectField, fflib_ISObjects2> domainsByRelationshipField)
	{
		Map<Id, Id> parentIdByChildId = getParentIdById(domainsByRelationshipField);

		List<fflib_ISObjects2> domains = domainsByRelationshipField.values();
		fflib_SObjects2 lastGrandParentDomain = (fflib_SObjects2) domains.get(domains.size() - 1);

		return fflib_ArrayUtils.replaceValue(
				parentIdByChildId,
				lastGrandParentDomain.getStringFieldByIdField(
						valueField,
						lastGrandParentDomain.getSObjectType().getDescribe().fields.getMap().get('Id')));
	}

	/**
	 * Gets the field value from the last given grandparent domain by the record Id
	 *
	 * @param valueField The field use return as value for the map
	 * @param domainsByRelationshipField A Map of domains and the in hierarchical order from first parent to grandparent
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The value of the given valueField of the last grandparent record listed in the relatedDomains,
	 *   null if no grandparent exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, Object> accountNameByCaseId =
	 *         casesDomain.getParentDecimalFieldById(
	 *                 Schema.Account.Name,
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Case.ContactId => contactDomain,
	 *                         Schema.Contact.AccountId => accountDomain
	 *                 });
	 */
	public virtual Map<Id, Decimal> getParentDecimalFieldById(
			Schema.SObjectField valueField,
			Map<Schema.SObjectField, fflib_ISObjects2> domainsByRelationshipField)
	{
		Map<Id, Id> parentIdByChildId = getParentIdById(domainsByRelationshipField);

		List<fflib_ISObjects2> domains = domainsByRelationshipField.values();
		fflib_SObjects2 lastGrandParentDomain = (fflib_SObjects2) domains.get(domains.size() - 1);

		return fflib_ArrayUtils.replaceValue(
				parentIdByChildId,
				lastGrandParentDomain.getDecimalById(
						valueField,
						lastGrandParentDomain.getSObjectType().getDescribe().fields.getMap().get('Id')));
	}

	/**
	 * Gets the field value from the last given grandparent domain by the record Id
	 *
	 * @param valueField The field use return as value for the map
	 * @param domainsByRelationshipField A Map of domains and the in hierarchical order from first parent to grandparent
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The value of the given valueField of the last grandparent record listed in the relatedDomains,
	 *   null if no grandparent exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, Object> accountNameByCaseId =
	 *         casesDomain.getParentBooleanFieldById(
	 *                 Schema.Account.Name,
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Case.ContactId => contactDomain,
	 *                         Schema.Contact.AccountId => accountDomain
	 *                 });
	 */
	public virtual Map<Id, Boolean> getParentBooleanFieldById(
			Schema.SObjectField valueField,
			Map<Schema.SObjectField, fflib_ISObjects2> domainsByRelationshipField)
	{
		Map<Id, Id> parentIdByChildId = getParentIdById(domainsByRelationshipField);

		List<fflib_ISObjects2> domains = domainsByRelationshipField.values();
		fflib_SObjects2 lastGrandParentDomain = (fflib_SObjects2) domains.get(domains.size() - 1);

		return fflib_ArrayUtils.replaceValue(
				parentIdByChildId,
				lastGrandParentDomain.getBooleanFieldByIdField(
						valueField,
						lastGrandParentDomain.getSObjectType().getDescribe().fields.getMap().get('Id')));
	}

	/**
	 * Gets the field value from the last given grandparent domain by the record Id
	 *
	 * @param valueField The field use return as value for the map
	 * @param domainsByRelationshipField A Map of domains and the in hierarchical order from first parent to grandparent
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The value of the given valueField of the last grandparent record listed in the relatedDomains,
	 *   null if no grandparent exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, Object> accountNameByCaseId =
	 *         casesDomain.getParentBooleanFieldById(
	 *                 Schema.Account.Name,
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Case.ContactId => contactDomain,
	 *                         Schema.Contact.AccountId => accountDomain
	 *                 });
	 */
	public virtual Map<Id, Id> getParentIdFieldById(
			Schema.SObjectField valueField,
			Map<Schema.SObjectField, fflib_ISObjects2> domainsByRelationshipField)
	{
		Map<Id, Id> parentIdByChildId = getParentIdById(domainsByRelationshipField);

		List<fflib_ISObjects2> domains = domainsByRelationshipField.values();
		fflib_SObjects2 lastGrandParentDomain = (fflib_SObjects2) domains.get(domains.size() - 1);

		return fflib_ArrayUtils.replaceValue(
				parentIdByChildId,
				lastGrandParentDomain.getIdFieldByIdField(
						valueField,
						lastGrandParentDomain.getSObjectType().getDescribe().fields.getMap().get('Id')));
	}

	/**
	 * Creates a map between the record Ids of this domain to the last given grandparent domain.
	 *
	 * @param domainsByRelationshipField A Map of domains and the in hierarchical order from first parent to grandparent
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The Id of the last grandparent record listed in the relatedDomains,
	 *   null if no grandparent exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, Id> accountIdByCaseId =
	 *         casesDomain.getParentIdById(
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Case.ContactId => contactDomain,
	 *                         Schema.Contact.AccountId => accountDomain
	 *                 });
	 */
	public virtual Map<Id, Id> getParentIdById(Map<Schema.SObjectField, fflib_ISObjects2> domainsByRelationshipField)
	{
		// Clone the domain map as we are about to modify it within this method
		Map<SObjectField, fflib_ISObjects2> domains = domainsByRelationshipField.clone();

		// Takes the highest related domain from the domains
		Schema.SObjectField relationshipField =
				new List<Schema.SObjectField>(domains.keySet())
				.get(0);
		fflib_ISObjects2 relatedDomain = domains.remove(relationshipField);

		// Extract the Id values of the related SObjectType
		Map<Id, Id> result = getIdFieldByIdField(
				relationshipField,
				getSObjectType().getDescribe().fields.getMap().get('Id'));

		// Check if we need to resolve another parent relation, if not return the results
		if (domains.isEmpty()) return result;

		// Fetch the Ids of the related SObjectType
		Map<Id, Id> parentIdByChildId = relatedDomain.getParentIdById(domains);

		// Replace the maps value (ParentId) with the grand parent Id
		return fflib_ArrayUtils.replaceValue(result, parentIdByChildId);
	}

	/** DEPRECATED **/
	public virtual Map<Id, Id> getGrandParentIdById(List<fflib_ISObjects2> relatedDomains)
	{
		System.debug(LoggingLevel.WARN,
				'The \'getGrandParentIdById(List<fflib_ISObjects2> relatedDomains)\' method is deprecated,' +
						'please refactor to \'getParentIdById(Map<Schema.SObjectField, fflib_ISObjects2> relatedDomains)\'');

		fflib_ISObjects2 relatedDomain = relatedDomains.remove(0);
		SObjectType relatedDomainType = relatedDomain.getSObjectType();
		Map<SObjectType, SObjectField> relatedFieldByDomainType = getRelatedFieldByDomainType();

		if (relatedFieldByDomainType.containsKey(relatedDomainType) == false)
			throw new DeveloperException(
					String.format(
							'RelatedDomain type {0} not present in method getRelatedFieldByDomainType',
							new List<String> {String.valueOf(relatedDomainType)}));

		Map<Id, Id> result = getIdFieldByIdField(
				relatedFieldByDomainType.get(relatedDomainType),
				getSObjectType().getDescribe().fields.getMap().get('Id'));

		// Check if we need to resolve another parent relation, if not return the results
		if (relatedDomains.isEmpty()) return result;

		Map<Id, Id> grandChildIdByChildId = relatedDomain.getGrandParentIdById(relatedDomains);

		// Replace the maps value (childId) with the grand child Id
		return fflib_ArrayUtils.replaceValue(result, grandChildIdByChildId);
	}

	/**
	 * Creates a map between the record Ids of this domain to the last given child domain.
	 * This method is using getRelatedFieldByDomainType to determine which SObjectField
	 * is related to the given parent domain
	 *
	 * @param domainsByRelationshipField A Map of domains in hierarchical order from first child to grandchild
	 *
	 * @return Returns a map with KEY: The Ids of the records in this domain,
	 *   to the VALUE: The record Ids of the lowest child related record listed in the relatedDomains,
	 *   null if no grandchild exists.
	 *
	 * @example
	 * ICases casesDomain = Cases.newInstance(caseRecords);
	 * IContacts contactsDomain = Contacts.newInstance(contactRecords);
	 * IAccount accountDomain = Accounts.newInstance(accountRecords);
	 *
	 * // A map with key - Case.Id to value - Account.Id
	 * Map<Id, Set<Id>> caseIdsByAccountId =
	 *         accountsDomain.getChildIdsById(
	 *                 new Map<Schema.SObjectField, fflib_SObjects2>
	 *                 {
	 *                         Schema.Contact.AccountId => contactsDomain
	 *                         Schema.Case.ContactId => casesDomain,
	 *                 });
	 */
	public virtual Map<Id, Set<Id>> getChildIdsById(Map<Schema.SObjectField, fflib_SObjects2> domainsByRelationshipField)
	{
		// Takes the highest related domain from the domains
		Schema.SObjectField relationshipField =
				new List<Schema.SObjectField>(domainsByRelationshipField.keySet())
						.get(0);
		fflib_SObjects2 relatedDomain = domainsByRelationshipField.remove(relationshipField);

		Map<Id, Set<Id>> result = relatedDomain.getIdFieldsByIdField(
				relatedDomain.getSObjectType().getDescribe().fields.getMap().get('Id'),
				relationshipField);

		// Check if we need to resolve another child relation, if not return the results
		if (domainsByRelationshipField.isEmpty()) return result;

		Map<Id, Set<Id>> childIdsById = relatedDomain.getChildIdsById(domainsByRelationshipField);

		// Replace the maps value (childIds) with the grand child Id
		return fflib_ArrayUtils.replaceValues(result, childIdsById);
	}

	/** DEPRECATED **/
	public virtual Map<Id, Set<Id>> getChildIdsById(List<fflib_SObjects2> relatedDomains)
	{
		System.debug(LoggingLevel.WARN,
				'The \'getChildIdsById(List<fflib_ISObjects2> relatedDomains)\' method is deprecated,' +
						'please refactor to \'getChildIdsById(Map<Schema.SObjectField, fflib_ISObjects2> relatedDomains)\'');


		SObjectType thisDomainType = getSObjectType();
		fflib_SObjects2 relatedDomain = relatedDomains.remove(0);
		Map<SObjectType, SObjectField> relatedFieldByDomainType = relatedDomain.getRelatedFieldByDomainType();

		if (relatedFieldByDomainType.containsKey(thisDomainType) == false)
			throw new DeveloperException(
					String.format(
							'RelatedDomain type {0} not present in method getRelatedFieldByDomainType',
							new List<String> {String.valueOf(thisDomainType)}));

		SObjectField relatedLookupFieldOnChild = relatedFieldByDomainType.get(thisDomainType);
		Map<Id, Set<Id>> result = relatedDomain.getIdFieldsByIdField(
				relatedDomain.getSObjectType().getDescribe().fields.getMap().get('Id'),
				relatedLookupFieldOnChild);

		// Check if we need to resolve another child relation, if not return the results
		if (relatedDomains.isEmpty()) return result;

		Map<Id, Set<Id>> childIdsById = relatedDomain.getChildIdsById(relatedDomains);

		// Replace the maps value (childIds) with the grand child Id
		return fflib_ArrayUtils.replaceValues(result, childIdsById);
	}

	/**
	 * @return Returns the contents of the Domain by their primary Key ('Id' field)
	 */
	public virtual Map<Id, SObject> getSObjectById()
	{
		return new Map<Id, SObject>(getRecords());
	}

	/**
	 * @param ids Domain containing primary key (Id field) values
	 *
	 * @return Returns only the SObjects from the domain matching the given Ids.
	 */
	public virtual List<SObject> getRecords(fflib_Ids ids)
	{
		return getRecords(ids.getIds());
	}

	/**
	 * @param ids A Set containing primary key (Id field) values
	 *
	 * @return Returns only the SObjects from the domain matching the given Ids.
	 */
	public virtual List<SObject> getRecords(Set<Id> ids)
	{
		Map<Id, SObject> sObjectsByIds = getSObjectById();
		List<SObject> result = new List<SObject>();
		for (Id id : ids)
		{
			if (sObjectsByIds.containsKey(id) == false) continue;

			result.add(sObjectsByIds.get(id));
		}
		return result;
	}

	/**
	 * @param criteria The condition the returned record must meet
	 *
	 * @return Return the SObject records contained in the domain matching the criteria
	 */
	public virtual List<SObject> getRecords(fflib_Criteria criteria)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (!criteria.evaluate(record)) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * @return Trip the records from fields that the user doesn't have access to
	 */
	public virtual List<SObject> stripInaccessibleFields()
	{
		return stripInaccessibleFields(AccessType.READABLE);
	}

	/**
	 * @param accessType
	 *
	 * @return Trip the records from fields that the user doesn't have access to
	 */
	public virtual List<SObject> stripInaccessibleFields(
			System.AccessType accessType
	)
	{
		return Security.stripInaccessible(accessType, getRecords()).getRecords();
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Date values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Dates getDateFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Date> result = new Set<Date>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Date) fieldValue);
		}
		return new fflib_Dates(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Date values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Dates getDateFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getDateFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The DateTime values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Datetime> result = new Set<Datetime>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Datetime) fieldValue);
		}
		return new fflib_DateTimes(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The DateTime values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getDateTimeFieldValues(sObjectField);
	}

	/**
	 * @param decimalField The field to use as the Value of the returned Map
	 * @param idField The field to use as the Key of the returned map
	 *
	 * @return Returns a map with the values of two fields
	 */
	@TestVisible
	protected virtual Map<Id, Decimal> getDecimalById(Schema.SObjectField decimalField, Schema.SObjectField idField) {
		Map<Id, Decimal> result = new Map<Id, Decimal>();
		for (SObject record : getRecords())
		{
			if (record.get(idField) == null) continue;

			result.put(
					(Id) record.get(idField),
					(Decimal) record.get(decimalField)
			);
		}
		return result;
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get the SUM of
	 *
	 * @return The total SUM of the given field
	 */
	@TestVisible
	protected virtual Decimal getDecimalFieldSum(Schema.SObjectField sObjectField)
	{
		Decimal result = 0;
		for (SObject record : getRecords())
		{
			result += record.get(sObjectField) == null ? 0 : (Decimal) record.get(sObjectField);
		}
		return result;
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Decimal values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Decimals getDecimalFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Decimal> result = new Set<Decimal>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Decimal) fieldValue);
		}
		return new fflib_Decimals(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Decimal values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Decimals getDecimalFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getDecimalFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Double values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Doubles getDoubleFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Double> result = new Set<Double>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Double) fieldValue);
		}
		return new fflib_Doubles(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Double values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Doubles getDoubleFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getDoubleFieldValues(sObjectField);
	}

	/**
	 * Get a map with the values of two fields.
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The field to use as the Value of the Map
	 * @param keyField The field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Accounts accounts = Accounts.newInstance(records);
	 * Map<Object, Object> accountNameById = accounts.getFieldByField(Account.Name, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Object, Object> getFieldByField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Object, Object> result = new Map<Object, Object>();
		for (SObject record : getRecords())
		{
			if (record.get(keyField) == null) continue;

			result.put(
					record.get(keyField),
					record.get(valueField)
			);
		}
		return result;
	}

	/**
	 * Get a map with the values of two fields
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The field to use as the Value of the Map
	 * @param keyField The field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Contacts contacts = Contacts.newInstance(records);
	 * Map<Object, Set<Object>> contactIdByAccountId = contacts.getFieldsByField(Contact.Id, Contact.AccountId);
	 */
	@TestVisible
	protected virtual Map<Object, Set<Object>> getFieldsByField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Object, Set<Object>> result = new Map<Object, Set<Object>>();
		for (SObject record : getRecords())
		{
			Object keyFieldValue = record.get(keyField);
			if (keyFieldValue == null) continue;

			if (!result.containsKey(keyFieldValue))
			{
				result.put(keyFieldValue, new Set<Object>());
			}
			result.get(keyFieldValue).add(record.get(valueField));
		}
		return result;
	}

	/**
	 * Get a map with the values of two fields.
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The field to use as the Value of the Map
	 * @param keyField The Id field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Accounts accounts = Accounts.newInstance(records);
	 * Map<Id, Object> accountNameById = accounts.getFieldValueByIdField(Account.Name, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, Object> getFieldValueByIdField(SObjectField valueField, SObjectField keyField) {
		return fflib_ArrayUtils.getValueById(this, valueField, keyField);
	}

	/**
	 * @return Returns only the first SObject contained in the domain.
	 */
	public SObject getFirstSObject()
	{
		if (isEmpty()) return null;

		return getRecords().get(0);
	}

	/**
	 * Get a map with the values of a String field as key and Id field
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Id field to use as the Value of the Map
	 * @param keyField The String field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Contacts contacts = Contacts.newInstance(records);
	 * Map<String, Id> accountIdByContactId = contacts.getIdFieldByStringField(Contact.Id, Contact.Name);
	 */
	@TestVisible
	protected virtual Map<String, Id> getIdFieldByStringField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<String, Id> result = new Map<String, Id>();
		for (SObject record : getRecords())
		{
			if (record.get(keyField) == null) continue;

			result.put(
					(String) record.get(keyField),
					(Id) record.get(valueField)
			);
		}
		return result;
	}

	/**
	 * Get a map with the values of two Id fields
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Id field to use as the Value of the Map
	 * @param keyField The Id field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Contacts contacts = Contacts.newInstance(records);
	 * Map<Id, Id> accountIdByContactId = contacts.getIdFieldByIdField(Contact.AccountId, Contact.Id);
	 */
	@TestVisible
	protected virtual Map<Id, Id> getIdFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, Id> result = new Map<Id, Id>();
		for (SObject record : getRecords())
		{
			if (record.get(keyField) == null) continue;

			result.put(
					(Id) record.get(keyField),
					(Id) record.get(valueField)
			);
		}
		return result;
	}

	/**
	 * Get a map with the values of two Id fields with a one to many relation
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Id field to use as the Value of the Map
	 * @param keyField The Id field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Contacts contacts = Contacts.newInstance(records);
	 * Map<Id, Set<Id>> contactIdByAccountId = contacts.getIdFieldsByIdField(Contact.Id, Contact.AccountId);
	 */
	@TestVisible
	protected virtual Map<Id, Set<Id>> getIdFieldsByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, Set<Id>> result = new Map<Id, Set<Id>>();
		for (SObject record : getRecords())
		{
			Id keyFieldId = (Id) record.get(keyField);
			if (keyFieldId == null) continue;

			if (!result.containsKey(keyFieldId))
			{
				result.put(keyFieldId, new Set<Id>());
			}
			result.get(keyFieldId).add((Id) record.get(valueField));
		}
		return result;
	}

	/**
	 * Get a map with the values of an Id field by a String field with a one to many relation
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Id field to use as the Value of the Map
	 * @param keyField The String field to use as the Key of the map
	 *
	 * @return Returns a map with the values of two fields
	 *
	 * @example
	 * Accounts accounts = Accounts.newInstance(records);
	 * Map<String, Set<Id>> accountIdsByCountry = accounts.getIdFieldsByStringField(Account.BillingCountry, Account.Id);
	 */
	@TestVisible
	protected virtual Map<String, Set<Id>> getIdFieldsByStringField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<String, Set<Id>> result = new Map<String, Set<Id>>();
		for (SObject record : getRecords())
		{
			String keyFieldString = String.valueOf(record.get(keyField));
			if (keyFieldString == null) continue;

			if (!result.containsKey(keyFieldString))
			{
				result.put(keyFieldString, new Set<Id>());
			}
			result.get(keyFieldString).add((Id) record.get(valueField));
		}
		return result;
	}

	/**
	 * Gets the Id values, but with the option to omit null values
	 *
	 * @param field The Schema.SObjectField to get their Id values
	 * @param omitNulls If set to TRUE, null values will be removed from the result
	 *
	 * @return The Id values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected Set<Id> getIdFieldValues(Schema.SObjectField field, Boolean omitNulls)
	{
		Set<Id> result = getIdFieldValues(field);

		if (omitNulls)
		{
			result.remove(null);
		}
		return result;
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Id values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Ids getIdFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_Ids(new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getIdFieldValues(sObjectField));
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 *
	 * @return The Integer values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Integers getIntegerFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Integer> result = new Set<Integer>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;

			result.add(Integer.valueOf(fieldValue));
		}
		return new fflib_Integers(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Integer values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Integers getIntegerFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getIntegerFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 *
	 * @return The Long values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Longs getLongFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Long> result = new Set<Long>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Long) fieldValue);
		}
		return new fflib_Longs(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Long values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual fflib_Longs getLongFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getLongFieldValues(sObjectField);
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Id idValue)
	{
		return getRecords(sObjectField, new Set<Id>{ idValue });
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Set<Id> values)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (values?.contains((Id) record.get(sObjectField)))
			{
				result.add(record);
			}
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, String value)
	{
		if (sObjectField.getDescribe().getType() == DisplayType.MULTIPICKLIST)
			return getRecords(sObjectField, new Set<String>{value}, true);

		return getRecords(sObjectField, new Set<String>{ value });
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Set<String> values)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (values?.contains((String) record.get(sObjectField)))
			{
				result.add(record);
			}
		}
		return result;
	}

	/**
	 * Gets the records from the domain matching values in the given multi-select picklist field
	 *
	 * @param sObjectField The SObjectType of the multi-select picklist
	 * @param values The values to filter by
	 * @param containsAll If TRUE the returned records have all the given values, otherwise a record with just one value is also returned
	 *
	 * @return Returns a list of matching SObjects
	 */
	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Set<String> values, Boolean containsAll)
	{
		if (sObjectField.getDescribe().getType() != DisplayType.MULTIPICKLIST) return getRecords(sObjectField, values);

		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			String value = (String) record.get(sObjectField);

			if ((value == null && (values == null || values.isEmpty() || values.contains(null))) // if values is empty and the field is empty = match!
					|| (value != null && containsAll && new Set<String>(value.split(';')).containsAll(values))
			)
			{
				result.add(record);
			}
			else if (value != null && containsAll == false)
			{
				Set<String> fieldValues = new Set<String>(value.split(';'));
				for (String fieldValue : fieldValues)
				{
					if (values.contains(fieldValue))
					{
						result.add(record);
						break;
					}
				}
			}
		}
		return result;
	}

	/**
	 * Returns a list of records where the given field contains the provided value (String.contains)
	 *
	 * @param sObjectField The field to check
	 * @param value The value the field must contain
	 *
	 * @return Returns a list of `SObjects` where the field contains the value
	 */
	@TestVisible
	protected virtual List<SObject> getRecordsContaining(Schema.SObjectField sObjectField, String value)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			String fieldValue = (String) record.get(sObjectField);
			if ((fieldValue == null && value == null)
					||
					(fieldValue != null && fieldValue.contains(value))
			) {
				result.add(record);
			}
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecordsIsNot(Schema.SObjectField sObjectField, String value)
	{
		return getRecordsNotIn(sObjectField, new Set<String>{ value });
	}

	@TestVisible
	protected virtual List<SObject> getRecordsNotIn(Schema.SObjectField sObjectField, Set<String> values)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (values?.contains((String) record.get(sObjectField))) continue;
			result.add(record);
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecordsIsNot(Schema.SObjectField sObjectField, Decimal value)
	{
		return getRecordsNotIn(sObjectField, new Set<Decimal>{ value });
	}

	@TestVisible
	protected virtual List<SObject> getRecordsNotIn(Schema.SObjectField sObjectField, Set<Decimal> values)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (values?.contains((Decimal) record.get(sObjectField))) continue;
			result.add(record);
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecordsIsNot(Schema.SObjectField sObjectField, Id idValue)
	{
		return getRecordsNotIn(sObjectField, new Set<Id>{ idValue });
	}

	@TestVisible
	protected virtual List<SObject> getRecordsNotIn(Schema.SObjectField sObjectField, Set<Id> idValues)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if (idValues?.contains((Id) record.get(sObjectField)) == false)
			{
				result.add(record);
			}
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Boolean value)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if ((Boolean) record.get(sObjectField) == value)
			{
				result.add(record);
			}
		}
		return result;
	}

	@TestVisible
	protected virtual List<SObject> getRecords(Schema.SObjectField sObjectField, Decimal value)
	{
		List<SObject> result = new List<SObject>();
		for (SObject record : getRecords())
		{
			if ((Decimal) record.get(sObjectField) != value) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Get Parent Domain SObjectType to SObjectField.relationship field on this domain SObjectType
	 *
	 * @return Returns a map of the Parent Domain SObjectType to SObjectField.relationship field on the SObjectType
	 */
	protected virtual Map<SObjectType, Schema.SObjectField> getRelatedFieldByDomainType()
	{
		return new Map<SObjectType, Schema.SObjectField>();
	}

	/**
	 * Get a map with the record mapped to the given Id field value
	 * Key fields containing null values are omitted
	 *
	 * @param sObjectField The field to use as key for the map
	 *
	 * @return Returns a map with the record mapped to the given Id field value
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, SObject> accountById = account.getSObjectByIdField(Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, SObject> getSObjectByIdField(Schema.SObjectField sObjectField)
	{
		Map<Id, SObject> result = new Map<Id, SObject>();
		for (SObject record : getRecords())
		{
			if (record.get(sObjectField) == null) continue;

			result.put((Id) record.get(sObjectField), record);
		}
		return result;
	}

	/**
	 * Get a map with the records mapped to the given Id field value
	 * Key fields containing null values are omitted
	 *
	 * @param sObjectField The field to use as key for the map
	 *
	 * @return Returns a map with the records mapped to the given Id field value
	 *
	 * @example
	 * Contacts contacts = Contacts.newInstance(records);
	 * Map<Id, List<SObject>> contactsByAccountId = contacts.getSObjectsByIdField(Contact.AccountId);
	 */
	@TestVisible
	protected virtual Map<Id, List<SObject>> getSObjectsByIdField(Schema.SObjectField sObjectField)
	{
		Map<Id, List<SObject>> result = new Map<Id, List<SObject>>();
		for (SObject record : getRecords())
		{
			Id fieldId = (Id) record.get(sObjectField);
			if (fieldId == null) continue;

			if (!result.containsKey(fieldId))
			{
				result.put(fieldId, new List<SObject>());
			}
			result.get(fieldId).add(record);
		}
		return result;
	}

	/**
	 * Get a map with the record mapped to the given String field value
	 * Key fields containing null values are omitted
	 *
	 * @param sObjectField The field to use as key for the map
	 *
	 * @return Returns a map with the record mapped to the given String field value
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<String, SObject> accountByNumber = account.getSObjectByStringField(Account.AccountNumber);
	 */
	@TestVisible
	protected virtual Map<String, SObject> getSObjectByStringField(Schema.SObjectField sObjectField)
	{
		Map<String, SObject> result = new Map<String, SObject>();
		for (SObject record : getRecords())
		{
			if (record.get(sObjectField) == null) continue;

			String fieldValue = (String) record.get(sObjectField);
			result.put(fieldValue, record);
		}
		return result;
	}

	/**
	 * Get a map with the records mapped to the given String field value
	 * Key fields containing null values are omitted
	 *
	 * @param sObjectField The field to use as key for the map
	 *
	 * @return Returns a map with the records mapped to the given String field value
	 *
	 * @example
	 * Accounts accounts = Account.newInstance(records);
	 * Map<String, List<SObject>> accountByName = accounts.getSObjectsByStringField(Account.AccountName);
	 */
	@TestVisible
	protected virtual Map<String, List<SObject>> getSObjectsByStringField(Schema.SObjectField sObjectField)
	{
		Map<String, List<SObject>> result = new Map<String, List<SObject>>();
		for (SObject record : getRecords())
		{
			String fieldValue = (String) record.get(sObjectField);
			if (fieldValue == null) continue;

			if (!result.containsKey(fieldValue))
			{
				result.put(fieldValue, new List<SObject>());
			}
			result.get(fieldValue).add(record);
		}
		return result;
	}

	/**
	 * Get a map with the given String field value mapped to the given Id field
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The String field to use as value for the map
	 * @param keyField The Id field to use as key for the map
	 *
	 * @return a map with the given String field value mapped to the given Id field
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, String> accountNameById = account.getStringFieldByIdField(Account.AccountName, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, String> getStringFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, String> result = new Map<Id, String>();
		Map<Object, Object> fieldByField = getFieldByField(valueField, keyField);
		for (Object obj : fieldByField.keySet())
		{
			result.put((Id) obj, (String) fieldByField.get(obj));
		}
		return result;
	}

	/**
	 * Get a map with the given Date field value mapped to the given Id field
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The Date field to use as value for the map
	 * @param keyField The Id field to use as key for the map
	 *
	 * @return a map with the given Date field value mapped to the given Id field
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, Date> createdDateById = account.getDateFieldByIdField(Account.CreatedDate, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, Date> getDateFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, Date> result = new Map<Id, Date>();
		Map<Object, Object> fieldByField = getFieldByField(valueField, keyField);
		for (Object obj : fieldByField.keySet())
		{
			Object value = fieldByField.get(obj);
			Date dateValue;
			if (value instanceof Date)
			{
				dateValue = (Date) value;
			}
			else if (value != null)
			{
				dateValue = ((Datetime) value).date();
			}
			result.put((Id) obj, dateValue);
		}
		return result;
	}

	/**
	 * Get a map with the given Date field value mapped to the given Id field
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The DateTime field to use as value for the map
	 * @param keyField The Id field to use as key for the map
	 *
	 * @return a map with the given Date field value mapped to the given Id field
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, Datetime> createdDateById = account.getDateFieldByIdField(Account.CreatedDate, Account.Id);
	 */
	@TestVisible
	protected virtual Map<Id, Datetime> getDateTimeFieldByIdField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<Id, Datetime> result = new Map<Id, Datetime>();
		Map<Object, Object> fieldByField = getFieldByField(valueField, keyField);
		for (Object obj : fieldByField.keySet())
		{
			result.put((Id) obj, (Datetime) fieldByField.get(obj));
		}
		return result;
	}

	/**
	 * Get a map with the records mapped to the given String field value
	 * Key fields containing null values are omitted
	 *
	 * @param valueField The field to use as value for the map
	 * @param keyField The field to use as key for the map
	 *
	 * @return Returns a map with the record mapped to the given Id field value
	 *
	 * @example
	 * Account account = Account.newInstance(records);
	 * Map<Id, String> accountNameById = account.getStringFieldByStringField(Account.AccountName, Account.Id);
	 */
	@TestVisible
	protected virtual Map<String, String> getStringFieldByStringField(Schema.SObjectField valueField, Schema.SObjectField keyField)
	{
		Map<String, String> result = new Map<String, String>();
		Map<Object, Object> fieldByField = getFieldByField(keyField, valueField);
		for (Object obj : fieldByField.keySet())
		{
			result.put((String) obj, (String) fieldByField.get(obj));
		}
		return result;
	}


	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The String values of the given sObjectField
	 */
	@TestVisible
	protected virtual fflib_Strings getStringFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new fflib_Strings(new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.getStringFieldValues(sObjectField));
	}

	/**
	 * Sets the given value to the given field only when the criteria is met for the record
	 *
	 * @param sObjectField The Schema.SObjectField to change its value
	 * @param value The new value for the given sObjectField
	 * @param criteria The criteria condition that must be met to include the value in the return
	 */
	@TestVisible
	protected virtual void setFieldValue(Schema.SObjectField sObjectField, Object value, fflib_Criteria criteria)
	{
		new fflib_SObjects2(getRecords(criteria), getSObjectType())
				.setFieldValue(sObjectField, value);
	}

	/**
	 * Sets a value to the given field only when key field Id value is provided in the given map
	 *
	 * @param sObjectIdFieldToCheck The SObject Id Field to match the key against in the provided map
	 * @param sObjectFieldToUpdate The SObjectField to store the mapped value when the key matches the value in the sObjectFieldToUpdate field
	 * @param values Map of values to store by the sObjectIdFieldToCheck fields value
	 */
	@TestVisible
	protected virtual void setFieldValue(
			Schema.SObjectField sObjectIdFieldToCheck,
			Schema.SObjectField sObjectFieldToUpdate,
			Map<Id, Object> values)
	{
		fflib_ArrayUtils.setFieldValue(this, sObjectIdFieldToCheck, sObjectFieldToUpdate, values);
	}

	/**
	 * Sets a value to the given field only when key field String value is provided in the given map
	 *
	 * @param sObjectStringFieldToCheck The SObject String Field to match the key against in the provided map
	 * @param sObjectFieldToUpdate The SObjectField to store the mapped value when the key matches the value in the sObjectFieldToUpdate field
	 * @param values Map of values to store by the sObjectIdFieldToCheck fields value
	 */
	@TestVisible
	protected virtual void setFieldValue(
			Schema.SObjectField sObjectStringFieldToCheck,
			Schema.SObjectField sObjectFieldToUpdate,
			Map<String, Object> values)
	{
		for (SObject record : getRecords())
		{
			String keyValue = (String) record.get(sObjectStringFieldToCheck);
			if (values?.containsKey(keyValue))
			{
				record.put(sObjectFieldToUpdate, values.get(keyValue));
			}
		}

	}

	public class DeveloperException extends Exception { }
}