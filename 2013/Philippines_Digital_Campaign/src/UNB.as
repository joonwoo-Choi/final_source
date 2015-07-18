package
{
	import com.adqua.util.NetUtil;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pEvent.PEventCommon;
	
	[SWF(width="1280",height="850",frameRate="30")]
	public class UNB extends AbstractMain
	{
		private var $topLogo:TopLogo;
		private var $bottomNavi:BottomNavi;
		
		public function UNB()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		override protected function onAdded(event:Event):void
		{
			//상단네비
			$topLogo = new TopLogo;
			addChild($topLogo);
			$topLogo["btn1"].buttonMode = true;
			$topLogo["btn1"].addEventListener(MouseEvent.CLICK, logoClick1); 
			$topLogo["btn2"]["b1"].buttonMode = true;
			$topLogo["btn2"]["b2"].buttonMode = true;
			$topLogo["btn2"]["b1"].addEventListener(MouseEvent.CLICK, koreanClick);
			$topLogo["btn2"]["b2"].addEventListener(MouseEvent.CLICK, englishClick);
			
			//하단네비
			$bottomNavi = new BottomNavi;
			addChild($bottomNavi);
			$bottomNavi["btn1"].buttonMode = true;
			$bottomNavi["btn2"].buttonMode = true;
			$bottomNavi["btn1"].mouseChildren = false;
			$bottomNavi["btn2"].mouseChildren = false;
			
			$bottomNavi["btn1"].addEventListener(MouseEvent.ROLL_OVER, eventOver);
			$bottomNavi["btn1"].addEventListener(MouseEvent.ROLL_OUT, eventOut);
			$bottomNavi["btn1"].addEventListener(MouseEvent.CLICK, eventClick);
			
			$bottomNavi["btn2"].addEventListener(MouseEvent.ROLL_OVER, routeOver);
			$bottomNavi["btn2"].addEventListener(MouseEvent.ROLL_OUT, routeOut);
			$bottomNavi["btn2"].addEventListener(MouseEvent.CLICK, routeClick);
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			onResize();
			
			stage.addEventListener(Event.RESIZE,onResize);
		}
		
		private function koreanClick(evt:MouseEvent):void
		{
			NetUtil.getURL("http://www.7107.co.kr/","_blank");
		}
		private function englishClick(evt:MouseEvent):void
		{
			NetUtil.getURL("http://www.tourism.gov.ph/","_blank");
		}	
		
		private function logoClick1(evt:MouseEvent):void
		{
			trace("왼쪽 Logo");
			if(_model.activeBottonContent){
				_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_CHANGE));
			}else{
				_controler.pauseMovie();
				_model.mainPopupFrame = 7;
				_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
			}
		}
		
		//이벤트페이지 버튼핸들러
		private function eventOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndPlay(2);
		}
		private function eventOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndStop(1)
		}
		
		private function eventClick(evt:MouseEvent):void
		{
			if(_model.activeBottonContent){
				if(_model.botPopupType == "eventPop") return;
				_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
				_controler.activeBottomContent("left");
			}else{
				_controler.popupShow(2);
			}
		}
		
		//루트맵페이지 버튼핸들러
		private function routeOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndPlay(2);
		}
		private function routeOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndStop(1);
		}
		
		private function routeClick(evt:MouseEvent):void
		{
			if(_model.activeBottonContent){
				if(_model.botPopupType == "routeMap") return;
				_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_OPEN_DEL));
				_controler.activeBottomContent("right");				
			}else{
				_controler.popupShow(3);
			}
		}
		
		
		protected function onResize(event:Event=null):void
		{
			_model.sw = stage.stageWidth;
			_model.sh = stage.stageHeight;
			
			if(_model.sh < 850) _model.sh = 850;
			if(_model.sw < 1280) _model.sw = 1280;
			
			$topLogo["btn2"].x = _model.sw - $topLogo["btn2"].width;
			
			$bottomNavi.y = _model.sh - $bottomNavi.height +10;
			$bottomNavi["btn2"].x = _model.sw - $bottomNavi["btn2"].width;
		}
		
	}
}
