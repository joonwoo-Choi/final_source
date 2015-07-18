package com.app 
{//Package
	import com.jac.facebook.FBUtils;
	import com.jac.log.Log;
	import com.jac.log.targets.BrowserConsoleTarget;
	import com.jac.log.targets.TraceTarget;
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLVariables;
	
	public class AuthConnectorMain extends MovieClip
	{//AuthConnectorMain Class
	
		private var _lcID:String="";
		private var _lc:LocalConnection;
		private var _token:String="";
		
		public function AuthConnectorMain() 
		{//AuthConnectorMain
			Log.addLogTarget(new TraceTarget());
			Log.addLogTarget(new BrowserConsoleTarget());
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		}//AuthConnectorMain
		
		private function handleAddedToStage(e:Event):void 
		{//handleAddedToStage
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			if (ExternalInterface.available)
			{//get params
				//Get access token
				_token = getToken();
				
				//Get LocalConnection ID
				_lcID = ExternalInterface.call("getLCID");
				
				if (_lcID && _lcID != "")
				{//send token
					_lc = new LocalConnection();
					_lc.addEventListener(StatusEvent.STATUS, handleStatus, false, 0, true);
					_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncError, false, 0, true);
					_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError, false, 0, true);
					
					//Send token
					Log.log("ID: " + _lcID);
					_lc.send(_lcID, "confirmAuthentication", _token);
				}//send token
			}//get params
			
			
		}//handleAddedToStage
		
		private function getToken():String
		{//getToken
			if (ExternalInterface.available)
			{//get hash
				var hash:String = ExternalInterface.call("getHash");
				var token:String = FBUtils.hashToToken(hash);
				return token;
			}//get hash
			
			return null;
		}//getToken
		
		private function handleSecurityError(e:SecurityErrorEvent):void 
		{//handleSecurityError
			Log.logError("Security Error: " + e.text);
		}//handleSecurityError
		
		private function handleAsyncError(e:AsyncErrorEvent):void 
		{//handleAsyncError
			Log.logError("Async Error: " + e.error.message);
		}//handleAsyncError
		
		private function handleStatus(e:StatusEvent):void 
		{//handleStatus
			switch(e.level)
			{//switch
				case "status":
					if (ExternalInterface.available)
					{//close window
						ExternalInterface.call("closeWindow");
					}//close window
				break;
				
				case "error":
					Log.logError("Send Failed: " + e.code);
				break;
				
			}//switch
		}//handleStatus
		
	}//AuthConnectorMain Class

}//Package