package popup
{
	import com.adqua.net.Debug;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import pEvent.PEventCommon;
	
	[SWF(width="1280", height="850", frameRate="30", backgroundColor="0x999999")]
	
	public class MainPopup extends AbstractMain
	{
		
		private var $main:AssetPopup;
		
		private var $btnLength:int = 2;
		
		public function MainPopup()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin, ColorTransformPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			_model.addEventListener(PEventCommon.MAIN_POPUP_SHOW, mainPopupShow);
			
			$main = new AssetPopup();
			this.addChild($main);
			
			$main.alpha = 0;
			$main.visible = false;
			
			makeButton();
			
			//콜백함수 (8개 영상완료시)
			if(ExternalInterface.available){
				//응모완료되면 outro영상 play
				ExternalInterface.addCallback("callbackUserInfo",outroPlay); //8개 완료 아웃영상
			}
			if(ExternalInterface.available){
				//개인정보닫기
				ExternalInterface.addCallback("callbackUserInfoClose",infoClose);
			}
			//이벤트1
			if(ExternalInterface.available){
				
				ExternalInterface.addCallback("callbackEvent1",evt1End); //8개 완료 아웃영상
			}
			//이벤트2
			if(ExternalInterface.available){
				
				ExternalInterface.addCallback("callbackEvent2",evt2End); //7번 이벤트 아웃영상
			}
		}
		
		//영상8개 다 보면 (이벤트1-아웃트로영상)
		private function evt1End($id:String):void
		{
			if($id == "1"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_SHOW))
				if(ExternalInterface.available)ExternalInterface.call("MovieEventUserCheck");
				
			}else if($id == "2"){
				Debug.alert("이미 이벤트에 참여하셨습니다.");
			}
		}
		
		//영상7번으로(이벤트2-쿨트라영상)
		private function evt2End($id:String):void
		{
			if($id == "1"){
				_controler.changeMovie([4,0]); // 영상7번으로(쿨트라 이벤트영상)
			}else if($id == "2"){
//				Debug.alert("이벤트에 참여하셨습니다.");
				_controler.changeMovie([4,0]); // 영상7번으로(쿨트라 이벤트영상)
			}
		}
		
		/**	팝업 보이기	*/
		protected function mainPopupShow(e:Event):void
		{
			makeButton();
			TweenLite.to($main, 0.5, {autoAlpha:1});
		}
		
		/**	버튼 만들기	*/
		private function makeButton():void
		{
			/**	프레임 이동	*/
			$main.popupCon.gotoAndStop(_model.mainPopupFrame);
			
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.popupCon.popup.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnsHandler);
			}
			
			ButtonUtil.makeButton($main.popupCon.popup.closeBtn, closeBtnHandler);
			
			resizeHandler();
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**	메인 버튼 핸들러	*/
		private function btnsHandler(e:MouseEvent):void
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
					activeHandler(target.no);
					TweenLite.to(target, 0.5, {colorTransform:{exposure:1}});
					break;
			}
		}
		/**	버튼 실행	*/
		private function activeHandler(num:int):void
		{
			/**	현재 프레임 번호 & 버튼 번호에 따라 실행	*/
			switch ($main.popupCon.currentFrame)
			{
				//메뉴시 뜨는 팝업 1
				case 1 :
					if(num == 0) 
					{
						_controler.resumeMovie();
					}
					else if(num == 1)
					{
						_model.activeMenu = _model.activeMenu2.no;
						_controler.changeGNB(_model.activeMenu);
						_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_ACTIVE_ON));
						
						_model.dispatchEvent(new PEventCommon(PEventCommon.DESTROY_INTERACTION));
						_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
						
					}
					destroy();
					break;
				
				//하단메뉴 왼쪽 이벤트 팝업
				case 2 :
					if(num == 0)
					{
						//영상통화 이어하기
						_controler.resumeMovie();
					}
					else if(num == 1)
					{
						_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
						//이벤트 페이지로 이동
						_controler.activeBottomContent("left");
					}
					
					destroy();
					break;
				
				//하단메뉴 오른쪽 루트 팝업
				case 3 :
					if(num == 0)
					{
						//영상통화 이어하기
						_controler.resumeMovie();
					}
					else if(num == 1)
					{
						_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
						//루트맵으로 이동
						_controler.activeBottomContent("right");

					}
					destroy();
					break;
				
				//영상통화 완료 팝업
				case 4:
					
					if(num == 0){
						//이벤트 페이지로 이동
						_controler.activeBottomContent("left");	
						
					}
					else if(num == 1)
					{
						
					}
					destroy();
					break;
				
				//쿨트라 로그인 팝업
				case 5:
					
					if(num == 0){
						//일반참여
						_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_SHOW))
						if(ExternalInterface.available)ExternalInterface.call("PresentEventUserCheck",_model.mall, "N");
					}
					else if(num == 1)
					{
						//페북참여
						if(ExternalInterface.available)ExternalInterface.call("PresentEventScrap",_model.mall);
					}
					destroy();
					break;
				
				//그냥하기
				case 6:
					if(num == 0){
						//메인으로
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_CHANGE));
					}
					else if(num == 1)
					{
						//루트페이지
						_controler.activeBottomContent("right");	
					}
					destroy();
					break;
				
				case 7:
					if(num == 0){
						//영상통화 이어하기
						_controler.resumeMovie();
					}
					else if(num == 1)
					{
						//메인으로
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_CHANGE));	
					}
					destroy();
					break;
			}
			
		}
		
		
		//아웃트로 영상
		protected function outroPlay($id:String):void
		{
			//8개 엔딩영상
			if($id == "1"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE))
				_controler.changeMovie([4,3]);
				_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_CLOSE));
				_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
				_model.dispatchEvent(new PEventCommon(PEventCommon.HPTITLE_STOP));
				
			//쿨트라 엔딩영상
			}else if($id == "2"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE))
				_model.dispatchEvent(new PEventCommon(PEventCommon.MALL_POP_CLOSE))
				_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
				_controler.changeMovie([4,0,7]);
			}
		}
		//닫기
		private function infoClose($id:String):void
		{
			if($id == "1"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE))
			}else if($id == "2"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE))
			}
		}
		
		
		/**	닫기 버튼 핸들러	*/
		private function closeBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($main.popupCon.popup.close, 0.5, {rotation:90, ease:Expo.easeOut});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($main.popupCon.popup.close, 0.5, {rotation:0, ease:Expo.easeOut});
					break;
				case MouseEvent.CLICK :
						
					//8개 완료 팝업창
					if(_model.mainPopupFrame == 4){
						Debug.alert("응모가 완료되지 않았습니다. 창을 닫으시겠습니까?");
						
					}else if(_model.mainPopupFrame == 6){
						destroy();
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_CHANGE));
						
					}else{
						destroy();
						_controler.resumeMovie();
					}
					
					TweenLite.to($main.popupCon.popup.close, 0.5, {rotation:0, ease:Expo.easeOut});
					break;
			}
		}
		
		/**	리사이즈	*/
		private function resizeHandler(e:Event = null):void
		{
			$main.bg.width = $main.stage.stageWidth;
			$main.bg.height = $main.stage.stageHeight;
			
			if($main.bg.width > 1280) $main.popupCon.x = int($main.bg.width/2 - $main.popupCon.width/2);
			else $main.popupCon.x = int(1280/2 - $main.popupCon.width/2);
			
			if($main.bg.height > 850) $main.popupCon.y = int($main.bg.height/2 - $main.popupCon.height/2);
			else $main.popupCon.y = int(850/2 - $main.popupCon.height/2);
		}
		
		/**	초기화	*/
		private function destroy():void
		{
			TweenLite.to($main, 0.5, {autoAlpha:0});
			
			/**	이벤트 제거	*/
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.popupCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, btnsHandler);
			}
			
			ButtonUtil.removeButton($main.popupCon.popup.closeBtn, closeBtnHandler);
			
			$main.stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
	}
}