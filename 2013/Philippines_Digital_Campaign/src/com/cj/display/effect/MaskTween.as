package com.cj.display.effect
{
	import com.cj.interfaces.IBitmapEffect;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class MaskTween implements IBitmapEffect
	{
		private var _container:Sprite;
		private var _mask:Shape;
		
		public function MaskTween($container:Sprite)
		{
			super();
			_container = $container;
		}
		
		public function execute(map:Bitmap, data:Object):void
		{
			var speed:Number = data.speed;
			var complete:Function = data.complete;
			var view:Boolean = data.view;
			
			if(_mask == null){
				_mask = new Shape();
				_mask.cacheAsBitmap = true;
				_container.addChild(_mask);
			}
			
			drawMask(_mask.graphics, map.width, map.height);
			map.cacheAsBitmap = true;
			map.mask = _mask;
			_mask.x = map.width >> 1;
			_mask.y = map.height >> 1;
			
			var obj:Object = {};
			var scale:Number = (view) ? 1 : 0;
			_mask.scaleX = (view) ? 0 : 1;
			_mask.scaleY = (view) ? 0 : 1;
			
			obj.scaleX = scale;
			obj.scaleY = scale;
			obj.onComplete = complete;
			if(view){
				obj.ease = Sine.easeOut;
			}else{
				obj.ease = Sine.easeOut;
				speed = 0.4;
			}
			TweenMax.to(_mask, speed, obj);
		}
		
		private function drawMask(g:Graphics, w:Number, h:Number):void
		{
			g.clear();
			var radius:Number = w-70;
			
			/*var boxWidth:Number = w;
			var boxHeight:Number = h;
			var type:String = GradientType.RADIAL;
			var colors:Array = [0x000000, 0x000000, 0xffffff];
			var alphas:Array = [1, 1, 0];
			var ratios:Array = [127, 190, 255];
			
			var matrix:Matrix = new Matrix();
			var boxRotation:Number=Math.PI/2;	// 90
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation);
			g.beginGradientFill(type, colors, alphas, ratios);   
			g.drawRect(0,0,boxWidth,boxHeight);*/
			
			var mtx:Matrix = new Matrix();
			mtx.createGradientBox(radius*2,radius*2,0,-radius,-radius);
			g.beginGradientFill(GradientType.RADIAL, [0x000000, 0xFFFFFF], [1,0], [175,255], mtx);
			g.drawCircle(0,0,radius);
			
			g.endFill();
		}
	}
}