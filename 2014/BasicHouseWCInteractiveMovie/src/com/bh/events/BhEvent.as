package com.bh.events
{
	import flash.events.Event;
	
	public class BhEvent extends Event
	{
		
		/**	영상 플레이	*/
		public static const VIDEO_PLAY:String = "videoPlay";
		/**	메인 컨텐츠 시작	*/
		public static const MAIN_CONTENTS_START:String = "mainContentsStart";
		/**	응원 카운트 갱신	*/
		public static const CHEERS_COUNT_CHECK:String = "cheersCountCheck";
		/**	좋아요 사람들 이미지 변경	*/
		public static const LIKE_PEOPLE_CHANGE:String = "likePeopleChange";
		/**	카드섹션 변경	*/
		public static const CARDSECTION_CHANGE:String = "cardsectionChange";
		/**	무비 재생	*/
		public static const PLAY_VIDEO:String = "playVideo";
		/**	무비 일시정지	*/
		public static const PAUSE_VIDEO:String = "pauseVideo";
		/**	무비 다시 재생	*/
		public static const RESUME_VIDEO:String = "resumeVideo";
		/**	카드 색션 다시 재생	*/
		public static const RESUME_CARDSECTION:String = "resumeCardsection";
		/**	영상 변경	*/
		public static const CHANGE_VIDEO:String = "changeVideo";
		/**	카드섹션 종료	*/
		public static const FINISH_CARDSECTION:String = "finishCardsection";
		/**	풀 영상 재생	*/
		public static const PLAY_FULL_VIDEO:String = "playFullVideo";
		/**	풀영상 닫기	*/
		public static const CLOSED_FULL_VIDEO:String = "closedFullVideo";
		/**	카드 리사이즈	*/
		public static const CARD_RESIZE:String = "cardResize";
		/**	풀 영상 카드섹션	*/
		public static const FULL_CARDSECTION_START:String = "fullCardsectionStart";
		/**	풀 영상 카드섹션 종료	*/
		public static const FULL_CARDSECTION_FINISHED:String = "fullCardsectionFinished";
		/**	풀영상 버튼 숨기기	*/
		public static const HIDE_VIDEO_BUTTON:String = "hideVideoButton";
		/**	투네임 보이기	*/
		public static const SHOW_TONAME:String = "showToname";
		/**	프롬네임 보이기	*/
		public static const SHOW_FROMNAME:String = "showFromname";
		/**	컨텐츠 시작	*/
		public static const CONTENTS_INMOTION:String = "contentsInmotion";
		/**	볼륨 조절	*/
		public static const VOLUME_CHANGE:String = "volumeChange";
		/**	요소 숨기기	*/
		public static const HIDE_MAIN_CONTENTS:String = "hideMainContents";
		/**	무비 커버 보이기	*/
		public static const SHOW_MOVIE_COVER:String = "showMovieCover";
		/**	무비 커버 숨기기	*/
		public static const HIDE_MOVIE_COVER:String = "hideMovieCover";
		
		/**	메인 인풋 초기화	*/
		public static const INIT_MAIN_INPUT:String = "initMainInput";
		
		
		
		private var _value:Object;
		
		public function BhEvent(type:String, value:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_value = value;
		}
		
		public function get value():Object
		{
			return _value;
		}
	}
}