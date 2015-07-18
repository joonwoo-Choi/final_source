package orpheus.events {
	/**
	 * @author kdh.
	 */
	import flash.events.Event;
	import flash.text.TextFormat;	

	public class EmbedFontEvent extends Event {
		public static const EMBED_COMPLETE : String = "embedComplete";
		public static const EMBED_ERROR : String = "embedError";

		public var _format : TextFormat;
		public var _error : String;

		public function EmbedFontEvent(vars : *, type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			switch (type) {
				case EMBED_COMPLETE : 
					_format = vars;
					break;
				case EMBED_ERROR :
					_error = vars;
					break;
			}
		}

		override public function clone() : Event {
			return new EmbedFontEvent(this._format, type, this.bubbles, this.cancelable);
		}
	}
}