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
	
	public class Stage_Move
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
		/**	마우스 다운인지 아닌지	*/
		private var $isDown:Boolean = false;
		
		public function Stage_Move(con:MovieClip)
		{
			$con = con;
			
			$con.shadow.mouseEnabled = false;
			$con.shadow.mouseChildren = false;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.COSMO_START, cosmoStart);
		}
		
		protected function cosmoStart(e:Event):void
		{
			makeButton();
			btnHandShow();
			imgMoveCheck();
			TweenLite.to($con.btnHand, 0.5, {alpha:1});
			Mouse.hide();
		}
		
		private function makeButton():void
		{
			$con.btnDrag.addEventListener(MouseEvent.MOUSE_OVER, btnHandShow);
			$con.btnDrag.addEventListener(MouseEvent.MOUSE_OUT, btnHandHide);
			$con.btnDrag.addEventListener(Event.MOUSE_LEAVE, removeHandler);
		}
		
		private function btnHandShow(e:MouseEvent = null):void
		{
			$isStage = true;
			Mouse.hide();
			TweenLite.to($con.btnHand, 0.5, {alpha:1});
			
			$con.btnDrag.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.btnDrag.addEventListener(MouseEvent.MOUSE_DOWN, setMousePoint);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
		}
		
		private function checkMousePoint(e:MouseEvent):void
		{
			$con.btnHand.alpha = 1;
			TweenLite.to($con.btnHand, 0.35, {x:$con.mouseX, y:$con.mouseY, ease:Cubic.easeOut});
			imgMoveCheck();
		}
		
		private function imgMoveCheck():void
		{
			if($isMove)
			{
				var imgX:Number =$con.img.x + $con.img.mouseX - $setPointX;
				var imgY:Number = $con.img.y + $con.img.mouseY - $setPointY;
				
				if(imgX > 0) imgX = 0;
				else if(imgX <= $con.mcMask.width - $con.img.width) imgX = int($con.mcMask.width - $con.img.width);
				
				if(imgY > 0) imgY = 0;
				else if(imgY <= $con.mcMask.height - $con.img.height) imgY = int($con.mcMask.height - $con.img.height);
				
				TweenLite.killTweensOf($con.img);
				TweenLite.to($con.img, 0.5, {x:imgX, y:imgY, ease:Cubic.easeOut});
				
				var thumbX:Number = Math.abs(imgX / 16.6);
				var thumbY:Number = Math.abs(imgY / 16.6);
				
				if(thumbX < 0) imgX = 0;
				else if(thumbX > $con.thumb.width - $con.thumb.mcMask.width) thumbX = int($con.thumb.width - $con.thumb.mcMask.width);
				
				if(thumbY < 0) imgY = 0;
				else if(thumbY > $con.thumb.height - $con.thumb.mcMask.height) imgY = int($con.thumb.height - $con.thumb.mcMask.height);
				
				TweenLite.to($con.thumb.mcMask, 0.5, {x:thumbX, y:thumbY, ease:Cubic.easeOut});
				TweenLite.to($con.thumb.window, 0.5, {x:thumbX, y:thumbY, ease:Cubic.easeOut});
			}
		}
		
		private function setMousePoint(e:MouseEvent):void
		{
//			$con.btnDrag.removeEventListener(MouseEvent.MOUSE_OVER, btnHandShow);
			$con.btnHand.hand.gotoAndStop(2);
			$setPointX = $con.img.mouseX;
			$setPointY = $con.img.mouseY;
			$isDown = true;
			$isMove = true;
		}
		
		private function stopCheckMousePoint(e:MouseEvent = null):void
		{
			$con.btnHand.hand.gotoAndStop(1);
			$isMove = false;
			$isDown = false;
			if($isStage == false)
			{
				$con.btnDrag.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
				$con.btnDrag.removeEventListener(MouseEvent.MOUSE_DOWN, setMousePoint);
				$con.stage.removeEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
			}
//			$con.btnDrag.addEventListener(MouseEvent.MOUSE_OVER, btnHandShow);
		}
		
		private function btnHandHide(e:MouseEvent):void
		{
			if($isDown == false) $con.btnDrag.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			removeHandler();
		}
		
		private function removeHandler(e:Event = null):void
		{
			$isStage = false;
			Mouse.show();
			TweenLite.to($con.btnHand, 0.5, {alpha:0});
		}
	}
}