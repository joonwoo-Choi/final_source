package com.sw.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * (아직 사용 되지 않았음)
	 * 무비클립 함수 관련 클래스
	 * */
	public class McFnc
	{
		/**	생성자	*/
		public function McFnc()
		{
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**
		 * 특정 프레임에서 함수 실행
		 * @param $mc			::		해당 mc
		 * @param $fnc			::		실행 함수
		 * @param $frame		::		실행 위치
		 */
		static function enter($mc:MovieClip,$fnc:Function,$frame:int=null):void
		{
			$mc.fnc = $fnc;
			if($frame == null) $frame = $mc.totalFrames;
			$mc.frame = $frame;
			$mc.addEventListener(Event.ENTER_FRAME,McFnc.onEnter);
		}
		/**	함수 실행 위치 찾는 이벤트	*/
		static function onEnter(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			if(mc.currentFrame == mc.frame)
			{
				mc.fnc();
				mc.removeEventListener(new Event(Event.ENTER_FRAME));
			}
		}
	}//class
}//package