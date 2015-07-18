package com.cj.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	public class ColorUtil
	{
		public function ColorUtil()
		{
		}
		
		public static function setColor(dp:DisplayObject, amount:Number):void 
		{
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			
			var redIdentity:Array = [1, 0, 0, 0, 0];
			var greenIdentity:Array = [0, 1, 0, 0, 0];
			var blueIdentity:Array = [0, 0, 1, 0, 0];
			var alphaIdentity:Array = [0, 0, 0, 1, 0];
			var grayluma:Array = [.3, .59, .11, 0, 0];
			var colmatrix:Array = [];
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, redIdentity, amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, greenIdentity, amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, blueIdentity, amount));
			colmatrix = colmatrix.concat(alphaIdentity);
			colorFilter.matrix = colmatrix;
			
			dp.filters = [colorFilter];
		}
		
		private static function interpolateArrays(ary1:Array, ary2:Array, t:Number):Array 
		{
			var result:Array = (ary1.length>=ary2.length) ? ary1.slice() : ary2.slice();
			var i:int = result.length;
			while (i--) {
				result[i] = ary1[i]+(ary2[i]-ary1[i])*t;
			}
			return result;
		}
	}
}
