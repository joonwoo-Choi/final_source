package
{
	
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		
		/** 페이지 롤링	*/
		public static const PAGE_ROLLING:String = "pageRolling";
		/** 리뷰 페이지 보이기	*/
		public static const REVIEW_PAGE_VIEW:String = "reviePageView";
		/** 리뷰 페이지 닫기	*/
		public static const REVIEW_PAGE_CLOSE:String = "reviePageClose";
		/** 타이머 일시정지 	*/
		public static const TIMER_PAUSE:String = "timerPause";
		/** 타이머 시작	*/
		public static const TIMER_START:String = "timerStart";
		/** 타이머 정지	*/
		public static const TIMER_STOP:String = "timerStop";
		/** evtOneCon 띄우기	*/
		public static const EVT_ONE_VIEW:String = "evtOneView";
		/** 키보드 리셋	*/
		public static const KEYBOARD_RESET:String = "keyboardReset";
		/** evtTwoCon 띄우기	*/
		public static const EVT_TWO_VIEW:String = "evtTwoView";
		/** 초대장 더 보내기	*/
		public static const FRIENDS_INVITE:String = "friendsInvite";
		/**	완료 페이지 띄우기	*/
		public static const COMPLETE_PAGE:String = "completePage";
		
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}