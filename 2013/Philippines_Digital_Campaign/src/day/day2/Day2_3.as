package day.day2
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day2_3 extends AbstractMain
	{
		
		private var $main:AssetDay2_3;
		
		private var $defaultPath:String;
		
		private var $btnLength:int = 2;
		
//		private var $skipTimer:Timer;
		
		private var $snd:HOTEL_Song;
		
		private var $channel:SoundChannel;
		
		private var $pausePosition:Number;
		
		public function Day2_3()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin]);
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
			if(SecurityUtil.isWeb()) $defaultPath = "http://cdn.funtrip2manila.co.kr/www/";
			else $defaultPath = "";
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.addEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			$main = new AssetDay2_3();
			$main.alpha = 0;
			this.addChild($main);
			
			makeBtn();
			
//			/**	인터랙션 스킵 타이머	*/
//			$skipTimer = new Timer(18000, 1);
//			$skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, skipInteraction);
//			$skipTimer.start();
		}
		/**	인터랙션 정지 	*/
		protected function pauseInteraction(e:Event):void
		{
			$main.mov.removeEventListener(Event.ENTER_FRAME, playStatusChk);
			$channel.removeEventListener(Event.SOUND_COMPLETE, musicEnd);
//			$skipTimer.stop();
			$main.mov.stop();
			$pausePosition = $channel.position;
			$channel.stop();
			trace("사운드 정지 위치: " + $pausePosition);
		}
		/**	인터랙션 재실행	*/
		protected function resumeInteraction(e:Event):void
		{
			$main.mov.addEventListener(Event.ENTER_FRAME, playStatusChk);
			$channel.addEventListener(Event.SOUND_COMPLETE, musicEnd);
//			$skipTimer.start();
			$main.mov.play();
			$channel = $snd.play($pausePosition);
		}
		
//		/**	스킵 타이머 - 인터랙션 종료	*/
//		private function skipInteraction(e:TimerEvent):void
//		{
//			skipHandler();
//		}
		
		private function makeBtn():void
		{
			/**	빨리감기 버튼	*/
			$main.seekBar.buttonMode = true;
			$main.seekBar.addEventListener(MouseEvent.MOUSE_OVER, btnHandler);
			$main.seekBar.addEventListener(MouseEvent.MOUSE_OUT, btnHandler);
			$main.seekBar.addEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			
			$main.mov.addEventListener(Event.ENTER_FRAME, playStatusChk);
			
			$snd = new HOTEL_Song();
			$channel = new SoundChannel();
			$channel = $snd.play();
			$channel.addEventListener(Event.SOUND_COMPLETE, musicEnd);
			
			TweenLite.to($main, 1, {alpha:1});
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenMax.to($main.seekBar.sun, .3, {scaleX:1.2,scaleY:1.2,colorMatrixFilter:{brightness:1.1,contrast:1.1}});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenMax.to($main.seekBar.sun, .3, {scaleX:1,scaleY:1,colorMatrixFilter:{brightness:1,contrast:1}});
					break;
				case MouseEvent.MOUSE_DOWN :
//					$skipTimer.stop();
					$main.mov.stop();
					frameRateChange();
					$main.mov.removeEventListener(Event.ENTER_FRAME, playStatusChk);
					$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
					$main.seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, normalPlay);
					break;
			}
		}
		
		/**	프레임 레이트 변환	*/
		private function frameRateChange(e:MouseEvent = null):void
		{
			var sunY:int;
			var sunMinY:int = $main.seekBar.area.y;
			var sunMaxY:int = $main.seekBar.area.height + $main.seekBar.area.y;
			
			sunY = $main.seekBar.mouseY;
			if(sunY <= sunMinY) sunY = sunMinY;
			else if(sunY >= sunMaxY) sunY = sunMaxY;
			$main.seekBar.sun.y = sunY;
			
			var movFrame:int = (sunY/($main.seekBar.area.height + $main.seekBar.area.y)) * $main.mov.totalFrames;
			$main.mov.gotoAndStop(movFrame);
			interactionEndChk();
		}
		/**	재생 속도 & 위치 체크	*/
		private function playStatusChk(e:Event):void
		{
			interactionEndChk();
			$main.seekBar.sun.y = ($main.mov.currentFrame/$main.mov.totalFrames) * ($main.seekBar.area.height + $main.seekBar.area.y);
			trace($main.seekBar.sun.y);
		}
		/**	인터랙션 종료 체크	*/
		private function interactionEndChk():void
		{
			if($main.mov.currentFrame == $main.mov.totalFrames)
			{
				skipHandler();
			}
		}
		/**	정상 재생	*/
		private function normalPlay(e:MouseEvent):void
		{
//			$skipTimer.start();
			$main.mov.play();
			$main.mov.addEventListener(Event.ENTER_FRAME, playStatusChk);
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
			$main.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
		}
		
		/**	음악 종료	*/
		private function musicEnd(e:Event):void
		{
			$channel = $snd.play();
			$channel.removeEventListener(Event.SOUND_COMPLETE, musicEnd);
			$channel.addEventListener(Event.SOUND_COMPLETE, musicEnd);
//			skipHandler();
		}
		
		private function skipHandler():void
		{
			removeEvent();
			$main.mov.stop();
			_controler.changeMovie([3, 6]);
//			TweenLite.to($main, 0.5, {autoAlpha:0, onComplete:destroy});
//			setTimeout(removeMain, 300);
		}
		private function removeMain(e:Event):void
		{
//			$main.visible = false;
//			$main.alpha = 0;
//			destroy();
			trace("::::::::::::: 스카이덱 레스토랑 인터랙션 종료 :::::::::::::");
			_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			TweenLite.to($main, 0, {delay:0.5, autoAlpha:0, onComplete:destroy});
		}
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
		/**	버튼 이벤트 지우기	*/
		private function removeEvent(e:Event=null):void
		{
			$main.seekBar.buttonMode = false;
			$main.seekBar.removeEventListener(MouseEvent.MOUSE_OVER, btnHandler);
			$main.seekBar.removeEventListener(MouseEvent.MOUSE_OUT, btnHandler);
			$main.seekBar.removeEventListener(MouseEvent.MOUSE_DOWN, btnHandler);
			
			$main.mov.removeEventListener(Event.ENTER_FRAME, playStatusChk);
			$main.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
			
//			$skipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, skipInteraction);
//			$skipTimer.stop();
//			$skipTimer = null;
			
			$channel.removeEventListener(Event.SOUND_COMPLETE, musicEnd);
			$channel.stop();
			$channel = null;
			$snd = null;
			
			_model.removeEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.removeEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
	}
}