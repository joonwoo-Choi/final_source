package com.lol.view
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class SideButton
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _btnArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _videoNum:int;
		
		private var _showSideBtn:Boolean = false;
		private var _moving:Boolean = false;
		
		private var _selectBtnNum:int;
		
		public function SideButton(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin]);
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip = _con.btnCon.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				_btnArr.push(btn);
				ButtonUtil.makeButton(btn, buttonHandler);
			}
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.VIDEO_PLAY, sideButtonVisibleTrue);
			_model.addEventListener(LolEvent.SELECT_POPUP_OPEN, showSideBtn);
			_model.addEventListener(LolEvent.INTERACTION_POPUP_OPEN, showSideBtn2);
			_model.addEventListener(LolEvent.HIDE_PANNING_BUTTON, hideSideBtn);
			_model.addEventListener(LolEvent.PANNING_VIDEO_STOP, resetPosition);
			_model.addEventListener(LolEvent.PANNING_HIDE_CONTENTS, panningHideContents);
			
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		protected function sideButtonVisibleTrue(e:Event):void
		{
			if(_model.videoNum != 2 || _model.videoNum != 6 || _model.videoNum != 18){
				_con.btnCon.btn0.visible = true;
				_con.btnCon.btn1.visible = true;
			}
		}
		
		protected function panningHideContents(e:LolEvent):void
		{
			var popup:MovieClip = _con.popup.getChildByName("popup" + _model.popupNum) as MovieClip;
			popup.dimmed.visible = true;
			setTimeout(videoVisibleOn, 250);
			TweenLite.to(_con.interPopup, 0.75, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.popup, 0.75, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.dimmed, 0.75, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.btnCon, 0.75, {alpha:0, ease:Cubic.easeOut, onComplete:hideBtn});
		}
		
		private function videoVisibleOn():void
		{
			_con.videoCon.video.visible = true;
			TweenLite.to(_con.videoCon.cover, 0.75, {alpha:0, ease:Cubic.easeOut});
		}
		
		private function hideBtn():void
		{		_btnArr[_selectBtnNum].visible = false;		}
		
		protected function resetPosition(e:LolEvent):void
		{
			if(_model.popupNum == 9) _con.popup.popup9.dimmed.visible = false;
			_con.videoCon.cover.alpha = 1;
			if(_model.videoType == "swf") _con.videoCon.video.visible = false;
			TweenLite.to(_con.interPopup, 0.75, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.popup, 0.75, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.dimmed, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.btnCon, 0.75, {alpha:1, ease:Cubic.easeOut, onComplete:selectPossible});
			if(!_model.isInterPopup) _model.dispatchEvent(new LolEvent(LolEvent.TIMER_START));
		}
		
		private function selectPossible():void
		{		
			_con.blockMC.visible = false;
			var popup:MovieClip = _con.popup.getChildByName("popup" + _model.popupNum) as MovieClip;
			popup.dimmed.visible = false;
		}
		
		private function buttonHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target, 1, {frame:target.totalFrames});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(target, 1, {frame:1});
					break;
				case MouseEvent.CLICK :
					_selectBtnNum = target.no;
					_con.blockMC.visible = true;
					_model.isPanningVideo = true;
					_model.panningPath = _model.videoList.panning.mov[_videoNum+target.no].@videoPath;
					trace("패닝영상 경로_____________   " + _model.panningPath);
					playPanningVideo();
					sendTracking(_videoNum+target.no);
					break;
			}
		}
		
		private function sendTracking(num:int):void
		{
			if(_model.verEng == false){
				switch (num) {
					case 0 : JavaScriptUtil.call("sendTracking", "PA1"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "PA2"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "PA3"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "PA4"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "PA5"); break;
					case 7 : JavaScriptUtil.call("sendTracking", "PA6"); break;
				}
			}else{
				switch (num) {
					case 0 : JavaScriptUtil.call("sendTracking", "EPA1"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "EPA2"); break;
					case 2 : JavaScriptUtil.call("sendTracking", "EPA3"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "EPA4"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "EPA5"); break;
					case 7 : JavaScriptUtil.call("sendTracking", "EPA6"); break;
				}
			}
		}
		
		private function playPanningVideo():void
		{
			if(!_model.isInterPopup) _model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			_model.dispatchEvent(new LolEvent(LolEvent.PANNING_VIDEO_PLAY));
		}
		
		private function showSideBtn(e:LolEvent):void
		{
			if(_model.popupNum == 3 || _model.popupNum == 9)
			{
				if(_model.popupNum == 3) _videoNum = 0;
				if(_model.popupNum == 9) _videoNum = 6;
				_con.blockMC.visible = false;
				_showSideBtn = true;
				resizeHandler();
			}
		}
		
		private function showSideBtn2(e:LolEvent):void
		{
			if( _model.interPopupNum == 0)
			{
				_videoNum = 2;
				_con.blockMC.visible = false;
				_showSideBtn = true;
				resizeHandler();
			}
		}
		
		private function hideSideBtn(e:LolEvent):void
		{
			if(_showSideBtn == false) return;
			_moving = true;
			_con.blockMC.visible = true;
			TweenLite.to(_con.btnCon.btn0, 0.75, {x:-221, ease:Cubic.easeOut});
			TweenLite.to(_con.btnCon.btn1, 0.75, {x:_con.stage.stageWidth + 221, ease:Cubic.easeOut, onComplete:hideComplete});
		}
		
		private function hideComplete():void
		{
			_showSideBtn = false;
			_moving = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.btnCon.btn0.y = _con.btnCon.btn1.y = _con.stage.stageHeight/2 - 267/2;
			if(_showSideBtn == false)
			{
				_con.btnCon.btn0.x = -221;
				_con.btnCon.btn1.x = _con.stage.stageWidth + 221;
			}
			else
			{
				if(_moving) return;
				TweenLite.to(_con.btnCon.btn0, 0.75, {x:0, ease:Cubic.easeOut});
				TweenLite.to(_con.btnCon.btn1, 0.75, {x:_con.stage.stageWidth - 221, ease:Cubic.easeOut});
			}
			
			_con.blockMC.width = _con.stage.stageWidth;
			_con.blockMC.height= _con.stage.stageHeight;
		}
	}
}