package com.cj.events
{
	import flash.events.Event;
	
	public class PageEvent extends Event
	{
		public static const PAGE_UPDATE:String = "page_update";
		
		public var page:int;
		
		public function PageEvent(type:String, page:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.page = page;
		} 
		
		public override function clone():Event 
		{ 
			return new PageEvent(type, page, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PageEvent", "type", "page", "bubbles", "cancelable", "eventPhase");
		}
	}
	
}