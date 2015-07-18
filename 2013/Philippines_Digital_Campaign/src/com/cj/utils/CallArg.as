package com.cj.utils
{
	import flash.events.Event;
	
	public class CallArg
	{
        public function CallArg(){}
        
		public static function create(method:Function, ... args):Function 
		{
			return function(event:Event):void
			{				
				method.apply(null, [event].concat(args));
			}		
		}
     }

}