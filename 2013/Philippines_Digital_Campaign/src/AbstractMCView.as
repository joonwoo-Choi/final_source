package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class AbstractMCView
	{
		protected var _model:Model;
		protected var _controler:Controler;
		
		protected var _mcView:MovieClip;
		
		public function AbstractMCView(mcView:MovieClip)
		{
			_mcView = mcView;
			_mcView.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			_mcView.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			_model = Model.getInstance();
			_controler = Controler.getInstance();
		}
		
		public function setting():void{
			
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			
			_mcView.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			
			_mcView.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
	}
}