package com.discovery.events
{
	import flash.events.Event;
	
	public class DiscoveryEvent extends Event
	{
		// 리스트 호출
		public static const SHOW_LIST:String = "DiscoveryEvent_showList";
		
		// 리스트 없애기
		public static const HIDE_LIST:String = "DiscoveryEvent_hideList";
		
		// 상세보기 
		public static const VIEW_CONTENT:String = "DiscoveryEvent_viewContent"; 
		
		// 상세보기 끄기
		public static const CLOSE_CONTENT:String = "DiscoveryEvent_closeContent"; 
		
		//상세보기 리스트 변경
		public static const CHANGE_CONTENT:String = "DiscoveryEvent_changeContent";
		
		public static const SHOW_ALERT:String = "DiscoveryEvent_showAlert";
		
		private var _value:Object;
		
		public function DiscoveryEvent(type:String, value:Object, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_value = value;
		}
		
		override public function toString():String 
		{
			return formatToString("DiscoveryEvent", "type", "value", "bubbles", "cancelable");
		}
		
		override public function clone():Event
		{
			return new DiscoveryEvent(type, value, bubbles, cancelable);
		}
		
		public function get value():Object
		{
			return _value;
		}
	}
}