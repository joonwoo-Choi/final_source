package com.adqua.events {
	import flash.events.*;

	public class VIDEOLoaderEvent extends Event {
		public static const GET_INFORMATION:String = "getInformation";
		public static const PLAY_START:String = "playStart";
		public static const PLAY_COMPLETE:String = "playComplete";
		public static const PLAYED_TIME:String = "playerTime";
		public static const LOAD_BYTES:String = "loadBytes";

		protected var _info:Object;


		public function VIDEOLoaderEvent( $type:String, $info:Object, $bubbles:Boolean=false, $cancelable:Boolean=false ) {
			super( $type, $bubbles, $cancelable );

			_info = $info;
		}

		override public function clone():Event {
			return new VIDEOLoaderEvent( type, target, bubbles, cancelable );
		}

		override public function toString():String {
			return formatToString( "VIDEOLoaderEvent", "type", "target", "bubbles", "cancelable" );
		}

		override public function get target():Object {
			return _info;
		}

		public function get playedTime():Number { return Number( target.playedTime ); 	}
		public function get duration():Number { return Number( target.duration ); }
	}
}