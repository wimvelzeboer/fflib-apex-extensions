/**
 * File Name: fflib_TriggerAction
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
public abstract inherited sharing class fflib_TriggerAction
		extends fflib_DoWork
		implements fflib_ITriggerAction
{
	protected fflib_ITriggerContext triggerContext;

	/**
	 * Override this to perform logic during the after delete phase, this is called by the handleAfterDelete method
	 **/
	public virtual void onAfterDelete() { }

	/**
	 * Override this to perform logic during the after insert phase, this is called by the handleAfterInsert method
	 **/
	public virtual void onAfterInsert() { }

	/**
	 * Override this to perform logic during the after undelete phase, this is called by the handleAfterDelete method
	 **/
	public virtual void onAfterUnDelete() { }

	/**
	 * Override this to perform logic during the after update phase, this is called by the handleAfterUpdate method
	 **/
	public virtual void onAfterUpdate() { }

	/**
	 * Override this to perform logic during the before delete phase, this is called by the handleBeforeDelete method
	 **/
	public virtual void onBeforeDelete() { }

	/**
	 * Override this to perform logic during the before insert phase, this is called by the handleBeforeInsert method
	 **/
	public virtual void onBeforeInsert() { }

	/**
	 * Override this to perform logic during the before update phase, this is called by the handleBeforeUpdate method
	 **/
	public virtual void onBeforeUpdate() { }

	public void doWork()
	{
		switch on this.triggerContext.getTriggerOperation()
		{
			when AFTER_DELETE { onAfterDelete(); }
			when AFTER_INSERT { onAfterInsert(); }
			when AFTER_UNDELETE { onAfterUndelete(); }
			when AFTER_UPDATE { onAfterUpdate(); }
			when BEFORE_DELETE { onBeforeDelete(); }
			when BEFORE_INSERT { onBeforeInsert(); }
			when BEFORE_UPDATE { onBeforeUpdate(); }
		}
	}

	/**
	 * Method used by the TriggerHandler and us to pass in the trigger context
	 *
	 * @param ctx Instance of fflib_ITriggerContext
	 *
	 * @return Instance of itself to allow for method chaining
	 */
	public fflib_ITriggerAction setContext(fflib_ITriggerContext ctx)
	{
		this.triggerContext = ctx;
		return this;
	}
}