package com.cj.utils
{
	public class StringUtil
	{
		public function StringUtil(){}
		
		/**
		 * 한자리수일때 "0"붙이기 
		 * @param $idx
		 * @return 
		 */		
		public static function getPageNum($idx:int=0):String
		{
			var str:String = $idx.toString();
			if(str.length == 1) str = "0"+str;
			return str;
		}
		
		
		/**
		 * Number 자릿수 단위로 ","넣기 
		 * @param tempNum
		 * @param chkPoint
		 * @return 
		 */		
		public static function numPoint( tempNum:Number, chkPoint:int = 3 ):String
		{
			var tmepArr:Array = tempNum.toString().split("");
			var chkNum:int = tmepArr.length - chkPoint;
			
			// i값을 전체 길이값의 3을 뺀 시점부터 3칸씩 줄여나가며 ","를 찍는다
			for( var i:int = chkNum; i > 0; i-=chkPoint )
			{
				tmepArr.splice( i, 0, "," );
			}
			return tmepArr.join("");
		}
		
		
		/**
		 * 문자열 공백없애기
		 * @param str
		 * @return 
		 * 
		 */		
		public static function lineFilter(str:String):String
		{
			var tempStr:String = str;
			tempStr = tempStr.split("\r\n").join("\n");
			tempStr = tempStr.split("\t").join("");
			return tempStr;
		}
		
		
		/**
		 * e-mail 문자열 체크 
		 * @param $str
		 * @return 
		 * 
		 */		
		static public function mailCheck( $str:String ):Boolean
		{
			// 정규표현식 사용
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test($str);
		}
	}
}