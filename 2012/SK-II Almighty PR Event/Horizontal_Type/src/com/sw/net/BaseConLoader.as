package com.sw.net
{
	import com.greensock.TweenMax;
	import com.greensock.loading.LoaderMax;
	import com.sw.display.BaseLayout;
	import com.sw.display.BaseResize;
	
	import flash.display.MovieClip;

	/**
	 * 전체 제어 로더 클래스
	 * */
	public class BaseConLoader
	{
		protected var rootURL:String = "http://hertest.purepitera.co.kr/swf/test/hori/";
		
		protected var loader:LoaderMax;
		
		protected var loading_mc:MovieClip;
		/**	기본 로딩바 등장,아웃 모션 사용 여부	*/
		protected var bLoadingMove:Boolean;
		
		/**	생성자	*/
		public function BaseConLoader()
		{
			bLoadingMove = true;
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**
		 * 초기화
		 * */
		protected function init():void
		{
			
		}
		/**
		 * 로딩바 보여지기
		 * @param $move	::	기본 등장 모션 사용할지 여부
		 */
		protected function viewLoading():void
		{
			if(loading_mc == null) return;
			loading_mc.visible = true;
			
			if(bLoadingMove == true)
				TweenMax.to(loading_mc,0.5,{alpha:1,scaleX:1,scaleY:1,onComplete:finishLoading});
		}
		/**
		 * 로딩바 사라지기
		 * @param $move	::	기본 등장 모션 사용할지 여부
		 */
		protected function hideLoading():void
		{
			if(loading_mc == null) return;
			
			if(bLoadingMove == true)
				TweenMax.to(loading_mc,0.5,{alpha:0,scaleX:0.5,scaleY:0.5,onComplete:finishLoading});
		}
		protected function finishLoading():void
		{
			if(loading_mc.alpha == 0) loading_mc.visible = false;
		}
	}//class
}//package