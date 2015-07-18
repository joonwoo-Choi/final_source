package com.sw.display
{
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 화면 구성 기본 클래스
	 * */
	public class BaseLayout extends Sprite
	{
		/**	생성자	*/
		public function BaseLayout()
		{
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**
		 * 생성자
		 * */
		protected function init():void
		{
		
		}
		/**
		 * 로드된 오브젝트 안의 mc내용 반환 
		 * @param $obj	::	로드 container
		 * @return 		::	속 안의 mc
		 * 
		 */
		public function getMc($obj:DisplayObjectContainer):*
		{
			if($obj.numChildren == 0) return null;
			return ContentDisplay($obj.getChildAt(0)).rawContent;
		}
	}//class
}//package