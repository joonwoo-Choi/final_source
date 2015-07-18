package com.utils {
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	public class NetUtil {
		public static function isBrowser():Boolean {
			if( Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") return true;
			else return false;
		}

		public static function getLoaded( $target:* ):Boolean {
			return ( $target.parent == null ) ? true : false;
		}

		static public function getParam( $scope:DisplayObject, $param:Object ):Object {
			if( Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External" ) 	{
				return $param;
				
			} else {
				$param = $scope.loaderInfo.parameters;
			}
			
			var params:Object = {};
			
			for( var prop:String in $param ) {
				var flashVars:String = $scope.loaderInfo.parameters[ prop ];
				
				if( flashVars != null ) {
					params[ prop ] = flashVars;
				}
				
				params[ prop ] = $param[ prop ];
			}
			
			return params;
		}
	}
}