/**
 * File Name: fflib_Ids
 * @description Primitive domain for the object type Id
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
public virtual with sharing class fflib_Ids
		extends fflib_Objects2
{
	public fflib_Ids(Set<Id> idSet)
	{
		super(new List<Id>(idSet));
	}

	public fflib_Ids(List<Id> ids)
	{
		super((List<Object>) ids);
	}

	public fflib_Ids(List<Object> elements)
	{
		super(elements);
	}

	public fflib_Ids(fflib_Objects objects)
	{
		super(getIdList(objects));
	}

	public Set<Id> getIds()
	{
		return new Set<Id>(getIdList());
	}

	public List<Id> getIdList()
	{
		return (List<Id>) getObjects();
	}

	public String join(String separator)
	{
		String result = '';
		for (Id recordId : getIds())
		{
			result += String.valueOf(recordId) + separator;
		}
		if (result == '') return '';
		else return result.removeEnd(separator);
	}

	private static List<Id> getIdList(fflib_Objects objects)
	{
		List<Id> result = new List<Id>();
		for (Object obj : objects.getObjects())
		{
			if (!(obj instanceof Id)) continue;

			result.add((Id) obj);
		}
		return result;
	}

	public fflib_Ids selectByIds(Set<Id> idSet)
	{
		List<Id> result = new List<Id>();
		for (Id recordId : getIdList())
		{
			if (idSet.contains(recordId) == false) continue;

			result.add(recordId);
		}
		return new fflib_Ids(result);
	}

	public fflib_Ids selectByIdsNotIn(Set<Id> idSet)
	{
		List<Id> result = new List<Id>();
		for (Id recordId : getIdList())
		{
			if (idSet.contains(recordId)) continue;

			result.add(recordId);
		}
		return new fflib_Ids(result);
	}

}