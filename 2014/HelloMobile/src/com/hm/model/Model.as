package com.hm.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 경로	*/
		public var commonPath:String = "";
		/**	페이지 호출 경로	*/
		public var dataUrl:String = "http://test.culture.cjhello.com/";
		/**	유저 정보 XML	*/
		public var boxData:XML;
		/**	참여 여부*/
		public var join:String = "";
		/**	요금제	*/
		public var rateType:int;
		/**	현재 박스 탭 번호	*/
		public var boxTabNum:int;
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():Model
		{
			return $model;
		}
	}
}