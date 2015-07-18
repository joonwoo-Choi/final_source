package contents.qnaevent
{
	import com.sw.display.PlaneClip;
	
	import contents.qnaevent.event.QnAEvent;
	import contents.qnaevent.step.BaseQnAStep;
	import contents.qnaevent.step.QnAFriend;
	import contents.qnaevent.step.QnAMain;
	import contents.qnaevent.step.QnAResult;
	import contents.qnaevent.step.QnAStep;
	import contents.qnaevent.step.QnAStepMovie;
	import contents.qnaevent.step.QnATotalResult;
	import contents.qnaevent.step.QnAVote;
	import contents.qnaevent.step.QnAWrite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.CallBack;
	
	/**		
	 *	SK2_Hersheys :: Q&A 이벤트 구현 내용
	 */
	[SWF(width="830",height="466",frameRate="30")]
	public class QnAMovie extends MovieClip
	{
		/**	서브 step내용 class	*/
		private var classAry:Array;
		/**	뒷 부분 판*/
		private var plane:PlaneClip;
		
		/**	생성자	*/
		public function QnAMovie()
		{
			super();
			
			init();	
			QnAGlobal.getIns().addEventListener(QnAEvent.STEP_MOVE,onMoveStep);
			QnAGlobal.getIns().moveStep(0);
			addEventListener(Event.REMOVED_FROM_STAGE,destroy);
			Global.getIns().addEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onFacebook);
		}
		/**	비회원 로그인	*/
		private function onLogin(e:Event):void
		{
			QnAGlobal.getIns().bFacebook = false;
		}
		/**	페이스북 로그인	*/
		private function onFacebook(e:Event):void
		{
			QnAGlobal.getIns().bFacebook = true;
		}
		/**	초기화	*/
		private function init():void
		{
			classAry = [QnAStep,QnAMain,QnAStepMovie,QnAWrite,QnAVote,QnAResult,QnATotalResult,QnAFriend];
			
			plane = new PlaneClip({color:0xffffff});
			plane.name = "plane";
			plane.width = 830;
			plane.height = 466;
			addChild(plane);
		}
		
		/**	step 구성	*/
		private function onMoveStep(e:QnAEvent):void
		{
			for(var i:int = 0; i<numChildren; i++)
			{
				var step:BaseQnAStep = getChildAt(i) as BaseQnAStep;
				if(step == null) continue;
				step.hide();
			}
			var newStep:BaseQnAStep = new classAry[e.pos]();
			addChild(newStep);
		}
		//x 312
		/**	소멸자	*/
		public function destroy(e:Event = null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			QnAGlobal.getIns().removeEventListener(QnAEvent.STEP_MOVE,onMoveStep);
			
			for(var i:int = 0; i<numChildren; i++)
			{
				var step:BaseQnAStep = getChildAt(i) as BaseQnAStep;
				if(step == null) continue;
				step.destroy();
			}
		}
	}//class
}//package