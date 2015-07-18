package orpheus.control.scrollbar.events 
{
	import flash.events.Event;

	/**
	 * @author philip
	 */
	public class ScrollEvent extends Event 
	{
		public var value:Number;
		public static const CHANGE:String = "CHANGE";
		public static const MOUSE_DOWN:String = "BTN_DOWN";
		public static const MOUSE_UP:String = "BTN_UP";
		public static const MOUSE_WHEEL:String = "mosue_wheel";

		public function ScrollEvent(type:String, value:Number = NaN, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.value = value;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new ScrollEvent(type, value, bubbles, cancelable);
		}
	}
}
