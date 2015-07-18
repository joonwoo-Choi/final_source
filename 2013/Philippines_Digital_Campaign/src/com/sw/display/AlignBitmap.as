package com.sw.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * 
	 * Bitmap 데이터 일정 크기로 잘라서 반환
	 * */
	public class AlignBitmap
	{
		/**	생성자	*/
		public function AlignBitmap()
		{
			
		}
		
		/**	Bitmap 제작 시작	
		 * @param $bit
		 * @param $mw
		 * @param $mh
		 * @param $data :: limit:"out","in",bgColor:
		 * @return 
		 * 
		 */
		static public function go($bit:Bitmap,$mw:int,$mh:int,$data:Object = null):Bitmap
		{
			if($data == null) $data = new Object();
			
			var limit:String = ($data.limit == null) ? ("out") : ($data.limit);
			var bgColor:uint = ($data.bgColor == null) ? (0xff000000) : ($data.bgColor);
			
			var dw:int = Math.round($bit.width);
			var dh:int = Math.round($bit.height);
			
			$bit.width = $mw;
			$bit.height = Math.round((dh/dw)*$mw);
			
			if( ( $bit.height < $mh && limit == "out") ||
				( $bit.height > $mh && limit == "in") )
			{
				$bit.height = $mh;
				$bit.width = Math.round((dw/dh)*$mh);
			}
			
			$bit.x = Math.round(($mw - $bit.width)/2);
			$bit.y = Math.round(($mh - $bit.height)/2);
			
			var bitData:BitmapData = new BitmapData($mw,$mh,false,bgColor);
			
			var sp:Sprite = new Sprite();
			sp.addChild($bit);
			
			bitData.draw(sp);
			
			var re_bit:Bitmap = new Bitmap(bitData);
			re_bit.smoothing = true;
			
			Remove.all(sp);
			
			return re_bit;
		}
		
	}//class
}//package