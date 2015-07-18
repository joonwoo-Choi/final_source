package com.sk2
{
	import com.greensock.loading.SWFLoader;
	import com.sk2.utils.DataProvider;
	
	import errorPopup.ErrorPopup;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	[SWF(width="1024",height="768",backgroundColor="0xffffff",frameRate="30")]

	public class Index extends Sprite
	{
		public function Index()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			/**	인터넷 접속 상태 검사	*/
			var errorPop:ErrorPopup = new ErrorPopup();
			
			var path:String = DataProvider.defaultURL+ "Main.swf";
			var loader:SWFLoader = new SWFLoader(path, {container:this, onComplet:loadComplete});
			var urlVars:URLVariables = new URLVariables;
			urlVars.ver = DataProvider.version
			loader.request.data = urlVars;
			loader.load();
			/**	풀 스크린 모드	*/
			stage.displayState = StageDisplayState.FULL_SCREEN;
			trace(":::_______"+loader);
//			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		protected function loadComplete(e:Event):void
		{
//			this.addChild(e.target.content);
			trace("::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::load complete");
		}
	}
}