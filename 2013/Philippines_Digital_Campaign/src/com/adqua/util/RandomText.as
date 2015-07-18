package com.adqua.util
{
	/**
	 * 랜덤 텍스트 뿌린 후 정렬
	 */
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class RandomText
	{
		
		private var $txtNum:int;
		
		private var $tf:TextField;
		/**	인수의 문자열을 담을 변수	*/
		private var $txt:String;
		/**	한 글자씩 표시하는 변수	*/
		private var $rightTxt:String;
		/**	사용 될 랜덤 텍스트	*/
		private var $fakeTxt:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@%&$#_?!/-";
		/**	바뀌는 시간	*/
		private var $timer:Timer;
		
		private var $viewTrace:Boolean;
		
		public function RandomText(tf:TextField, txt:String, time:uint, viewTrace:Boolean = false)
		{
			$tf = tf;
			
			$txt = txt;
			
			$timer = new Timer(time);
			
			$viewTrace = viewTrace;
		}
		
		/**	시작	*/
		public function start():void {
			$txtNum = 0;
			$rightTxt = ""; //1글자씩 대입되는 변수
			$tf.addEventListener(Event.ENTER_FRAME, rollWord); //랜덤하게 표시
			$timer.addEventListener(TimerEvent.TIMER, endTimer);
			$timer.start();
		}
		
		/**	랜덤 글자 표시	*/
		private function rollWord(e:Event):void {
			$tf.text = $rightTxt;
			/**	랜덤하게 글자를 표시하는 글자수	*/
			var randomTextNum:int = $txt.length - $rightTxt.length;
			for (var i:int = 0; i < randomTextNum; i++) {
				var randNum:Number = Math.floor(Math.random()*$fakeTxt.length);
				$tf.appendText($fakeTxt.charAt(randNum));
			}
		}
		
		/**	타이머	*/
		private function endTimer(e:Event):void {
			/**	타이머 실행 중	*/
			if ($txtNum != $txt.length - 1) {
				$rightTxt += $txt.charAt($txtNum);
				$txtNum += 1;
				if ($viewTrace) {
					trace($txtNum);
				}
			}
			else
			{
				/**	타이머 종료	*/
				$tf.text = $txt;
				$tf.removeEventListener(Event.ENTER_FRAME, rollWord);
				$timer.stop();
			}
		}
	}
}