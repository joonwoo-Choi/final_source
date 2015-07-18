package contents.sub
{
	import away3d.core.utils.Color;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**		
	 *	SK2_Hersheys :: 서브 종이 내용
	 */
	public class PaperGallery extends Sprite
	{
		/**	그래픽	*/
		private var container:PaperGalleryClip;
		/**	보여질 페이지 이미지 내용*/
		private var page:MovieClip;
		/**	현제 보고 있는 페이지	*/
		private var cPos:int;
		
		/**	중앙 종이 내용부분	*/
		private var paperMc:MovieClip;
		
		/**	사라지는 모습	*/
		private var outBit:Bitmap;
		
		/**	생성자	*/
		public function PaperGallery($page:MovieClip)
		{
			super();
			
			page = $page;
			init();
			setBtn();
		}
		/**	초기화	*/
		private function init():void
		{
			cPos = 1;
			page.gotoAndStop(cPos);
			
			container = new PaperGalleryClip();
			paperMc = container.paperMc as MovieClip;
			container.x = 237;
			container.y = 163;
			
			var imgMc:MovieClip = paperMc.imgMc as MovieClip;
			imgMc.addChild(page);
			
			outBit = new Bitmap(new BitmapData(page.width,page.height,true,0x00ffffff));
			outBit.alpha = 0;
			paperMc.addChild(outBit);
			paperMc.addChild(imgMc);
			outBit.x = imgMc.x;
			outBit.y = imgMc.y;
			
			addChild(container);
			
			paperMc.alpha = 0;
			paperMc.rotation = 10;
			page.alpha = 0;
			TweenMax.to(page,0,{colorMatrixFilter:{contrast:2},alpha:0});
			TweenMax.to(page,2,{delay:0.5,colorMatrixFilter:{contrast:1},alpha:1,ease:Expo.easeOut});
			TweenMax.to(paperMc,1,{alpha:1,rotation:0,ease:Expo.easeOut});
		}
		/**	페이지 이동	*/
		private function movePage(dir:int):void
		{
			cPos += dir;
			if(cPos < 1) cPos = 1;
			if(cPos > page.totalFrames) cPos = page.totalFrames;
			
			if(cPos == page.currentFrame) return;
			
			//TweenMax.to(page,0.5,{alpha:0,colorMatrixFilter:{contrast:3},ease:Expo.easeOut,onComplete:finishPaper});
			outBit.bitmapData.dispose();
			outBit.bitmapData = new BitmapData(page.width,page.height,true,0x00ffffff);
			outBit.bitmapData.draw(page);
			outBit.alpha = page.alpha;
			
			TweenMax.to(outBit,0.5,{alpha:0});
			TweenMax.to(page,0,{alpha:0,colorMatrixFilter:{contrast:3}});
			finishPaper();
		}
		
		/**	페이퍼 이동 위치 도달	*/
		private function finishPaper():void
		{
			if(page.alpha != 0) return;
			
			page.gotoAndStop(cPos);
			TweenMax.to(page,1,{alpha:1,overwrite:0,ease:Expo.easeOut});
			TweenMax.to(page,2,{colorMatrixFilter:{contrast:1},ease:Expo.easeOut});
		}
		/** 페이지 이동 버튼 	*/
		private function setBtn():void
		{
			for(var i:int = 1; i<=2; i++)
			{
				var btn:MovieClip = container["btn"+i] as MovieClip;
				btn.idx = i;
				btn.alpha = 0;
				
				btn.img.scaleX = 0.5;
				btn.img.scaleY = 0.5;
				
				TweenMax.to(btn,0.5,{delay:i*0.3,alpha:1});
				TweenMax.to(btn.img,0.5,{delay:i*0.3,scaleX:1,scaleY:1,ease:Expo.easeOut});				
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});		
			}
		}
		/**		*/
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc,0.5,{glowFilter:new GlowFilter(0x8A0005,1,4,4),ease:Expo.easeOut});
			TweenMax.to(mc.img,0.5,{scaleX:0.7,scaleY:0.7,tint:0xffffff,ease:Expo.easeOut});
		}
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc,0.5,{glowFilter:new GlowFilter(0xff0000,0,0,0),ease:Expo.easeOut});
			TweenMax.to(mc.img,0.5,{scaleX:1,scaleY:1,tint:null,ease:Expo.easeOut});		
		}
		private function onClick(mc:MovieClip):void
		{
			var num:int = -1;
			if(mc.idx == 2) num = 1;
			movePage(num);
		}
	}//class
}//package