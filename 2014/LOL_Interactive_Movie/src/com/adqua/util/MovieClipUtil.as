package com.adqua.util {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class MovieClipUtil extends MovieClip {
		public function MovieClipUtil() {
			// super();
		}

		static public function enable( $target:DisplayObjectContainer, $flag:Boolean, ...args ):void {
			var target:MovieClip = $target as MovieClip;
			target.buttonMode = $flag;
			target.enabled = $flag;
			target.useHandCursor = $flag;
			target.alpha = args[0] ? args[0] : 1;
		}
		
		static public function moveFrame( $target:Object, $frame:*, $scope:*=null, $cbkFn:Function=null, ...args ):void {
			$target = ( $target.name == "bt" ) ? $target.parent : $target;
			if( args.length >= 0 ) var tmp_arr:Array = args;

			var targetFrame:Number;
			var direction:String;

			if( typeof $frame == "string" ) {
				targetFrame = ( $frame == "over" ) ? $target.totalFrames : 1;
				direction = ( $frame == "over" ) ? "nextFrame" : "prevFrame";

			} else {
				targetFrame = $frame;
				direction = ( $target.currentFrame < $frame ) ? "nextFrame" : "prevFrame";
			}

			$target.prop = {	frame:targetFrame, state:direction, scope:$scope, cbkFn:$cbkFn, param:tmp_arr }

			$target.removeEventListener( Event.ENTER_FRAME, enterFrameListener );
			$target.addEventListener( Event.ENTER_FRAME, enterFrameListener );
		}

		static public function enterFrameListener( $evt:Event ):void {
			var target:Object = $evt.target;
			var frame:uint = target.prop.frame;
			var state:String = target.prop.state;
			var scope:Object = target.prop.scope;
			var param:Array = target.prop.param;

			if( target.currentFrame < frame || target.currentFrame > frame ) {
				target[state]();

			} else {
				target.removeEventListener( Event.ENTER_FRAME, enterFrameListener );
				target.gotoAndStop(frame);
				
				if (target.prop.scope) {
					if(target.prop.param.length > 0) {
						target.prop.cbkFn(target, target.prop.param)

					} else {
						target.prop.cbkFn(target);
					}
				}
				
				target.prop = null;
			}
		}
	}
}