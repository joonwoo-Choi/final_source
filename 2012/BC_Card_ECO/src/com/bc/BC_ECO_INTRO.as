package com.bc
{
	
	import com.bc.main.rollingTag.RollingTag;
	import com.bc.model.Model;
	import com.bc.model.ModelEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.utils.ButtonUtil;
	import com.utils.JavaScriptUtil;
	import com.utils.NetUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	[SWF(width="995", height="743", frameRate="30", backgroundColor="#ffffff")]
	
	public class BC_ECO_INTRO extends Sprite
	{
		
		private var $main:AssetIntro;
		
		private var $model:Model;
		/**	버튼 수	*/
		private var $btnLength:int = 4;
		/**	팝업 버튼 수	*/
		private var $popupBtnLength:int = 6;
		/**	상품 리스트 XML	*/
		private var $listXml:XML;
		/**	태그 이미지 수	*/
		private var $tagLength:int;
		/**	태그 배열	*/
		private var $tagArr:Array = [];
		/**	태그 롤링 타이머	*/
		private var $timer:Timer;
		/**	타이머 카운트	*/
		private var $timerCnt:int;
		
		public function BC_ECO_INTRO()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetIntro();
			
			this.addChild($main);
			
			$model = Model.getInstance();
			
			$main.popup.visible = false;
			$main.xMasPopup.visible = false;
			$main.block.visible = false;
			$main.texture.mouseChildren = false;
			$main.texture.mouseEnabled = false;
			$main.xMasPopup.btn2.visible = false;
			
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			listXmlLoad();
			makeButton();
			resizeHandler();
		}
		
		/**	리스트 로드	*/
		private function listXmlLoad():void
		{
			var xmlLdr:URLLoader = new URLLoader();
			if(NetUtil.isBrowser())
			{	xmlLdr.load(new URLRequest($model.webUrl + "xml/EcoMoneyList.xml"));	}
			else
			{	xmlLdr.load(new URLRequest("xml/EcoMoneyList.xml"));	}
			xmlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
		}
		/**	리스트 로드 완료	*/
		private function xmlLoadComplete(e:Event):void
		{
			$listXml = new XML(e.target.data);
			$tagLength = $listXml.product.list.length();
			
			/**	태그 이미지 로드	*/
			for (var i:int = 0; i < $tagLength; i++) 
			{
				var tagLdr:Loader = new Loader();
				if(NetUtil.isBrowser())
				{
					tagLdr.load(new URLRequest($model.webUrl + $listXml.tag.list[i]));
				}
				else
				{
					tagLdr.load(new URLRequest($listXml.tag.list[i]));
				}
				$tagArr.push(tagLdr);
				tagLdr.alpha = 0;
				$main.motion.tag.img.addChild(tagLdr);
			}
			
			$timer = new Timer(4000);
			$timer.addEventListener(TimerEvent.TIMER, rollingTagHandler);
			$timer.start();
		}
		
		private function rollingTagHandler(e:TimerEvent):void
		{
			$timerCnt++;
			for (var i:int = 0; i < $tagLength; i++) 
			{
				if($timerCnt%$tagLength == i)
				{
					$tagArr[i].x = $main.motion.tag.maskMC.width;
					TweenLite.to($tagArr[i], 1, {alpha:1, x:0, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($tagArr[i], 1, {x:-$tagArr[i].width, ease:Cubic.easeOut});
				}
			}
		}
		
		private function makeButton():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.motion.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
				
			}
			
			for (var j:int = 0; j < $popupBtnLength; j++) 
			{
				/**	X-Mas 이벤트 팝업 버튼	*/
				var btns:MovieClip = $main.xMasPopup.getChildByName("btn" + j) as MovieClip;
				btns.no = j;
				btns.buttonMode = true;
				btns.addEventListener(MouseEvent.CLICK, xMasPopupHandler);
			}
			
			
			$main.logo.buttonMode = true;
			$main.logo.addEventListener(MouseEvent.CLICK, logoClickHandler);
		}
		
		private function logoClickHandler(e:MouseEvent):void
		{
			/**	로고	*/
			JavaScriptUtil.call("EcoMoney.trace", "eco_logo");
			navigateToURL(new URLRequest("http://www.ecomoney.co.kr"), "_blank"); 
		}
		
		private function xMasPopupHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (target.no)
			{
				case 0 :
				case 4 :
					contentView(0);
					break;
				case 1 :
				case 5 :
					contentView(1);
					break;
				case 2 :
					navigateToURL(new URLRequest("http://www.bccard.com/app/card/ContentsLinkActn.do?pgm_id=ind0803"), "_blank");
					break;
				case 3 :
					contentView(0);
					TweenMax.to($main.xMasPopup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.block, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					break;
			}
		}
		
		private function contentView(num:int):void
		{
			switch (num)
			{
				case 0 :
					TweenMax.to($main.xMasPopup.txt0, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.txt1, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.leaf0, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.leaf1, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.btn0.over, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.btn1.over, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					$main.xMasPopup.btn4.visible = false;
					$main.xMasPopup.btn5.visible = true;
					$main.xMasPopup.btn2.visible = false;
					break;
				case 1 :
					TweenMax.to($main.xMasPopup.txt0, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.txt1, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.leaf0, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.leaf1, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.btn0.over, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($main.xMasPopup.btn1.over, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
					$main.xMasPopup.btn4.visible = true;
					$main.xMasPopup.btn5.visible = false;
					$main.xMasPopup.btn2.visible = true;
					break;
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (target.no)
			{
				case 0 :
					navigateToURL(new URLRequest("http://www.ecomoney.co.kr"), "_blank"); 
					break;
				case 1 :
					JavaScriptUtil.call("trace", "eco_xMas");
					$main.xMasPopup.scaleX = $main.xMasPopup.scaleY = 0.9;
					TweenMax.to($main.xMasPopup, 1.5, {autoAlpha:1, ease:Expo.easeOut});
					TweenMax.to($main.xMasPopup, 1.5, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
					TweenMax.to($main.block, 0.75, {autoAlpha:0.5, ease:Cubic.easeOut});
					break;
				case 2 :
					JavaScriptUtil.call("trace", "eco_event");
					$main.popup.gotoAndStop(1);
					popupView();
					break;
				case 3 :
					/**	2013-01-02 이벤트 종료	*/
					JavaScriptUtil.alert("이벤트 기간이 종료되었습니다. 감사합니다.");
//					JavaScriptUtil.call("trace", "eco_game");
//					$main.popup.gotoAndStop(2);
//					popupView();
					break;
			}
		}
		
		private function popupView():void
		{
			$main.popup.scaleX = $main.popup.scaleY = 0.9;
			TweenMax.to($main.popup, 1, {autoAlpha:1, ease:Expo.easeOut});
			TweenMax.to($main.popup, 1.5, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
			TweenMax.to($main.block, 0.75, {autoAlpha:0.5, ease:Cubic.easeOut});
			ButtonUtil.makeButton($main.popup.btn, popupBtnHandler);
		}
		
		private function popupBtnHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				if($main.popup.currentFrame == 1)
				{
					TweenMax.to($main.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.block, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					ButtonUtil.removeButton($main.popup.btn, popupBtnHandler);
				}
				else
				{
					/**	게임 시작	*/
					JavaScriptUtil.call("trace", "eco_start");
					$timer.stop();
					$timer.removeEventListener(TimerEvent.TIMER, rollingTagHandler);
					/**	버튼 이벤트 지우기	*/
					for (var i:int = 0; i < $btnLength; i++) 
					{
						var btn:MovieClip = $main.motion.getChildByName("btn" + i) as MovieClip;
						btn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
						
					}
					for (var j:int = 0; j < $popupBtnLength; j++) 
					{
						var btns:MovieClip = $main.xMasPopup.getChildByName("btn" + j) as MovieClip;
						btns.removeEventListener(MouseEvent.CLICK, xMasPopupHandler);
					}
					$main.logo.removeEventListener(MouseEvent.CLICK, logoClickHandler);
					ButtonUtil.removeButton($main.popup.btn, popupBtnHandler);
					
					$model.dispatchEvent(new ModelEvent(ModelEvent.MAIN_LOAD));
					trace("open");
				}
			}
		}
		
		/**	리사이즈 핸들러*/
		protected function resizeHandler(event:Event = null):void
		{
			if($main.stage.stageWidth >= 995)
			{	resize($main.stage.stageWidth, $main.stage.stageHeight);	}
			else
			{	resize(995, $main.stage.stageHeight);	}
		}
		
		private function resize(width:Number, height:Number):void
		{
			$main.block.width = int(width);
			$main.block.height = int(height);
			$main.block.x = int(width/2);
			$main.block.y = int(height/2);
			
			$main.popup.x = $main.xMasPopup.x = int(width/2);
			$main.popup.y = $main.xMasPopup.y = int(height/2);
			$main.texture.height = int(height);
			$main.texture.x = int(width/2 - $main.texture.width/2);
			
			$main.motion.x = int(width/2 - $main.motion.plane.width/2 + 840);
			
			trace($main.block.x, $main.block.width, $main.stage.stageWidth);
		}
	}
}