package com.toto
{
	
	import com.greensock.TweenMax;
	import com.toto.popup.Block;
	import com.toto.popup.Popup;
	import com.toto.rope.Rope;
	import com.utils.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	[SWF(width="1000",height="700",backgroundColor="0xffffff",frameRate="30")]
	
	public class TOTO_Event_Two extends Sprite
	{
		
		private var $main:AssetMain;
		/**	로프	*/
		private var $rope:Rope;
		/**	팝업	*/
		private var $popup:Popup;
		/**	팝업 BG	*/
		private var $block:Block;
		
		public function TOTO_Event_Two()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetMain();
			
			this.addChild($main);
			
			$rope = new Rope($main.content);
			
			$popup = new Popup($main);
			
			$block = new Block($main);
		}
	}
}