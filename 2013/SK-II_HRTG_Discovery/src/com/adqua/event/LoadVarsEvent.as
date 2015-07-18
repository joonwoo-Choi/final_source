package com.adqua.event
{
	import flash.events.Event;
	
	/**
	 * @author philip
	 */
	public class LoadVarsEvent extends Event 
	{
		public static const COMPLETE:String = "loadComplete";
		public static const ERROR:String = "loadError";
		
		public var data:*;
		public var error:String;
		public var errorType:String;

		public function LoadVarsEvent(type:String, vars:* = null, errorMsg:String = null, errortype:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			data = vars;
			error = errorMsg;
			errorType = errortype;
		}
		
		override public function clone():Event
		{
			return new LoadVarsEvent(type, data, error, errorType, bubbles, cancelable);
		}
	}
}
