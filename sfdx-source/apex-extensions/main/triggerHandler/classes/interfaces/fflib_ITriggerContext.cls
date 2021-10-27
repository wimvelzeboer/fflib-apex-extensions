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
}