package com.cj.events
{
	import flash.events.Event;
	
	public class DraggerEvent extends Event {
		
		public static const START_DRAG:String = "draggerStartDrag";
		public static const STOP_DRAG:String = "draggerStopDrag";
		public static const DRAG:String = "draggerDrag";
		public static const CANCEL_DRAG:String = "draggerCancelDrag";
		
		////////////////////////////////////////////////////////////
		////////////// constructor
		////////////////////////////////////////////////////////////
		
		public function DraggerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false):void 
		{
			super(type, bubbles, cancelable);
		}
		
		////////////////////////////////////////////////////////////
		////////////// override public method
		////////////////////////////////////////////////////////////
		
		//______________ toString ______________//
		override public function toString():String 
		{
			return formatToString("DraggerEvent","type","bubbles","cancelable");
		}
		
		//______________ clone ______________//
		override public function clone():Event 
		{
			return new DraggerEvent(type, bubbles, cancelable);
		}
		
	}
}