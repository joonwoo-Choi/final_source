package com.kgc.main
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kgc.control.PageLoad;
	import com.kgc.event.KGCEvent;
	import com.kgc.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Main
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $pageLoad:PageLoad;
		
		private var $dragCatalouge:DragCatalogue;
		
		private var $thumb:Thumb;
		
		private var $btnTabLength:int = 5;
		
		private var $btnCenterLength:int = 2;
		
		private var $btnZoomLength:int = 3;
		
		private var $btnTabArr:Array;
		
		private var $btnZoomArr:Array;
		
		private var $tabBtnNum:int = 0;
		
		public function Main(con:MovieClip)
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(KGCEvent.CATALOGUE_LIST_LOADED, makeButton);
			$model.addEventListener(KGCEvent.PAGE_LOADED, tabBtnChange);
			$model.addEventListener(KGCEvent.ZOOM_DRAGBTN_RESET, zoomDragBtnReset);
			
			$pageLoad = new PageLoad();
			$dragCatalouge = new DragCatalogue($con.imgCon);
			$thumb = new Thumb($con.thumbCon);
		}
		
		protected function zoomDragBtnReset(e:Event):void
		{
			TweenLite.to($btnZoomArr[2].over, 0.35, {alpha:0});
		}
		
		protected function tabBtnChange(e:Event):void
		{
			activeTabButton($tabBtnNum);
		}
		
		private function makeButton(e:Event):void
		{
			/**	상단 버튼	*/
			$btnTabArr = []
			var i:int
			for (i = 0; i < $btnTabLength; i++) 
			{
				var btnTabs:MovieClip = $con.getChildByName("btnTab" + i) as MovieClip;
				btnTabs.no = i;
				$btnTabArr.push(btnTabs);
				ButtonUtil.makeButton(btnTabs, btnTabChange);
			}
			
			/**	중앙 버튼	*/
			var j:int;
			for (j = 0; j < $btnCenterLength; j++) 
			{
				var btnCenters:MovieClip = $con.getChildByName("btnCenter" + j) as MovieClip;
				btnCenters.no = j;
				ButtonUtil.makeButton(btnCenters, pageNumChange);
			}
			
			/**	하단 버튼	*/
			$btnZoomArr = [];
			var k:int;
			for (k = 0; k < $btnZoomLength; k++) 
			{
				var btnZooms:MovieClip = $con.getChildByName("btnZoom" + k) as MovieClip;
				btnZooms.no = k;
				$btnZoomArr.push(btnZooms);
				ButtonUtil.makeButton(btnZooms, zoomInOut);
			}
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
			
			pageChange(1);
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			JavaScriptUtil.call("closeCatalogue");
		}
		
		
		/**
		 * 상단 버튼
		 * /
		/**	페이지 이동	*/
		private function btnTabChange(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(target.out, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(target.out, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK : 
					if($model.clickCheck == false) return;
					
					if($tabBtnNum > target.no) $model.direction = "left";
					else if($tabBtnNum < target.no) $model.direction = "right";
					$tabBtnNum = target.no;
					
					loadImg($tabBtnNum);
//					activeTabButton(target.no);
					break;
			}
		}
		/**	탭버튼 활성화	*/
		private function activeTabButton(num:int):void
		{
			for (var i:int = 0; i < $btnTabLength; i++) 
			{
				if(i == num)
				{	TweenLite.to($btnTabArr[i].over, 0.5, {delay:0.5, y:0, ease:Expo.easeOut});		}
				else
				{	TweenLite.to($btnTabArr[i].over, 0.5, {delay:0.5, y:$btnTabArr[i].over.height, ease:Expo.easeOut});		}
			}
		}
		
		private function loadImg(num:int):void
		{
			if($model.pageNum == $model.listStartNumArr[num]) return;
			$model.pageNum = $model.listStartNumArr[num];
			pageStatusCheck();
//			$pageLoad.load($model.pageNum, $con.imgCon);
		}
		
		/**
		 * 중앙 버튼
		 * /
		/**	페이지 번호 / 방향 설정	*/
		private function pageNumChange(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target.over, 0.35, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target.over, 0.35, {alpha:0});
					break;
				case MouseEvent.CLICK : 
					if($model.clickCheck == false) return;
					
					if(target.no == 0) $model.direction = "left";
					else if(target.no == 1) $model.direction = "right";
					pageChange(target.no);
					
					break;
			}
		}
		/**	페이지 이동	*/
		private function pageChange(num:int):void
		{
			if(num == 0) $model.pageNum--;
			else if(num == 1) $model.pageNum++;
			
			if($model.pageNum < 0) $model.pageNum = $model.lastPageNum;
			else if($model.pageNum > $model.lastPageNum) $model.pageNum = 0;
			
			/**	탭버튼 번호 검사	*/
			var tabBtnNum:int;
			for (var i:int = 0; i < $btnTabLength; i++) 
			{
				if($model.pageNum >= $model.listStartNumArr[$btnTabLength - 1])
				{
					tabBtnNum = $btnTabLength - 1;
					break;
				}
				else if($model.pageNum < $model.listStartNumArr[i]) 
				{
					tabBtnNum = i - 1;
					break;
				}
			}
			trace("탭버튼 번호: " + tabBtnNum);
			$tabBtnNum = tabBtnNum;
			pageStatusCheck();
		}
		/**	페이지 크기 위치 체크 후 페이지 로드	*/
		private function pageStatusCheck():void
		{
			if($model.pageArr[0] != null && $model.pageArr[0].scaleX != 0.25)
			{
				TweenLite.to($model.pageArr[0], 0.5, {x:0, y:0, scaleX:0.25, scaleY:0.25, ease:Expo.easeOut, onComplete:pageLoad});
			}
			else 
			{
				pageLoad();
			}
		}	
		/**	페이지 로드	*/
		private function pageLoad():void
		{
			$pageLoad.load($model.pageNum, $con.imgCon);
			$thumb.thumbSetting();
			$model.dispatchEvent(new KGCEvent(KGCEvent.RESET_ZOOM));
			$model.thumbX = $model.thumbY = 0;
			$model.pageScale = 1;
			$model.dispatchEvent(new KGCEvent(KGCEvent.THUMB_UPDATE));
		}
		
		
		/**
		 * 하단 버튼
		 * /
		/**	확대 축소	*/
		private function zoomInOut(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(target.out, 0.5, {colorTransform:{exposure:1.15}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(target.out, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					if($model.clickCheck == false) return;
					
					activeZoomButton(target.no);
					break;
			}
		}
		/**	줌버튼 활성화	*/
		private function activeZoomButton(num:int):void
		{
			var i:int;
			for (i = 0; i < $btnZoomLength; i++) 
			{
				if(i == num)
				{
					if(i == 2) 
					{
						if($model.pageArr[0].scaleX > 0.25) return;
						if($btnZoomArr[i].over.alpha == 0)
						{
							TweenLite.to($btnZoomArr[i].over, 0.35, {alpha:1});
							$dragCatalouge.setZoomType(i);
						}
						else
						{
							TweenLite.to($btnZoomArr[i].over, 0.35, {alpha:0});
							$dragCatalouge.setZoomType(-1);
						}
					}
					else
					{
						$btnZoomArr[i].over.alpha = 0;
						TweenLite.to($btnZoomArr[i].over, 0.5, {alpha:1, reversed:true});
						$dragCatalouge.setZoomType(i);
					}
				}
				else
				{
					TweenLite.to($btnZoomArr[i].over, 0.35, {alpha:0});
				}
			}
		}
	}
}