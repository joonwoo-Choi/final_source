package com.smirnoff.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var _model:Model = new Model();
		/**	공통 경로	*/
		public var defaultPath:String = "";
		public var sndList:XML;
		public var openLength:int;
		public var isLogoClick:Boolean = true;
		public var uName:String = "LEE SU JEE";
		public var uTitle:String = "수지팝팝";
		public var FBToken:String = "aaasdasfasfasfasf";
		public var FBID:String = "100004026803911";
		public var uImg:String = "img/uImg.jpg";
		public var sndUrl:String = "snd/music.mp3";
		public var cdNum:int;
		public var selectedRemixNum:Array;
//		public var sendMakeMusicUrl:String = "http://112.153.151.124/process/CreateMusic.ashx";
//		public var sendMakeTitleUrl:String = "http://112.153.151.124/process/EventComplete.ashx";
		public var dataUrl:String = "http://test.smirnoffdistrict.com/";
		public var outputSndUrl:String = "http://test.smirnoffdistrict.com/uploads/mp3/";
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():Model
		{
			return _model;
		}
	}
}