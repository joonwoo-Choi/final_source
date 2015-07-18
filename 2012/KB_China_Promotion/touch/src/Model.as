package
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 URL	*/
		public var defaultURL:String = "";
		/**	모델 비디오 XML	*/
		public var ModelXml:XML;
		/**	모델 페이지 팝업 번호	*/
		public var popupNum:int;
		/**	서브 메뉴 번호	*/
		public var subNum:int;
		/**	리스트 배열 번호	*/
		public var listArrayNum:int;
		
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function dispose():void
		{
			$model = null;
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():Model
		{
			return $model;
		}
	}
}