package
{
	import com.adqua.event.XMLLoaderEvent;
	import com.adqua.net.Debug;
	import com.adqua.net.XMLLoader;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import day.DayBg;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.Timer;
	
	import loading.ViewLoading;
	
	import orpheus.utils.ArrayUtil;
	
	import pEvent.PEventCommon;
	import pEvent.PEventVideo;
	
	import popup.MainPopup;
	
	import util.BgPlayer;
	import util.MainPlayer;
	
	
	[SWF(width="1280",height="850",frameRate="30")]
	public class ProjectP extends AbstractMain
	{
		private var $vcCover:Sprite;
		private var $commonPlayer:BgPlayer;
		private var $xmlLoader:XMLLoader;
		private var $introSkip:SkipBtn;
		private var $inputUserInfoLoader:Loader;
		private var $mainPlayer:MainPlayer;
		private var $dayBg:DayBg;
		private var $unb:UNB;
		private var $gnb:GNB;
		private var $rightTop:RightTop;
		private var $viewLoading:ViewLoading;
		private var _timer:Timer;
		private var $loading:MCLoading;
		private var $popBg:PopBg;
		private var $mainPopup:MainPopup;
		
		public function ProjectP()
		{
			Security.allowDomain("*");
			TweenPlugin.activate([FramePlugin]);
			TweenPlugin.activate([AutoAlphaPlugin]);
			_model.addEventListener(PEventCommon.MOVIE_CHANGE, mainLoadChk);
			_model.addEventListener(PEventCommon.MAIN_CHANGE, loadMainSWF);
		}
		
		protected function mainLoadChk(event:Event):void
		{
			
			if(ArrayUtil.compare(_model.numActiveVideo,[1])){
				loadMainSWF();
			}else{
				unloadMainSWF();
			}
		}
		
		private function loadMainSWF(evt:PEventCommon = null):void
		{
			loadInputUserInfo();
			
			//로고클릭 했을때
			
			makeDayBgOff();
			_model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_REMOVE));
		}
		
		override protected function onAdded(event:Event):void
		{
			_model.urlDefault = SecurityUtil.getPath(root);
			$xmlLoader = new XMLLoader;
			
			if(SecurityUtil.isWeb()==true){
				$xmlLoader.load(_model.urlDefaultWeb+"xml/movie.xml");
			}else{
				$xmlLoader.load(_model.urlDefault+"xml/movie_d.xml");
			}
			
			$xmlLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE, setting);
			super.onAdded(event);
		}
		
		protected function setting(event:XMLLoaderEvent = null):void
		{
			_model.xmlData = event.xml;
			
			//인트로 player
			$commonPlayer = new BgPlayer;
			addChild($commonPlayer);
			$commonPlayer.width = stage.stageWidth;
			$commonPlayer.height = stage.stageHeight;
			$commonPlayer.scaleX = $commonPlayer.scaleY = Math.max($commonPlayer.scaleX, $commonPlayer.scaleY);
			_model.objW =$commonPlayer.width;
			_model.objH =$commonPlayer.height;
			
			//vcCover (main.swf 커버)
			$vcCover = new Sprite;
			addChild($vcCover);
			
			//changeMovie
			_controler.changeMovie([0]);
			
			//introSkip
			$introSkip = new SkipBtn;
			addChild($introSkip);
			$introSkip.buttonMode = true;
			$introSkip.addEventListener(MouseEvent.ROLL_OVER, introOver);
			$introSkip.addEventListener(MouseEvent.ROLL_OUT, introOut);
			$introSkip.addEventListener(MouseEvent.CLICK, introClick);
			TweenLite.to($introSkip, .5, {delay:2, onComplete:skipStart});
			
			//dayBg
			$dayBg = new DayBg;
			addChild($dayBg);
			$dayBg.mouseEnabled = false;
			$dayBg.mouseChildren = false;
			$dayBg.visible = false;
			
			//오른쪽로고bg
			$rightTop = new RightTop;
			addChild($rightTop);
			$rightTop.visible = false;
			
			//mainPlayer
			$mainPlayer = new MainPlayer;
			addChild($mainPlayer);
//			$mainPlayer.visible= false;

			//unb
			$unb = new UNB;
			addChild($unb);
			$unb.visible = false;
			
			//gnb
			$gnb = new GNB;
			addChild($gnb);
			$gnb.visible = false;
			
			//popBg (검정알파bg)
			$popBg = new PopBg;
			addChild($popBg);
			$popBg.visible = false;
			$popBg.alpha = 0;
			
			//loading
			$loading = new MCLoading;	
			$viewLoading = new ViewLoading($loading);

			//popup
			$mainPopup = new MainPopup;
			addChild($mainPopup);
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.showDefaultContextMenu = false;
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
			
			$dayBg.stage.addEventListener(MouseEvent.MOUSE_MOVE, bgMoveHandler);
			
			//DAY BG
			_model.addEventListener(PEventCommon.MAKE_DAYBG,makeDayBg);
			
			_model.addEventListener(PEventCommon.CONTENT_DOWNLOADED,$viewLoading.hideLoading);
			
			_model.addEventListener(PEventCommon.LOADING_MAKE,makingLoading);
			_model.addEventListener(PEventCommon.LOADING_HIDE_COMPLETE,hideLoadingComplete);
			
			_model.addEventListener(PEventCommon.POPBG_SHOW,popBgShow);
			_model.addEventListener(PEventCommon.POPBG_HIDE,popBgHide);
			
			_model.addEventListener(PEventCommon.INTRO_NEXT,introNext);
		}	
		
		protected function popBgShow(evt:PEventCommon=null):void
		{
			TweenLite.to($popBg, .5, {autoAlpha:1});
		}
		
		protected function popBgHide(evt:PEventCommon=null):void
		{
			TweenLite.to($popBg, .5, {autoAlpha:0});
		}
		
		private function skipStart():void
		{
			TweenLite.to($introSkip, .5, {frame:$introSkip.totalFrames - 1})
		}
		
		protected function introOver(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"]["bg"].gotoAndStop(2);
		}
		protected function introOut(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"]["bg"].gotoAndStop(1);
		}
		
		//인트로 클릭
		protected function introClick(event:MouseEvent):void
		{
			TweenLite.to($introSkip, .5, {frame:1, onComplete:introNext})
		}
		
		//인트로 아웃되고 메인실행
		private function introNext(evt:PEventCommon = null):void
		{
			$introSkip.stop();
			$introSkip.visible = false;
			
			//로딩
			addChild($loading);
			_controler.makeLoading();
			
			loadInputUserInfo();
			
			$introSkip.removeEventListener(MouseEvent.ROLL_OVER, introOver);
			$introSkip.removeEventListener(MouseEvent.ROLL_OUT, introOut);
			$introSkip.removeEventListener(MouseEvent.CLICK, introClick);
		}
		
		
		//main Load
		private function loadInputUserInfo():void
		{
			//트래킹
			if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_main");
			
			$introSkip.stop();
			$introSkip.visible = false;
			
			$inputUserInfoLoader = new Loader;
			if(SecurityUtil.isWeb()==true){
				$inputUserInfoLoader.load(new URLRequest(_model.urlDefaultWeb + "Main.swf"));
			}else{
				$inputUserInfoLoader.load(new URLRequest(_model.urlDefault + "Main.swf"));
			}
			$inputUserInfoLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			$inputUserInfoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,userInfoMCLoaded);
		}
		
		protected function userInfoMCLoaded(event:Event):void
		{
			_model.dispatchEvent(new PEventVideo(PEventVideo.VIDEO_CLEAR))
			_model.dispatchEvent(new PEventVideo(PEventVideo.VIDEO_CLOSE))
			
			_controler.loadComplete();
			
			$vcCover.addChild($inputUserInfoLoader);
			onResize();
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			var per:Number = int((event.bytesLoaded/event.bytesTotal)*100);
			_controler.progress(per);
		}
		
		protected function makingLoading(event:Event):void
		{
			onResize();
			$viewLoading.makingLoading(event);
		}
		
		private function hideLoadingComplete(event:Event):void
		{
//			loadInputUserInfo();
			_model.removeEventListener(PEventCommon.LOADING_HIDE_COMPLETE,hideLoadingComplete);
		}
		
		protected function makeDayBg(evt:Event):void	
		{
			//Day나올떄 
			$unb.visible = true;
			$gnb.visible = true;
			$dayBg.visible = true;
			
			$rightTop.visible = true;
			_model.dispatchEvent(new PEventCommon(PEventVideo.VIDEO_CLEAR));
			_model.dispatchEvent(new PEventCommon(PEventVideo.VIDEO_CLOSE));
//			_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_OPEN_ONOFF));
			_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_OPEN_ON));
		}
		
		protected function makeDayBgOff(evt:Event=null):void	
		{
			//Day나올떄 
			$unb.visible = false;
			$gnb.visible = false;
			$dayBg.visible = false;
			$rightTop.visible = false;
		}
		
		protected function bgMoveHandler(event:MouseEvent):void
		{
			var moveNumX:int = int(stage.stageWidth/2 - $dayBg.width/2) + (stage.stageWidth/2 - stage.mouseX) / 35;
			var moveNumY:int = int(stage.stageHeight/2 - $dayBg.height/2) + (stage.stageHeight/2 - stage.mouseY) / 35;
			TweenLite.killTweensOf($dayBg);
			TweenLite.to($dayBg, 0.8, {x:moveNumX, y:moveNumY});
		}
		
		//////////////////////////////////////////////////////////////////////
		
		private function unloadMainSWF():void
		{
			var num:int = $vcCover.numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				var mc:Loader = Loader($vcCover.getChildAt(0));
				$vcCover.removeChild(mc);
				mc.unloadAndStop();
				mc=null;
			}
		}
		
		protected function onResize(event:Event=null):void
		{
			_model.sw = stage.stageWidth;
			_model.sh = stage.stageHeight;
			
			if(_model.sh < 850) _model.sh = 850;
			if(_model.sw < 1280) _model.sw = 1280;
			
			if($commonPlayer){
				$commonPlayer.width = _model.sw;
				$commonPlayer.height = _model.sh;
				$commonPlayer.scaleX = $commonPlayer.scaleY = Math.max($commonPlayer.scaleX, $commonPlayer.scaleY);
				_model.objW = int($commonPlayer.width);			
				_model.objH = int($commonPlayer.height);	
			}
			
			if($introSkip){
				$introSkip.x = int(_model.sw - $introSkip.width) + 145;
				$introSkip.y = int(_model.sh - $introSkip.height) + 180;
			}
			
			if($dayBg){
				TweenLite.killTweensOf($dayBg)
				$dayBg.width = int(_model.objW) + 60;			
				$dayBg.height = int(_model.objH) + 60;
				
				$dayBg.x = int((_model.sw - $dayBg.width)/2);
				$dayBg.y = int((_model.sh - $dayBg.height)/2);
				
				$rightTop.x = int(_model.sw - $rightTop.width);
			}
			
			if(stage){
				$viewLoading.loadingResize(stage);
			}
			if($popBg){
				$popBg.width = _model.sw;
				$popBg.height = _model.sh;
			}
			
		}
	}
}