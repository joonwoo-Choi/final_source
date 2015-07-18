package com.cj.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	public class VintageDisplay extends Sprite
	{
		private var _dop:DisplayObject;
		private var _noise:Bitmap;
		private var _blur:BlurFilter;
		
		public function VintageDisplay($dop:DisplayObject)
		{
			super();
			_dop = $dop;
			init();
		}
		
		private function init():void 
		{
			addChild(_dop);
			
			var shadow:Sprite = new Sprite();
			shadow.graphics.beginFill(0xFFFFFF);
			shadow.graphics.drawRect( 0, 0, _dop.width, _dop.height );
			shadow.graphics.endFill();
			shadow.filters = [ new GlowFilter( 0x000000, 0.9, 100, 100, 2, 2, true, true) ];
			shadow.blendMode = BlendMode.OVERLAY;
			addChild( shadow );
			
			_noise = new Bitmap( new BitmapData( _dop.width, _dop.height, true, 0xFFFF0000 ) );
			_noise.blendMode = BlendMode.HARDLIGHT;
			_noise.alpha = 0.3;
			addChild( _noise );
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1.0, -0.2, -0.2, 0.0, 100]); 	// red
			matrix = matrix.concat([-0.2, 0.85, -0.2, 0.0, 50]);	// green
			matrix = matrix.concat([-0.2, -0.2, 0.5, 0.0, 60]);		// blue
			matrix = matrix.concat([0, 0, 0, 1.0, 0]); 				// alpha
			
			_blur = new BlurFilter( 10, 10 );
			_dop.filters = [ _blur, new ColorMatrixFilter( matrix ) ];
		}
		
		public function update():void 
		{
			_noise.bitmapData.noise( Math.random() * 100, 0, 150, 7, true );
			_blur.blurX = Math.random() * 10;
			_blur.blurY = Math.random() * 10;
			
		}
	}
}