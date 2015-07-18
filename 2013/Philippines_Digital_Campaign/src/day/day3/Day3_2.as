package day.day3
{
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day3_2 extends AbstractMain
	{
		
		private var $main:AssetDay3_2;
		
		private var $btnLength:int = 2;
		
		
		public function Day3_2()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.addEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			$main = new AssetDay3_2();
			this.addChild($main);
			
			makeBtn();
			
		}
		
		/**	인터랙션 정지 	*/
		protected function pauseInteraction(e:Event):void
		{
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, manMoveHandler);
		}
		/**	인터랙션 재실행	*/
		protected function resumeInteraction(e:Event):void
		{
			$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, manMoveHandler);
		}
		
		private function removeMain(e:Event):void
		{
			
			trace("::::::::::::: 마카파갈 씨사이드 마켓 인터랙션 종료 :::::::::::::");
			_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			TweenLite.to($main, 0, {delay:0.5, autoAlpha:0, onComplete:destroy});
		}		
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnsHandler);
			}
			
			$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, manMoveHandler);
			
		}
		
		private function btnsHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			var exposureMC:MovieClip = $main["exposure" + target.no] as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target.bg, 0.5, {tint:0xfe3328});
					TweenLite.to(exposureMC, 0.5, {alpha:0.1});
					target.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target.bg, 0.5, {tint:null});
					TweenLite.to(exposureMC, 0.5, {alpha:0});
					target.gotoAndStop(1);
					break;
				case MouseEvent.CLICK :
					removeEvent();
//					setTimeout(removeMain,300);
					_controler.changeMovie([4, 2, target.no]);
					trace("영상번호: " + target.no);
					break;
			}
		}
		
		/**	아저씨 이동	*/
		private function manMoveHandler(e:MouseEvent):void
		{
			var moveNum:int = int($main.plane.width/2 - $main.man.width/2) + ($main.stage.mouseX - $main.plane.width/2) / 5;
			TweenLite.killTweensOf($main.man);
			TweenLite.to($main.man, 0.5, {x:moveNum});
		}
		
		
		/**	이벤트 제거	*/
		private function removeEvent(e:Event=null):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, btnsHandler);
			}
			
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, manMoveHandler);
			
			_model.removeEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.removeEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
	}
}