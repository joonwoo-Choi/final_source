package com.smirnoff.page
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.control.YoutubePlayer;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class Page_0
	{
		
		private var _con:MovieClip;
		private var _uTube:YoutubePlayer;
		private var _model:Model = Model.getInstance();
		
		public function Page_0(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			_con = con;
			
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			_model.addEventListener(SmirnoffEvents.GO_MAIN, goMain);
			
			if(ExternalInterface.available) ExternalInterface.addCallback("loginCall",getUserData);
			makeBtn();
		}
		
		protected function goMain(event:Event):void
		{
			if(_con.visible == true) _model.isLogoClick = true;
		}
		
		private function getUserData(fbid:String, fbName:String, accessToken:String, fbimg:String):void
		{
			_con.cover.visible = true;
			TweenLite.to(_con.youTube, 0.5, {alpha:0, onComplete:removeuTube});
			_model.FBID = fbid;
			_model.uName = fbName;
			_model.FBToken = accessToken;
			_model.uImg = fbimg;
			
			_con.addEventListener(Event.ENTER_FRAME, movEndChk);
			_con.mov.play();
			trace("fbid: " + fbid);
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) != 0) return;
			trace("인덱스 페이지 시작__!!");
			/**	트래킹	*/
			JavaScriptUtil.call("googleSender", "District", "evt_main");
			
			_con.alpha = 0;
			_con.visible = false;
			TweenLite.to(_con, 0.5, {autoAlpha:1, ease:Cubic.easeOut});
			_con.mov.gotoAndPlay(1);
			_uTube = new YoutubePlayer();
			_con.youTube.addChild(_uTube);
			_con.youTube.alpha = 0;
			_con.addEventListener(Event.ENTER_FRAME, movEndChk);
		}
		
		private function movEndChk(e:Event):void
		{
			if(_con.mov.currentFrame == 75)
			{
//				_model.isLogoClick = true;
//				_con.cover.visible = false;
				_con.removeEventListener(Event.ENTER_FRAME, movEndChk);
				TweenLite.to(_con.youTube, 0.5, {alpha:1, onComplete:showUtube});
			}
			else if(_con.mov.currentFrame == _con.mov.totalFrames)
			{
				_con.removeEventListener(Event.ENTER_FRAME, movEndChk);
				_con.alpha = 0;
				_con.visible = false;
				_con.cover.visible = true;
				_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:1}));
			}
		}
		
		private function showUtube():void
		{
			_model.isLogoClick = true;
			_con.cover.visible = false;
		}
		
		private function makeBtn():void
		{
			ButtonUtil.makeButton(_con.btnJoin, btnJoinHandler);
		}
		
		private function btnJoinHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				/**	20150525 개발 프로세스 제거	*/
//				if(SecurityUtil.isWeb())
//				{
//					/**	트래킹	*/
//					JavaScriptUtil.call("googleSender", "District", "mainbtn");
//					
//					JavaScriptUtil.call("facebook.loginAction");
//				}
//				else
//				{
					_con.cover.visible = true;
					_con.addEventListener(Event.ENTER_FRAME, movEndChk);
					_con.mov.play();
					TweenLite.to(_con.youTube, 0.5, {alpha:0, onComplete:removeuTube});
//				}
			}
		}
		
		private function removeuTube():void
		{
			_uTube.removeYoutubePlayer();
			_con.youTube.removeChild(_uTube);
			_uTube = null;
		}
	}
}