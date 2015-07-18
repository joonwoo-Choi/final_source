package loading
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pEvent.PEvent;
	import pEvent.PEventCommon;
	
	
	public class ViewLoading extends AbstractMCView
	{
		
		public var $loading:MCLoading;
		
		public function ViewLoading(mcView:MovieClip)
		{
			super(mcView);
			$loading = MCLoading(mcView);
			setting();
			_model.addEventListener(PEvent.MOVIE_GROUP_CHANGED,checkGroupChange);
			_model.addEventListener(PEvent.PROGRESS,loadingProgress);
		}
		
		override public function setting():void{
			$loading.name = "mcloading";
			$loading.popClose.buttonMode = true;
			$loading.popClose.addEventListener(MouseEvent.CLICK,hideLoading);			
		}
		
		protected function checkGroupChange(event:Event):void
		{
			trace("checkGroupChange::::::::::::::::::::::::::::::::\\\\\\\\\\\\\\\\\\\\\\\\");
			if($loading.alpha){
				hideLoading(null);
			}
		}
		
		protected function loadingProgress(event:Event):void
		{
			$loading.txtCon.txt.text = (_model.numProgress>100)?"100":String(_model.numProgress);
		}
		
		
		public function hideLoading(event:Event):void
		{
			trace("hideLoading");
//			_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE));
			
			TweenLite.killTweensOf($loading);
			TweenLite.killDelayedCallsTo(showLoading);
			TweenLite.to($loading,.3,{autoAlpha:0,onComplete:loadingHided});
//			$loading.stage.removeEventListener(MouseEvent.CLICK,hideLoading);
//			$loading.stage.removeEventListener(MouseEvent.CLICK,removePop);
		}		
		private function loadingHided():void
		{
			trace("loadingHided=======---------=======--------");
//			_controler.loadingHideComplete();
		}		
		private function showLoading():void
		{
			trace("showLoading::::::::showLoading::::::::showLoading");
			$loading.visible = true;
			$loading.popClose.visible = false;
			$loading.alpha=1;
			$loading.txtCon.alpha = 0;
			$loading.txtCon.gotoAndPlay(2);
			TweenLite.to($loading.txtCon,.3,{autoAlpha:1,onComplete:function():void{
//				$loading.stage.addEventListener(MouseEvent.CLICK,hideLoading);
//				$loading.stage.addEventListener(MouseEvent.CLICK,removePop);
			}});
			
		}	
		public function makingLoading(event:Event):void
		{
			trace("makingLoading***************");
//			_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_SHOW));
			
			$loading.txtCon.txt.text = "0";
			
			TweenLite.delayedCall(.2,showLoading);
//			showLoading();
		}	
		
		protected function removePop(event:MouseEvent):void
		{
//			_controler.popUpRemove();
		}
		
		public function loadingResize(rootStage:Stage):void{
			$loading.x = int((rootStage.stageWidth-$loading.bg.width)/2);
			$loading.y = int((rootStage.stageHeight-$loading.bg.height)/2);
		}
	}
}