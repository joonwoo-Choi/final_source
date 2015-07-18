package com.cj.events
{
	import flash.events.Event;

    public class ValueEvent extends Event
    {
		public static const GET_OBJECT:String = "getObject";
		
        private var _value:Object;

        public function ValueEvent(type:String, value:Object, bubbles:Boolean = true, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
			
            _value = value;
        }

		override public function toString():String 
		{
			return formatToString("ValueEvent", "type", "value", "bubbles", "cancelable");
		}
		
		override public function clone():Event
		{
			return new ValueEvent(type, value, bubbles, cancelable);
		}
		
        public function get value():Object
        {
            return _value;
        }

    }
}
