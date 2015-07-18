package evtTwo
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EvtTwo_Complete extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		
		public function EvtTwo_Complete(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	완료 페이지 보이기	*/
			$model.addEventListener(ModelEvent.COMPLETE_PAGE, comPageViewHandler);
			
			makeBtn();
		}
		
		private function comPageViewHandler(e:Event):void
		{
			TweenMax.to($con, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			$con.btn0.buttonMode = true;
			$con.btn0.addEventListener(MouseEvent.CLICK, closeHandler);
			
			$con.btn1.buttonMode = true;
			$con.btn1.addEventListener(MouseEvent.CLICK, inviteFriendsHandler);
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		/**	친구초대 더하기 	*/
		private function inviteFriendsHandler(e:MouseEvent):void
		{
			TweenMax.to(e.target, 0, {colorTransform:{exposure:1.2, brightness:1}});
			TweenMax.to(e.target, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			resetHandler();
			
			/**	evtTwoCon 페이지 보이기	*/
			$model.dispatchEvent(new Event(ModelEvent.FRIENDS_INVITE));
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			/**	리스트 롤링 재시작	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_START));
			/**	팝업 컨테이너 숨기기 	*/
			TweenMax.to($con.parent, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			resetHandler();
		}
		
		private function resetHandler():void
		{
			/**	키보드 리셋	*/
			$model.dispatchEvent(new Event(ModelEvent.KEYBOARD_RESET));
			/**	completeCon 숨기기	*/
			TweenMax.to($con, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			trace("::: close evtOneCon :::");
		}
	}
}