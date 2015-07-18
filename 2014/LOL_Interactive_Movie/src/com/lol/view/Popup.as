package com.lol.view
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.control.PopupControl;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class Popup
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _popupControl:PopupControl;
		
		private var _popupLength:int;
		private var _popupArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _centerGroup:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _rightGroup:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _popup9BtnArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _popup9BlockArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var popupHeight:int = 500;
		private var sidePopupWidth:int = 449;
		private var centerPopupWidth:int = 561;
		private var finalPopupWidth:int = 652;
		
		public function Popup(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);
			
			_popupLength = _con.popup.numChildren;
			_popupArr.push(null);
			for (var i:int = 1; i <= _popupLength; i++) 
			{
				var popup:MovieClip = _con.popup.getChildByName("popup" + i) as MovieClip;
				popup.frame.stop();
				popup.no = i;
				_popupArr.push(popup);
				
				if(i == 3 || i == 8 || i == 9) _centerGroup.push(popup);
				if(i == 1 || i == 4 || i == 5 || i == 6 || i == 7 || i == 10 || i == 11 || i == 12 || i == 13) _rightGroup.push(popup);
			}
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.SELECT_POPUP_OPEN, showPopup);
			_model.addEventListener(LolEvent.SELECT_POPUP_CLOSE, hidePopup);
			_model.addEventListener(LolEvent.TIMER_END, timerEnd);
			
			var btn:MovieClip;
			var i:int;
			/**	팝업 1 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup1.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 2 이벤트 등록	*/
			for (i = 0; i < 1; i++) 
			{
				btn = _con.popup.popup2.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 3 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup3.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 4 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup4.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 5 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup5.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 6 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup6.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 7 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup7.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 8 이벤트 등록	*/
			for (i = 0; i < 1; i++) 
			{
				btn = _con.popup.popup8.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 9 이벤트 등록	*/
			for (i = 0; i < 4; i++) 
			{
				btn = _con.popup.popup9.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				_popup9BtnArr.push(btn);
				ButtonUtil.makeButton(btn, popupMouseHandler);
				
				if(i < 3){
					var blockMC:MovieClip = _con.popup.popup9.getChildByName("block" + i) as MovieClip;
					blockMC.visible = false;
					_popup9BlockArr.push(blockMC);
				}
			}
			/**	팝업 10 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup10.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 11 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup11.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 12 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup12.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			/**	팝업 13 이벤트 등록	*/
			for (i = 0; i < 2; i++) 
			{
				btn = _con.popup.popup13.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, popupMouseHandler);
			}
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			_popupControl = new PopupControl(_con, _popupArr, _popup9BtnArr, _popup9BlockArr);
		}
		
		/**	팝업 열기	*/
		protected function showPopup(e:LolEvent):void
		{
			if(_model.isReactionPopup) return;
			trace("팝업 오픈 ==> " + _model.isPopup);
			_model.isPopup = true;
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_ON));
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_QUICK_MENU));
			
			for (var i:int = 1; i <= _popupLength; i++) 
			{
				if(i == _model.popupNum)
				{
					_popupArr[i].gotoAndStop(1);
					_popupArr[i].frame.play();
					_popupArr[i].alpha = 1;
					_popupArr[i].visible = true;
				}
				else
				{
					_popupArr[i].alpha = 0;
					_popupArr[i].visible = false;
				}
			}
			_con.popup.visible = true;
			
			if(_model.popupNum == 3) _popupArr[_model.popupNum].chName.gotoAndStop(_model.randomMixNum+1);
			_popupArr[_model.popupNum].dimmed.visible = true;
			_popupArr[_model.popupNum].play();
			
			if(_model.popupNum == 2){
				_con.stage.focus = _con.popup.popup2.txt;
				_con.popup.popup2.txt.text = "";
			}
			if(_model.popupNum == 8){
				_con.stage.focus = _con.popup.popup8.txt;
				_con.popup.popup8.txt.text = "";
			}
			
			/**	마지막 팝업인지 체크	*/
			if(_model.popupNum != 14){
				_model.dispatchEvent(new LolEvent(LolEvent.TIMER_START));
			}else{
				_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			}
			
			_con.addEventListener(Event.ENTER_FRAME, frameEndChk);
			resizeHandler();
			
			sendTracking();
		}
		
		/**	트래킹	*/
		private function sendTracking():void
		{
			if(_model.verEng == false){
				switch (_model.popupNum) {
					case 1 : JavaScriptUtil.call("sendTracking", "P1"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "P4"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "P5"); break;
					case 4 : JavaScriptUtil.call("sendTracking", "P8"); break;
					case 5 : JavaScriptUtil.call("sendTracking", "P9"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "P10"); break;
					case 7 : JavaScriptUtil.call("sendTracking", "P11"); break;
					case 8 : JavaScriptUtil.call("sendTracking", "P12"); break;
					case 9 : JavaScriptUtil.call("sendTracking", "P13"); break;
					case 10 : JavaScriptUtil.call("sendTracking", "P18"); break;
					case 11 : JavaScriptUtil.call("sendTracking", "P19"); break;
					case 12 : JavaScriptUtil.call("sendTracking", "P20"); break;
					case 13 : JavaScriptUtil.call("sendTracking", "P21"); break;
					case 14 : JavaScriptUtil.call("sendTracking", "6"); break;
				}
			}else{
				switch (_model.popupNum) {
					case 1 : JavaScriptUtil.call("sendTracking", "EP1"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "EP4"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "EP5"); break;
					case 4 : JavaScriptUtil.call("sendTracking", "EP8"); break;
					case 5 : JavaScriptUtil.call("sendTracking", "EP9"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "EP10"); break;
					case 7 : JavaScriptUtil.call("sendTracking", "EP11"); break;
					case 8 : JavaScriptUtil.call("sendTracking", "EP12"); break;
					case 9 : JavaScriptUtil.call("sendTracking", "EP13"); break;
					case 10 : JavaScriptUtil.call("sendTracking", "EP18"); break;
					case 11 : JavaScriptUtil.call("sendTracking", "EP19"); break;
					case 12 : JavaScriptUtil.call("sendTracking", "EP20"); break;
					case 13 : JavaScriptUtil.call("sendTracking", "EP21"); break;
					case 14 : JavaScriptUtil.call("sendTracking", "E6"); break;
				}
			}
		}
		
		private function frameEndChk(e:Event):void
		{
			if(_popupArr[_model.popupNum].currentFrame == _popupArr[_model.popupNum].totalFrames-2)
			{
				_popupArr[_model.popupNum].dimmed.visible = false;
				_con.removeEventListener(Event.ENTER_FRAME, frameEndChk);
				
			}
		}
		/**	팝업 닫기	*/
		protected function hidePopup(e:LolEvent = null):void
		{
			_model.quickMenuShow = true;
			_popupArr[_model.popupNum].frame.stop();
			_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_OFF));
			TweenLite.to(_popupArr[_model.popupNum], 0.75 , {autoAlpha:0});
			videoPlay();
			trace("팝업 닫기 ==> " + _model.popupNum);
		}
		/**	팝업 선택 타이머 종료	*/
		protected function timerEnd(e:Event):void
		{
			if(_model.popupType != "popup" || _model.popupNum == 14 || _model.isReactionPopup) return;
			popupNumChk(-1);
		}
		/**	비디오 재생	*/
		private function videoPlay():void
		{
			_con.popup.visible = false;
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
		}
		
		/**	팝업 선택 핸들러	*/
		private function popupMouseHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget  as MovieClip;
			switch (e.type) 
			{
				case MouseEvent.MOUSE_OVER : 
					target.gotoAndPlay(1);
					break;
				case MouseEvent.MOUSE_OUT :
					target.gotoAndPlay(13);
					break;
				case MouseEvent.CLICK :
					_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
					popupNumChk(target.no);
					break;
			}
		}
		
		/**	팝업별로 진행	*/
		private function popupNumChk(btnNum:int):void
		{
			if(btnNum == -1) _model.selectPopupBtnNum = 0;
			else _model.selectPopupBtnNum = btnNum;
			trace("버튼 번호____________>>          " + _model.selectPopupBtnNum);
			
			_popupControl.action(btnNum);
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.popup.y = int(_con.stage.stageHeight/2 - popupHeight/2) - 30;
			
			var num:int = 0;
			if(_con.stage.stageWidth/2 > sidePopupWidth) num = (_con.stage.stageWidth/2 - sidePopupWidth)/2;
			/**	왼쪽 팝업	*/
			_con.popup.popup2.x = _con.stage.stageWidth/2 - sidePopupWidth - num- 15;
			
			/**	가운데 팝업	*/
			for (var i:int = 0; i < _centerGroup.length; i++) 
			{		_centerGroup[i].x = _con.stage.stageWidth/2 - centerPopupWidth/2;			}
			
			/**	우측 팝업	*/
			for (var j:int = 0; j < _rightGroup.length; j++) 
			{
				if(_con.stage.stageWidth/2 > sidePopupWidth) num = (_con.stage.stageWidth/2 - sidePopupWidth)/2; 
				_rightGroup[j].x = _con.stage.stageWidth/2 + num + 15;
			}
			
			_popupArr[14].x = int(_con.stage.stageWidth/2 - finalPopupWidth/2);
		}
	}
}