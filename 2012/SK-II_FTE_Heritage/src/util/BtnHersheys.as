package util
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.display.PlaneClip;
	import com.sw.display.Remove;
	import com.sw.utils.McData;
	import com.sw.utils.book.Book;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;

	/**		
	 *	SK2FND :: 버튼 오버 효과 공통 (싱글톤)
	 */
	public class BtnHersheys
	{
		/**	인스턴스	*/
		static private var ins:BtnHersheys = new BtnHersheys();
		/**	버튼 모션 알파 사용 여부	*/
		private var bAlpha:Boolean;
		
		/**	생성자	*/
		public function BtnHersheys()
		{
			
		}
		/**	인스턴스 반환	*/
		static public function getIns():BtnHersheys
		{	return ins;	}
		/**	버튼 구현	*/
		public function go(btn:MovieClip,fnc:Function):void
		{
			McData.save(btn);
			Remove.child(btn);
			
			var plane1:PlaneClip = createPlane(btn);
			var plane2:PlaneClip = createPlane(btn);
			plane2.height += 3;
			plane1.height = 1;
			btn.alpha = 1;
			btn.plane = plane1;
			btn.blendMode = BlendMode.OVERLAY;
			
			Button.setUI(btn,{over:onOver,out:onOut,click:fnc});
		}
		/**	버튼 안에 plane 생성	*/
		private function createPlane(mc:MovieClip):PlaneClip
		{
			//var plane:PlaneClip = new PlaneClip({color:0xC90101});
			var plane:PlaneClip = new PlaneClip({color:0xffffff});
			plane.width = mc.dw;
			plane.height = mc.dh;
			plane.alpha = 0;
			
			mc.scaleX = 1;
			mc.scaleY = 1;
			mc.addChild(plane);
			
			return plane;
		}
		/**	버튼 오버 효과	*/
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc.plane,0,{alpha:0,y:0,height:1});	
			TweenMax.to(mc.plane,1,{alpha:0.5,height:mc.height,ease:Expo.easeOut});	
		}
		/**	버튼 아웃 효과	*/
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc.plane,1,{alpha:0,height:1,y:mc.height-2,ease:Expo.easeOut});
		}
		
		/**	동영상 플레이어 마우스 오버 효과	*/
		public function playBtn(mc:MovieClip,fnc:Function,$bAlpha:Boolean = false):void
		{
			bAlpha = $bAlpha;
			Button.setUI(mc,{over:onOverPlay,out:onOutPlay,click:fnc});
		}
		/**	영상 플레이 버튼 오버	*/
		private function onOverPlay(mc:MovieClip):void
		{
			var obj:Object = new Object();
			obj.ease = Expo.easeOut;
			obj.colorMatrixFilter = {contrast:3};
			obj.glowFilter = new GlowFilter(0xffffff,1,4,4);
			if(bAlpha == true) obj.alpha = 1;
			TweenMax.to(mc,1,obj);
		}
		/**	영상 플레이 버튼 아웃	*/
		private function onOutPlay(mc:MovieClip):void
		{
			var obj:Object = new Object();
			obj.ease = Expo.easeOut;
			obj.colorMatrixFilter = {contrast:1};
			obj.glowFilter = new GlowFilter(0xffffff,0,0,0);
			if(bAlpha == true) obj.alpha = 0;
			
			TweenMax.to(mc,1,obj);
		}
		
		/**	썸네일 버튼 움직임	*/
		static public function move(mc:MovieClip,dir:String="over",ease:Object=null,speed:Number=0.7):void
		{
			if(mc == null) return;
			if(ease == null) ease = Expo.easeOut;
			
			var alpha:Number = 1;
			var height:int = mc.overMc.height;
			var colObj:Object = {contrast:1};
			if(dir == "out") 
			{
				alpha = 0;
				height = 2;
				colObj = {contrast:3};
			}
			TweenMax.to(mc.overImg,speed,{alpha:alpha,ease:ease,colorMatrixFilter:colObj});
			TweenMax.to(mc.overMc,speed,{alpha:alpha,ease:ease});
			TweenMax.to(mc.maskOver,speed,{height:height,ease:ease});
		}
	}//class
}//package