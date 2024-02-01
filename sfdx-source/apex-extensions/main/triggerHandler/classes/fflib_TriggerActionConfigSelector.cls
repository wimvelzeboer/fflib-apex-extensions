/**
 * File Name: fflib_TriggerActionConfigSelector
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
public virtual without sharing class fflib_TriggerActionConfigSelector
		extends fflib_SObjectSelector
		implements fflib_ITriggerActionConfigSelector
{
	public fflib_TriggerActionConfigSelector()
	{
		super();
	}

	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField>
		{
				fflib_TriggerAction__mdt.Id,
				fflib_TriggerAction__mdt.AfterDelete__c,
				fflib_TriggerAction__mdt.AfterInsert__c,
				fflib_TriggerAction__mdt.AfterUndelete__c,
				fflib_TriggerAction__mdt.AfterUpdate__c,
				fflib_TriggerAction__mdt.BeforeDelete__c,
				fflib_TriggerAction__mdt.BeforeInsert__c,
				fflib_TriggerAction__mdt.BeforeUpdate__c,
				fflib_TriggerAction__mdt.ExecutionContext__c,
				fflib_TriggerAction__mdt.ImplementationType__c,
				fflib_TriggerAction__mdt.ObjectType__c,
				fflib_TriggerAction__mdt.ObjectTypeAlternate__c,
				fflib_TriggerAction__mdt.Sequence__c,
				fflib_TriggerAction__mdt.Stateful__c
		};
	}

	public Schema.SObjectType getSObjectType()
	{
		return Schema.fflib_TriggerAction__mdt.SObjectType;
	}

	/**
	 * @return Query all fflib_TriggerAction__mdt records
	 */
	public virtual List<fflib_TriggerAction__mdt> selectAllActive()
	{
		return (List <fflib_TriggerAction__mdt>) Database.query(

				String.format(
						'SELECT {0} FROM {1} WHERE IsActive__c=TRUE',
						new List<String>
						{
								getFieldListString() + ', ObjectType__r.QualifiedApiName',
								getSObjectType().getDescribe().getName()
						}
				)

	/* Please replace the above String.format method call for that below,
	   when the following issue in fflib-apex-commons is resolved:
	   https://github.com/apex-enterprise-patterns/fflib-apex-common/issues/208

				newQueryFactory()
						.selectField('ObjectType__r.QualifiedApiName')
						.toSOQL()

	 */
		);
	}
}