package com.cj.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipUtil
	{
		static public const PLAY_COMPLETE:String = "play_complete";
		static private var playComplete:Boolean;
		static private var frameSpeed:int;
		
		public function MovieClipUtil(){}
		
		public static function allStop(container:MovieClip) : void
		{
			container.stop();
			
			// 자식 오브젝트가 있다면
			var total:int = container.numChildren;
			var i:int=0;
			var child:DisplayObject;
			for(; i < total; ++i)
			{
				child = container.getChildAt(i);
				
				// 자식이 무비클립이면 재귀호출
				if(child is MovieClip){
					MovieClipUtil.allStop(child as MovieClip);
				}
			}
		}
		
		//______________________ public static function ____________________________________________________

		/**
		 * 무비클립 재생
		 * @param $mc
		 * 
		 */		
		static public function play($mc:MovieClip, $frSpeed:int=1):void
		{
			frameSpeed = $frSpeed;
			if($mc.hasEventListener(Event.ENTER_FRAME)){ 
				$mc.removeEventListener(Event.ENTER_FRAME, prevFrameHandler);
			}
			$mc.addEventListener(Event.ENTER_FRAME, nextFrameHandler);
		}
		
		/**
		 * 무비클립 되돌리기 
		 * @param $mc
		 * 
		 */		
		static public function back($mc:MovieClip, $frSpeed:int=1):void
		{
			frameSpeed = $frSpeed;
			if($mc.hasEventListener(Event.ENTER_FRAME)){
				$mc.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
			}
			$mc.addEventListener(Event.ENTER_FRAME, prevFrameHandler);
		}
		
		static public function clear($mc:MovieClip, $next:Boolean=false):void
		{
			var bool:Boolean = $mc.hasEventListener(Event.ENTER_FRAME);
			if(bool == false) return;
			
			if($next){
				$mc.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
			}else{
				$mc.removeEventListener(Event.ENTER_FRAME, prevFrameHandler);	
			}
		}
		
		//______________________ private static event handler _____________________________________________
		
		static private function nextFrameHandler(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			for (var i:int = 0; i < frameSpeed; i++) 
			{
				mc.nextFrame();
			}
			
			if(mc.currentFrame == mc.totalFrames){
				mc.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
				mc.dispatchEvent( new Event(PLAY_COMPLETE) );
			}
		}
		
		static private function prevFrameHandler(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			for (var i:int = 0; i < frameSpeed; i++) 
			{
				mc.prevFrame();
			}
			
			if(mc.currentFrame == 1){
				mc.removeEventListener(Event.ENTER_FRAME, prevFrameHandler);
				mc.dispatchEvent( new Event(PLAY_COMPLETE) );
			}
		}
		
	}
}