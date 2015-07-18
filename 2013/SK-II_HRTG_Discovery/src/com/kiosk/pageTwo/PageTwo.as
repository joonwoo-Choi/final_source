package com.kiosk.pageTwo
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.kiosk.event.ModelEvent;
	import com.kiosk.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class PageTwo
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	메인으로 리셋 타이머	*/
		private var $resetTimer:Timer;
		/**	나쁜 부분 수	*/
		private var $badPointLength:int = 5;
		/**	이전 나쁜 부분 배열	*/
		private var $prevBadPointArr:Array;
		/**	현재 나쁜 부분 배열	*/
		private var $nowBadPointArr:Array;
		/**	나쁜 부분 검사	*/
		private var $badPointSearchArr:Array = ["피부결", "탄력", "표정라인", "피부톤", "광채"];
		/**	이전 나쁜 부분	*/
		private var $prevBadPoint:MovieClip;
		/**	현재 나쁜 부분	*/
		private var $nowBadPoint:MovieClip;
		/**	나쁜 부분 반짝임 타이머	*/
		private var $glowTimer:Timer;
		
		public function PageTwo(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_TWO, pageSetting);
			
			$prevBadPointArr = [$con.prevResult.bad0, $con.prevResult.bad1, $con.prevResult.bad2, $con.prevResult.bad3, $con.prevResult.bad4];
			$nowBadPointArr = [$con.nowResult.bad0, $con.nowResult.bad1, $con.nowResult.bad2, $con.nowResult.bad3, $con.nowResult.bad4];
		}
		
		private function pageSetting(e:Event):void
		{
			$model.kioskPageNum = 2;
			
			$con.visible = true;
			$con.alpha = 1;
			
			$resetTimer = new Timer(60000,1);
			$resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
			$resetTimer.start();
			
			$glowTimer = new Timer(5000);
			$glowTimer.addEventListener(TimerEvent.TIMER, badPointGlowHandler);
			$glowTimer.start();
			
			/**	이전 방문 날짜 셋팅	*/
			$con.dateTxt.text = $model.previousVisitDate[0] + "년 " + $model.previousVisitDate[1] + "월 " + $model.previousVisitDate[2] + "일 피부 상태와 비교";
			$con.dateTxt.autoSize = TextFieldAutoSize.LEFT;
			
			/**	유저 이름 셋팅	*/
			$con.userName.text = $model.userName;
			$con.userName.autoSize = TextFieldAutoSize.LEFT;
			$con.nameTxt.x = $con.userName.x + $con.userName.width + 10;
			
			/**	그래프 & 스코어 셋팅	*/
			$con.prevScoreGraph.scaleY = 0;
			$con.prevAgeGraph.scaleY = 0;
			$con.nowScoreGraph.scaleY = 0;
			$con.nowAgeGraph.scaleY = 0;
			
			$con.prevScore.score.text = "0";
			$con.nowScore.score.text = "0";
			$con.prevAge.score.text = "0";
			$con.nowAge.score.text = "0";
			$con.prevScore.score.autoSize = TextFieldAutoSize.LEFT;
			$con.nowScore.score.autoSize = TextFieldAutoSize.LEFT;
			$con.prevAge.score.autoSize = TextFieldAutoSize.LEFT;
			$con.nowAge.score.autoSize = TextFieldAutoSize.LEFT;
			
			for (var j:int = 0; j < $badPointLength; j++) 
			{
				var prevBad:MovieClip = $con.prevResult.getChildByName("bad" + j) as MovieClip;
				var nowBad:MovieClip = $con.nowResult.getChildByName("bad" + j) as MovieClip;
				prevBad.alpha = 0;
				nowBad.alpha = 0;
			}
			$con.prevResult.penta.alpha = 0;
			$con.nowResult.penta.alpha = 0;
			
			/**	오각형 이전 피부 나쁜 부분 셋팅	*/
			var i:int = 0;
			for (i = 0; i < $badPointLength; i++) 
			{
				if($badPointSearchArr[i] == $model.previousSkinTrouble)
				{
					$prevBadPointArr[i].over.alpha = 1;
					$prevBadPointArr[i].out.alpha = 0;
					$prevBadPoint = $prevBadPointArr[i].over;
				}
				else
				{
					$prevBadPointArr[i].over.alpha = 0;
					$prevBadPointArr[i].out.alpha = 1;
				}
			}
			/**	오각형 현재 피부 나쁜 부분 셋팅	*/
			for (i = 0; i < $badPointLength; i++) 
			{
				if($badPointSearchArr[i] == $model.skinTrouble)
				{
					$nowBadPointArr[i].over.alpha = 1;
					$nowBadPointArr[i].out.alpha = 0;
					$nowBadPoint = $nowBadPointArr[i].over;
					/**	샘플 텍스트 설정	*/
					$con.sampleTxt.gotoAndStop(i + 1);
					trace(i+1);
				}
				else
				{
					$nowBadPointArr[i].over.alpha = 0;
					$nowBadPointArr[i].out.alpha = 1;
				}
			}
			
			/**	결과 않좋은 부분 셋팅	*/
			var score:int = $model.previousSkinScore - $model.skinScore;
			var age:int = $model.previousSkinAge - $model.skinAge;
			
			var scoreTxt:String;
			var ageTxt:String;
			var finishTxt:String;
			
			if(score < 0) scoreTxt = "% 좋아졌으며, 피부나이는 ";
			else if(score == 0) scoreTxt = "동일하며, 피부나이는 ";
			else scoreTxt = "% 나빠졌으며, 피부나이는 ";
			
			if(age < 0)
			{
				ageTxt = "살 많아";
				finishTxt = "졌습니다.";
			}
			else if(age == 0) 
			{
				ageTxt = "동일";
				finishTxt = "합니다.";
			}
			else 
			{
				ageTxt = "살 줄었";
				finishTxt = "습니다.";
			}
			
			/**	점수 양수로 변환	*/
			if(score < 0) score = -score;
			if(age < 0) age = -age;
			
			if(age == 0 && score == 0) $con.resultTxt0.text = "피부 점수는 " + scoreTxt + ageTxt;
			else if(age == 0) $con.resultTxt0.text = "피부 점수는 " + score + scoreTxt + ageTxt;
			else if(score == 0) $con.resultTxt0.text = "피부 점수는 " + scoreTxt + age + ageTxt;
			else $con.resultTxt0.text = "피부 점수는 " + score + scoreTxt + age + ageTxt;
			$con.resultTxt0.autoSize = TextFieldAutoSize.LEFT;
			trace($con.resultTxt0.text);
			$con.resultTxt1.text = finishTxt;
			$con.resultTxt1.autoSize = TextFieldAutoSize.LEFT;
			$con.resultTxt1.x = $con.resultTxt0.x + $con.resultTxt0.width;
			
			$con.resultTxt2.text = $model.skinTrouble;
			$con.resultTxt2.autoSize = TextFieldAutoSize.LEFT;
			$con.badTxt.x = $con.resultTxt2.x + $con.resultTxt2.width;
			
			setTimeout(makeResetBtn, 3500);
			setTimeout(showResult, 500);
		}
		
		private function makeResetBtn():void
		{		$con.btn.addEventListener(MouseEvent.CLICK, pageTwoOut);		}
		
		private function showResult():void
		{
			TweenLite.to($con.prevResult.penta, 1, {alpha:1});
			TweenLite.to($con.nowResult.penta, 1, {alpha:1});
			TweenMax.to($con.prevResult.penta, 1, {colorTransform:{exposure:1.4}, reversed:true});
			TweenMax.to($con.nowResult.penta, 1, {colorTransform:{exposure:1.4}, reversed:true});
			
			var i:int = 0;
			for (i = 0; i < $badPointLength; i++) 
			{
				TweenLite.to($prevBadPointArr[i], 1, {delay:0.15*i, alpha:1});
				TweenLite.to($nowBadPointArr[i], 1, {delay:0.15*i, alpha:1});
			}
			
			/**	이전 그래프	*/
			TweenLite.to($con.prevScoreGraph, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:scoreUpdate});
			TweenLite.to($con.prevAgeGraph, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:ageUpdate});
			/**	현재 그래프	*/
			var scoreNum:Number = $model.skinScore / $model.previousSkinScore;
			var ageNum:Number = $model.previousSkinAge / $model.skinAge;
			if(scoreNum >= 2) scoreNum = 2;
			else if(scoreNum <= 0.25) scoreNum = 0.25;
			if(ageNum >= 2) ageNum = 2;
			else if(ageNum <= 0.25) ageNum = 0.25;
			TweenLite.to($con.nowScoreGraph, 3, {scaleY:scoreNum, ease:Cubic.easeOut});
			TweenLite.to($con.nowAgeGraph, 3, {scaleY:ageNum, ease:Cubic.easeOut});
		}
		/**	스코어 그래프	*/
		private function scoreUpdate():void
		{
			$con.prevScore.score.text = Math.ceil($model.previousSkinScore * $con.prevScoreGraph.scaleY);
			$con.prevScore.score.autoSize = TextFieldAutoSize.LEFT;
			$con.prevScore.txt.x = int($con.prevScore.score.x + $con.prevScore.score.width);
			
			$con.nowScore.score.text = Math.ceil($model.skinScore * $con.prevScoreGraph.scaleY);
			$con.nowScore.score.autoSize = TextFieldAutoSize.LEFT;
			$con.nowScore.txt.x = int($con.nowScore.score.x + $con.nowScore.score.width);
			
//			if($con.totalUserBar.height / $barHeight < 0.5) return;
//			$con.totalRank.y = 1100 - int(100 * ($con.totalUserBar.height / $barHeight) - 80);
		}
		/**	나이 그래프	*/
		private function ageUpdate():void
		{
			$con.prevAge.score.text = Math.ceil($model.previousSkinAge * $con.prevAgeGraph.scaleY);
			$con.prevAge.score.autoSize = TextFieldAutoSize.LEFT;
			$con.prevAge.txt.x = int($con.prevAge.score.x + $con.prevAge.score.width);
			
			$con.nowAge.score.text = Math.ceil($model.skinAge * $con.prevAgeGraph.scaleY);
			$con.nowAge.score.autoSize = TextFieldAutoSize.LEFT;
			$con.nowAge.txt.x = int($con.nowAge.score.x + $con.nowAge.score.width);
			
//			if($con.ageUserBar.height / $barHeight < 0.5) return;
//			$con.ageRank.y = 1100 - int(100 * ($con.ageUserBar.height / $barHeight) - 80);
		}
		
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	};
		
		private function badPointGlowHandler(e:TimerEvent):void
		{
			TweenMax.to($prevBadPoint, 1.3, {colorTransform:{exposure:1.5}, reversed:true});
			TweenMax.to($nowBadPoint, 1.3, {colorTransform:{exposure:1.5}, reversed:true});
		}
		
		private function pageTwoOut(e:MouseEvent):void
		{
			destroy();
			$model.dispatchEvent(new ModelEvent(ModelEvent.SEND_IMG));
			if($model.sampleCheck == "N")	$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_MAIN));
			else	$model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_POPUP));
		};
		
		/**	키오스크 리셋 - 메인가기	*/
		private function resetKiosk(e:TimerEvent):void
		{
			destroy();
			$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_MAIN));
		}
		/**	초기화	*/
		private function destroy():void
		{
			$model.userInform = null;
			if($resetTimer != null)
			{
				$resetTimer.stop();
				$resetTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
				$resetTimer = null;
			}
			$con.btn.removeEventListener(MouseEvent.CLICK, pageTwoOut);
			
			if($glowTimer != null)
			{
				$glowTimer.stop();
				$glowTimer.removeEventListener(TimerEvent.TIMER, badPointGlowHandler);
				$glowTimer = null;
			}
			if($prevBadPoint != null)
			{
				TweenMax.killTweensOf($prevBadPoint);
				TweenMax.to($prevBadPoint, 1.3, {colorTransform:{exposure:1}});
				$prevBadPoint = null;
				TweenMax.killTweensOf($nowBadPoint);
				TweenMax.to($nowBadPoint, 1.3, {colorTransform:{exposure:1}});
				$nowBadPoint = null;
			}
		}
	}
}