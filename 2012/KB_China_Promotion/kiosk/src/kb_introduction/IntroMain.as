package kb_introduction
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kb.utils.MotionController;
	
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
	
	import kb_introduction.introGNB.IntroGNB;
	import kb_introduction.introGNB.SubGNB;
	
	
	[SWF(width="768", height="1366", frameRate="30", backgroundColor="#ffffff")]
	
	public class IntroMain extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetIntroMain;
		/**	모션 SWF 리스트	*/
		private var $motionList:XML;
		/**	버튼 갯수	*/
		private var $btnLength:int = 2;
		/**	현재 서브 메뉴	*/
		private var $nowSub:Array = [];
		/**	서브 SWF 리스트	*/
		private var $subList:XML;
		/**	GNB 컨트롤	*/
		private var $gnb:IntroGNB;
		/**	sub GNB	*/
		private var $subGnb:SubGNB;
		
		private var _moController:MotionController;
		
		public function IntroMain()
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
			
			$main = new AssetIntroMain();
			this.addChild($main);
			
			$gnb = new IntroGNB($main.gnb);
			
			$subGnb = new SubGNB($main.subGnb);
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.GO_TO_MAIN, removeSubMenu);
			$model.addEventListener(ModelEvent.SELECTED_GNB_MENU, selectedGnbSubChange);
			
			_moController = new MotionController($main.movCon);
			_moController.addEventListener(MotionController.MOTION_FINISHED, motionFinished);
			
			xmlLoad();
			makeBtn();
		}
		
		protected function selectedGnbSubChange(e:Event):void
		{
			TweenMax.to($nowSub[0], 0.3, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destory});
			setTimeout(loadMenu, 300, $model.subNum);
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			/**	네비게이션 교체 	*/
			$model.subNum = target.no;
			TweenMax.to($main.gnb, 0.75, {autoAlpha:0, y:1233, ease:Cubic.easeOut});
			TweenMax.to($main.subGnb, 0.75, {autoAlpha:1, y:1206, ease:Cubic.easeOut});
			$model.dispatchEvent(new Event(ModelEvent.SELECTED_SUB_MENU));
			
			loadMenu(target.no);
		}
		
		protected function motionFinished(e:Event):void
		{
			_moController.load($model.defaultURL + $motionList.list[1],  false);
		}
		
		private function xmlLoad():void
		{
			var data:URLVariables = new URLVariables();
			data.rand = Math.random() * 10000;
			
			var motionLdr:URLLoader = new URLLoader();
			motionLdr.data = data;
			motionLdr.load(new URLRequest($model.defaultURL + "xml/introMotionList.xml"));
			motionLdr.addEventListener(Event.COMPLETE, motionListLoadCompleteHandler);
			
			var listLdr:URLLoader = new URLLoader();
			listLdr.data = data;
			listLdr.load(new URLRequest($model.defaultURL + "xml/introSubList.xml"));
			listLdr.addEventListener(Event.COMPLETE, listLoadCompleteHandler);
		}
		
		protected function motionListLoadCompleteHandler(e:Event):void
		{
			$motionList = new XML(e.target.data);
			
			_moController.load($model.defaultURL + $motionList.list[0],  true);
			
			TweenMax.to($main.title, 0.75, {autoAlpha:1, y:129, ease:Cubic.easeOut});
		}
		
		protected function listLoadCompleteHandler(e:Event):void
		{
			$subList = new XML(e.target.data);
			trace($subList);
		}
		
		/**	서브메뉴 로드	*/
		private function loadMenu(num:int):void
		{
//			TweenMax.to($main.title, 0.75, {autoAlpha:0, y:134, ease:Cubic.easeOut});
//			TweenMax.to($main.title2, 0.75, {autoAlpha:1, y:129, ease:Cubic.easeOut});
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn"+i) as MovieClip;
				btn.visible = false;
			}
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest($subList.list[num]));
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
			setTimeout(showSubMenu, 750);
			trace("load complete_____: " + e.target.content);
		}
		
		private function showSubMenu():void
		{
			TweenMax.to($main.movCon, 0.75, {alpha:0, ease:Cubic.easeOut});
			TweenMax.to($nowSub[0], 0.75, {alpha:1, ease:Cubic.easeOut});
		}
		
		/**	서브 제거	*/
		protected function removeSubMenu(e:Event):void
		{
			_moController.load($model.defaultURL + $motionList.list[0],  true);
//			TweenMax.to($main.title, 0.75, {autoAlpha:1, y:129, ease:Cubic.easeOut});
//			TweenMax.to($main.title2, 0.75, {autoAlpha:0, y:134, ease:Cubic.easeOut});
			TweenMax.to($main.gnb, 0.75, {autoAlpha:1, y:1213, ease:Cubic.easeOut});
			TweenMax.to($main.subGnb, 0.75, {autoAlpha:0, y:1226, ease:Cubic.easeOut});
			TweenMax.to($main.movCon, 0.75, {alpha:1, ease:Cubic.easeOut});
			TweenMax.to($nowSub[0], 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destory});
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
				var ldr:Loader = $nowSub[0].getChildAt(0) as Loader
				ldr.unloadAndStop();
				ldr = null;
				$main.menuCon.removeChildAt(0);
				$nowSub = [];
			}
			trace("초기화_____: " + ldr + "\n자식수_____: " + $main.menuCon.numChildren);
		}
		
		private function subChange(num:int):void
		{
			
		}
	}
}