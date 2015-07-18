package util
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LoadingMC extends Sprite
	{
		private var $mcLoading:MCLoading;
		public var test:int;
		public function LoadingMC()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			$mcLoading = new MCLoading;
			addChild($mcLoading);
			
			stage.addEventListener(Event.RESIZE,onResize);
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			onResize();
			
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void
		{
			stage.removeEventListener(Event.RESIZE,onResize);
		}
		
		public function arcAngle(num:Number):void{
			$mcLoading.txt.text = String(num);
			Arc.DrawSector($mcLoading.mcCircle,81+9,81+9,81,num*3.6,270,0xb10032);			
		}
		
		protected function onResize(event:Event=null):void
		{
			$mcLoading.x = (stage.stageWidth - $mcLoading.width)/2;
			$mcLoading.y = (stage.stageHeight - $mcLoading.height)/2;
		}
	}
}