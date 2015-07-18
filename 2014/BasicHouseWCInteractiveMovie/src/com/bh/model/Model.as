package com.bh.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 경로	*/
		public var commonPath:String = "";
		/**	메인 롤링 카드섹션 데이터 경로	*/
		public var userDataPath:String = "xml/user_list.xml";
		/**	메인 롤링 카드섹션 유저정보	*/
		public var userXml:XML;
		/**	유저 수	*/
		public var userLength:int;
		/**	카드섹션 문구 배열	*/
		public var cardSectionArr:Array = [];
		/**	영상 씬 번호	*/
		public var sceneNum:int;
		
//		public var fullCardsection:Boolean = false;
		
		public var isIntro:Boolean = false;
		public var hideUI:Boolean = false;
		
		public var fullVideo:Boolean = false;
		public var toName:String = "to유저";
		public var fromName:String = "from유저";
		public var imgUrl:String = "img/userImg1.jpg";
		
		public var galleryOpen:Boolean = false;
		public var myMovieOpen:Boolean = false;
		public var scrap:Boolean = false;
		
		public var loop:Boolean = false;
		
//		public var isPause:Boolean = false;
		
		public var fullVideoEnd:Boolean = false;
		public var mute:Boolean = false;
		
		public var nowPlay:Boolean = false;
		
		public var closeUp:Boolean = false;
		
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