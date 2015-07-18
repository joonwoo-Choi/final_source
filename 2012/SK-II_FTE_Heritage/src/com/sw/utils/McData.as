package com.sw.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * 무비 클립에 현제 속성 내용 저장, 적용
	 * */
	public class McData
	{
		//static public var stateAry:Array;
		/**	생성자	 */
		public function McData()
		{
			//stateAry = ["dx","dy","dsX","dsY","dw","dh","da","dr","dd"];
		}
		/**	저장	*/
		static public function save($mc:Object):Boolean
		{
			if($mc.dx != null) return false;
			$mc.dx = $mc.x;
			$mc.dy = $mc.y;
			$mc.dsX = $mc.scaleX;
			$mc.dsY = $mc.scaleY;
			$mc.dw = $mc.width;
			$mc.dh = $mc.height;
			$mc.da = $mc.alpha;
			$mc.dr = $mc.rotation;
			if($mc.parent) $mc.dd = $mc.parent.getChildIndex($mc);
			
			return true;
		}
		/**	저장한 값으로 되돌리기	*/
		static public function re($mc:Object):Boolean
		{
			if($mc.dx == null) return false;
			$mc.x = $mc.dx;
			$mc.y = $mc.dy;
			$mc.scaleX = $mc.dsX;
			$mc.scaleY = $mc.dsY;
			$mc.width = $mc.dw;
			$mc.height = $mc.dh;
			$mc.alpha = $mc.da;
			$mc.rotation = $mc.dr;
			if($mc.parent) $mc.parent.addChildAt($mc,$mc.dd);
			
			return true;
		}
		static public function del($mc:MovieClip):Boolean
		{
			if($mc.dx == null) return false;
			$mc.dx = null;
			$mc.dy = null;
			$mc.dsX = null;
			$mc.dsY = null;
			$mc.dw = null;
			$mc.dh = null;
			$mc.da = null;
			$mc.dr = null;
			$mc.dd = null;
			
			return true;
		}
	}
}