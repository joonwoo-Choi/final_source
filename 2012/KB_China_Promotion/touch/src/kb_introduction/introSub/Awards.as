package kb_introduction.introSub
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kb_china.utils.MotionController;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import kb_introduction.scrollPage.ScrollPage;
	
	[SWF(width="1920", height="1080", frameRate="30", backgroundColor="#ffffff")]
	
	public class Awards extends Sprite
	{
		
		/**	모델	*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetAwards;
		/**	리스트 XML	*/
		private var $xml:XML;
		/**	리스트 갯수	*/
		private var $listLength:int;
		/** 리스트 현재 번호	*/
		private var $listNum:int = 0;
		/** 리스트 마지막 번호	*/
		private var $maxNum:int;
		/**	리스트 배열	*/
		private var $listArr:Array = [];
		/**	불릿 배열	*/
		private var $bulletArr:Array = [];
		/**	마우스 다운시 기준점 X	*/
		private var $xPoint:Number;
		/**	마우스 다운시 리스트 X	*/
		private var $listX:Number;
		/**	이미지 X축 이동 좌표 	*/
		private var $xMoveNum:Number;
		/**	페이지 이동 방향	*/
		private var $movDirection:int;
		/**	트로피 사진 배열	*/
		private var $picArr:Array = [];
		/**	사진 갯수	*/
		private var $endPicNum:int = -1;
		/**	SWF 컨트롤	*/
		private var $movControll:MotionController;
		
		public function Awards()
		{
			TweenPlugin.activate([TintPlugin]);
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetAwards();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			$movControll = new MotionController($main.trophy);
			
			$movControll.load($model.defaultURL + "flv/KB_Trophy_Loop.swf", false);
			
			$main.trophy.mouseEnabled = false;
			$main.trophy.mouseChildren = false;
			
			xmlLoad();
		}
		
		/**	XML 로드	*/
		private function xmlLoad():void
		{
			var ldr:URLLoader = new URLLoader();
			ldr.load(new URLRequest($model.defaultURL + "xml/introductionAwardsList.xml"));
			
			ldr.addEventListener(Event.COMPLETE, xmlLoadComplete);
		}
		/**	XML 로드 완료	*/
		private function xmlLoadComplete(e:Event):void
		{
			$xml = new XML(e.target.data);
			$listLength = $xml.list.length();
			$maxNum = $listLength - 1;
			trace($xml + "\n$listLength_____: " + $listLength);
			
			for (var i:int = 0; i < $listLength; i++) 
			{
				var imgLdr:Loader = new Loader();
				imgLdr.load(new URLRequest($model.defaultURL + $xml.list[i].@url));
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				
				/**	리스트 로드	*/
				var mcList:listClip = new listClip();
				$listArr.push(mcList);
				mcList.alpha = 0;
				mcList.imgCon.addChild(imgLdr);
				$main.listCon.addChild(mcList);
				
				$listArr[i].imgCon.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				$main.btnClose.buttonMode = true;
				$main.btnClose.addEventListener(MouseEvent.CLICK, subCloseHandler);
				
				/**	불릿 붙이기	*/
				var mcBullet:bulletClip = new bulletClip();
				/**	불릿 하단 텍스트 로드	*/
				var txtLdr:Loader = new Loader();
				txtLdr.load(new URLRequest($model.defaultURL + $xml.list[i].@bullet));
				mcBullet.txt0.addChild(txtLdr);
				txtLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, txtLoadComplete);
				
				var txtOnLdr:Loader = new Loader();
				txtOnLdr.load(new URLRequest($model.defaultURL + $xml.list[i].@bulletOn));
				mcBullet.txt1.addChild(txtOnLdr);
				txtOnLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, txtOnLoadComplete);
				mcBullet.txt1.alpha = 0;
				
				$bulletArr.push(mcBullet);
				$main.bulletCon.addChild(mcBullet);
				
				/**	불릿 클릭 이벤트 핸들러	*/
				mcBullet.no = i;
				mcBullet.buttonMode = true;
				mcBullet.addEventListener(MouseEvent.CLICK, bulletClickHandler);
				
				var xPoint:Number = i * ($main.bulletCon.width / $listLength);
				mcBullet.x =  xPoint + ($main.bulletCon.width / $listLength)/3;
				
				var picLdr:Loader;
				var mc:MovieClip;
				if($xml.list[i].@pic != "")
				{
					picLdr = new Loader();
					picLdr.load(new URLRequest($model.defaultURL + $xml.list[i].@pic));
					mc = new MovieClip();
					$picArr.push(mc);
					mc.addChild(picLdr);
					$main.picCon.addChild(mc);
					mc.alpha = 0;
					
					$endPicNum++;
				}
				else
				{
					picLdr = new Loader();
					picLdr.load(new URLRequest($model.defaultURL + $xml.list[$endPicNum].@pic));
					mc = new MovieClip();
					$picArr.push(mc);
					mc.addChild(picLdr);
					$main.picCon.addChild(mc);
					mc.alpha = 0;
				}
				trace($picArr);
			}
		}
		
		protected function bulletClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			if(target.no < $listNum) 
			{
				$movDirection = 0;
			}
			else
			{
				$movDirection = 1;
			}
			$listNum = target.no;
			listChange();
		}
		
		private function imgLoadComplete(e:Event):void
		{
			/**	리스트 컨텐츠 세로 스크롤 이벤트 주기	*/
			for (var i:int = 0; i < $listLength; i++) 
			{
				if($listArr[i].imgCon.height > $main.listCon.scroll.height)
				{
					var range:int = $main.listCon.scroll.height - ($main.maskMC.height - $main.listCon.scroll.height);
					var scrollPage:ScrollPage = new ScrollPage($listArr[i], 379);
				}
			}
			$main.listCon.setChildIndex($main.listCon.scroll, $main.listCon.numChildren - 1);
			listChange();
		}
		
		/**	불릿 텍스트 로드	*/
		private function txtLoadComplete(e:Event):void
		{
			/**	불릿 컨테이너 X 좌표	*/
			e.target.content.x = -e.target.content.width/2;
		}
		
		protected function txtOnLoadComplete(e:Event):void
		{
			/**	불릿 컨테이너 X 좌표	*/
			e.target.content.x = -e.target.content.width/2;
			
			$main.bulletCon.setChildIndex($main.bulletCon.marker, $main.bulletCon.numChildren - 1);
		}
		
		/**	리스트 마우스 이동	*/
		private function mouseDownHandler(e:MouseEvent):void
		{
			$xPoint = $main.stage.mouseX;
			$listX = $listArr[$listNum].x;
			
			$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		private function mouseMoveHandler(e:MouseEvent):void
		{
			$xMoveNum = ($main.stage.mouseX - $xPoint)/12;
			
			TweenLite.killTweensOf($listArr[$listNum]);
			TweenLite.to($listArr[$listNum], 0.5, {x:$xMoveNum + $listX});
			
			$main.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$main.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if($xMoveNum >= 10)
			{
				listNumChange(0);
			}
			else if($xMoveNum <= -10)
			{
				listNumChange(1);
			}
			else
			{
				TweenLite.to($listArr[$listNum], 1, {x:0 , ease:Expo.easeOut});
			}
		}
		
		private function listNumChange(num:int):void
		{
			/**	버튼에 따른 페이지 번호 변화	*/
			switch (num)
			{
				case 0 : 
					$movDirection = 0;
					$listNum--; 
					break;
				case 1 : 
					$movDirection = 1;
					$listNum++; 
					break;
			}
			
			/**	페이지 번호 순환 시키기	*/
			if($listNum < 0)
			{
				$listNum = $maxNum;
			}
			else if($listNum > $maxNum)
			{
				$listNum = 0;
			}
			
			/**	페이지 체인지	*/
			listChange();
		}
		
		private function listChange():void
		{
			for (var i:int = 0; i < $listLength; i++) 
			{
				TweenMax.killTweensOf($listArr[i]);
				if($listNum == i) 
				{
					$listArr[i].imgCon.y = 0;
					$main.listCon.scroll.bar.y = 0;
					/**	방향에 따른 시작 위치	*/
					if($movDirection == 1) $listArr[i].x = $main.stage.stageWidth;
					else $listArr[i].x = -$listArr[i].width;
					
					/**	컨텐츠 스크롤 보이기 숨기기	*/
					if($listArr[i].imgCon.height > 422)
						TweenMax.to($main.listCon.scroll, 0.75, {alpha:1, ease:Expo.easeOut});
					else
						TweenMax.to($main.listCon.scroll, 0.75, {alpha:0, ease:Expo.easeOut});
					
					/**	리스트 트윈	*/
					$listArr[i].alpha = 1;
					if($listArr[i].width > $main.listCon.scroll.x)
					{
						TweenMax.to($listArr[i], 0.75, {x:$main.listCon.scroll.x - $listArr[i].width, alpha:1, ease:Expo.easeOut});
					}
					else
					{
						TweenMax.to($listArr[i], 0.75, {x:0, alpha:1, ease:Expo.easeOut});
					}
					
					TweenMax.to($picArr[i], 0.5, {alpha:1, ease:Expo.easeOut});
					
					TweenMax.to($main.bulletCon.bar, 0.75, {width:$bulletArr[i].x, alpha:1, ease:Expo.easeOut});
					TweenMax.to($main.bulletCon.marker, 0.75, {x:$bulletArr[i].x, alpha:1, ease:Expo.easeOut});
					TweenMax.to($bulletArr[i].txt0, 0.75, {y:33, alpha:0 , ease:Expo.easeOut});
					TweenMax.to($bulletArr[i].txt1, 0.75, {y:33, alpha:1 , ease:Expo.easeOut});
				}
				else
				{
					if($movDirection == 0)
						TweenMax.to($listArr[i], 0.75, {x:$listArr[i].width, alpha:0, ease:Expo.easeOut});
					else
						TweenMax.to($listArr[i], 0.75, {x:-$listArr[i].width, alpha:0, ease:Expo.easeOut});
					
					TweenMax.to($picArr[i], 0.5, {alpha:0, ease:Expo.easeOut});
					TweenMax.to($bulletArr[i].txt1, 0.75, {y:30, alpha:0 , ease:Expo.easeOut});
					TweenMax.to($bulletArr[i].txt0, 0.75, {y:30, alpha:1 , ease:Expo.easeOut});
				}
			}
		}
		
		protected function subCloseHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new Event(ModelEvent.GO_TO_MAIN));
			trace("___어워드 클로즈___!");
		}
	}
}