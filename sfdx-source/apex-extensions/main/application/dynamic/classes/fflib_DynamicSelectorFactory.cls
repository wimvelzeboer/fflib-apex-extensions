/**
 * File Name: fflib_DynamicSelectorFactory
 * @description
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
public virtual class fflib_DynamicSelectorFactory
		extends fflib_DynamicAppFactory
		implements fflib_ISelectorFactory
{
	protected fflib_ClassicSelectorFactory selectorFactory;

	public fflib_DynamicSelectorFactory(fflib_IAppBindingResolver resolver)
	{
		this(resolver, null);
	}

	public fflib_DynamicSelectorFactory(fflib_IAppBindingResolver resolver, String packageName)
	{
		this.resolver = resolver;
		this.packageName = packageName;
	}

	public fflib_ISObjectSelector newInstance(SObjectType sObjectType)
	{
		if (this.selectorFactory == null) loadBindings();

		return this.selectorFactory.newInstance(sObjectType);
	}

	public List<SObject> selectById(Set<Id> recordIds)
	{
		if (this.selectorFactory == null) loadBindings();

		return this.selectorFactory.selectById(recordIds);
	}

	public List<SObject> selectById(Set<Id> recordIds, SObjectType sObjectType)
	{
		if (this.selectorFactory == null) loadBindings();

		return this.selectorFactory.selectById(recordIds, sObjectType);
	}

	public List<SObject> selectByRelationship(List<SObject> relatedRecords, SObjectField relationshipField)
	{
		if (this.selectorFactory == null) loadBindings();

		return this.selectorFactory.selectByRelationship(relatedRecords, relationshipField);
	}

	public void replaceWith(SObjectType sObjectType, Type replacementImplType)
	{
		if (this.selectorFactory == null) loadBindings();

		this.selectorFactory.replaceWith(sObjectType, replacementImplType);
	}

	public void setMock(fflib_ISObjectSelector selectorInstance)
	{
		if (this.selectorFactory == null) loadBindings();

		this.selectorFactory.setMock(selectorInstance);
	}

	public void setMock(SObjectType sObjectType, fflib_ISObjectSelector selectorInstance)
	{
		if (this.selectorFactory == null) loadBindings();

		this.selectorFactory.setMock(sObjectType, selectorInstance);
	}

	private void loadBindings()
	{
		fflib_IAppBindings appBindings = new fflib_AppBindings(resolver.resolve());

		// If a package name is provide we should filter on package name
		if (String.isNotBlank(this.packageName))
		{
			appBindings = appBindings.selectByPackageName(this.packageName);
		}

		Map<SObjectType, Type> implementationBySObjectType =
				appBindings.selectByType(fflib_AppBindingType.Selector)
						.getImplementationBySObjectType();

		this.selectorFactory = new fflib_ClassicSelectorFactory(implementationBySObjectType);
	}

	public class DeveloperException extends Exception {}
}