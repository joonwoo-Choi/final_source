package com.sw.utils
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.sw.buttons.BtnScale;
	import com.sw.display.BaseClass;
	import com.sw.motion.IntroScale;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 팝업 어미 클래스
	 * */
	public class BasePopup extends BaseClass
	{
		/**	클릭 제어 mc	*/
		protected var lock_mc:DisplayObjectContainer;
		/**	클릭 제어 mc alpha 값	*/
		protected var lock_alpha:Number;
		/**	팝업 현 위치		*/
		protected var pos:String;
		/**	중앙 본문 내용	*/
		protected var body_mc:MovieClip;
		/**	popup띄우면서 전달된 데이터	*/
		protected var viewData:Object;
		
		/**	생성자		
		 * @param $scope		::	popup 내용이 들어 있는 object
		 * @param $data			::{view_fnc,hide_fnc}		
		 * 
		 */
		public function BasePopup($scope:Object, $data:Object=null)
		{
			super($scope, $data);
			if(data.lock == null)
				throw new Error("오류 : Popup","lock이 없습니다.");
			if(scope.body_mc == null)
				throw new Error("오류 : Popup","body_mc가 없습니다.");
			if(scope.plane_mc == null)
				throw new Error("오류 : Popup","plane_mc가 없습니다.");
			if(scope.body_mc.plane_mc == null)
				throw new Error("오류 : Popup","body_mc.plane_mc가 없습니다.");
			
			lock_mc = data.lock;
			body_mc = scope.body_mc;
			body_mc.visible = false;
			body_mc.gotoAndStop(1);
			lock_alpha = (data.alpha != null) ? (data.alpha) : (0.5);
			
			scope.plane_mc.visible = false;
			body_mc.plane_mc.visible = false;
		}
		
		/**	소멸자		*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**
		 * 초기화
		 * */
		protected function init():void
		{
		
		}
		
		/**
		 * 팝업 보여지기
		 * @param $pos		::		팝업 위치
		 * @param $data		::		추가 데이터 ( alert의 경우 표시될 문자)
		 */
		public function viewPop($pos:String,$data:Object=null):void
		{
			body_mc.gotoAndStop("basic");
			body_mc.visible = true;
			viewData = $data;
			if(viewData == null) viewData = new Object();
			
			pos = $pos;
			body_mc.gotoAndStop($pos);											//해당 위치로 이동
			this[$pos]();														//현제 위치 함수 수행
			introView();			
			lock_mc.visible = true;
			setClose();
		}
		
		/**
		 * 팝업 가려지기
		 * */
		public function hidePop():void
		{	
			lock_mc.visible = false;
			
			//소멸자 수행
			if(pos != null)
				this[pos+"_destroy"]();
			
			if(data.hide_fnc != null) 
			{	data.hide_fnc();	return;	}
			introHide();
		}
		
		/**	보여지는 모션	*/
		protected function introView():void
		{
			var ins:IntroScale = new IntroScale(body_mc,{});
		}
		
		/**	사라지는 모션	*/
		protected function introHide():void
		{
			TweenMax.to(body_mc,0.3,{	overwrite:1,
										x:(body_mc.dw/4)+body_mc.dx,
										y:(body_mc.dh/4)+body_mc.dy,
										scaleX:0.5,scaleY:0.5,alpha:0,
										onComplete:finishHide,
										ease:Back.easeIn});
		}
		protected function finishHide():void
		{	
			if(body_mc.alpha == 0) body_mc.visible = false;
		}
		/**		
		 * 이벤트 추가
		 * */
		protected function addEvent():void
		{
			setClose();
		}
		/**
		 * 닫기 버튼
		 * */
		protected function setClose():void
		{
			var bs:BtnScale = new BtnScale(body_mc.close_btn,{click:onClickClose});
		}
		protected function onClickClose(e:MouseEvent):void
		{
			hidePop();
		}
		
	}//class
}//package