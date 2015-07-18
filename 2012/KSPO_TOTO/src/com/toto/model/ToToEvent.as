package com.toto.model
{
	
	import flash.events.Event;
	
	public class ToToEvent extends Event
	{
		/**	홈으로 가기	*/
		public static const GO_HOME:String = "goHome";
		/**	이벤트1로 가기	*/
		public static const GO_EVENT_ONE:String = "goEventOne";
//		public static const GO_MAIN_SHOW:String = "goMainShow";
//		public static const GO_SUB1_SHOW:String = "goSub1Show";
//		public static const GO_SUB2_SHOW:String = "goSub2Show";
		/** 이벤트 완료 **/
		public static const COMPLETE_POPUP:String = "completPopup";
		
		public function ToToEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}