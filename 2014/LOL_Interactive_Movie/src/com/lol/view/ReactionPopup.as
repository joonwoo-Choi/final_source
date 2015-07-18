package com.lol.view
{
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ReactionPopup
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		public function ReactionPopup(con:MovieClip)
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
			_model.addEventListener(LolEvent.SHOW_REACTION_POPUP, showPopup);
			_model.addEventListener(LolEvent.HIDE_REACTION_POPUP, closeReactionPopup);
			_model.addEventListener(LolEvent.TIMER_END, timerEnd);
			
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		protected function showPopup(e:LolEvent):void
		{
			trace("리액션 팝업 오픈 ==> " + _model.reactionPopupNum);
			_model.isReactionPopup = true;
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PAUSE));
			_model.dispatchEvent(new LolEvent(LolEvent.HIDE_QUICK_MENU));
			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_START));
			_con.yellowMc.blockMc.visible = false;
			_con.yellowMc.gotoAndStop(_model.reactionPopupNum+1);
			_con.yellowMc.balloon.gotoAndStop(1);
			_con.yellowMc.balloon.btn.play();
			TweenLite.to(_con.yellowMc.balloon, 1.5, {frame:41});
			_con.yellowMc.visible = true;
			_con.yellowMc.balloon.btn.addEventListener(MouseEvent.CLICK, nextVideoPlay);
			
			sendTracking();
		}
		
		/**	트래킹	*/
		private function sendTracking():void
		{
			if(_model.verEng == false){
				switch (_model.reactionPopupNum) {
					case 0 : JavaScriptUtil.call("sendTracking", "P2"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "P3"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "P7"); break;
					case 4 : JavaScriptUtil.call("sendTracking", "P14"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "P15"); break;
				}
			}else{
				switch (_model.reactionPopupNum) {
					case 0 : JavaScriptUtil.call("sendTracking", "EP2"); break;
					case 1 : JavaScriptUtil.call("sendTracking", "EP3"); break;
					case 3 : JavaScriptUtil.call("sendTracking", "EP7"); break;
					case 4 : JavaScriptUtil.call("sendTracking", "EP14"); break;
					case 6 : JavaScriptUtil.call("sendTracking", "EP15"); break;
				}
			}
		}
		
		protected function closeReactionPopup(e:LolEvent):void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			closePopup();
		}
		
		protected function timerEnd(e:LolEvent):void
		{
			if(!_model.isReactionPopup) return;
			closePopup();
		}
		
		private function nextVideoPlay(e:MouseEvent):void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			closePopup();
		}
		
		private function closePopup():void
		{
			_model.isReactionPopup = false;
			_model.quickMenuShow = true;
			_con.yellowMc.balloon.btn.removeEventListener(MouseEvent.CLICK, nextVideoPlay);
			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_RESUME));
			_con.yellowMc.blockMc.visible = true;
			_con.yellowMc.balloon.btn.stop();
			TweenLite.to(_con.yellowMc.balloon, 1, {frame:_con.yellowMc.balloon.totalFrames, onComplete:hidePopup});
		}
		
		private function hidePopup():void
		{
			_con.yellowMc.visible = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.yellowMc.x = int(_con.stage.stageWidth/2 - _con.yellowMc.width/2) + 150;
			_con.yellowMc.y = int(_con.stage.stageHeight - _con.yellowMc.height) + 50;
		}
	}
}