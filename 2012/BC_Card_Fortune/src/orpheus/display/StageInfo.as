package orpheus.display 
{
	import flash.events.Event;	
	import flash.display.Stage;	
	import flash.geom.Rectangle;
	
	/**
	 * @author p2ri
	 */
	public class StageInfo extends Rectangle 
	{
		public var stage:Stage;
		private var workWidth:uint;
		private var workHeight:uint;
		public static var obj:StageInfo;

		public function StageInfo(stage:Stage, workWidth:uint = 0, workHeight:uint = 0)
		{
			super();
			
			this.workHeight = workHeight;
			this.workWidth = workWidth;
			this.stage = stage;
			
			resizeHandler();
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			obj = this;
		}
		
		private function resizeHandler(event:Event = null):void
		{
			if (stage.align.search("L") != -1)
			{
				x = 0;
			}
			else if (stage.align.search("R") != -1)
			{
				x = workWidth - stage.stageWidth;
			}
			else
			{
				x = (workWidth - stage.stageWidth) * .5;
			}
			
			if (stage.align.search("T") != -1)
			{
				y = 0;
			}
			else if (stage.align.search("B") != -1)
			{
				y = workHeight - stage.stageHeight;
			}
			else
			{
				y = (workHeight - stage.stageHeight) * .5;
			}
			
			width = stage.stageWidth;
			height = stage.stageHeight;
		}

		public function dispose():void
		{
			stage.removeEventListener(Event.RESIZE, resizeHandler);
			stage = null;
		}
	}
}