package
{
	import com.adqua.event.XMLLoaderEvent;
	import com.adqua.net.XMLLoader;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import pEvent.PEvent;
	import pEvent.PEventCommon;
	import pEvent.PEventKeyPad;
	import pEvent.PEventVideo;
	
	import util.ONLineCheck;

	public class Controler
	{
		private var $model:Model;
		private static var $main:Controler;
		
		public function Controler()
		{
			$model = Model.getInstance();
			
		}
		public static function getInstance():Controler{
			if(!$main)$main = new Controler;
			return $main;
		}
		
		public function changeMovie(arg:Array):void{
			$model.numActiveVideo = arg;
			$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_CHANGE));
		}
		
		
        public function pauseMovie():void
		{
			$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_PAUSE));
			$model.mainPopupFrame = 0;
		}
		public function resumeMovie():void
		{
			$model.activeBottonContent = false;
			$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_RESUME));
			$model.mainPopupFrame = 0;
		}
		////////////////////////////////////////////////////////////////////////
		
		public function makeLoading():void{
			trace("makeLoading")
			$model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_SHOW));
			$model.dispatchEvent(new PEventCommon(PEventCommon.LOADING_MAKE));
		}
		
		public function loadComplete():void{
			$model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE));
			$model.dispatchEvent(new PEventCommon(PEventCommon.CONTENT_DOWNLOADED));
		}
		
		public function progress(progress:int):void{
			$model.numProgress = progress;
			$model.dispatchEvent(new PEventCommon(PEventCommon.PROGRESS));
		}
		
		
		public function jsTracking(str:String,param:String):void{
			if(ExternalInterface.available){
				ExternalInterface.call(str,param);
			}
		}
		
		public function movieFinished():void
		{
			$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_PLAY_FINISHED));		
		}
		
		public function swfContentLoad(nextNum:Array):void
		{
			$model.numNext = nextNum;
			$model.dispatchEvent(new PEventCommon(PEventCommon.SWF_CONTENT_LOAD));		
		}
		
		public function activeCheck(param0:int):void
		{
			var dataChk:Boolean = false;
			for (var i:int = 0; i < $model.watchedMov.length; i++) 
			{
				var num:int = $model.watchedMov[i];
				if(param0==num){
					dataChk = true;
				}
			}
			
			/**	본적 없는 영상일 때 - watchedMov에 저장 & 영상 번호 보내기	*/
			if(dataChk==false){
				/**	영상 번호 배열에 저장	*/
				$model.watchedMov.push(String(param0));
				
				/**	영상 번호 서버에 저장	*/
				var watchedMovLdr:XMLLoader= new XMLLoader();
				watchedMovLdr.addEventListener(XMLLoaderEvent.XML_COMPLETE, watchedMovLoadComplete);
				
				var urlVars:URLVariables = new URLVariables;
				urlVars.movNum = param0;
				
				var loadURL:String = $model.urlWatch[ONLineCheck.url()];
				
				watchedMovLdr.load(loadURL, urlVars);
			}
			
			$model.dispatchEvent(new PEvent(PEvent.ACTIVE_MENU_CHECK));
		}
		/**	서버에 저장 완료 후 결과	*/
		private function watchedMovLoadComplete(e:XMLLoaderEvent):void
		{
			trace("서버에 영상 번호 저장 완료________!! 저장된 번호===>>     " + e.xml.watchedMovie);
		}
		
		public function changeGNB(movNum:int):void
		{
			$model.activeBottonContent = false;
			if(movNum == 0){
				changeMovie([2,0]); //바바라스
			}else if(movNum == 1){
				changeMovie([2,2]); //수영장
			}else if(movNum == 2){
				changeMovie([2,3]); //밤쇼핑
			}
				
				
			else if(movNum == 3){
				changeMovie([3,0]); //골프
			}else if(movNum == 4){
				changeMovie([3,2]); //마사지
			}else if(movNum == 5){
				changeMovie([3,4]); //석양
			}
				
				
			else if(movNum == 6){
				changeMovie([4,0]); //기념품샵
			}else if(movNum == 7){
				changeMovie([4,1]); //씨푸드
			}			
		}
		
		public function activeBottomContent(param0:String):void
		{
			$model.activeBottonContent = true;
			$model.activeMenu = -1;
			if(param0=="left"){
				$model.underMovTitleSetting = 12;
				$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_EVENT_PLAY));				
			}else{
				$model.underMovTitleSetting = 11;
				$model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_ROUTE_PLAY));				
			}
			
			$model.dispatchEvent(new PEventCommon(PEventCommon.GNB_ACTIVE_ON));
		}
		
		public function popupShow(param0:int):void
		{
			pauseMovie();
			trace("하단 routeMap");
			$model.mainPopupFrame = param0;
			$model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
			
		}
	}
}