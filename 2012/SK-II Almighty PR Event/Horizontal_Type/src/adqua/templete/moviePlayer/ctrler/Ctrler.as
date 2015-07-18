package adqua.templete.moviePlayer.ctrler
{
	import adqua.templete.moviePlayer.ModelPlayer;

	public class Ctrler
	{
		protected var _model:ModelPlayer;
		public function Ctrler()
		{
			_model = ModelPlayer.getInstance();
		}
	}
}