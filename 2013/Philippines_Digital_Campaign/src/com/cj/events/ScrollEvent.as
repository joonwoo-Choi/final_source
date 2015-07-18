package com.cj.events
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const CHANGED:String = "changed";
		public static const POS_UPDATE:String = "posUpdate";
		
		private var _pos:Number;
		public function get pos():Number
		{
			return _pos;
		}
		
		public function ScrollEvent(type:String, pos:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._pos = pos;
		}
		
		public override function clone():Event
		{
			return new ScrollEvent(type, _pos);
		}
		
		public override function toString():String
		{
			return formatToString("ScrollBarEvent", "type", "pos", "bubbles", "cancelable", "eventPhase");
		}
	}
}