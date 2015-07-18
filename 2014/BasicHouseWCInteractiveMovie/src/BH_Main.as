package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.StringUtil;
	import com.bh.events.BhEvent;
	import com.bh.main.Main;
	import com.bh.model.Model;
	import com.bh.player.MainFlvPlayer;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	[SWF(width="1280", height="720", frameRate="30", backgroundColor="0x888888")]
	
	public class BH_Main extends Sprite
	{
		private var _assetMain:AssetMain;
		private var _model:Model = Model.getInstance();
		
		private var _main:Main;
		private var _mainFlvPlayer:MainFlvPlayer;
		
		public function BH_Main()
		{
			Security.allowDomain('*');
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{
//				_model.commonPath = SecurityUtil.getPath(this);
				_model.userDataPath = _model.commonPath + "xml/user_list.xml"
//				if(StringUtil.ereg(_model.commonPath, "adqua", "g")) _model.userDataPath = "http://basichouse.adqua.co.kr/process/CheerMovieMainList.ashx";
//				else _model.userDataPath = "http://www.basichousecheer.co.kr/process/CheerMovieMainList.ashx"
			}
			else
			{
				_model.commonPath = "";
				_model.userDataPath = "xml/user_list.xml"
//				_model.userDataPath = "http://basichouse.adqua.co.kr/process/CheerMovieMainList.ashx"
			}
			
			_assetMain = new AssetMain();
			this.addChild(_assetMain);
			
			_main = new Main(_assetMain);
			_mainFlvPlayer = new MainFlvPlayer(_assetMain.scene);
			
			userDataLoad();
			if(ExternalInterface.available) ExternalInterface.addCallback("playFullVideo", playFullVideo);
			if(ExternalInterface.available) ExternalInterface.addCallback("resumeVideo", resumeVideo);
			
//			setTimeout(playFullVideo, 3000, 2, "view");
		}
		
		private function playFullVideo(index:int, type:String=""):void
		{
			if(type == "start") _model.myMovieOpen = true;
			if(type == "view") _model.galleryOpen = true;
			if(type == "scrap") _model.scrap = true;
			_model.loop = false;
			_model.hideUI = true;
			
			_model.fullVideoEnd = false;
			
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.idx = index;
			
			var req:URLRequest = new URLRequest(_model.userDataPath);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var ldr:URLLoader = new URLLoader();
			ldr.load(req);
			ldr.addEventListener(Event.COMPLETE, makeMoviePlay);
		}
		
		private function resumeVideo():void
		{
			_model.nowPlay = false;
			_model.dispatchEvent(new BhEvent(BhEvent.CONTENTS_INMOTION));
			_model.dispatchEvent(new BhEvent(BhEvent.RESUME_VIDEO));
			_model.dispatchEvent(new BhEvent(BhEvent.HIDE_MOVIE_COVER));
		}
		
		private function makeMoviePlay(e:Event):void
		{
			trace(XML(e.target.data));
			var xml:XML = new XML(e.target.data);
			
			for (var i:int = 0; i < _model.cardSectionArr.length; i++) 
			{	_model.cardSectionArr[i] = null;	}
			_model.cardSectionArr.length = 0;
			
			for (var j:int = 0; j < xml.user.msg.length(); j++) 
			{	_model.cardSectionArr[j] = xml.user.msg[j];		}
			
			_model.toName = xml.user.@toName;
			_model.fromName = xml.user.@fromName;
			_model.imgUrl = _model.commonPath + xml.user.@imgUrl;
			_model.fullVideo = true;
//			_model.fullCardsection = true;
			_model.sceneNum = 0;
//			JavaScriptUtil.alert(_model.toName + _model.fromName + _model.cardSectionArr[0]);
			_model.dispatchEvent(new BhEvent(BhEvent.FINISH_CARDSECTION));
			_model.dispatchEvent(new BhEvent(BhEvent.PLAY_FULL_VIDEO));
			_model.dispatchEvent(new BhEvent(BhEvent.INIT_MAIN_INPUT));
			_model.dispatchEvent(new BhEvent(BhEvent.HIDE_MOVIE_COVER));
			
			if(!_model.scrap) JavaScriptUtil.call("likeBoxHide");
		}
		
		public function scrapMoviePlay(idx:int):void
		{
			playFullVideo(idx, "scrap");
			trace("영상으로 시작_______!!  ", idx);
			
			JavaScriptUtil.call("likeBoxHide");
		}
		
		public function mainContentStart():void
		{
			_model.dispatchEvent(new BhEvent(BhEvent.MAIN_CONTENTS_START));
			trace("메인 컨텐츠 시작______________!!!");
		}
		
		/**	유저 정보 가져오기	*/
		private function userDataLoad():void
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			
			var req:URLRequest = new URLRequest(_model.userDataPath);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var ldr:URLLoader = new URLLoader();
			ldr.load(req);
			ldr.addEventListener(Event.COMPLETE, resultLoadComplete);
		}
		/**	유저 정보 받기	*/
		private function resultLoadComplete(e:Event):void
		{
			_model.userXml = new XML(e.target.data);
			_model.userLength = _model.userXml.user.length();
			trace(_model.userXml, _model.userLength);
		}
	}
}