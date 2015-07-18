package com.kgc.main
{
	
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.kgc.event.KGCEvent;
	import com.kgc.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class DragCatalogue
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $mouseType:String;
		/**	확대 or 축소 가능 체크	*/
		private var $isZoom:Boolean = false;
		/**	확대 or 축소 트윈 중 체크	*/
		private var $isTween:Boolean = false;
		/**	드래그 확대 가능 체크	*/
		private var $isDragZoom:Boolean = false;
		/**	카다로그 드래그 가능 체크	*/
		private var $isDrag:Boolean = false;
		/**	X 기준 포인트	*/
		private var $setPointX:Number;
		/**	Y 기준 포인트	*/
		private var $setPointY:Number;
		/**	카다로그 시작 X	*/
		private var $catalogueX:int;
		/**	카다로그 시작 Y	*/
		private var $catalogueY:int;
		/**	이동 시작할지 말지 체크	*/
		private var $isMove:Boolean = false;
		/**	마우스 스테이지 위인지	*/
		private var $isStage:Boolean = false;
		/**	마우스 다운인지 아닌지	*/
		private var $isDown:Boolean = false;
		/**	드래그 확대 스프라이트	*/
		private var $sp:Sprite;
		/**	사각형 시작 X 좌표	*/
		private var $rectStartX:int;
		/**	사각형 시작 Y 좌표	*/
		private var $rectStartY:int;
		private var $rectEndX:Number;
		private var $rectEndY:Number;
		
		public function DragCatalogue(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(KGCEvent.RESET_ZOOM, zoomReset);
			$model.addEventListener(KGCEvent.THUMB_DRAG, moveCatalogue);
			
			$sp = new Sprite();
			$con.addChild($sp);
			
			$con.hand.mouseEnabled = false;
			$con.hand.mouseChildren = false;
			
			/**	드래그 줌	*/
			$con.addEventListener(MouseEvent.MOUSE_DOWN, dragZoomHandler);
			/**	카다로그 드래그 이동	*/
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMousePoint);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, stopCheckMousePoint);
			$con.addEventListener(MouseEvent.MOUSE_DOWN, setMousePoint);
			/**	손바닥 보이기 or 숨기기	*/
			$con.addEventListener(MouseEvent.MOUSE_OVER, showHand);
			$con.addEventListener(MouseEvent.MOUSE_OUT, hideHand);
		}
		
		/**	섬네일 이동시 카다로그 위치 변경	*/
		protected function moveCatalogue(e:Event):void
		{
			var imgX:Number = -($model.thumbX*(24.5*$model.pageArr[0].scaleX));
			var imgY:Number = -($model.thumbY*(24.5*$model.pageArr[0].scaleX));
			
			if(imgX > 0) imgX = 0;
			else if(imgX <= $con.plane.width - $model.pageArr[0].width) imgX = int($con.plane.width - $model.pageArr[0].width);
			
			if(imgY > 0) imgY = 0;
			else if(imgY <= $con.plane.height - $model.pageArr[0].height) imgY = int($con.plane.height - $model.pageArr[0].height);
			
			TweenLite.killTweensOf($model.pageArr[0]);
			TweenLite.to($model.pageArr[0], 0.5, {x:imgX, y:imgY, ease:Cubic.easeOut});
		}
		
		protected function zoomReset(e:Event):void
		{
//			$isZoom = false;
			$isDrag = false;
			$isDragZoom = false;
			TweenLite.killTweensOf($con.hand);
			$con.hand.alpha = 0;
			Mouse.show();
			$mouseType = "버튼 기능 해제!!";
		}
		
		public function setZoomType(num:int):void
		{
			$isDrag = false;
			$isDragZoom = false;
			TweenLite.to($con.hand, 0.5, {alpha:0});
			if(num == 0)
			{
				$mouseType = "zoomIn";
				$isDrag = true;
				zoomHandler();
			}
			else if(num == 1)
			{
				$mouseType = "zoomOut";
				$isDrag = false;
				zoomHandler();
			}
			else if(num == 2)
			{
				$mouseType = "zoomDrag";
				$isDragZoom = true;
			}
			else if(num == -1)
			{
				$mouseType = "버튼 기능 해제!!";
				$isDrag = true;
			}
			
			trace("줌 버튼 상태: " + $mouseType);
		}
		
		/**
		 * 줌 버튼
		 * */
		private function zoomHandler():void
		{
			if($isTween == true || $model.clickCheck == false) return;
			
			/**	이동 전 가로, 세로, X, Y	*/
			var prevX:int = $model.pageArr[0].x;
			var prevY:int = $model.pageArr[0].y;
			var prevWidth:int = $model.pageArr[0].width;
			var prevHeight:int = $model.pageArr[0].height;
			
			var tx:int = $con.plane.width/2 - $con.mouseX;
			var ty:int = $con.plane.height/2 - $con.mouseY;
			
			/**	1/4 씩 증가 or 감소	*/
			var zoom:Number = 0.25;
			if($mouseType == "zoomIn")
			{
				zoom = 0.75;
				
				TweenLite.to($model.pageArr[0], 0.75, {scaleX:zoom, scaleY:zoom, ease:Quad.easeOut});
				
				var mc:MovieClip = new MovieClip;
				mc.x = 0;
				TweenLite.to(mc, 0.75, {x:100, ease:Quad.easeOut, 
					onUpdate:move, onUpdateParams:[mc, zoom, prevX, prevY, prevWidth, prevHeight, tx, ty], 
					onComplete:zoomComplete});
			}
			else if($mouseType == "zoomOut") 
			{
				zoom = 0.25;
				TweenLite.to($model.pageArr[0], 0.75, {x:0, y:0, scaleX:zoom, scaleY:zoom, ease:Quad.easeOut, onUpdate:thumbUpdate});
				$model.pageScale = ($model.imgOriginW * zoom) / $con.plane.width;
			}
			
			$model.pageScale = ($model.imgOriginW * zoom) / $con.plane.width;
			$model.dispatchEvent(new KGCEvent(KGCEvent.THUMB_UPDATE));
//			if($mouseType == "zoomIn")
//			{
//				/**	최대값이면 리턴	*/
//				if($model.pageArr[0].scaleX >= 1) return;
//				else zoom = $model.pageArr[0].scaleX + 0.25;
//			}
//			else if($mouseType == "zoomOut") 
//			{
//				/**	최소값이면 리턴	*/
//				if($model.pageArr[0].scaleX <= 0.25) return;
//				else zoom = $model.pageArr[0].scaleX - 0.25;
//			}
//			/**	최대 & 최소 크기	*/
//			if(zoom <= 0.25) zoom = 0.25;
//			else if(zoom >= 1) zoom = 1;
		}
		/**	영역 벗어나지않게 설정	*/
		private function move(mc:MovieClip, zoom:Number, prevX:int, prevY:int, prevWidth:int, prevHeight:int, tx:int, ty:int):void
		{
			$isTween = true;
			$model.pageArr[0].x = int(prevX + int(prevWidth - $model.pageArr[0].width)/2);
			if($model.pageArr[0].x <= $con.plane.width - $model.pageArr[0].width)
			{
				$model.pageArr[0].x = $con.plane.width - $model.pageArr[0].width;
			}
			else if($model.pageArr[0].x >= 0)
			{
				$model.pageArr[0].x = 0;
			}
			
			$model.pageArr[0].y = int(prevY + (prevHeight - $model.pageArr[0].height)/2) ;
			if($model.pageArr[0].y <= $con.plane.height - $model.pageArr[0].height)
			{
				$model.pageArr[0].y = $con.plane.height - $model.pageArr[0].height;
			}
			else if($model.pageArr[0].y >= 0)
			{
				$model.pageArr[0].y = 0;
			}
			
			$model.pageScale = ($model.imgOriginW * zoom) / $con.plane.width;
			thumbUpdate();
		}
		/**	확대 축소 종료*/
		private function zoomComplete():void
		{
			$isTween = false;
		}
		/**	섬네일 크기 & 위치 업데이트	*/
		private function thumbUpdate():void
		{
			$model.thumbX = Math.abs($model.pageArr[0].x/(24.5*$model.pageArr[0].scaleX));
			$model.thumbY = Math.abs($model.pageArr[0].y/(24.5*$model.pageArr[0].scaleX));
			$model.dispatchEvent(new KGCEvent(KGCEvent.THUMB_UPDATE));
		}
		
		
		/**
		 * 드래그 줌
		 * */
		private function dragZoomHandler(e:MouseEvent):void
		{
			if($isDragZoom == false || $isTween == true) return;
			
			$rectStartX = $con.mouseX;
			$rectStartY = $con.mouseY;
			
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, drawRect);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, dragZoom);
		}
		/**	사각형 생성 크기 체크	*/
		private function drawRect(e:MouseEvent):void
		{
			var width:int = $con.mouseX - $rectStartX;
			var height:int = $con.mouseY - $rectStartY;
			
			if($rectStartX + width >= $con.plane.width) width = $con.plane.width - $rectStartX;
			if($rectStartY + height >= $con.plane.height) height = $con.plane.height - $rectStartY;
			
			$sp.graphics.clear();
			$sp.graphics.lineStyle(2, 0xff0000, 1);;
			$sp.graphics.drawRect($rectStartX, $rectStartY, width, height);
		}
		/**	영역 확대	*/
		private function dragZoom(e:MouseEvent):void
		{
			var zoom:Number;
			$rectEndX = $con.mouseX;
			
			$rectEndY = $con.mouseY;			
			var widthPercent:Number = 1 - ($sp.width / $con.plane.width);
			var heightPercent:Number = 1 - ($sp.height / $con.plane.height);
			if(widthPercent >= heightPercent) zoom = widthPercent;
			else zoom = heightPercent;
			zoom = zoom + $model.pageArr[0].scaleX;
			
			/**	최대 & 최소 크기	*/
			if(zoom <= 0.25) zoom = 0.25;
			else if(zoom >= 0.75) zoom = 0.75;
			
			$model.pageScale = ($model.imgOriginW * zoom) / $con.plane.width;
			$model.dispatchEvent(new KGCEvent(KGCEvent.THUMB_UPDATE));
			
			var redRectCenterX:Number;  
			if($rectStartX>$rectEndX) {
				redRectCenterX = $rectStartX- $sp.width/2;
			}else{
				redRectCenterX = $rectStartX+$sp.width/2;
			}

			var  redRectCenterY:Number ;
			if($rectStartY>$rectEndY){
				redRectCenterY = $rectStartY - $sp.height/2; 
			}else{
				redRectCenterY =	 $rectStartY+$sp.height/2 ;
			}
			trace("redRectCenterX: ",redRectCenterX);
			var  scaleOrigin:Number = 0.25;
			var scaleBig:Number = 0.25;
//			ratio=드래그했을때 얼느정도의 스케일로 할지	
//			mcOriginX = 드래그해서 늘어났을때의 빨간 사각형의 x위치 
			
			var mcWhenLongX:int = (redRectCenterX *zoom)/scaleOrigin;
			var mcWhenLongY:int = (redRectCenterY *zoom)/scaleOrigin;	
				
			var photoFrameCenterX:int  = $con.plane.width/2;
			var photoFrameCenterY:int  = $con.plane.height/2;
			
//			tx: 늘어났을때 움직일 거리(갭)
			var tx:int =photoFrameCenterX - mcWhenLongX;
			var ty:int  =photoFrameCenterY-mcWhenLongY;
			//늘어났을때 이미지가 -쪽으로 갈수있는 최대거리
			var maxW:int =$con.plane.width-$model.imgOriginW;
			var maxH:int =$con.plane.height-$model.imgOriginH;
			if(tx>0)
			{
				tx = 0;
			}else
			{
				if(tx<maxW) tx = maxW;
			}
			if(ty>0)
			{
				ty = 0;
			}
			else
			{
				if(ty<maxH) ty = maxH;
			}
			TweenLite.to($model.pageArr[0], 0.75, {scaleX:zoom, scaleY:zoom, x:tx , y:ty, ease:Quad.easeOut, onUpdate:thumbUpdate, onComplete:zoomComplete});
			
			$sp.graphics.clear();
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawRect);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, dragZoom);
			
			/**	드래그 줌 종료 드래그 시작	*/
			$isDragZoom = false;
			$isDrag = true;
			/**	줌 드래그버튼 활성화 제거	*/
			$model.dispatchEvent(new KGCEvent(KGCEvent.ZOOM_DRAGBTN_RESET));
			
			thumbUpdate();
		}		
		
		
		/**
		 * 카다로그 이동
		 * */
		/**	마우스 기준점 설정	*/
		private function setMousePoint(e:MouseEvent):void
		{
			if($isDrag == false) return;
			$con.hand.gotoAndStop(2);
			
			$setPointX = $con.mouseX;
			$setPointY = $con.mouseY;
			$catalogueX	 = $model.pageArr[0].x;
			$catalogueY = $model.pageArr[0].y;
			
			$isDown = true;
			$isMove = true;
		}
		private function checkMousePoint(e:MouseEvent):void
		{
			imgMoveCheck();
		}
		/**	이동 거리 체크	*/
		private function imgMoveCheck():void
		{
			$con.hand.x = $con.mouseX;
			$con.hand.y = $con.mouseY;
			if($isMove)
			{
				var imgX:int =$catalogueX + $con.mouseX - $setPointX;
				var imgY:int = $catalogueY + $con.mouseY - $setPointY;
				
				if(imgX > 0) imgX = 0;
				else if(imgX <= $con.plane.width - $model.pageArr[0].width) imgX = int($con.plane.width - $model.pageArr[0].width);
				
				if(imgY > 0) imgY = 0;
				else if(imgY <= $con.plane.height - $model.pageArr[0].height) imgY = int($con.plane.height - $model.pageArr[0].height);
				
				TweenLite.killTweensOf($model.pageArr[0]);
				TweenLite.to($model.pageArr[0], 0.5, {x:imgX, y:imgY, ease:Cubic.easeOut});
			}
			
			if($isDrag == true) thumbUpdate();
		}
		/**	마우스 이동 체크 중지	*/
		private function stopCheckMousePoint(e:MouseEvent):void
		{
			$con.hand.gotoAndStop(1);
			
			$isMove = false;
			$isDown = false;
		}
		/**	손바닥 보이기	*/
		private function showHand(e:MouseEvent):void
		{
			if($isDrag == false) return;
			Mouse.hide();
			TweenLite.to($con.hand, 0.5, {alpha:1});
		}
		/**	손바닥 숨기기	*/
		private function hideHand(e:MouseEvent):void
		{
			if($isDrag == false) return;
			Mouse.show();
			TweenLite.to($con.hand, 0.5, {alpha:0});
		}
	}
}