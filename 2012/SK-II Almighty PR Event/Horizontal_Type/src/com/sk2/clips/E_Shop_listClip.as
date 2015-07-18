package com.sk2.clips
{
	import com.sk2.utils.DataProvider;
	import com.sw.net.FncOut;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * SK2	::	E-SHOP 리스트 clip
	 * */
	public class E_Shop_listClip extends MovieClip
	{
		public var plane_mc:MovieClip;
		public var txt1:TextField;
		public var txt2:TextField;
		public var txt3:TextField;
		public var btn:MovieClip;
		public var mask_mc:MovieClip;
		
		/**	링크 주소	*/
		private var link_url:String;
		
		/**	생성자	*/
		public function E_Shop_listClip($link_url:String)
		{
			super();
			link_url = $link_url;
			init();
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**
		 * 초기화
		 * */
		private function init():void
		{
			DataProvider.baseSub.setBaseBtn(btn,onClickBtn);
		}
		private function onClickBtn($mc:MovieClip):void
		{
			FncOut.link(link_url,"_blank");
		}
	}//class
}//package