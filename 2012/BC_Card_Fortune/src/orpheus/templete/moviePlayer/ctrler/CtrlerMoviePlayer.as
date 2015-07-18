package orpheus.templete.moviePlayer.ctrler
{
	import orpheus.templete.moviePlayer.ModelPlayer;

	public class CtrlerMoviePlayer
	{
		protected var _model:ModelPlayer;
		private static var main:CtrlerMoviePlayer;
		public function CtrlerMoviePlayer()
		{
			_model = ModelPlayer.getInstance();
		}
		public static function getInstance():CtrlerMoviePlayer{
			if(!main)main = new CtrlerMoviePlayer;
			return main;
		}
	}
}