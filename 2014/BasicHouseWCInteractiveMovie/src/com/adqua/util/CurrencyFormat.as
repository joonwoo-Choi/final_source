package com.adqua.util
{
	/**
	 * 숫자 설정한 단위로 콤마 찍기	
	 */
	
	
	public class CurrencyFormat
	{
		
		/**	입력된 값	*/
		private var $value:String;
		/**	분할 단위	*/
		private var $divideNum:int;
		
		public function CurrencyFormat()
		{
			
		}
		
		/**	단위 변환	*/
		public function makeCurrency(value:String, divideNum:int):String
		{
			$value = value;
			
			$divideNum = divideNum;
			
			var tmpStr:String = String($value).split(",").join("");
			var numArr:Array = tmpStr.split("");
			var commaMax:Number = Math.floor(numArr.length/$divideNum);
			var commaStart:Number = numArr.length%$divideNum;
			
			for (var i:Number = 0; i<commaMax; i++) {
				numArr.splice((i*$divideNum)+i+commaStart,0,(i == 0 && commaStart == 0) ? "" : ",");
			}
			
			return numArr.join("");
		}
	}
}