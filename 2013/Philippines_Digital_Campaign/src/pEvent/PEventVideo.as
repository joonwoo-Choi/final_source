package pEvent
{
	import flash.events.Event;
	
	public class PEventVideo extends Event
	{
		public static const VIDEO_CLEAR:String = "videoClear";
		public static const VIDEO_HIDE:String = "videoHide";
		public static const VIDEO_CLOSE:String = "videoClose";
		public static const VIDEO_SHOW:String = "videoShow";		
		public static const VIDEO_PAUSE:String = "videoPause";		
		public function PEventVideo(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}