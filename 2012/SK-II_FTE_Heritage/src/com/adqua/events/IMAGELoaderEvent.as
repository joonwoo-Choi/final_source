package com.adqua.events {
	import flash.events.*;

	public class IMAGELoaderEvent extends Event {
		public static const IO_ERROR:String = "ioError";
		public static const SECURITY_ERROR:String = "securityError";
		public static const OPEN:String = "open";
		public static const PROGRESS:String = "progress";
		public static const INIT:String = "init";
		public static const COMPLETE:String = "complete";
		public static const UNLOAD:String = "unload";

		protected var _target:Object;


		public function IMAGELoaderEvent( $type:String, $param:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false ) {
			super( $type, $bubbles, $cancelable );

			_target = $param;
		}

		override public function clone():Event {
			return new IMAGELoaderEvent( type, target, bubbles, cancelable );
		}

		override public function toString():String {
			return formatToString( "IMAGELoaderEvent", "type", "target", "bubbles", "cancelable", "eventPhase" );
		}

		override public function get target():Object {
			return _target;
		}
	}
}