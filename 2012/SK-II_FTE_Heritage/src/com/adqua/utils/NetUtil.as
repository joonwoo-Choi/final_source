package com.adqua.utils {
	import flash.display.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.*;

	public class NetUtil extends Object {
		static public function isWeb():Boolean {
			return ( Security.sandboxType == Security.REMOTE ) ? true : false;
		}

		static public function isBrowser():Boolean {
			if( Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn" ) return true;
			else return false;
		}

		static public function isLocal( $scope:DisplayObjectContainer ):Boolean {
			if( $scope.loaderInfo.loaderURL.substr(0, 4) == "file" ) return true;
			else return false;
		}

		static public function getURL( $url:String, $window:String="_self" ):void {
			var _url:String = $url.substr( 0, 11 );
			_url.toLowerCase();

			if( _url != "javascript:" ) {
				navigateToURL( new URLRequest( $url ), $window );

			} else {
				JavaScriptUtil.call( $url.substring( 11 ) );
			}
		}
	}
}