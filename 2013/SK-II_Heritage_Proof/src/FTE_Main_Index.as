package
{
	
	import com.adqua.control.MotionController;
	import com.adqua.display.Resize;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
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
	
	public class FTE_Main_Index extends Sprite
	{
		
		private var $index:AssetSiteIndex;
		
		private var $model:Model;
		/**	리사이즈	*/
		private var $resize:Resize;
		
		private var $ldr:Loader;
		
		private var $moController:MotionController;
		
		private var $isIntro:String;
		
		public function FTE_Main_Index()
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
			
			$index.removeChild($index.blind);
			$index.removeChild($index.dot);
			$index.loaderCon.product_mask.scaleY = 0;
			$index.loaderCon.default_mask.scaleY = 1;
			
			$model = Model.getInstance();
			
			$resize = new Resize();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			$index.loaderCon.count.count.autoSize = TextFieldAutoSize.LEFT;
			
			var sp:Sprite = new Sprite();
			$index.mainCon.addChild(sp);
			$moController = new MotionController(sp);
			$moController.load($model.defaulfPath + "FTE_Site.swf",  false, true);
			$moController.addEventListener(MotionController.MOTION_LOAD_PROGRESS, motionLoadProgress);
			$moController.addEventListener(MotionController.MOTION_LOAD_COMPLETE, motionLoadComplete);
			
			resizeHandler();
			$index.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
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
		
		private function motionLoadComplete(e:Event):void
		{
			$moController.removeEventListener(MotionController.MOTION_LOAD_PROGRESS, motionLoadProgress);
			$moController.removeEventListener(MotionController.MOTION_LOAD_COMPLETE, motionLoadComplete);
			TweenLite.to($index.loaderCon, 0.5, {autoAlpha:0});
			$index.stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$resize.arrangeX($index.loaderCon, 1024);
		}
	}
}