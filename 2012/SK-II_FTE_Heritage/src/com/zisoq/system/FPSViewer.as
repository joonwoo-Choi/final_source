package com.zisoq.system
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;


	/**
	 * ...
	 * @author Kim Jeung-Kyoon ( zisoq.com )
	 */
	public class FPSViewer extends Sprite
	{
		private static const _instance:FPSViewer = new FPSViewer();
		private var _txt:TextField;
		private var _bar:Shape;
		private var _prevFrameTime:Number;
		private var _prevSecondTime:Number;
		private var _frames:Number;


		public function FPSViewer()
		{
			if( _instance ) throw new Error( "singleton" );

			_prevFrameTime = getTimer();
			_prevSecondTime = getTimer();
			_frames = 0;

			_txt = new TextField();
			_txt.defaultTextFormat = new TextFormat( "Arial" , 10 , 0xffffff );
			_txt.selectable = false;
			_txt.embedFonts = false;
			_txt.y = -4;
			_txt.text = "stand by..";

			_bar = new Shape();
			_bar.graphics.beginFill( 0x666666 );
			_bar.graphics.drawRect( 0 , 0 , 100 , 8 );
			_bar.graphics.beginFill( 0xffffff );
			_bar.graphics.drawRect( 100 , 0 , 1 , 8 );
			_bar.graphics.endFill();

			addChild( _bar );
			addChild( _txt );

			addEventListener( Event.ADDED_TO_STAGE , onAdded );
			addEventListener( Event.REMOVED_FROM_STAGE , onRemoved );
		}

		public static function getInstance():FPSViewer
		{
			return _instance;
		}

		public static function show():void
		{
			getInstance().removeEventListener( Event.ENTER_FRAME , getInstance().onFrame );

			getInstance().addEventListener( Event.ENTER_FRAME , getInstance().onFrame );
			getInstance().visible = true;
		}

		public static function hide():void
		{
			getInstance().removeEventListener( Event.ENTER_FRAME , getInstance().onFrame );
			getInstance().visible = false;
		}

		private function onAdded( e:Event ):void
		{
			show();
		}

		private function onRemoved( e:Event ):void
		{
			hide();
		}

		private function onFrame( e:Event ):void
		{
			var time:int = getTimer();
			var frameTime:int = time - _prevFrameTime;
			var secondTime:int = time - _prevSecondTime;
			var divTime:int = secondTime - 1000;
			if( divTime >= 0 )
			{
				_txt.text = _frames + " FPS   " + Math.round( System.totalMemory / 1048576 ) + " MB";
				_prevSecondTime = time - divTime;
				_frames = 0;
			}
			else
			{
				_frames++;
			}
			_prevFrameTime = time;
			_bar.width -= ( _bar.width - ( frameTime << 2 ) ) >> 2;
		}
	}
}