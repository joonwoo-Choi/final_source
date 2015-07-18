package com.sk2.sub
{
	
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	
	public class PITERA_ESSENCE_PRODUCT extends BaseSub
	{
		/**	생성자	*/
		public function PITERA_ESSENCE_PRODUCT($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			trace("Sub3_1");
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			scope_mc.bg_img.light.visible = false;
		}	
		override public function init():void
		{
			TweenMax.to(scope_mc.bg_img,2,{alpha:1});
		}	
			
	}//class
}//package