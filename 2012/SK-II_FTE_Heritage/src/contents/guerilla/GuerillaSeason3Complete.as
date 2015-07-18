package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	
	import event.MovieEvent;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	
	import util.BGM;
	
	/**		
	 *	SK2_Hersheys :: 화이트데이 게릴라 이벤트 완료 모습
	 */
	public class GuerillaSeason3Complete extends BaseGuerilla
	{
		private var btn:MovieClip;
		
		/**	생성자	*/
		public function GuerillaSeason3Complete($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
			//btnMc.visible = false;
			init();
			gapX = 0;
			gapY = -15;
			
			btn = btnMc.btn1 as MovieClip;
			btnMc.scaleX = 0.7;
			btnMc.scaleY = 0.8;
			btnMc.rotation = 1;
			btnMc.alpha = 0;
			
			//btn.alpha = 1;
			btn.width += 20;
			btn.height += 20;
			btn.x -= 10;
			btn.y -= 10;
			setMenu();
			
			if(Global.getIns().bgm != null)
			{
				Global.getIns().bgm.destroy();
				Global.getIns().bgm = null;
			}
			Global.getIns().bgm = new BGM(Global.getIns().rootURL+"asset/bgm.mp3");
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			
		}
		/**	버튼 구성	*/
		private function setMenu():void
		{
			for(var i:int = 1; i<=2; i++)
			{
				var btn:MovieClip = btnMc["btn"+i] as MovieClip;
				btn.view = viewMc["btn"+i] as MovieClip;
				TweenMax.to(btn.view,0,{tint:0xffffff});
				MovieClip(btn.view).blendMode = BlendMode.OVERLAY;
				btn.idx = i;
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
		}
		/**	마우스 오버	*/
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:0.8,ease:Expo.easeOut});
		}
		/**	마우스 아웃	*/
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:0,ease:Expo.easeOut});
		}
		/**	클릭	*/
		private function onClick(mc:MovieClip):void
		{
			if(mc.idx == 1)
			{//다음 영상으로 넘어가기
				playNextMovie();
			}
			if(mc.idx == 2)
			{//이전 영상으로 넘어가기
				playPrevMovie();
			}
		}
		
	}//class
}//package