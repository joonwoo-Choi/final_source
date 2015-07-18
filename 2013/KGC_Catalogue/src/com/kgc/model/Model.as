package com.kgc.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class Model extends EventDispatcher
	{
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	기본 경로	*/
		public var defaultPath:String = "";
		/**	XML	*/
		public var listXml:XML;
		/**	리스트 갯수	*/
		public var listLength:int;
		/**	컨텐츠별 리스트 시작 번호 배열	*/
		public var listStartNumArr:Array = [];
		/**	현재	페이지 번호	*/
		public var pageNum:int = -1;
		/**	이전 페이지 번호	*/
		public var prevPageNum:int;
		/**	마지막 페이지 번호	*/
		public var lastPageNum:int;
		/**	페이지 이동 방향	*/
		public var direction:String = "right";
		/**	페이지 로드 중 클릭 금지	*/
		public var clickCheck:Boolean = true;;
		/**	페이지 배열	*/
		public var pageArr:Array = [];
		/**	카다로그 원본 가로 크기	*/
		public var imgOriginW:Number;
		/**	카다로그 원본 세로 크기	*/
		public var imgOriginH:Number;
		/**	페이지 스케일	*/
		public var pageScale:Number = 1;
		/**	섬네일 X	*/
		public var thumbX:int;
		/**	섬네일 Y	*/
		public var thumbY:int;
		
		public function Model(target:IEventDispatcher = null)
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