package com.sw.display
{
	import com.adqua.ui.AdquaContext;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * 컨텍스트 메뉴 클래스
	 * */
	public class ContextMenu
	{
		/**	생성자	*/	
		public function ContextMenu()
		{
			super();
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**	
		 *  컨텍스트 메뉴 추가
		 * @param $scope	::	컨텍스트메뉴 표시 오브젝트
		 * 
		 */
		static public function setMenu($scope:DisplayObjectContainer):void
		{
			AdquaContext.addContextMenu($scope);
			$scope.stage.showDefaultContextMenu  = false;
		}	
		
	}//class
}//package