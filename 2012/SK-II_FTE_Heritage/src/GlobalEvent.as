package
{
	
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		/** XML 로드 완료 **/
		public static const XML_LOADED:String = "xmlLoaded";
		/** 페이지 이동 **/
		public static const PAGE_CHANGED:String = "pageChanged";
		/** 비디오 플레이 **/
		public static const VIDEO_PLAY:String = "videoPlay";
		/** 비디오 일시 정지 **/
		public static const VIDEO_PAUSE:String = "videoPause";
		/** 비디오 정지 **/
		public static const VIDEO_STOP:String = "videoStop";
		/** 비디오 채도 알파 **/
		public static const VIDEO_ON:String = "videoOn";
		/** 비디오 채도 알파 **/
		public static const VIDEO_OFF:String = "videoOff";
		/** 중앙 버튼 **/
		public static const CENTER_BUTTON:String = "centerButton";
		/** 페이스북 리셋 **/
		public static const RESET_BUTTON:String = "resetButton";
		/** 페이스북 이벤트 완료 창 **/
		public static const FBEVENT_CLEAR:String = "eventClear";
		/** 페이스북 이벤트 로딩 창 **/
		public static const FBEVENT_LOADING:String = "eventLoading";
		/** 페이스북 이벤트 완료 **/
		public static const FBEVENT_COMPLETE:String = "eventComplete";
		/** 팝업 닫기 **/
		public static const POPUP_CLOSE:String = "popupClose";
		/** 스페셜 페이지 온 **/
		public static const PAGE_SPECIAL_ON:String = "pageSpecialON";
		/** 스페셜 페이지 오프 **/
		public static const PAGE_SPECIAL_OFF:String = "pageSpecialOFF";
		
		public static const FB_SHOW:String = "facebookShow";
		
		public static const PLUS_FLIP_COUNT:String = "plusFlipCount";

		public static const SPECIAL_BTN_CLICK:String = "specialBtnClick";
		
		public static const MOVIE_COUNT_CHANGED:String = "movieCountChanged";
		
		public static const ADD_MOUSE_MOVE:String = "addMouseMove";
		
		public static const ACTIVE_RESIZE:String = "activeResize";
		
		public static const USER_LOAD_COMPLETE:String = "userNameLoadComplete";
		
		public function GlobalEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}