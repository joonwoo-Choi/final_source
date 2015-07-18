package contents.movie
{
	import contents.qnaevent.QnAGlobal;
	import contents.qnaevent.event.QnAEvent;
	
	import event.MovieEvent;
	
	import flash.events.Event;

	/**		
	 *	SK2_Hersheys :: QnA 내용
	 */
	public class QnATime extends BaseMovie
	{
		/**	생성자	*/
		public function QnATime(data:Object=null)
		{
			super(data);
			
			init();
		}
		/**	초기화	*/
		override protected function init():void
		{
			loadPath = MovieEvent.Q_AND_A_PATH;
			loadAry = ["QnAMovie"];
			
			super.init();
			
			QnAGlobal.getIns().setDot(getDotMc());
			QnAGlobal.getIns().hideDot();
		}
		
		
		/**	영상이 실행되는 매 순간 실행 함수	*/
		override protected function onEnter(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,onEnter);
		}
		override public function destroy():void
		{
			super.destroy();
			
		}
	}//class
}//package