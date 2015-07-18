package com.kgc.event
{
	
	import flash.events.Event;

	public class KGCEvent extends Event
	{
		/**	카다로그 리스트 로드 완료 	*/
		public static const CATALOGUE_LIST_LOADED:String = "catalogueListLoaded";
		/**	페이지 로드 완료 	*/
		public static const PAGE_LOADED:String = "pageLoaded";
		/**	줌버튼 기능 제거 	*/
		public static const RESET_ZOOM:String = "resetZoom";
		/**	줌 드래그 버튼 활성화 제거	*/
		public static const ZOOM_DRAGBTN_RESET:String = "zoomBtnReset";
		/**	섬네일 상태 업데이트	*/
		public static const THUMB_UPDATE:String = "thumbUpdate";
		/**	섬네일 드래그	*/
		public static const THUMB_DRAG:String = "thumbDrag";
		
		public function KGCEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}