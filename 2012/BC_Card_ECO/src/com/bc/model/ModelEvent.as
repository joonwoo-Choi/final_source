package com.bc.model
{
	
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		
		/** XML 로드 완료 **/
		public static const XML_LOADED:String = "xmlLoaded";
		/**	메인 로드	*/
		public static const MAIN_LOAD:String = "mainLoad";
		/** 태그 이미지 로드 완료 **/
		public static const TAG_LOADED:String = "tagLoaded";
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}