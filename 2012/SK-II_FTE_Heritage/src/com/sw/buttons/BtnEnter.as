package com.sw.buttons
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * MovieClip 버튼 모션 오버시 앞으로 가고, 아웃시 뒤로 가기 <br>
	 * click : 후 실행 함수. (인자) : MovieClip <br>
	 * prev : 되돌아가는 속도  <br>
	 * next : 앞으로 가는 속도 <br>
	 * <p>ex : new BtnEnter(mc,{click:onClick,prev:1,next:1});
	 * */
	public class BtnEnter extends Sprite
	{
		private var mc:MovieClip;
		private var data:Object;
		/**	
		 * 생성자		
		 * */
		public function BtnEnter(mc:MovieClip=null,$data:Object=null)
		{
			super();
			this.mc = mc;
			mc.buttonMode = true;
			mc.mouseChildren = false;
			mc.gotoAndStop(1);
			mc.moveMc = moveMc;
			mc.addEventListener(MouseEvent.ROLL_OVER,onOver);
			mc.addEventListener(MouseEvent.ROLL_OUT,onOut);
			data = new Object();
			
			if($data == null) return;
			if($data.click) 
			{
				data = $data;
				mc.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		/**	소멸자		*/
		public function destroy():void
		{		}
		
		/**
		 * 버튼 오버시
		 * */
		private function onOver(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(data.over != null) data.over(mc);
			moveMc("play");
		}
		/**
		 * 버튼 아웃시
		 * */
 		private function onOut(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			moveMc("prev");
			if(data.out != null) data.out(mc);
		}
		
		/**
		 * enterframe 움직임 적용
		 * */
		public function moveMc($dir:String = "play"):void
		{
			data.dir = $dir;
			mc.removeEventListener(Event.ENTER_FRAME,onEnter);
			mc.addEventListener(Event.ENTER_FRAME,onEnter);
		}
		/**	
		 * 뒤로 계속 감기기	
		 * */
		private function onEnter(e:Event):void
		{
			var cnt:int = 1;
			if(data.dir == "prev" && data.prev) cnt = data.prev;
			if(data.dir == "play" && data.play) cnt = data.play;
			if(cnt < 0) cnt = 1;
			
			for(var i:int = 1; i<= cnt; i++)
			{
				if(data.dir == "prev") mc.prevFrame();
				if(data.dir == "play") mc.nextFrame();
			}
			if(mc.currentFrame == 1 || mc.currentFrame == mc.totalFrames) 
			{
				mc.removeEventListener(Event.ENTER_FRAME,onEnter);
			}
		}
		
		/**	메뉴 클릭시*/
		private function onClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			data.click(mc);
		}
	}//class
}//package