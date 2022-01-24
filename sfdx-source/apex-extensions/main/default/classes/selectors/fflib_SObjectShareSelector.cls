/**
 * File Name: fflib_SObjectShareSelector
 *
 * @description Abstract selector for SObject Shares
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
public abstract inherited sharing class fflib_SObjectShareSelector
		extends fflib_SObjectSelector
{
	private String accessLevelFieldName
	{
		get
		{
			if (accessLevelFieldName == null)
			{
				accessLevelFieldName = fflib_SObjectShare.getAccessLevelFieldName(getSObjectType2());
			}
			return accessLevelFieldName;
		}
		private set;
	}
	private String parentIdFieldName
	{
		get
		{
			if (parentIdFieldName == null)
			{
				parentIdFieldName = fflib_SObjectShare.getParentIdFieldName(getSObjectType2());
			}
			return parentIdFieldName;
		}
		private set;
	}
	private String rowCauseFieldName = 'RowCause';
	private String userOrGroupIdName = 'UserOrGroupId';
	private List<Schema.SObjectField> sObjectFieldList
	{
		get
		{
			if (sObjectFieldList == null)
			{
				SObjectType sObjectType = getSObjectType2();
				fflib_SObjectDescribe sObjectDescribe = fflib_SObjectDescribe.getDescribe(sObjectType);
				sObjectFieldList = new List<Schema.SObjectField>
				{
						fflib_SObjectShare.getIdField(sObjectType),
						fflib_SObjectShare.getAccessLevelField(sObjectType),
						fflib_SObjectShare.getParentIdField(sObjectType),
						fflib_SObjectShare.getRowCauseField(sObjectType),
						fflib_SObjectShare.getUserOrGroupIdField(sObjectType)
				};
			}
			return sObjectFieldList;
		}
		private set;
	}

	public List<Schema.SObjectField> getSObjectFieldList()
	{
		return sObjectFieldList;
	}

	protected List<SObject> selectShareByParentId(Set<Id> parentIds)
	{
		return Database.query(
				newQueryFactory()
						.setCondition(parentIdFieldName + ' IN :parentIds')
						.toSOQL());
	}

	protected List<SObject> selectShareByParentId(Set<Id> parentIds, Set<Id> userOrGroupIds)
	{
		return Database.query(
				newQueryFactory()
						.setCondition(parentIdFieldName + ' IN :parentIds AND ' + userOrGroupIdName + ' IN :userOrGroupIds')
						.toSOQL());
	}

	protected List<SObject> selectShareByParentId(Set<Id> parentIds, Set<Id> userOrGroupIds, Set<String> accessLevels)
	{
		return Database.query(
				newQueryFactory()
						.setCondition(parentIdFieldName + ' IN :parentIds AND '
						+ userOrGroupIdName + ' IN :userOrGroupIds AND '
						+ accessLevelFieldName + ' IN :accessLevels')
						.toSOQL());
	}

	protected List<SObject> selectShareByParentId(Set<Id> parentIds, Set<String> rowCauses)
	{
		return Database.query(
				newQueryFactory()
						.setCondition(parentIdFieldName + ' IN :parentIds AND ' + rowCauseFieldName + ' IN :rowCauses')
						.toSOQL());
	}
}