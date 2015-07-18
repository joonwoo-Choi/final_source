package com.sk2.clips
{
	import com.sw.net.list.BaseNumClip;
	
	import flash.display.MovieClip;

	/**
	 * SK2	::	E-SHOP 날짜 clip
	 * */
	public class DateClip extends BaseNumClip
	{
		public var bubble_mc:MovieClip;
		
		/**	생성자	*/
		public function DateClip()
		{
			super();
		}
		/**	소멸자	*/
		override public function destroy():void
		{	
			super.destroy();	
		}
		
	}//class
}//package