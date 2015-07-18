package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class AbstractMain extends Sprite
	{
		protected var _model:Model;
		protected var _controler:Controler;
		public function AbstractMain()
		{
			_model = Model.getInstance();
			_controler = Controler.getInstance();
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
	}
}