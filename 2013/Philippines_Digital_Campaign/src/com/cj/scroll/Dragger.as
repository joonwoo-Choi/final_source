package com.cj.scroll
{
	import com.cj.events.DraggerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class Dragger extends EventDispatcher 
	{
		protected var _target:DisplayObject;
		protected var _enabled:Boolean = true;
		protected var _horizontal:Boolean = true;
		protected var _vertical:Boolean = true;
		protected var _bufferDistance:Number = 0;
		protected var _alpha:Number = 1;
		protected var _dragging:Boolean = false;
		protected var _draggableRect:Rectangle;
		
		protected var downPoint:Point;
		protected var delta:Point;
		protected var originalAlpha:Number;
		
		public function Dragger(target:DisplayObject) 
		{
			super();
			_target = target;
			_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		////////////////////////////////////////////////////////////
		////////////// getter / setter
		////////////////////////////////////////////////////////////
		
		//______________ target ______________//
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		//______________ enabled ______________//
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		//______________ horizontal ______________//
		public function get horizontal():Boolean 
		{
			return _horizontal;
		}
		public function set horizontal(value:Boolean):void 
		{
			_horizontal = value;
		}
		
		//______________ vertical ______________//
		public function get vertical():Boolean 
		{
			return _vertical;
		}
		public function set vertical(value:Boolean):void 
		{
			_vertical = value;
		}
		
		//______________ bufferDistance ______________//
		public function get bufferDistance():Number 
		{
			return _bufferDistance;
		}
		public function set bufferDistance(value:Number):void 
		{
			_bufferDistance = value;
		}
		
		//______________ alpha ______________//
		public function get alpha():Number 
		{
			return _alpha;
		}
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
		
		//______________ draggableRect ______________//
		public function get draggableRect():Rectangle 
		{
			return _draggableRect;
		}
		public function set draggableRect(value:Rectangle):void 
		{
			_draggableRect = value;
		}
		
		//______________ dragging ______________//
		public function get dragging():Boolean 
		{
			return _dragging;
		}
		
		
		////////////////////////////////////////////////////////////
		////////////// public method
		////////////////////////////////////////////////////////////
		
		//______________ startDrag ______________//
		public function startDrag():void 
		{
			if (!_dragging && _target.stage) {
				refreshDelta();
			}
			setDragging(true, _target.stage, false);
		}
		
		//______________ stopDrag ______________//
		public function stopDrag():void 
		{
			setDragging(false, _target.stage, false);
		}
		
		//______________ destroy ______________//
		public function destroy():void 
		{
			setDragging(false, _target.stage, false);
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_target = null;
		}
		
		
		////////////////////////////////////////////////////////////
		////////////// method
		////////////////////////////////////////////////////////////
		
		//______________ setDragging ______________//
		protected function setDragging(value:Boolean, stage:Stage, fireEvent:Boolean):void 
		{
			if (!stage) {
				return;
			}
			if (_dragging == value) {
				if (!_dragging) {
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
					if (fireEvent) {
						dispatchEvent(new DraggerEvent(DraggerEvent.CANCEL_DRAG));
					}
				}
				return;
			}
			_dragging = value;
			if (_dragging) {
				//originalAlpha = _target.alpha;
				//_target.alpha = _alpha;
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				if (fireEvent) {
					dispatchEvent(new DraggerEvent(DraggerEvent.START_DRAG));
				}
			}else{
				//_target.alpha = originalAlpha;
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				if (fireEvent) {
					dispatchEvent(new DraggerEvent(DraggerEvent.STOP_DRAG));
				}
			}
		}
		
		//______________ getDragablePos __________//
		protected function getDragablePos($x:Number, $y:Number):Object
		{
			var tx:Number = Math.max(_draggableRect.x, Math.min(_draggableRect.x + _draggableRect.width, $x));
			var ty:Number = Math.max(_draggableRect.y, Math.min(_draggableRect.y + _draggableRect.height, $y));
			
			return {x:tx, y:ty};
		}
		
		//______________ refreshDelta ______________//
		protected function refreshDelta():void 
		{
			//var globalPoint:Point = _target.parent.localToGlobal(new Point(_target.x, _target.y));
			var globalPoint:Point = new Point(_target.x, _target.y);
			delta = new Point(globalPoint.x - _target.stage.mouseX, globalPoint.y - _target.stage.mouseY);
		}
		
		////////////////////////////////////////////////////////////
		////////////// event handler
		////////////////////////////////////////////////////////////
		
		//______________ mouseDownHandler ______________//
		protected function mouseDownHandler(e:MouseEvent):void 
		{
			if (!_enabled) {
				false;
			}
			Mouse.cursor = MouseCursor.HAND;
			
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			downPoint = new Point(_target.stage.mouseX, _target.stage.mouseY);
			refreshDelta();
			setDragging(true, _target.stage, true);
		}
		
		//______________ mouseMoveHandler ______________//
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			var stage:Stage = Stage(e.currentTarget);
			if (_dragging) {
				//var localPoint:Point = _target.parent.globalToLocal(new Point(stage.mouseX + delta.x, stage.mouseY + delta.y));
				var localPoint:Point = new Point(stage.mouseX + delta.x, stage.mouseY + delta.y);
				if (_draggableRect) {
					var obj:Object = getDragablePos(localPoint.x, localPoint.y);
					localPoint.x = obj.x;
					localPoint.y = obj.y;
				}
				var changed:Boolean = false;
				if (_horizontal && _target.x != localPoint.x){
					_target.x = localPoint.x;
					changed = true;
				}
				if (_vertical && _target.y != localPoint.y) {
					_target.y = localPoint.y;
					changed = true;
				}
				if (changed) {
					dispatchEvent(new DraggerEvent(DraggerEvent.DRAG));
				}
			}else if (Point.distance(downPoint, new Point(stage.mouseX, stage.mouseY)) > _bufferDistance){
				setDragging(true, stage, true);
			}
		}
		
		//______________ mouseUpHandler ______________//
		protected function mouseUpHandler(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			
			var stage:Stage = Stage(e.currentTarget);
			setDragging(false, stage, true);
		}
		
		//______________ removedFromStageHandler ______________//
		protected function removedFromStageHandler(e:Event):void 
		{
			setDragging(false, Stage(DisplayObject(e.currentTarget).stage), true);
		}
		
	}
}