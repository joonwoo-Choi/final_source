package com.lol.view
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class QuickMenu
	{
		private var _con:MovieClip;
		protected var _model:Model;
		private var $quickCount:int = 5;
		private var $qCon:MovieClip;
		private var $barArray:Array = [30,152,273,393,515];
		private var $yelloArray:Array = [-503,-381,-260,-140,-20];
		private var $id:uint;
		private var _tempQuickNum:int;
		
		private var _menuTimeout:uint;
		private var _currentNum:int;
		
		public function QuickMenu(con:MovieClip)
		{
			_con = con;
			trace("quickMenu");
			TweenPlugin.activate([AutoAlphaPlugin, FramePlugin]);
			_model = Model.getInstance();
			
			init();
			initEventListener();
		}
		
		protected function init():void
		{
			_con.y = 818;
			_con.gotoAndPlay(2);
			
			//menu셋팅
			menuSetting();
			//bar셋팅
			quickBarSetting();
			
//			resizeHandler();
			_con.y = _con.stage.stageHeight+100;
			_con.x = int(_con.stage.stageWidth/2 - _con.width/2);
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.REICIVE_QUICK_NUM, reiciveQuickBarSetting);
			_model.addEventListener(LolEvent.HIDE_QUICK_MENU, hideMenu);
			_model.addEventListener(LolEvent.VIDEO_PLAY, videoPlay);
			
			_con.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_con.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			ButtonUtil.makeButton(_con.btnSnd, volumeChk);
			ButtonUtil.makeButton(_con.btnHome, goHome);
			for (var i:int = 0; i < 2; i++) 
			{
				_con.btnLan["btn" + i].no = i;
				ButtonUtil.makeButton(_con.btnLan["btn" + i], languageChange);
			}
		}
		
		protected function reiciveQuickBarSetting(e:LolEvent):void 
		{
			quickBarSetting()
		}
		
		protected function hideMenu(e:LolEvent):void
		{
			_model.quickMenuShow = false;
			hideQuickMenu();
		}
		
		protected function videoPlay(e:LolEvent):void
		{
			_model.quickMenuShow = true;
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if(_model.quickMenuShow == false) return;
			if(_con.stage.mouseY >= _con.stage.stageHeight - 125){
				clearTimeout(_menuTimeout);
				showQuickMenu();
			}else{
				clearTimeout(_menuTimeout);
				_menuTimeout = setTimeout(hideQuickMenu, 1000);
			}
		}
		
		protected function mouseLeaveHandler(e:Event):void
		{
			if(_model.quickMenuShow) hideQuickMenu();
		}
		
		private function showQuickMenu():void
		{
			TweenLite.to(_con, 1, {y:_con.stage.stageHeight-51, ease:Cubic.easeOut});
		}
		private function hideQuickMenu():void
		{
			TweenLite.to(_con, 0.75, {y:_con.stage.stageHeight+60, ease:Cubic.easeOut});
		}
		
		private function volumeChk(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					target.ss.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target.ss.gotoAndStop(1);
					break;
				case MouseEvent.CLICK :
					if(_con.btnSnd.currentFrame == 1)
					{
						_model.totalVolume.volume = 0;
						_con.btnSnd.gotoAndStop(2);
					}
					else
					{
						_model.totalVolume.volume = 1;
						_con.btnSnd.gotoAndStop(1);
					}
					_model.dispatchEvent(new LolEvent(LolEvent.VOLUME_CHANGE));
					
					break;
			}
		}
		
		private function goHome(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					target.ss.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target.ss.gotoAndStop(1);
					break;
				case MouseEvent.CLICK :
					JavaScriptUtil.call("back");
					break;
			}
		}
		
		private function languageChange(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					target.ss.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target.ss.gotoAndStop(1);
					break;
				case MouseEvent.CLICK :
					if(_model.verEng){
						if(target.no == 0) return;
						JavaScriptUtil.call("videoLang", "kor");
					}else{
						if(target.no == 1) return;
						JavaScriptUtil.call("videoLang", "eng");
					}
					trace("언어 설정 변경___>>   " + target.no);
					break;
			}
		}
		
		private function quickBarSetting():void
		{
			quickMov(_model.quickNum);
			barMov(_model.quickNum);
		}
		
		//퀵메뉴 셋팅
		private function menuSetting():void
		{
			for (var i:int = 0; i < $quickCount; i++) 
			{
				$qCon = _con["q"+i];
				$qCon.buttonMode = true;
				$qCon.mouseChildren = false;
				$qCon.id = i;
				$qCon.addEventListener(MouseEvent.ROLL_OVER, quickOver);
				$qCon.addEventListener(MouseEvent.ROLL_OUT, quickOut);
				$qCon.addEventListener(MouseEvent.CLICK, quickClick);
			}
			
			_con.seekBar.buttonMode = true;
			_con.seekBar.addEventListener(MouseEvent.MOUSE_OVER, btnHandler);
			_con.seekBar.addEventListener(MouseEvent.MOUSE_OUT, btnHandler);
			_con.seekBar.addEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			_con.seekBar.addEventListener(MouseEvent.MOUSE_UP, setResult);
		}
		
		//퀵메뉴 활성화
		private function quickMov($id:int):void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				$qCon = _con["q"+i];
				if(i == $id){
					TweenLite.to($qCon, 0.3,{frame:$qCon.totalFrames-1, easing:Linear.easeNone});
					
				}else{
					TweenLite.to($qCon, 0.3,{frame:1, easing:Linear.easeNone});
				}
			}
		}
		
		private function quickOver(e:MouseEvent):void
		{
			var curMc:MovieClip = e.currentTarget as MovieClip;
			var curId:int = curMc.id;
			clearTimeout($id);
			TweenLite.to(curMc, 0.3,{frame:curMc.totalFrames-1, easing:Linear.easeNone});
		}
		
		private function quickOut(e:MouseEvent):void
		{
			var curMc:MovieClip = e.currentTarget as MovieClip;
			var curId:int = curMc.id;
			$id = setTimeout(quickMov,500,_model.quickNum);
			quickMov(_model.quickNum);
		}
		
		//퀵메뉴 클릭
		private function quickClick(e:MouseEvent):void
		{
			var curMc:MovieClip = e.currentTarget as MovieClip;
			if(_model.isPanningVideo == true) return;
			if(_model.quickReClick == false) return;
			if(_model.quickNum == curMc.id) return;
			
			_model.quickReClick = false;
			_model.quickNum = curMc.id;
			
			quickMov(_model.quickNum);
			barMov(_model.quickNum);
			//영상플레이 함수
			showResultMovie(_model.quickNum);
			
			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_PANNING_BUTTON));
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					_con.seekBar.qbtn.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					_con.seekBar.qbtn.gotoAndStop(1);
					break;
				case MouseEvent.MOUSE_DOWN :
					frameChange();
					
					_con.stage.addEventListener(MouseEvent.MOUSE_MOVE, frameChange);
					_con.stage.addEventListener(MouseEvent.MOUSE_UP, setResult);
					break;
			}
		}
		
		private function frameChange(e:MouseEvent = null):void
		{
			var sunX:int;
			var sunMinX:int = _con.seekBar.area.x;
			var sunMaxX:int = _con.seekBar.area.width + _con.seekBar.area.x;
			
			sunX = _con.seekBar.mouseX;
			if(sunX <= sunMinX) sunX = sunMinX;
			else if(sunX >= sunMaxX) sunX = sunMaxX;
			_con.seekBar.qbtn.x = sunX;
			_con.seekBar.yellowBar.x = sunX-_con.seekBar.yellowBar.width;
		}
		
		private function setResult(e:MouseEvent):void
		{
			_con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameChange);
			_con.stage.removeEventListener(MouseEvent.MOUSE_UP, setResult);
			
			var seekX:int = _con.seekBar.qbtn.x;
			var tempQuickNum:int;
			
			if(seekX < 92 ){
				tempQuickNum = 0;
			}else if(seekX < 210 && seekX >= 92 ){
				tempQuickNum = 1;
			}else if(seekX < 332 && seekX >= 210){
				tempQuickNum = 2;
			}else if(seekX < 452 && seekX >= 332){
				tempQuickNum = 3;
			}else if(seekX < 515 ){
				tempQuickNum = 4;
			}
			
			if(_model.quickNum != tempQuickNum && !_model.isInterPopup && !_model.isPopup && _model.quickReClick)
			{
				_model.quickReClick = false;
				_model.quickNum = tempQuickNum;
			}
			
			TweenLite.to(_con.seekBar.qbtn, .3, {x:$barArray[_model.quickNum]});
			TweenLite.to(_con.seekBar.yellowBar, .3, {x:$yelloArray[_model.quickNum]});
			quickMov(_model.quickNum);
			
			if(_currentNum != _model.quickNum){
				
				//결과 무비로
				showResultMovie(_model.quickNum);
			}
			_currentNum = _model.quickNum;
			
		}
		
		private function barMov($id:int):void
		{
			TweenLite.to(_con.seekBar.qbtn, .3, {x:$barArray[_model.quickNum]});
			TweenLite.to(_con.seekBar.yellowBar, .3, {x:$yelloArray[_model.quickNum]});
		}
		
		//영상플레이 함수
		private function showResultMovie(num:int):void
		{
			_model.isPopup = true;
			if(num == 0){
				trace("영상 result : ", num);
				_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[1].@videoPath;
				_model.videoNum = _model.videoList.interaction.mov[1].@videoNum;
			}else if(num == 1){
				trace("영상 result : ", num);
				_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[11].@videoPath;
				_model.videoNum = _model.videoList.interaction.mov[11].@videoNum;
			}else if(num == 2){
				trace("영상 result : ", num);
				_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[16].@videoPath;
				_model.videoNum = _model.videoList.interaction.mov[16].@videoNum;
			}else if(num == 3){
				trace("영상 result : ", num);
				_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[23].@videoPath;
				_model.videoNum = _model.videoList.interaction.mov[23].@videoNum;
			}else if(num == 4){
				trace("영상 result : ", num);
				_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[29].@videoPath;
				_model.videoNum = _model.videoList.interaction.mov[29].@videoNum;
			}
			_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_TALK_POPUP));
			_model.dispatchEvent(new LolEvent(LolEvent.REMOVE_SWF_VIDEO));
			_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_CLOSE));
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.x = int(_con.stage.stageWidth/2 - _con.width/2);
			if(_model.quickMenuShow) TweenLite.to(_con, 0.75, {y:_con.stage.stageHeight-51, ease:Cubic.easeOut});
			else _con.y = _con.stage.stageHeight+60;
		}
	}
}