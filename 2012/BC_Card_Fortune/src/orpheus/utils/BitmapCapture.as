package orpheus.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapCapture
	{
		public function BitmapCapture()
		{
			super();
			
		}
		public static function makeBitmap(cover:Sprite,content:DisplayObject):Bitmap
		{
			// TODO Auto Generated method stub
			var originData:BitmapData = new BitmapData(content.width,content.height,true,0);//투명하게 복사하려면 fillColor을 0으로 해야한다.
			originData.draw(content);
			
			var bitmapdata:BitmapData = new BitmapData(content.width,content.height);
			var pt:Point = new Point(0,0);
			var rect:Rectangle = new Rectangle(0,0,content.width,content.height);//원본 0,0좌표에서 가로  세로지역을 캡쳐함
			bitmapdata.copyPixels(originData,rect,pt);
			//원본데이터에서 rect영역만큼 bitmapData의 pt좌표x:0,y:0 지역에 복사한 비트맵데이터를 붙인다.
			
			var copyBitmap:Bitmap = new Bitmap(bitmapdata);
			copyBitmap.smoothing = true;
			
			cover.addChild(copyBitmap);
			
			return copyBitmap;
		}
		
		public static function makeBitmap2(cover:Sprite):Bitmap
		{
			var originData:BitmapData = new BitmapData(cover.width,cover.height);
			originData.draw(cover);
			
			var bitmapdata:BitmapData = new BitmapData(cover.width,cover.height);
			var pt:Point = new Point(0,0);
			var rect:Rectangle = new Rectangle(0,0,cover.width,cover.height);//원본 0,0좌표에서 가로 160 세로30지역을 캡쳐함
			bitmapdata.copyPixels(originData,rect,pt);
			
			var copyBitmap:Bitmap = new Bitmap(bitmapdata);	
			return copyBitmap;
		}
		
	}
}