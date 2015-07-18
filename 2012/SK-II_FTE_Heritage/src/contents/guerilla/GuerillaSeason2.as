package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	
	import event.MovieEvent;
	
	import flash.display.MovieClip;
	
	import net.CallBack;
	
	/**		
	 *	SK2_Hersheys :: 환절기 게릴라 이벤트
	 */
	public class GuerillaSeason2 extends BaseGuerilla
	{
		
		/**	생성자	*/
		public function GuerillaSeason2($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
			btnMc.visible = false;
			init();
		}
		/**	보여지기	*/
		public function view():void
		{
			btnMc.visible = true;
			
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			
			for(var i:int = 1; i<=4; i++)
			{
				var btn:MovieClip = btnMc["btn"+i] as MovieClip;
				
				btn.idx = i;
				btn.overMc.gotoAndStop(i);
				btn.outMc.gotoAndStop(i);
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
		}
		private function onOver(mc:MovieClip):void
		{	TweenMax.to(mc.maskMc,1.2,{width:mc.overMc.width+20,ease:Expo.easeOut});	}
		private function onOut(mc:MovieClip):void
		{	TweenMax.to(mc.maskMc,0.7,{width:1,ease:Expo.easeOut});	}
		
		/**	투표 메뉴 클릭	*/
		private function onClick(mc:MovieClip):void
		{
			Global.getIns().callbackSate = CallBack.VOTE;
			Global.getIns().addEventListener(CallBack.VOTE,onCallbackVote);
			FncOut.call("guerilla2Validation",mc.idx);
			
			if(Location.setURL("swf","") == "swf") onCallbackVote(null);
		}
		/**	투표 완료 후 다음영상으로 넘어 가기	*/
		private function onCallbackVote(e:MovieEvent):void
		{
			Global.getIns().removeEventListener(CallBack.VOTE,onCallbackVote);
			Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.NEXT));
		}
		
	}//class
}//package