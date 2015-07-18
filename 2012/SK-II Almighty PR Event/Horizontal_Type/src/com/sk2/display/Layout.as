package com.sk2.display
{
	import com.sk2.utils.DataProvider;
	import com.sw.display.BaseLayout;
	import com.sw.display.PlaneClip;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
//	import org.papervision3d.materials.MovieAssetMaterial;

	/**
	 * SK2	::	화면 구성
	 * */
	public class Layout extends BaseLayout
	{
		public var container:Sprite;
		
		public var plane:PlaneClip;
		public var bg:Sprite;
		public var bg_mc:MovieClip;
		public var bg_bit:Bitmap;
		public var sub:Sprite;
		public var sub_mc:MovieClip;
		public var sub_in_bit:Bitmap;
		public var sub_out_bit:Bitmap;
		public var navi:Sprite;
		public var lock_plane:PlaneClip;
		public var pop:Sprite;
		public var loading:Sprite;
		
		/**	생성자	*/
		public function Layout()
		{
			super();
			init();
			addObject();
		}
		/**	소멸자	 */
		override public function destroy():void
		{		
			super.destroy();
		}
		/**
		 * 초기화
		 * */
		override protected function init():void
		{
			super.init();
			container = new Sprite();
			plane = new PlaneClip({color:0xffffff});
			bg = new Sprite();
			bg_mc = new MovieClip();
			bg_bit = new Bitmap();
			sub = new Sprite();
			sub_mc = new MovieClip();
			sub_in_bit = new Bitmap();
			sub_out_bit = new Bitmap();
			navi = new Sprite();
			lock_plane = new PlaneClip({color:0x000000});
			lock_plane.alpha = 0.5;
			lock_plane.visible = false;
			pop = new Sprite();
			loading = new Sprite();
		}
		public function addObject():void
		{
			DataProvider.stage.addChild(container);
			container.addChild(plane);
			
			container.addChild(bg);
			bg.addChild(bg_bit);
			bg.addChild(bg_mc);
			
			container.addChild(sub);
			sub.addChild(sub_out_bit);
			sub.addChild(sub_mc);
			sub.addChild(sub_in_bit);
			
			container.addChild(navi);
			
			container.addChild(lock_plane);
			container.addChild(pop);
			container.addChild(loading);		
		}
	}//class
}//package