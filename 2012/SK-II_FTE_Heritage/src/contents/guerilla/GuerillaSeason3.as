package contents.guerilla
{
	import adqua.net.Debug;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.utils.McData;
	
	import event.MovieEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	import util.BGM;
	
	/**		
	 *	SK2_Hersheys :: 화이트데이 게릴라 이벤트
	 */
	public class GuerillaSeason3 extends BaseGuerilla
	{
		/**	생성자	*/
		public function GuerillaSeason3($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
			//btnMc.visible = false;
			init();
			setMenu();
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			
			viewMc.btnSnd.gotoAndStop(2);
			btnMc.btnSnd.gotoAndStop(2);
			
			btnMc.scaleX = 0.96;
			btnMc.scaleY = 0.97;
			btnMc.rotation = -15;
			
			btnMc.alpha = 0;
			//btnMc.imgMc.alpha = 0;
			//배경 음악 플레이
			destroyBGM();
			Global.getIns().bgm = new BGM(Global.getIns().rootURL+"asset/SK_II_AR.mp3");
			
			Global.getIns().addEventListener(CallBack.BELL,onCallBell);
		}
		/**	개인정보 입력 완료	*/
		private function onCallBell(e:MovieEvent):void
		{
			playNextMovie();
		}
		/**	메뉴 구성	*/
		private function setMenu():void
		{
			for(var i:int = 1; i<=3; i++)
			{
				var btn:MovieClip = btnMc["btn"+i] as MovieClip;
				btn.idx = i;
				btn.view = viewMc["btn"+i] as MovieClip;
				btn.view.gotoAndStop(i);
				
				if(btn.dx == null) 
				{
					McData.save(btn);
					btn.x -= 10;
					btn.y -= 10;
					btn.height += 10;
					btn.width += 20;
				}
				//btn.alpha = 0.5;
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
			btnMc.btnSnd.view = viewMc.btnSnd;
			Button.setUI(btnMc.btnSnd,{click:onClickSnd});
		}
		/**		*/
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:1,ease:Expo.easeOut});
		}
		/**		*/
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:0,ease:Expo.easeOut});
		}
		/**		*/
		private function onClick(mc:MovieClip):void
		{
			if(mc.idx == 3)
			{
				playNextMovie();
				return;
			}
			
			Global.getIns().callbackSate = CallBack.BELL;
			
			if(mc.idx == 1) {
				Debug.alert("이벤트가 종료되었습니다.");
//				HersheysFncOut.downBell();
			}
			if(mc.idx == 2) HersheysFncOut.downRing();
		}
		/**	음악 플레이, 멈추기,	*/
		private function onClickSnd(mc:MovieClip):void
		{
			if(mc.view.currentFrame == 1)
			{
				mc.view.nextFrame();
				Global.getIns().bgm.setSnd("on");
			}
			else
			{
				mc.view.prevFrame();
				Global.getIns().bgm.setSnd("off");
			}
		}
		/**	사운드 없에기	*/
		private function destroyBGM():void
		{
			if(Global.getIns().bgm != null)
			{
				Global.getIns().bgm.destroy();
				Global.getIns().bgm = null;
			}
		}
		/**	소멸자	*/
		override public function destroy(e:Event = null):void
		{
			super.destroy();
			Global.getIns().removeEventListener(CallBack.BELL,onCallBell);
			destroyBGM();
		}
	}//class
}//package