package day.day1
{
	
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import orpheus.movieclip.TestButton;
	import orpheus.system.SecurityUtil;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day1_3 extends AbstractMain
	{
		
		private var $main:AssetDay1_3;
		
		private var $defaultPath:String;
		
		private var $choiceBtnLength:int = 2;
		
		private var $btnChoice:Array = [];
		
		private var $swf:Loader;
		
		private var $swfArr:Array = [];
		
		private var $frameRate:int = 1;
		
//		private var $skipTimer:Timer;
		
		private var $isDown:Boolean = false;
		/**	마지막 영상 플레이 할지 말지 체크	*/
		private var $finishChk:Boolean = false;
		/**	처음 영상 방향	*/
		private var $direction:String;
		
		public function Day1_3()
		{
			super();
			TweenPlugin.activate([TintPlugin,AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb()) $defaultPath = "http://cdn.funtrip2manila.co.kr/www/";
			else $defaultPath = "";
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.addEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			
			
			$main = new AssetDay1_3();
			this.addChild($main);
			
			$main.btnFF.alpha = 0;
			$main.btnFF.visible = false;
			$main.btnFF.txt.scaleX = $main.btnFF.txt.scaleY = 0; 
			
			//빨리감기
//			$main.stage.addEventListener(KeyboardEvent.KEY_DOWN, skipSWF);
			
			makeBtn();
			
//			/**	인터랙션 스킵 타이머	*/
//			$skipTimer = new Timer(10000, 1);
//			$skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, skipInteraction);
//			$skipTimer.start();
		}
		/**	인터랙션 정지 	*/
		protected function pauseInteraction(e:Event):void
		{
//			if($main.btnCon.alpha == 1) $skipTimer.stop();
			if(_model.content != null) _model.content.stop();
		}
		/**	인터랙션 재실행	*/
		protected function resumeInteraction(e:Event):void
		{
//			if($main.btnCon.alpha == 1) $skipTimer.start();
			if(_model.content != null) _model.content.play();
		}
		
		/**	스킵 타이머 - 다음 인터랙션	*/
		private function skipInteraction(e:TimerEvent):void
		{
//			$skipTimer.reset();
			var num:int = Math.round(Math.random());
			loadDirectionSWF(num);
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			/**	방향 선택	*/
			for (var i:int = 0; i < $choiceBtnLength; i++) 
			{
				var btn:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				$btnChoice.push(btn);
				btn.no = i;
				ButtonUtil.makeButton(btn, choiceHandler);
			}
			
		}
		
		protected function test(event:Event):void
		{
			trace("XXXXXXXXXXXXXXXXXXXX");	
			loadComplete(null);
			_model.removeEventListener("XXXX",test);
		}
		
		/**	영상 선택	*/
		private function choiceHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					if(e.target.no == 0){
						TweenLite.to(e.target,.2,{x: 11,easing:Bounce.easeInOut})
					}else if(e.target.no == 1){
						TweenLite.to(e.target,.2,{x: 821,easing:Bounce.easeInOut})
					}
//					$skipTimer.stop();
					break;
				case MouseEvent.MOUSE_OUT :
					
					if(e.target.no == 0){
						TweenLite.to(e.target,.2,{x: 21,easing:Bounce.easeInOut})
					}else if(e.target.no == 1){
						TweenLite.to(e.target,.2,{x: 811,easing:Bounce.easeInOut})
					}
//					$skipTimer.start();
					break;
				case MouseEvent.CLICK :
					/**	영상 로드	*/
					loadDirectionSWF(e.target.no);
					break;
			}
		}
		/**	영상 로드	*/
		private function loadDirectionSWF(num:int):void
		{
			
			/**	좌우 버튼 이벤트 제거	*/
			for (var i:int = 0; i < $choiceBtnLength; i++) 
			{	ButtonUtil.removeButton($btnChoice[i], choiceHandler);		}
			/**	빨리감기 버튼	*/
			ButtonUtil.makeButton($main.btnFF, btnFFHandler);
			$main.btnFF.gotoAndStop(1)
				
			var path:String;
			if($finishChk == false)
			{
				if(num == 0)
				{
					_controler.makeLoading();
					
					$direction = "left";
					path = $defaultPath + "movie/left_01.swf";
				}
				else
				{
					_controler.makeLoading();
					
					$direction = "right";
					path = $defaultPath + "movie/right_01.swf";
				}
			}
			else
			{
				if($direction == "left")
				{
					if(num == 0){
						_controler.makeLoading();
						path = $defaultPath + "movie/left_02.swf";
					}else{
						_controler.makeLoading();
						path = $defaultPath + "movie/right_02.swf";
					}
				}
				else if($direction == "right")
				{
					if(num == 0){
						_controler.makeLoading();
						path = $defaultPath + "movie/left_02.swf";
					}else{
						_controler.makeLoading();
						path = $defaultPath + "movie/right_02.swf";
					}
				}
			}
			trace("영상 경로: ", path);
			trace("이동 방향: ", $direction);
			trace("마지막 영상 체크: ", $finishChk);
			
			
			$swf = new Loader();
			$swf.load(new URLRequest(path));
			$swf.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			$swf.contentLoaderInfo.addEventListener(Event.INIT,loadStart);
			
			$swfArr.push($swf);
			$main.swfCon.addChild($swf);
//			var testBtn:Sprite = TestButton.btn();
//			testBtn.x = testBtn.y = 100;
//			$main.swfCon.addChild(testBtn);
			
		}
		/**	로드 시작	*/
		private function loadStart(e:Event):void
		{
//			$skipTimer.stop();
			trace("영상 로드 시작__!! 스킵 타이머 정지 !!");
		}
		/**	로드 진행	*/
		private function loadProgress(e:ProgressEvent):void
		{
			var percent:Number = int((e.bytesLoaded/e.bytesTotal)*200);
			_controler.progress(percent);
			
			if(percent > 95){
				trace("loadComplete(null)");
				loadComplete(null);
				$swf.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgress);
			}
//			trace("로드중__ " + percent);
		}
		
		/**	로드 완료	*/
		private function loadComplete(e:Event):void
		{
			if(_model.content){
				_controler.loadComplete();		
//				trace("_model.content: ",_model.content);
				_model.content.gotoAndPlay(2);
				TweenLite.to($main.imgCon, 0.5, {alpha:0, onComplete:removeImg});
				TweenLite.to($main.btnCon, 0.5, {autoAlpha:0});
				TweenLite.to($main.btnFF, 0.5, {autoAlpha:1});
				$main.swfCon.addEventListener(Event.ENTER_FRAME, playStatusChk);				
				trace("로드완료__!!");
			}else{
				_model.addEventListener("XXXX",test);
			}
		}
		
		private function swfPlay(e:PEventCommon):void
		{
			_model.content.play();
		}
		
		/**	이미지 제거	*/
		private function removeImg():void
		{
			if($main.imgCon.numChildren >= 1) {
				var bitmap:Bitmap = Bitmap($main.imgCon.getChildAt(0));
				$main.imgCon.removeChild(bitmap);
				bitmap.bitmapData.dispose();
			}
		}
		
		/**	영상 빨리 감기	*/
		private function btnFFHandler(e:MouseEvent):void
		{
			$main.btnFF.gotoAndStop(2)
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($main.btnFF.btnW.over, 0.5, {tint:0xfff500});
					TweenLite.to($main.btnFF.txt, 0.75, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
					
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($main.btnFF.btnW.over, 0.5, {tint:0xffffff});
					TweenLite.to($main.btnFF.txt, 0.5, {scaleX:0, scaleY:0, ease:Back.easeIn});
					break;
				case MouseEvent.MOUSE_DOWN :
					$isDown = true;
					_model.content.stop();
					TweenLite.to($main.btnFF.btnW, 0.3, {y:-5, x:10, scaleX:0.9, scaleY:0.9});
					$main.btnFF.stage.addEventListener(MouseEvent.MOUSE_UP, normalPlay);
					break;
			}
		}
		/**	재생 속도 & 위치 체크	*/
		private function playStatusChk(e:Event):void
		{
			if(_model.content.currentFrame == _model.content.totalFrames)
			{
				$isDown = false;
				$main.swfCon.removeEventListener(Event.ENTER_FRAME, playStatusChk);
				$main.btnFF.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
				_model.content.stop();
				if($finishChk == false)
				{
					$finishChk = true;
//					$skipTimer.start();
					/**	빨리감기 버튼 이벤트 제거	*/
					ButtonUtil.removeButton($main.btnFF, btnFFHandler);
					/**	좌우 버튼 이벤트	*/
					for (var i:int = 0; i < $choiceBtnLength; i++) 
					{	ButtonUtil.makeButton($btnChoice[i], choiceHandler);		}
					TweenLite.to($main.btnCon, 0.5, {autoAlpha:1});
					TweenLite.to($main.btnFF, 0.5, {autoAlpha:0});
					drawBitmap();
					destroy();
					trace("영상 종료___스킵 타이머 시작__!!");
				}
				else
				{
					btnSkipHandler();
					trace("인터랙션 종료__!!엔딩 영상 플레이~~");
				}
				TweenLite.to($main.btnFF.btnW.over, 0.5, {tint:0xffffff});
				TweenLite.to($main.btnFF.btnW, 0.3, {y:0, x:0, scaleX:1, scaleY:1});
				TweenLite.to($main.btnFF.txt, 0.5, {scaleX:0, scaleY:0, ease:Back.easeIn});
			}
			else
			{
				if($isDown)
				{
					_model.content.nextFrame();
					_model.content.nextFrame();
					_model.content.nextFrame();
				}
			}
		}
		
		protected function skipSWF(e:KeyboardEvent):void
		{
			trace(e.keyCode);
			if(e.keyCode == 65 && _model.content != null)
			{
				_model.content.gotoAndPlay(_model.content.totalFrames - 10);
			}
		}
		
		
		/**	정상 재생	*/
		private function normalPlay(e:MouseEvent):void
		{
			$isDown = false;
			TweenLite.to($main.btnFF.btnW, 0.3, {y:0, x:0, scaleX:1, scaleY:1});
			if(_model.content.currentFrame != _model.content.totalFrames) _model.content.play();
			$main.btnFF.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
		}
		
		/**	다음 코스 넘어가기	*/
		private function btnSkipHandler(e:MouseEvent = null):void
		{
			trace("btnSkipHandler 다음코스 넘어가기");
			_controler.changeMovie([2, 4, 0]);
			removeEvent();
//			setTimeout(removeMain, 500);
		}
		
		private function removeMain(e:Event):void
		{
//			$main.alpha = 0;
//			$main.visible = false;
//			destroy();
//			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			TweenLite.to($main, 0, {delay:0.5, autoAlpha:0, onComplete:callRemoveInteraction});
		}
		
		private function callRemoveInteraction():void
		{
			trace("::::::::::::: 보나파시오 하이스트리트 인터랙션 종료 :::::::::::::");
			destroy();
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
		
		/**	마지막 장면 그려서 붙이기	*/
		private function drawBitmap():void
		{
			trace("drawBitmap ~~~~~~~~~~~~~~~~~~~~");
			$main.imgCon.alpha = 1;
			var bmpData:BitmapData = new BitmapData(961, 541);
			bmpData.draw($main.swfCon);
			var bmp:Bitmap = new Bitmap(bmpData, "auto", true);
			$main.imgCon.addChild(bmp);
		}
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			$isDown = false;
			
			var num:int = $main.swfCon.numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				var mc:DisplayObject = $main.swfCon.getChildAt(0);
				$main.swfCon.removeChild(mc);
				if(mc is Loader){
					Loader(mc).unloadAndStop();
				}
			}
			_model.content=null;
			trace("이미지 컨테이너 자식수: ", $main.imgCon.numChildren);
			trace("영상 컨테이너 자식수", $main.swfCon.numChildren);
		}
		
		/**	버튼 이벤트 지우기	*/
		private function removeEvent(e:Event=null):void
		{
			$main.swfCon.removeEventListener(Event.ENTER_FRAME, playStatusChk);
			
			for (var i:int = 0; i < $choiceBtnLength; i++) 
			{
				var btn:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btn, choiceHandler);
			}
			
			$main.btnFF.removeEventListener(MouseEvent.MOUSE_OVER, btnFFHandler);
			$main.btnFF.removeEventListener(MouseEvent.MOUSE_OUT, btnFFHandler);
			$main.btnFF.removeEventListener(MouseEvent.MOUSE_DOWN, btnFFHandler);
			
			$main.btnFF.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
//			$main.btnFF.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
			$main.btnFF.buttonMode = false;
			
//			$skipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, skipInteraction);
//			$skipTimer.stop();
//			$skipTimer = null;
			
			_model.removeEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.removeEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
	}
}