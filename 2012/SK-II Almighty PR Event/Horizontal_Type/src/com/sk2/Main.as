package com.sk2
{
	import com.adqua.net.FONTLoader;
	import com.adqua.ui.AdquaContext;
	import com.sk2.display.Layout;
	import com.sk2.display.Resize;
	import com.sk2.net.CallBack;
	import com.sk2.net.ConLoader;
	import com.sk2.net.Track;
	import com.sk2.sub.BaseSub;
	import com.sk2.utils.DataProvider;
	import com.sw.display.BaseIndex;
	import com.sw.display.ContextMenu;
	import com.sw.net.Location;
	
	import errorPopup.ErrorPopup;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Security;
	
	/**
	 * SK2	::	Document 클래스
	 * */
	[SWF(width="1024",height="768",backgroundColor="0xffffff",frameRate="30")]
	public class Main extends BaseIndex
	{
		/**	생성자	*/
		public function Main()
		{
			super();
			init();
			/**	인터넷 접속 상태 검사	*/
			var errorPop:ErrorPopup = new ErrorPopup();
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		/**	소멸자	*/
		override public function destroy(e:Event = null):void
		{	
			super.destroy();	
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			DataProvider.index = this;
//			DataProvider.rootURL = "http://prevent.purepitera.co.kr/swf/hori/"
			DataProvider.rootURL = Location.setURL(DataProvider.defaultURL,"");
			//DataProvider.dataURL = Location.setURL("http://www.purepitera.co.kr","");
			DataProvider.dataURL = Location.setURL(DataProvider.defaultURL,"");
			
			DataProvider.pos1 = 1;
			DataProvider.pos2 = 1;
			DataProvider.baseSub = new BaseSub(this,{});
			DataProvider.track = new Track();
			
			//var fontLoader:FONTLoader = new FONTLoader(this,DataProvider.rootURL+"font/YDIYSin.swf");
			//var fontLoader2:FONTLoader = new FONTLoader(this,DataProvider.rootURL+"font/CreMyungjo_L.swf");
		}
		/**
		 * 화면에 붙여질 때 수행
		 * */
		override protected function onAdd(e:Event):void
		{
			super.onAdd(e);
			
			DataProvider.stage = stage;
			ContextMenu.setMenu(this);
			
			DataProvider.callBack = new CallBack();
			
			var login:String = loaderInfo.parameters.login;
			if(login == "1")
				DataProvider.callBack.login = true;
			else DataProvider.callBack.login = false;
			
			DataProvider.layout = new Layout();
			DataProvider.resize = new Resize(stage);
			DataProvider.loader = new ConLoader();
		}
	}//class
}//package