package com.adqua.events {
	import flash.events.*;

	public class CustomEvent extends Event {
		public var param:Object;


		public function CustomEvent( $type:String, $param:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=false ):void {
			super( $type, $bubbles, $cancelable );
			
			param = $param;
		}

		override public function clone():Event {
			return new CustomEvent( type, param, bubbles, cancelable );
		}

		override public function toString():String {
			return formatToString( "CustomEvent", "type", "param", "bubbles", "cancelable", "eventPhase" );
		}
	}
}