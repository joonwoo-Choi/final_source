package orpheus.utils
{
	import flash.external.ExternalInterface;
	
	public class CookieUtil
	{
		public function CookieUtil()
		{
		}
		
		private static const FUNCTION_SETCOOKIE:String = 
            "document.insertScript = function ()" +
            "{ " +
                "if (document.flash_func_setCookie==null)" +
                "{" +
                    "flash_func_setCookie = function (name, value, days)" +
                    "{" +
                        "if (days) {"+
							"var date = new Date();"+
							"date.setTime(date.getTime()+(days*24*60*60*1000));"+
							"var expires = '; expires='+date.toGMTString();"+
						"}" +
						"else var expires = '';"+
						"document.cookie = name+'='+value+expires+'; path=/';" +
		            "}" +
                "}" +
            "}";
		
		private static const FUNCTION_GETCOOKIE:String = 
            "document.insertScript = function ()" +
            "{ " +
                "if (document.flash_func_getCookie==null)" +
                "{" +
                    "flash_func_getCookie = function (name)" +
                    "{" +
                        "var nameEQ = name + '=';"+
						"var ca = document.cookie.split(';');"+
						"for(var i=0;i < ca.length;i++) {"+
							"var c = ca[i];"+
							"while (c.charAt(0)==' ') c = c.substring(1,c.length);"+
							"if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);"+
						"}"+
						"return null;" +
		            "}" +
                "}" +
            "}";
     
            
        private static var INITIALIZED:Boolean = false;
		
		private static function init():void
		{
			ExternalInterface.call(FUNCTION_GETCOOKIE);
			ExternalInterface.call(FUNCTION_SETCOOKIE);
			INITIALIZED = true;
		}
		
		public static function setCookie(name:String, value:String, days:int):void
		{
			if(!INITIALIZED) init();
			
			ExternalInterface.call("flash_func_setCookie", name, value, days);
		}
		
		public static function getCookie(name:String):String
		{
			if(!INITIALIZED) init();
			
			return String(ExternalInterface.call("flash_func_getCookie", name));
		}
		
		public static function deleteCookie(name:String):void
		{
			if(!INITIALIZED) init();
			
			ExternalInterface.call("flash_func_setCookie", name, "", -1);
		}
	}
}