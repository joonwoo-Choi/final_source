package orpheus.movieclip
{
	import flash.display.Sprite;
	
	public class TestButton
	{
		public function TestButton()
		{
			super();
			
		}
		public static function btn(bw:int=20,bh:int=20,color:uint=0xff0000):Sprite
		{
			var btn:Sprite = new Sprite;
			btn.graphics.beginFill(color);
			btn.graphics.drawRect(0,0,bw,bh);
			btn.graphics.endFill();
			return btn;
		}		
	}
}