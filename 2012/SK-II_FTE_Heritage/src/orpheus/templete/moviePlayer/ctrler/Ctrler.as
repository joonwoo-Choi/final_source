package orpheus.templete.moviePlayer.ctrler
{
	import orpheus.templete.moviePlayer.ModelPlayer;

	public class Ctrler
	{
		protected var _model:ModelPlayer;
		public function Ctrler()
		{
			_model = ModelPlayer.getInstance();
		}
	}
}