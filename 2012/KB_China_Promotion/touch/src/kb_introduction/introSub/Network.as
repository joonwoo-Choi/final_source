package kb_introduction.introSub
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kb_china.utils.MotionController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="1920", height="1080", frameRate="60", backgroundColor="#ffffff")]
	
	public class Network extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetNetwork;
		/**	팝업 포인트	*/
		private var $pointArr:Array = [];
		/** 맵 팝업 포인트	*/
		private var $mapPointArr:Array = [];
		/**	SWF 컨트롤	*/
		private var $movControll:MotionController;
		
		public function Network()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetNetwork();
			this.addChild($main);
			
			$main.popupMap.visible = false;
			
			$model = Model.getInstance();
			
			$movControll = new MotionController($main.mapCon);
			
			$movControll.load($model.defaultURL + "flv/KB_NetworkMap.swf", true);
			
			makeBtn();
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
				
				if(i > 3) return;
				var pointMC:MovieClip = $main.getChildByName("point" + i) as MovieClip;
				$pointArr.push(pointMC);
			}
			$main.popup.btnClose.buttonMode = true;
			$main.popup.btnClose.addEventListener(MouseEvent.CLICK, popupCloseHandler);
			
			$main.btnClose.buttonMode = true;
			$main.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
			
			/**	아시아 지역 팝업 이벤트	*/
			for (var j:int = 0; j < 11; j++) 
			{
				var btns:MovieClip = $main.popupMap.getChildByName("btn" + j) as MovieClip;
				btns.no = j;
				btns.buttonMode = true;
				btns.addEventListener(MouseEvent.CLICK, popupMapBtnClickHandler);
				
				var points:MovieClip = $main.popupMap.getChildByName("point" + j) as MovieClip;
				$mapPointArr.push(points);
			}
			
			$main.popupMap.btnClose.addEventListener(MouseEvent.CLICK, popupMapCloseHandler);
			$main.popupMap.pop.btnClose.addEventListener(MouseEvent.CLICK, popupMapPopCloseHandler);
		}
		
		private function popupCloseHandler(e:MouseEvent):void
		{
			TweenMax.to($main.popup, 0.5, {autoAlpha:0, ease:Expo.easeOut});
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			if(target.no == 3)
			{
				TweenMax.to($main.popupMap, 1, {autoAlpha:1, ease:Cubic.easeOut});
				TweenMax.to($main.popup, 0.5, {autoAlpha:0, ease:Expo.easeOut});
			}
			else
			{
				$main.popup.gotoAndStop(target.no + 1);
				$main.popup.x = $pointArr[target.no].x;
				$main.popup.y = $pointArr[target.no].y;
				$main.popup.alpha = 0;
				TweenMax.to($main.popup, 0.5, {autoAlpha:1, ease:Expo.easeOut});
				$main.popup.pop.mouseEnabled = false;
				$main.popup.pop.mouseChildren = false;
			}
		}
		
		private function popupMapBtnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			$main.popupMap.pop.gotoAndStop(target.no + 4);
			$main.popupMap.pop.x = $mapPointArr[target.no].x - 8;
			$main.popupMap.pop.y = $mapPointArr[target.no].y + 10;
			$main.popupMap.pop.alpha = 0;
			TweenMax.to($main.popupMap.pop, 0.5, {autoAlpha:1, ease:Expo.easeOut});
			$main.popupMap.pop.pop.mouseEnabled = false;
			$main.popupMap.pop.pop.mouseChildren = false;
		}
		
		private function popupMapCloseHandler(e:MouseEvent):void
		{
			TweenMax.to($main.popupMap, 1, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($main.popupMap.pop, 0.5, {autoAlpha:0, ease:Expo.easeOut});
		}
		
		private function popupMapPopCloseHandler(e:MouseEvent):void
		{
			TweenMax.to($main.popupMap.pop, 1, {autoAlpha:0, ease:Cubic.easeOut});
		}
		
		protected function closeHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new Event(ModelEvent.GO_TO_MAIN));
			trace("___네트워크 클로즈___!");
		}
	}
}