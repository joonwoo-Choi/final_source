package com.cj.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.Security;

	public class NetUtil
	{
		private static var req:URLRequest = new URLRequest();
		private static const WINDOW_OPEN_FNC:String = "window.open";
		
		public function NetUtil(){}
		
		static public function isWeb():Boolean 
		{
			return ( Security.sandboxType == Security.REMOTE ) ? true : false;
		}
		
		static public function isBrowser():Boolean 
		{
			if( Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn" ){
				return true;
			}else{
				return false;
			}
		}
		
		static public function getURL( $url:String, $window:String="_self" ):void
		{
			trace("GET URL: " + $url);
			if(isWeb()==false) return;
			req.url = $url;
			navigateToURL( req, $window );
		}
		
		/**
		 * 팝업방지 기능때문에 팝업이 제대로 실행못하는경우
		 * 자바스크립트의 window.open 함수를 이용하여 해결. 
		 * @param url
		 * @param window
		 */		
		static public function openWindow(url:String, window:String="_blank"):void
		{
			JSUtil.call(WINDOW_OPEN_FNC, url, window);
		}
		
		/**
		 * 로컬상태를 구분해서 경로 반환
		 * @param $local
		 * @param $web
		 * @return 
		 * 
		 */		
		static public function getHostPath($local:String, $web:String):String
		{
			var webBool:Boolean = NetUtil.isWeb();
			var browserBool:Boolean = NetUtil.isBrowser();
			var str:String;
			
			if(webBool && browserBool){
				str = $web;
			}else{
				str = $local;
			}
			return str;
		}
	}
}