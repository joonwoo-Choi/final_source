package com.bc.main.popup
{
	
	import com.bc.model.Model;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.utils.ButtonUtil;
	import com.utils.JavaScriptUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class PopupGuide
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		public function PopupGuide(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
		}
		/**	이벤트 가이드, 룰 팝업	*/
		public function makeButton():void
		{
			ButtonUtil.makeButton($con.popup.btn, btnHandler);
		}
		/**	버튼 핸들러	*/
		private function btnHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					break;
				case MouseEvent.MOUSE_OUT : 
					break;
				case MouseEvent.CLICK :
					if($con.popup.currentFrame <= 2)
					{
						TweenMax.to($con.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
						TweenMax.to($con.block, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
						ButtonUtil.removeButton($con.popup.btn, btnHandler);
					}
					else
					{
						JavaScriptUtil.call("trace", "eco_clear");
						JavaScriptUtil.call("eventClear");
						TweenMax.to($con.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
						ButtonUtil.removeButton($con.popup.btn, btnHandler);
					}
					trace(e.target.name);
					break;
			}
		}
		
		/**	*/
	}
}