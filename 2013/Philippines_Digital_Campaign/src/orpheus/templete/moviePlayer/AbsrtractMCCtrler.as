package orpheus.templete.moviePlayer
{
	import orpheus.templete.moviePlayer.ctrler.CtrlerMoviePlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class AbsrtractMCCtrler
	{
		protected var _con:MoviePlayer;
		protected var _model:ModelPlayer;
		protected var _ctrler:CtrlerMoviePlayer;
		public function AbsrtractMCCtrler(mc:MoviePlayer)
		{
			_con = mc;
			_model = ModelPlayer.getInstance();
			_ctrler = CtrlerMoviePlayer.getInstance();
			_con.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			_con.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			_ctrler = null;
			_model = null;
			_con.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			
			_con.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
	}
}