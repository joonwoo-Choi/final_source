package com.lol.view
{
	import com.adqua.net.Debug;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class WallPop
	{
		private var _model:Model;
		private var _con:MovieClip;
//		private va_conon:WallCon;
		private var $menuCount:int=3;
		private var $id:uint;
		private var $snsMenu:MovieClip;
		
		public function WallPop(con:MovieClip)
		{
			_con = con;
			TweenPlugin.activate([AutoAlphaPlugin, FramePlugin]);
			_model = Model.getInstance();
			
			init();
		}
		
		protected function init():void
		{
			settingBtn();
		}
		
		//sns버튼
		private function settingBtn():void{
			for (var i:int = 0; i < 2; i++) 
			{
				$snsMenu = _con["sns"+i];
				$snsMenu.id = i;
				ButtonUtil.makeButton($snsMenu, snsHandler);
			}
			
			ButtonUtil.makeButton(_con.btn0, endHandler);
			_con.btn0.no = 0;
			ButtonUtil.makeButton(_con.btn1, endHandler);
			_con.btn1.no = 1;
			ButtonUtil.makeButton(_con.replyBtn, replyHandler);
		}
		
		private function endHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : TweenLite.to(target, 0.5, {frame:10}); break;
				case MouseEvent.MOUSE_OUT : TweenLite.to(target, 0.5, {frame:1}); break;
				case MouseEvent.CLICK :
					_con.dimmed.visible = true;
					TweenLite.to(target.clickComp, 0.75, {frame:target.clickComp.totalFrames, onCompleteParams:[target.no], onComplete:activeJS})
					TweenLite.to(target.btnBg, 0.75, {frame:target.btnBg.totalFrames})
					break;
			}
		}
		
		private function replyHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : target.gotoAndPlay(1); break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					/**	트래킹	*/
					if(_model.verEng == false) JavaScriptUtil.call("sendTracking", "P22");
					else JavaScriptUtil.call("sendTracking", "EP22");
					
					setTimeout(back, 1000);
					break;
			}
		}
		private function back():void
		{			JavaScriptUtil.call("back");		}
		
		private function activeJS(num:int):void
		{
			if(num == 0){
				/**	트래킹	*/
				if(_model.verEng == false) JavaScriptUtil.call("sendTracking", "P23");
				else JavaScriptUtil.call("sendTracking", "EP23");
				
				setTimeout(popupGo, 1000, 1);
			}
			else
			{
				/**	트래킹	*/
				if(_model.verEng == false) JavaScriptUtil.call("sendTracking", "7");
				else JavaScriptUtil.call("sendTracking", "E7");
				
				setTimeout(popupGo, 1000, 3);
			}
		}
		private function popupGo(num:int):void
		{			JavaScriptUtil.call("popupGo", num);		}
		
		protected function snsHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					target.gotoAndPlay(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target.gotoAndStop(1);
					break;
				case MouseEvent.CLICK :
					if(_model.verEng){
						if(target.id == 0)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("sendTracking", "EF1");
							JavaScriptUtil.call("shareOnFacebookEng");
						}
						if(target.id == 1)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("sendTracking", "ET1");
							JavaScriptUtil.call("shareOnTwitterEng");
						}
					}else{
						if(target.id == 0)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("sendTracking", "F1");
							JavaScriptUtil.call("shareOnFacebook");
						}
						if(target.id == 1)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("sendTracking", "T1");
							JavaScriptUtil.call("shareOnTwitter");
						}
					}
					break;
			}
		}
	}
}
