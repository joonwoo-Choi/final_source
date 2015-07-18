package evtTwo
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EvtTwo_Join extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		
		public function EvtTwo_Join(con:MovieClip) 
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	evtTwoCon 페이지 보이기	*/
			$model.addEventListener(ModelEvent.EVT_TWO_VIEW, evtTwoViewHandler);
			
			makeBtn();
		}
		
		private function evtTwoViewHandler(e:Event):void
		{
			TweenMax.to($con, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			TweenMax.to($con.parent, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			
			/**	편지지 백그라운드 보이기	*/
			var bg:MovieClip = $con.parent.getChildByName("bg") as MovieClip;
			TweenMax.to(bg, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			trace("이벤트2 페이지 보이기");
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			$con.btn.buttonMode = true;
			$con.btn.addEventListener(MouseEvent.CLICK, showInputPageHandler);
			
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function showInputPageHandler(e:MouseEvent):void
		{
			TweenMax.to(e.target, 0, {colorTransform:{exposure:1.2, brightness:1}});
			TweenMax.to(e.target, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			TweenMax.to($con, 1.2, { autoAlpha:0, ease:Cubic.easeOut});
			
			var mc:MovieClip = $con.parent.getChildByName("inputCon") as MovieClip;
			TweenMax.to(mc, 0, {colorTransform:{exposure:1.2, brightness:0.5}});
			TweenMax.to(mc, 1.2, {colorTransform:{exposure:1, brightness:0}, autoAlpha:1, ease:Cubic.easeOut});
			
			/**	이벤트 페이지 번호	*/
			$model.evtPageNum = 1;
			trace("::: Show inputCon :::");
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			/**	리스트 롤링 재시작	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_START));
			
			TweenMax.to($con.parent, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($con, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			
			trace("::: Close evtTwoCon :::");
		}
	}
}