/**
 * File Name: fflib_SObjectsSelector
 *
 * Generic SObject selector class
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
public with sharing class fflib_SObjectsSelector
        extends fflib_SObjectSelector {
    /**
     * The current implementation type of the service
     */
    private static System.Type implementationType = fflib_SObjectsSelector.class;

    /**
     * The implementation replacement for the service,
     */
    private static fflib_SObjectsSelector implementationReplacement;

    /**
     * The list of field that should be retrieved with each query
     */
    private List<Schema.SObjectField> sObjectFields { get; set; }

    /**
     * Holds the SObjectType of the records to query
     */
    private Schema.SObjectType sObjectType { get; set; }

    /**
     * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
     *
     * @param sObjectType The SObjectType of the records to query
     * @param sObjectFields a set of SObjectFields to get each time a Quote records is queried
     *
     * @return New instance of the selector
     */
    public static fflib_SObjectsSelector newElevatedInstance(SObjectType sObjectType, Set<SObjectField> sObjectFields) {
        fflib_SObjectsSelector selector =
                (implementationReplacement == null) ? (fflib_SObjectsSelector) implementationType.newInstance() : implementationReplacement;
        selector.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
        selector.setSObjectFields(sObjectFields);
        selector.setSObjectType(sObjectType);
        return selector;
    }

    /**
     * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
     *
     * @param sObjectType The SObjectType of the records to query
     * @param sObjectFields a set of SObjectFields to get each time a Quote records is queried
     *
     * @return New instance of the selector
     */
    public static fflib_SObjectsSelector newElevatedInstance(SObjectType sObjectType, Set<String> sObjectFields) {
        fflib_SObjectsSelector selector =
                (implementationReplacement == null) ? (fflib_SObjectsSelector) implementationType.newInstance() : implementationReplacement;
        selector.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
        selector.setSObjectFields(sObjectType, sObjectFields);
        selector.setSObjectType(sObjectType);
        return selector;
    }

    /**
     * Class constructor
     * This should not be used directly by an application but only by fflib
     */
    public fflib_SObjectsSelector() {
        super();
    }

    /**
     * The fields to always include in all queries
     *
     * @return Returns a list of default fields that are always queried
     */
    public virtual List<Schema.SObjectField> getSObjectFieldList() {
        return this.sObjectFields;
    }

    /**
     * Defines the SObjectType for this selector
     *
     * @return the SObjectType of this selector
     */
    public Schema.SObjectType getSObjectType() {
        return this.sObjectType;
    }

    /**
     * Replace the default implementation of the service
     *
     * @param systemType The System.Type of the replacement class
     */
    public static void replaceWith(System.Type systemType) {
        fflib_SObjectsSelector.implementationType = systemType;
    }

    /**
     * Replace the default implementation of the service
     *
     * @param replacement A replacement instance
     *
     * @see fflib_SObjectsSelector
     */
    public static void replaceWith(fflib_SObjectsSelector replacement) {
        fflib_SObjectsSelector.implementationReplacement = replacement;
    }

    /**
     * Queries records by their record Id
     *
     * @param idSet A set of record Id values
     *
     * @return A list of SObject records
     */
    public virtual List<SObject> selectById(Set<Id> idSet) {
        return Database.query(
                newQueryFactory()
                        .setCondition('Id IN :idSet')
                        .toSOQL()
        );
    }

    /**
     * Queries SObject records by their record Id
     *
     * @param sObjectField The Id field to query
     * @param ids A set of record Id values
     *
     * @return A list of SObject records
     */
    public List<SObject> selectByIdField(SObjectField sObjectField, Set<Id> ids) {
        return Database.query(
                newQueryFactory()
                        .setCondition(sObjectField.getDescribe().getName() + ' IN :ids')
                        .toSOQL()
        );
    }

    /**
     * Sets the list of fields that are fetched on each query
     *
     * @param sObjectFields A set of SObjectFields from the SObjectType
     *
     * @return Returns an instance of itself to allow for method chaining
     */
    public fflib_SObjectsSelector setSObjectFields(Set<SObjectField> sObjectFields) {
        this.sObjectFields = new List<SObjectField>(sObjectFields);
        return this;
    }

    /**
     * Sets the list of fields that are fetched on each query
     *
     * @param sObjectType The SObjectType of the provided fields
     * @param fieldNames A set of SObject field names
     *
     * @return Returns an instance of itself to allow for method chaining
     */
    public fflib_SObjectsSelector setSObjectFields(SObjectType sObjectType, Set<String> fieldNames) {
        Map<String, SObjectField> sObjectFieldsByName = sObjectType.getDescribe().fields.getMap();

        Set<SObjectField> sObjectFields = new Set<SObjectField>();
        for (String fieldName : fieldNames) {
            if (sObjectFieldsByName.containsKey(fieldName) == false) continue;

            sObjectFields.add(sObjectFieldsByName.get(fieldName));
        }
        setSObjectFields(sObjectFields);
        return this;
    }

    /**
     * Sets the SObjectType of the records to query
     *
     * @param sObjectType The SObjectType of the records to query
     *
     * @return Returns an instance of itself to allow for method chaining
     */
    public fflib_SObjectsSelector setSObjectType(SObjectType sObjectType) {
        this.sObjectType = sObjectType;
        return this;
    }
}