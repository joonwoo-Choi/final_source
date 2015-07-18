package com.lol.view
{
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class TalkPopup
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _popupTimeout:uint;
		private var _popupMC:MovieClip;
		private var _leftPopupNum:Array = [2,4,6,7,10,14,15,16];
		private var _isTweening:Boolean = false;
		private var _isShow:Boolean = false;
		
		public function TalkPopup(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin]);
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.SHOW_TALK_POPUP, showTalkPopup);
			_model.addEventListener(LolEvent.HIDE_TALK_POPUP, hideTalkPopup);
			
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		protected function showTalkPopup(e:LolEvent):void
		{
			if(_model.isReactionPopup) return;
			trace("******************   토크팝업 보이기   ******************");
			_isShow = true;
			
			for (var i:int = 0; i < _leftPopupNum.length; i++) 
			{
				if(_leftPopupNum[i] == _model.talkPopupNum){
					_popupMC = _con.talkPopup2;
					break;
				}else{
					_popupMC = _con.talkPopup;
				}
			}
			_popupMC.visible = true;
			_popupMC.gotoAndStop(_model.talkPopupNum + 1);
			sizeChk();
			_popupMC.popCon.popup.gotoAndStop(1);
			
			_isTweening = true;
			
			TweenLite.to(_popupMC.popCon.popup, 0.75, {frame:_popupMC.popCon.popup.totalFrames, onComplete:showMotionEnd, ease:Cubic.easeOut});
			clearTimeout(_popupTimeout);
			if(_model.talkPopupNum == 0 || _model.talkPopupNum == 17) _popupTimeout = setTimeout(hideTalkPopup, 4500);
			else if(_model.talkPopupNum == 11) _popupTimeout = setTimeout(hideTalkPopup, 3500);
			else _popupTimeout = setTimeout(hideTalkPopup, 6500);
			
			if(_popupMC.currentFrame == 2) _popupMC.popCon.popup.btn.addEventListener(MouseEvent.CLICK, closeTalkPopup);
		}
		
		private function showMotionEnd():void
		{
			_isTweening = false;
			sizeChk();
		}
		
		private function closeTalkPopup(e:MouseEvent):void
		{		hideTalkPopup();		}
		
		protected function hideTalkPopup(e:LolEvent = null):void
		{
			trace("******************   토크팝업 숨기기   ******************");
			if(_popupMC == null) return;
			_isShow = false;
			_isTweening = true;
			
			if(_popupMC.currentFrame == 2){
				_popupMC.popCon.popup.btn.removeEventListener(MouseEvent.CLICK, closeTalkPopup);
				_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_RESUME));
			}
			clearTimeout(_popupTimeout);
			
			if(_model.talkPopupNum > 0) TweenLite.to(_popupMC.popCon.popup, 0.75, {frame:1, onComplete:hideComplete, ease:Cubic.easeOut});
		}
		
		private function hideComplete():void
		{
			_isTweening = false;
			_popupMC.visible = false;
		}
		
		private function sizeChk():void
		{
			if(!_isShow || _isTweening) return;
			
			var currentFrame:int;
			if(_con.stage.stageWidth <= 1280){
				if(_popupMC.popCon.currentFrame == 2) return;
				
				if(_popupMC.currentFrame == 2) _popupMC.popCon.popup.btn.removeEventListener(MouseEvent.CLICK, closeTalkPopup);
				currentFrame = _popupMC.popCon.popup.currentFrame;
				_popupMC.popCon.gotoAndStop(2);
				_popupMC.popCon.popup.gotoAndStop(currentFrame);
				if(_popupMC.currentFrame == 2) _popupMC.popCon.popup.btn.addEventListener(MouseEvent.CLICK, closeTalkPopup);
			}else{
				if(_popupMC.popCon.currentFrame == 1) return;
				
				if(_popupMC.currentFrame == 2) _popupMC.popCon.popup.btn.removeEventListener(MouseEvent.CLICK, closeTalkPopup);
				currentFrame = _popupMC.popCon.popup.currentFrame;
				_popupMC.popCon.gotoAndStop(1);
				_popupMC.popCon.popup.gotoAndStop(currentFrame);
				if(_popupMC.currentFrame == 2) _popupMC.popCon.popup.btn.addEventListener(MouseEvent.CLICK, closeTalkPopup);
			}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.talkPopup.y = int(_con.stage.stageHeight/10);
			_con.talkPopup.x = _con.stage.stageWidth - 478;
			
			_con.talkPopup2.y = int(_con.stage.stageHeight/10);
			
			sizeChk();
		}
	}
}