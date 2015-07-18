package kb_model.modelScroll
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class PopupPageScroll extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	스크롤 바	*/
		private var $scroll:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	페이지 최대 이동 거리	*/
		private var $pageMaxY:Number;
		/**	버튼 갯수	*/
		private var $btnLength:int = 2;
		/**	y축 기본 값	*/
		private var $pointY:Number;
		/**	y축 이동 값	*/
		private var $moveY:Number;
		/**	다운 시 기준 Y값	*/
		private var $pageY:Number;
		
		private var $heightPercent:Number;
		/**	최대 스크롤 값	*/
		private var $maxScrollRange:Number;
		/**	버튼 클릭 시 페이지 이동 거리	*/
		private var $moveNum:int = 100;
		
		public function PopupPageScroll(con:MovieClip, range:Number)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$pageMaxY = range - $con.imgCon.height;
			
			/**	페이지 드래그	*/
			$con.imgCon.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			/**	버튼 이벤트	*/
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $con.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (target.no)
			{
				case 0 :
					imgMove($con.imgCon.y + $moveNum);
					break;
				case 1 :
					imgMove($con.imgCon.y - $moveNum);
					break;
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			/**	마우스 다운 시 기준 포인트 	*/
			$pointY = $con.stage.mouseY;
			/**	마우스 다운 시 기준 이미지 포인트	*/
			$pageY = $con.imgCon.y;
		}
		
		/**	마우스 이동 값 계산	*/
		private function mouseMoveHandler(e:MouseEvent):void
		{
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
			/**	이동 할 거리 계산	*/
			$moveY = ($con.stage.mouseY - $pointY);
			/**	현재 Y값에 이동거리 합산	*/
			var imgMoveNum:Number = $pageY + $moveY;
			
			imgMove(imgMoveNum);
			
		}
		
		private function imgMove(imgMoveNum:Number):void
		{
			/**	최대, 최소 Y값 정하기	*/
			if(imgMoveNum >=68 )
			{
				imgMoveNum = 68;
			}
			else if(imgMoveNum <= $pageMaxY)
			{
				imgMoveNum = $pageMaxY
			}
			TweenLite.to($con.imgCon, 1, {y:imgMoveNum, ease:Cubic.easeOut});
		}		
		
		
		private function removeDragHandler(e:MouseEvent):void
		{
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
		}
	}
}