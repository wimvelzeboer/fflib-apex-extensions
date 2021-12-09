/**
 * File Name: fflib_TriggerActionConfig
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
public virtual inherited sharing class fflib_TriggerActionConfig
		implements fflib_ITriggerActionConfig
{
	protected Boolean afterDelete = false;
	protected Boolean afterInsert = false;
	protected Boolean afterUndelete = false;
	protected Boolean afterUpdate = false;
	protected Boolean beforeDelete = false;
	protected Boolean beforeInsert = false;
	protected Boolean beforeUpdate = false;
	protected Boolean stateful = false;
	protected System.Type implementationType { get; set; }
	protected Schema.SObjectType sObjectType { get; set; }
	protected Integer sequence = 0;
	protected Boolean dedicatedQueued;

	/**
	 * Class Constructor
	 * Takes a custom metadata records and translates that into an instance of fflib_TriggerActionConfig
	 *
	 * @param triggerAction Instance of fflib_TriggerActionConfig
	 */
	public fflib_TriggerActionConfig(fflib_TriggerAction__mdt triggerAction)
	{
		this.afterDelete = triggerAction.AfterDelete__c == null ? false : triggerAction.AfterDelete__c;
		this.afterInsert = triggerAction.AfterInsert__c == null ? false : triggerAction.AfterInsert__c;
		this.afterUndelete = triggerAction.AfterUndelete__c == null ? false : triggerAction.AfterUndelete__c;
		this.afterUpdate = triggerAction.AfterUpdate__c == null ? false : triggerAction.AfterUpdate__c;
		this.beforeDelete = triggerAction.BeforeDelete__c == null ? false : triggerAction.BeforeDelete__c;
		this.beforeInsert = triggerAction.BeforeInsert__c == null ? false : triggerAction.BeforeInsert__c;
		this.beforeUpdate = triggerAction.BeforeUpdate__c == null ? false : triggerAction.BeforeUpdate__c;
		this.implementationType = System.Type.forName(triggerAction.ImplementationType__c);
		this.sequence = triggerAction.Sequence__c == null ? 0 : Integer.valueOf(triggerAction.Sequence__c);
		this.stateful = triggerAction.Stateful__c == null ? false : triggerAction.Stateful__c;

		if (triggerAction.ExecutionContext__c == 'Queued') this.dedicatedQueued = false;
		else if (triggerAction.ExecutionContext__c == 'Dedicated Queued') this.dedicatedQueued = true;

		// Get SObjectType
		String ObjectTypeApiName =
				String.isNotBlank(triggerAction.ObjectType__c)
					? triggerAction.ObjectType__r?.QualifiedApiName?.toLowerCase().trim()
					: triggerAction.ObjectTypeAlternate__c.toLowerCase().trim();
		this.sObjectType = Schema.describeSObjects(new List<String> {ObjectTypeApiName}).get(0).getSObjectType();
	}

	/**
	 * @return Returns the Implementation Type of the Trigger Action
	 */
	public Type getImplementationType()
	{
		return this.implementationType;
	}

	/**
	 * @return Returns the sequence number of the trigger action
	 */
	public Integer getSequence()
	{
		return this.sequence;
	}

	/**
	 * @return Returns the SObjectType linked to the trigger action
	 */
	public SObjectType getSObjectType()
	{
		return this.sObjectType;
	}

	/**
	 * @return Returns TRUE if the trigger action should be executed in a dedicated Queueable context
	 */
	public Boolean isDedicatedQueued()
	{
		return (this.dedicatedQueued != null && this.dedicatedQueued);
	}

	/**
	 * @return Returns TRUE if the trigger action needs to be kept in memory and reused by the next TriggerHandler run
	 */
	public Boolean isStateful()
	{
		return this.stateful;
	}

	/**
	 * @return Returns TRUE if the trigger action can be executed in an Queueable context
	 */
	public Boolean isQueued()
	{
		return (this.dedicatedQueued != null);
	}

	/**
	 * Creates a new instance of the trigger action class based on the provided implementation type in the configuration
	 *
	 * @return Instance of the Trigger Action class
	 */
	public fflib_ITriggerAction newInstance()
	{
		return (fflib_ITriggerAction) implementationType.newInstance();
	}

	public Boolean hasTriggerContext(TriggerOperation triggerOperation)
	{
		return (triggerOperation == System.TriggerOperation.BEFORE_INSERT && beforeInsert)
				|| (triggerOperation == System.TriggerOperation.BEFORE_UPDATE && beforeUpdate)
				|| (triggerOperation == System.TriggerOperation.BEFORE_DELETE && beforeDelete)
				|| (triggerOperation == System.TriggerOperation.AFTER_DELETE && afterDelete)
				|| (triggerOperation == System.TriggerOperation.AFTER_INSERT && afterInsert)
				|| (triggerOperation == System.TriggerOperation.AFTER_UNDELETE && afterUndelete)
				|| (triggerOperation == System.TriggerOperation.AFTER_UPDATE && afterUpdate);
	}
}