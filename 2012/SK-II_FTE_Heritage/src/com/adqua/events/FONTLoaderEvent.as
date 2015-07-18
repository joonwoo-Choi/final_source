package com.adqua.events {
	import flash.events.*;
	import flash.text.*;

	public class FONTLoaderEvent extends Event {
		public static const IO_ERROR:String = "ioError";
		public static const COMPLETE:String = "complete";

		protected var _target:Object;


		public function FONTLoaderEvent( $type:String, $param:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false ) {
			super( $type, $bubbles, $cancelable );

			_target = $param;
		}

		override public function clone():Event {
			return new FONTLoaderEvent( type, target, bubbles, cancelable );
		}

		override public function get target():Object {
			return _target;
		}
	}
}