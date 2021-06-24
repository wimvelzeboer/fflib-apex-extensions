/**
 * File Name: Objects
 * Description: Primitive domain for the object type Object
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
public virtual with sharing class Objects
		extends fflib_Objects
		implements fflib_IObjects
{
	// The objects contained in the domain
	protected List<Object> objects { get; private set; }

	// The object type of the objects contained in the domain
	private Object objectType;

	/**
	 * Class constructor
	 *
	 * @param obj The object to contain inside the domain
	 */
	public Objects(Object obj)
	{
		this(new List<Object>{ obj });
	}

	/**
	 * Class constructor
	 *
	 * @param objects The objects to contain inside the domain
	 */
	public Objects(Set<Object> objects)
	{
		this(new List<Object>(objects));
	}

	/**
	 * Class constructor
	 *
	 * @param objects The objects to contain inside the domain
	 */
	public Objects(List<Object> objects)
	{
		this(objects, Object.class);
	}

	/**
	 * Class constructor
	 *
	 * @param objects The objects to contain inside the domain
	 * @param objectType The object type of the given objects
	 */
	public Objects(List<Object> objects, Object objectType)
	{
		super(objects);
		this.objectType = this.objectType;
	}

	/**
	 * @return Returns a unique set of objects which are contained in the domain
	 */
	public Set<Object> getObjectsSet()
	{
		return new Set<Object>(getObjects());
	}
}