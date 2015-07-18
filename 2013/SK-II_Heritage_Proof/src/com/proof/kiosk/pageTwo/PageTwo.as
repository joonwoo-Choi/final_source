package com.proof.kiosk.pageTwo
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class PageTwo
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	메인으로 리셋 타이머	*/
		private var $resetTimer:Timer;
		
		public function PageTwo(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_TWO, pageSetting);
		}
		
		private function pageSetting(e:Event):void
		{
			$model.kioskPageNum = 2;
			
			$resetTimer = new Timer(60000,1);
			$resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
			$resetTimer.start();
			
			$con.visible = true;
			$con.alpha = 1;
			
			$con.tipTxt.alpha = 0;
			$con.specialTxt.alpha = 0;
			$con.finishCon.alpha = 0;
			$con.contestTxt.alpha = 0;
			
			/**	스페샬 기프트 상품 & 텍스트 설정	*/
			var giftNum:int;
			if($model.gender == "M")
			{	giftNum = 6;		}
			else
			{
				switch ($model.skinTrouble)
				{
					case "피부결" : giftNum = 1; break;
					case "탄력" : giftNum = 2; break;
					case "표정라인" : giftNum = 3; break;
					case "피부톤" : giftNum = 4; break;
					case "광채" : giftNum = 5; break;
				}
			}
			$con.finishCon.gotoAndStop(giftNum);
			/**	성별 나이별 팁 & 스페셜 텍스트 설정	*/
			if($model.gender == "M")
			{
				var maleFrame:int;
				switch ($model.skinTrouble)
				{
					case "피부결" : maleFrame = 16; break;
					case "탄력" : maleFrame = 17; break;
					case "표정라인" : maleFrame = 18; break;
					case "피부톤" : maleFrame = 19; break;
					case "광채" : maleFrame = 20; break;
				}
				$con.tipTxt.gotoAndStop(maleFrame);
				$con.specialTxt.gotoAndStop(maleFrame);
			}
			else
			{
				var femaleFrame:int;
				var badPointFrame:int;
				switch ($model.age)
				{
					case 20 : femaleFrame = 1; break;
					case 30 : femaleFrame = 6; break;
					case 40 : femaleFrame = 11; break;
				}
				switch ($model.skinTrouble)
				{
					case "피부결" : badPointFrame = 0; break;
					case "탄력" : badPointFrame = 1; break;
					case "표정라인" : badPointFrame = 2; break;
					case "피부톤" : badPointFrame = 3; break;
					case "광채" : badPointFrame = 4; break;
				}
				$con.tipTxt.gotoAndStop(femaleFrame + badPointFrame);
				$con.specialTxt.gotoAndStop(femaleFrame + badPointFrame);
			}
			$con.specialTxt.x = $con.stage.stageWidth/2 - $con.specialTxt.width/2;
			
			setTimeout(makeResetBtn, 3500);
			setTimeout(showResult, 500);
		}
		
		private function makeResetBtn():void
		{		$con.finishCon.btn.addEventListener(MouseEvent.CLICK, pageTwoOut);		}
		
		private function showResult():void
		{
			TweenLite.to($con.tipTxt, 1, {alpha:1});
			TweenMax.to($con.tipTxt, 1, {
				colorTransform:{exposure:1.1},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.tipTxt]
			});
			
			TweenLite.to($con.specialTxt, 1, {delay:0.5, alpha:1});
			TweenMax.to($con.specialTxt, 1, {
				delay:0.5,
				colorTransform:{exposure:1.1},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.specialTxt]
			});
			
			TweenLite.to($con.finishCon, 1, {delay:1, alpha:1});
			TweenMax.to($con.finishCon, 1, {
				delay:1,
				colorTransform:{exposure:1.1},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.finishCon]
			});
			
			TweenLite.to($con.contestTxt, 1, {delay:1.5, alpha:1});
			TweenMax.to($con.contestTxt, 1, {
				delay:1.5,
				colorTransform:{exposure:1.1},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.contestTxt]
			});
		}
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
		
		private function pageTwoOut(e:MouseEvent):void
		{	resetKiosk();		}
		
		/**	키오스크 리셋 - 메인가기	*/
		private function resetKiosk(e:TimerEvent = null):void
		{
			destroy();
			if($model.joinCheck == "N")	$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_MAIN));
			else	$model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_POPUP));
		}
		/**	초기화	*/
		private function destroy():void
		{
			$model.userInform = null;
			$resetTimer.stop();
			$resetTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
			$resetTimer = null;
			$con.finishCon.btn.removeEventListener(MouseEvent.CLICK, resetKiosk);
		}
	}
}