package evtTwo
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sendInform.SendInform;

	public class EvtTwo_Input extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	이름 전화번호 보내기 	*/
		private var $sendInform:SendInform;
		
		public function EvtTwo_Input(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	초대장 더 보내기	*/
			$model.addEventListener(ModelEvent.FRIENDS_INVITE, moreInviteHandler);
			/**	완료 페이지 보이기	*/
			$model.addEventListener(ModelEvent.COMPLETE_PAGE, comPageViewHandler);
			
			$sendInform = SendInform.getInstance();
			
			makeBtn();
		}
		
		private function comPageViewHandler(e:Event):void
		{
//			TweenMax.to(e.target, 0, {colorTransform:{exposure:1.2, brightness:1}});
//			TweenMax.to(e.target, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			resetHandler();
			
//			var mc:MovieClip = $con.parent.getChildByName("completeCon") as MovieClip;
//			TweenMax.to(mc, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			trace("::: 이벤트 완료 :::");
		}
		
		/**	초대장 더 보내기 보이기	*/
		private function moreInviteHandler(e:Event):void
		{
			/**	편지지 백그라운드 보이기	*/
			var bg:MovieClip = $con.parent.getChildByName("bg") as MovieClip;
			TweenMax.to(bg, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			
			TweenMax.to($con, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			$con.btn.buttonMode = true;
			$con.btn.addEventListener(MouseEvent.CLICK, completeHandler);
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		/**	완료 버튼 핸들러	*/
		private function completeHandler(e:MouseEvent):void
		{
			var name:String = $con.txt0;
			var number:String = $con.txt0 + $con.txt1 + $con.txt2;
			var progress:String = "send"
			
			/**	텍스트 없을시 반환	*/
			if(name.length == 0 && number.length == 0) return;
			
			$sendInform.evtOneSend(name, number, progress);
		}
		
		/**	닫기 버튼 핸들러	*/
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
			/**	inputCon 숨기기	*/
			TweenMax.to($con, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			
			/**	편지지 백그라운드 숨기기	*/
			var bg:MovieClip = $con.parent.getChildByName("bg") as MovieClip;
			TweenMax.to(bg, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			trace("::: close inputCon :::");
		}
	}
}