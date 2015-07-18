package com.proof.kiosk.popup
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MainPopup
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		public function MainPopup(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			$con = con;
			$con.visible = false;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.SHOW_POPUP, showPopup);
		}
		
		private function showPopup(e:Event):void
		{
			$con.gotoAndStop($model.weekNum);
			makeButton();
			$con.userName.text = $model.userName;
			TweenLite.to($con, 0.75, {autoAlpha:1});
		}
		
		private function makeButton():void
		{
			$con.btn.addEventListener(MouseEvent.CLICK, closePopup);
		}
		
		private function closePopup(e:MouseEvent):void
		{
			TweenLite.to($con, 0.75, {autoAlpha:0});
			$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_MAIN));
//			$model.dispatchEvent(new ModelEvent(ModelEvent.SET_FOCUS_BARCODE));
		}
	}
}