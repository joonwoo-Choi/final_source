package microsite.Main
{
	
	import adqua.event.XMLLoaderEvent;
	import adqua.movieclip.TestButton;
	import adqua.net.Debug;
	import adqua.net.XMLLoader;
	import adqua.util.NetUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AlignMode;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.lumpens.utils.ButtonUtil;
	import com.sw.display.BaseIndex;
	import com.sw.utils.book.Book;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.system.System;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.Main.special.SpecialCon;
	
	import orpheus.event.LoadVarsEvent;
	import orpheus.net.LoadVars;
	import orpheus.system.SecurityUtil;
	import orpheus.templete.countDown.PiteraCount;
	
	import util.LoadingMC;
	
	[SWF(width="1280",height="768", backgroundColor = "#000000" ,frameRate="30")]
	
	public class PurepiteraMain extends BaseIndex
	{
		
		/** 컨테이너 **/
		private var $container:AssetMain;
		/** 클래스 모음 **/
		private var $HeritageMain:HeritageMain;
		/** 인트로 네비게이션 로더 **/
		private var $gnbLdr:LoaderMax;
		/** 네비게이션 **/
		private var $gnb:ContentDisplay;
		/** 푸터 **/
		private var $footer:ContentDisplay;
		/** 인트로 **/
		private var $intro:ContentDisplay;
		/** 인트로 Boolean **/
		private var $introIs:String;
		/** 글로벌 클래스 **/
		private var $global:Global;
		/** 유알엘 **/
		private var $rootUrl:String;
		/** 인트로 로더 **/
//		private var $introLdr:Loader;
		/** 인트로 타임아웃 **/
		private var $introTimeout:uint;
		private var $loadVars:LoadVars;
		private var $model:MainModel;
//		private var $loading:LoadingMC;
		private var $flashVars:Object;
		private var $specialOpenContent:SpecialCon;
		private var $ctrler:MainCtrler;
		
		public function PurepiteraMain()
		{
			super();
			trace("PurepiteraMain0713");
		}
		
		protected function getMovieCnt(event:Event):void
		{
			trace("getMovieCnt");
			$ctrler.getMovieCnt("get");
		}
		
		override protected function onAdd(e:Event):void
		{
			super.onAdd(e);
			$global = Global.getIns();
			$model = MainModel.getInstance();
			$global.addEventListener(GlobalEvent.PAGE_CHANGED,getMovieCnt);
			$ctrler = MainCtrler.getInstance();
			$global.urlType = "web";
			$rootUrl = root.loaderInfo.url;
			
			if(SecurityUtil.isWeb()){
				if($rootUrl.indexOf("test")==-1){
					Global.getIns().dataURL="http://www.purepitera.co.kr"
				}else{
					Global.getIns().dataURL="http://hertest.purepitera.co.kr"
				}
			}else{
				Global.getIns().dataURL="http://hertest.purepitera.co.kr";
			}
			
			$global.gnbVisible = false;
			$ctrler.getMovieCnt("get");
			$model.addEventListener(GlobalEvent.MOVIE_COUNT_CHANGED,completeHandler);
			
		}
		
		protected function completeHandler(evt:GlobalEvent):void
		{
			$container = new AssetMain();
			addChild( $container );
			$container.alpha = 0;
			makeIntro();
			stage.addEventListener( Event.RESIZE, resizeHandler );
			$model.removeEventListener(GlobalEvent.MOVIE_COUNT_CHANGED,completeHandler);
		}
		
		private function makeIntro():void
		{
			viewContainer();
			resizeHandler();
		}
		
		protected function introLoaded(event:Event):void
		{
			trace("introLoaded");
		}		
		
		protected function resizeHandler(e:Event = null):void
		{
			if($footer) 
			{
				if($container.stage.stageHeight > 768 ) $footer.y = stage.stageHeight - $footer.height;
				else $footer.y = 768 - $footer.height;
			}
		}
		
		/** 인트로 제거 메인 붙이기 **/
		private function viewContainer():void
		{
			$HeritageMain = new HeritageMain( $container );
			TweenLite.to( $container, 1, {alpha:1});
			
			gnbLoad();
			xmlLoad();
			userNameload();
		}
		
		/** GNB 로드 **/
		private function gnbLoad():void
		{
			trace("gnbLoad");
			$specialOpenContent = new SpecialCon;
			addChild($specialOpenContent);		
			
			$gnbLdr = new LoaderMax({ name:"GNB", onComplete:gnbLoadComplete });
			$gnbLdr.append( new SWFLoader(SecurityUtil.getPath($container.root)+"GNB_Essay.swf", {name:"essayGNB" ,  container:$container.gnbContainer , alpha:0  , autoPlay:false}) );
			$gnbLdr.append( new SWFLoader(SecurityUtil.getPath($container.root)+"Footer.swf", {name:"footer" , container:$container , alpha:0  , autoPlay:false}) );
			$gnbLdr.load();
		}
		
		/** GNB 로드 **/
		private function gnbLoadComplete(e:LoaderEvent):void
		{
			$gnb = LoaderMax.getContent("essayGNB");
			TweenLite.to($gnb, 0.5, {alpha:1});
			$container.gnbContainer.addChild( $gnb );
			$footer = LoaderMax.getContent("footer");
			TweenLite.to($footer, 0.5, {alpha:1});
			$container.addChild( $footer );
			
			resizeHandler();
			trace(e.target + " is complete!");
		}
		
		/** XML 로드 **/
		private function xmlLoad():void
		{
			var essayListLoader:XMLLoader = new XMLLoader();
			essayListLoader.load(SecurityUtil.getPath(root)+"xml/essayList.xml");
			essayListLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE,xmlLoadHandler);
		}
		
		/** XML 로드 완료 **/
		private function xmlLoadHandler(e:XMLLoaderEvent):void {
			var essayXml:XML = e.xml;
			$global.essayXml = essayXml;
			
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.XML_LOADED ));
		}
		
		protected function userNameload():void
		{
			var listVar:URLVariables = new URLVariables();
			listVar.type = "xml";
			listVar.rand = Math.random()*100000;
			var $xmlReq:URLRequest = new URLRequest("Process/Launch/GetNameList.ashx");
			$xmlReq.data = listVar;
			$xmlReq.method = URLRequestMethod.POST;
			
			var $xmlLdr:URLLoader = new URLLoader;
			$xmlLdr.dataFormat = URLLoaderDataFormat.TEXT;
			$xmlLdr.load($xmlReq);
			$xmlLdr.addEventListener(IOErrorEvent.IO_ERROR,onError);
			$xmlLdr.addEventListener( Event.COMPLETE , xmlLoadComplete );
		}
		
		protected function onError(evt:IOErrorEvent):void
		{
			Debug.alert(evt.type);
		}
		
		protected function xmlLoadComplete(e:Event):void
		{
			$model.userXml = new XML(URLLoader(e.currentTarget).data);
			$model.dispatchEvent( new GlobalEvent( GlobalEvent.USER_LOAD_COMPLETE ));
		}
	}
}