package com.app 
{//Package
	import com.app.ui.likeButton.LikeButtonControl;
	import com.jac.facebook.events.FacebookEvent;
	import com.jac.facebook.FacebookConnectManager;
	import com.jac.log.DebugLevel;
	import com.jac.log.Log;
	import com.jac.log.targets.BrowserConsoleTarget;
	import com.jac.log.targets.TraceTarget;
	import com.jac.log.VerboseLevel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	
	public class HookConnectMain extends MovieClip
	{//HookConnectMain Class
		
		private const APP_ID:String = "142459119113770";
		private const PAGE_ID:String = "106749192712698"; 	//HOOK PAGE
		private const REDIRECT:String = "http://labs.byhook.com/hookconnect/ConnectCallback.html";
		private const SCOPE:String = "user_likes";
		
		private var _postID:String = "122857984426987";		//New Hook Link Post
		
		private var _fb:FacebookConnectManager;
		private var _likeBTN:LikeButtonControl;
		
		public function HookConnectMain() 
		{//HookConnectMain
			Log.addLogTarget(new TraceTarget());
			Log.addLogTarget(new BrowserConsoleTarget());
			Log.setVerboseFilter(VerboseLevel.ALL);
			Log.setLevelFilter(DebugLevel.ALL);
			
			_fb = new FacebookConnectManager(APP_ID, REDIRECT, SCOPE, false, true);
			_fb.addEventListener(FacebookEvent.AUTHORIZED, handleAuthorized, false, 0, true);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		}//HookConnectMain
		
		private function handleAddedToStage(e:Event):void 
		{//handleAddedToStage
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			_likeBTN = new LikeButtonControl(_fb, PAGE_ID, _postID); 
			addChild(_likeBTN);
			
		}//handleAddedToStage
		
		private function handleAuthorized(e:FacebookEvent):void 
		{//handleAuthorized
			Log.log("MAIN Authorized");
		}//handleAuthorized
		
	}//HookConnectMain Class

}//Package