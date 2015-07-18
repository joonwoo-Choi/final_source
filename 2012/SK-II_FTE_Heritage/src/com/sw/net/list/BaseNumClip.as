package com.sw.net.list
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 페이지 내용 표현 clip 어미 클래스
	 * */
	public class BaseNumClip extends MovieClip
	{
		protected var	no:int;
		public var obj:Object;
		public var txt:TextField;
		public var plane_mc:MovieClip;
		
		/**	생성자	*/
		public function BaseNumClip()
		{
			super();
		}
		/**	소멸자	*/
		public function destroy():void
		{}	
		/**	페이지 번호 적용	*/
		public function set idx($no:int):void
		{	
			no = $no;
			txt.text = String($no);
		}
		/**	페이지 번호 반환	*/
		public function get idx():int
		{	return no;	}
	}//class
}//package