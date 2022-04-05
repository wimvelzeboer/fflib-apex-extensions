/**
 * File Name: fflib_IServiceFactory2
 * @description Interface for creating instances of Service classes
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
public interface fflib_IServiceFactory2 extends fflib_IServiceFactory
{
	/**
	 * Returns a new instance of the Apex class associated with the given Apex interface
	 *   Will return any mock implementation of the interface provided via setMock
	 *   Note that this method will not check the configured Apex class actually implements the interface
	 *
	 * @param serviceInterfaceType Apex interface type
	 * @exception Is thrown if there is no registered Apex class for the interface type
	 *
	 * @return Instance of the requested service class interface type
	 **/
	Object newInstance(Type serviceInterfaceType);

	/**
	 * Creates or replaces an existing binding for another
	 *
	 * @param serviceInterfaceType The Interface type to replace its implementation
	 * @param replacementImplType The implementation type of the replacement
	 */
	void replaceWith(Type serviceInterfaceType, Type replacementImplType);

	/**
	 * @param serviceInterfaceType The interface type to mock
	 * @param serviceImpl The mock implementation
	 */
	void setMock(Type serviceInterfaceType, Object serviceImpl);
}