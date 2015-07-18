package
{
	
	import com.adqua.control.MotionController;
	import com.adqua.display.Resize;
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.model.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	[SWF(width="1659", height="877", frameRate="30", backgroundColor="0x999999")]
	
	public class FTE_Intro_Index extends Sprite
	{
		
		private var $index:AssetSiteIndex;
		
		private var $model:Model;
		/**	리사이즈	*/
		private var $resize:Resize;
		
		private var $ldr:Loader;
		
		private var $moController:MotionController;
		
		private var $isIntro:String;
		
		private var $sp:Sprite;
		
		private var $dot:dot;
		
		/**	메인 or 서브 체크	*/
		private var $isMain:Boolean = true;
		
		public function FTE_Intro_Index()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$index = new AssetSiteIndex();
			this.addChild($index);
			
			$model = Model.getInstance();
			
			$resize = new Resize();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			/**	메인 or 서브 체크	*/
			if(root.loaderInfo.parameters.menu)
			{
				$isMain = false;
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest($model.defaulfPath + "thumb/sub_bg.jpg"));
				$index.mainCon.addChild(ldr);
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundLoadComplete);
			}
			else
			{
				$isMain = true;
//				var ldr:Loader = new Loader();
//				ldr.load(new URLRequest($model.defaulfPath + "thumb/sub_bg.jpg"));
//				$index.mainCon.addChild(ldr);
//				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundLoadComplete);
				var sp:Sprite = new Sprite();
				$index.mainCon.addChild(sp);
				$moController = new MotionController(sp);
				$moController.load($model.defaulfPath + "FTE_Intro.swf",  true, true);
				$moController.addEventListener(MotionController.MOTION_FINISHED, motionFinished);
				$moController.addEventListener(MotionController.MOTION_LOAD_PROGRESS, motionLoadProgress);
				$moController.addEventListener(MotionController.MOTION_LOAD_COMPLETE, motionLoadComplete);
			}
			
			$index.loaderCon.count.count.autoSize = TextFieldAutoSize.LEFT;
			$index.loaderCon.product_mask.scaleY = 0;
			$index.loaderCon.default_mask.scaleY = 1;
			
			$sp = new Sprite();
			$index.dot.addChild($sp);
			$dot = new dot();
			
			resizeHandler();
			$index.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**	모션 로드	*/
		private function motionLoadProgress(e:Event):void
		{
			TweenLite.to($index.loaderCon, 0.3, {autoAlpha:1});
			$index.loaderCon.product_mask.scaleY = $model.percent;
			$index.loaderCon.default_mask.scaleY = 1 - $model.percent;
			$index.loaderCon.count.count.text = Math.round($model.percent * 100);
			$index.loaderCon.count.per_txt.x = int($index.loaderCon.count.count.width);
			$index.loaderCon.count.x = $index.loaderCon.plane.width / 2 - $index.loaderCon.count.width / 2;
			resizeHandler();
			trace($index.loaderCon.count.width);
		}
		/**	모션 로드 완료	*/
		private function motionLoadComplete(e:Event):void
		{
			$moController.removeEventListener(MotionController.MOTION_LOAD_PROGRESS, motionLoadProgress);
			$moController.removeEventListener(MotionController.MOTION_LOAD_COMPLETE, motionLoadComplete);
			TweenLite.to($index.loaderCon, 0.5, {autoAlpha:0});
		}
		/**	모션 종료	*/
		private function motionFinished(e:Event):void
		{
			TweenLite.to($index.dot, 0.6, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to($index.blind, 0.6, {alpha:0.65, ease:Cubic.easeOut});
		}
		
		/**	서브 배경 이미지 로드 완료	*/
		private function backgroundLoadComplete(e:Event):void
		{
			resizeHandler();
			$index.dot.alpha = 1;
			$index.blind.alpha = 0.65;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$sp.graphics.clear();
			$sp.graphics.beginBitmapFill($dot);
			$sp.graphics.drawRect(0, 0, $index.stage.stageWidth, $index.stage.stageHeight);
			$sp.graphics.endFill();
			
			$index.blind.width = $index.stage.stageWidth;
			$index.blind.height = $index.stage.stageHeight;
			
			if($isMain == false)
			{
				$resize.stageResize($index.mainCon, $index.stage.stageWidth, $index.stage.stageHeight, 1659, 877, false, false);
				$resize.arrangeX($index.mainCon, 1024);
			}
			
			$resize.arrangeX($index.loaderCon, 1024);
		}
	}
}