package com.cj.display.effect
{
	import com.cj.interfaces.IBitmapEffect;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PixelTween extends Sprite implements IBitmapEffect
	{
		private var _onComplete:Function;
		
		public function PixelTween(){}
		
		public function execute(map:Bitmap, data:Object):void
		{
			map.visible = false;
			var speed:Number = data.speed;
			_onComplete = data.complete;
			
			var objW:Number = map.width;
			var objH:Number = map.height;
			
			// 나누어질 박스사이즈
			var boxGap:Number = Math.floor(objW/20);
			var col:Number = Math.ceil(objW / boxGap);
			var row:Number = Math.ceil(objH / boxGap);
			
			var pt:Point = new Point(0, 0);
			var total:uint = col * row;
			
			var tweenObj:Object;
			var i:int = 0;
			for (; i < total; i++)
			{
				var dx:Number = (i % col) * boxGap;
				var dy:Number = Math.floor(i / col) * boxGap;
				var rect:Rectangle =  new Rectangle(dx, dy, boxGap, boxGap);
				
				var bd:BitmapData = new BitmapData(boxGap, boxGap, true, 0x00ffffff);
				bd.copyPixels( map.bitmapData, rect, pt );
				var bt:Bitmap = new Bitmap(bd);
				bt.alpha = 0;
				bt.x = map.width >> 1;
				bt.y = map.height >> 1;
				bt.scaleX = bt.scaleY = 0;
				
				addChild(bt);
				
				//trace(speed);
				tweenObj = {};
				tweenObj.alpha = 1;
				tweenObj.x = dx;
				tweenObj.y = dy;
				tweenObj.scaleX = 1;
				tweenObj.scaleY = 1;
				
				tweenObj.delay = (i * 0.004) * Math.random();
				tweenObj.ease = Back.easeInOut;
				if(i == total-1){
					tweenObj.onComplete = bitmapEffectComplete;
				}
				
				TweenMax.to( bt, speed, tweenObj );
			}
		}
		
		private function bitmapEffectComplete():void
		{
			trace("tween complete!!");
			if(_onComplete != null) _onComplete();
			
			var total:int = numChildren;
			var bt:Bitmap;
			for (var i:int = 0; i < total; i++) 
			{
				bt = getChildAt(0) as Bitmap;
				bt.bitmapData.dispose();
				bt.bitmapData = null;
				removeChild(bt);
				bt = null;
			}
		}
		
	}
}