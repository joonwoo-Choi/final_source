package util
{
	import com.sw.display.Remove;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/**		
	 *	SK2_Hersheys :: 영상 위 점 내용 균일하게 복제
	 */
	public class MovieDot
	{
		/**	생성자	*/
		public function MovieDot()
		{}
		/**
		 * 점 내용 일정 크기로 반복해서 그리기 
		 * @param mc :: 점 MovieClip
		 * @param dw :: 넓이
		 * @param dh :: 높이
		 */		
		static public function go(mc:MovieClip,dw:int,dh:int):void
		{
			var mcW:int = mc.width+1;
			var mcH:int = mc.height+1;
			
			var bitData:BitmapData = new BitmapData(mcW-1,mcH-1,true,0x00ffffff);
			
			bitData.draw(mc);
			Remove.child(mc);
			
			var wNum:int = Math.round((dw)/mcW)
			var hNum:int = Math.round(dh/mcH);
			
			for(var i:int = 0; i< wNum; i++)
			{
				for(var j:int = 0; j< hNum; j++)
				{
					var bit:Bitmap = new Bitmap(bitData);
					mc.addChild(bit);
					bit.x = i*mcW;
					bit.y = j*mcH;
				}
			}
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
		}
		
	}//class
}//package