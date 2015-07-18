package com.proof.kiosk.pageOne
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Product
	{
		TweenPlugin.activate([AutoAlphaPlugin]);
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	결과 텍스트 가로 정렬 기준	*/
		private var $centerNum:int = 539;
		/**	안 좋은 부분	*/
		private var $badPointLength:int = 5;
		private var $badPointSearchArr:Array = ["피부결", "탄력", "표정라인", "피부톤", "광채"];
		/**	메인으로 리셋 타이머	*/
		private var $resetTimer:Timer;
		
		public function Product(con:MovieClip)
		{
			$con = con;
			
			$model =Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_ONE, pageSetting);
		}
		
		private  function pageSetting(e:Event):void
		{
			$resetTimer = new Timer(40000,1);
			$resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
			$resetTimer.start();
			
			$con.result1_up.userName.text = $model.userName;
			$con.result1_up.userName.autoSize = TextFieldAutoSize.LEFT;
			$con.result1_up.txt.x = $con.result1_up.userName.x + $con.result1_up.userName.width;
			$con.result1_up.x = $centerNum - int($con.result1_up.width / 2);
			$con.comma0.x = $con.result1_up.x - $con.comma0.width - 20;
			
			$con.result1_down.badPoint.text = $model.skinTrouble;
			$con.result1_down.badPoint.autoSize = TextFieldAutoSize.LEFT;
			$con.result1_down.txt.x = $con.result1_down.badPoint.x + $con.result1_down.badPoint.width;
			$con.result1_down.x = $centerNum - int($con.result1_down.width / 2);
			$con.comma1.x = $con.result1_down.x + $con.result1_down.width + 20;
			
			$con.product.alpha = 0;
			for (var i:int = 0; i < $badPointLength; i++) 
			{
				if($badPointSearchArr[i] == $model.skinTrouble)
				{
					$con.result_txt.gotoAndStop(i + 1);
					if($model.gender == "F" )
					{	$con.product.gotoAndStop(i + 1);	}
					else if($model.gender == "M")
					{	$con.product.gotoAndStop(i + 6);	}
				}
			}
			trace("상품 번호: " + $con.product.currentFrame);
			
			setTimeout(makeNextBtn, 2500);
			setTimeout(showResult, 500);
		}
		
		private function makeNextBtn():void
		{	$con.btn.addEventListener(MouseEvent.CLICK, showPageTwo);	}
		
		private function showResult():void
		{
			TweenLite.to($con.product, 1, {delay:0.5, alpha:1});
			TweenMax.to($con.product, 1, {
				delay:0.5,
				colorTransform:{exposure:1.1},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.product]
			});
		}
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
		
		/**	키오스크 리셋 - 메인가기	*/
		private function resetKiosk(e:TimerEvent):void
		{
			destroy();
			$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_MAIN));
		}
		/**	초기환	*/
		private function destroy():void
		{
			$resetTimer.stop();
			$resetTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetKiosk);
			$resetTimer = null;
			$con.btn.removeEventListener(MouseEvent.CLICK, showPageTwo);
		}
		
		private function showPageTwo(e:MouseEvent):void
		{
			destroy();
			TweenLite.to($con, 1, {autoAlpha:0, ease:Cubic.easeOut});
			$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_PAGE_TWO));
			
			trace("페이지2 보이기");
		}
	}
}