package day.day2
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.ascb.drawing.Pen;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day2_1 extends AbstractMain
	{
		
		private var $main:AssetDay2_1;
		
		private var $isComplete:Boolean = false;
		
//		private var $skipTimer:Timer;
		
		private var $mouseY:int;
		/**	최초 실행 체크	*/
		private var $resetCheck:Boolean = true;
		/**	펜 클래스	*/
		private var $pen:Pen;
		/**	게이지바 푸른 BG	*/
		private var $blueBG:Pen;
		/**	스윙 각도	*/
		private var $degrees:Number;
		/**	퍼센트 텍스트 배열	*/
		private var $txtArr:Array;
		/**	골프 샷 횟수	*/
		private var $shotCnt:int;
		
		public function Day2_1()
		{
			super();
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.addEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			$main = new AssetDay2_1();
			this.addChild($main);
			
			/**	게이지바 마스크	*/
			$pen = new Pen($main.dragBar.maskCon.graphics);
			/**	그래프 바 마스크	*/
			$blueBG = new Pen($main.dragBar.blueBGMaskCon.graphics);
			$blueBG.beginFill(0x000000, 1);
			$blueBG.lineStyle(0, 0, 0);
			$blueBG.drawArc(0, 0, 150, 17, 216, true);
			
			if(_model.xmlData==null){
				/**	테스트위한 XML 로드	*/
				var urlLdr:URLLoader = new URLLoader;
				if(SecurityUtil.isWeb()==true){
					urlLdr.load(new URLRequest(_model.urlDefaultWeb + "xml/movie.xml"));
				}else{
					urlLdr.load(new URLRequest(_model.urlDefault + "xml/movie_d.xml"));
				}
				urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
			}else{
				makeBtn();
			}
			
			_model.addEventListener(PEventCommon.RETRY_GOLF, retryGolf);
		}
		
		/**	인터랙션 정지 	*/
		protected function pauseInteraction(e:Event):void
		{
			$main.mov.stop();
		}
		/**	인터랙션 재실행	*/
		protected function resumeInteraction(e:Event):void
		{
			$main.mov.play();
		}
		
		/**	실패시 다시 시도	*/
		protected function retryGolf(e:Event):void
		{
			trace("retry Golf **** ");
			makeBtn();
			$resetCheck = true;
			frameChange();
			TweenLite.to($main, 0.5, {autoAlpha:1});
//			TweenLite.to($main.btnSkip, 0.5, {delay:0.5, autoAlpha:1});
			skipOn();
		}
		
		//스킵온
		private function skipOn(evt:PEventCommon = null):void
		{
			trace("스킵온   _model.activeMenu  : ", _model.activeMenu)
			TweenLite.to($main.btnSkip, .5, {autoAlpha:1,frame:$main.btnSkip.totalFrames-1})
		}
		
		private function skipOff(evt:PEventCommon=null):void
		{
			TweenLite.to($main.btnSkip, .5, {frame:1, onComplete:skipComplete});
		}
		
		private function skipComplete(evt:Event = null):void
		{
			skipInteraction();
			trace("스킵아웃");
			
			$main.btnSkip.stop();
			$main.btnSkip.visible = false;
			$main.btnSkip.alpha = 0;
			TweenLite.killTweensOf($main.btnSkip);
			_model.removeEventListener(PEventCommon.SKIP_OPEN_ON,skipOn);
		}
		
		/**	스킵 타이머 - 인터랙션 종료	*/
		private function skipInteraction(e:TimerEvent = null):void
		{
			$isComplete = true;
			removeEvent();
//			setTimeout(removeMain,500);
			_controler.changeMovie([3,1,3]);
		}
		
		/**	XML로드 완료 모델에 저장	*/
		protected function xmlLoadComplete(e:Event):void
		{
			_model.xmlData = XML(e.target.data);
			makeBtn();
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			/**	빨리감기 버튼	*/
			ButtonUtil.makeButton($main.dragBar.marker, btnFFHandler);
			
			/**	스킵 버튼	*/
			ButtonUtil.makeButton($main.btnSkip, btnSkipHandler);
			
			/**	퍼센트 텍스트 배열	*/
			$txtArr = [];
			for (var i:int = 0; i < 3; i++) 
			{
				var txt:MovieClip = $main.dragBar.getChildByName("txt" + i) as MovieClip;
				$txtArr.push(txt);
			}
			frameChange();
		}
		
		/**	영상 빨리 감기	*/
		private function btnFFHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					e.target.gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					e.target.gotoAndStop(1);
					break;
				case MouseEvent.MOUSE_DOWN :
					frameChange();
					
					$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, frameChange);
					$main.stage.addEventListener(MouseEvent.MOUSE_UP, setResult);
					break;
			}
		}
		
		private function frameChange(e:MouseEvent = null):void
		{
			/**	마스크 호 중심과 마우스 포인트 각도 계산	*/
			var radians:Number;
			if($resetCheck)
			{
				$resetCheck = false;
				radians = Math.atan2((360 - $main.dragBar.maskCon.y), (223 - $main.dragBar.maskCon.x));
			}
			else
			{
				radians = Math.atan2(($main.dragBar.mouseY - $main.dragBar.maskCon.y), ($main.dragBar.mouseX - $main.dragBar.maskCon.x));
			}
			$degrees = Math.round(radians*180/Math.PI);
			/**	180도가 넘어가면 마이너스 값으로 바뀜	*/
			if($degrees < 0) $degrees = $degrees + 360;
			/**	최소 최대각도 범위	*/
			if($degrees >= 270) $degrees = 270;
			else if($degrees <= 90)$degrees = 90;
			
			/**	그래프 바 마스크	*/
			$pen.clear();
			$pen.beginFill(0xf943ff, 1);
			$pen.lineStyle(0, 0, 0);
			$pen.drawArc(0, 0, 150, $degrees, 0, true);
			
			/**	마커 위치	*/
			var yNum:int;
			var xNum:int;
			if($degrees <= 180)
			{
				xNum = _model.markerPoint[0] + 223 + (($degrees - 90) / 90) * 10;
				yNum = _model.markerPoint[1] + 210 + ((($degrees - 90) / 90) * 15) - 15;
			}
			else if($degrees > 180)
			{
				xNum = _model.markerPoint[0] + 223 - (($degrees - 180) / 90) * 10 + 10;
				yNum = _model.markerPoint[1] + 195+ ((($degrees - 180) / 90) * 15) + 15;
			}
			$main.dragBar.marker.rotation = $degrees + 90;
			$main.dragBar.marker.x = xNum;
			$main.dragBar.marker.y = yNum;
			
			/**	퍼센트 텍스트 반짝임	*/
			var percent:Number = ($degrees - 90) / 180;
			var txtNum:int;
			if(percent < 0.25) txtNum = 0;
			else if(percent >= 0.25 && percent < 0.75) txtNum = 1;
			else if(percent >= 0.75 && percent <= 1) txtNum = 2;
			for (var i:int = 0; i < 3; i++) 
			{
				if(i == txtNum && $txtArr[i].currentFrame == 1) $txtArr[i].gotoAndPlay(2);
				else if(i != txtNum) $txtArr[i].gotoAndStop(1);
			}
//			trace("마커 좌표: " + $main.dragBar.stage.mouseX, $main.dragBar.stage.mouseY);
		}
		
		private function setResult(e:MouseEvent):void
		{
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameChange);
			$main.stage.removeEventListener(MouseEvent.MOUSE_UP, setResult);
			
			/**	시도 횟수가 3회이면 인터랙션 종료	*/
			$shotCnt++;
			if($shotCnt == 3) $isComplete = true;
			trace("$shotCnt ::::::::::::::::::::::::::  " ,$shotCnt)
			/**	게이지에 따른 영상 출력	*/
			var percent:Number = ($degrees - 90) / 180;
			var videoNum:Array = [];
//			trace("게이지: " + percent);
			
			if(percent < 0.7)
			{
				if($shotCnt == 3) {
					$isComplete = true;
					videoNum = [3,1,4];
				}else{
					videoNum = [3,1,0];
				}
				trace("실패");
			}
			else if(percent >= 0.7 && percent < 0.8)
			{
				videoNum = [3,1,1];
				$isComplete = true;
				trace("홀인원");
			}
			else if(percent >= 0.8)
			{
				if($shotCnt == 3) {
					$isComplete = true;
					videoNum = [3,1,5];
				}else {
					videoNum = [3,1,2];
				}
				trace("롱롱~ 오버");
			}
			
			showResultMovie(videoNum);
		}
		
		/**	결과 영상 보여주기	*/
		private function showResultMovie(num:Array):void
		{
			removeEvent();
//			setTimeout(removeMain,500);
			_controler.changeMovie(num);
		}
		
		private function removeMain(e:Event):void
		{
//			$main.visible = false;
//			$main.alpha = 0;
//			for (var i:int = 0; i < 3; i++) $txtArr[i].gotoAndStop(1);
//			/**	홀인원 성공시 인터랙션 제거	*/
//			if($isComplete == true)
//			{
//				_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
//				destroy();
//			}
			
			TweenLite.to($main, 0, {delay:0.5, autoAlpha:0, onComplete:callRemoveInteraction});
		}
		private function callRemoveInteraction():void
		{
			for (var i:int = 0; i < 3; i++) $txtArr[i].gotoAndStop(1);
			/**	홀인원 성공시 인터랙션 제거	*/
			if($isComplete == true)
			{
				_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
				destroy();
			}
		}
		
		/**	다음 코스 넘어가기	*/
		private function btnSkipHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					target["skipMc"].gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target["skipMc"].gotoAndStop(1);
					break;
				case MouseEvent.MOUSE_DOWN :
					skipOff();
//					$isComplete = true;
//					removeEvent();
//					setTimeout(removeMain,500);
//					_controler.changeMovie([3,1,3]);
					break;
			}
		}
		
		/**	이벤트 제거	*/
		private function removeEvent(e:Event=null):void
		{
			ButtonUtil.removeButton($main.dragBar.marker, btnFFHandler);
			
			ButtonUtil.removeButton($main.btnSkip, btnSkipHandler);
			
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameChange);
			$main.stage.removeEventListener(MouseEvent.MOUSE_UP, setResult);
		}
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			trace("::::::::::::: 클럽 인트라무로스 인터랙션 종료 :::::::::::::");
			_model.removeEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.removeEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			_model.removeEventListener(PEventCommon.RETRY_GOLF, retryGolf);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			$pen.clear();
			$pen = null;
			$blueBG.clear();
			$blueBG = null;
			
			$txtArr = null;
			
			$isComplete = false;
			
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
	}
}