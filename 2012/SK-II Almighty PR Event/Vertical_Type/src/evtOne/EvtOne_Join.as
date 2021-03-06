package evtOne
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EvtOne_Join
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		
		public function EvtOne_Join(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	참여하기 페이지 보이기	*/
			$model.addEventListener(ModelEvent.EVT_ONE_VIEW, viewPageHandler);
			
			makeBtn();
		}
		
		/**	참여하기 페이지 보이기	*/
		protected function viewPageHandler(e:Event):void
		{
			/**	백그라운드 보이기	*/
			var mc:MovieClip = $con.parent.parent.getChildByName("bg") as MovieClip; 
			TweenMax.to(mc, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			
			TweenMax.to($con, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			TweenMax.to($con.parent, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			$con.btn.buttonMode = true;
			$con.btn.addEventListener(MouseEvent.CLICK, showInputPageHandler);
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		/**	신상정보 입력 페이지 팝업	*/
		private function showInputPageHandler(e:MouseEvent):void
		{
			TweenMax.to(e.target, 0, {colorTransform:{exposure:1.2, brightness:1}});
			TweenMax.to(e.target, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			TweenMax.to($con, 1.2, { autoAlpha:0, ease:Cubic.easeOut});
			
			var mc:MovieClip = $con.parent.getChildByName("inputCon") as MovieClip;
			TweenMax.to(mc, 0, {colorTransform:{exposure:1.2, brightness:0.5}});
			TweenMax.to(mc, 1.2, {colorTransform:{exposure:1, brightness:0}, autoAlpha:1, ease:Cubic.easeOut});
			
			/**	이벤트 페이지 번호	*/
			$model.evtPageNum = 0;
			trace("::: Show inputCon :::");
		}
		
		/**	참여하기 페이지 닫기	*/
		private function closeHandler(e:MouseEvent):void
		{
			/**	리스트 롤링 재시작	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_START));
			
			TweenMax.to($con.parent, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($con, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			trace("::: close evtOneCon :::");
		}
	}
}