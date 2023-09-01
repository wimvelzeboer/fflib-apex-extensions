/**
 * File Name: fflib_DynamicDomainFactory
 * @description Domain Factory for creating instances of Domain classes
 *              using a resolver to dynamically link an Object type to its Domain Constructor implementation class
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
public virtual class fflib_DynamicDomainFactory
		extends fflib_DynamicAppFactory
		implements fflib_IDomainFactory
{
	protected fflib_ISelectorFactory selectorFactory;
	protected fflib_ClassicDomainFactory domainFactory;

	/**
	 * Class constructor
	 *
	 * @param resolver A reference to the resolve instance
	 * @param selectorFactory A reference to the selector factory instance
	 */
	public fflib_DynamicDomainFactory(fflib_IAppBindingResolver resolver, fflib_ISelectorFactory selectorFactory)
	{
		this(resolver, selectorFactory, null);
	}

	/**
	 * Class constructor
	 *
	 * @param resolver A reference to the resolve instance
	 * @param selectorFactory A reference to the selector factory instance
	 * @param packageName The package name
	 */
	public fflib_DynamicDomainFactory(
			fflib_IAppBindingResolver resolver,
			fflib_ISelectorFactory selectorFactory,
			String packageName)
	{
		this.resolver = resolver;
		this.selectorFactory = selectorFactory;
		this.packageName = packageName;
	}

	public fflib_IDomain newInstance(Set<Id> recordIds)
	{
		return newInstance(this.selectorFactory.selectById(recordIds));
	}

	public fflib_IDomain newInstance(Set<Id> recordIds, SObjectType sObjectType)
	{
		return newInstance(this.selectorFactory.selectById(recordIds));
	}

	public fflib_IDomain newInstance(List<SObject> records)
	{
		if (domainFactory == null) loadBindings();

		return this.domainFactory.newInstance(records);
	}

	public fflib_IDomain newInstance(List<Object> objects, Object objectType)
	{
		if (domainFactory == null) loadBindings();

		return this.domainFactory.newInstance(objects, objectType);
	}

	public fflib_IDomain newInstance(List<SObject> records, SObjectType domainSObjectType)
	{
		return newInstance((List<Object>) records, (Object) domainSObjectType);
	}

	public void setMock(fflib_ISObjectDomain mockDomain)
	{
		if (domainFactory == null) loadBindings();

		this.domainFactory.setMock(mockDomain);
	}

	public void setMock(Schema.SObjectType sObjectType, fflib_ISObjectDomain mockDomain)
	{
		if (domainFactory == null) loadBindings();

		this.domainFactory.setMock(sObjectType, mockDomain);
	}

	public void setMock(fflib_IDomain mockDomain)
	{
		if (domainFactory == null) loadBindings();

		this.domainFactory.setMock(mockDomain);
	}

	public void setMock(Object domainType, fflib_IDomain mockDomain)
	{
		if (domainFactory == null) loadBindings();

		this.domainFactory.setMock(domainType, mockDomain);
	}

	private void loadBindings()
	{
		fflib_IAppBindings appBindings = new fflib_AppBindings(resolver.resolve());

		// If a package name is provide we should filter on package name
		if (String.isNotBlank(this.packageName))
		{
			appBindings = appBindings.selectByPackageName(this.packageName);
		}

		Map<Object, Type> constructorByObject =
				appBindings.selectByType(fflib_AppBindingType.Domain)
						.getImplementationByBindingObject();

		this.domainFactory = new fflib_ClassicDomainFactory(this.selectorFactory, constructorByObject);
	}

	public class DeveloperException extends Exception {}
}