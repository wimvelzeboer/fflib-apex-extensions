/**
 * File Name: fflib_ALogAppenderFilter
 * Description: Log Appender that includes a filter for logginglevel
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
public interface fflib_ITriggerAction extends fflib_IDoWork
{
	/**
	 * Perform logic during the after delete phase
	 **/
	void onAfterDelete();

	/**
	 * Perform logic during the after Insert phase
	 **/
	void onAfterInsert();

	/**
	 * Perform logic during the after Undelete phase
	 **/
	void onAfterUnDelete();

	/**
	 * Perform logic during the after update phase
	 **/
	void onAfterUpdate();

	/**
	 * Perform logic during the before delete phase
	 **/
	void onBeforeDelete();

	/**
	 * Perform logic during the before insert phase
	 **/
	void onBeforeInsert();

	/**
	 * Perform logic during the before update phase
	 **/
	void onBeforeUpdate();

	/**
	 * Method used by the TriggerHandler and us to pass in the trigger context
	 *
	 * @param ctx Instance of fflib_ITriggerContext
	 *
	 * @return Instance of itself to allow for method chaining
	 */
	fflib_ITriggerAction setContext(fflib_ITriggerContext ctx);
}