package com.adqua.display
{
	import flash.display.MovieClip;
	
	public class Resize
	{
		/**	대상	*/
		private var $target:MovieClip;
		/**	대상 넓이 값 */
		private var $tw:int;
		/**	대상 높이 값 */
		private var $th:int;
		/**	윈도우 넓이	*/
		private var $sw:Number;
		/**	윈도우 높이	*/
		private var $sh:Number;
		/**	넓이 최소 값	*/
		private var $swMin:int;
		/**	높이 최소 값	*/
		private var $shMin:int;
		/**	X축 정렬 여부	*/
		private var $rePosX:Boolean = true;
		/**	Y축 정렬 여부	*/
		private var $rePosY:Boolean = true;
		
		public function Resize()
		{		}
		
		/**	스테이지 리사이즈	*/
		public function stageResize(target:MovieClip, sw:int, sh:int, swMin:int=0, shMin:int=0, rePosX:Boolean=true, rePosY:Boolean=true):void
		{
			/**	가로 값 조정	*/
			if(sw > swMin) target.width = sw;
			else target.width = swMin;
			/**	세로 값 조정	*/
			if(sh > shMin) target.height = sh;
			else target.height = shMin;
			/**	비율 조정	*/
			target.scaleX = target.scaleY = Math.max(target.scaleX, target.scaleY);
			/**	정렬	*/
			if(rePosX) target.x = int(sw/2 - target.width/2);
			if(rePosY) target.y = int(sh/2 - target.height/2);
		}
		
		/**	X축 가운데 정렬 	*/
		public function arrangeX(target:MovieClip, value:int):void
		{
			if(target.stage.stageWidth > value) target.x = int(target.stage.stageWidth/2 - target.width/2);
			else target.x = int(value/2 - target.width/2);
		}
		
		/**	Y축 가운데 정렬 	*/
		public function arrangeY(target:MovieClip, value:int):void
		{
			if(target.stage.stageHeight > value) target.y = int(target.stage.stageHeight/2 - target.height/2);
			else target.y = int(value/2 - target.height/2);
		}
	}
}