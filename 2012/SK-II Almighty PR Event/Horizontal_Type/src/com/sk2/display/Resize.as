package com.sk2.display
{
	import com.greensock.loading.display.ContentDisplay;
	import com.sk2.utils.DataProvider;
	import com.sw.display.BaseResize;
	import com.sw.display.SetBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
//	import org.papervision3d.materials.MovieAssetMaterial;

	/**
	 * SK2	::	윈도우 크기 조절
	 * */
	public class Resize extends BaseResize
	{
		private var layout:Layout;
		private var wSpace:int;
		/**	생성자	*/
		public function Resize($scope:DisplayObjectContainer)
		{
			super($scope);
			init();
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**
		 * 초기화
		 * */
		override protected function init():void
		{
			layout = DataProvider.layout;
			super.init();
			setMin(1000,600);
			wSpace = -140;
		}
		/**
		 * 윈도우 크기 조절시
		 * */
		override protected function onResize(e:Event):void
		{
			super.onResize(e);
			
			if(layout.loading.numChildren != 0)	resizeBase();			
//			if(layout.navi.numChildren != 0)	resizeNavi();
			if(layout.sub_mc.numChildren != 0)	resizeSub();
			if(layout.bg.numChildren != 0)		resizeBg();
			if(layout.pop.numChildren != 0)		resizePop();
		}
		/**	기본 위치 조절	*/
		public function resizeBase():void
		{
			layout.plane.width = layout.lock_plane.width = sw;
			layout.plane.height = layout.lock_plane.height = sh;
			
			var loading_mc:MovieClip =	layout.loading.getChildAt(0) as MovieClip;
			if(loading_mc == null) return;
			loading_mc.x = Math.round(sw/2);
			loading_mc.y = Math.round(sh/2)-30;
			
		}
		/**	메뉴 내용 위치 조절	*/
		public function resizeNavi():void
		{
			var navi_mc:MovieClip =	layout.getMc(layout.navi);
			if(navi_mc == null) return;
			
			var posX:int = Math.round((sw - navi_mc.plane_mc.width)/2);
			var posY:int = Math.round((sh - navi_mc.plane_mc.height)/2);
			if(posX < wSpace) posX = wSpace;
			//if(posY < 0) posY = 0;
			navi_mc.x = posX;
			navi_mc.y = posY;
			
			navi_mc.logo_mc.x = posX*-1;
			navi_mc.logo_mc.y = 
			navi_mc.top_mc.y = posY*-1;
			
			navi_mc.top_mc.x = (sw-navi_mc.top_mc.plane_mc.width)-posX;
		}
		
		/**	팝업 내용 조절	*/
		public function resizePop():void
		{
			var pop_mc:MovieClip =	layout.getMc(layout.pop);
			if(pop_mc == null) return;
			layout.pop.x = Math.round((sw - pop_mc.plane_mc.width)/2);
			layout.pop.y = Math.round((sh - pop_mc.plane_mc.height)/2);
			
			pop_mc.visible = false;
		}
		
		/**	배경 위치조절	*/
		public function resizeBg():void
		{
			var bg_mc:MovieClip = layout.bg_mc;
			if(!bg_mc.dw) return;
			var dw:Number = sw;
			var dh:Number = sh;
			if(dw < 1500 ) dw = 1500;
			if(dh < 900 ) dh = 900;
			
			bg_mc.width = dw;
			bg_mc.height = (bg_mc.dh/bg_mc.dw)*dw;
			if(bg_mc.height < sh+100)
			{
				bg_mc.height = dh+100;
				bg_mc.width = (bg_mc.dw/bg_mc.dh)*(sh+100);
			}
			bg_mc.x = Math.round((sw-bg_mc.width)/2);
			bg_mc.y = Math.round((sh-bg_mc.height)/2);
		}
		/**	서브 내용 위치 조절	*/
		public function resizeSub():void
		{
			var sub_mc:MovieClip = layout.getMc(layout.sub_mc);
			//trace(layout.sub_mc.numChildren);
			
			if(sub_mc == null) return;
			var sub:Sprite = layout.sub;
			sub.x = Math.round((sw-sub_mc.plane_mc.width)/2);
			sub.y = Math.round((sh-sub_mc.plane_mc.height)/2);
			if(sub.x < wSpace) sub.x = wSpace;
			//if(sub.y < 0) sub.y = 0;
			
			var bg_img:MovieClip = sub_mc.bg_img;
			if(sub_mc.bg_img == null) return;
			bg_img.height = sh;
			if(bg_img.img != null) SetBitmap.go(bg_img.img,true);
			if(bg_img.height < bg_img.plane_mc.height) 
			{
				bg_img.height = bg_img.plane_mc.height;
				if(bg_img.img != null) SetBitmap.go(bg_img.img,false);
			}
			bg_img.width = (bg_img.plane_mc.width/bg_img.plane_mc.height)*bg_img.height;
		
			bg_img.x = Math.round((sw - bg_img.width)/2)-sub.x;
			bg_img.y = Math.round((sh - bg_img.height)/2)-sub.y;
		}
		
	}//class
}//package