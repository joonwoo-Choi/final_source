package com.sw.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 화면 제정렬 클래스
	 * */
	public class BaseResize extends Sprite
	{
		protected var scope:DisplayObjectContainer;
		/**	윈도우 넓이	*/
		public var sw:Number;
		/**	윈도우 높이	*/
		public var sh:Number;
		/**	넓이 최소값	*/
		protected var swMin:int;
		/**	높이 최소값	*/
		protected var shMin:int;
		
		
		/**	생성자	*/
		public function BaseResize($scope:DisplayObjectContainer)
		{
			scope = $scope;
		}
				
		/**	소멸자	*/
		public function destroy():void
		{
			stage.removeEventListener(Event.RESIZE,onResize);
		}
		/**	
		 * 초기화	
		 * */
		protected function init():void
		{
			setMin(1000,600);
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			scope.addChild(this);
		}
		/**	윈도우 최소값 설정	*/
		public function setMin($sw:int,$sh:int):void
		{
			swMin = $sw;
			shMin = $sh;
		}
		/**
		 * 화면에 붙고 난후에 수행 내용
		 * */
		protected function onAdd(e:Event):void
		{
			stage.addEventListener(Event.RESIZE,onResize);
			
			stage.dispatchEvent(new Event(Event.RESIZE));
			//stage.removeEventListener(Event.RESIZE,onResize);
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		/**
		 * 화면 사이즈 조절시 수행
		 * */
		protected function onResize(e:Event):void
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			if(sw < swMin) sw = swMin;
			if(sh < shMin) sh = shMin;
		}
	}//class
}//package