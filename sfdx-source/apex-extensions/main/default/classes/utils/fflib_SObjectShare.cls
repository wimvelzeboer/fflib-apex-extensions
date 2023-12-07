/**
 * File Name: fflib_SObjectShare 
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
public with sharing class fflib_SObjectShare
{
	private static final String ACCESS_LEVEL_EDIT = 'Edit';
	private static final String ACCESS_LEVEL_READ = 'Read';

	/**
	 * Creates a Share record for the given userOrGroup to the parentId with the access level "Edit"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentId The parent objects Id
	 * @param userOrGroupId The Id of the user or group
	 *
	 * @return Return the created share
	 */
	public static SObject createEditShare(
			SObjectType sObjectType,
			Id parentId,
			Id userOrGroupId)
	{
		return createEditShares(sObjectType, parentId, new Set<Id>{ userOrGroupId })
				.get(0);
	}

	/**
	 * Creates a Share record for each userOrGroup to the parentId with the access level "Edit"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentId The parent objects Id
	 * @param userOrGroupIds The Ids of the users or groups
	 *
	 * @return Returns a list of the created shares
	 */
	public static List<SObject> createEditShares(
			SObjectType sObjectType,
			Id parentId,
			Set<Id> userOrGroupIds)
	{
		return createEditShares(sObjectType, new Set<Id>{ parentId }, userOrGroupIds);
	}

	/**
	 * Creates a Share record for each userOrGroup for each parentId with the access level "Edit"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentIds The parents object Id
	 * @param userOrGroupIds The Id of the user or group
	 *
	 * @return Returns a list of the created shares
	 */
	public static List<SObject> createEditShares(
			SObjectType sObjectType,
			Set<Id> parentIds,
			Set<Id> userOrGroupIds)
	{
		return createShares(sObjectType, parentIds, userOrGroupIds, ACCESS_LEVEL_EDIT);
	}

	/**
	 * Creates a Share record for the given userOrGroup to the parentId with the access level "Read"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentId The parent objects Id
	 * @param userOrGroupId The Id of the user or group
	 *
	 * @return Return the created share
	 */
	public static SObject createReadShare(
			SObjectType sObjectType,
			Id parentId,
			Id userOrGroupId)
	{
		return createReadShares(sObjectType, parentId, new Set<Id>{ userOrGroupId })
				.get(0);
	}

	/**
	 * Creates a Share record for each userOrGroup to the parentId with the access level "Read"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentId The parent objects Id
	 * @param userOrGroupIds The Ids of the users or groups
	 *
	 * @return Returns a list of the created shares
	 */
	public static List<SObject> createReadShares(
			SObjectType sObjectType,
			Id parentId,
			Set<Id> userOrGroupIds)
	{
		return createReadShares(sObjectType, new Set<Id>{ parentId }, userOrGroupIds);
	}

	/**
	 * Creates a Share record for each userOrGroup for each parentId with the access level "Read"
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentIds The parents object Id
	 * @param userOrGroupIds The Id of the user or group
	 *
	 * @return Returns a list of the created shares
	 */
	public static List<SObject> createReadShares(
			SObjectType sObjectType,
			Set<Id> parentIds,
			Set<Id> userOrGroupIds)
	{
		return createShares(sObjectType, parentIds, userOrGroupIds, ACCESS_LEVEL_READ);
	}

	/**
	 * Creates a Share record for each userOrGroup for each parentId
	 *
	 * @param sObjectType The SObjectType of the share to create
	 * @param parentIds The parents object Id
	 * @param userOrGroupIds The Id of the user or group
	 * @param accessLevel The access level "Read" / "Edit" / "None"
	 *
	 * @return Returns a list of the created shares
	 */
	public static List<SObject> createShares(
			SObjectType sObjectType,
			Set<Id> parentIds,
			Set<Id> userOrGroupIds,
			String accessLevel)
	{
		String parentIdFieldName = getParentIdFieldName(sObjectType);
		String accessLevelFieldName = getAccessLevelFieldName(sObjectType);
		SObjectType sObjectTypeShare = getSObjectTypeShare(sObjectType);

		List<SObject> results = new List<SObject>();
		for (Id parentId : parentIds)
		{
			for (Id userOrGroupId : userOrGroupIds)
			{
				SObject result = sObjectTypeShare.newSObject();
				result.put(parentIdFieldName, parentId);
				result.put( 'UserOrGroupId', userOrGroupId );
				result.put(accessLevelFieldName, accessLevel);
				result.put( 'RowCause', 'Manual' );
				results.add(result);
			}
		}
		return results;
	}


	/**
	 * Gets the name of the AccessLevel field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its AccessLevel field
	 *
	 * @return Returns the AccessLevel name e.g. "AccessLevel" or "AccountAccessLevel
	 */
	public static String getAccessLevelFieldName(SObjectType sObjectType)
	{
		String sObjectName = sObjectType.getDescribe().getName();
		return (isCustom(sObjectName) ? '' : sObjectName.substringBefore('Share')) + 'AccessLevel';
	}

	/**
	 * Gets the SObjectField for the AccessLevel field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its AccessLevel field
	 *
	 * @return Returns the xxxAccessLevel.SObjectField
	 */
	public static SObjectField getAccessLevelField(SObjectType sObjectType)
	{
		return getsObjectField(
				fflib_SObjectDescribe.getDescribe(sObjectType).getFields(),
				getAccessLevelFieldName(sObjectType));
	}

	/**
	 * Gets the name of the ParentId field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its parent Id field
	 *
	 * @return Returns the parent field name e.g. "ParentId" or "AccountId"
	 */
	public static String getParentIdFieldName(SObjectType sObjectType)
	{
		String sObjectName = sObjectType.getDescribe().getName();
		return (isCustom(sObjectName) ? 'Parent' : sObjectName.substringBefore('Share')) + 'Id';
	}

	/**
	 * Gets the SObjectField for the ParentId field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its parent Id field
	 *
	 * @return Returns the xxxId.SObjectField e.g. ParentId.SObjectField or AccountId.SObjectField
	 */
	public static SObjectField getParentIdField(SObjectType sObjectType)
	{
		return getsObjectField(
				fflib_SObjectDescribe.getDescribe(sObjectType).getFields(),
				getParentIdFieldName(sObjectType));
	}

	/**
	 * Gets the SObjectField for the RowCause field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its RowCause field
	 *
	 * @return Returns the RowCause.SObjectField
	 */
	public static SObjectField getRowCauseField(SObjectType sObjectType)
	{
		return getsObjectField(
				fflib_SObjectDescribe.getDescribe(sObjectType).getFields(),
				'RowCause');
	}

	/**
	 * Gets the SObjectField for the UserOrGroupId field of the given SObjectType
	 *
	 * @param sObjectType The SObjectType to get its UserOrGroupId field
	 *
	 * @return Returns the UserOrGroupId.SObjectField
	 */
	public static SObjectField getUserOrGroupIdField(SObjectType sObjectType)
	{
		return getsObjectField(
				fflib_SObjectDescribe.getDescribe(sObjectType).getFields(),
				'UserOrGroupId');
	}

	private static SObjectField getsObjectField(fflib_SObjectDescribe.FieldsMap fields, String fieldName)
	{
		return fields.get(fieldName).getDescribe().getSobjectField();
	}

	private static SObjectType getSObjectTypeShare(SObjectType sObjectType)
	{
		String sObjectName = sObjectType.getDescribe().getName();

		if (sObjectName.endsWith('Share')) return sObjectType; // is already a Share SObjectType

		// Try to construct the Share SObject from
		if (sObjectName.endsWith('__c'))
			return
					fflib_SObjectDescribe.getDescribe(sObjectName.replace('__c', '__Share'))
					.getDescribe().getSObjectType();

		return fflib_SObjectDescribe.getDescribe(sObjectName + 'Share')
				.getDescribe().getSObjectType();
	}

	private static Boolean isCustom(String sObjectName)
	{
		return sObjectName.endsWith('__Share') || sObjectName.endsWith('__c');
	}
}