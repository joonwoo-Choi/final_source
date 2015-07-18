package
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import eventPop.keyBoardMain.VirtualKeyboard_EvtOne;
	
	import evtOne.EvtOne_Input;
	import evtOne.EvtOne_Join;
	
	import evtTwo.EvtTwo_Complete;
	import evtTwo.EvtTwo_Input;
	import evtTwo.EvtTwo_Join;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import museList.ReviewPage;
	import museList.RollingList;
	
	[SWF(width="1024", height="1280", frameRate="60", backgroundColor="#ffffff")]
	
	public class Index extends Sprite
	{
		
		private var $main:AssetMain;
		/**	모델	*/
		private var $model:Model;
		/**	롤링 리스트	*/
		private var $listCon:RollingList;
		/**	롤링 리스트	*/
		private var $reviewCon:ReviewPage;
		/**	evtOneCon 참여하기 팝업 페이지	*/
		private var $evtOneJoinCon:EvtOne_Join;
		/**	evtOneCon 정보입력 팝업 페이지	*/
		private var $evtOneInputCon:EvtOne_Input;
		/**	evtTwoCon 참여하기 팝업 페이지	*/
		private var $evtTwoJoinCon:EvtTwo_Join;
		/**	evtTwoCon 정보입력 팝업 페이지	*/
		private var $evtTwoInputCon:EvtTwo_Input;
		/**	evtTwoCon 완료 팝업 페이지	*/
		private var $evtTwoCompleteCon:EvtTwo_Complete;
		/**	evt1 키보드	*/
		private var $keyboard_evtOne:VirtualKeyboard_EvtOne;
		/**	evt2 키보드	*/
		private var $keyboard_evtTwo:VirtualKeyboard_EvtOne;
		/**	롤링 타이머 타임아웃 	*/
		private var $rollingTimeOut:uint;
		
		/**	롤링 타이머	*/
		private var $timer:Timer;
		
		public function Index()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetMain();
			addChild($main);
			
			/**	풀 스크린 모드	*/
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			$model = Model.getInstance();
			/**	리스트 롤링 일시 정지	*/
			$model.addEventListener(ModelEvent.TIMER_PAUSE, timerPauseHandler);
			/**	리스트 롤링 시작	*/
			$model.addEventListener(ModelEvent.TIMER_START, viewListConHandler);
			/**	리스트 롤링 정지	*/
			$model.addEventListener(ModelEvent.TIMER_STOP, timerStopHandler);
			
			/**	롤링 리스트	*/
			$listCon = new RollingList($main.listCon);
			
			/**	리뷰 페이지	*/
			$reviewCon = new ReviewPage($main.listCon.reviewCon);
			
			/**	evtOneCon 참여하기 팝업 페이지 	*/
			$evtOneJoinCon = new EvtOne_Join($main.evtOneCon.joinCon);
			
			/**	evtOneCon 정보 입력 팝업 페이지	*/
			$evtOneInputCon = new EvtOne_Input($main.evtOneCon.inputCon);
			
			/**	evtTwoCon 참여하기 팝업 페이지	*/
			$evtTwoJoinCon = new EvtTwo_Join($main.evtTwoCon.joinCon);
			
			/**	evtTwoCon 정보입력 팝업 페이지	*/
			$evtTwoInputCon = new EvtTwo_Input($main.evtTwoCon.inputCon);
			
			/**	evtTwoCon 완료 팝업 페이지	*/
			$evtTwoCompleteCon = new EvtTwo_Complete($main.evtTwoCon.completeCon);
			
			/**	키보드 만들기	*/
			$keyboard_evtOne = new VirtualKeyboard_EvtOne($main.evtOneCon.inputCon);
			$keyboard_evtTwo = new VirtualKeyboard_EvtOne($main.evtTwoCon.inputCon);
			
			/**	리스트 후기 버튼 숨기기	*/
			$main.listCon.btnReview.visible = false;
			$main.listCon.reviewCon.visible = false;
			
			/**	팝업 evtOneCon 페이지 숨기기	*/
			$main.evtOneCon.joinCon.visible = false;
			$main.evtOneCon.inputCon.visible = false;
			$main.evtOneCon.visible = false;
			$main.bg.visible = false;
			
			/**	팝업 evtTwoCon 페이지 숨기기	*/
			$main.evtTwoCon.joinCon.visible = false;
			$main.evtTwoCon.inputCon.visible = false;
			$main.evtTwoCon.completeCon.visible = false;
			$main.evtTwoCon.visible = false;
			
			/**	타이머 만들기	*/
			makeTimer();
		}
		
		protected function viewListConHandler(event:Event):void
		{
			/**	리스트 보이기	*/
			TweenMax.to($main.listCon, 1.2, {autoAlpha:1, ease:Cubic.easeOut});
			/**	리스트 롤링 시작	*/
			rollingStart();
		}
		
		/**	리스트 롤링 일시 정지	*/
		private function timerPauseHandler(e:Event):void
		{
			$timer.stop();
			
			clearTimeout($rollingTimeOut);
			$rollingTimeOut = setTimeout(rollingStart, 10000);
		}
		
		/**	리스트 롤링 정지	*/
		protected function timerStopHandler(e:Event):void
		{
			clearTimeout($rollingTimeOut);
			$timer.stop();
		}
		
		/**	리스트 롤링 시작	*/
		private function rollingStart(e:Event = null):void
		{
			/**	백그라운드 숨기기	*/
			TweenMax.to($main.bg, 1.2, {autoAlpha:0, ease:Cubic.easeOut});
			
			$model.viewArr = [];
			$model.viewLength = 1;
			$timer.start();
		}
		
		private function makeTimer():void
		{
			$timer = new Timer(5000);
			$timer.addEventListener(TimerEvent.TIMER, rollingTimer);
			$timer.start();
		}
		
		protected function rollingTimer(e:TimerEvent):void
		{
			$model.dispatchEvent(new Event(ModelEvent.PAGE_ROLLING));
		}
	}
}