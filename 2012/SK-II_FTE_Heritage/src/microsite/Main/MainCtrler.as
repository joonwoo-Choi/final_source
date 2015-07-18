package microsite.Main
{
	import adqua.event.LoadVarsEvent;
	import adqua.net.LoadVars;
	
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class MainCtrler
	{
		private static var $main:MainCtrler;
		private var $loadVars:LoadVars;
		private var $model:MainModel;
		private var $global:Global;
		public function MainCtrler()
		{
			$model = MainModel.getInstance();
			$global = Global.getIns();
		}
		public function getMovieCnt(loadType:String):void{
			trace("getMovieCnt");
			var sendData:URLVariables = new URLVariables();
			sendData.mov = "mov"+int($global.essayNum+1);
			sendData.t = loadType;
			sendData.s = "W";
			$loadVars = new LoadVars(Global.getIns().dataURL+"/Process/MovieCount.ashx", sendData,URLRequestMethod.POST,URLLoaderDataFormat.TEXT);
			$loadVars.addEventListener(LoadVarsEvent.COMPLETE, completeHandler);
			
			/**	20150525	개발 프로세스 제거	*/
			$model.dispatchEvent(new GlobalEvent(GlobalEvent.MOVIE_COUNT_CHANGED));
		}
		protected function completeHandler(evt:LoadVarsEvent):void
		{
			trace("evt.data: ",evt.data);
			$model.movieCount = String(evt.data).split("&")[1];
			$model.dispatchEvent(new GlobalEvent(GlobalEvent.MOVIE_COUNT_CHANGED));
		}
		public static function getInstance():MainCtrler{
			if(!$main)$main = new MainCtrler;
			return $main;
		}
	}
}