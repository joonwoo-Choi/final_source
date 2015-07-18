package contents.qnaevent.step
{
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	
	import util.BtnHersheys;

	/**		
	 * SK2_Hersheys :: Q&A 초기 진입 페이지
	 */ 
	public class QnAStep extends BaseQnAStep
	{
		private var container:QnAStepClip;
		
		/**	생성자	*/
		public function QnAStep(mc:MovieClip = null)
		{
			container = new QnAStepClip();
			
			super(container);
			/**	버튼화	*/
			BtnHersheys.getIns().go(container.btn,onClick);
		}
		
		/**	리스트 내용으로 이동	*/
		private function onClick(mc:MovieClip):void
		{
			QnAGlobal.getIns().moveStep(1);
		}
		
	}//class
}//package