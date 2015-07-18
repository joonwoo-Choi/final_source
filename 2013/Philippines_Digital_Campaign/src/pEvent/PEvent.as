package pEvent
{
	import flash.events.Event;
	
	public class PEvent extends Event
	{
		public static const MOVIE_CHANGE:String = "changeMovie";
		public static const MOVIE_PLAY_FINISHED:String = "movieFinished";
		
		public static const SWF_CONTENT_LOAD:String = "swfContentLoad";
		
		public static const VIDEO_CLEAR:String = "videoClear";
		public static const VIDEO_HIDE:String = "videoHide";
		public static const VIDEO_CLOSE:String = "videoClose";
		public static const VIDEO_SHOW:String = "videoShow";
	
		public static const MOVIE_GROUP_CHANGED:String = "movieGroupChanged";
		public static const MOVIE_GROUP_USERINFO_START:String = "movieGroupUserInfoStart";
		
		public static const PROGRESS:String = "loadingProgress";
		public static const LOADING_MAKE:String = "makeLoading";
		public static const LOADING_MAKE_NOT_NUMBER:String = "makeLoadingFacebook";
		public static const LOADING_HIDE_COMPLETE:String = "loadingHideComplete";
		
		public static const GALLERY_MAIN:String = "galleryMain";
		public static const GALLERY_LOAD:String = "galleryLoad";
		public static const SPOT_MAIN:String = "spotMain";
		public static const MAKE_DAYBG:String = "makeDaybg";
		
		public static const CHANGE_MOVIE:String = "changeMovie";
		
		public static const GNB_OPEN_ON:String = "gnbOpenOn";
		public static const GNB_OPEN_OFF:String = "gnbOpenOff";
		
		public static const ACTIVE_MENU_CHECK:String = "activeMenuCheckMovie";//사용자가 본 영상 체크표시함
		
		public function PEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}