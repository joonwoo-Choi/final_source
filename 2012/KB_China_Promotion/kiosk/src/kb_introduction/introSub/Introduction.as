package kb_introduction.introSub
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import kb_introduction.scrollPage.ScrollPage;
	
	[SWF(width="768", height="1366", frameRate="30", backgroundColor="#ffffff")]
	
	public class Introduction extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetIntroduction;
		
		private var $listXml:XML;
		
		private var $btnLength:int = 2;
		
		private var $listLength:int;
		
		private var $listArr:Array = [];
		
		private var $tabArr:Array = [];
		
		public function Introduction()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
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
			makeBtn();
		}
		
		private function xmlLoad():void
		{
			var data:URLVariables = new URLVariables();
			data.rand = Math.random() * 10000;
			
			var listLdr:URLLoader = new URLLoader();
			listLdr.data = data;
			listLdr.load(new URLRequest($model.defaultURL + "xml/introductionList.xml"));
			listLdr.addEventListener(Event.COMPLETE, listLoadCompleteHandler);
		}
		
		protected function listLoadCompleteHandler(e:Event):void
		{
			$listXml = new XML(e.target.data);
			$listLength = $listXml.list.length();
			trace($listXml);
			
			for (var i:int = 0; i < $listLength; i++) 
			{
				var imgLdr:Loader = new Loader();
				var container:MovieClip = new MovieClip;
				imgLdr.load(new URLRequest($model.defaultURL + $listXml.list[i]));
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				
				container.alpha = 0;
				container.addChild(imgLdr);
				$main.imgCon.addChild(container);
				
				$listArr.push(container);
			}
		}
		
		protected function imgLoadComplete(e:Event):void
		{
			/**	리스트 컨텐츠 세로 스크롤 이벤트 주기	*/
			var range:int = $main.maskMC.height - ($main.imgCon.y - $main.maskMC.y);
			for (var i:int = 0; i < $listLength; i++) 
			{
				if($listArr[i].height > range)
				{
					var scrollPage:ScrollPage = new ScrollPage($listArr[i], range);
					trace($listArr[i].height , range);
				}
			}
			listChange(0);
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
				
				var tab:MovieClip = $main.getChildByName("tab" + i) as MovieClip;
				$tabArr.push(tab);
			}
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			listChange(target.no);
		}
		
		protected function listChange(num:int):void
		{
			for (var i:int = 0; i < $listLength; i++) 
			{
				if(num == i)
				{
					$listArr[i].y = 0;
					TweenMax.to($tabArr[i], 0.5, {autoAlpha:1, ease:Cubic.easeOut});
					TweenMax.to($listArr[i], 0.5, {autoAlpha:1, ease:Cubic.easeOut});
				}
				else
				{
					TweenMax.to($tabArr[i], 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($listArr[i], 0.75, {autoAlpha:0, ease:Cubic.easeOut});
				}
			}
		}
	}
}