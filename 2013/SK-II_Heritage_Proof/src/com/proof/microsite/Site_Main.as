package com.proof.microsite
{
	
	import com.adqua.display.Resize;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class Site_Main
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $resize:Resize;
		
		private var $btnLength:int = 6;
		
		private var $areaArr:Array;
		
		private var $overArr:Array;
		
		private var $pointArr:Array;
		
		private var $rollingTimer:Timer;
		
		private var $activeNum:int;
		
		private var $sp:Sprite;
		
		private var $dot:dot;
		
		private var $isClick:Boolean = false;
		
		public function Site_Main(con:MovieClip)
		{
			TweenPlugin.activate([TintPlugin, AutoAlphaPlugin]);
			
			$con = con;
			
			$model = Model.getInstance();
			
			$resize = new Resize();
			
			$rollingTimer = new Timer(5000);
			$rollingTimer.addEventListener(TimerEvent.TIMER, rollingMenuHandler);
			
			/**	인트로에 따른 설정	*/
			if($model.isIntro == "true")
			{
				$sp = new Sprite();
				$con.dot.addChild($sp);
				$dot = new dot();
			}
			
			resizeHandler();
			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var line:MovieClip = $con.content.getChildByName("line" + i) as MovieClip;
				line.mcMask.scaleX = 0;
			}
			$con.alpha = 0;
			TweenLite.to($con, 1, {alpha:1, ease:Cubic.easeOut, onComplete:startMotion});
			
			for (var j:int = 0; j < 4; j++) 
			{
				var title:MovieClip = $con.content.getChildByName("title" + j) as MovieClip;
				TweenLite.to(title, 1, {delay:0.5 + j/4, alpha:1});
				TweenMax.to(title, 1, {
					delay:0.2 * j,
					y:title.y + 4,
					blurFilter:new BlurFilter(4,4),
					reversed:true,
					onComplete:finishBlur,
					onCompleteParams:[title]
				});
			};
		}
		/**	시작 모션 설정	*/
		private function startMotion():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var point:MovieClip = $con.content.getChildByName("point" + i) as MovieClip;
				TweenLite.to(point, 1, {delay:0.2 * i, alpha:1});
				TweenMax.to(point, 1, {
					delay:0.2 * i,
					y:point.y - 3,
					blurFilter:new BlurFilter(2,2),
					reversed:true,
					onComplete:finishBlur,
					onCompleteParams:[point]
				});
				
				var line:MovieClip = $con.content.getChildByName("line" + i) as MovieClip;
				TweenLite.to(line.mcMask, 0.75, {delay:0.2 * i, scaleX:1, onComplete:showDefaultTxt, onCompleteParams:[i],  ease:Expo.easeOut});
			}
			
			setTimeout(makeButton, 2100);
		}
		
		private function showDefaultTxt(num:int):void
		{
			var btn:MovieClip = $con.content.getChildByName("btn" + num) as MovieClip;
			TweenLite.to(btn, 0.6, {alpha:1});
			TweenMax.to(btn, 0.6, {
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onComplete:finishBlur,
				onCompleteParams:[btn]
			});
		}
		
		private function rollingMenuHandler(event:TimerEvent):void
		{
			if($activeNum < $btnLength - 1) $activeNum++;
			else $activeNum = 0;
			
			activeMenu($activeNum);
		}
		
		private function resizeHandler(e:Event = null):void
		{
			/**	인트로에 따른 설정	*/
			if($model.isIntro == true)
			{
				$sp.graphics.clear();
				$sp.graphics.beginBitmapFill($dot);
				$sp.graphics.drawRect(0, 0, $con.stage.stageWidth, $con.stage.stageHeight);
				$sp.graphics.endFill();
			}
			
			$resize.arrangeX($con.content, 1024);
			$resize.arrangeY($con.content, 920);
		}
		
		private function makeButton():void
		{
			$areaArr = [];
			$overArr = [];
			$pointArr = [];
			
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $con.content.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, menuPopupHandler);
				
				$areaArr.push($con.content.getChildByName("area" + i));
				$overArr.push($con.content.getChildByName("over" + i));
				$overArr[i].no = i;
				ButtonUtil.makeButton($overArr[i], popupHandler);
				$overArr[i].mouseChildren = true;
				
				$overArr[i].btn.no = i;
				ButtonUtil.makeButton($overArr[i].btn, popupBtnHandler);
				
				var point:MovieClip = $con.content.getChildByName("point" + i) as MovieClip;
				$pointArr.push(point);
			}
			
			/**	천개 어워드 버튼	*/
//			$con.content.over5.buttonMode = true;
//			$con.content.over5.addEventListener(MouseEvent.CLICK, awardHandler);
//			ButtonUtil.makeButton($con.content.over5.btn, awardBtnHandler);
//			TweenLite.to($con.content.area5, 1, {alpha:1, ease:Expo.easeOut});
//			TweenLite.to($con.content.area5, 1, {scaleX:0.85, scaleY:0.85, reversed:true, ease:Elastic.easeIn});
//			
//			TweenLite.to($con.content.over5, 0.6, {autoAlpha:1});
//			TweenMax.to($con.content.over5, 0.6, {
//				colorTransform:{exposure:1.2},
//				blurFilter:new BlurFilter(4,4),
//				reversed:true,
//				onReverseComplete:finishBlur,
//				onReverseCompleteParams:[$con.content.over5]
//			});
//			$con.content.point5.gotoAndPlay(2);
			
			$rollingTimer.start();
			activeMenu(5);
		}
		/**	천개 어워드 핸들러	*/
//		private function awardHandler(e:MouseEvent):void
//		{			JavaScriptUtil.call("pageOpen", 6);		}
//		/**	천개 어워드 버튼 핸들러	*/
//		private function awardBtnHandler(e:MouseEvent):void
//		{
//			switch (e.type)
//			{
//				case MouseEvent.MOUSE_OVER :
//					TweenLite.to(e.target, 0.5,{tint:0x383838});
//					break;
//				case MouseEvent.MOUSE_OUT :
//					TweenLite.to(e.target, 0.5,{tint:null});
//					break;
//			}
//		}
		/**	팝업 보이기	*/
		private function menuPopupHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					$rollingTimer.stop();
					if($activeNum == target.no) break;
					$activeNum = target.no;
					activeMenu($activeNum);
					trace("메뉴 팝업: " + target.no);
					break;
				case MouseEvent.MOUSE_OUT :
					$rollingTimer.start();
					break;
				case MouseEvent.CLICK :
					break;
			}
		}
		/**	팝업 원 마우스 핸들러	*/
		private function popupHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					$rollingTimer.stop();
					break;
				case MouseEvent.MOUSE_OUT : 
					$rollingTimer.start();
					break;
				case MouseEvent.CLICK : 
					if($isClick == true)
					{
						$rollingTimer.start();
						$pointArr[target.no].gotoAndStop(1);
						JavaScriptUtil.call("pageOpen", target.no + 1);
						trace($isClick);
					}
					break;
			}
			$rollingTimer.start();
		}
		/**	팝업 원 바로가기 버튼	*/
		private function popupBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target, 0.5,{tint:0x383838});
					$rollingTimer.stop();
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target, 0.5,{tint:null});
					$rollingTimer.start();
					break;
				case MouseEvent.CLICK :
//					$rollingTimer.start();
//					JavaScriptUtil.call("pageOpen", target.no + 1);
					break;
			}
		}
		
		private function activeMenu(num:int):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				if(num == i)
				{
					$isClick = false;
					TweenLite.to($areaArr[i], 1, {alpha:1, ease:Expo.easeOut, onComplete:clickTrue});
					TweenLite.to($areaArr[i], 1, {scaleX:0.85, scaleY:0.85, reversed:true, ease:Elastic.easeIn});
					
					TweenLite.killTweensOf($overArr[i]);
					TweenMax.to($overArr[i], 0, {colorTransform:{exposure:1}});
					TweenLite.to($overArr[i], 0.6, {autoAlpha:1});
					TweenMax.to($overArr[i], 0.6, {
						colorTransform:{exposure:1.2},
						blurFilter:new BlurFilter(4,4),
						reversed:true,
						onReverseComplete:finishBlur,
						onReverseCompleteParams:[$overArr[i]]
					});
					
					$pointArr[i].gotoAndPlay(2);
				}
				else
				{
					TweenLite.to($areaArr[i], 1, {alpha:0, ease:Expo.easeOut});
					
					TweenLite.killTweensOf($overArr[i]);
					TweenLite.to($overArr[i], 0.6, {autoAlpha:0});
					TweenMax.to($overArr[i], 0.6, {
						blurFilter:new BlurFilter(4,4),
						onComplete:finishBlur,
						onCompleteParams:[$overArr[i]]
					});
					
					$pointArr[i].gotoAndStop(1);
				}
			}
		}
		/**	팝업 원 클릭 활성화	*/
		private function clickTrue():void
		{	$isClick = true;		}
		
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
	}
}