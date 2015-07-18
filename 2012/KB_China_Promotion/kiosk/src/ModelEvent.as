package
{
	
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		
		// 인덱스한테 보내기
		public static const KB_INDEX:String = "kb.index";
		public static const KB_INTRO:String = "kb.intro";
		public static const KB_MODEL:String = "kb.model";
		public static const KB_PHOTO:String = "kb.photo";
		
		/**	메인으로 가기	*/
		public static const GO_TO_MAIN:String = "goToMain";
		/**	메인으로 가기	*/
		public static const GO_TO_MODEL_MAIN:String = "goToModelMain";
		/**	서브메뉴 선택	*/
		public static const SELECTED_SUB_MENU:String = "selectedSubMenu";
		/**	GNB 서브메뉴 선택	*/
		public static const SELECTED_GNB_MENU:String = "selectedGnbMenu";
		
		/**	모델 페이지 팝업 띄우기	*/
		public static const MODEL_POPUP:String = "modelPopup";
		/**	모델 리스트 로드 완료	*/
		public static const MODEL_LIST_LOADED:String = "modelListLoaded";
		/**	리스트 재배열	*/
		public static const LIST_CHANGE:String = "listChange";
		public static const LIST_ALPHA_1:String = "listAlpha1";
		
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}