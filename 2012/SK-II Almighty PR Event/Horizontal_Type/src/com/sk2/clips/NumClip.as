package com.sk2.clips
{
	import com.sw.net.list.BaseNumClip;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 리스트 페이지 클래스
	 * */
	public class NumClip extends BaseNumClip
	{
		public var bubble_mc:MovieClip;
		
		/**	생성자	*/
		public function NumClip()
		{
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		
	}//class
}//package