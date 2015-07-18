package com.cj.application
{
	import com.cj.utils.StageUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 메인 애플리케이션 
	 * @author cj
	 * 
	 */	
	public class MainApplication extends Sprite
	{
		public function MainApplication()
		{
			super();
			
			if(stage) onStage();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// 스테이지 초기화
			StageUtil.setDefault(this);
			StageUtil.setContextMenu(this);
			
			// 초기화
			defaultSetting();
		}
		
		/**
		 * 초기화 
		 * 
		 */		
		protected function defaultSetting():void
		{
			// override
		}
		
	}
}