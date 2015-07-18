package com.cj.display.effect
{
	import com.cj.interfaces.IBitmapEffect;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	
	public class TweenEffect implements IBitmapEffect
	{
		public function TweenEffect(){}
		
		public function execute(map:Bitmap, data:Object):void
		{
			var speed:Number = data.speed;
			var vars:Object = data.vars;
			
			TweenMax.to( map, speed, vars );
		}
	}
}