package orpheus.templete.countDown
{
	import flash.events.Event;
	
	public class CountDownEvent extends Event
	{
		public static const NUMBER_CHANGED:String = "numberChanged";
		public static const NUMBER_CHANGED2:String = "numberChanged2";
		public function CountDownEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}