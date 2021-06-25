/**
 * File Name: SObjects
 * Description: Primitive domain for the object type SObject
 *
 * @author : architect ir. Wilhelmus G.J. Velzeboer
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
public virtual class SObjects
		extends fflib_SObjects
		implements fflib_ISObjects
{
	protected Schema.DescribeSObjectResult SObjectDescribe { get; private set; }

	/**
	 * Class constructors
	 *
	 * @param objects The Objects of type SObjectType, to contain inside the domain
	 */
	public SObjects(List<Object> objects)
	{
		// todo - assert of objects of type SObject
		this((List<SObject>) objects);
	}

	/**
	 * Class constructor
	 *
	 * @param records The records to contain inside the domain
	 */
	public SObjects(List<SObject> records)
	{
		this(records, records.getSObjectType());
	}

	/**
	 * Class constructor
	 *
	 * @param records The records to contain inside the domain
	 * @param sObjectType The SObjectType of the records
	 */
	public SObjects(List<SObject> records, Schema.SObjectType sObjectType)
	{
		super(records, sObjectType);
		SObjectDescribe = sObjectType.getDescribe();
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
	public virtual List<SObject> getRecords(Ids ids)
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
	 * Adds an error message to the records in the domain
	 *
	 * @param message The error message to add to each record
	 */
	@TestVisible
	protected virtual void addError(String message)
	{
		for (SObject record : getRecords())
		{
			record.addError(error(message, record));
		}
	}

	/**
	 * Adds an error message to the a field records in the domain
	 *
	 * @param sObjectField The field where the error should be reported
	 * @param message The error message to add to the given field on each record
	 */
	@TestVisible
	protected virtual void addError(Schema.SObjectField sObjectField, String message)
	{
		for (SObject record : getRecords())
		{
			record.addError(sObjectField, error(message, record, sObjectField));
		}
	}

	/**
	 * Clear the field value on all the records of the domain
	 * @param sObjectField The field to nullify
	 */
	@TestVisible
	protected virtual void clearField(Schema.SObjectField sObjectField)
	{
		clearFields(new Set<Schema.SObjectField>{ sObjectField });
	}

	/**
	 * Clear the field values on all the records of the domain
	 * @param sObjectFields The fields to nullify
	 */
	@TestVisible
	protected virtual void clearFields(Set<Schema.SObjectField> sObjectFields)
	{
		for (SObject record : getRecords())
		{
			for (SObjectField sObjectField : sObjectFields)
			{
				record.put(sObjectField, null);
			}
		}
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Date values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Dates getDateFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Date> result = new Set<Date>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Date) fieldValue);
		}
		return new Dates(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Date values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Dates getDateFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getDateFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The DateTime values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Datetime> result = new Set<Datetime>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Datetime) fieldValue);
		}
		return new DateTimes(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The DateTime values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual DateTimes getDateTimeFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getDateTimeFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Decimal values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Decimals getDecimalFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Decimal> result = new Set<Decimal>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Decimal) fieldValue);
		}
		return new Decimals(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Decimal values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Decimals getDecimalFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getDecimalFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Double values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Doubles getDoubleFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Double> result = new Set<Double>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Double) fieldValue);
		}
		return new Doubles(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Double values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Doubles getDoubleFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getDoubleFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 *
	 * @return The Id values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Ids getIdFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Id> result = new Set<Id>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add(Id.valueOf(String.valueOf(fieldValue)));
		}
		return new Ids(result);
		// todo - alternative return to avoid code duplications: return new Ids(getFieldValues(sObjectField));
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their Id values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Id values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Ids getIdFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getIdFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 *
	 * @return The Integer values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Integers getIntegerFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Integer> result = new Set<Integer>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add(Integer.valueOf(fieldValue));
		}
		return new Integers(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Integer values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Integers getIntegerFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getIntegerFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 *
	 * @return The Long values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Longs getLongFieldValues(Schema.SObjectField sObjectField)
	{
		Set<Long> result = new Set<Long>();
		for (SObject record : getRecords())
		{
			Object fieldValue = record.get(sObjectField);
			if (fieldValue == null) continue;
			result.add((Long) fieldValue);
		}
		return new Longs(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The Long values of the given sObjectField, null values are omitted
	 */
	@TestVisible
	protected virtual Longs getLongFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getLongFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 *
	 * @return The String values of the given sObjectField
	 */
	@TestVisible
	protected virtual Strings getStringFieldValues(Schema.SObjectField sObjectField)
	{
		Set<String> result = new Set<String>();
		for (SObject record : getRecords())
		{
			result.add(String.valueOf(record.get(sObjectField)));
		}
		return new Strings(result);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to get their values
	 * @param criteria The criteria condition that must be met to include the value in the return
	 *
	 * @return The String values of the given sObjectField
	 */
	@TestVisible
	protected virtual Strings getStringFieldValues(Schema.SObjectField sObjectField, fflib_Criteria criteria)
	{
		return new SObjects(getRecords(criteria))
				.getStringFieldValues(sObjectField);
	}

	/**
	 * @param sObjectField The Schema.SObjectField to change its value
	 * @param value The new value for the given sObjectField
	 * @param criteria The criteria condition that must be met to include the value in the return
	 */
	@TestVisible
	protected virtual void setFieldValue(Schema.SObjectField sObjectField, Object value, fflib_Criteria criteria)
	{
		new SObjects(getRecords(criteria))
				.setFieldValue(sObjectField, value);
	}
}