package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.control.SoundControll;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	import com.lol.view.LoadingBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.ui.Mouse;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[SWF(width="1280", height="720", frameRate="30", backgroundColor="0x888888")]
	
	public class Index extends Sprite
	{
		
		private var _main:AssetIndex;
		private var _model:Model = Model.getInstance();
		private var _snd:SoundControll;
		private var _loadingBar:LoadingBar;
		private var _swfName:String;
		
		private var _loader:Loader;
		private var _listLoadComplete:Boolean = false;
		
		public function Index()
		{
			TweenPlugin.activate([AutoAlphaPlugin, FramePlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
//			Security.allowDomain('leagueoflegends.co.kr');
			Security.allowDomain('*');
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb()) _model.commonPath = SecurityUtil.getPath(this);
			else _model.commonPath = "";
			
			_main = new AssetIndex();
			this.addChild(_main);
			_loadingBar = new LoadingBar(_main);
			_snd = new SoundControll();
			
			_main.loaderCon.visible = false;
			
			Mouse.hide();
			_main.pointer.mouseEnabled = false;
			_main.pointer.mouseChildren = false;
			
			var flashParams:Object = LoaderInfo(root.loaderInfo).parameters;
			
			if(flashParams.ver == "kor" || flashParams.ver == "eng"){
				if(flashParams.ver == "kor") _model.verEng = false;
				else if(flashParams.ver == "eng") _model.verEng = true;
				_main.introCon.visible = false;
				xmlLoad();
			}else{
				_main.introCon.popup.btn1.gotoAndStop(2);
				TweenLite.to(_main.introCon, 1, {alpha:1, ease:Cubic.easeOut});
				initMouseEventListener();
			}
			
			initEeventListener();
		}
		
		private function initEeventListener():void
		{
			if(ExternalInterface.available) ExternalInterface.addCallback("videoPause", videoPause);
			if(ExternalInterface.available) ExternalInterface.addCallback("videoResume", videoResume);
			
			_model.addEventListener(LolEvent.VOLUME_CHANGE, volumeChange);
			
			_main.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_main.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave);
			
			stageResizeHandler();
			_main.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		private function initMouseEventListener():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip = _main.introCon.popup.getChildByName("btn" + i) as MovieClip;
				btn.no = i
				ButtonUtil.makeButton(btn, btnHandler);
			}
			ButtonUtil.makeButton(_main.introCon.popup.btn2, btnStartHandler);
		}
		
		protected function videoPause():void
		{
			_model.isVideoPause = true;
			if(_model.isPopup || _model.isInterPopup || _model.isReactionPopup) _model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PAUSE));
		}
		
		protected function videoResume():void
		{
			_model.isVideoPause = false;
			if(_model.isPopup || _model.isInterPopup || _model.isReactionPopup) _model.dispatchEvent(new LolEvent(LolEvent.TIMER_START));
			if(!_model.isReactionPopup) _model.dispatchEvent(new LolEvent(LolEvent.VIDEO_RESUME));
		}
		
		protected function volumeChange(e:LolEvent):void
		{
			this.soundTransform = _model.totalVolume;
		}
		
		private function mouseLeave(e:Event):void
		{			TweenLite.to(_main.pointer, 0.5, {alpha:0});		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			if(_main.pointer.alpha == 0) TweenLite.to(_main.pointer, 0.5, {alpha:1});
			Mouse.hide();
			TweenLite.to(_main.pointer, 0.25, {x: _main.mouseX, y: _main.mouseY, ease:Cubic.easeOut});
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : target.over.alpha = 0.5; break;
				case MouseEvent.MOUSE_OUT : target.over.alpha = 0; break;
				case MouseEvent.CLICK :
					if(target.no == 1){
						_main.introCon.popup.gotoAndStop(1);
						_main.introCon.popup.btn1.gotoAndStop(2);
						_main.introCon.popup.btn0.gotoAndStop(1);
						_main.introCon.popup.startMc.introTxt.gotoAndStop(1);
						_model.verEng = false;
					}else{
						_main.introCon.popup.gotoAndStop(2);
						_main.introCon.popup.btn1.gotoAndStop(1);
						_main.introCon.popup.btn0.gotoAndStop(2);
						_main.introCon.popup.startMc.introTxt.gotoAndStop(2);
						_model.verEng = true;
					}
					break;
			}
		}
		
		private function btnStartHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : TweenLite.to(_main.introCon.popup.startMc, 0.75, {frame:15}); break;
				case MouseEvent.MOUSE_OUT : TweenLite.to(_main.introCon.popup.startMc, 0.75, {frame:1}); break;
				case MouseEvent.CLICK :	outMotion(); break;
			}
		}
		
		private function outMotion():void
		{
			/**	트래킹	*/
			if(_model.verEng == false) JavaScriptUtil.call("sendTracking", "5");
			else JavaScriptUtil.call("sendTracking", "E5");
			
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip = _main.introCon.popup.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btn, btnHandler);
			}
			ButtonUtil.removeButton(_main.introCon.popup.btn2, btnStartHandler);
			
			TweenLite.killTweensOf(_main.introCon.popup.startMc);
			_main.introCon.popup.startMc.gotoAndStop(15);
			TweenLite.to(_main.introCon.popup.startMc, 0.75, {frame:_main.introCon.popup.startMc.totalFrames, onComplete:xmlLoad});
		}
		
		private function xmlLoad():void
		{
			var xmlPath:String;
			if(_model.verEng){
				_swfName = "Eng_LOL_Main.swf";
//				xmlPath = "xml/EngMovieList.xml";
				xmlPath = "xml/KorMovieList.xml";
				_model.userName = "HonoredPlayer";
				_model.rankName = "WeLoveRankedTeam";
			}else{
				_swfName = "Kor_LOL_Main.swf";
				xmlPath = "xml/KorMovieList.xml";
				_model.userName = "명예로운유저";
				_model.rankName = "팀랭크가좋아";
			}
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest(_model.commonPath + xmlPath));
			urlLdr.addEventListener(IOErrorEvent.IO_ERROR, movieListLoadError);
			urlLdr.addEventListener(Event.COMPLETE, movieListLoadComplete);
			
			trace("로드 플래시 ____>  " + _swfName, xmlPath);
		}
		
		private function movieListLoadError(e:IOErrorEvent):void
		{
			JavaScriptUtil.alert("영상 리스트 로드 에러_!!  " + e.text);
		}
		
		private function movieListLoadComplete(e:Event):void
		{
			_model.videoList = XML(e.target.data);
			mainLoad();
		}
		
		private function mainLoad():void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.SHOW_LOADING_BAR));
			_loader = new Loader();
			_loader.load(new URLRequest(_model.commonPath + _swfName));
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoadComplete);
			_main.container.addChild(_loader);
		}
		
		private function mainLoadProgress(e:ProgressEvent):void
		{
			_model.loadPercent = e.target.bytesLoaded / e.target.bytesTotal;
			_model.dispatchEvent(new LolEvent(LolEvent.LOADING_PROGRESS));
		}
		
		private function mainLoadComplete(e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, mainLoadComplete);
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_LOADING_BAR));
			TweenLite.to(_main.introCon, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			TweenLite.to(_main.container, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			
			_main.introCon.popup.startMc.stop();
			_main.introCon.popup.txtCon.light0.stop();
			_main.introCon.popup.txtCon.light1.stop();
		}
		
		private function stageResizeHandler(e:Event = null):void
		{
			var stageWidth:Number;
			var stageHeight:Number;
			if(_main.stage.stageWidth > 1024)
			{
				stageWidth = _main.stage.stageWidth;
				_main.introCon.intro.width = int(_main.stage.stageWidth);
			}
			else
			{
				stageWidth = 1024;
				_main.introCon.intro.width = 1024;
			}
			if(_main.stage.stageHeight > 600)
			{
				stageHeight = _main.stage.stageHeight;
				_main.introCon.intro.height = int(_main.stage.stageHeight);
			}
			else
			{
				stageHeight = 600;
				_main.introCon.intro.height = 600;
			}
			_main.introCon.intro.scaleX = _main.introCon.intro.scaleY = Math.max(_main.introCon.intro.scaleX, _main.introCon.intro.scaleY);
			_main.introCon.intro.x = int(stageWidth/2 - _main.introCon.intro.width/2);
			_main.introCon.intro.y = int(stageHeight/2 - _main.introCon.intro.height/2);
			
			_main.introCon.popup.x = int(_main.stage.stageWidth/2 - 400);
			_main.introCon.popup.y = int(_main.stage.stageHeight/2 - 225);
			
			_main.loaderCon.dimmed.width = _main.stage.stageWidth;
			_main.loaderCon.dimmed.height = _main.stage.stageHeight;
		}
	}
}