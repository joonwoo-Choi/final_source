package com.smirnoff.page
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Notice
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		public function Notice(con:MovieClip)
		{
			_con = con;
			_con.notice.y = _con.stage.stageHeight;
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			
			makeBtn();
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) == 0) return;
//			_con.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, noticeScrollHandler);
			_con.notice.btnSecurity.removeEventListener(MouseEvent.CLICK, securityHandler);
			_con.notice.btnDrink.removeEventListener(MouseEvent.CLICK, drinkHandler);
			_con.notice.y = _con.stage.stageHeight;
//			TweenLite.to(_con.notice, 1.5, {y:_con.stage.stageHeight, ease:Expo.easeOut});
		}
		
		private function makeBtn():void
		{
//			_con.stage.addEventListener(MouseEvent.MOUSE_WHEEL, noticeScrollHandler);
			_con.page0.btnArrow.buttonMode = true;
			_con.page0.btnArrow.addEventListener(MouseEvent.CLICK, showNotice);
			_con.notice.btnArrow.buttonMode = true;
			_con.notice.btnArrow.addEventListener(MouseEvent.CLICK, hideNotice);
			
			_con.notice.btnSecurity.buttonMode = true;
			_con.notice.btnSecurity.addEventListener(MouseEvent.CLICK, securityHandler);
			_con.notice.btnDrink.buttonMode = true;
			_con.notice.btnDrink.addEventListener(MouseEvent.CLICK, drinkHandler);
		}
		
		private function showNotice(e:MouseEvent):void
		{
			TweenLite.to(_con.notice, 1.5, {y:_con.stage.stageHeight - _con.notice.height, ease:Expo.easeOut});
		}
		
		private function hideNotice(e:MouseEvent):void
		{
			TweenLite.to(_con.notice, 1.5, {y:_con.stage.stageHeight, ease:Expo.easeOut});
		}
		
//		private function noticeScrollHandler(e:MouseEvent):void
//		{
//			switch (e.delta)
//			{
//				case 3 :
//					TweenLite.to(_con.notice, 1.5, {y:-_con.notice.height, ease:Expo.easeOut});
//					break;
//				case -3 :
//					TweenLite.to(_con.notice, 1.5, {y:0, ease:Expo.easeOut});
//					break;
//			}
//		}
		
		private function securityHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("https://www.facebook.com/SmirnoffKorea/app_1376702779221155"), "_blank");
		}
		
		private function drinkHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.drinkiq.com"), "_blank");
		}
	}
}