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
		Set<Id> safeValues = stripNulls(idFieldValues);
		if (safeValues.isEmpty()) return this;

		if (this.queries.containsKey(sObjectType) == false) {
			this.queries.put(sObjectType, new Map<SObjectField, QueryInfo>());
		}

		if (this.queries.get(sObjectType).containsKey(idField))
		{
			this.queries.get(sObjectType)
					.get(idField)
					.addFields(fieldsToFetch)
					.addValues(safeValues);
		} else {
			this.queries.get(sObjectType)
				.put(idField, new QueryInfo(sObjectType, fieldsToFetch, idField, safeValues));
		}

		return this;
	}

	public fflib_MultiSObjectsSelector registerQuery(
			SObjectType sObjectType,
			Set<SObjectField> fieldsToFetch,
			Set<String> relationshipFieldPaths,
			SObjectField idField,
			Set<Id> idFieldValues
	)
	{
		registerQuery(sObjectType, fieldsToFetch, idField, idFieldValues);
		if (relationshipFieldPaths != null && !relationshipFieldPaths.isEmpty())
		{
			Set<String> safePaths = validateFieldPaths(relationshipFieldPaths);
			if (!this.queries.containsKey(sObjectType)) return this;
			if (!this.queries.get(sObjectType).containsKey(idField)) return this;
			this.queries.get(sObjectType).get(idField).addFieldPaths(safePaths);
		}
		return this;
	}

	/**
	 * Convenience method that queries all registered SObjectTypes.
	 * The lazy fetch pattern (used by fflib_TriggerContext) calls queryForType() directly
	 * to avoid querying SObjectTypes that no trigger action actually consumes.
	 */
	public Map<SObjectType, List<SObject>> query() {
		Map<SObjectType, List<SObject>> result = new Map<SObjectType, List<SObject>>();
		for (SObjectType sObjectType : this.queries.keySet())
		{
			List<SObject> records = queryForType(sObjectType);
			if (records != null)
			{
				result.put(sObjectType, records);
			}
		}
		return result;
	}

	public List<SObject> queryForType(SObjectType sObjectType) {
		if (!this.queries.containsKey(sObjectType)) return null;

		fflib_QueryFactory qf = new fflib_QueryFactory(sObjectType);
		qf.setEnforceFLS(this.accessLevel == System.AccessLevel.USER_MODE);

		List<String> conditions = new List<String>();

		for (SObjectField idField : this.queries.get(sObjectType).keySet())
		{
			QueryInfo queryInfo = this.queries.get(sObjectType).get(idField);
			if (queryInfo.idFieldValues.isEmpty()) continue;

			// Add fields to QueryFactory (Id is included automatically)
			for (String fieldPath : queryInfo.fieldsToFetch)
			{
				qf.selectField(fieldPath);
			}

			List<String> escapedIds = new List<String>();
			for (Id idVal : queryInfo.idFieldValues)
			{
				escapedIds.add(String.escapeSingleQuotes(String.valueOf(idVal)));
			}
			conditions.add(
				idField.getDescribe().getName()
					+ ' IN (\'' + String.join(escapedIds, '\',\'') + '\')'
			);
		}

		if (conditions.isEmpty()) return null;

		qf.setCondition(String.join(conditions, ' OR '));
		return Database.query(qf.toSOQL());
	}

	public Boolean hasQueriesFor(SObjectType sObjectType) {
		return this.queries.containsKey(sObjectType);
	}

	private static Set<Id> stripNulls(Set<Id> ids)
	{
		Set<Id> result = new Set<Id>();
		if (ids == null) return result;
		for (Id idVal : ids)
		{
			if (idVal != null) result.add(idVal);
		}
		return result;
	}

	private static final Pattern FIELD_PATH_PATTERN = Pattern.compile('^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)*$');

	private static Set<String> validateFieldPaths(Set<String> paths)
	{
		Set<String> safe = new Set<String>();
		for (String path : paths)
		{
			if (String.isBlank(path)) continue;
			if (!FIELD_PATH_PATTERN.matcher(path.trim()).matches())
			{
				throw new SelectorException('Invalid field path: ' + path);
			}
			safe.add(path.trim());
		}
		return safe;
	}

	public class SelectorException extends Exception {}


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

		private final Set<String> fieldsToFetch;
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
			this.idFieldValues = idFieldValues;
		}

		public QueryInfo addFields(Set<SObjectField> fieldsToFetch) {
			for (SObjectField sObjectField : fieldsToFetch)
			{
				this.fieldsToFetch.add(sObjectField.getDescribe().getName());
			}
			return this;
		}

		public QueryInfo addFieldPaths(Set<String> fieldPaths) {
			this.fieldsToFetch.addAll(fieldPaths);
			return this;
		}

		public QueryInfo addValues(Set<Id> idFieldValues) {
			this.idFieldValues.addAll(idFieldValues);
			return this;
		}
	}
}