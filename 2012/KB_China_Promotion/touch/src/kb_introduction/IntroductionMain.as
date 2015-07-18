package kb_introduction
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.kb_china.utils.MotionController;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	
	import kb_introduction.introNavigation.IntroGNB;
	import kb_introduction.introNavigation.IntroSNB;
	
	[SWF(width="1920", height="1080", frameRate="60", backgroundColor="#ffffff")]
	
	public class IntroductionMain extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetIntroductionMain;
		/**	SWF 리스트	*/
		private var $xml:XML;
		/**	버튼 갯수	*/
		private var $btnLength:int = 4;
		/**	현재 서브 메뉴	*/
		private var $nowSub:Array = [];
		
		private var $motionList:XML;
		
		private var _moController:MotionController;
		
		private var $snb:IntroSNB;
		
		private var $gnb:IntroGNB;
		
		public function IntroductionMain()
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
			
			$main = new AssetIntroductionMain();
			this.addChild($main);
			
			/**	SNB 	*/
			$main.snb.visible = false;
			$main.gnb.alpha = 0;
			$main.gnb.y = 923;
			TweenMax.to($main.gnb, 0.75, {autoAlpha:1, y:913, ease:Cubic.easeOut});
			$snb = new IntroSNB($main.snb);
			$gnb = new IntroGNB($main.gnb);
			
			_moController = new MotionController($main.loop);
			_moController.addEventListener(MotionController.MOTION_FINISHED, motionFinished);
			
			$model = Model.getInstance();
			
//			$model.addEventListener(ModelEvent.KB_INDEX, gotoIndexHandler);
			$model.addEventListener(ModelEvent.GO_TO_MAIN, removeSubMenu);
			$model.addEventListener(ModelEvent.SELECTED_GNB_MENU, selectedGnbSubChange);
			
			/**	메인 메뉴 SWF 리스트 로드	*/
			var data:URLVariables = new URLVariables();
			data.rand = Math.random() * 10000;
			
			var xmlLdr:URLLoader = new URLLoader();
			xmlLdr.data = data;
			xmlLdr.load(new URLRequest($model.defaultURL + "xml/introductionSubList.xml"));
			xmlLdr.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			
			var motionLdr:URLLoader = new URLLoader();
			motionLdr.data = data;
			motionLdr.load(new URLRequest($model.defaultURL + "xml/introductionMotionList.xml"));
			motionLdr.addEventListener(Event.COMPLETE, motionXmlLoadCompleteHandler);
			
			/**	버튼 만들기	*/
			makeBtn();
		}
		
		/*protected function gotoIndexHandler(event:Event):void
		{
			this.dispatchEvent( new Event(ModelEvent.KB_INDEX) );
		}*/
		
		protected function selectedGnbSubChange(e:Event):void
		{
			TweenMax.to($nowSub[0], 0.3, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destory});
			setTimeout(loadMenu, 300, $model.subNum);
		}
		
		protected function motionXmlLoadCompleteHandler(e:Event):void
		{
			$motionList = new XML(e.target.data);
			
			_moController.load($model.defaultURL + $motionList.list[0],  true);
		}
		
		protected function motionFinished(event:Event):void
		{
			if($main.loop.alpha == 1) _moController.load($model.defaultURL + $motionList.list[1],  false);
		}
		
		private function xmlLoadCompleteHandler(e:Event):void
		{
			$xml = new XML(e.target.data);
			trace($xml);
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn"+i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnHandler);
			}
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			$model.subNum = mc.no;
			
//			TweenLite.to($main.title, 0.75, {alpha:0, y:160, ease:Cubic.easeOut});
//			TweenLite.to($main.title2, 0.75, {alpha:1, y:150, ease:Cubic.easeOut});
			
			loadMenu(mc.no);
		}
		
		/**	서브메뉴 로드	*/
		private function loadMenu(num:int):void
		{
			/**	그림자 지우기	*/
			TweenLite.to($main.shadow, 0.75, {alpha:0, ease:Cubic.easeOut});
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn"+i) as MovieClip;
				btn.visible = false;
			}
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest($xml.list[num].@url));
			
			var mc:MovieClip = new MovieClip;
			mc.addChild(ldr);
			$nowSub.push(mc);
			$main.menuCon.addChild(mc);
			
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, subLoadProgress);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, subLoadComplete);
		}
		/**	로드 프로그레스 	*/
		private function subLoadProgress(e:ProgressEvent):void
		{
			var percent:Number = (e.bytesLoaded / e.bytesTotal) * 100;
			trace("load progress_____: " + percent);
		}
		/**	서브로드 완료	*/
		private function subLoadComplete(e:Event):void
		{
			$nowSub[0].alpha = 0;
			setTimeout(showSubMenu, 300);
			trace("load complete_____: " + e.target.content);
		}
		
		private function showSubMenu():void
		{
			$model.dispatchEvent(new Event(ModelEvent.SELECTED_SUB_MENU));
			TweenMax.to($main.snb, 0.75, {autoAlpha:1, y:913, ease:Cubic.easeOut});
			TweenMax.to($main.gnb, 0.75, {autoAlpha:0, y:923, ease:Cubic.easeOut});
			TweenMax.to($main.loop, 0.75, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to($nowSub[0], 0.75, {alpha:1, ease:Cubic.easeOut});
		}
		
		/**	서브 제거	*/
		protected function removeSubMenu(e:Event):void
		{
			_moController.load($model.defaultURL + $motionList.list[0],  true);
			TweenMax.to($main.snb, 0.75, {autoAlpha:0, y:923, ease:Cubic.easeOut});
			TweenMax.to($main.gnb, 0.75, {autoAlpha:1, y:913, ease:Cubic.easeOut});
			TweenMax.to($main.loop, 0.75, {alpha:1, ease:Cubic.easeOut});
			TweenMax.to($nowSub[0], 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destory});
			
			/**	바닥 그림자 보이기	*/
			TweenLite.to($main.shadow, 0.75, {alpha:1, ease:Cubic.easeOut});
			
//			TweenLite.to($main.title, 0.75, {alpha:1, y:150, ease:Cubic.easeOut});
//			TweenLite.to($main.title2, 0.75, {alpha:0, y:160, ease:Cubic.easeOut});
		}
		
		/**	초기화	*/
		private function destory():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn"+i) as MovieClip;
				btn.visible = true;
			}
			
			if($main.menuCon.numChildren > 0)
			{
				for (var j:int = 0; j < $main.menuCon.numChildren; j++) 
				{
					var ldr:Loader = $nowSub[0].getChildAt(0) as Loader
						ldr.unloadAndStop();
						ldr = null;
						$main.menuCon.removeChildAt(0);
						$nowSub = [];
				}
			}
			trace("초기화_____: " + ldr + "\n자식수_____: " + $main.menuCon.numChildren);
		}
	}
}