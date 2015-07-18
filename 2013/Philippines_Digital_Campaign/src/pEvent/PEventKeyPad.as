package pEvent
{
	import flash.events.Event;
	
	public class PEventKeyPad extends Event
	{
		public static const PHONE_NUM_CHECKED:String = "phoneNumChecked";
		
		public static const MOVIE_GROUP_CHANGED:String = "movieGroupChanged";
		public static const MOVIE_GROUP_USERINFO_START:String = "movieGroupUserInfoStart";
		
		public static const GET_PHOTO_LOADED:String = "getPhotoLoaded";
		public static const XML_VIDEOINFO_LOADED:String = "xmlVideoInfoLoaded";
		public static const MMS_SENT:String = "mmsSent";
		public static const SENT_TEXT:String = "textSent";
		
		public static const FEATURE_COMPLETE:String = "featureComplete";
		public static const FEATURE_COMPLETE_TEST:String = "featureCompleteTest";
		public static const FEATURE_COMPLETE_RETURN:String = "featureCompleteReturn";//서버에서 리턴받는수간 발생
		
		
		public static const KEY_MOVIE_FINISHED:String = "keyMovieFinished";
		
		
		public static const VOLUMN_DOWN:String = "volumnDown";
		public static const VOLUMN_UP:String = "volumnUp";
		
		
		public function PEventKeyPad(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}