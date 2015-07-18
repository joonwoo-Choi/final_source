package com.cj.utils
{
	public class MathUtil
	{
		public function MathUtil(){}
		/**
		 * 
		 * @param nx	: target x
		 * @param ny	: target y
		 * @param px	: obj x
		 * @param py	: obj y
		 * @return 		: target과 obj간 거리
		 * 
		 */		
		public static function getDistance(nx:Number, ny:Number, px:Number, py:Number):Number
		{
			var dx:Number = nx - px;
			var dy:Number = ny - py;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * @param nx	: target x
		 * @param ny	: target y
		 * @param px	: obj x
		 * @param py	: obj y
		 * @return 		: target과 obj간 각도
		 * 
		 */		
		public static function getAngle(nx:Number, ny:Number, px:Number, py:Number):Number
		{
			var dx:Number = nx - px;
			var dy:Number = ny - py;
			
			return Math.atan2(dy,dx) * Math.PI/180;
		}
		
		/**
		 * 정수 랜덤 구하기 
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function getRandomInt(start:int, end:int):int
		{
			return Math.round(start - 0.5 + (end - start + 1) * Math.random());
		}
		
		/**
		 * 랜덤 구하기 
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function getRandom(start:Number, end:Number):Number
		{
			return start + (end - start) * Math.random();
		}
		
		/**
		 * 배열원소들의 평균 구하기 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function average(arr:Array):Number
		{
			return MathUtil.sum(arr) / arr.length;
		}
		
		/**
		 * 배열원소들의 합 구하기 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function sum(arr:Array):Number
		{
			var sum:Number = 0;
			var len:Number = arr.length;
			for (var i:Number = 0; i < len; i++) {
				sum += arr[i];
			}
			return sum;
		}
		
		/**
		 * 최소/최대값 범위안에서의 결과값구하기
		 * @param value
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public static function clamp(value:Number, min:Number, max:Number):Number 
		{
			value = Math.max(min, value);
			value = Math.min(max, value);
			return value;
		}
		
		/**
		 * Number 자릿수 지정
		 * Examples:
		 * MathUtils.float(12345.67, -1) returns 12350
		 * MathUtils.float(12345.67, -2) returns 12300
		 * MathUtils.float(12345.67, 1) returns 12345.7
		 */
		public static function float(val:Number, sigDigits:Number):Number 
		{
			var m:Number = Math.pow(10, sigDigits);
			return Math.round(val * m) / m;
		}
		
		
		/**
		 * 두각도간 가까운 각도 구하기 
		 * @param angleTo
		 * @param currentAngle
		 * @return 
		 * 
		 */		
		public static function getShortAngle(angleTo:Number,currentAngle:Number):Number
		{
			var diffAngle:Number = Math.atan2(Math.sin(angleTo - currentAngle), Math.cos(angleTo - currentAngle));
			return diffAngle * 180/Math.PI;
		}
		
		
		/**
		 * 라디안 값으로 구하기 
		 * @param ang
		 * @return 
		 * 
		 */		
		public static function makeRadian(ang:Number):Number
		{
			var ta:Number = ang * Math.PI/180;
			return ta;
		}
		
		/**
		 * 플래시에서 함수 Math.abs은 매우 비효율적이다. 대신 이것을 사용하자.
		 */
		public function abs(x:Number):Number 
		{
			return (x >= 0) ? x : -x;
		}
		
		/**
		 * 1을 반환하면 0보다 크거나 같다. 아니면 0
		 */
		public function sign(x:Number):Number 
		{
			return (x >= 0) ? 1 : 0;
		}
		
		
	}
}