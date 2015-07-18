package com.lol.player
{
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.lol.control.SwfTextSetting;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SwfPlayer
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _movMC:MovieClip;
		private var _swfTextSetting:SwfTextSetting;
		
		/**	팝업9 변수	*/
		private var _btn0Chk:int
		private var _btn1Chk:int
		private var _btn2Chk:int
		private var _arrayTxt:Array = [];
		private var _txtTimeout:uint;
		private var _combiTxt:MovieClip;
		private var _isSelect:Boolean = false;
		
		public function SwfPlayer($container:MovieClip)
		{
			_con = $container;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			_swfTextSetting = new SwfTextSetting();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.SELECT_TEAM_COMBINATION, teamCombinationEvent);
			_model.addEventListener(LolEvent.REMOVE_SWF_VIDEO, unloadSwf);
			_model.addEventListener(LolEvent.SWF_VIDEO_PLAY, load);
			_model.addEventListener(LolEvent.VIDEO_PAUSE, videoPause);
			_model.addEventListener(LolEvent.VIDEO_RESUME, videoResume);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
//			/**	테스트용	*/
//			_con.stage.addEventListener(KeyboardEvent.KEY_DOWN, skipVideo);
		}
//		protected function skipVideo(e:KeyboardEvent):void
//		{
//			if(_model.videoType != "swf" || _movMC == null) return;
//			if(e.keyCode == 32) _movMC.gotoAndPlay(_movMC.totalFrames - 60);
//		}
		
		protected function videoPause(e:LolEvent):void
		{		pauseSwfMovie();		}
		
		private function pauseSwfMovie():void
		{
			if(_movMC != null){
				_movMC.removeEventListener(Event.ENTER_FRAME, motionFrameChk);
				_movMC.stop();
				if(_model.videoNum == 18 && _isSelect){
					_con.removeEventListener(Event.ENTER_FRAME, endFrameChk);
					_combiTxt.stop();
				}
				if(_model.videoNum == 20){
					_movMC.rankName.stop();
					_movMC.rankName.txtMc.stop();
				}
			}
		}
		
		protected function videoResume(e:LolEvent):void
		{		resumeSwfMovie();		}
		
		private function resumeSwfMovie():void
		{
			if(_movMC != null){
				if(_movMC.currentFrame != _movMC.totalFrames){
					_movMC.addEventListener(Event.ENTER_FRAME, motionFrameChk);
					_movMC.play();
				}
				
				if(_model.videoNum == 18 && _isSelect){
					_con.addEventListener(Event.ENTER_FRAME, endFrameChk);
					_combiTxt.play();
				}
				
				if(_model.videoNum == 20){
					_movMC.rankName.play();
					_movMC.rankName.txtMc.play();
				}
			}
		}
		
		protected function unloadSwf(e:LolEvent):void
		{		unload();		}
		
		protected function load(e:LolEvent):void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.SHOW_LOADING_BAR));
			
			_talkPopupShow = true;
			
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(_model.videoPath));
			_con.swfCon.addChild(ldr);
			_model.loadPercent = 0;
			ldr.contentLoaderInfo.addEventListener(Event.INIT, initLoad);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadComplete);
		}
		
		private function initLoad(e:Event):void
		{
			var mc:MovieClip = e.target.content as MovieClip;
			mc.stop();
			
			if(_model.videoNum == 18){
				_btn0Chk = 0;
				_btn1Chk = 0;
				_btn2Chk = 0;
				_arrayTxt.length = 0;
			}
		}
		
		private function progressHandler(e:ProgressEvent):void
		{
			var loadPercent:Number = e.target.bytesLoaded / e.target.bytesTotal;
			_model.loadPercent = loadPercent;
			_model.dispatchEvent(new LolEvent(LolEvent.LOADING_PROGRESS));
		}
		
		private function loadError(e:IOErrorEvent):void
		{
			JavaScriptUtil.alert(e.text);
		}
		
		private function swfLoadComplete(e:Event):void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_LOADING_BAR));
			e.target.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			e.target.removeEventListener(Event.COMPLETE, swfLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			_movMC = e.target.content as MovieClip;
			
			_model.dispatchEvent(new LolEvent(LolEvent.REMOVE_COVER));
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_OFF));
			_swfTextSetting.swfTxtSetting(_movMC);
			resizeHandler();
			
			if(_model.isVideoPause) pauseSwfMovie();
			else resumeSwfMovie();
		}
		
		private var _talkPopupShow:Boolean = true;
		private function motionFrameChk(e:Event):void
		{
			if(_model.videoNum == 4 && _movMC.currentFrame >= 290 && _talkPopupShow){
				pauseSwfMovie();
				_model.talkPopupNum = 1;
				showTalkPopup();
			}else if(_model.videoNum == 10 && _movMC.currentFrame >= 205 && _talkPopupShow){
				_model.talkPopupNum = 11;
				showTalkPopup();
			}else if(_model.videoNum == 28 && _movMC.currentFrame >= 190 && _talkPopupShow){
				_model.talkPopupNum = 20;
				showTalkPopup();
			}
			
			if(_movMC.currentFrame == _movMC.totalFrames){
				_movMC.removeEventListener(Event.ENTER_FRAME, motionFrameChk);
				if(_model.videoNum != 18) motionEnd();
				else _model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
			}
		}
		
		private function showTalkPopup():void
		{
			_talkPopupShow = false;
			_model.dispatchEvent(new LolEvent(LolEvent.SHOW_TALK_POPUP));
		}
		
		private function motionEnd():void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
			unload();
			
			if(_model.popupType == "popup"){
				trace("팝업_______________!!!    " + _model.popupType + _model.popupNum);
				_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
			}else if(_model.popupType == "inter"){
				trace("인터랙션 팝업_______________!!!    " + _model.popupType + _model.interPopupNum);
				_model.dispatchEvent(new LolEvent(LolEvent.INTERACTION_POPUP_OPEN));
			}else{
				trace("SWF 영상 종료___> 다음 영상 플레이______________!");
				_model.videoNum = int(_model.videoList.interaction.mov[_model.videoNum].@videoNum) + 1;
				_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
			}
		}
		
		/**	팝업 9 - 팀 채팅 조합 함수	*/
		public function teamCombinationEvent(e:LolEvent):void
		{
			trace(_model.combiNum, _btn0Chk, _movMC);
			_isSelect = true;
			if(_model.combiNum == 0){
				if(_btn0Chk >= 2) _btn0Chk = 2;
				_combiTxt = _movMC.loadCon.getChildByName("txt0_" + _btn0Chk) as MovieClip;
				_btn0Chk++;
			}else if(_model.combiNum == 1){
				if(_btn1Chk >= 2) _btn1Chk = 2;
				_combiTxt = _movMC.loadCon.getChildByName("txt1_" + _btn1Chk) as MovieClip;
				_btn1Chk++;
			}else if(_model.combiNum == 2){
				if(_btn2Chk >= 2) _btn2Chk = 2;
				_combiTxt = _movMC.loadCon.getChildByName("txt2_" + _btn2Chk) as MovieClip;
				_btn2Chk++;
			}else if(_model.combiNum == 3){
				_combiTxt = _movMC.loadCon.getChildByName("txt3") as MovieClip;
			}
			
			var sameTxt:Boolean = false;
			for (var j:int = 0; j < _arrayTxt.length; j++) 
			{			if(_arrayTxt[j] == _combiTxt) sameTxt = true;			}
			if(sameTxt == false) _arrayTxt.push(_combiTxt);
			
			var showTxtHeight:int;
			if(_arrayTxt.length == 1){
				_combiTxt.y = 0;
			}else {
				for (var i:int = 0; i < _arrayTxt.length; i++) 
				{			showTxtHeight = showTxtHeight + _arrayTxt[i].height;				}
				_combiTxt.y = showTxtHeight - _combiTxt.height;
			}
			
			if(showTxtHeight >= 125) _movMC.loadCon.y = 340 +125-showTxtHeight; 
			_combiTxt.play();
			_con.addEventListener(Event.ENTER_FRAME, endFrameChk);
		}
		private function endFrameChk(e:Event):void
		{
			if(_arrayTxt[_arrayTxt.length-1].currentFrame == _arrayTxt[_arrayTxt.length-1].totalFrames){
				_isSelect = false;
				_con.removeEventListener(Event.ENTER_FRAME, endFrameChk);
				clearTimeout(_txtTimeout);
				if(_model.combiNum == 3){
					_txtTimeout = setTimeout(nextVideoPlay, 2000);
				}else{
					_txtTimeout = setTimeout(popupReOpen, 2000);
				}
			}
		}
		private function nextVideoPlay():void
		{
			_model.isPopup = false;
			_model.videoNum = _model.videoList.interaction.mov[19].@videoNum;
			_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[21].@videoPath;
			_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
		}
		private function popupReOpen():void
		{		_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));		}
		
		public function unload():void
		{
			_movMC = null;
			while(_con.swfCon.numChildren > 0)
			{
				var ldr:Loader = _con.swfCon.getChildAt(0) as Loader;
				_con.swfCon.removeChild(ldr);
				ldr.unloadAndStop();
				ldr = null;
			}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			var stageWidth:Number;
			var stageHeight:Number;
			if(_con.stage.stageWidth > 1024)
			{
				stageWidth = _con.stage.stageWidth;
				_con.swfCon.width = int(_con.stage.stageWidth);
			}
			else
			{
				stageWidth = 1024;
				_con.swfCon.width = 1024;
			}
			if(_con.stage.stageHeight > 600)
			{
				stageHeight = _con.stage.stageHeight;
				_con.swfCon.height = int(_con.stage.stageHeight);
			}
			else
			{
				stageHeight = 600;
				_con.swfCon.height = 600;
			}
			_con.swfCon.scaleX = _con.swfCon.scaleY = Math.max(_con.swfCon.scaleX, _con.swfCon.scaleY);
			_con.swfCon.x = int(stageWidth/2 - _con.swfCon.width/2);
			_con.swfCon.y = int(stageHeight/2 - _con.swfCon.height/2);
		}
	}
}