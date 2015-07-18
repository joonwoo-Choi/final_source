package
{
	
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.cosmo.Stage_Move;
	import com.proof.microsite.cosmo.Thumb_Move;
	import com.proof.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	
	[SWF(width="874", height="605", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_Cosmo extends Sprite
	{
		
		private var $main:AssetCosmo;
		
		private var $model:Model;
		
		private var $stageMove:Stage_Move;
		
		private var $thumbMove:Thumb_Move;
		
		public function FTE_Cosmo()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetCosmo();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			$stageMove = new Stage_Move($main);
			$thumbMove = new Thumb_Move($main);
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);			}
			else
			{		$model.defaulfPath = "";			};
			
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest($model.defaulfPath + "thumb/cosmo.jpg"));
			$main.img.addChild(ldr);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
		}
		
		protected function imgLoadComplete(e:Event):void
		{
			var bitmap:Bitmap = e.target.content as Bitmap;
			bitmap.smoothing = true;
			trace(e.target.content);
//			$main.img.y = -65;
			$main.img.scaleX = $main.img.scaleY = 0.28;
			$main.img.x = $main.btnDrag.width/2 - $main.img.width/2;
			$main.img.y = $main.btnDrag.height/2 - $main.img.height/2;
//			TweenLite.to($main.img, 1, {alpha:1, ease:Cubic.easeOut, onComplete:originalScale});
			TweenLite.to($main.img, 1, {alpha:1, onComplete:originalScale});
			TweenMax.to($main.img, 1, {
				colorTransform:{exposure:1.2},
				blurFilter:new BlurFilter(8,8),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$main.img]
			});
		}
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
		
		private function originalScale():void
		{
			TweenLite.to($main.img, 0.6, {x:-1088, y:-619, scaleX:1, scaleY:1, ease:Quad.easeOut});
			TweenLite.to($main.thumb, 0.6, {delay:0.6, y:473, ease:Cubic.easeOut, onComplete:cosmoStart});
			TweenLite.to($main.thumb.mcMask, 0.35, {delay:0.75, x:int(Math.abs(-1088 / 16.5)), 
																			y:int(Math.abs(-619 / 16.5)), ease:Cubic.easeOut});
			TweenLite.to($main.thumb.window, 0.35, {delay:0.75, x:int(Math.abs(-1088/ 16.5)), 
																			y:int(Math.abs(-619 / 16.5)), ease:Cubic.easeOut});
		}
		
		private function cosmoStart():void
		{
			$model.dispatchEvent(new ModelEvent(ModelEvent.COSMO_START));
		}
	}
}