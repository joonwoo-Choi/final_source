package kb_introduction.introSub
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
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
	
	public class Introduction extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetIntroduction;
		/**	리스트 XML	*/
		private var $xml:XML;
		/**	리스트 번호	*/
		private var $listNum:int;
		/**	리스트 수	*/
		private var $listLength:int;
		/**	버튼 배열	*/
		private var $btn:Array = [];
		/**	버튼 위치 배열	*/
		private var $btnYArr:Array = [[274,423,526,628],
									[274,395,526,628],
									[274,363,494,628],
									[274,363,467,628]];
		/**	프레임 텍스트 배열	*/
		private var $txtArr:Array = [];
		/**	리스트 배열	*/
		private var $listArr:Array = [];
		
		public function Introduction()
			
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
			
			$main = new AssetIntroduction();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			xmlLoad();
		}
		
		private function xmlLoad():void
		{
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest($model.defaultURL + "xml/introductionList.xml"));
			urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
		}
		
		protected function xmlLoadComplete(e:Event):void
		{
			var $xml:XML = new XML(e.target.data);
			trace($xml);
			
			$listLength = $xml.list.length();
			for (var i:int = 0; i < $listLength; i++) 
			{
				var imgLdr:Loader = new Loader();
				imgLdr.load(new URLRequest($model.defaultURL + $xml.list[i]));
				
				var mcList:listClip = new listClip();
				mcList.alpha = 0;
				$listArr.push(mcList);
				mcList.imgCon.addChild(imgLdr);
				$main.listCon.addChild(mcList);
				
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, listLoadComplete);
			}
			
			makeBtn();
		}
		
		protected function listLoadComplete(e:Event):void
		{
			/**	리스트 컨텐츠 세로 스크롤 이벤트 주기	*/
			for (var i:int = 0; i < $listLength; i++) 
			{
				if($listArr[i].height > $main.maskMC.height)
				{
					var range:int = $main.maskMC.height - ($main.listCon.y - $main.maskMC.y);
					var scrollPage:ScrollPage = new ScrollPage($listArr[i], range - 50);
				}
			}
			$main.listCon.setChildIndex($main.listCon.scroll, $main.listCon.numChildren - 1);
			listChange();
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $listLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				//btn.no = i;
				$btn.push(btn);
				btn.mouseEnabled = false;
				btn.hit.no = i;
				btn.hit.buttonMode = true;
				btn.hit.mouseChildren = false;
				
				btn.over.mouseEnabled = false;
				//btn.over.mouseChildren = false;
				btn.out.mouseEnabled = false;
				//btn.out.mouseChildren = false;
				
				btn.hit.addEventListener(MouseEvent.CLICK, btnClickHandler);
				
				/**	텍스트 배열	*/
				var txt:MovieClip = $main.getChildByName("txt" + i) as MovieClip;
				$txtArr.push(txt);
			}
			
			$main.btnClose.buttonMode = true;
			$main.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			$listNum = target.no;
			
			listChange();
		}
		
		private function listChange():void
		{
			for (var i:int = 0; i < $listLength; i++) 
			{
				TweenMax.killTweensOf($listArr[i]);
				$listArr[i].imgCon.y = 0;
				$main.listCon.scroll.bar.y = 0;
				
				if($listNum == i) 
				{
					$listArr[i].x = $main.stage.stageWidth;
					
					/**	컨텐츠 스크롤 보이기 숨기기	*/
					if($listArr[i].height > $main.maskMC.height - ($main.listCon.y - $main.maskMC.y))
						TweenMax.to($main.listCon.scroll, 0.75, {alpha:1, ease:Expo.easeOut});
					else
						TweenMax.to($main.listCon.scroll, 0.75, {alpha:0, ease:Expo.easeOut});
					
					/**	리스트 트윈	*/
					TweenMax.to($listArr[i], 0.75, {x:0, alpha:1, ease:Expo.easeOut});
					
					/**	버튼 위치 이동	*/
					for (var j:int = 0; j < $listLength; j++) 
					{	TweenMax.to($btn[j], 0.75, {y:$btnYArr[i][j], ease:Expo.easeOut});	}
					TweenMax.to($btn[i].over, 0.75, {alpha:1, ease:Expo.easeOut});
					
//					$btn[i].mouseEnabled = false;
//					$btn[i].mouseChildren = false;
					$btn[i].hit.mouseEnabled = false;
					
					TweenLite.to($txtArr[i], 0.75, {alpha:1, y:328, ease:Cubic.easeOut});
				}
				else
				{
					TweenMax.to($listArr[i], 0.75, {x:-$listArr[i].width, alpha:0, ease:Expo.easeOut});
					TweenMax.to($btn[i].over, 0.75, {alpha:0, ease:Expo.easeOut});
					
//					$btn[i].mouseEnabled = true;;
//					$btn[i].mouseChildren = true;
					$btn[i].hit.mouseEnabled = true;
					
					TweenLite.to($txtArr[i], 0.75, {alpha:0, y:333, ease:Expo.easeOut});
				}
			}
		}
		
		protected function closeHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new Event(ModelEvent.GO_TO_MAIN));
			trace("___인트로덕션 클로즈___!");
		}
	}
}