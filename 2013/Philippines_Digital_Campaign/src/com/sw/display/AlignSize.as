package com.sw.display
{
	import flash.display.DisplayObject;

	/**		
	 * 이미지 크기 정렬
	 */
	public class AlignSize
	{
		/**	생성자	
		 * @param org	:: 사이즈 변동될 내용
		 * @param degree:: 기준 내용
		 * @param data	:: {pos:1=위치값 중앙,2=disDegree위치도 계산에 포함}
		 */
		public function AlignSize(disOrg:DisplayObject,disDegree:DisplayObject,data:Object = null)
		{
			if(data == null) data = new Object();
			
			if(data.size != false)
			{
				var dw:int = Math.round(disOrg.width);
				var dh:int = Math.round(disOrg.height);
			
				disOrg.width = Math.round(disDegree.width);
				disOrg.height = Math.round((dh/dw)*disDegree.width);
				
				if(disOrg.height < disDegree.height)
				{
					disOrg.height = Math.round(disDegree.height);
					disOrg.width = Math.round((dw/dh)*disDegree.height);
				}
			}
			
			if(data.pos != null)
			{
				disOrg.x = Math.round((disDegree.width - disOrg.width)/2);
				disOrg.y = Math.round((disDegree.height - disOrg.height)/2);
				if(data.pos == 2)
				{
					disOrg.x += disDegree.x;
					disOrg.y += disDegree.y;
				}
			}
		}
		
		
	}//class
}//package