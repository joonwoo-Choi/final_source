package day.day1
{
	
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sw.utils.book.Book;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import loading.ViewLoading;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day1_1 extends AbstractMain
	{
		
		private var $main:AssetDay1_1;
		
		private var $swf:SWFLoader;
		/**	배속	*/
		private var $frameRate:int = 1;
		/**	배속 버튼 다운?	*/
		private var $isDown:Boolean = false;
		/**	정상 플레이?	*/
		private var $isPlay:Boolean = true;
		/**	이미지 다운로드	*/
		private var $fileRef:FileReference;
		/**	사진찍기 팝업 버튼 수	*/
		private var $shotBtnLength:int = 2;
		
		private var $tryShotPicture:Boolean = true;
		
		private var $imgNum:int;
		
		private var $downLoadActive:Boolean = true;
		/**	사진 찍은 횟수	*/
		private var $shotPictureCnt:int;
		
		private var $loading:MCLoading;
		private var $viewLoading:ViewLoading;
		
		public function Day1_1()
		{
			super();
			TweenPlugin.activate([TintPlugin, AutoAlphaPlugin, ColorTransformPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			_controler.makeLoading();
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
			
			$main = new AssetDay1_1();
			this.addChild($main);
			
			$main.btnSkip.visible = false;
			
			$main.seekBar.btn.mouseEnabled = false;
			$main.seekBar.btn.mouseChildren = false;
			
			$main.picCon.alpha = 0;
			$main.picCon.visible = false;
//			$main.picCon.mouseEnabled = false;
//			$main.picCon.mouseChildren = false;
			
			
			$fileRef = new FileReference();
			$fileRef.addEventListener(Event.CANCEL, downCancel);
			$fileRef.addEventListener(Event.COMPLETE, downLoadChk);
			
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
			
		}
		
		/**	인터랙션 정지 	*/
		protected function pauseInteraction(e:Event):void
		{
			$main.swfCon.removeEventListener(Event.ENTER_FRAME, playStatusChk);
			$swf.rawContent.stop();
		}
		/**	인터랙션 재실행	*/
		protected function resumeInteraction(e:Event):void
		{
			$main.swfCon.addEventListener(Event.ENTER_FRAME, playStatusChk);
			$swf.rawContent.play();
		}
		
		/**	XML로드 완료 모델에 저장	*/
		protected function xmlLoadComplete(e:Event):void
		{
			_model.xmlData = XML(e.target.data);
			makeBtn();
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
			_controler.changeMovie([2, 1, 1]);
			removeEvent();
//			setTimeout(removeMain, 500);
			trace("::::::::::::: 바바라스 인터랙션 종료 :::::::::::::");
		}
		
		private function removeMain(e:Event):void
		{
			_model.removeEventListener(PEventCommon.MOVIE_PLAY_START, removeMain);
			TweenLite.to($main, 0, {delay:0.5, autoAlpha:0, onComplete:destroy});
//			$main.alpha = 0;
//			$main.visible = false;
//			destroy();
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			trace("makeBtn!!!")
			/**	빨리감기 버튼	*/
			ButtonUtil.makeButton($main.seekBar, btnFFHandler);
			
			/**	이미지 저장 버튼	*/
			ButtonUtil.makeButton($main.btnSave.btn, imgSave);
			
			/**	스킵 버튼	*/
			ButtonUtil.makeButton($main.btnSkip, btnSkipHandler);
			
			/**	팝업 버튼	*/
			for (var i:int = 0; i < $shotBtnLength; i++) 
			{
				var btns:MovieClip = $main.picCon.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, imgShotBtnHandler);
			}
			
			/**	영상 로드	*/
			$swf = new SWFLoader(_model.xmlData.list[2].list[1].list[0].@swf, {container:$main.swfCon, onInit:loadStart, onProgress:loadProgress, onComplete:loadComplete});
			$swf.load();
		}
		
		/**	스킵버튼 핸들러	*/
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
				case MouseEvent.CLICK : 
//					skipInteraction();
					skipOff();
					break;
			}
		}
		/**	로드 시작	*/
		private function loadStart(e:LoaderEvent):void
		{
//			$skipTimer.stop();
		}
		
		/**	로드 진행	*/
		private function loadProgress(e:LoaderEvent):void
		{
			var percent:Number = int((e.target.bytesLoaded/e.target.bytesTotal)*100);
			_controler.progress(percent);
//			trace("로드중__ " + percent);
		}
		
		/**	로드 완료	*/
		private function loadComplete(e:Event):void
		{
			_controler.loadComplete();
			$swf.rawContent.play();
			
			$main.swfCon.addEventListener(Event.ENTER_FRAME, playStatusChk);
			trace("로드완료__!!");
		}
		
		/**	영상 빨리 감기	*/
		private function btnFFHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
//					TweenLite.to($main.seekBar.btn, 0.5, {frame:2});
					$main.seekBar.btn.gotoAndStop(2)
					break;
				case MouseEvent.MOUSE_OUT : 
//					TweenLite.to($main.seekBar.btn, 0.5, {frame:1});
					$main.seekBar.btn.gotoAndStop(1)
					break;
				case MouseEvent.MOUSE_DOWN :
					if($tryShotPicture == false) return;
					frameRateChange();
					$main.stage.addEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
					$main.seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, normalPlay);
					break;
			}
		}
		/**	프레임 레이트 변환	*/
		private function frameRateChange(e:MouseEvent = null):void
		{
			var btnX:int;
			var maxBtnX:int = $main.seekBar.range.width + $main.seekBar.range.x;
			
			btnX = $main.seekBar.mouseX;
			if(btnX <= $main.seekBar.range.x) btnX = $main.seekBar.range.x;
			else if(btnX >= maxBtnX) btnX = maxBtnX;
			TweenLite.killTweensOf($main.seekBar.btn);
			$main.seekBar.btn.x = btnX;
			
			var frameRate:int = 1 + ((btnX - $main.seekBar.range.x) / $main.seekBar.range.width) * 4;
			
			$frameRate = frameRate;
			
			/**	플레이 & 배속 체크	*/
			if($frameRate >= 2 && $isPlay == true)
			{
				$isPlay = false;
				$isDown = true;
				$swf.rawContent.stop();
			}
			else if($frameRate == 1 && $isPlay ==false)
			{
				$isPlay = true;
				$isDown = false;
				$swf.rawContent.play();
			}
			trace("프레임 레이트: " + $frameRate);
		}
		/**	재생 속도 & 위치 체크	*/
		private function playStatusChk(e:Event):void
		{
			if($swf.rawContent.currentFrame == $swf.rawContent.totalFrames)
			{
				$swf.rawContent.gotoAndPlay(2);
			}
			else
			{
				if($isDown && $frameRate >= 2)
				{
					for (var i:int = 0; i < $frameRate; i++) 
					{
						$swf.rawContent.nextFrame();
					}
				}
			}
			/**	이미지 번호 설정	*/
			var frameNum:int = $swf.rawContent.currentFrame;
			if(frameNum >= 1 && frameNum <= 65) $imgNum = 0;
			else if(frameNum >= 66 && frameNum <= 100) $imgNum = 1;
			else if(frameNum >= 101 && frameNum <= 140) $imgNum = 2;
			else if(frameNum >= 141 && frameNum <= 170) $imgNum = 3;
			else if(frameNum >= 171 && frameNum <= 210) $imgNum = 4;
			else if(frameNum >= 211 && frameNum <= 250) $imgNum = 5;
			else if(frameNum >= 251 && frameNum <= 285) $imgNum = 6;
			else if(frameNum >= 286 && frameNum <= 322) $imgNum = 7;
			else if(frameNum >= 323 && frameNum <= 450) $imgNum = 8;
			else if(frameNum >= 451 && frameNum <= 570) $imgNum = 9;
			else if(frameNum >= 571 && frameNum <= 650) $imgNum = 10;
			else if(frameNum >= 651 && frameNum <= 720) $imgNum = 11;
		}
		/**	정상 재생	*/
		private function normalPlay(e:MouseEvent):void
		{
			if($isPlay == false) $swf.rawContent.play();
			$isPlay = true;
			$isDown = false;
			TweenLite.to($main.seekBar.btn, 0.5, {x:$main.seekBar.range.x});
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
			$main.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
			$frameRate = 1;
		}
		
		/**	사진 찍기	*/
		private function imgSave(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($main.btnSave.camera, 0.5, {tint:0xfff400});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($main.btnSave.camera, 0.5, {tint:null});
					break;
				case MouseEvent.MOUSE_DOWN :
					$main.btnSave.gotoAndPlay(2)
					if($tryShotPicture != true) return;
//					$shotPictureCnt++;
					$tryShotPicture = false;
					$downLoadActive = true;
					$swf.rawContent.stop();
					
					var picLdr:Loader = new Loader();
					picLdr.load(new URLRequest(_model.urlDefaultWeb + "img/selca_" + $imgNum + ".jpg"));
					picLdr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, pictureLoadProgress);
					picLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, pictureLoadComplete);
					$main.picCon.pic.addChild(picLdr);
					
					/**	사진 설정	*/
					$main.picCon.itemCon.gotoAndStop($imgNum + 1);
					$main.picCon.itemCon.item.gotoAndPlay(2);
					trace("이미지 번호: " + $imgNum);
					break;
			}
		}
		/**	사진 로드 중	*/
		private function pictureLoadProgress(e:ProgressEvent):void
		{
//			var percent:Number = int((e.target.bytesLoaded/e.target.bytesTotal)*100);;
//			trace("로드중__ " + percent);
//			_controler.progress(percent);
			
		}
		/**	사진 로드 완료	*/
		private function pictureLoadComplete(e:Event):void
		{
			e.target.removeEventListener(ProgressEvent.PROGRESS, pictureLoadProgress);
			e.target.removeEventListener(Event.COMPLETE, pictureLoadComplete);
			
//			_controler.loadComplete();
			
			$main.picCon.visible = true;
			$main.picCon.alpha = 1;
			TweenLite.to($main.picCon, 0, {colorTransform:{exposure:1.3}});
			TweenLite.to($main.picCon, 0.75, {colorTransform:{exposure:1}});
			
		}
		
		/**	사진 팝업 버튼 핸들러	*/
		private function imgShotBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenMax.to(target, .3, {colorMatrixFilter:{brightness:0.9,contrast:0.9}});
					
					break;
				case MouseEvent.MOUSE_OUT :
					TweenMax.to(target, .3, {colorMatrixFilter:{brightness:1,contrast:1}});
					break;
				case MouseEvent.MOUSE_DOWN :
					if(target.no == 0)
					{
						if($downLoadActive != true) return;
						$downLoadActive = false;
						$fileRef.download(new URLRequest("http://cdn.funtrip2manila.co.kr/www/img/downImg/selca_" + $imgNum + ".jpg" ), "에일리의 얼짱 셀카♥_" + $imgNum + ".jpg");
					}
					else
					{
						if($shotPictureCnt  >= 3) skipInteraction();
						else replayInteraction();
					}
					
					setTimeout(showBtnSkip, 500);
					break;
			}
		}
		/**	인터랙션 재시작	*/
		private function replayInteraction(e:TimerEvent = null):void
		{
			$tryShotPicture = true;
			$downLoadActive = false;
			$swf.rawContent.play();
			
			TweenLite.to($main.picCon, 0.5, {autoAlpha:0, onComplete:removePicture});
			/**	2번째 사진 저장했을 때 부터 스킵버튼 활성화	*/
//			if($shotPictureCnt == 1) setTimeout(showBtnSkip, 500);
		}
		
		/**	스킵버튼 보이기	*/
		private function showBtnSkip():void
		{	
			skipOn();
		}
		
		/**	사진 제거	*/
		private function removePicture():void
		{
			var ldr:Loader = $main.picCon.pic.getChildAt(0) as Loader;
			$main.picCon.pic.removeChild(ldr);
			ldr.unloadAndStop();
			ldr = null;
			
			$main.picCon.itemCon.item.gotoAndStop(1);
			trace("사진 컨테이너 자식 수: " + $main.picCon.pic.numChildren);
		}
		
		/**	다운로드 취소	*/
		private function downCancel(e:Event):void
		{
			replayInteraction();
		}
		/**	다운로드 체크	*/
		private function downLoadChk(e:Event):void
		{
			$shotPictureCnt++;
			if($shotPictureCnt  >= 3)
			{
				skipInteraction();
			}
			else
			{
				$downLoadActive = true;
				replayInteraction();
			}
		}
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			if($main.swfCon.numChildren > 0)
			{
				$main.swfCon.removeChildAt(0);
				$swf.unload();
				$swf = null;
			}
			
			if($main.picCon.pic.numChildren >= 1)
			{
				removePicture();
//				var ldr:Loader = $main.picCon.pic.getChildAt(0) as Loader;
//				$main.picCon.pic.removeChildAt(0);
//				ldr.unloadAndStop();
//				ldr = null;
			}
			
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			trace($swf, $main.swfCon.numChildren);
		}
		
		private function removeEvent(e:Event=null):void
		{
			trace("remove버튼")
			$main.swfCon.removeEventListener(Event.ENTER_FRAME, playStatusChk);
			$main.stage.removeEventListener(MouseEvent.MOUSE_MOVE, frameRateChange);
			$main.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, normalPlay);
			
			ButtonUtil.removeButton($main.seekBar, btnFFHandler);
			
			ButtonUtil.removeButton($main.btnSave.btn, imgSave);
			
			ButtonUtil.removeButton($main.btnSkip.btn, btnSkipHandler);
			
			for (var i:int = 0; i < $shotBtnLength; i++) 
			{
				var btns:MovieClip = $main.picCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, imgShotBtnHandler);
			}
			$fileRef.removeEventListener(Event.CANCEL, downLoadChk);
			$fileRef.removeEventListener(Event.COMPLETE, downLoadChk);
			$fileRef = null;
			
			_model.removeEventListener(PEventCommon.MOVIE_PAUSE, pauseInteraction);
			_model.removeEventListener(PEventCommon.MOVIE_RESUME, resumeInteraction);
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
	}
}