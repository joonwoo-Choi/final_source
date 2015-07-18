package com.cj.utils 
{
	public class ArrayUtil 
	{
		/**
		 * 두배열이 원소값 일치 비교 
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */		
		public static function matchArray(source:Array, target:Array):Boolean 
		{
			if (source.length != target.length) return false;
			return source.every(function(item:*, i:int, a:Array):Boolean 
			{
				return (item == target[i]);
			});
		}
		
		/**
		 * 배열 랜덤으로 섞기
		 * @param array
		 * @param maxCount
		 * @return 
		 */		
		public static function shuffle(array:Array, maxCount:int=int.MAX_VALUE):Array
		{
			var oldArray:Array = array.slice();
			var shuffledArray:Array = [];
			var oldArrayL:uint = oldArray.length;
			
			// 배열길이값이 int의 최대값을 넘지않게하기
			maxCount = Math.min(maxCount, oldArrayL);
			
			while (maxCount--) {
				// 배열에서 랜덤인덱스의 값을 제거하고 다시 넣기
				shuffledArray.push(oldArray.splice(Math.floor(Math.random() * oldArrayL), 1)[0]);
				oldArrayL--;
			}
			
			return shuffledArray;
		}
		
		/**
		 * arrayA에서 arrayB에 중복되는 값의 배열 반환
		 * @param arrayA
		 * @param arrayB
		 * @return 
		 * 
		 */		
		public static function intersect(arrayA:Array, arrayB:Array):Array 
		{
			var newArray:Array = [];
			for each(var value:* in arrayA){
				// 배열의 내용을 비교해서 동일한것만 고르기
				if(arrayB.indexOf(value) != -1){
					newArray.push(value);
				}
			}
			return newArray;
		}
		
		/**
		 * arrayA에서 arrayB에 중복되지 않는 값의 배열 반환
		 * @param arrayA
		 * @param arrayB
		 * @return 
		 * 
		 */		
		public static function diff(arrayA:Array, arrayB:Array):Array 
		{
			var newArray:Array = [];
			for each (var value:* in arrayA) {
				if (arrayB.indexOf(value) == -1) {
					newArray.push(value);
				}
			}
			return newArray;
		}
		
		/**
		 * 배열에 중복되는값을 제거하고 반환
		 * @param array
		 * @return 
		 * 
		 */		
		public static function unique(array:Array):Array
		{
			var arrayL:uint = array.length;
			if (!arrayL) return [];
			
			var newArray:Array = [array[0]];
			for (var i:uint = 1; i < arrayL; i++){
				var item:* = array[i];
				
				// 해당인덱스의 앞번호부터 역순으로 검색해서 같은 값이 없다면
				// 새로운 배열에 넣기
				if(array.lastIndexOf(item, i - 1) == -1){
					newArray.push(item);
				}
			}
			return newArray;
		}
		
		/**
		 * 배열을 검색해서 특정 속성값을 가진 원소의 인덱스 반환
		 * 없다면 -1 반환   
		 * @param array :: 오브젝트들을 가진 배열
		 * @param prop :: 찾을 속성의 이름
		 * @param searchElement :: 찾을 속성값
		 * @return 
		 */		
		public static function indexOfWithProp(array:Array, prop:String, searchElement:Object):int 
		{
			var i:int = 0;
			for each(var value:Object in array){
				
				// 해당 속성을 가졌는지 확인
				if(value.hasOwnProperty(prop)){
					// 속성값이 검색값이랑 일치하다면 인덱스 반환
					if(value[prop] == searchElement){
						return i;
					}
				}
				i++;
			}
			
			// 찾지 못했다면 -1 반환
			return -1;
		}
	}
}