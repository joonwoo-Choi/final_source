package orpheus.utils 
{

	/**
	 * Date Class Util
	 * @author philip
	 */
	public class DateUtil 
	{
		public static const MILLISECOND:Number = 1;
		public static const SECOND:Number = MILLISECOND * 1000;
		public static const MINUTE:Number = SECOND * 60;
		public static const HOUR:Number = MINUTE * 60;
		public static const DAY:Number = HOUR * 24;
		public static const WEEK:Number = DAY * 7;

		/**
		 * 요일 한글로 표시
		 */
		public static var dayInKor:Array = new Array("일", "월", "화", "수", "목", "금", "토");

		/**
		 * 요일 영어로 표시
		 */
		public static var dayInEnglish:Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");

		/**
		 * 요일 영어(약어)로 표시
		 */
		public static var dayInEng:Array = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");

		
		/**
		 * 몇 년 후 찾기
		 */
		public static function addYears(date:Date, years:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setFullYear(dNew.getFullYear() + years);
			return dNew;
		}

		/**
		 * 몇 달 후 찾기
		 */
		public static function addMonths(date:Date, months:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setMonth(dNew.getMonth() + months);
			return dNew;
		}

		/**
		 * 몇 주 후 찾기
		 */
		public static function addWeeks(date:Date, weeks:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setDate(dNew.getDate() + weeks * 7);
			return dNew;
		}

		/**
		 * 몇 일 후 찾기
		 */
		public static function addDays(date:Date, days:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setDate(dNew.getDate() + days);
			return dNew;
		}

		/**
		 * 몇시간 후 찾기
		 */
		public static function addHours(date:Date, hrs:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setHours(dNew.getHours() + hrs);
			return dNew;
		}

		/**
		 * 몇 분 후 찾기
		 */
		public static function addMinutes(date:Date, mins:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setMinutes(dNew.getMinutes() + mins);
			return dNew;
		}

		/**
		 * 몇 초 후 찾기
		 */
		public static function addSeconds(date:Date, secs:Number):Date 
		{
			var dNew:Date = new Date(date.getTime());
			dNew.setSeconds(dNew.getSeconds() + secs);
			return dNew;
		}

		/**
		 * 해당 월의 1일 요일 과 해당 월 개수 & 날수(30, 31, 28, 29) 반환
		 * return:Object  firstDay : 0 ~ 6, days : 28 ~ 31
		 * 매개변수 전달이 없을 시 현재 월의 정보 반환
		 */
		public static function getMonthInfo(year:uint = 0, month:uint = 0):Object
		{
			var date:Date;
			if (year == 0)
			{
				date = new Date();
				date.setMonth(date.getMonth() + 1, 0);
			}
			else
			{
				date = new Date(year, month + 1, 0);
			}
			var days:uint = date.getDate();
			date.setDate(1);
			var firstDay:uint = date.getDay();
			return {firstDay:firstDay, days:days};
		}

		/**
		 * 양력 -> 음력 변환
		 * month : 0 ~ 11
		 */
		public static function toLunar(DateOrYear:* = null, month:uint = 0, date:uint = 0):Date
		{
			var _date:Date;
			
			if (DateOrYear == null)
			{
				_date = new Date();
			}
			else if (DateOrYear is Date)
			{
				_date = DateOrYear;
			}
			else
			{
				_date = new Date(DateOrYear, month, date);
			}
			
			var lunar:lunarCalendar = new lunarCalendar(uint(_date.fullYear), uint(_date.getMonth() + 1), uint(_date.getDate()));
			_date = new Date(lunar.fullyear, lunar.month - 1, lunar.day);
			return _date;
		}
		
		private static function elapsedDate(dOne:Date, dTwo:Date = null):Date 
		{
			if(dTwo == null) 
			{
				dTwo = new Date();
			}
			return new Date(dOne.getTime() - dTwo.getTime());
		}

		/**
		 * 두 데이터 경과 시간을 밀리초단위로 반환
		 */
		public static function elapsedMilliseconds(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard) 
			{
				return elapsedDate(dOne, dTwo).getUTCMilliseconds();
			}
			else 
			{
				return (dOne.getTime() - dTwo.getTime());
			}
		}
		
		/**
		 * 두 데이터 경과 시간을 초단위로 반환
		 */
		public static function elapsedSeconds(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard) 
			{
				return (elapsedDate(dOne, dTwo).getUTCSeconds());
			}
			else 
			{
				return Math.floor(elapsedMilliseconds(dOne, dTwo) / SECOND);
			}
		}

		/**
		 * 두 데이터 경과 시간을 분단위로 반환
		 */
		public static function elapsedMinutes(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard) 
			{
				return (elapsedDate(dOne, dTwo).getUTCMinutes());
			}
			else 
			{
				return Math.floor(elapsedMilliseconds(dOne, dTwo) / MINUTE);
			}
		}

		/**
		 * 두 데이터 경과 시간을 시간단위로 반환
		 */
		public static function elapsedHours(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard) 
			{
				return (elapsedDate(dOne, dTwo).getUTCHours());
			}
			else 
			{
				return Math.floor(elapsedMilliseconds(dOne, dTwo) / HOUR);
			}
		}

		/**
		 * 두 데이터 경과 시간을 일단위로 반환
		 */
		public static function elapsedDays(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard) 
			{
				return (elapsedDate(dOne, dTwo).getUTCDate() - 1);
			}
			else 
			{
				return Math.floor(elapsedMilliseconds(dOne, dTwo) / DAY);
			}
		}

		/**
		 * 두 데이터 경과 시간을 월단위로 반환
		 */
		public static function elapsedMonths(dOne:Date, dTwo:Date = null, bDisregard:Boolean = false):Number 
		{
			if(bDisregard)
			{
				return (elapsedDate(dOne, dTwo).getUTCMonth());
			}
			else 
			{
				return (elapsedDate(dOne, dTwo).getUTCMonth() + elapsedYears(dOne, dTwo) * 12);
			}
		}

		/**
		 * 두 데이터 경과 시간을 연단위로 반환
		 */
		public static function elapsedYears(dOne:Date, dTwo:Date = null):Number 
		{
			return (elapsedDate(dOne, dTwo).getUTCFullYear() - 1970);
		}
		
		/**
		 * 두 데이터 경과 시간을 각각의 시간 단위로 반환
		 * return Object parameters : years, months, days, hours, minutes, seconds, milliseconds
		 */
		public static function elapsed(dOne:Date, dTwo:Date = null):Object 
		{
			var oElapsed:Object = new Object();
			oElapsed["years"] = elapsedYears(dOne, dTwo);
			oElapsed["months"] = elapsedMonths(dOne, dTwo, true);
			oElapsed["days"] = elapsedDays(dOne, dTwo, true);
			oElapsed["hours"] = elapsedHours(dOne, dTwo, true);
			oElapsed["minutes"] = elapsedMinutes(dOne, dTwo, true);
			oElapsed["seconds"] = elapsedSeconds(dOne, dTwo, true);
			oElapsed["milliseconds"] = elapsedMilliseconds(dOne, dTwo, true);
			return oElapsed;
		}
	}
}
