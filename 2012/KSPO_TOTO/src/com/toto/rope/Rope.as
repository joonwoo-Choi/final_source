package com.toto.rope
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.toto.model.ToToEvent;
	import com.toto.model.ToToModel;
	import com.utils.ButtonUtil;
	
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class Rope extends Sprite
	{
		
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:ToToModel;
		/**	버튼 수	*/
		private var $btnLength:int = 9;
		/**	선택한 공	*/
		private var $targetBall:MovieClip;
		/**	공 드래그 영역	*/
		private var $dragArea:Rectangle;
		/**	선 시작점 배열	*/
		private var $pointArr:Array;
		/**	공 배열	*/
		private var $ballArr:Array;
		/** 공 위치 배열	*/
		private var $ballPointArr:Array;
		/**	넣은 공 */
		private var $ballNum:int;
		/**	선 Shape	*/
		private var $lineShape:Sprite;
		/**	볼 프레임 라벨	*/
		private var $labelArr:Array = ["ball0", "ball1", "ball2", "ball3", "ball4"];
		/**	종료체크 타임아웃	*/
		private var $completeChk:uint;
		/**	종료 최대 수	*/
		private var $endNum:int = 5
		
		public function Rope(con:MovieClip)
		{
			$con = con;
			
			$con.ballCon.planeMC.visible = false;
			
			$model = ToToModel.getInstance();
			
			$lineShape = new Sprite();
			$con.shapeCon.addChild($lineShape);
			
			/**	포인트 좌표 볼 배열 저장	*/
			$pointArr = [];
			$ballArr = [];
			$ballPointArr = [];
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var point:MovieClip = $con.ballCon.getChildByName("point" + i) as MovieClip;
				$pointArr.push(point);
				
				var ball:MovieClip = $con.ballCon.getChildByName("ball" + i) as MovieClip;
				ball.no = i;
				ball.hit = "false";
				$ballArr.push(ball);
				
				var ballPoint:Array = [ball.x, ball.y];
				$ballPointArr.push(ballPoint);
				
			}
			
			setTimeout(makeStartButton, 6500);
		}
		
		private function drawLine():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				$lineShape.graphics.lineStyle(2, 0xffffff, 0.07);
				$lineShape.graphics.moveTo($pointArr[i].x, $pointArr[i].y);
				$lineShape.graphics.lineTo($ballArr[i].x, $ballArr[i].y);
			}
		}
		
		private function makeStartButton():void
		{
			showBalls();
			
			ButtonUtil.makeButton($con.btnStart, makeButton);
			ballUpdateHandler();
			addEventListener(Event.ENTER_FRAME, ballUpdateHandler);
		}
		
		private function showBalls():void
		{
			$con.motion.balls.alpha = 0;
			
			$con.motion.graph.alpha = 0;
			
			for (var j:int = 0; j < $btnLength; j++) 
			{	
				$ballArr[j].alpha = 1;	
			}
			$con.ballBG.alpha = 1;
			$con.graph.alpha = 1;
			
		}
		
		private function makeButton(e:MouseEvent):void
		{
			switch (e.type) 
			{
				case MouseEvent.MOUSE_OVER: 
					TweenLite.to($con.btnOver, 0.5, {alpha:1, ease:Cubic.easeOut});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenLite.to($con.btnOver, 0.5, {alpha:0, ease:Cubic.easeOut});
					break;
				case MouseEvent.CLICK: 
					TweenMax.to($con.btnOver, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($con.btnStart, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($con.motion.heartStart, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:addBallDownEvent});
					break;
			}
		}
		
		private function addBallDownEvent():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var ball:MovieClip = $con.ballCon.getChildByName("ball" + i) as MovieClip;
				ball.buttonMode = true;
				ball.addEventListener(MouseEvent.MOUSE_DOWN, ballDownHandler);
			}
			trace("$pointArr: " + $pointArr + "\n" + "$ballArr: " + $ballArr + "\n" + "$ballPointArr: " + $ballPointArr);
		}
		
		private function ballUpdateHandler(e:Event=null):void
		{
			$lineShape.graphics.clear();
			for (var i:int = 0; i < $btnLength; i++) 
			{
				$lineShape.graphics.lineStyle(2, 0xffffff, 0.4);
				$lineShape.filters = [new DropShadowFilter(12, 45, 0x0, 0.6, 20, 20)];
				
				if($ballArr[i].hit == "true") $lineShape.graphics.lineStyle(2, 0xffffff, 0);
				$lineShape.graphics.moveTo($pointArr[i].x, $pointArr[i].y);
				$lineShape.graphics.lineTo($ballArr[i].x, $ballArr[i].y);
			}
		}
		/**	공 마우스 다운	*/
		private function ballDownHandler(e:MouseEvent):void
		{
			$targetBall = e.currentTarget as MovieClip;
			TweenLite.killTweensOf($targetBall);
			$dragArea = new Rectangle($targetBall.width/2, $targetBall.height/2, 
										$con.stage.stageWidth - $targetBall.width, 
										$con.stage.stageHeight - $targetBall.height);
			$targetBall.startDrag(false, $dragArea);
			$targetBall.stage.addEventListener(MouseEvent.MOUSE_UP, ballUpHandler);
		}
		/**	이벤트 제거	*/
		private function ballUpHandler(e:MouseEvent):void
		{
			$targetBall.stopDrag();
			$targetBall.stage.removeEventListener(MouseEvent.MOUSE_UP, ballUpHandler);
			ballLocationCheck($targetBall);
		}
		/**	공 위치 체크	*/
		private function ballLocationCheck(target:MovieClip):void
		{
			if(target.hitTestObject($con.area))
			{
				target.removeEventListener(MouseEvent.MOUSE_DOWN, ballDownHandler);
				target.hit = "true";
				
				TweenMax.killTweensOf($con.motion.heart);
				TweenMax.to($con.motion.heart, 2, {frameLabel:$labelArr[$ballNum]});
				$ballNum++;
				
				TweenMax.to(target, 0.6, {scaleX:1.1, scaleY:1.1,
										autoAlpha:0,
										colorTransform:{exposure:1.5},
										blurFilter:new BlurFilter(20,20),
										onComplete:finishBlur,
										onCompleteParams:[target]
										});
				
				clearTimeout($completeChk);
				$completeChk = setTimeout(completeChk, 1000);
				graphUpdate();
			}
			else
			{
				TweenLite.to(target, 1, {x:$ballPointArr[target.no][0], 
											y:$ballPointArr[target.no][1], 
											ease:Elastic.easeOut});
			}
		}
		/**	블러 트윈 종료	*/
		private function finishBlur($mc:MovieClip):void
		{	$mc.filters = null;	}
		
		private function graphUpdate():void
		{
			TweenLite.to($con.graph.marker, 0.5, {y:15 + (190 - 190*($ballNum / $endNum)), ease:Cubic.easeOut});
			TweenLite.to($con.graph.bar, 0.5, {y:15 + (190 - 190*($ballNum / $endNum)), ease:Cubic.easeOut});
			if($ballNum == $endNum)
			{	
				for (var i:int = 0; i < $btnLength; i++) 
				{
					var ball:MovieClip = $con.ballCon.getChildByName("ball" + i) as MovieClip;
					ball.buttonMode = false;
					ball.removeEventListener(MouseEvent.MOUSE_DOWN, ballDownHandler);
				}
			}
		}
		
		/**	종료 체크	*/
		private function completeChk():void
		{
			if($ballNum == $endNum)
			{	
				$model.dispatchEvent(new ToToEvent(ToToEvent.COMPLETE_POPUP));
			}
		}
	}
}