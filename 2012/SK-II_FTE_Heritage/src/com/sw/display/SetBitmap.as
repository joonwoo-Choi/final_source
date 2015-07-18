package com.sw.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SetBitmap extends Sprite
	{
		//public var bmp:Bitmap;
		//public var bmpData:BitmapData;
		/**	생성자	*/
		public function SetBitmap()
		{
			super();			
		}
		/**	소멸자	*/
		public function destroy():void
		{		}	
			
		public static function go($mc:MovieClip,$smooth:Boolean=false,$alpha:uint = 0x00ffffff):Bitmap
		{
			if(!$mc) return null;
			var shape:DisplayObject = $mc.getChildAt(0) as DisplayObject;
			//trace(shape.width);
			var rect:Rectangle = shape.getRect(shape);
			var point:Point = new Point(shape.x+rect.x,shape.y+rect.y);
			shape.x = rect.x*-1;
			shape.y = rect.y*-1;
			
			var bool:Boolean = true;
			
			if($alpha != 0x00ffffff) bool = false;
			
			var bmpData:BitmapData = new BitmapData(shape.width,shape.height,bool,$alpha);
			
			bmpData.draw(shape.parent);
			var bmp:Bitmap = new Bitmap(bmpData);
			bmp.x = point.x;
			bmp.y = point.y;
			bmp.smoothing = $smooth;
			
			$mc.removeChild(shape);
			$mc.addChild(bmp);
			
			return bmp;
		}
		
	}//class
}//package