package com.lumpens.utils {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class ButtonUtil extends Object {
		static private var _autoPlay:Boolean = false;


		public function ButtonUtil() {
			// super();
		}

		static public function makeButton( $target:*, $cbkFn:Function, $dic:Dictionary=null, $param:Object=null, $autoPlay:Boolean=false ):void {
			if( $target == null ) return;

			var target:* = $target;
			target.buttonMode = true;
			target.mouseChildren = false;
			target.addEventListener( MouseEvent.MOUSE_OVER, $cbkFn );
			target.addEventListener( MouseEvent.MOUSE_OUT, $cbkFn );
			target.addEventListener( MouseEvent.MOUSE_DOWN, $cbkFn );
			target.addEventListener( MouseEvent.CLICK, $cbkFn );

			if( $dic != null ) $dic[ target ] = $param;
			
			if( $autoPlay ) {
				_autoPlay = true;
				target.gotoAndStop( 1 );
				target.addEventListener( MouseEvent.MOUSE_OVER, autoPlayListener );
				target.addEventListener( MouseEvent.MOUSE_OUT, autoPlayListener );
			}
		}
		
		static public function movButton( $target:*, $cbkFn:Function, $dic:Dictionary=null, $param:Object=null, $autoPlay:Boolean=false ):void {
			if( $target == null ) return;
			
			var target:* = $target;
			target.buttonMode = true;
			target.mouseChildren = false;
			target.addEventListener( MouseEvent.ROLL_OVER, $cbkFn );
			target.addEventListener( MouseEvent.ROLL_OUT, $cbkFn );
			target.addEventListener( MouseEvent.MOUSE_DOWN, $cbkFn );
			target.addEventListener( MouseEvent.CLICK, $cbkFn );
		}
		
		static public function containerButton( $target:*, $cbkFn:Function, $dic:Dictionary=null, $param:Object=null, $autoPlay:Boolean=false ):void {
			if( $target == null ) return;
			
			var target:* = $target;
			target.addEventListener( MouseEvent.MOUSE_OVER, $cbkFn );
			target.addEventListener( MouseEvent.MOUSE_OUT, $cbkFn );
		}

		static public function autoPlayListener( $msEvt:MouseEvent ):void {
			switch( $msEvt.type ) {
				case  MouseEvent.MOUSE_OVER : MovieClipUtil.moveFrame( MovieClip( $msEvt.target ), "over" ); break;
				case  MouseEvent.MOUSE_OUT : MovieClipUtil.moveFrame( MovieClip( $msEvt.target ), "out" ); break;
			}
		}

		static public function removeButton( $target:*, $cbkFn:Function ):void {
			if( $target == null ) return;

			var target:* = $target;
			target.buttonMode = false;
			target.removeEventListener( MouseEvent.MOUSE_OVER, $cbkFn );
			target.removeEventListener( MouseEvent.MOUSE_OUT, $cbkFn );
			target.removeEventListener( MouseEvent.MOUSE_DOWN, $cbkFn );
			target.removeEventListener( MouseEvent.CLICK, $cbkFn );
			
			if( _autoPlay ) {
				_autoPlay = false;
				target.gotoAndStop( 1 );
				target.removeEventListener( MouseEvent.MOUSE_OVER, autoPlayListener );
				target.removeEventListener( MouseEvent.MOUSE_OUT, autoPlayListener );
			}
		}
	}
}