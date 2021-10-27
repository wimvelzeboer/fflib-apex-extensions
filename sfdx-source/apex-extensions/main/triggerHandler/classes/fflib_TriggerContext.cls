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


	public fflib_TriggerContext(List<SObject> records)
	{
		super(records);
	}

	/**
     * Provides access to the data represented by this Trigger Context
     **/
	public System.TriggerOperation getTriggerOperation()
	{
		return triggerOperation;
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
	 * Constructor to construct the Trigger Context class
	 */
	public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_IDomain construct(List<Object> objects)
		{
			return new fflib_TriggerContext((List<SObject>) objects);
		}
	}
}