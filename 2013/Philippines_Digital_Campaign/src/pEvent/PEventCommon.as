package pEvent
{
	import flash.events.Event;
	
	public class PEventCommon extends Event
	{
		
		public static const REMOVE_INTERACTION:String = "removeInteraction";
		
		public static const MOVIE_CHANGE:String = "changeMovie";
		public static const MOVIE_PAUSE:String = "changePause";
		public static const MOVIE_RESUME:String = "changeResume";
		public static const MOVIE_REMOVE:String = "movieRemove";
		public static const MOVIE_PLAY_FINISHED:String = "movieFinished";
		
		public static const SWF_CONTENT_LOAD:String = "swfContentLoad";
		
		public static const MOVIE_GROUP_CHANGED:String = "movieGroupChanged";
		public static const MOVIE_GROUP_USERINFO_START:String = "movieGroupUserInfoStart";
		
		public static const GALLERY_MAIN:String = "galleryMain";
		public static const GALLERY_LOAD:String = "galleryLoad";
		public static const SPOT_MAIN:String = "spotMain";
		
		public static const MAKE_DAYBG:String = "makeDaybg";
		
		public static const GNB_OPEN_ON:String = "gnbOpenOn";
		public static const GNB_OPEN_OFF:String = "gnbOpenOff";
		public static const GNB_OPEN_ONOFF:String = "gnbOpenOnOff";
		public static const GNB_ACTIVE_ON:String = "gnbActiveOn";
		
		public static const SKIP_OPEN_ON:String = "skipOpenOn";
		public static const SKIP_OPEN_OFF:String = "skipOpenOff";
		public static const SKIP_OPEN_DEL:String = "skipOpenDel";
		
		public static const YELLOW_OPEN:String = "yellowOpen";
		public static const YELLOW_CLOSE:String = "yellowClose";
		
		
		public static const MOVIE_ROUTE_PLAY:String = "movieRoutePlay";
		public static const MOVIE_EVENT_PLAY:String = "movieEventPlay";
		
		public static const CONTENT_DOWNLOADED:String = "contentDownloaded";
		
		public static const PROGRESS:String = "loadingProgress";
		public static const LOADING_MAKE:String = "makeLoading";
		public static const LOADING_MAKE_NOT_NUMBER:String = "makeLoadingFacebook";
		public static const LOADING_HIDE_COMPLETE:String = "loadingHideComplete";
		
		public static const POPBG_SHOW:String = "popBgShow";
		public static const POPBG_HIDE:String = "popBgHide";
		
		public static const RETRY_GOLF:String = "retryGolf";
		public static const RESELECT_PRODUCT:String = "reselectProduct";
		
		public static const MAIN_CHANGE:String = "mainChange";
		
		public static const TIMER_INTER_PLAY:String = "timerInterPlay";
		
		
		public static const KEY_NEXT_MOV:String = "keyNextMov";
		public static const KEY_PREV_MOV:String = "keyPrevMov";
		
		public static const ROUTE_MENU_SHOW:String = "RouteMenuShow";
		public static const ROUTE_MENU_HIDE:String = "RouteMenuHide";
		
		public static const MAIN_POPUP_SHOW:String = "MainPopShow";

		public static const POP_CLICK_PLAY:String = "PopClickPlay";
		public static const POP_CLICK_PAUSE:String = "PopClickPause";
		
		public static const MALL_POP_OPEN:String = "MallPopOpen";
		public static const MALL_POP_CLOSE:String = "MallPopClose";
		
		public static const BOT_REMOVE:String = "BotRemove";
		
		public static const DESTROY_INTERACTION:String = "DestroyInteraction";
		
		public static const HPTITLE_STOP:String = "HptitleStop";
		
		public static const SKIP_INTERACTION:String = "SkipInteraction";
		public static const MOVIE_PLAY_START:String = "moviePlayStart";
		
		public static const INTRO_NEXT:String = "IntroNext";
		public static const NOTICE_START:String = "noticeStart";

		public static const REMOVE_POPUP_EVENT:String = "removePopupEvent";
		
		
		public function PEventCommon(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}