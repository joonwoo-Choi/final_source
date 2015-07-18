package com.cj.events
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const MENU_SELECT:String = "get_idx";
		
		public var index:int;
		
		public function MenuEvent(type:String, idx:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.index = idx;
		} 
		
		public override function clone():Event 
		{ 
			return new MenuEvent(type, index, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuEvent", "type", "idx", "bubbles", "cancelable", "eventPhase");
		}
	}
}