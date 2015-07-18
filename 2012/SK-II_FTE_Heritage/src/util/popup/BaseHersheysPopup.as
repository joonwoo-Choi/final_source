package util.popup
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.utils.BasePopup;
	import com.sw.utils.BlurMotion;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;
	
	/**		
	 * SK2_Hersheys :: 팝업 공통 내용
	 */
	public class BaseHersheysPopup extends BasePopup
	{
		/**	생성자	*/
		public function BaseHersheysPopup($scope:Object, $data:Object=null)
		{
			super($scope, $data);
			TweenMax.to(body_mc,0,{blurFilter:new BlurFilter(4,4),alpha:0});
		}
		
		/**	팝업 alpha값 반환	*/
		public function getBodyAlpha():Number
		{	return body_mc.alpha;	}
		
		
		/**	팝업 보여지기	*/
		override public function viewPop($pos:String, $data:Object=null):void
		{
			super.viewPop($pos,$data);
		}
		
		
		/**	닫기 버튼 셋팅	*/
		override protected function setClose():void
		{
			var btnClose:MovieClip = body_mc.close_btn as MovieClip;
			trace("닫기 버튼 셋팅 btnClose: ",btnClose);	
			if(btnClose != null)
			{
				trace("body_mc.close_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));");
				btnClose.buttonMode = true;
				btnClose.addEventListener(MouseEvent.CLICK,onClickClose);
				
			}
			
			var btnX:MovieClip = body_mc.btnX as MovieClip;
			trace("닫기 버튼 셋팅 btnX: ",btnX);	
			if(btnX != null) Button.setUI(btnX,{click:onClickX});
			
		}
		
		/**	팝업 사라지기	*/
		override public function hidePop():void
		{
			super.hidePop();
		}
		/**	팝업 보여지는 모션	*/
		override protected function introView():void
		{
			body_mc.visible = true;
			
			var obj:Object = {};
			obj.blurFilter = new BlurFilter(0,0);
			obj.ease = Expo.easeOut;
			obj.alpha = 1;
			obj.onComplete = finishIntro;
			//TweenMax.to(body_mc,1,obj);
			BlurMotion.getIns().viewBlurObj(body_mc,finishIntro,null,1,0.3);
		}
		
		/**	팝업 사라지는 모션	*/
		override protected function introHide():void
		{
			BlurMotion.getIns().viewBlurObj(body_mc,finishIntro,null,0,0.3);
		}
		
		/**	팝업 등장,사라지기 움직임 완료		*/
		private function finishIntro():void
		{
			if(body_mc.alpha == 1) body_mc.filters = [];
			if(body_mc.alpha == 0) body_mc.visible = false;
		}
		/**	팝업 사라지고 영상 플레이	*/
		private function onClickX(mc:MovieClip):void
		{
			trace("팝업 사라지고 영상 플레이 onClickX");
			hidePop();
			Global.getIns().playMovie();
		}
		
	}//class
}//package