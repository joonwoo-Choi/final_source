package com.cj.core
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Non Blocking Loop 
	 * 과도한 연산으로 cpu가 뻗는현상을 방지하기 위함
	 * 엔터프레임을 이용해 분할 실행..
	 * 
	 */
	public class NonBlockingLoop extends EventDispatcher
	{
		// 엔터프레임을 돌리기 위한 displayobject
		private var _looper:Shape = new Shape;
		
		private var _countIdx:int;
		private var _counter:int;
		private var _limit:int;
		private var _runner:Function;
		private var _args:Array;
		
		private var _frameBool:Boolean;
		
		public function NonBlockingLoop(){}
		
		public function loop($counter:int, $limit:int, $runner:Function, ...$args):void
		{
			_frameBool = true;
			_countIdx = 0;
			_counter = $counter;
			_limit = $limit;
			_runner = $runner;
			_args = $args;
			
			_looper.addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		private function enterframe(e:Event):void
		{
			var i:int;
			while( i++ < _limit && _frameBool)
			{
				if( _countIdx < _counter ){
					if(_args.length) _runner.apply(null, _args);
					else _runner();
					
					++_countIdx;
				}else{
					close();
					break;
				}
			}
		}
		
		public function close():void
		{
			_frameBool = false;
			_looper.removeEventListener(Event.ENTER_FRAME, enterframe);
			dispatchEvent( new Event(Event.COMPLETE) );
			
			trace("루프 끝났당께!!!!!");
		}
	}
}