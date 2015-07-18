package com.sw.display
{
	import flash.display.Sprite;
	/**
	 * 사각 박스 그래픽 생성
	 * */
	dynamic public class PlaneClip extends Sprite
	{
		
		/**
		 * 생성자 
		 * @param $data	::	{color:색}
		 * 
		 */
		public function PlaneClip($data:Object)
		{
			super();
			if($data == null) 
			{	trace("PlaneClip : 오류, data 인자 값이 없습니다.");		return;	}
			
			var dx:int = ($data.x != null) ? ($data.x) : (0);
			var dy:int = ($data.y != null) ? ($data.y) : (0);
			var dw:int = ($data.width != null) ? ($data.width) : (100);
			var dh:int = ($data.height != null) ? ($data.height) : (100);
			var color:uint = ($data.color != null) ? ($data.color) : (0x000000);
			var da:Number = ($data.alpha != null) ? ($data.alpha) : (1);
			
			this.graphics.beginFill(color,da);
			this.graphics.drawRect(0,0,dw,dh);		
			this.x = dx;
			this.y = dy;
			
		}
	}
}