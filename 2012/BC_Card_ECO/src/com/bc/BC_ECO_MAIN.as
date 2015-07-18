package com.bc
{
	
	import com.bc.main.popup.PopupGuide;
	import com.bc.main.popup.PopupProduct;
	import com.bc.main.rollingTag.RollingTag;
	import com.bc.model.Model;
	import com.bc.model.ModelEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.utils.ButtonUtil;
	import com.utils.NetUtil;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[SWF(width="995", height="743", frameRate="30", backgroundColor="#ffffff")]
	
	public class BC_ECO_MAIN extends Sprite
	{
		
		private var $main:AssetMain;
		
		private var $model:Model;
		
		private var $tag:RollingTag;
		
		private var $popupGuide:PopupGuide;
		
		private var $productPopup:PopupProduct;
		/**	상품 리스트 XML	*/
		private var $listXml:XML;
		/**	상품 갯수	*/
		private var $listLength:int;
		/** 캐릭터 기본 Y값 	*/
		private var $characterY:int;
		/**	점프중 체크	*/
		private var $isJump:Boolean = false;
		/**	캐릭터 이동 방향 및 거리	*/
		private var $moveNum:int;
		/**	엔터프레임 체크 	*/
		private var $enterChk:Boolean = false;
		/**	에코머니 획득 수	*/
		private var $cntChk:int;
		/**	팝업 제거 타임 아웃	*/
		private var $popupTime:uint;
		/**	백그라운드 배열	*/
		private var $moveConArr:Array;
		/**	백그라운드 X 좌표	*/
		private var $conArrX:Array = [];
		/**	트윈 시간	*/
		private var $tweenTime:int;
		/**	기준 x 좌표	*/
		private var $standardX:Number;
		/**	히트테스트 가능 & 불가능	*/
		private var $isHit:Boolean = true;
		
		public function BC_ECO_MAIN()
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
			
			$main = new AssetMain();
			
			this.addChild($main);
			
			$tag = new RollingTag($main.mainCon.tag);
			
			$popupGuide = new PopupGuide($main);
			
			$productPopup = new PopupProduct($main);
			
			$moveConArr = [$main.itemCon, $main.depth0, $main.depth1, $main.depth2, $main.bg];
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.TAG_LOADED, defaultSetting)
			
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			listXmlLoad();
			makeButton();
			defaultSetting();
			resizeHandler();
		}
		/**	시작 셋팅	*/
		private function defaultSetting(e:Event = null):void
		{
			$characterY = int($main.mainCon.character.y);
			$standardX = int($main.mainCon.x);
			$main.block.visible = false; 
			$main.popup.visible = false;
			$main.findPop.visible = false;
			$main.texture.mouseEnabled = false;
			$main.texture.mouseChildren = false;
			
			$main.itemCon.x = int($main.stage.stageWidth/2 - $main.itemCon.width/2);
			$main.bg.x = int($main.stage.stageWidth/2 - $main.bg.width/2);
			$main.depth0.x = int($main.stage.stageWidth/2 - $main.depth0.width/2);
			$main.depth1.x = int($main.stage.stageWidth/2 - $main.depth1.width/2);
			$main.depth2.x = int($main.stage.stageWidth/2 - $main.depth2.width/2);
			
			$standardX = int($main.mainCon.x);
			for (var k:int = 0; k < $moveConArr.length; k++) 
			{	$conArrX.push($moveConArr[k].x);	}
			trace("$conArrX: " + $conArrX);
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
			$listLength = $listXml.product.list.length();
			trace($listXml);
			
			$model.listXml = $listXml;
			
			$model.dispatchEvent(new ModelEvent(ModelEvent.XML_LOADED));
			
			TweenLite.to($main.mainCon.btnEvt, 1.5, {alpha:1, ease:Cubic.easeOut});
		}
		
		/**	버튼 만들기	*/
		private function makeButton():void
		{
			ButtonUtil.makeButton($main.mainCon.btnEvt, popupHandler);
			ButtonUtil.makeButton($main.btnRule, popupHandler);
			ButtonUtil.makeButton($main.logo, logoHandler);
			/**	키보드 이벤트	*/
			$main.stage.addEventListener(KeyboardEvent.KEY_DOWN, characterHandler);
			$main.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		/**	팝업 핸들러	*/
		private function popupHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				if(e.target.name == "btnEvt") $main.popup.gotoAndStop(1);
				else if(e.target.name == "btnRule") $main.popup.gotoAndStop(2);
				popupView();
			}
		}
		
		private function popupView():void
		{
			TweenMax.killTweensOf($main.popup);
			$main.popup.scaleX = $main.popup.scaleY = 0.9;
			TweenMax.to($main.popup, 1, {autoAlpha:1, ease:Expo.easeOut});
			TweenMax.to($main.popup, 1.5, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
			TweenMax.to($main.block, 0.75, {autoAlpha:0.5, ease:Cubic.easeOut});
			$popupGuide.makeButton();
		}
		/**	로고 핸들러	*/
		private function logoHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{	navigateToURL(new URLRequest("http://www.ecomoney.co.kr"), "_blank");	}
		}
		/**	키보드 핸들러	*/
		private function characterHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 37 :
					if(!$enterChk)
					{
						$enterChk = true;
						$moveNum = 4;
						$main.mainCon.character.scaleX = 1;
						$main.stage.addEventListener(Event.ENTER_FRAME, settingCharacter);
					}
					break;
				case 39 :
					if(!$enterChk)
					{
						$enterChk = true;
						$moveNum = -4;
						$main.mainCon.character.scaleX = -1;
						$main.stage.addEventListener(Event.ENTER_FRAME, settingCharacter);
					}
					break;
				case 32:
					if(!$isJump)
					{
						$isJump = true;
						character(0, 1, 0);
						$main.mainCon.character.jump.play();
						TweenMax.to($main.mainCon.character, 1.3, 
						{bezierThrough:[{y:$characterY - 150}, {y:$characterY}], onComplete:endJump});
						$main.mainCon.character.addEventListener(Event.ENTER_FRAME, jumpHitTest);
					}
					break;
			}
		}
		
		private function jumpHitTest(e:Event):void
		{
			for (var i:int = 0; i < $model.itemLength; i++) 
			{
				for (var j:int = 0; j < $model.repeatNum; j++) 
				{
					if($main.mainCon.character.area.hitTestObject($model.itemArr[i][j]))
					{	hitEcoMoney(i, j);	}
				}
			}
		}
		/**	엔터 프레임 캐릭터 이동 값 방향 지정	*/
		private function settingCharacter(e:Event):void
		{	moveCharacter($moveNum);	}
		/**	캐릭터 이동	*/
		private function moveCharacter(num:int):void
		{
			$tweenTime = 0;
			if($main.bg.x >= -500 && num == 4)
			{	num = 0;	}
			else if($main.bg.x <= $main.stage.stageWidth - $main.bg.width + 500 && num == -4)
			{	num = 0;	}
			else if($isJump)
			{	num = 7*$main.mainCon.character.scaleX;	}
			for (var i:int = 0; i < $model.itemLength; i++) 
			{
				$model.cartStampArr[i].scaleX = $main.mainCon.character.scaleX;
				if($main.mainCon.character.area.hitTestObject($model.moolbumArr[i].area) && $isHit)
				{
					/**	물범과 부딪혔을 때	*/
					$isJump = false;
					$isHit = false;
					$tweenTime = 1
					num = -75*$main.mainCon.character.scaleX;
					/**	왼쪽 오른쪽 구분 물범 플레이	*/
					if($main.mainCon.character.scaleX == 1)
					{
						$model.moolbumArr[i].hit0.action.play();
						$model.moolbumArr[i].hit0.play();
						$model.moolbumArr[i].hit0.alpha = 1;
						$model.moolbumArr[i].hit1.alpha = 0;
					}
					else
					{
						$model.moolbumArr[i].hit1.action.play();
						$model.moolbumArr[i].hit1.play();
						$model.moolbumArr[i].hit0.alpha = 0;
						$model.moolbumArr[i].hit1.alpha = 1;
					}
					setTimeout(moolbumHitTrue,6000);
					character(0, 0, 1);
					$main.mainCon.character.hit.play();
					TweenMax.to($main.mainCon.character, 1.2, 
						{bezierThrough:[{y:$characterY - 75}, 
							{y:$characterY}], 
							onComplete:addKeyBoardEvent});
					$main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, characterHandler);
					$main.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
					$main.stage.removeEventListener(Event.ENTER_FRAME, settingCharacter);
					break;
				}
				else
				{
					if($isJump && $main.mainCon.character.hit.currentFrame == 1)
					{
						character(0, 1, 0);
						$main.mainCon.character.jump.play();
					}
					else if($main.mainCon.character.hit.currentFrame == 1)
					{
						character(1, 0, 0);
						$main.mainCon.character.walk.play();
					}
				}
				for (var j:int = 0; j < $model.repeatNum; j++) 
				{
					/**	에코머니와 부딪혔을 때	*/
					if($main.mainCon.character.area.hitTestObject($model.itemArr[i][j]))
					{
						hitEcoMoney(i,j);
					}
				}
			}
			
			/**	이동	*/
			var contentNum:int;
			$conArrX = [];
			$standardX = int($main.mainCon.x);
			for (var k:int = 0; k < $moveConArr.length; k++) 
			{
				if(k <= 1) contentNum = 0;
				else contentNum = k - 1;
				TweenLite.to($moveConArr[k], $tweenTime, {x:$moveConArr[k].x + num*int((6-contentNum)/3)});
				$conArrX.push($moveConArr[k].x);
			}
			trace("$conArrX: " + $conArrX);
		}
		/**	에코머니와 부딪혔을 때	*/
		private function hitEcoMoney(i:int, j:int):void
		{
			if($model.itemArr[i][j] != null) $main.itemCon.removeChild($model.itemArr[i][j]);
			/**	완료 팝업 체크 & 보이기	*/
			setTimeout(showPopup, 250);
			$cntChk++;
			if($cntChk <= $model.itemLength)
			{
				TweenLite.to($model.cartStampArr[$cntChk - 1], 0.75, {alpha:1, ease:Cubic.easeOut});
				TweenLite.to($model.stampArr[$cntChk - 1].find, 0.75, {alpha:1, ease:Cubic.easeOut});
			}
			if($cntChk >= $model.itemLength)
			{
				ButtonUtil.removeButton($main.mainCon.btnEvt, popupHandler);
				ButtonUtil.removeButton($main.btnRule, popupHandler);
				ButtonUtil.removeButton($main.logo, logoHandler);
				$main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, characterHandler);
				$main.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				$main.stage.removeEventListener(Event.ENTER_FRAME, settingCharacter);
				$main.mainCon.character.removeEventListener(Event.ENTER_FRAME, jumpHitTest);
			}
		}
		
		private function moolbumHitTrue():void
		{	
			$isHit = true;
			$main.mainCon.character.removeEventListener(Event.ENTER_FRAME, jumpHitTest);
		}
		
		/**	키보드 이벤트 주기	*/
		private function addKeyBoardEvent():void
		{
			$main.stage.addEventListener(KeyboardEvent.KEY_DOWN, characterHandler);
			$main.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function showPopup():void
		{
			for (var k:int = 0; k < $model.itemLength; k++) 
			{
				if(k == $cntChk-1) $model.productArr[k].alpha = 1;
				else $model.productArr[k].alpha = 0;
			}
			clearTimeout($popupTime);
			$popupTime  = setTimeout(popupClose,2000);
			TweenMax.killTweensOf($main.findPop);
			$main.findPop.scaleX = $main.findPop.scaleY = 0.9;
			TweenMax.to($main.findPop, 1, {autoAlpha:1, ease:Expo.easeOut});
			TweenMax.to($main.findPop, 1.5, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
			TweenMax.to($main.block, 0.75, {autoAlpha:0.5, ease:Cubic.easeOut});
		}
		private function popupClose():void
		{
			if($cntChk >= $model.itemLength)
			{
				$main.popup.gotoAndStop(3);
//				setTimeout(popupView, 250);
				TweenMax.to($main.findPop, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:popupView});
				return;
			}
			TweenMax.to($main.findPop, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			if($cntChk == $model.itemLength) return;
			TweenMax.to($main.block, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
		}
		/**	캐릭터 알파	*/
		private function character(walkAlpha:int, jumpAlpha:int, hitAlpha:int):void
		{
			$main.mainCon.character.walk.alpha = walkAlpha;
			$main.mainCon.character.jump.alpha = jumpAlpha;
			$main.mainCon.character.hit.alpha = hitAlpha;
		}
		/**	점프 종료	*/
		private function endJump():void
		{	
			$isJump = false;
			$main.mainCon.character.jump.alpha = 0;
			$main.mainCon.character.walk.alpha = 1;
			$main.mainCon.character.removeEventListener(Event.ENTER_FRAME, jumpHitTest);
		}
		/**	캐릭터 이동 종료	*/
		protected function keyUpHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == 37 || e.keyCode == 39)
			{
				$enterChk = false;
				$main.stage.removeEventListener(Event.ENTER_FRAME, settingCharacter);
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
			$main.texture.height = int(height);
			$main.texture.x = int(width/2 - $main.texture.width/2);
			$main.btnRule.x = int(width - 104);
			
			$main.block.width = int(width);
			$main.block.height = int(height);
			
			$main.texture.x = int(width/2 - $main.texture.width/2);
			$main.popup.x = int($main.findPop.x = width/2);
			$main.popup.y = int($main.findPop.y = height/2);
			$main.mainCon.x = int(width/2 - $main.mainCon.plane.width/2);
			
			/**	이동	*/
			var standardNum:Number = $main.mainCon.x- $standardX;
			for (var k:int = 0; k < $moveConArr.length; k++) 
			{	$moveConArr[k].x = $conArrX[k] + standardNum;	}
		}
	}
}