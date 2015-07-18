package com.kiosk.pageOne
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.kiosk.event.ModelEvent;
	import com.kiosk.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Result
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	텍스트 드랍쉐도우 필터	*/
		private var $dsFilter:BitmapFilter = new DropShadowFilter(1, 135, 0x000000, 0.3, 2, 2, 1, 1, true);
		/**	상태 나쁜 부분	*/
		private var $badPointLength:int = 5;
		private var $badPointArr:Array;
		private var $badPointSearchArr:Array = ["피부결", "탄력", "표정라인", "피부톤", "광채"];
		private var $badPointNum:int = 2;
		/**	bar 기준 높이	*/
		private var $barHeight:int = 121;
		/**	결과 텍스트 가로 정렬 기준	*/
		private var $centerNum:int = 315;
		/**	나쁜 부분	*/
		private var $MCbadPoint:MovieClip;
		/**	나쁜 부분 반짝임 타이머	*/
		private var $glowTimer:Timer;
		
		public function Result(con:MovieClip)
		{
			$con = con;
			
			$model =Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_ONE, pageSetting);
			$model.addEventListener(ModelEvent.KIOSK_PAGE_TWO, removePageOne);
			$model.addEventListener(ModelEvent.KIOSK_MAIN, removePageOne);
			
			
			$badPointArr = [$con.bad0, $con.bad1, $con.bad2, $con.bad3, $con.bad4];
			
			/**	랭킹 텍스트 드랍쉐도우 적용	*/
			$con.skinScore.filters = [$dsFilter];
			$con.skinAge.filters = [$dsFilter];
		}
		
		private  function pageSetting(e:Event):void
		{
			$model.kioskPageNum = 1;
			
			$con.visible = true;
			$con.alpha = 1;
			
			for (var j:int = 0; j < $badPointLength; j++) 
			{
				var MCbad:MovieClip = $con.getChildByName("bad" + j) as MovieClip;
				MCbad.alpha = 0;
			}
			$con.penta.alpha = 0;
			$con.result0_up.alpha = 0;
			$con.result0_down.alpha = 0;
			
			/**	유저 이름 셋팅	*/
			$con.userName0.text = $model.userName;
			$con.userName0.autoSize = TextFieldAutoSize.LEFT;
			$con.nameRightTxt.x = $con.userName0.x + $con.userName0.width + 12;
			
			$con.result0_up.userName.text = $model.userName;
			$con.result0_up.userName.autoSize = TextFieldAutoSize.LEFT;
			$con.result0_up.txt.x = $con.result0_up.userName.x + $con.result0_up.userName.width;
			$con.result0_up.x = $centerNum - int($con.result0_up.width / 2);
			
			$con.result0_down.badPoint.text = $model.skinTrouble;
			$con.result0_down.badPoint.autoSize = TextFieldAutoSize.LEFT;
			$con.result0_down.txt.x = $con.result0_down.badPoint.x + $con.result0_down.badPoint.width;
			$con.result0_down.x = $centerNum - int($con.result0_down.width / 2);
			
			/**	유저 피부 점수 & 나이 초기화	*/
			$con.skinScore.text = "";
			$con.skinAge.text = "";
			
			$con.ageAvgTxt.text = "※" + $model.userName + "님과 같은 " + $model.age + "세의 평균 피부 상태입니다."
			$con.ageAvgTxt.autoSize = TextFieldAutoSize.CENTER;
			
			$con.skinScore_avg.text = $model.avgSkinScore;
			$con.skinAge_avg.text = $model.avgSkinAge;
			
			/**	오각형 피부 나쁜 부분 셋팅	*/
			for (var i:int = 0; i < $badPointLength; i++) 
			{
				if($badPointSearchArr[i] == $model.skinTrouble)
				{
					$badPointArr[i].over.alpha = 1;
					$badPointArr[i].out.alpha = 0;
					$MCbadPoint = $badPointArr[i].over;
					trace("안 좋은 부분: " + $model.skinTrouble);
				}
				else
				{
					$badPointArr[i].over.alpha = 0;
					$badPointArr[i].out.alpha = 1;
				}
			}
			
			$glowTimer = new Timer(5000);
			$glowTimer.addEventListener(TimerEvent.TIMER, badPointGlowHandler);
			$glowTimer.start();
			
			setTimeout(showResult, 500);
		}
		
		private function showResult():void
		{
			/**	상단 점수 & 나이	*/
			var mc:MovieClip = new MovieClip();
			mc.x = 0;
			TweenLite.to(mc, 3, {x:100, onUpdate:scoreUpdate, onUpdateParams:[mc], ease:Cubic.easeOut});
			
			TweenLite.to($con.penta, 1, {alpha:1});
			TweenMax.to($con.penta, 1, {colorTransform:{exposure:1.4}, reversed:true});
			for (var j:int = 0; j < $badPointLength; j++) 
			{
				var MCbad:MovieClip = $con.getChildByName("bad" + j) as MovieClip;
				TweenLite.to(MCbad, 1, {delay:0.15*j, alpha:1});
			}
			TweenLite.to($con.result0_up, 1, {delay:0.75, alpha:1});
			TweenLite.to($con.result0_down, 1, {delay:1, alpha:1});
			TweenMax.to($con.result0_up, 1, {delay:0.75, y:$con.result0_up.y + 3, reversed:true});
			TweenMax.to($con.result0_down, 1, {delay:1, y:$con.result0_down.y + 3, reversed:true});
		}
		/**	상단 피부점수 & 나이	*/
		private function scoreUpdate(mc:MovieClip):void
		{
			var num:Number = mc.x;
			$con.skinScore.text = int($model.skinScore * (num / 100));
			$con.skinAge.text = int($model.skinAge * (num / 100));
		}
		
		private function badPointGlowHandler(e:TimerEvent):void
		{
			if($model.kioskPageNum != 1)
			{
				removePageOne();
				return;
			}
			TweenMax.to($MCbadPoint, 1.3, {
				colorTransform:{exposure:1.5},
				reversed:true});
		}
		/**	초기화	*/
		private function removePageOne(e:Event = null):void
		{
			if($glowTimer != null)
			{
				$glowTimer.stop();
				$glowTimer.removeEventListener(TimerEvent.TIMER, badPointGlowHandler);
				$glowTimer = null;
			}
			if($MCbadPoint != null)
			{
				TweenMax.killTweensOf($MCbadPoint);
				TweenMax.to($MCbadPoint, 1.3, {colorTransform:{exposure:1}});
				$MCbadPoint = null;
			}
		}
	}
}