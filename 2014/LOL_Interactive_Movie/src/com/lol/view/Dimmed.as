package com.lol.view
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Dimmed
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		public function Dimmed(con:MovieClip)
		{
			_con = con;
			
			initEventListener();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.DIMMED_ON, showDimmed);
			_model.addEventListener(LolEvent.DIMMED_OFF, hideDimmed);
			_con.stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageResizeHandler();
		}
		
		private function showDimmed(e:LolEvent):void
		{
			TweenLite.to(_con, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		private function hideDimmed(e:LolEvent):void
		{
			TweenLite.to(_con, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
		}
		
		private function stageResizeHandler(event:Event = null):void
		{
			_con.width = _con.stage.stageWidth;
			_con.height = _con.stage.stageHeight;
		}
	}
}