package
{
	/**	3자리당 콤마 찍기	*/
	public class CurrencyFormat
	{
		
		public function CurrencyFormat(num:String)
		{
			var tmpStr:String = String(num).split(",").join("");
			var numArr:Array = tmpStr.split("");
			var commaMax:Number = Math.floor(numArr.length/3);
			var commaStart:Number = numArr.length%3;
			
			for (var i:Number = 0; i<commaMax; i++) {
				numArr.splice((i*3)+i+commaStart,0,(i == 0 && commaStart == 0) ? "" : ",");
			}
			
			return numArr.join("");
		}
	}
}