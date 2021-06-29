/**
 * File Name: fflib_AppBinding 
 * Description: Definition for an Application Binding
 *
 * @author : architect ir. Wilhelmus G.J. Velzeboer
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
public virtual class fflib_AppBinding
		implements fflib_IAppBinding, Comparable
{
	protected Object bindingObject { get; set; }
	protected Decimal bindingSequence { get; set; }
	protected fflib_AppBindingType bindingType { get; set; }
	protected System.Type implementationType { get; set; }
	protected System.Type interfaceType { get; set; }
	protected String namespacePrefix { get; set; }
	protected fflib_SharingMode sharingMode { get; set; }

	public Integer compareTo(Object compareTo)
	{
		fflib_IAppBinding compareToEmp = (fflib_IAppBinding) compareTo;
		if (getSequence() == compareToEmp.getSequence()) return 0;
		if (getSequence() > compareToEmp.getSequence()) return 1;
		return -1;
	}

	public Object getBindingObject()
	{
		return this.bindingObject;
	}

	public virtual fflib_AppBindingType getBindingType()
	{
		return this.bindingType;
	}

	public virtual System.Type getImplementationType()
	{
		return this.implementationType;
	}

	public Type getInterfaceType()
	{
		return this.interfaceType;
	}

	public String getNamespacePrefix()
	{
		return this.namespacePrefix;
	}

	public Decimal getSequence()
	{
		return this.bindingSequence;
	}

	public fflib_SharingMode getSharingMode()
	{
		return this.sharingMode;
	}

	public virtual Object newImplInstance()
	{
		return implementationType.newInstance();
	}

	public virtual fflib_IAppBinding setBindingObject(Object bindingObject)
	{
		this.bindingObject = bindingObject;
		return this;
	}

	public virtual fflib_IAppBinding setBindingType(fflib_AppBindingType bindingType)
	{
		this.bindingType = bindingType;
		return this;
	}

	public virtual fflib_IAppBinding setNamespacePrefix(String namespacePrefix)
	{
		this.namespacePrefix = namespacePrefix;
		return this;
	}

	public virtual fflib_IAppBinding setImplementationType(System.Type implementationType)
	{
		this.implementationType = implementationType;
		return this;
	}

	public virtual fflib_IAppBinding setInterfaceType(Type interfaceType)
	{
		this.interfaceType = interfaceType;
		return this;
	}

	public virtual fflib_IAppBinding setSequence(Decimal sequence)
	{
		this.bindingSequence = sequence;
		return this;
	}

	public virtual fflib_IAppBinding setSharingMode(fflib_SharingMode sharingMode)
	{
		this.sharingMode = sharingMode;
		return this;
	}
}