package com.lol.events
{
	import flash.events.Event;
	
	public class LolEvent extends Event
	{
		
		/**	영상 플레이	*/
		public static const VIDEO_PLAY:String = "videoPlay";
		/**	영상 정지	*/
		public static const VIDEO_STOP:String = "videoStop";
		/**	일시정지	*/
		public static const VIDEO_PAUSE:String = "videoPause";
		/**	다시재생	*/
		public static const VIDEO_RESUME:String = "videoResume";
		/**	SWF 영상 플레이	*/
		public static const SWF_VIDEO_PLAY:String = "swfVideoPlay";
		/**	딤드 On	*/
		public static const DIMMED_ON:String = "dimmedOn";
		/**	딤드 Off	*/
		public static const DIMMED_OFF:String = "dimmedOff";
		/**	선택지 팝업 오픈	*/
		public static const SELECT_POPUP_OPEN:String = "selectPopupOpen";
		/**	선택지 팝업 클로즈	*/
		public static const SELECT_POPUP_CLOSE:String = "selectPopupClose";
		/**	인터랙션 팝업 오픈	*/
		public static const INTERACTION_POPUP_OPEN:String = "interactionPopupOpen";
		/**	인터랙션 팝업 클로즈	*/
		public static const INTERACTION_POPUP_CLOSE:String = "interactionPopupClose";
		/**	타이머 시작	*/
		public static const TIMER_START:String = "timerStart";
		/**	타이머 중지	*/
		public static const TIMER_STOP:String = "timerStop";
		/**	타이머 종료	*/
		public static const TIMER_END:String = "timerEnd";
		/**	영상 정지화면 그리기	*/
		public static const DRAW_COVER:String = "drawCover";
		/**	영상 정지화면 지우기	*/
		public static const REMOVE_COVER:String = "removeCover";
		/**	로딩바 보이기	*/
		public static const SHOW_LOADING_BAR:String = "showLoadingBar";
		/**	로딩 중	*/
		public static const LOADING_PROGRESS:String = "loadingProgress";
		/**	로딩 숨기기	*/
		public static const HIDE_LOADING_BAR:String = "hideLoadingBar";
		/**	팝업 9 - 조합선택 채팅	*/
		public static const SELECT_TEAM_COMBINATION:String = "selecTeamCombination";
		/**	SWF영상 비우기	*/
		public static const REMOVE_SWF_VIDEO:String = "removeSwfVideo";
		/**	퀵메뉴 숨기기	*/
		public static const HIDE_QUICK_MENU:String = "hideQuickMenu";
		/**	패닝영상 버튼 숨기기	*/
		public static const HIDE_PANNING_BUTTON:String = "hidePanningButton";
		/**	전체 볼륨 체인지	*/
		public static const VOLUME_CHANGE:String = "volumeChange";
		
		/**	토크버튼 보이기	*/
		public static const SHOW_TALK_POPUP:String = "showTalkButton";
		/**	토크버튼 숨기기	*/
		public static const HIDE_TALK_POPUP:String = "hideTalkButton";
		
		/**	패닝영상 플레이	*/
		public static const PANNING_VIDEO_PLAY:String = "panningVideoPlay";
		/**	화면 숨기기	*/
		public static const PANNING_HIDE_CONTENTS:String = "panningHideContents";
		/**	패닝영상 종료	*/
		public static const PANNING_VIDEO_STOP:String = "panningVideoStop";
		
		/**	퀵메뉴 번호 보내기	*/
		public static const SEND_QUICK_NUM:String = "hideLoadingBar";
		/**	퀵메뉴 번호 받기	*/
		public static const REICIVE_QUICK_NUM:String = "hideLoadingBar";
		
		/**	리액션 팝업 보이기	*/
		public static const SHOW_REACTION_POPUP:String = "showReactionPopup";
		/**	리액션 팝업 숨기기	*/
		public static const HIDE_REACTION_POPUP:String = "hideReactionPopup";
		
//		/**	퀵메뉴 팝업 열기	*/
//		public static const SHOW_QUICK_POPUP:String = "showQuickPopup";
//		/**	퀵메뉴 팝업 닫기	*/
//		public static const HIDE_QUICK_POPUP:String = "hideQuickPopup";
//		/**	퀵메뉴 영상 플레이	*/
//		public static const QUICK_VIDEO_PLAY:String = "quickVideoPlay";
		
//		/**	인터랙티브 무비 언어 변경	*/
//		public static const CHANGE_LANGUAGE:String = "changeLanguage";
		
		public function LolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}