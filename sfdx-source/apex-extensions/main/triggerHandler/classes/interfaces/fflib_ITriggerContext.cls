/**
 * File Name: fflib_ITriggerContext
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
public interface fflib_ITriggerContext
{
	/**
	 * Framework method to tell the Trigger Context that the previous queried related records of interest should be cleared
	 * Note: Should only be used by the framework
	 */
	void clearRelated();

	/**
	 * Triggers the execution of the UnitOfWork,
	 * holding all the registered work by the trigger actions
	 */
	void commitWork();

	/**
	 * Framework method to tell the Trigger Context that the related records of interest can be queried
	 * Note: Should only be used by the framework
	 */
	void fetchRelated();

	/**
     * Detects whether any values in context records have changed for given field as string
     * Returns list of SObject records that have changes in the specified fields
     **/
	List<SObject> getChangedRecords(String fieldName);

	/**
     * Detects whether any values in context records have changed for given fields as strings
     * Returns list of SObject records that have changes in the specified fields
     **/
	List<SObject> getChangedRecords(Set<String> fieldNames);

	/**
	 * Detects whether any values in context records have changed for given field as token
	 * Returns list of SObject records that have changes in the specified fields
	 **/
	 List<SObject> getChangedRecords(Schema.SObjectField fieldToken);

	/**
     * Detects whether any values in context records have changed for given fields as tokens
	 * Returns list of SObject records that have changes in the specified fields
	 **/
	List<SObject> getChangedRecords(Set<Schema.SObjectField> fieldTokens);

	/**
	 * Provides access to Trigger.oldMap or the mock when configured in a unit-test
	 **/
	Map<Id, SObject> getExistingRecords();

	/**
	 * @return Returns the System.TriggerOperation enum value
	 */
	System.TriggerOperation getTriggerOperation();

	/**
     * Provides access to the data represented by this Trigger Context
     **/
	List<SObject> getRecords();

	/**
	 * Get the records for the given SObjectType,
	 * which are queried based on the defined interests of all trigger actions
	 *
	 * @param sObjectType The SObjectType of the records to return
	 *
	 * @return Return a list of SObjects
	 */
	List<SObject> getRelated(SObjectType sObjectType);

	/**
	 * Method used by the framework to create a new instance of the unit of work,
	 * with the registered SObjectTypes by the trigger actions
	 */
	void initializeUnitOfWork();

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
	fflib_ITriggerContext interestedIn(SObjectField idField, Set<SObjectField> fields);

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
	fflib_ITriggerContext interestedIn(String relationshipName, Set<SObjectField> fields);

	/**
	 * Declares its interest into an unrelated record
	 *
	 * @param sSObjectType The SObjectType to query
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
	fflib_ITriggerContext interestedIn(
			Schema.SObjectType sSObjectType,
			Schema.SObjectField idField,
			Set<Id> values,
			Set<SObjectField> fields);
	/**
	 * @return Returns TRUE if the Trigger Context is an INSERT operation
	 */
	Boolean isInsert();

	/**
	 * @return Returns TRUE if the Trigger Context is an UPDATE operation
	 */
	Boolean isUpdate();

	/**
	 * @return Returns TRUE if the Trigger Context is an DELETE operation
	 */
	Boolean isDelete();

	/**
	 * @return Returns TRUE if the Trigger Context is an UNDELETE operation
	 */
	Boolean isUndelete();

	/**
	 * @return Returns TRUE if the Trigger Context is an BEFORE operation
	 */
	Boolean isBefore();

	/**
	 * @return Returns TRUE if the Trigger Context is an AFTER operation
	 */
	Boolean isAfter();

	/**
	 * Registers an SObjectType with the unit of work
	 *
	 * @param sObjectType The SObjectType to register
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	fflib_TriggerContext registerSObjectType(SObjectType sObjectType);

	/**
	 * Registers an SObjectType with the unit of work
	 *
	 * @param childSObjectType The SObjectType to register
	 * @param parentSObjectTypes A set of SObjectType that should be handled by the unit of work before the given childSObjectType
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	fflib_TriggerContext registerSObjectType(SObjectType childSObjectType, Set<SObjectType> parentSObjectTypes);
}