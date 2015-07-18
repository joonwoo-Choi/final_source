package net
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.core.LoaderCore;
	import com.sw.net.BaseConLoader;
	
	import display.Layout;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**		
	 *	SK2_Hersheys :: 로더 공통 내용
	 */
	public class SK2BaseConLoader extends BaseConLoader
	{
		/**	마우스 제어 	*/
		protected var lockPlane:Object;
		
		/**	생성자	*/
		public function SK2BaseConLoader($loadingMc:MovieClip = null,$lockPlane:Object = null)
		{
			super();
			
			if($loadingMc != null) loading_mc = $loadingMc;
			if($lockPlane != null) lockPlane = $lockPlane;
		}
		
		/**	외부에서 로딩바 보여지기	*/
		public function setViewLoading():void
		{	viewLoading();	}
		/**	외부에서 로딩바 가려	지기*/
		public function setHideLoading():void
		{	hideLoading();	}
		
		protected function setLoadingTxt(num:int):void
		{
			var txt:TextField = loading_mc.txtMc.txt as TextField;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = num+"";
			
			loading_mc.txtMc.txt2.x = txt.width;
			
			if(loading_mc.txtMc.planeMc != null)
			{
				txt.x = Math.round((loading_mc.txtMc.planeMc.width - txt.width)/2);
				loading_mc.txtMc.txt2.x += txt.x;
				
//				var dir:Number = num/100;
//				loading_mc.maskMc.scaleY -= (loading_mc.maskMc.scaleY-dir)*0.3;
				var dir:Number = 292-num;
				loading_mc.maskMc.y -= (loading_mc.maskMc.y-dir)*0.3;
				
//				if(num == 0) loading_mc.maskMc.scaleY = 0.1;
				if(num == 0) loading_mc.maskMc.y = 292;
			}
		}
		/**	로딩 진행 중	*/
		public function onProgress(e:LoaderEvent):void
		{
			if(loading_mc == null) return;
			var loaderCore:LoaderCore = e.target as LoaderCore;
			var num:int = Math.round((loaderCore.bytesLoaded / loaderCore.bytesTotal )*100);
			
			setLoadingTxt(num);
		}
		
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			bLoadingMove = false;	//기본 로딩바 모션 사용하지 않음
			
			if(lockPlane == null) lockPlane = Layout.getIns().lockPlane;
			if(Layout.getIns().loadingSp.numChildren > 0 && loading_mc == null)
			{
				loading_mc = Layout.getIns().loadingSp.getChildAt(0) as MovieClip;
				loading_mc.alpha = 0;
				loading_mc.planeMc.visible = false;
			}
		}
		/**	데이터 로드	*/
		public function load():void
		{
			viewLoading();
			if(loader != null)
			{
			
			}
			loader = new LoaderMax({onComplete:onLoadTotal,onProgress:onProgress,auditSize:false});
			
		}
		/**	로딩바 보여지기	*/
		override protected function viewLoading():void
		{
			if(loading_mc == null) return;
			
			loading_mc.visible = true;
			//Layout.getIns().lockPlane.visible = true;
			lockPlane.visible = true;
			setLoadingTxt(0);
			
			TweenMax.to(loading_mc,0,{alpha:loading_mc.alpha,ease:Expo.easeOut});
			TweenMax.to(loading_mc,1,{alpha:1,ease:Expo.easeIn});
		}
		/**	로딩바 가려지기	*/
		override protected function hideLoading():void
		{
			if(loading_mc == null) return;
			
			//Layout.getIns().lockPlane.visible = false;
			
			if(Global.getIns().getPopAlpha() != 1) lockPlane.visible = false;
			setLoadingTxt(100);
			
			TweenMax.to(loading_mc,1,{alpha:0,onComplete:finishLoading,ease:Expo.easeOut});
		}
		/**	초기 로드 내용 모두 로드	*/
		protected function onLoadTotal(e:LoaderEvent):void
		{	}
		
	}//class
}//package