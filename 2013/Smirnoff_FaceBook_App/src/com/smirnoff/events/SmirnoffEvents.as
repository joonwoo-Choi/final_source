package com.smirnoff.events
{
	
	import flash.events.Event;
	
	public class SmirnoffEvents extends Event
	{
		
		/**	페이지 변경	*/
		public static const PAGE_CHANGED:String = "pageChanged";
		/**	메인페이지	*/
		public static const GO_MAIN:String = "goMain";
		
		private var _value:Object;
		
		public function SmirnoffEvents(type:String, value:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_value = value;
		}
		
		public function get value():Object
		{
			return _value;
		}
	}
}