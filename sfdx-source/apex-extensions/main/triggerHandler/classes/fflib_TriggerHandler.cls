/**
 * File Name: fflib_TriggerHandler
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
public virtual with sharing class fflib_TriggerHandler
		implements fflib_ITriggerHandler
{
	public static final System.Type DEFAUT_TRIGGERCONTEXT_TYPE = fflib_TriggerContext.class;

	@TestVisible
	protected System.Type triggerContextType
	{
		get
		{
			if (triggerContextType == null)
			{
				triggerContextType = DEFAUT_TRIGGERCONTEXT_TYPE;
			}
			return triggerContextType;
		}
		private set;
	}

	protected fflib_ITriggerContext triggerContext;

	/**
	 * Retain instance of Trigger Action classes implementing stateful
	 */
	@TestVisible
	private static Map<Type, fflib_ITriggerAction> triggerActionStateByClass;

	/**
	 * Provides access to the trigger action configurations and allowing it to be mocked in unit-tests
	 */
	@TestVisible
	private static List<fflib_ITriggerActionConfig> configs = new List<fflib_ITriggerActionConfig>();

	/**
	 * Main method to execute the trigger handler to call the trigger actions
	 */
	public void run()
	{
		loadConfiguration();
		fflib_ITriggerContext ctx = getTriggerContext();
		execute(ctx);
	}

	/**
	 * Tells the trigger handler in which trigger context it is running
	 *
	 * @param ctx A configured Trigger Context instance
	 *
	 * @return Instance of itself to allow for method chaining
	 */
	public fflib_ITriggerHandler setTriggerContext(fflib_ITriggerContext ctx)
	{
		this.triggerContext = ctx;
		return this;
	}

	/**
	 * Tells the trigger handler in which trigger context it is running
	 *
	 * @param classType A reference to the Trigger Context class to use when executing the trigger handler
	 *
	 * @return Instance of itself to allow for method chaining
	 */
	public fflib_ITriggerHandler setTriggerContextType(Type classType)
	{
		this.triggerContextType = classType;
		return this;
	}

	@TestVisible
	protected void addTriggerActionConfig(fflib_TriggerAction__mdt config)
	{
		configs.add(new fflib_TriggerActionConfig(config));
	}

	protected void execute(fflib_ITriggerContext ctx)
	{
		fflib_UnitOfWork unitOfWork = new fflib_UnitOfWork();
		for (fflib_ITriggerActionConfig triggerActionConfig : configs)
		{
			if (isValidExecutionContext(ctx, triggerActionConfig) == false
					||
					isValidSObjectType(triggerActionConfig, ctx) == false) continue;

			fflib_ITriggerAction triggerAction = getTriggerActionInstance(triggerActionConfig);

			triggerAction.setContext(ctx);
			triggerAction.setSequence(triggerActionConfig.getSequence());

			// Queueable only makes sense in an onAfter context.
			if (triggerActionConfig.isQueued() && ctx.isAfter())
			{
				triggerAction.enableQueueable(triggerActionConfig.isDedicatedQueued());
			}

			unitOfWork.addWork(triggerAction);
		}
		unitOfWork.doWork();
	}

	private Boolean isValidExecutionContext(fflib_ITriggerContext ctx, fflib_ITriggerActionConfig config)
	{
		return config.hasTriggerContext(ctx.getTriggerOperation());
	}

	private Boolean isValidSObjectType(fflib_ITriggerActionConfig triggerActionConfig, fflib_ITriggerContext ctx)
	{
		return triggerActionConfig.getSObjectType() == ctx.getRecords().get(0).getSObjectType();
	}

	private fflib_ITriggerAction getTriggerActionInstance(fflib_ITriggerActionConfig triggerActionConfig)
	{
		if (triggerActionConfig.isStateful()
				&& triggerActionStateByClass != null
				&& triggerActionStateByClass.containsKey(triggerActionConfig.getImplementationType()))
		{
			return triggerActionStateByClass.get(triggerActionConfig.getImplementationType());
		}

		return triggerActionConfig.newInstance();
	}

	@TestVisible
	protected void loadConfiguration()
	{
		if (configs.isEmpty() == false) return;

		for (fflib_TriggerAction__mdt action : new fflib_TriggerActionConfigSelector().selectAllActive())
		{
			configs.add( new fflib_TriggerActionConfig(action));
		}
	}

	private fflib_ITriggerContext constructTriggerContext()
	{
		// Construct the trigger context domain class constructor class
		String triggerContextClassName = triggerContextType.getName();
		Type constructableClass =
				triggerContextClassName.endsWith('Constructor')
						? Type.forName(triggerContextClassName)
						: Type.forName(triggerContextClassName + '.Constructor');
		fflib_IDomainConstructor domainConstructor = (fflib_IDomainConstructor) constructableClass.newInstance();

		// Construct the trigger context domain class with the appropriate record set
		if (Trigger.isInsert) return (fflib_ITriggerContext) domainConstructor.construct(Trigger.new);
		else if (Trigger.isUpdate) return (fflib_ITriggerContext) domainConstructor.construct(Trigger.new);
		else if (Trigger.isDelete) return (fflib_ITriggerContext) domainConstructor.construct(Trigger.old);
		else if (Trigger.isUndelete) return (fflib_ITriggerContext) domainConstructor.construct(Trigger.new);

		return null;
	}

	private fflib_ITriggerContext getTriggerContext()
	{
		if (triggerContext == null) triggerContext = constructTriggerContext();

		return triggerContext;
	}
}