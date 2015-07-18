package com.hm.events
{
	import flash.events.Event;
	
	public class HellomobileEvent extends Event
	{
		
		/**	사용자 정보 획득	*/
		public static const GET_USER_INFO:String = "videoSetting";
		
		public function HellomobileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}