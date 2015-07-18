package util
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class LoadingTest extends Sprite
	{
		private var $loading:LoadingMC;
		public function LoadingTest()
		{
			super();
			$loading = new LoadingMC;
			addChild($loading);
			TweenLite.to($loading,2,{test:100,delay:1,onUpdate:loadingTest});
		}
		
		private function loadingTest():void
		{
			// TODO Auto Generated method stub
			$loading.arcAngle($loading.test);
		}
	}
}