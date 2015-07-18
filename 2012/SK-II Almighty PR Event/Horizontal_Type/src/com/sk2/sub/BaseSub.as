package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.sw.buttons.BtnAlpha;
	import com.sw.display.SetBitmap;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;

	/**
	 * SK2	::	서브 페이지 공통 클래스
	 * */
	public class BaseSub 
	{
		protected var scope_mc:MovieClip;
		protected var data:Object;
		/**	물결 효과를 보여 주었는지 여부	*/
		protected var bRipple:Boolean = false;
		
		/**	생성자	*/
		public function BaseSub($scope:DisplayObjectContainer,$data:Object=null)
		{
			scope_mc = $scope as MovieClip;
			/*
			if(scope_mc != null)
				if(scope_mc.plane_mc != null) scope_mc.plane_mc.visible = false;
			*/
			data = new Object();
			if($data != null) data = $data;
			
		}
		/**	소멸자	*/
		public function destroy():void
		{
			
		}
		/**
		 * 물결 움직임 시작
		 * */
		protected function playRipple():void
		{	
			if(bRipple == true) return;
			if(data.cbk_ripple != null) data.cbk_ripple();	
			bRipple = true;
		}
		/**	물결 움직임 주기 전 셋팅 내용	 */
		public function setRipple():void
		{	playRipple();	}
		/**
		 * 초기화
		 * */
		public function init():void
		{}
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
			
			TweenMax.to($obj,0,{alpha:$obj.alpha,override:0});
			TweenMax.to($obj,0.5+$speed,{alpha:$alpha,override:1});
			var obj:Object = new Object();
			obj.blurX = 0;
			obj.blurY = 0;
			TweenMax.to($obj,0.5+$speed,{delay:0.3,blurFilter:obj,onComplete:finishBlur,onCompleteParams:[$obj,$finish_fnc,$fnc_obj]});
			
			$obj.visible = true;
		}
		
		private function finishBlur($obj:MovieClip,$finish_fnc:Function,$fnc_obj:Object):void
		{
			if($obj.alpha == 0) $obj.visible = false;
			$obj.filters = null;
			if($finish_fnc != null && $fnc_obj != null) $finish_fnc($fnc_obj);	
			if($finish_fnc != null && $fnc_obj == null) $finish_fnc();	
		}
		
		/**
		 *	기본 버튼 셋팅 
		 * @param $btn			:: 버튼 mc
		 * @param $click_fnc	:: 클릭시 수행 함수
		 */
		public function setBaseBtn($btn:MovieClip,$click_fnc:Function):void
		{
			if($btn == null) return;
			$btn.alpha = 0;
			$btn.blendMode = BlendMode.ADD;
			TweenMax.to($btn,0,{tint:0x8B0106});
			var ba:BtnAlpha = new BtnAlpha($btn,{click:$click_fnc,alpha:0.5});
		}
		/**	
		 * 물방울 등장	
		 * @param $bubble	::	물방울 mc
		 * @param $data		::	추가 데이터 {speed,delay,scale}
		 * 
		 */
		public function moveBubble($bubble:MovieClip,$data:Object=null):void
		{
			var bubble:MovieClip = $bubble;
			SetBitmap.go(bubble,true);
			
			var data:Object = new Object();
			if($data != null) data = $data;
			
			data.speed = (data.speed != null) ? (data.speed):(1);
			data.delay = (data.delay != null) ? (data.delay):(0);
			data.scale = (data.scale != null) ? (data.scale):(0.8);
			if(data.dirScale == null)
			{	
				bubble.alpha = 0;
				bubble.scaleX = data.scale;
				bubble.scaleY = data.scale;
				data.dirScale = 1;
				data.alpha = 1;
			}
			else data.alpha = 0;
			
			TweenMax.to(bubble,data.speed,{	delay:data.delay,
											alpha:data.alpha,
											scaleX:data.dirScale,
											scaleY:data.dirScale,
											ease:Elastic.easeOut});
		}
	}//class
}//package