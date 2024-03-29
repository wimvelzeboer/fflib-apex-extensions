/**
 * File Name: fflib_ITriggerActionConfig
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
public interface fflib_ITriggerActionConfig
{
	/**
	 * @return Returns the Implementation Type of the Trigger Action
	 */
	System.Type getImplementationType();

	/**
	 * @return Returns the sequence number of the trigger action
	 */
	Integer getSequence();

	/**
	 * @return Returns the SObjectType linked to the trigger action
	 */
	Schema.SObjectType getSObjectType();

	/**
	 * @param triggerOperation The Trigger operation to validate the configuration against.
	 *
	 * @return Returns TRUE is the given operation type matches the one of the configuration
	 */
	Boolean hasTriggerContext(TriggerOperation triggerOperation);

	/**
	 * @return Returns TRUE if the trigger action should be executed in a dedicated Queueable context
	 */
	Boolean isDedicatedQueued();

	/**
	 * @return Returns TRUE if the trigger action needs to be kept in memory and reused by the next TriggerHandler run
	 */
	Boolean isStateful();

	/**
	 * @return Returns TRUE if the trigger action can be executed in an Queueable context
	 */
	Boolean isQueued();

	/**
	 * Creates a new instance of the trigger action class based on the provided implementation type in the configuration
	 *
	 * @return Instance of the Trigger Action class
	 */
	fflib_ITriggerAction newInstance();


}