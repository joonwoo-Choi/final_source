package com.cj.display.effect
{
	import com.cj.display.FreeTransform;
	import com.cj.interfaces.IBitmapEffect;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Flap extends Sprite implements IBitmapEffect
	{
		private const totalPoint:int = 8;
		private var _transform:FreeTransform;
		private var _cnt:int;
		private var _complete:Function;
		
		public function Flap(){}

		private function setTransform(bmd:BitmapData):void
		{
			if(_transform){
				_transform.bitmapData = bmd;
			}else{
				_transform = new FreeTransform(bmd, 20, 15);
				_transform.mouseEnabled = false;
				addChild(_transform);
			}
		}
		
		private function centerFlap(sx:Number, sy:Number, on:Boolean):void
		{
			_cnt = 0;
			var obj:Object = {};
			if(on){
				
				for(var i:int=0; i < totalPoint; ++i)
				{
					var tx:Number = _transform.srcPoints[i].x;
					var ty:Number = _transform.srcPoints[i].y;
					obj = {};
					obj.onUpdate = draw;
					obj.onComplete = drawComplete;
					obj.ease = Back.easeOut;
					obj.x = tx;
					obj.y = ty;
					obj.delay = i*0.06;
					TweenMax.to(_transform.dstPoints[i], .4, obj);
				}
			}else{
					
				obj.onUpdate = draw;
				obj.onComplete = drawComplete;
				obj.ease = Back.easeOut;
				obj.x = sx;
				obj.y = sy;
				TweenMax.allTo(_transform.dstPoints, .3, obj, .06);
			}
		}
		
		private function draw():void
		{
			if(_transform) _transform.reCount();
		}
		
		private function drawComplete():void
		{
			if(_cnt == (totalPoint-1)){
				if(_complete != null) _complete();
			}
			_cnt++;
		}
		
		public function execute(map:Bitmap, data:Object):void
		{
			map.alpha = 0;
			
			setTransform(map.bitmapData);
			var on:Boolean = data.on;
			var tx:Number = data.tx;
			var ty:Number = data.ty;
			_complete = data.onComplete;
			
			if(on){
				for (var i:int = 0; i < totalPoint; i++) 
				{
					_transform.dstPoints[i].x = tx;
					_transform.dstPoints[i].y = ty;
				}
			}
			draw();
			centerFlap(tx, ty, on);
		}
		
		public function dispose():void
		{
			_complete = null;
			if(_transform == null) return;
			if(contains(_transform)) removeChild(_transform);
			_transform.dispose();
			_transform = null;
		}
	}
}