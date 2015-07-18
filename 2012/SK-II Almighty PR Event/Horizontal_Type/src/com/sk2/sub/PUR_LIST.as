package com.sk2.sub
{
	import com.sk2.net.CLEAR_LIST;
	import com.sk2.utils.DataProvider;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * PUR 리스트
	 * */
	public class PUR_LIST extends BaseSub
	{
		private var clear_list:MovieClip;
		private var list:CLEAR_LIST;
		
		/**	생성자	*/
		public function PUR_LIST($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			clear_list = scope_mc.clear_list;
			
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**
		 * 물결 효과 후 초기화
		 * */
		override public function init():void
		{
			list = new CLEAR_LIST(clear_list,DataProvider.dataURL+"/Xml/PurList.aspx",{});
			
		}
	}//class
}//package