package com.adqua.moviePlayer.ctrler
{
	import com.adqua.moviePlayer.ModelPlayer;

	public class Ctrler
	{
		protected var _model:ModelPlayer;
		public function Ctrler()
		{
			_model = ModelPlayer.getInstance();
		}
	}
}