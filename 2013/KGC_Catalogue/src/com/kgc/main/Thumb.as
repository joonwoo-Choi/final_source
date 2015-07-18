package com.kgc.main
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kgc.event.KGCEvent;
	import com.kgc.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Thumb
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $sp:Sprite;
		/**	X 기준 포인트	*/
		private var $setPointX:Number;
		/**	Y 기준 포인트	*/
		private var $setPointY:Number;
		/**	이동 시작할지 말지 체크	*/
		private var $isMove:Boolean = false;
		/**	마우스 스테이지 위인지	*/
		private var $isStage:Boolean = false;
		
		public function Thumb(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			$con = con;
			
			$sp = new Sprite();
			$con.addChild($sp);
			
			$model = Model.getInstance();
			$model.addEventListener(KGCEvent.THUMB_UPDATE, thumbUpdate);
			$con.addEventListener(MouseEvent.MOUSE_DOWN, setMousePoint);
		}
		/**	카다로그 위치 이동시 셈네일 위치 변경	*/
		protected function thumbUpdate(e:Event):void
		{
			TweenLite.to($con.maskMC, 0.5, {x:$model.thumbX, y:$model.thumbY,  
																scaleX:1/ $model.pageScale, scaleY:1/ $model.pageScale, 
																onUpdate:drawRect});
			if($model.pageScale == 1) TweenLite.to($con, 0.5, {autoAlpha:0});
			else TweenLite.to($con, 0.5, {autoAlpha:1});
		}
		/**	섬네일 페이지 변경	*/
		public function thumbSetting():void
		{
			$con.gotoAndStop($model.pageNum + 1);
		}
		/**	빨간선 프레임 생성	*/
		private function drawRect():void
		{
			$sp.graphics.clear();
			$sp.graphics.lineStyle(6, 0xff0000, 1);;
			$sp.graphics.drawRect($con.maskMC.x, $con.maskMC.y, $con.maskMC.width, $con.maskMC.height);
		}
		/**	섬네일 이동 체크	*/
		private function setMousePoint(e:MouseEvent):void
		{
			checkMousePoint();
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
		}
		
		private function checkMousePoint(e:MouseEvent = null):void
		{
			var thumbX:int = $con.mouseX - $con.maskMC.width/2;
			var thumbY:int= $con.mouseY - $con.maskMC.height/2;
			
			if(thumbX < 0) thumbX = 0;
			else if(thumbX > $con.plane.width - $con.maskMC.width) thumbX = int($con.plane.width - $con.maskMC.width);
			
			if(thumbY < 0) thumbY = 0;
			else if(thumbY > $con.plane.height - $con.maskMC.height) thumbY = int($con.plane.height - $con.maskMC.height);
			
			TweenLite.to($con.maskMC, 0.5, {x:thumbX, y:thumbY, ease:Cubic.easeOut, onUpdate:drawRect});
			
			$model.thumbX = thumbX;
			$model.thumbY = thumbY;
			
			$model.dispatchEvent(new KGCEvent(KGCEvent.THUMB_DRAG));
			trace(thumbX, thumbY);
		}
		
		private function stopCheckMousePoint(e:MouseEvent):void
		{
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
		}
	}
}