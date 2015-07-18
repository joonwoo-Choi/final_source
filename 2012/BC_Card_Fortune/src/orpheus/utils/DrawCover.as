package orpheus.utils
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class DrawCover
	{
		public function DrawCover()
		{
			super();
			
		}
		public static function line(g:Graphics, sw:int, sh:int, limitW:int, limitH:int):void
		{
			var color:uint = 0xffffff;
			var ap:Number = 1;
			
			g.clear();
			g.beginFill(color, ap);
			g.drawRect(0,0,sw,sh);
			g.drawRect( (sw-limitW) >> 1, (sh-limitH) >> 1, limitW, limitH );
			g.endFill();
		}		
	}
}