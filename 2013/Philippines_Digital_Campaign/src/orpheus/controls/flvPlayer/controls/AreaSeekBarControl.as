﻿package orpheus.controls.flvPlayer.controls {	import flash.geom.Point;		import orpheus.controls.flvPlayer.events.SeekEvent;		import flash.events.MouseEvent;		import flash.events.EventDispatcher;		import orpheus.controls.flvPlayer.FLVPlayer;		import flash.display.Sprite;		import flash.events.TimerEvent;		import orpheus.controls.flvPlayer.BasicStream;		import flash.display.DisplayObject;		/**	 * @author philip	 */	public class AreaSeekBarControl extends BarControl	{		private var fmsURL:String;		private var oldStatus:String;		private var clickPoint:Point;		private var defaultX:Number;		private var area:Sprite;		public function AreaSeekBarControl(bar:Sprite = null, area:Sprite = null, stream:FLVPlayer = null, fmsURL:String = "")		{			super(bar, stream);						this.area = area;			this.fmsURL = fmsURL;			if (fmsURL) act = false;			bar.addEventListener(MouseEvent.MOUSE_DOWN, seekHandler);			clickPoint = new Point();		}		private function seekHandler(event:MouseEvent):void		{			if (!stream.source) return;			if(!fmsURL && stream.nowState == "stop") stream.play();						getDefaultX();						oldStatus = stream.nowState;			stream.pause(true, true);			var tg:Number =  area.mouseX / area.width;			dispatchEvent(new SeekEvent(SeekEvent.SEEK, tg, "down"));			bar.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);			bar.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);		}				private function getDefaultX():void		{			var p:Point = new Point();			p = bar.localToGlobal(p);			defaultX = p.x;		}		private function moveHandler(event:MouseEvent):void		{			var tg:Number = area.mouseX / area.width;			dispatchEvent(new SeekEvent(SeekEvent.SEEK, tg));						clickPoint.x = area.mouseX;			clickPoint.y = 0;		}		private function upHandler(event:MouseEvent):void		{			if (oldStatus == "play") stream.pause(false, true);			var tg:Number = area.mouseX / area.width;			dispatchEvent(new SeekEvent(SeekEvent.SEEK, tg, "up"));			bar.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);			bar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);		}		override protected function timerHandler(event:TimerEvent):void		{			var scale:Number = stream.ns.bytesLoaded / stream.ns.bytesTotal;			if (!isNaN(scale)) bar.scaleX = scale;			if (bar.scaleX == 1) stop();		}				override protected function removeEvent():void		{			bar.removeEventListener(MouseEvent.MOUSE_DOWN, seekHandler);			bar.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);			bar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);			area = null;		}	}}