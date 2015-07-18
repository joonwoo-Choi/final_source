package eventPop
{
	
	import com.adqua.net.Debug;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import pEvent.PEventCommon;

	[SWF(width="961",height="541",frameRate="30")]
	
	public class EventPop extends AbstractMain
	{
		
		private var $evtPop:PHL_EventPopup;
		/**	탭버튼 수	*/
		private var $btnTabLength:int = 2;
		/**	탭버튼 배열	*/
		private var $btnTabArr:Array;
		/**	활성된 메뉴 번호	*/
		private var $activeNum:int;
		/**	상품 수	*/
		private var $giftLength:int = 5;
		
		public function EventPop()
		{
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, ColorTransformPlugin]);
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			$evtPop = new PHL_EventPopup;
			addChild($evtPop);
			$evtPop["hpCover"].mouseEnabled = false;
			$evtPop["hpCover"].mouseChildren = false;
			$evtPop.btnTab0.bg.alpha=0;
			$evtPop.evtCon0.gotoAndPlay(2)
				
			if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_event1");
			
			Model.getInstance().addEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			
			makeButton();
		}
		/**	버튼 만들기	*/
		private function makeButton():void
		{
			$btnTabArr = [];
			for (var i:int = 0; i < $btnTabLength; i++) 
			{
				/**	상단 탭버튼	*/
				var btns:MovieClip = $evtPop.getChildByName("btnTab" + i) as MovieClip;
				$btnTabArr.push(btns);
				btns.btn.no = i;
				ButtonUtil.makeButton(btns.btn, btnTabHandler);
				
				/**	이벤트 참여버튼	*/
				var btnEvt:MovieClip = $evtPop.getChildByName("evtCon" + i) as MovieClip;
				btnEvt.btnEvt.no = i;
				ButtonUtil.makeButton(btnEvt.btnEvt, btnEvtHandler);
			}
			
			/**	상품 셋팅	*/
			for (var j:int = 0; j < $giftLength; j++) 
			{
				var gifts:MovieClip = $evtPop.evtCon1.getChildByName("gift" + j) as MovieClip;
				gifts.gotoAndStop(j + 1);
			}
		}
		
		/**	탭버튼 핸들러	*/
		private function btnTabHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($btnTabArr[target.no].txt, 0.5, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT :
					if($activeNum == target.no) return;
					
					if(target.no == 0) TweenLite.to($btnTabArr[target.no].txt, 0.5, {alpha:0.65});
					else TweenLite.to($btnTabArr[target.no].txt, 0.5, {alpha:0.35});
					break;
				case MouseEvent.CLICK :
					if(target.no == $activeNum) return;
					$activeNum = target.no;
					changeEventMenu(target.no);
					$evtPop["evtCon"+target.no].gotoAndPlay(2)
					if(target.no == 0){
						if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_event1");
					}else if(target.no == 1){
						if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_event2");
					}
					break;
			}
		}
		/**	이벤트 메뉴 변경	*/
		private function changeEventMenu(num:int):void
		{
			if(num == 0)
			{
				TweenLite.to($evtPop.bg, 0.5, {tint:0xFFEB00});
			}
			else if(num == 1)
			{
				TweenLite.to($evtPop.bg, 0.5, {tint:0xFF6042});
			}
			
			/**	탭버튼 변경	*/
			for (var i:int = 0; i < $btnTabLength; i++) 
			{
				if(i == num)
				{
					TweenLite.to($btnTabArr[i].bg, 0.5, {alpha:0});
					TweenLite.to($btnTabArr[i].txt, 0.5, {alpha:1});
					TweenLite.to($evtPop["evtCon" + i], 0.5, {autoAlpha:1});
				}
				else
				{
					TweenLite.to($btnTabArr[i].bg, 0.5, {alpha:1});
					if(i == 0) TweenLite.to($btnTabArr[i].txt, 0.5, {alpha:0.65});
					else TweenLite.to($btnTabArr[i].txt, 0.5, {alpha:0.35});
					TweenLite.to($evtPop["evtCon" + i], 0.5, {autoAlpha:0});
				}
			}
		}
		
		/**	이벤트 참여버튼 핸들러	*/
		private function btnEvtHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target, 0.5, {colorTransform:{exposure:1.15}});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					if(target.no == 0){
						/**	20130714 이벤트 종료	*/
						JavaScriptUtil.alert("이벤트가 종료되었습니다.");
						
//						if(_model.allWatched == "true"){
//							trace("영상 8개");
//							if(ExternalInterface.available)ExternalInterface.call("MovieEventPageCheck");
//						}else{
//							Debug.alert("영상을 1편~8편까지 모두 보셔야 \n 이벤트에 참여 가능 합니다.");
//						}
						
					}else if(target.no == 1) {
						/**	20130714 이벤트 종료	*/
						JavaScriptUtil.alert("이벤트가 종료되었습니다.");
						
//						_model.activeMenu = 6;
//						_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_ACTIVE_ON));
//						
////						_controler.changeMovie([4,0]); // 영상7번으로(쿨트라 이벤트영상)
//						if(ExternalInterface.available)ExternalInterface.call("PresentEventPageCheck");
					}
					break;
			}
		}
		
		/**	이벤트 제거	*/
		private function removeEvent(e:Event):void
		{
			trace("이벤트 팝업 이벤트 제거_____________________!!");
			Model.getInstance().removeEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			
			for (var i:int = 0; i < $btnTabLength; i++) 
			{
				var btns:MovieClip = $evtPop.getChildByName("btnTab" + i) as MovieClip;
				ButtonUtil.removeButton(btns.btn, btnTabHandler);
				
				var btnEvt:MovieClip = $evtPop.getChildByName("evtCon" + i) as MovieClip;
				ButtonUtil.removeButton(btnEvt.btnEvt, btnEvtHandler);
			}
			
			$btnTabArr = null;
		}
		/**	초기화	*/
		private function destroy():void
		{
			
		}
	}
}