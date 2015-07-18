package com.cj.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class DisplayObjectUtil
	{
		/**
		 * 최대사이즈에 맞춰 리사이즈된 데이터 반환
		 * @param $width
		 * @param $height
		 * @param $maxSize 최대사이즈
		 * @param $widthOnly true : false 가로기준인지 세로기준인지..
		 * @return 
		 * 
		 */		
		public static function getReSizeObject($width:int, $height:int, $maxSize:int, $widthOnly:Boolean=true):Object
		{
			var ratio:Number;	// 비율계산
			var fixWidth:int;
			var fixHeight:int;
			
				// 가로비율일때
			if($widthOnly){
				ratio = $maxSize / $width;
				fixWidth = $maxSize;
				fixHeight = $height * ratio;
			}else{
				// 세로비율일때
				ratio = $maxSize / $height;
				fixWidth = $width * ratio;
				fixHeight = $maxSize;
			}
			
			return {width:fixWidth, height:fixHeight};
		}
		
		
		/**
		 * 컨테이너 자식 모두제거 
		 * @param container
		 * 
		 */		
		public static function removeAllChildren(container:DisplayObjectContainer) : void
		{
			var child:DisplayObject;
			while (container.numChildren)
			{
				child = container.getChildAt(0);
				container.removeChildAt(0);
				
				// 자식이 콘테이너면 재귀호출
				if(child is DisplayObjectContainer){
					DisplayObjectUtil,removeAllChildren( child as DisplayObjectContainer );
				}
				
				// 자식이 비트맵이면 디스포즈
				if(child is Bitmap){
					if((child as Bitmap).bitmapData) {
						(child as Bitmap).bitmapData.dispose();
					}
				}
				
				child = null;
			}
		}
		
		
		/**
		 * 오브젝트 가운데 위치 맞춤 
		 * @param dp
		 * 
		 */		
		public static function centerDO(dp:DisplayObject) : void
		{
			dp.x = int((-dp.width) * 0.5);
			dp.y = int((-dp.height) * 0.5);
		}
		
		
		/**
		 * 타겟의 복사된 비트맵을 가진 콘테이너 반환
		 * @param target
		 * @param useAlpha
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 */		
		public static function rasterize(target:DisplayObject, useAlpha:Boolean=true, scaleX:Number = 1, scaleY:Number = 1):Sprite
		{
			var bounds:Rectangle = target.getBounds(target);
			var bmpd:BitmapData = new BitmapData(target.width * scaleX, target.height * scaleY, useAlpha, 0x00000000);
			var mat:Matrix = new Matrix();
			mat.translate(-bounds.left, -bounds.top);
			mat.scale(scaleX, scaleY);
			bmpd.draw(target, mat);
			
			var bmp:Bitmap = new Bitmap(bmpd, PixelSnapping.ALWAYS, true);
			bmp.x = bounds.left;
			bmp.y = bounds.top;
			
			var container:Sprite = new Sprite();
			container.cacheAsBitmap = true;
			container.transform.matrix = target.transform.matrix;
			container.addChild(bmp);
			return container;
		}
		
		
		/**
		 * 비트맵 데이터를 받아 해당 사이즈안에서 비율조절후 반환
		 * @param inputBitmapData
		 * @param maxWidth
		 * @param maxHeight
		 * @return 
		 * 
		 */		
		public static function imageSizeCompressor(inputBitmapData:BitmapData, maxWidth:int, maxHeight:int):BitmapData
		{
			var ratio:Number;	// 비율계산
			var fixWidth:int;
			var fixHeight:int;
			
			var returnBitmapData:BitmapData;
			// 가로비율일때
			if (inputBitmapData.width / inputBitmapData.height >=  maxWidth / maxHeight)
			{
				ratio = maxWidth / inputBitmapData.width;
				fixWidth = maxWidth;
				fixHeight = inputBitmapData.height * ratio;
			}
			// 세로비율일때
			else if (inputBitmapData.width / inputBitmapData.height <  maxWidth / maxHeight)
			{
				ratio = maxHeight / inputBitmapData.height;
				fixWidth = inputBitmapData.width * ratio;
				fixHeight = maxHeight;
			}
			
			returnBitmapData = new BitmapData(fixWidth, fixHeight, true, 0x0);
			returnBitmapData.draw(inputBitmapData, new Matrix(ratio, 0, 0, ratio));
			return returnBitmapData;
		}
		
		public static function reSizeBitmapMatrix(inputBitmapData:BitmapData, maxWidth:int, maxHeight:int):Matrix
		{
			var ratio:Number;	// 비율계산
			var fixWidth:int;
			var fixHeight:int;
			var fixX:int;
			var fixY:int;
			
			var returnMatrix:Matrix;
			
			ratio = maxWidth / inputBitmapData.width;
			fixWidth = maxWidth;
			fixHeight = inputBitmapData.height * ratio;
			
			if(fixHeight < maxHeight){
				ratio = maxHeight / inputBitmapData.height;
				fixWidth = inputBitmapData.width * ratio;
				fixHeight = maxHeight;
			}
			fixX = (maxWidth - fixWidth) >> 1;
			fixY = (maxHeight - fixHeight) >> 1;
			
			returnMatrix = new Matrix(ratio, 0, 0, ratio);
			returnMatrix.translate(fixX, fixY);
			return returnMatrix;
		}
		
				
		public static function reSizeImage(displayObj:DisplayObject, maxWidth:int, maxHeight:int):void
		{
			var ratio:Number;	// 비율계산
			var fixWidth:int;
			var fixHeight:int;
			//800
			ratio = maxWidth / displayObj.width;
			fixWidth = maxWidth;
			fixHeight = displayObj.height * ratio;
			
			if(fixHeight < maxHeight){
				ratio = maxHeight / displayObj.height;
				fixWidth = displayObj.width * ratio;
				fixHeight = maxHeight;
			}
			
			displayObj.width = fixWidth;
			displayObj.height = fixHeight;
			displayObj.x = (maxWidth - fixWidth) >> 1;
			displayObj.y = (maxHeight - fixHeight) >> 1;
		}
		
		/**
		 * 색상변환 
		 * @param mc
		 * @param color
		 * 
		 */		
		public static function colorize( mc:DisplayObject, color:uint ):void 
		{
			var current_alpha:Number = mc.alpha;
			if(isNaN(color)) {
				mc.transform.colorTransform = null;
			} else {
				var ct:ColorTransform = new ColorTransform();
				ct.color = color;
				mc.transform.colorTransform = ct;
			}
			mc.alpha = current_alpha;
		}
		
		
	}
}