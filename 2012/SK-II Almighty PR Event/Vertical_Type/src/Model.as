package
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/** 결과 값	*/
		public var resultNum:int;
		/** 본 이미지 번호 배열 저장	*/
		public var viewArr:Array = [];
		/**	배열 갯수	*/
		public var viewLength:int = 1;
		/**	이벤트 페이지 번호	*/
		public var evtPageNum:int = 0;
		/**	유저 이름	*/
		public var uname:String;
		/**	유저 전화 번호	*/
		public var ucellular:String;
		
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