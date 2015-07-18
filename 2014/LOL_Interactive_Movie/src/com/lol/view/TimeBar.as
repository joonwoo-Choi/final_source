package com.lol.view
{
	
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimeBar
	{
		
		private var _timer:Timer;
		private var _model:Model = Model.getInstance();
		
		public function TimeBar()
		{
			_timer = new Timer(9000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerEnd);
			
			_model.addEventListener(LolEvent.TIMER_START, start);
			_model.addEventListener(LolEvent.TIMER_STOP, stop);
		}
		
		private function start(e:LolEvent):void
		{
			trace("-------------------  타이머 시작 --------------------");
			_timer.repeatCount = 1;
			if(!_model.isReactionPopup){
				if(_model.popupNum == 2 || _model.popupNum == 8) _timer.repeatCount = 3;
			}
			_timer.reset();
			_timer.start();
		}
		
		private function stop(e:LolEvent):void
		{
			reset();
		}
		
		private function timerEnd(e:TimerEvent):void
		{
			reset();
			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_END));
		}
		
		private function reset():void
		{
			trace("-------------------  타이머 종료 --------------------");
			_timer.stop();
			_timer.reset();
		}
	}
}