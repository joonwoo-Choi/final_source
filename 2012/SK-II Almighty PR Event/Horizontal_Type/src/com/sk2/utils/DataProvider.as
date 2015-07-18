package com.sk2.utils
{
	import com.sk2.Main;
	import com.sk2.display.Layout;
	import com.sk2.display.Resize;
	import com.sk2.net.CallBack;
	import com.sk2.net.ConLoader;
	import com.sk2.net.Track;
	import com.sk2.sub.BaseSub;
//	import com.sk2.ui.Popup;
	import com.sw.net.FncOut;
	
	import flash.display.Stage;

	/**
	 * SK2	::	전체 공용 변수 모음
	 * */
	public class DataProvider
	{
		static public var defaultURL:String = "http://prevent.purepitera.co.kr/swf/hori/";
		static public var version:int = 1;
		static public var stage:Stage;
		static public var index:Main;
		static public var rootURL:String = "http://prevent.purepitera.co.kr/swf/hori/";
		static public var dataURL:String = "http://prevent.purepitera.co.kr/swf/hori/";
		static public var callBack:CallBack;
//		static public var popup:Popup;
		static public var track:Track;
		static public var layout:Layout;
		static public var loader:ConLoader;
		static public var resize:Resize;
		static public var baseSub:BaseSub;
		
		
		/**	1뎁스 위치	*/
		static public var pos1:int;
		/**	2뎁스 위치	*/
		static public var pos2:int;
		
		/**	생성자	*/
		public function DataProvider()
		{
				
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**	로그인 함수 호출	*/
		static public function callLogin($txt:String = ""):void
		{
			switch($txt)
			{
			case "":
				FncOut.call("piteraMenu.showMainLogin");
				break;
			case "evt2Write":
				FncOut.call("piteraMenu.showEpilogueLogin");
				break;
			case "evt1":
				FncOut.call("piteraMenu.showTourLogin");
				break;
			case "evt1_write" :
				FncOut.call("piteraMenu.showPostLogin");
				//FncOut.call("piteraMenu.showMainLogin");
				break;
			}
		}
		
	}//class
}//package