package com.lol.view
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	public class InteractionPopup
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _popupLength:int;
		private var _popupArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var _blockBtn:Boolean = true;
		
		public function InteractionPopup(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, AutoAlphaPlugin]);
			_popupLength = _con.interPopup.numChildren - 1;
			for (var i:int = 0; i < _popupLength; i++) 
			{
				trace(i);
				var popup:MovieClip = _con.interPopup.getChildByName("popup" + i) as MovieClip;
				popup.no = i;
				_popupArr.push(popup);
			}
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.INTERACTION_POPUP_OPEN, showPopup);
			_model.addEventListener(LolEvent.INTERACTION_POPUP_CLOSE, closeInteractivePopup);
			
			/**	팝업 0 이벤트 등록	*/
			ButtonUtil.makeButton(_con.interPopup.popup0.target, popup0BtnHandler);
			_con.interPopup.popup0.frame.stop();
			
			/**	팝업 1 이벤트 등록	*/
			_con.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			ButtonUtil.makeButton(_con.interPopup.popup1.hh, popup1BtnHandler);
			
			/**	팝업 2 이벤트 등록	*/
			for (var i:int = 0; i < 3; i++) 
			{
				var btn:MovieClip = _con.interPopup.popup2.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popup2BtnHandler);
			}
			
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		protected function showPopup(e:LolEvent):void
		{
			if(_model.isReactionPopup) return;
			trace("인터랙션 팝업 오픈 ==> " + _model.interPopupNum);
			_blockBtn = false;
			_model.isInterPopup = true;
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_QUICK_MENU));
			for (var i:int = 0; i < _popupLength; i++) 
			{
				if(i == _model.interPopupNum)
				{
					_popupArr[i].gotoAndStop(1);
					_popupArr[i].alpha = 1;
					_popupArr[i].visible = true;
				}
				else
				{
					_popupArr[i].alpha = 0;
					_popupArr[i].visible = false;
				}
			}
			_con.interPopup.visible = true;
//			_con.interPopup.dimmed.visible = true;
			_con.interPopup.dimmed.visible = false;
			
			if(_model.interPopupNum == 0){
				_con.interPopup.popup0.target.gotoAndStop(1);
				_con.interPopup.popup0.frame.play();
			}
			if(_model.interPopupNum == 1){
				_con.interPopup.popup1.vcon.vSuccess.gotoAndStop(1);
			}
			
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_ON));
			_popupArr[_model.interPopupNum].play();
			_con.addEventListener(Event.ENTER_FRAME, frameEndChk);
			resizeHandler();
		}
		/**	등장모션 종료 체크	*/
		private function frameEndChk(e:Event):void
		{
			if(_popupArr[_model.interPopupNum].currentFrame == _popupArr[_model.interPopupNum].totalFrames-2)
			{
				_con.interPopup.dimmed.visible = false;
				_con.removeEventListener(Event.ENTER_FRAME, frameEndChk);
			}
		}
		
		/**
		 * 팝업 0 이벤트 *********************************************************
		 * */
		private function popup0BtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type) 
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					TweenLite.to(_con.interPopup.popup0.target, 1, {frame:_con.interPopup.popup0.target.totalFrames, onComplete:hidePopup});
					break;
			}
		}
		
		/**
		 * 팝업 1 이벤트 *********************************************************
		 * */
		private function keyDownHandler(e:KeyboardEvent):void
		{
//			trace(e.keyCode);
			if(_model.interPopupNum != 1) return;
			if(_blockBtn) return;
			if(e.keyCode == 86 || e.keyCode == 229) popup1OutMotion();
		}
		
		private function popup1BtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type) 
			{
				case MouseEvent.MOUSE_OVER : target.gotoAndStop(2); break;
				case MouseEvent.MOUSE_OUT : target.gotoAndStop(1); break;
				case MouseEvent.CLICK : popup1OutMotion(); break;
			}
		}
		
		private function popup1OutMotion():void
		{
			TweenLite.to(_con.interPopup.popup1.vcon.vSuccess, 0.75, {frame:_con.interPopup.popup1.vcon.vSuccess.totalFrames, onComplete:hidePopup});
		}
		
		/**
		 * 팝업 2 이벤트 *********************************************************
		 * */
		private function popup2BtnHandler(e:MouseEvent):void
		{
			if(_blockBtn) return;
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					target.gotoAndPlay(1);
					break;
				case MouseEvent.MOUSE_OUT:
					target.gotoAndPlay(36);
					break;
				case MouseEvent.CLICK: 
					if(target.no == 1) hidePopup();
					else target.gotoAndPlay(23);
					break;
			}
		}
		
		private function btnReset(mc:MovieClip):void
		{		mc.gotoAndStop(1);			}
		
		private function hidePopup():void
		{
			trace("인터랙션 팝업 닫기 ==> " + _model.interPopupNum);
			if(_model.interPopupNum == 0) _con.interPopup.popup0.frame.stop();
			removeEvent();
			_blockBtn = true;
			_con.interPopup.dimmed.visible = true;
			_model.videoNum++;
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_OFF));
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_PANNING_BUTTON));
			
			sendTracking();
		}
		
		/**	트래킹	*/
		private function sendTracking():void
		{
			if(_model.verEng == false){
				switch (_model.interPopupNum) {
					case 0 : JavaScriptUtil.call("sendTracking", "P6"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "P16"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "P17"); break;
				}
			}else{
				switch (_model.interPopupNum) {
					case 0 : JavaScriptUtil.call("sendTracking", "EP6"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "EP16"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "EP17"); break;
				}
			}
		}
		
		private function closeInteractivePopup(e:LolEvent):void
		{
		}
		
		private function removeEvent():void
		{
			_model.isInterPopup = false;
			_model.quickMenuShow = true;
			TweenLite.to(_popupArr[_model.interPopupNum], 0.75 , {autoAlpha:0, onComplete:videoPlay});
		}
		
		/**	비디오 재생	*/
		private function videoPlay():void
		{
			_con.interPopup.visible = false;
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
		}
		
		
		private function resizeHandler(e:Event = null):void
		{
			_con.interPopup.x = _con.stage.stageWidth/2 - 493/2;
			_con.interPopup.y = _con.stage.stageHeight/2 - 553/2;
		}
	}
}