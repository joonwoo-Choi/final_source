package com.app.ui.likeButton
{//Package
	import com.adobe.serialization.json.JSON;
	import com.jac.facebook.FacebookConnectManager;
	import com.jac.facebook.events.FacebookEvent;
	import com.jac.facebook.net.FBRequest;
	import com.jac.facebook.net.events.FBRequestEvent;
	import com.jac.log.Log;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class LikeButtonControl extends Sprite
	{//LikeButtonControl Class
		
		private var clip:LikeButtonControlClip;
		//ELEMENTS
		public var _likeText:TextField;
		public var _likeView:MovieClip;
		//ELEMENTS
	
		private var _fb:FacebookConnectManager;
		private var _likeCountLoader:URLLoader;
		private var _pageID:String;
		private var _postID:String;
		private var _lastLikeList:Array;
		private var _isPopUpOpen:Boolean = false;
		private var _pageLikeTimer:Timer;
		private var _isLiked:Boolean = false;
		
		public function LikeButtonControl(facebookConnectManager:FacebookConnectManager, pageID:String, postID:String) 
		{//LikeButtonControl
			_fb = facebookConnectManager;
			
			_pageID = pageID;
			_postID = postID;
			
			//Setup callbacks for ShadowBox
			addShadowBoxHandlers();
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		}//LikeButtonControl
		
		private function handleAddedToStage(e:Event):void 
		{//handleAddedToStage
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			clip = new LikeButtonControlClip();
			this.addChild(clip);
			
			_likeText = clip._likeText;
			_likeView = clip._likeView;
			//setup text field
			
			_likeText.autoSize = TextFieldAutoSize.LEFT;
			
			//Check initial connection to facebook, without user intervention
			_fb.addEventListener(FacebookEvent.QUICK_CHECK_COMPLETE, handleQuickCheckComplete, false, 0, true);
			_fb.quickConnectCheck();
			
			//Handle mouse
			buttonMode = true;
			useHandCursor = true;
			addEventListener(MouseEvent.ROLL_OVER, handleMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, handleMouseOut, false, 0, true);
			addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
			
		}//handleAddedToStage
		
		private function handleMouseOut(e:MouseEvent):void 
		{//handleMouseOut
			if (!_isLiked)
			{//out
				_likeView.gotoAndStop("Up");
			}//out
		}//handleMouseOut
		
		private function handleMouseOver(e:MouseEvent):void 
		{//handleMouseOver
			if (!_isLiked)
			{//over
				_likeView.gotoAndStop("Over");
			}//over
		}//handleMouseOver
		
		private function handleQuickCheckComplete(e:FacebookEvent):void 
		{//handleQuickCheckComplete
			_fb.removeEventListener(FacebookEvent.QUICK_CHECK_COMPLETE, handleQuickCheckComplete, false);
			
			getLikeCount();
			
		}//handleQuickCheckComplete
		
		private function getLikeCount():void
		{//getLikeCount
			
			_fb.fbGet(handleLikeCountComplete, (_pageID + "_" + _postID), "likes");
			
			//_fb.fbGet(handleLikeCountComplete, (_pageID), "likes");
			
			
		}//getLikeCount
		
		private function handleLikeCountComplete(e:FBRequestEvent):void 
		{//handleLikeCountComplete
			
			if (e.successResult.success)
			{//good request
				_lastLikeList = e.fbObj.data as Array;
				
				refresh();
				
			}//good request
			else
			{//bad request
				_likeText.text = "Could not connect to Facebook.";
				Log.log("Like Count Error: " + e.successResult.errorCode + ": " + e.successResult.message);
			}//bad request
			
		}//handleLikeCountComplete
		
		private function isLiked(list:Array):Boolean
		{//isLiked
			
			if (!_fb.isConnected)
			{//not connected, bail
				return false;
			}//not connected, bail
			else
			{//connected, check
				var me:String = _fb.userID;
				for (var i:int = 0; i < list.length; i++)
				{//check ids
					if (list[i].id == me)
					{//found it
						return true;
					}//found it
				}//check ids
			}//connected, check
			
			return false;
			
		}//isLiked
		
		private function handleClick(e:MouseEvent):void 
		{//handleClick
			Log.log("Click Connected: " + _fb.isConnected);
			if (_fb.isConnected)
			{//post
				doLike();
			}//post
			else
			{//authorize
				Log.log("Attempt To Auth");
				_fb.addEventListener(FacebookEvent.AUTHORIZED, handleAuthorizedLike, false, 0, true);
				_fb.connect();
			}//authorize
			
		}//handleClick
		
		private function handleAuthorized(e:FacebookEvent):void
		{//handleAuthorized
			getLikeCount();
		}//handleAuthorized
		
		private function handleAuthorizedLike(e:FacebookEvent):void 
		{//handleAuthorizedLike
			_fb.removeEventListener(FacebookEvent.AUTHORIZED, handleAuthorizedLike);
			doLike();
		}//handleAuthorizedLike
		
		private function doLike():void
		{//doLike
			//Check if PAGE is liked
			_fb.fbGet(handlePageLikeCheckComplete, _fb.userID, "likes");
		}//doLike
		
		private function handlePageLikeCheckComplete(e:FBRequestEvent):void
		{//handlePageLikeComplete
			
			if (e.successResult.success)
			{//good request
				//Search data for page ID
				var dataList:Array = e.fbObj.data as Array;
				for (var i:int = 0; i < dataList.length; i++)
				{//search for PAGE ID
					if (dataList[i].id == _pageID)
					{//found it
					
						//Its liked, continue
						if (_isLiked)
						{//unlike
							
							_fb.fbPost(handleLikeComplete, (_pageID + "_" + _postID), "likes", { "method":"delete" } );
							
							//_fb.fbPost(handleLikeComplete, (_pageID), "likes", { "method":"delete" } );
							
						}//unlike
						else
						{//like
							
							_fb.fbPost(handleLikeComplete, (_pageID + "_" + _postID), "likes");
							//_fb.fbPost(handleLikeComplete, (_pageID), "likes");
							
						}//like
						
						return;
						
					}//found it
				}//search for PAGE ID
				
				//Not liked, force pop up
				if (ExternalInterface.available)
				{//pop up
					ExternalInterface.call("openLikeBox", _pageID);
				}//pop up
				
			}//good request
			else
			{//possibly not authorized
				Log.log("Not Authorized");
				_likeText.text = "Please Log Into Facebook, or Click Like Again";
			}//possibly not authorized
			
		}//handlePageLikeComplete
		
		public function refresh():void
		{//refresh
			Log.log("Refreshing");
			var postLiked:Boolean = isLiked(_lastLikeList);
			
			Log.log("Liked: " + postLiked);
			
			if (postLiked)
				{//you and others
					liked = true;
					if (_lastLikeList.length > 1)
					{//others
						if (_lastLikeList.length > 2)
						{//plural
							_likeText.text = ("You and " + (_lastLikeList.length - 1) + " others like this.");
						}//plural
						else
						{//singular
							_likeText.text = ("You and " + (_lastLikeList.length - 1) + " other person like this.");
						}//singular
					}//others
					else
					{//just you
						_likeText.text = ("You like this.");
					}//just you
					
				}//you and others
				else
				{//others only
					liked = false;
					if (_lastLikeList.length > 1)
					{//plural
						_likeText.text = (_lastLikeList.length + " people like this.");
					}//plural
					else if(_lastLikeList.length == 1)
					{//singular
						_likeText.text = ("1 person likes this.");
					}//singular
					else
					{//no one yet
						_likeText.text = ("Be the first to like this.");
					}//no one yet
				}//others only
		}//refresh
		
		private function handleLikeComplete(e:FBRequestEvent):void
		{//handleLikeComplete
			if (e.successResult.success)
			{//good
				Log.log("LIKE COMPLETE");
			}//good
			else
			{//bad
				Log.log("LIKE FAILED");
			}//bad
			
			getLikeCount();
		}//handleLikeComplete
		
		private function handlePostComplete(e:FBRequestEvent):void
		{//handleLikeComplete
			Log.log("Post Complete");
			_fb.savedSession.data.likes = "true";
			_fb.savedSession.flush();
		}//handleLikeComplete
		
		///////// SHADOW BOX \\\\\\\\\
		private function addShadowBoxHandlers():void
		{//addShadowBoxHandlers
			if (ExternalInterface.available)
			{//register
				Log.log("ADD SHADOWBOX CALLBACKS");
				ExternalInterface.addCallback("onShadowBoxOpen", handleShadowBoxOpen);
				ExternalInterface.addCallback("onShadowBoxClose", handleShadowBoxClose);
			}//register
		}//addShadowBoxHandlers
		
		private function handleShadowBoxOpen():void
		{//handleShadowBoxOpen
			Log.log("Shadow Box Open");
			_isPopUpOpen = true;
			pollPageLike();
		}//handleShadowBoxOpen
		
		private function handleShadowBoxClose():void
		{//handleShadowBoxClose
			Log.log("Shadow Box Close");
			_isPopUpOpen = false;
			if (_pageLikeTimer != null && _pageLikeTimer.running) { _pageLikeTimer.stop(); }
			getLikeCount();
		}//handleShadowBoxClose
		
		private function pollPageLike():void
		{//pollPageLike
		
			if (_isPopUpOpen)
			{//check
				_fb.fbGet(handlePageLikePoll, _fb.userID, "likes");
			}//check
		
		}//pollPageLike
		
		private function handlePageLikePoll(e:FBRequestEvent):void
		{//handlePageLikePoll
			if (e.successResult.success)
			{//good request
				//Search data for page ID
				var dataList:Array = e.fbObj.data as Array;
				for (var i:int = 0; i < dataList.length; i++)
				{//search for PAGE ID
					if (dataList[i].id == _pageID)
					{//found it
						Log.log("PAGE IS LIKED");
						
						//Close Pop Up
						if (ExternalInterface.available)
						{//close pop up
							ExternalInterface.call("closeShadowBox");
						}//close pop up
						
						//Its liked, continue
						_fb.fbPost(handleLikeComplete, (_pageID + "_" + _postID), "likes");
						return;
					}//found it
				}//search for PAGE ID
				
				//Not liked, force pop up
				Log.log("PAGE NOT LIKED YET!!");
				if (_isPopUpOpen)
				{//keep checking
					if (_pageLikeTimer != null) 
					{//clean up
						_pageLikeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlePageLikeTimer, false);
						_pageLikeTimer.stop(); 
					}//clean up
					
					_pageLikeTimer = new Timer(500, 1);
					_pageLikeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlePageLikeTimer, false, 0, true);
					_pageLikeTimer.start();
				}//keep checking
			}//good request
		}//handlePageLikePoll
		
		private function handlePageLikeTimer(e:TimerEvent):void 
		{//handlePageLikeTimer
			Log.log("Page Like Timer");
			_pageLikeTimer.stop();
			_pageLikeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handlePageLikeTimer, false);
			pollPageLike();
		}//handlePageLikeTimer
		
		public function get liked():Boolean
		{//get liked
			return _isLiked;
		}//get liked
		
		public function set liked(value:Boolean):void
		{//set liked
			_isLiked = value;
			
			if (_isLiked)
			{//select
				_likeView.gotoAndStop("Selected");
			}//select
			else
			{//un select
				_likeView.gotoAndStop("Up");
			}//un select
		}//set liked
		
		///////// REQUEST HANDLERS \\\\\\\\\\\\
		private function handleHTTPStatus(e:HTTPStatusEvent):void 
		{//handleHTTPStatus
			Log.log("HTTPStatus: " + e.status);
		}//handleHTTPStatus
		
		/**
		 * Called when the request returns with an error.  This dispatches a FBRequestEvent.COMPLETE with "IOError" passed as the error property.
		 * <br/>Please note that this is different than a failed <code>evaluateSuccess</code> call.
		 * @param	e
		 */
		protected function ioErrorHandler(e:IOErrorEvent):void
		{//ioErrorHandler
			Log.log("ServiceRequest:ioErrorHandler: An error was thrown during the request: " + e.text);
		}//ioErrorHandler
		
		/**
		 * Called when the request retruns with a security error. This dispatches a FBRequestEvent.COMPLETE with "SecurityError" passed as the error property.
		 * @param	e
		 */
		protected function securityErrorHandler(e:SecurityErrorEvent):void
		{//securityErrorHandler
			Log.log("ServiceRequest:securityErrorHandler: A security error was thrown during a request: " + e.text);
		}//securityErrorHandler
		
		/**
		 * Called when there has been progress on the request result download.  This redispatches the ProgressEvent.
		 * @param	e
		 */
		protected function progressHandler(e:ProgressEvent):void
		{//progressHandler
			dispatchEvent(e);
		}//progressHandler
		
	}//LikeButtonControl Class

}//Package