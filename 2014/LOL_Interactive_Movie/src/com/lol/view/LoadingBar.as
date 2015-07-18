package com.lol.view
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LoadingBar
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _loading:Boolean = false;
		
		public function LoadingBar(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.SHOW_LOADING_BAR, showLoadingBar);
			_model.addEventListener(LolEvent.LOADING_PROGRESS, loadingProgress);
			_model.addEventListener(LolEvent.HIDE_LOADING_BAR, hideLoadingBar);
			
			resizeHandler();
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		protected function resizeHandler(e:Event = null):void
		{
			_con.loaderCon.loadingBar.x = int(_con.stage.stageWidth/2 - 160);
			_con.loaderCon.loadingBar.y = int(_con.stage.stageHeight/2 - 34);
		}
		
		protected function showLoadingBar(e:LolEvent):void
		{
//			if(_model.videoNum == 6 || _model.videoNum == 9) return;
			_loading = true;
			_con.loaderCon.loadingBar.bar.x = 1;
			_con.loaderCon.loadingBar.box.x = 1;
			_con.loaderCon.loadingBar.box.txt.text = "0%";
			TweenLite.to(_con.loaderCon, 0.35, {autoAlpha:1, ease:Cubic.easeOut});
			trace("로딩바 보이기_________________!!");
		}
		
		protected function loadingProgress(e:LolEvent):void
		{
			_con.loaderCon.loadingBar.bar.x = int(_model.loadPercent * 322);
			_con.loaderCon.loadingBar.box.txt.text = String(int(_model.loadPercent*100))+"%";
			_con.loaderCon.loadingBar.box.x = _con.loaderCon.loadingBar.bar.x;
//			trace("로딩중_____>>     " + _model.loadPercent);
		}
		
		protected function hideLoadingBar(e:LolEvent):void
		{
			if(_model.loadPercent < 1) return;
			TweenLite.to(_con.loaderCon, 0.35, {autoAlpha:0, ease:Cubic.easeOut});
			trace("로딩바 숨기기_________________!!");
		}
	}
}