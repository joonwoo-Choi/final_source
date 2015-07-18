package com.sw.buttons
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 자주 사용 되는 버튼 어미 클래스
	 * ***사용 불가*****
	 * */
	public class BtnClip extends MovieClip
	{
		public var over_mc:MovieClip;
		public var out_mc:MovieClip;
		public var txt_mc:MovieClip;
		public var txt:TextField;
		public var plane_mc:MovieClip;
		
		
		/**	생성자	*/
		public function BtnClip()
		{
			super();
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		
	}//class
}//package