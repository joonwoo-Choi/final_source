package com.sw.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**		
	 * 드래그
	 */
	public class Drag
	{
		private var dragMc:MovieClip;
		
		private var data:Object;
		private var container:MovieClip;
		
		private var mx:Number;
		private var my:Number;
		private var sx:Number;
		private var sy:Number;
		
		/**	
		 * 생성자	<br>
		 * mc:드래그 하는 MovieClip,{standard:최소값을 계산할 기준 ,maxX:세로최대,minX:세로최소,<br>
		 * maxY:가로최대,minY:가로최소,onEnter:드래그중 실행 내용,<br>
		 * click:클릭시수행내용}
		 * */
		public function Drag(mc:MovieClip,$data:Object = null)
		{
			container = mc;
			
			data = $data;
			
			if(data.speed == null) data.speed = 1;
			if(data == null) data = new Object();
			
			mc.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,onDownImg);
			
			mc.buttonMode = true;
			
			if(data.standard != null)
			{
				var std:DisplayObject = data.standard as DisplayObject;
				if(std == null) throw new Error("standard가 잘못되었습니다.");
				setMax(0,0);
				data.minX = Math.round((std.width-mc.width));
				data.minY = Math.round((std.height-mc.height));
			}
		}
		
		/**	드래그 최소 값	설정	*/
		public function setMin($x:int,$y:int):void
		{	
			data.minX = $x;	data.minY = $y;	
			if(container.x < $x) container.x = $x;
			if(container.y < $y) container.y = $y;
		}
		/**	드래그 최대 값	설정	*/
		public function setMax($x:int,$y:int):void
		{	
			data.maxX = $x;	data.maxY = $y;	
			if(container.x > $x) container.x = $x;
			if(container.y > $y) container.y = $y;
		}
		
		/**	이미지 마우스 다운	*/
		private function onDownImg(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			mx = mc.parent.mouseX-mc.x;
			my = mc.parent.mouseY-mc.y;
			sx = mc.x;
			sy = mc.y;
			
			mc.addEventListener(Event.ENTER_FRAME,onEnterImg);
			
			dragMc = mc;
			
			mc.stage.addEventListener(MouseEvent.MOUSE_UP,onUpImg);
		}
		
		/**	이미지 마우스 업	*/
		private function onUpImg(e:MouseEvent):void
		{
			//var mc:MovieClip = e.currentTarget as MovieClip;
			var mc:MovieClip = dragMc;
			
			if(dragMc == null) return;
			
			mc.removeEventListener(Event.ENTER_FRAME,onEnterImg);
			
			var gapX:Number = Math.abs(Math.abs(mx+sx)-Math.abs(mc.parent.mouseX));
			var gapY:Number = Math.abs(Math.abs(my+sy)-Math.abs(mc.parent.mouseY));
			
			if(gapX < 2 && gapY < 2)
			{	//드래그가 아닌 클릭
				if(data.click != null) data.click(mc);
			}
			
			dragMc = null;
			
			mc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUpImg);
		}
		
		/**	드래그 중*/
		private function onEnterImg(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			//trace(mc.parent.name);
			
			if(data.dir != "TB") mc.x -= (mc.x - (mc.parent.mouseX - mx))*data.speed; 
			if(data.maxX != null && data.maxX < mc.x) mc.x = data.maxX;
			if(data.minX != null && data.minX > mc.x) mc.x = data.minX;
			
			if(data.dir != "LR")  mc.y -= (mc.y - (mc.parent.mouseY - my))*data.speed;
			if(data.maxY != null && data.maxY < mc.y) mc.y = data.maxY;
			if(data.minY != null && data.minY > mc.y) mc.y = data.minY;
			
			
			if(data.onEnter != null) data.onEnter(mc);
			
		}
		
		/**	소멸자	*/
		public function destroy(e:Event):void
		{
			//trace("Drag_destroy");
			container.removeEventListener(MouseEvent.MOUSE_DOWN,onDownImg);
			container.stage.removeEventListener(MouseEvent.MOUSE_UP,onUpImg);
		}	
	}//class
}//package