package com.cj.scroll
{
	import com.cj.events.ScrollEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class KineticScroller extends EventDispatcher
	{
		private static const HISTORY_LENGTH:uint = 7;	// 마우스 이동시 기억하고 있을 포인트수
		
		private var _target:DisplayObject;
		private var _enabled:Boolean = true;
		private var previousPoints:Array;
		private var previousTimes:Array;
		
		private var _dragableRect:Rectangle;
		private var _rectGap:int = 20;
		private var _areaPos:Object;
		
		// 속도 포인트
		private var velocity:Point = new Point();
		
		// 0 ~ 1
		public var dampening:Number = 0.8;
		
		public var horizontalScrollEnabled:Boolean = true;
		public var verticalScrollEnabled:Boolean = true;
		
		public function KineticScroller(targetVal:DisplayObject = null) 
		{
			target = targetVal;
			(target as Sprite).mouseChildren = false;
		}
		
		
		//_________ getter / setter ________________________________________________________________________
		
		
		public function get dragableRect():Rectangle
		{
			return _dragableRect;
		}

		public function set dragableRect(value:Rectangle):void
		{
			if(_dragableRect) _dragableRect = null;
			_dragableRect = value;
			
			var minX:Number = _dragableRect.x - _rectGap;
			var maxX:Number = _dragableRect.width + _rectGap;
			var minY:Number = _dragableRect.y - _rectGap;
			var maxY:Number = _dragableRect.height + _rectGap;
			if(_areaPos) _areaPos = null;
			_areaPos = {x1:minX,x2:maxX,y1:minY,y2:maxY};
		}

		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value == _enabled)
				return; // no-op
			_enabled = value;
			if (!value) {
				stop();
			}
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void 
		{
			if (_target) removeAllListeners();
			_target = value;
			if (value) {
				target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0);
				target.addEventListener(MouseEvent.CLICK, mouseClickHandler, true, 100, true);	// 캡쳐단계 활성화 (타겟,버블 - x)
			}
		}
		
		
		//_________ event handler ________________________________________________________________________
		
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			if (!enabled) return;
			if (hasMouseEventListeners(DisplayObject(event.target))) return;
			
			stop();
			previousPoints = [new Point(target.stage.mouseX, target.stage.mouseY)];
			previousTimes = [getTimer()];
			target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void 
		{
			if (!enabled) return;
			if (!event.buttonDown) {
				mouseUpHandler();
				return;
			}
			var currPoint:Point = new Point(target.stage.mouseX, target.stage.mouseY);
			var currTime:int = getTimer();
			var previousPoint:Point = Point(previousPoints[previousPoints.length - 1]);
			var diff:Point = currPoint.subtract(previousPoint);	// 현재 포인트에서 이전포인트를 뺀 포인트 생성
			//diff = transformPointToLocal(diff);
			moveScrollPosition(diff);
			
			previousPoints.push(currPoint);
			previousTimes.push(currTime);
			
			if (previousPoints.length >= HISTORY_LENGTH) {
				previousPoints.shift();
				previousTimes.shift();
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent = null):void 
		{
			target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			if (!enabled) return;
			
			var currPoint:Point = new Point(target.stage.mouseX, target.stage.mouseY);
			var currTime:int = getTimer();
			var firstPoint:Point = Point(previousPoints[0]);
			var firstTime:int = int(previousTimes[0]);
			var diff:Point = currPoint.subtract(firstPoint);
			var time:Number = (currTime - firstTime) / (1000 / target.stage.frameRate);
			velocity = new Point(diff.x / time, diff.y / time);
			
			start();
		}
		
		protected function enterFrameHandler(event:Event):void 
		{
			velocity = new Point(velocity.x * dampening, velocity.y * dampening);
			//var localVelocity:Point = transformPointToLocal(velocity);
			if (Math.abs(velocity.x) < .1) velocity.x = 0;
			if (Math.abs(velocity.y) < .1) velocity.y = 0;
			if (!velocity.x && !velocity.y){
				stop();
			} 
			
			//trace(velocity.x, velocity.y);
			moveScrollPosition(velocity);
			
			// 영역 벗어남을 체크
			areaCheck();
		}
		
		private function mouseClickHandler(event:MouseEvent):void 
		{
			if (velocity.length > 5) {
				event.stopImmediatePropagation();
			}
		}
		
		
		//_________ private method _______________________________________________________________________
		
		
		private function hasMouseEventListeners(displayTarget:DisplayObject):Boolean
		{
			if (displayTarget == target) return false;
			if (displayTarget.hasEventListener(MouseEvent.MOUSE_DOWN) || displayTarget.hasEventListener(MouseEvent.MOUSE_UP)) return true;
			if (displayTarget.parent) return hasMouseEventListeners(displayTarget.parent);
			return false;
		}
		
		private function areaCheck():void
		{
			if(!_dragableRect) return;
			
			var value:Number;
			var bool:Boolean;
			
			var min:Number;
			var max:Number;
			var targetPos:Number;
			
			if (horizontalScrollEnabled) {
				min = _areaPos.x1;
				max = _areaPos.x2;
				targetPos = target.x;
			}
			
			if (verticalScrollEnabled) {
				min = _areaPos.y1;
				max = _areaPos.y2;
				targetPos = target.y;
			}
			
			if(targetPos >= min){
				bool = true;
				value = min + _rectGap;
			}
			if(targetPos <= max){
				bool = true;
				value = max - _rectGap;
			}
			
			if(!bool) value = targetPos;
			dispatchEvent( new ScrollEvent(ScrollEvent.POS_UPDATE, value) );
			
			if(bool){
				stop();
				dispatchEvent( new ScrollEvent(ScrollEvent.CHANGED, value) );
			}
		}
		
		//_________ public method ________________________________________________________________________
		
		
		public function stop():void 
		{
			if(target.hasEventListener(Event.ENTER_FRAME)){
				target.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			if(velocity){
				velocity.x = velocity.y = 0;
			}else{
				velocity = new Point();
			}
		}
		
		public function setVelocity(value:Point):void 
		{
			if (!value) value = new Point();
			if (!target.stage) return;
			target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			velocity = value;
			start();
		}
		
		
		//_________ protected method ________________________________________________________________________
		
		
		protected function start():void 
		{
			target.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		/**
		 * Removes all listeners from the target and stage.
		 */
		public function removeAllListeners():void 
		{
			if(target.hasEventListener(MouseEvent.MOUSE_DOWN)){
				target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			if(target.hasEventListener(MouseEvent.CLICK)){
				target.removeEventListener(MouseEvent.CLICK, mouseClickHandler, true);
			}
			if(target.hasEventListener(Event.ENTER_FRAME)){
				target.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			
			if (target.stage) {
				if(target.stage.hasEventListener(MouseEvent.MOUSE_UP)){
					target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				}
				if(target.stage.hasEventListener(MouseEvent.MOUSE_MOVE)){
					target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				}
			}
		}
		
		/**
		 * Moves scroller which moves viewport into position
		 * */
		protected function moveScrollPosition(diff:Point):void
		{
			var len:Number = 1.2;
			
			if (horizontalScrollEnabled) {
				target.x += diff.x * len;
			}
			if (verticalScrollEnabled) {
				target.y += diff.y * len;
			}
			
		}
	}
}