/**
 * File Name: fflib_MultiSObjectsSelector
 *
 * Selector class which is able to execute multiple dynamic queries
 * constructed from multiple registered queries.
 * Overlapping queries for the same SObjectType will be merged
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
public without sharing class fflib_MultiSObjectsSelector
{
	/**
     * The current implementation type of the service
     */
	private static System.Type implementationType = fflib_MultiSObjectsSelector.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static fflib_MultiSObjectsSelector implementationReplacement;

	protected Map<SObjectType, Map<SObjectField, QueryInfo>> queries =
			new Map<SObjectType, Map<SObjectField, QueryInfo>>();

	private System.AccessLevel accessLevel;

	/**
	* Runs the query in User Mode
	*
	* @return New instance of the selector
	*/
	public static fflib_MultiSObjectsSelector newInstance() {
		fflib_MultiSObjectsSelector selector =
				(implementationReplacement == null) ? (fflib_MultiSObjectsSelector) implementationType.newInstance() : implementationReplacement;
		selector.accessLevel = System.AccessLevel.USER_MODE;
		return selector;
	}

	/**
	* Runs the query in System Mode, disabling FLS, CRUD & sharing rules
	*
	* @return New instance of the selector
	*/
	public static fflib_MultiSObjectsSelector newElevatedInstance() {
		fflib_MultiSObjectsSelector selector =
				(implementationReplacement == null) ? (fflib_MultiSObjectsSelector) implementationType.newInstance() : implementationReplacement;
		selector.accessLevel = System.AccessLevel.SYSTEM_MODE;
		return selector;
	}

	public fflib_MultiSObjectsSelector clear() {
		this.queries.clear();
		return this;
	}

	public fflib_MultiSObjectsSelector registerQuery(
			SObjectType sObjectType,
			Set<SObjectField> fieldsToFetch,
			SObjectField idField,
			Set<Id> idFieldValues
	)
	{
		if (this.queries.containsKey(sObjectType) == false) {
			this.queries.put(sObjectType, new Map<SObjectField, QueryInfo>());
		}

		if (this.queries.get(sObjectType).containsKey(idField))
		{
			this.queries.get(sObjectType)
					.get(idField)
					.addFields(fieldsToFetch)
					.addValues(idFieldValues);
		} else {
			this.queries.get(sObjectType)
				.put(idField, new QueryInfo(sObjectType, fieldsToFetch, idField, idFieldValues));
		}

		return this;
	}


	public Map<SObjectType, List<SObject>> query() {
		Map<SObjectType, List<SObject>> result = new Map<SObjectType, List<SObject>>();

		for (SObjectType sObjectType : this.queries.keySet())
		{
			Set<String> fields = new Set<String>();
			String condition = '';

			for (SObjectField idField : this.queries.get(sObjectType).keySet())
			{
				QueryInfo queryInfo = this.queries.get(sObjectType).get(idField);
				fields.addAll(queryInfo.fieldsToFetch);
				condition +=
						(String.isBlank(condition) ? '' : ' OR ') +
						idField.getDescribe().getName()
								+ ' IN (' + '\'' + String.join(queryInfo.idFieldValues, '\',\'') + '\')';
			}

			String query = 'SELECT Id,' + String.join(fields,',')
					+ ' FROM ' + sObjectType.getDescribe().getName()
					+ ' WHERE ' + condition
					+ ' WITH ' + (this.accessLevel == System.AccessLevel.SYSTEM_MODE ? 'SYSTEM_MODE' : 'USER_MODE')
			;

			List<SObject> sObjects = Database.query(query);
			result.put(sObjectType, sObjects);
		}
		return result;
	}


	/**
	 * Replace the default implementation of the selector
	 *
	 * @param systemType The System.Type of the replacement class
	 */
	public static void replaceWith(System.Type systemType) {
		fflib_MultiSObjectsSelector.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the selector
	 *
	 * @param replacement A replacement instance
	 *
	 * @see fflib_MultiSObjectsSelector
	 */
	public static void replaceWith(fflib_MultiSObjectsSelector replacement) {
		fflib_MultiSObjectsSelector.implementationReplacement = replacement;
	}


	private class QueryInfo {

//		private final SObjectType sObjectType;
		private final Set<String> fieldsToFetch;
//		private final SObjectField idField;
		private final Set<Id> idFieldValues;

		public QueryInfo(SObjectType sObjectType,
				Set<SObjectField> fieldsToFetch,
				SObjectField idField,
				Set<Id> idFieldValues) {
			this.fieldsToFetch = new Set<String>();
			for (SObjectField sObjectField : fieldsToFetch)
			{
				this.fieldsToFetch.add(sObjectField.getDescribe().getName());
			}
//			this.idField = idField;
			this.idFieldValues = idFieldValues;
//			this.sObjectType = sObjectType;
		}

		public QueryInfo addFields(Set<SObjectField> fieldsToFetch) {
			for (SObjectField sObjectField : fieldsToFetch)
			{
				this.fieldsToFetch.add(sObjectField.getDescribe().getName());
			}
			return this;
		}

		public QueryInfo addValues(Set<Id> idFieldValues) {
			this.idFieldValues.addAll(idFieldValues);
			return this;
		}
	}
}