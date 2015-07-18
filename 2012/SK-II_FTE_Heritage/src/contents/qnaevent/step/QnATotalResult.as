package contents.qnaevent.step
{
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	import util.BtnHersheys;
	
	/**		
	 * SK2_Hersheys :: Q&A 전체 결과
	 */
	public class QnATotalResult extends BaseQnAStep
	{
		private var container:QnATotalResultClip;
		
		/**	생성자	*/
		public function QnATotalResult(mc:MovieClip=null)
		{
			container = new QnATotalResultClip();
			init();
			super(container);
		}
		/**	초기화	*/
		private function init():void
		{
			container.bg.gotoAndStop(1);
			container.btnComplete.x = 192;
			container.btnInvite.visible = true;
			BtnHersheys.getIns().go(container.btnComplete,onClickComplete);
			BtnHersheys.getIns().go(container.btnInvite,onClickInvite);
			BtnHersheys.getIns().go(container.btnBuy,onClickBuy);
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
		
		protected function onLogin(event:Event):void
		{
			// TODO Auto-generated method stub
			QnAGlobal.getIns().moveStep(7);
		}
		/**	이벤트 완료 버튼	*/
		private function onClickComplete(mc:MovieClip):void
		{
			QnAGlobal.getIns().moveStep(0);
		}
		/**	구매하기 버튼	*/
		private function onClickBuy(mc:MovieClip):void
		{
			HersheysFncOut.buy();
		}
		
		/**	초대하기 버튼 클릭	*/
		private function onClickInvite(mc:MovieClip):void
		{
			HersheysFncOut.qnaLoginFB();
			
			//QnAGlobal.getIns().moveStep(7);
		}
	}//class
}//package