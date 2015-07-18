package com.sw.display
{
	import com.greensock.layout.ScaleMode;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * 초기 내용 클래스
	 * */
	public class BaseIndex extends Sprite
	{
		/**	생성자	*/
		public function BaseIndex()
		{
			super();
			trace("index 생성자");
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);	
		}
		/**	소멸자	*/
		public function destroy(e:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,destroy);	
			//trace("소멸자호출");
		}
		/**
		 * 초기화
		 * */
		protected function init():void
		{
			this.mouseEnabled = false;
		}
		/**
		 *	화면에 붙고 난후에 수행 내용
		 * */
		protected function onAdd(e:Event):void
		{
			//ContextMenu.setMenu(this);
			stage.stageFocusRect = false;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			this.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
		}
		
	}//class
}//package