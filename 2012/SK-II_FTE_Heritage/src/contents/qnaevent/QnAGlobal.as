package contents.qnaevent
{
	import contents.qnaevent.event.QnAEvent;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	/**		
	 *	SK2_Hersheys :: 전역 클래스 (싱글톤)
	 */
	public class QnAGlobal extends EventDispatcher
	{
		/**	인스턴스*/
		static private var ins:QnAGlobal = new QnAGlobal();
		/**	질문 위치	*/
		public var qPos:int;
		
		/**	영상 위 흰색 점	*/
		private var mcDot:MovieClip;
		
		/**	페이스북 로그인 여부	*/
		public var bFacebook:Boolean;
		
		/**	이벤트 완료 결과	*/
		private var completeEvent:Array;
		
		/**	생성자	*/
		public function QnAGlobal()
		{
			if(ins != null) throw new Error("QnAGlobal은 싱글톤 입니다.");
			init();
		}
		/**	인스턴스 반환	*/
		static public function getIns():QnAGlobal
		{	return ins;	}
		
		/**	초기화	*/
		private function init():void
		{
			bFacebook = false;
			completeEvent = ["",false,false,false,false,false];
		}
		/**	일정 위치 스텝으로 이동	*/
		public function moveStep(pos:int):void
		{
			dispatchEvent(new QnAEvent(QnAEvent.STEP_MOVE,pos,{}));
		}
		/**	버튼 이름 바꾸기 위한 이벤트	*/
		public function changeBtnB(pos:int):void
		{
			dispatchEvent(new QnAEvent(QnAEvent.CHANGE_BTN_B,pos,{}));
		}
		/**	버튼 이름 바꾸기 위한 이벤트	*/
		public function changeBtnA(pos:int):void
		{
			dispatchEvent(new QnAEvent(QnAEvent.CHANGE_BTN_A,pos,{}));
		}
		
		/**	영상 위 흰색 점	구성	*/
		public function setDot(mc:MovieClip):void
		{	mcDot = mc;		}
		
		/**	영상 위 흰색 점	보여지기	*/
		public function viewDot():void
		{	
			if(mcDot == null) return; 
			mcDot.visible = true;	
		}
		
		/**	영상 위 흰색 점	가려지기	*/
		public function hideDot():void
		{	
			if(mcDot == null) return; 
			mcDot.visible = false;	
		}
		/**	이벤트 참여 결과 반환	*/
		public function getComplete():Array
		{	return completeEvent;	}
		/**	이벤트 참여	*/
		public function setComplete(pos:int):void
		{
			if(pos < 1 || pos > 5) return;
			completeEvent[pos] = true;
		}
	}//class
}//package