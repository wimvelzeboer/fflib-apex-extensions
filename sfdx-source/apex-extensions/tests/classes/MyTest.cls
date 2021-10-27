/**
 * File Name: MyTest 
 * Description: 
 *
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public with sharing class MyTest
{

	public class WorkA extends fflib_DoWork
	{
		public void doWork()
		{
			System.debug('Work A executing');
			insert new fflib_LogEntry__c(
					LogLevel__c = 'INFO',
					Message__c = 'WorkA'
			);
		}
	}

	public class WorkB extends fflib_DoWork
	{
		public void doWork()
		{
			System.debug('Work B executing');
			insert new fflib_LogEntry__c(
					LogLevel__c = 'INFO',
					Message__c = 'WorkB'
			);
		}
	}

	public class WorkC extends fflib_DoWork
	{
		public void doWork()
		{
			System.debug('Work C executing');
			insert new fflib_LogEntry__c(
					LogLevel__c = 'INFO',
					Message__c = 'WorkC'
			);
		}
	}

}