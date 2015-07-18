package museList
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ReviewPage extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	최대 스크롤 값	*/
		private var $maxScrollRange:Number;
		/**	페이지 최대 이동 거리	*/
		private var $pageMaxY:Number;
		/**	휠 이동 거리	*/
		private var $moveLength:int = 100;
		
		public function ReviewPage(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	리뷰 페이지 보이기	*/
			$model.addEventListener(ModelEvent.REVIEW_PAGE_VIEW, pageViewHandler);
			/**	리뷰 페이지 닫기	*/
			$model.addEventListener(ModelEvent.REVIEW_PAGE_CLOSE, removeEvent);
		}
		
		protected function pageViewHandler(e:Event):void
		{
			TweenMax.to($con, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			
			/**	스크롤 값 설정	*/
			$maxScrollRange = $con.scrollBar.height - $con.scrollBar.scroll.height;
			$pageMaxY = $con.planeMC.height - $con.imgCon.height;
			
			makeBtn();
		}	
		
		private function makeBtn():void
		{
			/**	마우스 휠 이벤트 등록	*/
			$con.stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			
			/**	스크롤 이벤트 등록	*/
			$con.scrollBar.scroll.buttonMode = true;
			$con.scrollBar.scroll.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
			
			/**	리뷰 페이지 닫기 핸들러	*/
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function wheelHandler(e:MouseEvent):void
		{
			if(e.delta < 0)
			{
				pageMoveHandler("down");
			}
			else
			{
				pageMoveHandler("up");
			}
			var ldr:Loader = $con.imgCon.getChildAt(0) as Loader;
		}
		
		/**	페이지 이동 	*/
		private function pageMoveHandler(move:String):void
		{
			var moveYNum:Number;
			switch (move)
			{
				case "down" :
					moveYNum = $con.imgCon.y - $moveLength;
					if(moveYNum <= $pageMaxY)
					{
						moveYNum = $pageMaxY;
					}
					break;
				case "up" :
					moveYNum = $con.imgCon.y + $moveLength;
					if(moveYNum >= 0)
					{
						moveYNum = 0;
					}
					break;
			}
			TweenLite.to($con.imgCon, 1, {y:moveYNum, ease:Expo.easeOut});
			var scrollMoveYNum:Number = (moveYNum / $pageMaxY * $maxScrollRange);
			TweenLite.to($con.scrollBar.scroll, 1, {y:scrollMoveYNum, ease:Expo.easeOut});
			trace("$con.imgCon.y: "+$con.imgCon.y);
			trace("scrollMoveYNum: "+scrollMoveYNum);
			trace("$con.imgCon.y: "+$con.imgCon.getChildAt(0).visible);
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
			var pageMoveYNum:Number = $con.scrollBar.scroll.y / $maxScrollRange * $pageMaxY;
			TweenLite.to($con.imgCon, 1, {y:pageMoveYNum, ease:Expo.easeOut});
		}
		
		/**	스크롤 마우스 업 이벤트 핸들러	*/
		private function mouseUpHandler(e:MouseEvent):void
		{
			$con.scrollBar.scroll.stopDrag();
			$con.scrollBar.scroll.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollMoveHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**	클로즈 버튼 핸들러	*/
		private function closeHandler(e:MouseEvent):void
		{
			removeEvent();
			
			/**	리스트 롤링 시작	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_START));
			trace("::::: 리뷰 페이지 닫기 :::::");
		}
		
		private function removeEvent(e:Event = null):void
		{
			/**	리뷰 페이지 숨기기	*/
			TweenMax.to($con, 1.2, {autoAlpha:0, ease:Cubic.easeOut, onComplete: imgConReset});
			/**	마우스 이벤트 제거	*/
			$con.scrollBar.scroll.removeEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
			$con.btnClose.removeEventListener(MouseEvent.CLICK, closeHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		/**	초기화	*/
		private function imgConReset():void
		{
			/**	Y값 초기화	*/
			$con.imgCon.y = 1;
			$con.scrollBar.scroll.y = 0;
			/**	리뷰 페이지 제거	*/
			if($con.imgCon.numChildren == 0) return;
			var ldr:Loader = $con.imgCon.getChildAt(0) as Loader;
			ldr.unloadAndStop();
			ldr = null;
			$con.imgCon.removeChildAt(0);
			trace(":::::리뷰페이지 제거: "+$con.imgCon.numChildren);
		}
	}
}