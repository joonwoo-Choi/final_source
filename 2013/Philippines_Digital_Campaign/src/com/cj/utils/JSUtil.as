package com.cj.utils
{
	import flash.external.ExternalInterface;
	
	public class JSUtil
	{
		public function JSUtil() { }
		
		// 자바스크립트호출
		static public function call( $method:String, ... args ):Object
        {
			var argsStr:String="";
			if(args.length > 0){
				for(var i:int = 0; i < args.length; ++i)
				{
					if(i == args.length-1) argsStr = argsStr.concat(args[i]);
					else argsStr = argsStr.concat(args[i] + ", ");
				}
			}
			trace("[자바스크립트 호출] " + $method + "(" + argsStr + ")");
			
            var rtn: Object;
        	if( ExternalInterface.available )
				rtn = ExternalInterface.call.apply( null, [ $method ].concat( args ) );
            
            return rtn;
        }
		
		// 자바스크립트가 플래시함수 호출하기
		static public function callBack( $jsFnName:String, $fn:Function ):void
		{
			if( ExternalInterface.available )
				ExternalInterface.addCallback( $jsFnName, $fn );
		}
		
		// alert창 띄우기
		static public function alert( $str:String ):void
		{
			trace("alert:"+$str);
			if ( ExternalInterface.available )
				ExternalInterface.call( "alert", $str );
		}
	}

}