package com.cj.scroll
{
	import com.cj.events.ScrollEvent;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Scroller extends EventDispatcher
	{
		protected var _handle:Sprite;
		protected var _xScrollBool:Boolean;
		protected var _length:Number = 0;
		
		private var _min:Number;
		private var _max:Number;
		private var _pos:Number=0;
		
		public function Scroller($handle:Sprite, $xScroll:Boolean=true)
		{
			super();
			
			_handle = $handle;
			_handle.buttonMode = true;
			_xScrollBool = $xScroll;
		}

		public function get max():Number
		{
			return _max;
		}

		public function get min():Number
		{
			return _min;
		}

		public function get pos():Number
		{
			return _pos;
		}

		public function set pos(value:Number):void
		{
			if(value > _min || value < _max) return;
			_pos = value;
		}

		public function init( $min:Number, $max:Number, $length:Number, $init:Boolean=false ):void
		{
			_min = $min;
			_max = $max;
			if(_xScrollBool){
				_length = $length - _handle.width;
				if(_pos) _handle.x = getHandlePos();
			}else{
				_length = $length - _handle.height;
				if(_pos) _handle.y = getHandlePos();
			}
			
			if(_handle.hasEventListener(MouseEvent.MOUSE_DOWN)==false){
				_handle.addEventListener( MouseEvent.MOUSE_DOWN, downHandler );
			}
			if($init) _handle.y = 0;
			moveHandle();
		}
		
		public function getHandlePos():Number
		{
			var value:Number = (_pos - _min) / (_max - _min) * _length; 
			if(value < 0) value = 0;
			if(value > _length) value = _length;
			return value;
		}
		
		public function addWheelEvent():void
		{
			if(_handle.stage){
				_handle.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}
		
		public function dispose():void
		{
			if(_handle.stage){
				if(_handle.stage.hasEventListener(MouseEvent.MOUSE_WHEEL)){
					_handle.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				}
			}
			if(_handle.hasEventListener(MouseEvent.MOUSE_DOWN)){
				_handle.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
			}
		}
		
		private function mouseWheelHandler(e:MouseEvent):void
		{
			var ty:Number = _handle.y; 
			ty -= (e.delta*(_length/20));
			if(ty < 0) ty = 0;
			if(ty > _length) ty = _length;
			
			TweenMax.to(_handle, 0.4, {y:ty, onUpdate:moveHandle});
		}
		
		private function downHandler(e:MouseEvent):void
		{
			var bound:Rectangle;
			if(_xScrollBool){
				bound =  new Rectangle( 0, 0, _length, 0 );
			}else{
				bound =  new Rectangle( 0, 0, 0, _length );
			}
			_handle.startDrag( false, bound );
			
			_handle.addEventListener( Event.ENTER_FRAME, moveHandle );
			_handle.stage.addEventListener( MouseEvent.MOUSE_UP, upHandler );
		}
		
		private function upHandler(e:MouseEvent):void
		{
			_handle.removeEventListener( Event.ENTER_FRAME, moveHandle );
			
			_handle.stopDrag();
			_handle.stage.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
		}
		
		private function moveHandle(e:Event=null):void
		{
			var temp:Number;
			if(_xScrollBool){
				temp = _handle.x;
			}else{
				temp = _handle.y;
			}
			
			_pos = ( temp * ( _max - _min ) ) / _length + _min;
			sendEvent();
		}
		
		private function sendEvent():void
		{
			dispatchEvent( new ScrollEvent( ScrollEvent.CHANGED, _pos ) );
		}
	}
}