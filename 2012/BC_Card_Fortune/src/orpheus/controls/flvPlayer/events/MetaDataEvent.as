package orpheus.controls.flvPlayer.events {
	import flash.events.Event;		/**
	 * @author p2ri
	 */
	public class MetaDataEvent extends Event 	{
		public var info:Object;		public static const METADATA:String = "MetaData_Event";		public function MetaDataEvent(info:Object, type:String, bubbles:Boolean = false, cancelable:Boolean = false)		{
			this.info = info;			super(type, bubbles, cancelable);
		}				override public function clone():Event		{			return new MetaDataEvent(info, type, bubbles, cancelable);		}	}
}
