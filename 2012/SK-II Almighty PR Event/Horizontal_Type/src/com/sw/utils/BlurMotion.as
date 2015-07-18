package com.sw.utils
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;

	/**
	  * 오브젝트 블러먹여서 등장 클래스 (싱글톤)
	 * */
	public class BlurMotion
	{
		static private var ins:BlurMotion = new BlurMotion();
		/**	생성자	*/
		public function BlurMotion()
		{
			if(ins != null) throw new Error("BlurMotion은 싱글톤임.");
		}
		static public function getIns():BlurMotion
		{	return ins;	}
		/**
		 * 오브젝트 블러먹여서 등장
		 * @param $obj			::	등장 대상
		 * @param $finish_fnc 	::	등장후 호출함수
		 * @param $fnc_obj		::	등장후 호출함수 인자값
		 * 
		 */
		public function viewBlurObj($obj:MovieClip,$finish_fnc:Function = null,$fnc_obj:Object = null,$alpha:int=1,$speed:Number=0):void
		{
			if($alpha == 1) $obj.mouseChildren = true;
			else if($alpha == 0) $obj.mouseChildren = false;
			
			$obj.filters = [new BlurFilter(4,4)];
			
			TweenMax.to($obj,0,{alpha:$obj.alpha,overwrite:0});
			TweenMax.to($obj,0.5+$speed,{alpha:$alpha,overwrite:1});
			var obj:Object = new Object();
			obj.blurX = 0;
			obj.blurY = 0;
			TweenMax.to($obj,0.5+$speed,{delay:0.3,blurFilter:obj,onComplete:finishBlur,onCompleteParams:[$obj,$finish_fnc,$fnc_obj]});
			
			$obj.visible = true;
		}
		/**	블러 모션 끝*/
		private function finishBlur($obj:MovieClip,$finish_fnc:Function,$fnc_obj:Object):void
		{
			if($obj.alpha == 0) $obj.visible = false;
			$obj.filters = null;
			if($finish_fnc != null && $fnc_obj != null) $finish_fnc($fnc_obj);	
			if($finish_fnc != null && $fnc_obj == null) $finish_fnc();	
		}
		
	}//class
}//package