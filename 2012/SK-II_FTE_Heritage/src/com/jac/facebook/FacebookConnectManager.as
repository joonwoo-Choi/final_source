package com.jac.facebook 
{//Package
	import com.adobe.serialization.json.JSON;
	import com.jac.facebook.events.FacebookEvent;
	import com.jac.facebook.net.events.FBRequestEvent;
	import com.jac.facebook.net.FBRequest;
	import com.jac.log.Log;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	
	
	public class FacebookConnectManager extends EventDispatcher
	{//FacebookConnectManager Class
	
		protected var _appID:String;
		protected var _redirectURI:String;
		protected var _scope:String;
		protected var _useHTTPS:Boolean;
		
		protected var _jsConfirmCallback:String = "confirmFacebookConnection";
        protected var _jsWindowName:String = "facebookConnector";
		protected var _httpApiURL:String = "http://graph.facebook.com";
		protected var _httpsApiURL:String = "https://graph.facebook.com";
		protected var _fcmSOPrefix:String = "FCMApp_";
		
		protected var _isAuthCallbackDefined:Boolean = false;
		protected var _uncheckedToken:String;
		protected var _token:String="";
		protected var _savedSession:SharedObject;
		protected var _isConnected:Boolean = false;
		protected var _userID:String = "";
		protected var _lc:LocalConnection;
		protected var _revalidateOnFailedCall:Boolean;
		
		public function FacebookConnectManager(appID:String, redirectURI:String, scope:String, useHTTPS:Boolean = false, revalidateOnFailedCall:Boolean = false) 
		{//FacebookConnectManager
			_appID = appID;
			_redirectURI = redirectURI;
			_scope = scope;
			_useHTTPS = useHTTPS;
			_revalidateOnFailedCall = revalidateOnFailedCall;
			
			addSWFFinder();
		}//FacebookConnectManager
		
		public function connect():void
		{//connect
			
			//setup lc for response from callback.html
			_lc = new LocalConnection();
			_lc.allowDomain("*");
			_lc.allowInsecureDomain("*");
			_lc.client = this;
			
			var lcID:String = ("_AuthConnectorLC_" + getTimer());
			try
			{//try to connect
				_lc.connect(lcID);
			}//try to connect
			catch (error:Error)
			{//error
				Log.logError("Can't Connect to: " + lcID + "... Connection is already in use", true);
			}//error
			
			openFacebookPopUp(lcID);
		}//connect
		
		protected function openFacebookPopUp(localConnectionID:String):void
		{//openFacebookPopUp
			//Update redirection link with new local connection ID
			var lcParams:String = localConnectionID;
			var fullRedirect:String = (_redirectURI + "?lcid=" + lcParams);
			var url:String = buildAuthURL(fullRedirect);
			
			if (ExternalInterface.available)
			{//handle through js
				var id:String = ExternalInterface.call("getSwfID");		//ADDED by addSWFFinder()
				var name:String = jsWindowName;
				var props:String = "width=670,height=370";
				var js:String = 'window.open("' + url + '", "' + name + '", "' + props + '");'
				ExternalInterface.call("function(){" + js + "}");
			}//handle through js
			else
			{//flash
				Log.log("Opening Facebook Webpage"+" , "+url);
				navigateToURL(new URLRequest(url), "_blank");
			}//flash
		}//openFacebookPopUp
		
		private function buildAuthURL(redirect:String):String
		{//buildAuthURL
			return apiPath + "/oauth/authorize"
                    + "?client_id=" + _appID 
                    + "&redirect_uri=" + redirect
                    + "&type=user_agent"
                    + "&scope=" + _scope
                    + "&display=popup";
		}//buildAuthURL
		
		public function quickConnectCheck():void
		{//quickConnectCheck
			verifySavedToken(true);
		}//quickConnectCheck
		
		public function fbPost(callback:Function, itemID:String, apiCall:String = "", paramObject:Object = null):void
		{//fbPost
			var fbReq:FBRequest = new FBRequest(callback, itemID, apiCall, _token, paramObject, URLLoaderDataFormat.TEXT, URLRequestMethod.POST);
			fbReq.addEventListener(FBRequestEvent.COMPLETE, handleFBRequestComplete, false, 0, false);
			fbReq.load();
		}//fbPost
		
		public function fbGet(callback:Function, itemID:String, apiCall:String = "", paramObject:Object = null):void
		{//fbPost
			var fbReq:FBRequest = new FBRequest(callback, itemID, apiCall, _token, paramObject, URLLoaderDataFormat.TEXT, URLRequestMethod.GET);
			fbReq.addEventListener(FBRequestEvent.COMPLETE, handleFBRequestComplete, false, 0, false);
			fbReq.load();
		}//fbPost
		
		protected function handleFBRequestComplete(e:FBRequestEvent):void 
		{//handleFBRequestComplete
			//Log.log("Handle Request COmplete: " + e.result);
			Log.log("Handle Request Complete: " + e.target.url);
			
			Log.logWarning("RESULT: " + e.successResult.success + " / " + _revalidateOnFailedCall);
			
			if (!e.successResult.success && _revalidateOnFailedCall)
			{//revalidate
				Log.log("Revalidate");
				_isConnected = false;
				quickConnectCheck();
			}//revalidate
			
			dispatchEvent(e);
		}//handleFBRequestComplete
		
		public function confirmAuthentication(token:String):void
		{//token
			Log.log("Confirm Connection: " + token);
			verifyToken(token);
		}//token
		
		protected function confirmConnection(locHash:String, isQuickCheck:Boolean=false):void
		{//confirmConnection
			Log.log("Confirm Connection");
			if (locHash)
			{//check token
				verifyToken(FBUtils.hashToToken(locHash), isQuickCheck);
			}//check token
		}//confirmConnection
		
		protected function verifyToken(token:String, isQuickCheck:Boolean = false):void
        {//verifyToken
			Log.log("Verify Token");
			
			if (token != "")
			{//good token
			
				var fbReq:FBRequest = new FBRequest(null, "me", "", token);
				
				Log.log("Requesting: " + fbReq.url);
				
				if (!isQuickCheck)
				{//connect after if fail
					fbReq.addEventListener(FBRequestEvent.COMPLETE, verifyTokenSuccess);
				}//connect after if fail
				else
				{//don't connect, quick check only
					fbReq.addEventListener(FBRequestEvent.COMPLETE, handleTokenCheckComplete);
				}//don't connect, quick check only
				
				fbReq.load();
			}//good token
			else
			{//bad token
				Log.log("Bad Token passed to verifier");
			}//bad token
        }//verifyToken
		
		protected function verifySavedToken(isQuickCheck:Boolean=false):void
        {//verifySavedToken
			Log.log("Verify Saved Token");
			if (savedSession.data.token)
			{//we have a saved token, verify it
				Log.log("Verify Token from Verify Saved Token");
				verifyToken(savedSession.data.token, isQuickCheck);
			}//we have a saved token, verify it
			else if(!isQuickCheck)
			{//no token data
				Log.log("Connect, not Quick Check");
				connect();
			}//no token data
			else
			{//failed quick check
				Log.log("Failed Quick Check at VerifySavedToken");
				dispatchEvent(new FacebookEvent(FacebookEvent.QUICK_CHECK_COMPLETE));
			}//failed quick check
        }//verifySavedToken
		
		protected function handleTokenCheckComplete(e:FBRequestEvent):void
		{//verifyTokenCheck
			FBRequest(e.target).removeEventListener(FBRequestEvent.COMPLETE, handleTokenCheckComplete);
			Log.log("handleTokenCheckComplete: " + e.successResult.success);
			
			if (e.successResult.success)
			{//save token
				_token = FBRequest(e.target).accessToken;
				Log.log("Token: " + _token);
				
				savedSession.data.token = _token;
				savedSession.flush();
				
				Log.log("Setting isConnected to true");
				_isConnected = true;
				_userID = e.fbObj.id;
				Log.log("Got User ID: " + _userID);
			}//save token
			else
			{//not connected
				Log.log("Setting isConnected to false");
				_isConnected = false;
			}//not connected
			
			dispatchEvent(new FacebookEvent(FacebookEvent.QUICK_CHECK_COMPLETE));
		}//verifyTokenCheck
		
		protected function verifyTokenSuccess(e:FBRequestEvent):void
        {//verifyTokenSuccess
			e.target.removeEventListener(FBRequestEvent.COMPLETE, verifyTokenSuccess);
			Log.log("Verify Token Success: " + e.successResult.success);
			
			if (e.successResult.success)
			{//save token
				_token = FBRequest(e.target).accessToken;
				Log.log("Token: " + _token);
				
				savedSession.data.token = _token;
				savedSession.flush();
				
				Log.log("Setting isConnected to true");
				_isConnected = true;
				_userID = e.fbObj.id;
				Log.log("Got User ID: " + _userID);
				
				dispatchEvent(new FacebookEvent(FacebookEvent.AUTHORIZED));
			}//save token
			else
			{//connect
				Log.log("Setting isConnected to false");
				_isConnected = false;
				dispatchEvent(new FacebookEvent(FacebookEvent.AUTH_FAILED));
				connect();
			}//connect
        }//verifyTokenSuccess
		
		public function get apiPath():String
		{//get apiPath
			return _useHTTPS?_httpsApiURL:_httpApiURL;
		}//get apiPath
		
		public function get savedSession():SharedObject
        {//get savedSession
            if (_savedSession)
			{//already have ref
                return _savedSession;
			}//already have ref
                
            var name:String = _fcmSOPrefix + _appID;
            _savedSession = SharedObject.getLocal(name);
            return _savedSession;
        }//get savedSession
		
		private function addSWFFinder():void
		{//addSWFFinder
			if (ExternalInterface.available)
			{//add
				var js:String = "getSwfID = function(){var objects = document.getElementsByTagName('object'); if(objects.length > 0){return objects[objects.length-1]['id'];}else{return '';}};";
				ExternalInterface.call("function(){" + js + "}");
				
				js = "getSWF = function(){var objects = document.getElementsByTagName('object'); if(objects.length > 0){return objects[objects.length-1];}else{return null;}}";
				ExternalInterface.call("function(){" + js + "}");
			}//add
		}//addSWFFinder
		
		///////// CONVENIENCE METHODS \\\\\\\\\
		public function postToFeed(callback:Function, profileID:String, message:String="", name:String="", link:String="", description:String="", pic:String=""):void
		{//postToFeed
			if (_token != "")
			{//post
				var argsObj:Object = new Object();
				
				if (message != "")
				{//
					argsObj["message"] = message;
				}//
				
				if (name != "")
				{//name
					argsObj["name"] = name;
				}//name
				
				if (link != "")
				{//link
					argsObj["link"] = link;
				}//link
				
				if (description != "")
				{//description
					argsObj["description"] = description;
				}//description
				
				if (pic != "")
				{//pic
					argsObj["picture"] = pic;
				}//pic
				
				var fbReq:FBRequest = new FBRequest(callback, profileID, "feed", _token, argsObj);
				fbReq.requestMethod = URLRequestMethod.POST;
				fbReq.addEventListener(FBRequestEvent.COMPLETE, handleFeedComplete, false, 0, false);
				fbReq.load();
			}//post
			else
			{//no token
				Log.logWarning("No Token!");
			}//no token
		}//postToFeed
		
		private function handleFeedComplete(e:FBRequestEvent):void 
		{//handleFeedComplete
			dispatchEvent(e);
		}//handleFreedComplete
		
		protected function get jsConfirmCallback():String { return _jsConfirmCallback; }
		protected function get jsWindowName():String { return _jsWindowName; }
		public function get token():String { return _token; }
		public function get isConnected():Boolean { return _isConnected; }
		public function get userID():String { return _userID; }
		public function get revalidateOnFailedCall():Boolean { return _revalidateOnFailedCall; }
		public function set revalidateOnFailedCall(value:Boolean):void 
		{
			_revalidateOnFailedCall = value;
		}
		
	}//FacebookConnectManager Class

}//Package