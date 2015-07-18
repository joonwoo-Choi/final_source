package 
{
	
	import com.bc.model.Model;
	import com.bc.model.ModelEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.utils.NetUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	[SWF(width="995", height="743", frameRate="30", backgroundColor="#ffffff")]
	
	public class Index extends Sprite
	{
		
		private var $main:AssetIndex;
		
		private var $model:Model;
		/**	인트로	*/
		private var $introLdr:Loader;
		/**	메인  	*/
		private var $mainLdr:Loader;
		/**	*/
		private var $girlX:int;
		
		public function Index()
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
			
			$main = new AssetIndex();
			
			this.addChild($main);
			
			$main.preloader.visible = false;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.MAIN_LOAD, mainLoadHandler);
			
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			$girlX = $main.preloader.girl.x;
			
			introLoad();
		}
		
		/**	인트로 로드	*/
		private function introLoad():void
		{
			$introLdr = new Loader();
			if(NetUtil.isBrowser())
			{
				$introLdr.load(new URLRequest("swf/BC_ECO_INTRO.swf"));
			}
			else
			{
				$introLdr.load(new URLRequest("BC_ECO_INTRO.swf"));
			}
			$introLdr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, introLoadProgress);
			$introLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, introLoadComplete);
			
			resizeHandler();
		}
		/**	인트로 로드 프로그래스	*/
		protected function introLoadProgress(e:ProgressEvent):void
		{
			TweenMax.to($main.preloader, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
			var loadingPercent:Number = e.bytesLoaded / e.bytesTotal;
			
			var frame:int = 273 * loadingPercent;
			$main.preloader.tree.gotoAndStop(frame);
			$main.preloader.bar.x = $main.preloader.bg.width - (loadingPercent * $main.preloader.bg.width);
			$main.preloader.girl.x = $girlX - (loadingPercent * $girlX);
			trace(loadingPercent);
		}
		/**	인트로  로드 완료	*/
		private function introLoadComplete(e:Event):void
		{
			TweenMax.to($main.preloader, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
			$main.menuCon.addChild($introLdr);
			$main.setChildIndex($main.footer, $main.numChildren - 1);
		}
		/**	인트로 제거	*/
		private function mainLoadHandler(e:Event):void
		{
			TweenLite.to($introLdr, 1, {alpha:0, ease:Cubic.easeOut, onComplete:removeIntro});
		}
		/**	메인 로드	*/
		private function removeIntro():void
		{
			$introLdr.unloadAndStop();
			$main.menuCon.removeChild($introLdr);
			$introLdr = null;
			
			$mainLdr = new Loader();
			if(NetUtil.isBrowser())
			{
				$mainLdr.load(new URLRequest($model.webUrl + "BC_ECO_MAIN.swf"));
			}
			else
			{
				$mainLdr.load(new URLRequest("BC_ECO_MAIN.swf"));
			}
			$mainLdr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			$mainLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoadComplete);
			$mainLdr.alpha = 0;
			trace("_______인트로 제거");
		}
		/**	메인 로드 프로그래스	*/
		protected function mainLoadProgress(e:ProgressEvent):void
		{
			TweenMax.to($main.preloader, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
			var loadingPercent:Number = e.bytesLoaded / e.bytesTotal;
			
			var frame:int = 273 * loadingPercent;
			$main.preloader.tree.gotoAndStop(frame);
			$main.preloader.bar.x = $main.preloader.bg.width - (loadingPercent * $main.preloader.bg.width);
			$main.preloader.girl.x = $girlX - (loadingPercent * $girlX);
			trace(loadingPercent);
		}
		/**	메인 로드 완료	*/
		protected function mainLoadComplete(e:Event):void
		{
			TweenMax.to($main.preloader, 0.5, {autoAlpha:0, ease:Cubic.easeOut});
			TweenLite.to($main.bgUp, 0.5, {height:555, ease:Cubic.easeOut, onComplete:addChildMain});
		}
		
		private function addChildMain():void
		{
			/**	메인 붙이기	*/
			$main.menuCon.addChild($mainLdr);
			TweenLite.to($mainLdr, 1, {alpha:1, ease:Cubic.easeOut});
			$main.setChildIndex($main.footer, $main.numChildren - 1);
			$main.stage.focus = $mainLdr;
		}
		
		/**	리사이즈 핸들러*/
		protected function resizeHandler(e:Event = null):void
		{
			$main.footer.x = $main.stage.stageWidth/2 - $main.footer.width/2;
			$main.footer.y = $main.stage.stageHeight - $main.footer.height;
			
			$main.preloader.x = int($main.stage.stageWidth/2 - $main.preloader.bg.width/2);
			$main.preloader.y = int($main.stage.stageHeight/2 - $main.preloader.height/2);
			
			$main.bgDown.width = $main.stage.stageWidth;
			$main.bgDown.height = $main.stage.stageHeight;
			$main.bgUp.width = $main.stage.stageWidth;
		}
	}
}