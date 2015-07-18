package evtOne
{
	
	import com.greensock.*;
	import com.greensock.easing.Cubic;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sendInform.SendInform;

	public class EvtOne_Input
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	이름 전화번호 보내기 	*/
		private var $sendInform:SendInform;
		/**	내용보내기	*/
		private var $resultCtrl:SendInform;
		
		public function EvtOne_Input(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.EVT_TWO_VIEW, evtTwoViewHandler);
			
			$sendInform = SendInform.getInstance();
			
			makeBtn();
		}
		
		protected function evtTwoViewHandler(e:Event):void
		{
//			TweenMax.to(e.target, 0, {colorTransform:{exposure:1.5, brightness:1}});
//			TweenMax.to(e.target, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			resetHandler();
			trace(":: 이벤트 완료 ::");
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			$con.btnCom.buttonMode = true;
			$con.btnCom.addEventListener(MouseEvent.CLICK, completeHandler);
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		/**	완료 버튼 핸들러	*/
		private function completeHandler(e:MouseEvent):void
		{
			var name:String = $con.txt0;
			var number:String = $con.txt0 + $con.txt1 + $con.txt2;
			var progress:String = "start";
			
			/**	유저 이름& 번호 모델에 저장	*/
			$model.uname = name;
			$model.ucellular = number;
			
			/**	텍스트 없을시 반환	*/
			if(name.length == 0 && number.length == 0) 
			{
				return;
			}
			
			$sendInform.evtOneSend(name, number, progress);
			trace("$model.evtPageNum:::::: "+$model.evtPageNum);
		}
		
		/**	닫기 버튼 핸들러	*/
		private function closeHandler(e:MouseEvent):void
		{
			/**	리스트 롤링 재시작	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_START));
			resetHandler();
		}
		
		private function resetHandler():void
		{
			/**	키보드 리셋	*/
			$model.dispatchEvent(new Event(ModelEvent.KEYBOARD_RESET));
			
			TweenMax.to($con.parent, 1.5, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($con, 1.5, {autoAlpha:0, ease:Cubic.easeOut});
			trace("::: close evtOneCon :::");
		}
	}
}