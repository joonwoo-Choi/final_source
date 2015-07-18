package com.sw.utils
{
	import flash.display.Stage;
	/**	Stage내용 전체 공용으로 사용할 클래스	*/
	public class DataProvider
	{
		/**	최상위 DisplayObject	*/
		static public var stage:Stage;
		/**	생성자	*/
		public function DataProvider()
		{}
		/**	Stage 설정	*/
		static public function setStage($scope:Object):void 
		{
			stage = $scope.stage;
		} 
		
	}//class
}//package