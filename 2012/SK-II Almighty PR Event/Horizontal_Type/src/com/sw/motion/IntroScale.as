package com.sw.motion
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.sw.display.BaseClass;
	import com.sw.utils.McData;
	
	import flash.display.MovieClip;

	/**
	 * 중심 축으로 크기 값이 작았다가 커지는 모습<br>
	 * ex : new IntroScale(mc,{dir:"none",ease:Expo.easeOut,complete:onComplete,speed:0.5,delay:0}
	 * */
	public class IntroScale extends BaseClass
	{
		/**	생성자	*/
		public function IntroScale($scope:Object,$data:Object)
		{
			super($scope,$data);
			init();	
		}
		/**	소멸자	*/
		override public function destroy():void
		{	
			super.destroy();
		}	
		/**
		 * 초기화
		 * */
		private function init():void
		{
			if(scope.dx == null) McData.save(scope);
			scope.x = (scope.dw/4)+scope.dx;
			scope.y = (scope.dh/4)+scope.dy;
			scope.width = scope.dw/2;
			scope.height = scope.dh/2;
			
			//하단에서 부터 올라오는 모습
			if(data.dir == "down") scope.y = (scope.dh/2)+scope.dy;
			var ease:Function = (data.ease != null) ? (data.ease) : Expo.easeOut;
			var speed:Number = (data.speed != null) ? (data.speed) : (0.5);
			var delay:Number = (data.delay != null) ? (data.delay) : (0);
			
			TweenMax.to(scope,speed,{
				overwrite:1,
				alpha:1,
				x:scope.dx,y:scope.dy,
				width:scope.dw,height:scope.dh,
				delay:delay,ease:ease,onComplete:onComplete});
		}
		/**	모션 완료후 함수 호출 	*/
		private function onComplete():void
		{
			if(data.complete) data.complete(scope);
		}
		
	}//class
}//package