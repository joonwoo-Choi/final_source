package com.sw.utils
{
	import flash.display.MovieClip;
	
	
	public class Sum
	{
		
		public function Sum()
		{
			
		}
		/**	$mc의 $scale로 scale 수정후 중앙 위치값 [x,y] 배열로 반환	*/
		static public function center($mc:Object,$scale:Number):Array
		{
			var ary:Array = [];
			
			var bWidth:Number = $mc.width;
			var nWidth:Number = (bWidth/$mc.scaleX)*$scale;
			ary[0] = Math.round((bWidth-nWidth)/2);
			
			var bHeight:Number = $mc.height;
			var nHeight:Number = (bHeight/$mc.scaleY)*$scale;			
			ary[1] = Math.round((bHeight-nHeight)/2);
			
			return ary;
		}		
		/**	비율 맞춰서 넓이 기준으로 사이즈 조절	*/
		static public function resizeW($obj:Object,$num:Number):void
		{
			var dw:Number = $obj.width;
			var dh:Number = $obj.height;
			$obj.width = $num;
			$obj.height = ((dh/dw)*$num);
		}
		/**	비율 맞춰서 높이 기준으로 사이즈 조절	*/
		static public function resizeH($obj:Object,$num:Number):void
		{
			var dw:Number = $obj.width;
			var dh:Number = $obj.height;
			$obj.height = $num;
			$obj.width = ((dw/dh)*$num);		
		}
			
		/**	$obj의 width를 기준으로 $sw의 중심 값 반환*/
		static public function getCenX($sw:Number,$obj:Object):Number
		{
			return Math.round(($sw-$obj.width)/2);
		}
		/**	$obj의 width를 기준으로 $sw의 중심 값 반환*/
		static public function getCenY($sh:Number,$obj:Object):Number
		{
			return Math.round(($sh-$obj.height)/2);
		}
		
		/**	$obj의 width를 기준으로 $sw의 중심 값 적용*/
		static public function setCenX($sw:Number,$obj:Object):void
		{	$obj.x = Sum.getCenX($sw,$obj);	}
		/**	$obj의 height를 기준으로 $sh의 중심 값 적용*/
		static public function setCenY($sh:Number,$obj:Object):void
		{	$obj.y = Sum.getCenY($sh,$obj);	}
		/**	$obj의 width,height를 기준으로 $sw,$sh의 중심 값 적용*/
		static public function setCenXY($sw:Number,$sh:Number,$obj:Object):void
		{	
			Sum.setCenX($sw,$obj);	
			Sum.setCenY($sh,$obj);	
		}		
		
		/**	최대, 최소 값 적용	 
		 * @param $num	::	비교 대상 숫자
		 * @param $max	::	최대 값
		 * @param $min	::	최소 값
		 * @return 	:: 비교 결과 값 
		 * 
		 */
		static public function setMinMax($num:Number,$max:Number,$min:Number=0):Number
		{
			if($num < $min) $num = $min;
			if($num > $max) $num = $max;
			
			return $num;
		}
		
		/**
		 * cnt 갯수 만큼 랜덤으로 섞인 배열 반환
		 * @param cnt :: 갯수
		 */
		static public function supple(cnt:int):Array
		{
			var ary:Array = [];
			var i:int;
			
			for(i = 0; i<cnt; i++) ary.push(i);
			for(i = 0; i<cnt; i++) suppleAry(ary);
			
			return ary;
		}
		/**	배열 순서 섞기	*/
		static public function suppleAry(ary:Array):void
		{
			var ran1:int = Math.random()*ary.length;
			var ran2:int = Math.random()*ary.length;
			var num:int;
		
			num = ary[ran1];
			ary[ran1] = ary[ran2];
			ary[ran2] = num;
		}
	}
}

