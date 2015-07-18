package com.sw.display
{
	/**
	 * 20101113 이후 작성 되는 모든 유맅 클래스의 어미 클래스
	 * scope : 인자 값으로 초기에 받는 내용
	 * data : 인자 값으로 넘겨 받을 데이터 내용
	 * */
	public class BaseClass
	{
		protected var scope:Object;
		protected var data:Object;
		
		/**	생성자	*/
		public function BaseClass($scope:Object,$data:Object=null)
		{
			scope = $scope;
			data = new Object();
			if($data != null) data = $data;
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**	scope반환	*/
		public function get _scope():Object
		{	return scope;	}
		
	}//class
}//package