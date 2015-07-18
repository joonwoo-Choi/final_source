package com.sk2.ui
{
	import com.greensock.TweenMax;
	import com.sk2.sub.BaseSub;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.utils.Popup;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2		::		팝업 내용
	 * */
	public class Popup extends com.sw.utils.Popup
	{
		private var baseSub:BaseSub;
		
		/**	생성자	*/
		public function Popup($scope:Object, $data:Object=null)
		{
			super($scope, $data);
			
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			baseSub = new BaseSub(scope as DisplayObjectContainer);	
		}
		/**
		 * 초기화
		 * */
		override protected function init():void
		{
			super.init();

		}
		/**	보여지는 모션	*/
		override protected function introView():void
		{
			lock_mc.alpha = 0;
			TweenMax.to(lock_mc,0.5,{alpha:lock_alpha});
			DataProvider.baseSub.viewBlurObj(body_mc);
		
		}
		/**	사라지는 모션	*/
		override protected function introHide():void
		{
			DataProvider.baseSub.viewBlurObj(body_mc,finishHide,null,0);
		}
		override protected function setClose():void
		{
			Button.setUI(body_mc.close_btn,{click:onClickClose2});
		}
		private function onClickClose2($mc:MovieClip):void
		{	hidePop();	}
		
		public function alert():void
		{
			body_mc.close_btn.visible = false;
			DataProvider.baseSub.setBaseBtn(body_mc.btn,onClickClose2);
			var txt:TextField = body_mc.txt;
			txt.autoSize = TextFieldAutoSize.LEFT;
			body_mc.txt.text = viewData.txt;
			SetText.space(txt,{letter:-1.5,leading:-3});
			txt.y = Math.round((body_mc.plane_mc.height - txt.height)/2)-20;
		}
		public function alert_destroy():void
		{
			body_mc.close_btn.visible = true;
		};
		public function gallery():void
		{}
		public function gallery_destroy():void
		{}
	}//class
}//package