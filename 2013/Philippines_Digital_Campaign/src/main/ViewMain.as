package main
{
	import com.greensock.TweenLite;
//	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import pEvent.PEventCommon;
	
	public class ViewMain extends AbstractMCView
	{
		private var myTimer:Timer;
		
		public function ViewMain(con:MovieClip)
		{
			super(con);
			setting();
		}
		
		override public function setting():void
		{
			mainBgChange();	
			peopleTimer();
		}
		
		override protected function onRemoved(event:Event):void
		{
			trace("메인아웃!!!!!!!!!!!!!!!!!!!!!!");
			myTimer.removeEventListener("timer", timerHandler);
			myTimer.stop();
			super.onRemoved(event);
		}
		
		//메인 에일리 랜덤
		private function mainBgChange(evt:Event=null):void
		{
			var prNum:int = Math.ceil(Math.random()*7)-1; 
			
			for (var i:int = 0; i < 8; i++) 
			{
				var bg:MovieClip = _mcView["p"+i];
				if(prNum == i){
					TweenLite.to(bg, .5,{autoAlpha:1});
				}else{
					TweenLite.to(bg, .5,{autoAlpha:0});
				}
			}
		}
		
		//에일리 랜덤 타이머
		public function peopleTimer():void {
			myTimer = new Timer(4000);
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}
		
		public function timerHandler(evt:TimerEvent):void {
			mainBgChange();
		}
		
	}
}