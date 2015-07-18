package adqua.event
{
	import flash.events.Event;

	public class XMLLoaderEvent extends Event
	{
		public static const XML_COMPLETE:String = "xmlComplete";
		public static const XML_ERROR:String = "xmlError";
		public static var XML_PROGRESS:String = "xmlProgress";

		public var xml:XML;
		public var error:String;
		public var bytesLoaded:Number;
		public var bytesTotal:Number;

		public function XMLLoaderEvent( data:*, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			switch (type)
			{
				case XML_COMPLETE : 
					this.xml = data; 
					break;
				case XML_ERROR : 
					this.error = data; 
					break;
				case XML_PROGRESS :	
					this.bytesLoaded = data["bytesLoaded"]; 
					this.bytesTotal = data["bytesTotal"]; 
					
					break;
			}
		}

		override public function clone():Event
		{
			return new XMLLoaderEvent(this.xml, this.type, this.bubbles, this.cancelable);
		}
	}
}