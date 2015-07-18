package com.sw.display
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**	자식내용 모두 없에는 클래스	*/
	public class Remove extends BaseClass
	{
		/**	생성자	*/
		public function Remove($scope:Object, $data:Object=null)
		{
			super($scope, $data);
		}
		/**
		 * 오브젝트 하위 내용 지우기 
		 * @param $obj		::하위내용을 지울 내용
		 * 
		 */
		static public function child($obj:Object):void
		{
			if($obj == null) return;
			var dis:DisplayObjectContainer = $obj as DisplayObjectContainer;
			var cnt:int = dis.numChildren;
			for(var i:int =0; i<cnt; i++)
			{
				var del:DisplayObject = dis.getChildAt(0);
				//dis.removeChildAt(i);
				dis.removeChild(del);
				del = null;
			}
		}
		/**
		 * 오브젝트 상위 내용으로 부터 자신 지우기
		 * @param $obj		::		지워질 대상
		 * 
		 */
		static public function my($obj:Object):void
		{
			if($obj == null) return;
			var dis:DisplayObject = $obj as DisplayObject;
			if(dis.parent != null)
			{	
				dis.parent.removeChild(dis);	
			}
			dis = null;
		}
		/**
		 * 오브젝트 하위 내용과 자신 내용 지우기
		 * @param $obj		:: 지워질 대상
		 * 
		 */
		static public function all($obj:Object):void
		{
			if($obj == null) return;
			Remove.child($obj);
			Remove.my($obj);
		}
	}//class
}//package