package day.day3
{
	import com.adqua.net.Debug;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day3_1 extends AbstractMain
	{
		
		private var $main:AssetDay3_1;
		
		private var $btnLength:int = 5;
		
		private var $btnArr:Array;
		
		public function Day3_1()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			_model.addEventListener(PEventCommon.MALL_POP_OPEN, popOpen);
			_model.addEventListener(PEventCommon.MALL_POP_CLOSE, mallPopClose)
			$main = new AssetDay3_1();
			this.addChild($main);
			
			$main.popup.alpha = 0;
			$main.popup.visible = false;
			$main.popup.gotoAndStop(1);
			
			$main.btnSkip.visible = false;
			
			makeBtn();
		}
		
		private function makeBtn():void
		{
			$btnArr = [];
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				$btnArr.push(btns);
				btns.over.alpha = 0;
				btns.over.visible = false;
				ButtonUtil.makeButton(btns, mainBtnHandler);
			}
			
			ButtonUtil.makeButton($main.popup.btnPresent, selectMovie);
			ButtonUtil.makeButton($main.popup.btnClose, popupClose);
			ButtonUtil.makeButton($main.btnSkip, btnSkipHandler);
			
		}
		
		
		private function btnSkipHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					target["skipMc"].gotoAndStop(2);
					break;
				
				case MouseEvent.MOUSE_OUT : 
					target["skipMc"].gotoAndStop(1);
					break;
				case MouseEvent.CLICK : 
					skipOff();
//					showEndingMovie(); 
					break;
			}
		}
		
		//스킵온
		private function skipOn(evt:PEventCommon = null):void
		{
			trace("스킵온   _model.activeMenu  : ", _model.activeMenu)
			TweenLite.to($main.btnSkip, .5, {autoAlpha:1,frame:$main.btnSkip.totalFrames-1})
		}
		
		private function skipOff(evt:PEventCommon=null):void
		{
			TweenLite.to($main.btnSkip, .5, {frame:1, onComplete:skipComplete});
		}
		
		private function skipComplete(evt:Event = null):void
		{
			showEndingMovie(); 
			trace("스킵아웃");
			
			$main.btnSkip.stop();
			$main.btnSkip.visible = false;
			$main.btnSkip.alpha = 0;
			TweenLite.killTweensOf($main.btnSkip);
			_model.removeEventListener(PEventCommon.SKIP_OPEN_ON,skipOn);
		}
		
		/**	메인 버튼 - 팝업 보이기	*/
		private function mainBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					btnOverCheck(target.no);
					break;
				case MouseEvent.MOUSE_OUT :
					btnOverCheck(-1);
					break;
				case MouseEvent.CLICK :
					$main.popup.gotoAndStop(target.no + 1);
					trace("target.no : ", target.no);
					_model.mall  = target.no + 1;
					TweenLite.to($main.btnCon, 0.5, {autoAlpha:0});
					_controler.changeMovie([4, 0, target.no + 2]);
					trace("_model.mall : ", _model.mall)
					break;
			}
		}
		
		//팝업 오픈
		private function popOpen(e:PEventCommon):void
		{
			TweenLite.to($main.popup, 0.5, {autoAlpha:1});
			$main.btnSkip.visible = false;
			$main.btnSkip.alpha = 0;
			trace("선물받기 팝업 오픈_________!!!");
		}
		
		/**	선물받기 팝업 버튼	*/
		private function selectMovie(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					/**	20130714 이벤트 종료	*/
					JavaScriptUtil.alert("이벤트가 종료되었습니다.");
					
//					//팝업 5번 (일반참여/페북참여)
//					_model.mainPopupFrame = 5;
//					_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
//					_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
					
					
					//팝업에서 참여 누르고 개인정보 끝나고 showEndingMovie
//					showEndingMovie();
					break;
			}
		}
		/**	선물받기 - 인터랙션 종료	*/
		private function showEndingMovie():void
		{
			removeEvent();
			_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
			_controler.changeMovie([4, 0, 7]); //엔딩
			TweenLite.to($main, 0.5, {autoAlpha:0, onComplete:destroy});
		}
		
		/**	팝업 닫기 버튼	*/
		private function popupClose(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($main.popup.btnClose, 0.5, {rotation:90, ease:Expo.easeOut});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($main.popup.btnClose, 0.5, {rotation:0, ease:Expo.easeOut});
					break;
				case MouseEvent.CLICK :
//					Debug.alert("이벤트 응모가 완료되지 않았습니다.\n창을 닫으시겠습니까?");
					_model.mall = 0;
					TweenLite.to($main.popup, 0.5, {autoAlpha:0});
					TweenLite.to($main.btnCon, 0.5, {autoAlpha:1});
					/**	스킵버튼 활성화	*/
//					if($main.btnSkip.alpha != 1) TweenLite.to($main.btnSkip, 0.5, {autoAlpha:1});
					skipOn();
					break;
			}
		}
		
		protected function mallPopClose(event:PEventCommon):void
		{
			_model.mall = 0;
			TweenLite.to($main.popup, 0.5, {autoAlpha:0});
			TweenLite.to($main.btnCon, 0.5, {autoAlpha:0});
			
		}
		/**	마우스 오버 체크	*/
		private function btnOverCheck(num:int):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				if(i == num)
				{
					$main.btnCon.setChildIndex($btnArr[i], $main.btnCon.numChildren - 1);
					TweenLite.to($btnArr[i].over, 0.5, {autoAlpha:1});
				}
				else
				{
					TweenLite.to($btnArr[i].over, 0.5, {autoAlpha:0});
				}
			}
		}
		
		/**	이벤트 제거	*/
		private function removeEvent(e:Event=null):void
		{
			$btnArr = null;
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, mainBtnHandler);
			}
			
			ButtonUtil.removeButton($main.popup.btnPresent, selectMovie);
			ButtonUtil.removeButton($main.popup.btnClose, popupClose);
			ButtonUtil.removeButton($main.btnSkip, btnSkipHandler);
			
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
	}
}