package com.proof.microsite.cosmo
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class Thumb_Move
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	X 기준 포인트	*/
		private var $setPointX:Number;
		/**	Y 기준 포인트	*/
		private var $setPointY:Number;
		/**	이동 시작할지 말지 체크	*/
		private var $isMove:Boolean = false;
		/**	마우스 스테이지 위인지	*/
		private var $isStage:Boolean = false;
		
		public function Thumb_Move(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.COSMO_START, cosmoStart);
		}
		
		protected function cosmoStart(e:Event):void
		{
			$con.thumb.addEventListener(MouseEvent.MOUSE_DOWN, setMousePoint);
		}
		
		private function setMousePoint(e:MouseEvent):void
		{
			$con.btnHand.visible = false;
			checkMousePoint();
			$con.thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
		}
		
		private function checkMousePoint(e:MouseEvent = null):void
		{
			var thumbX:Number = $con.thumb.mouseX - $con.thumb.mcMask.width/2;
			var thumbY:Number = $con.thumb.mouseY - $con.thumb.mcMask.height/2;
			
			if(thumbX < 0) thumbX = 0;
			else if(thumbX > $con.thumb.plane.width - $con.thumb.mcMask.width) thumbX = int($con.thumb.plane.width - $con.thumb.mcMask.width);
			
			if(thumbY < 0) thumbY = 0;
			else if(thumbY > $con.thumb.plane.height - $con.thumb.mcMask.height) thumbY = int($con.thumb.plane.height - $con.thumb.mcMask.height);
			
			TweenLite.to($con.thumb.mcMask, 0.5, {x:thumbX, y:thumbY, ease:Cubic.easeOut});
			TweenLite.to($con.thumb.window, 0.5, {x:thumbX, y:thumbY, ease:Cubic.easeOut});
			trace(thumbX, thumbY);
			
			var imgX:Number = -thumbX * 16.8;
			var imgY:Number = -thumbY * 16.8;
			
			if(imgX > 0) imgX = 0;
			else if(imgX <= $con.mcMask.width - $con.img.width) imgX = int($con.mcMask.width - $con.img.width);
			
			if(imgY > 0) imgY = 0;
			else if(imgY <= $con.mcMask.height - $con.img.height) imgY = int($con.mcMask.height - $con.img.height);
			
			TweenLite.killTweensOf($con.img);
			TweenLite.to($con.img, 0.5, {x:imgX, y:imgY, ease:Cubic.easeOut});
			
			Mouse.show();
			TweenLite.to($con.btnHand, 0.5, {alpha:0, ease:Cubic.easeOut});
		}
		
		private function stopCheckMousePoint(e:MouseEvent):void
		{
			$con.btnHand.visible = true;
			$con.thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
		}
	}
}