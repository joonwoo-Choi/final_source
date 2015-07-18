package com.toto.popup
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.toto.model.ToToModel;
	import com.toto.model.ToToEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Popup extends Sprite
	{
		
		private var $con:MovieClip;
		
		private var $model:ToToModel;
		
		public function Popup(con:MovieClip)
		{
			$con = con;
			
			$model = ToToModel.getInstance();
			
			$con.blockCon.visible = false;
			$con.popup.visible = false;
			
			$model.addEventListener(ToToEvent.COMPLETE_POPUP, completePopupHandler);
			
//			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
//			resizeHandler();
		}
		
		private function completePopupHandler(e:Event):void
		{
			$con.popup.gotoAndStop(3);
//			resizeHandler();
			TweenMax.to($con.popup, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			$con.popup.comPopup.gotoAndPlay(1);
			
			for (var i:int = 0; i < 2; i++) 
			{
				var mc:MovieClip = $con.popup.getChildByName("btn" + i) as MovieClip;
				mc.buttonMode = true;
				mc.no = i;
				mc.addEventListener(MouseEvent.CLICK, completeBtnClickHandler);
			}
		}
		
		private function completeBtnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (target.no)
			{
				case 0 :
//					$model.dispatchEvent(new ToToEvent(ToToEvent.GO_MAIN_SHOW, true));
					$con.dispatchEvent(new ToToEvent(ToToEvent.GO_HOME, true));
					break;
				case 1 :
//					$model.dispatchEvent(new ToToEvent(ToToEvent.GO_SUB1_SHOW, true));
					$con.dispatchEvent(new ToToEvent(ToToEvent.GO_EVENT_ONE, true));
					break;
			}
			$con.popup.btn0.removeEventListener(MouseEvent.CLICK, completeBtnClickHandler);
			$con.popup.btn1.removeEventListener(MouseEvent.CLICK, completeBtnClickHandler);
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$con.popup.x = int($con.stage.stageWidth/2 - $con.popup.widrh/2);
//			$con.popup.y = int($con.stage.stageHeight/2 - $con.popup.height/2);
		}
	}
}