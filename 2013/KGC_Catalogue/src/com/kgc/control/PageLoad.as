package com.kgc.control
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kgc.event.KGCEvent;
	import com.kgc.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class PageLoad
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $nowPage:Loader;
		
		private var $prevPage:Loader;
		
		public function PageLoad()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			$model = Model.getInstance();
		}
		
		public function load(num:int, con:MovieClip):void
		{
			$model.clickCheck = false;
			
			$con = con;
			
			TweenLite.to($con.loadingMC, 0.5, {autoAlpha:1});
			$con.loadingMC.play();
			
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest($model.defaultPath + $model.listXml.list[num].@path));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, catalogueLoadComplete);
			$con.img.addChild(ldr);
			
			/**	페이지 배열 저장	*/
			$model.pageArr.splice(0,0,ldr);
			
			/**	현재/과거 카다로그 교체	*/
			if($nowPage != null) $prevPage = $nowPage
			$nowPage = ldr;
			/**	시작 위치	*/
			if($model.direction == "right")
			{
				ldr.x = $con.plane.width;
			}
			else if($model.direction == "left")
			{
				ldr.x = -$con.plane.width;
			}
			
			$model.prevPageNum = num;
		}
		
		private function catalogueLoadComplete(e:Event):void
		{
			$model.dispatchEvent(new KGCEvent(KGCEvent.PAGE_LOADED));
			/**	이미지 스무싱	*/
			var bitmap:Bitmap = e.target.content as Bitmap;
			bitmap.smoothing = true;
			bitmap.bitmapData.lock();
			$model.imgOriginW = bitmap.width;
			$model.imgOriginH = bitmap.height;
			$nowPage.scaleX = 0.25;
			$nowPage.scaleY = 0.25;
			TweenLite.to($nowPage, 0.65, {x:0, ease:Cubic.easeOut, onComplete:clickTrue});
			TweenLite.to($con.loadingMC, 0.5, {autoAlpha:0, onComplete:resetLoadingMC});
			
			/**	최초 실행시 과거 페이지 없음	*/
			if($prevPage == null) return;
			
			if($model.direction == "right") TweenLite.to($prevPage, 0.65, {x:-$con.plane.width, ease:Cubic.easeOut, onComplete:removePrevPage});
			else if($model.direction == "left") TweenLite.to($prevPage, 0.65, {x:$con.plane.width, ease:Cubic.easeOut, onComplete:removePrevPage});
		}
		
		private function clickTrue():void
		{
			$model.clickCheck = true;
		}
		
		private function resetLoadingMC():void
		{
			$con.loadingMC.gotoAndStop(1);
		}
		
		/**	페이지 제거	*/
		private function removePrevPage():void
		{
			var i:int = $model.pageArr.length - 1;
			while (i >= 1)
			{
				$model.pageArr[i].unloadAndStop();
				$con.img.removeChild($model.pageArr[i]);
				$model.pageArr[i] = null;
				$model.pageArr.pop();
				i--;
			}
			
			trace("페이지 번호: " + $model.pageNum);
			trace("컨테이너 자식 수 : " + $con.img.numChildren, "페이지 배열 수: " + $model.pageArr.length);
		}
	}
}