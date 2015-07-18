package com.cj.utils
{
	public class DateUtil
	{
		public function DateUtil(){}
		
		/**
		 * 날짜 체크
		 * @param dy :: D-Day가 될 년도 설정
		 * @param dm :: D-Day가 될 월 설정
		 * @param dd :: D-Day가 될 일 설정
		 * @return 
		 */		
		public static function dayCheck(dy:int, dm:int, dd:int):Boolean
		{
			var dday:Date = new Date(dy, dm-1, dd, 0, 0, 0, 0);
			var now:Date = new Date();	// 현재시간
			return (now.getTime() >= dday.getTime());
		}
	}
}