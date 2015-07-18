package kb_introduction.scrollPage
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollPage extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	스크롤 바	*/
		private var $scroll:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	페이지 최대 이동 거리	*/
		private var $pageMaxY:Number;
		/**	y축 기본 값	*/
		private var $pointY:Number;
		/**	y축 이동 값	*/
		private var $moveY:Number;
		/**	다운 시 기준 Y값	*/
		private var $pageY:Number;
		
		private var $heightPercent:Number;
		/**	최대 스크롤 값	*/
		private var $maxScrollRange:Number;
		
		public function ScrollPage(con:MovieClip, range:Number)
		{
			$con = con;
			
			$scroll = $con.parent.getChildByName("scroll") as MovieClip;
			
			$model = Model.getInstance();
			
			
			/**	스크롤 값 설정	*/
			$heightPercent = range / $con.imgCon.height;
			$maxScrollRange = $scroll.height - $scroll.bar.height;
			$pageMaxY = range - $con.imgCon.height;
			
			/**	페이지 드래그	*/
			$con.imgCon.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			/**	스크롤 이벤트 등록	*/
			$scroll.bar.buttonMode = true;
			$scroll.bar.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			/**	마우스 다운 시 기준 포인트 	*/
			$pointY = $con.stage.mouseY;
			/**	마우스 다운 시 기준 이미지 포인트	*/
			$pageY = $con.imgCon.y;
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
			/**	이동 할 거리 계산	*/
			$moveY = ($con.stage.mouseY - $pointY);
			/**	현재 Y값에 이동거리 합산	*/
			var imgMoveNum:Number = $pageY + $moveY;
			
			/**	최대, 최소 Y값 정하기	*/
			if(imgMoveNum >=0 )
			{
				imgMoveNum = 0;
			}
			else if(imgMoveNum <= $pageMaxY)
			{
				imgMoveNum = $pageMaxY
			}
			TweenLite.to($con.imgCon, 1, {y:imgMoveNum, ease:Cubic.easeOut});
			var scrollMoveYNum:Number = (imgMoveNum / $pageMaxY * $maxScrollRange);
			TweenLite.to($scroll.bar, 1, {y:scrollMoveYNum, ease:Cubic.easeOut});
		}
		
		private function removeDragHandler(e:MouseEvent):void
		{
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
		}
		
		/**	스크롤 바 이벤트 핸들러	*/
		private function scrollDownHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var rect:Rectangle = new Rectangle(0, 0, 0, $maxScrollRange);
			mc.startDrag(false,rect);
			mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollMoveHandler);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**	스크롤 마우스 이동 이벤트 핸들러	*/
		private function scrollMoveHandler(e:MouseEvent):void
		{
			var pageMoveYNum:Number = $scroll.bar.y / $maxScrollRange * $pageMaxY;
			TweenLite.to($con.imgCon, 1, {y:pageMoveYNum, ease:Cubic.easeOut});
		}
		
		/**	스크롤 마우스 업 이벤트 핸들러	*/
		private function mouseUpHandler(e:MouseEvent):void
		{
			$scroll.bar.stopDrag();
			$scroll.bar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollMoveHandler);
			$scroll.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
	}
}