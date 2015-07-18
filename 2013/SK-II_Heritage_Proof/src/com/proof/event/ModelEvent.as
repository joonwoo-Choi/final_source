package com.proof.event
{
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		
		/**	플레이 리스트 로드 완료	*/
		public static const PLAY_LIST_LOADED:String = "playListLoaded";
		/**	메인 바코드 포커스 타이머 시작	*/
		public static const SET_FOCUS_BARCODE:String = "setFocusBarcode";
		/** 영상 셋팅 **/
		public static const VIDEO_SETTING:String = "videoSetting";
		/** 영상 플레이 시작 **/
		public static const VIDEO_PLAY:String = "videoPlay";
		/**	영상 종료	*/
		public static const VIDEO_STOP:String = "videoStop"
		/**	비디오 제거	*/
		public static const VIDEO_DESTROY:String = "videoDestroy";
		/**	팝업 보이기	*/
		public static const SHOW_POPUP:String = "showPopup";
		/**	메인 보이기	*/
		public static const KIOSK_MAIN:String = "kioskMain";
		/**	키오스크 페이지 1 보이기	*/
		public static const KIOSK_PAGE_ONE:String = "kioskPageOne";
		/**	키오스크 페이지 2 보이기	*/
		public static const KIOSK_PAGE_TWO:String = "kioskPageTwo";
		/**	사이트 서브 랭킹 팝업 데이터 없음 페이지	*/
		public static const DATA_NO:String = "dataNo";
		/**	메뉴 변경 영상 리스트 수정	*/
		public static const MENU_CHANGE:String = "menuChange";
		/**	코스모 컨텐츠 시작	*/
		public static const COSMO_START:String = "cosmoStart";
		/**	키오스트 시즌2 페이스북 이벤트 이미지 보내기	*/
		public static const SEND_IMG:String = "sendImg";
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}