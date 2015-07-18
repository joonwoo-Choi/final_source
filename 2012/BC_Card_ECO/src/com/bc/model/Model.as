package com.bc.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/** 리스트 XML	*/
		public var listXml:XML;
		/**	상품 배열	*/
		public var productArr:Array = [];
		/**	에코머니 아이템 수	*/
		public var itemLength:int;
		/**	에코머니 아이템 배열 	*/
		public var itemArr:Array = [];
		/**	스템프 배열	*/
		public var stampArr:Array = [];
		/**	물범 배열	*/
		public var moolbumArr:Array = [];
		/**	경로 설정	*/
		public var webUrl:String = "swf/";
		/**	카트 에코머니	*/
		public var cartStampArr:Array = [];
		/**	에코머니 아이템 반복 붙이는 수	*/
		public var repeatNum:int = 3;
		
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