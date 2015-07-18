package util
{
	import com.adqua.control.flvPlayer.BasicPlayer;
	import com.adqua.control.flvPlayer.events.MovieStatusEvent;
	import com.adqua.net.Debug;
	import com.cj.events.PageEvent;
	import com.cj.utils.ArrayUtil;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import pEvent.PEventCommon;
	
	public class MainPlayer extends AbstractMain
	{
		//손하고 핸드폰이 들어가있는...
		private var $mCover:Sprite;
		private var $moviePlayer:BasicPlayer;
		private var $swfPlayer:Sprite;
		private var $hpCon:HpCon;
		private var $yellowBar:YellowBar;
		private var $hpCover:HpCover;
		private var $playerX:int = 576.5;
		private var $playerY:int = 64.5;
		private var $botCover:Sprite;
		private var $botSwf:SWFLoader;
		private var $botInfoLoader:Loader;
		private var $btnSkip:BtnSkip;
		private var $skipTimer:Timer;
		private var endChk:String;//xml노드에서 가져오는 정보 현재 몇번째 메뉴 플레이 중인지 0~7번 중 하나의 값.
		private var skipChk:String;
		private var swing:String;
		private var $hpConControl:FBTwitterTxt;
		private var $swfArr:Array = [];
		
		public function MainPlayer()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin,FrameLabelPlugin]);
			
			$mCover = new Sprite;
			addChild($mCover);
			$mCover.visible = false;
			
			//핸드폰
			$hpCon = new HpCon;
			$hpConControl = new FBTwitterTxt($hpCon);
			$mCover.addChild($hpCon);
			
			//moviePlayer
			$moviePlayer = new BasicPlayer(null,962,542);
//			$moviePlayer.addEventListener(MovieStatusEvent.STOP,movieFinished);
			$moviePlayer.addEventListener(MovieStatusEvent.STATUS_EVENT, videoStatusHandler);
			$moviePlayer.x = $playerX;
			$moviePlayer.y = $playerY;
			$mCover.addChild($moviePlayer);	
			
			//swfPlayer
			$swfPlayer = new SWFContent;
			$swfPlayer.x = $playerX;
			$swfPlayer.y = $playerY;
			$mCover.addChild($swfPlayer);
			
			//btnSkip버튼
			$btnSkip = new BtnSkip;
			$mCover.addChild($btnSkip);
			$btnSkip.x = 576;
			$btnSkip.y = 527;
			$btnSkip.visible = false;
			$btnSkip.buttonMode = true;
			$btnSkip.addEventListener(MouseEvent.ROLL_OVER, skipOver);
			$btnSkip.addEventListener(MouseEvent.ROLL_OUT, skipOut);
			$btnSkip.addEventListener(MouseEvent.CLICK, skipClick);
			
			//핸드폰커버
			$hpCover = new HpCover;
			$hpCover.x = 570;
			$hpCover.y = 58;
			$mCover.addChild($hpCover);
			$hpCover.mouseEnabled = false;
			$hpCover.mouseChildren = false;
			
			//yellowBar
			$yellowBar = new YellowBar;
			$yellowBar.x = 840;
			$yellowBar.y = 47;
			$mCover.addChild($yellowBar);
			$yellowBar["yTxt"].gotoAndStop(_model.activeMenu + 1);
			$yellowBar["yTxt"].visible = false;
			
			//routeMap,event LoadCover
			$botCover = new Sprite;
			addChild($botCover);
			
			//각 인터랙션 처음 스킵버튼 나오는 타이머
			$skipTimer = new Timer(3000, 1);
			$skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, skipInteraction);
			
			_model.addEventListener(PEventCommon.GNB_ACTIVE_ON, underTitleSetting);
			
			
			_model.addEventListener(PEventCommon.MOVIE_CHANGE,playSetting);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE,moviePause);
			_model.addEventListener(PEventCommon.MOVIE_RESUME,movieResume);
			
			_model.addEventListener(PEventCommon.MOVIE_PLAY_FINISHED,nextStepSetting);
			
			_model.addEventListener(PEventCommon.MOVIE_ROUTE_PLAY,routeMapLoad);
			_model.addEventListener(PEventCommon.MOVIE_EVENT_PLAY,eventMapLoad);
			
			_model.addEventListener(PEventCommon.MOVIE_REMOVE,mainPlayerRemove);
			
			//skip On Off
			_model.addEventListener(PEventCommon.SKIP_OPEN_ON,skipOn);
			_model.addEventListener(PEventCommon.SKIP_OPEN_OFF,skipOff);
			_model.addEventListener(PEventCommon.SKIP_OPEN_DEL,skipDelete);
			
			//노란바
			_model.addEventListener(PEventCommon.YELLOW_OPEN,yellowOpen);
			_model.addEventListener(PEventCommon.YELLOW_CLOSE,yellowClose);
			
			//팝업에서 영상계속 플레이
			_model.addEventListener(PEventCommon.MOVIE_RESUME,popClickPlay);
			_model.addEventListener(PEventCommon.MOVIE_PAUSE,popClickPause);
			
			_model.addEventListener(PEventCommon.HPTITLE_STOP,hpTitleStop);
		}
		
		protected function hpTitleStop(e:PEventCommon):void
		{
			$hpCon["hpTitle"].gotoAndStop(11);
		}
		/**	일시정지	*/
		protected function moviePause(e:Event):void
		{
			$moviePlayer.pause();
		}
		/**	다시 재생	*/
		protected function movieResume(e:Event):void
		{
			$moviePlayer.resume();
		}
		
		//skip버튼
		protected function skipOver(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"].gotoAndStop(2);
		}
		protected function skipOut(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"].gotoAndStop(1);
		}
			
		private function skipClick(evt:MouseEvent):void
		{
			skipOff(null)
		}
		
		private function skipOn(evt:PEventCommon = null):void
		{
			skipDelete()
			if($btnSkip){
				$btnSkip.stop();
				$btnSkip.visible = false;
				$btnSkip.alpha = 0;
			}
			trace("스킵온   _model.activeMenu  : ", _model.activeMenu)
			TweenLite.to($btnSkip, .5, {autoAlpha:1,frame:$btnSkip.totalFrames-1})
		}
		
		private function skipOff(evt:PEventCommon=null):void
		{
			TweenLite.to($btnSkip, .5, {frame:1, onComplete:skipComplete});
		}
		
		private function skipComplete(evt:Event = null):void
		{
			skipDelete();
			$moviePlayer.seek($moviePlayer.duration - 0.1);
			
			_model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_PLAY_FINISHED));
		}
		
		private function skipDelete(evt:Event=null):void
		{
			trace("스킵아웃");	
			if($btnSkip){
				$btnSkip.stop();
				$btnSkip.visible = false;
				$btnSkip.alpha = 0;
				TweenLite.killTweensOf($btnSkip);
				_model.removeEventListener(PEventCommon.SKIP_OPEN_ON,skipOn);
			}
		}
		
		protected function yellowOpen(evt:PEventCommon=null):void
		{
			//yellow타이틀
			$yellowBar.visible = true;
			$yellowBar["yTxt"].alpha = 0;
			$yellowBar["yTxt"].visible = false;
			$yellowBar["bg"].gotoAndPlay(2);
			$yellowBar["bg"].addFrameScript($yellowBar["bg"].totalFrames-1, yellowComplete);
		}
		protected function yellowClose(evt:PEventCommon=null):void
		{
			if($yellowBar){
				$yellowBar.visible = false;
			}
		}
		
		protected function nextStepSetting(event:Event):void
		{
			var nextNum:String;
			var nextNumAry:Array;
			var lastMovieChk:Boolean = false;
			
			//지금 재생한 영상이 각 컨텐츠별 마지막 영상이면 true
			for (var i:int = 0; i < _model.watchedMov3.length; i++) 
			{
				var lastMovie:Array = _model.watchedMov3[i];
				lastMovieChk = ArrayUtil.matchArray(lastMovie,_model.numActiveVideo);
				if(lastMovieChk)break;
				
			}	
			//최종 3-2마지막 영상을 먼저 본 경우  && 다른 day 안본 영상의 마지막 영상을 본 경우
			//요약해서 현재 재생완료된 영상이 각 메뉴(0~7)의 마지막 영상을 봤다면 다른 안본메뉴(0~7)의 첫번째 영상을 플레이시킬 주소값을 가지게 하고 
			//전부 다 봤다면 마지막 영상을 재생해야한다.
			if(lastMovieChk){
				trace("_model.menuBank: ",_model.menuBank);
				trace("_model.watchedMov: ",_model.watchedMov);
				//또다른 안본 영상이 있는지 검색한다.리턴값은 0~7중하나
				var notPlay:Array = ArrayUtil.diff(_model.menuBank,_model.watchedMov);
				trace("notPlay: ",notPlay);
				if(notPlay.length>0){//~~~~~~~~~~~~~~~~~~
					var playNum:int = makePlayNum(notPlay);//~~~~~~~~~~~~~~~~~~
					trace("playNum: ",playNum);
					nextNumAry = _model.watchedMov2[playNum];//~~~~~~~~~~~~~~~~~~
				}else{
					//안본영상이 없는경우
					trace("기존처럼 xml값에 있는 다음 영상이나 컨텐츠를 보여준다.");
					nextNum = makeNextNum();//~~~~~~~~~~~~~~~~~~
					nextNumAry = nextNum.split(",");					
				}
			}else{			
				
				if(_model.numActiveVideo.length==1)
				{
					nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].@videoNext;
				}
				else if(_model.numActiveVideo.length==2)
				{
					nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@videoNext;
				}
				else if(_model.numActiveVideo.length==3)
				{
					nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@videoNext;
				}	
				
				nextNumAry = nextNum.split(",");
			}
			
			var nextSwfUrl:String;
			var loopChk:String;
			
			//다음 활성화 내용에 swf버튼이나 디자인 컨텐츠가 있는지를 체크하기 위해서
			if(nextNumAry.length==1)
			{
				nextSwfUrl = _model.xmlData.list[int(nextNumAry[0])].@swf;
				skipChk  = _model.xmlData.list[int(nextNumAry[0])].@skipChk;
				endChk  = _model.xmlData.list[int(nextNumAry[0])].@endChk;
			}
			else if(nextNumAry.length==2)
			{
				nextSwfUrl = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].@swf;
				skipChk  = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].@skipChk;
				endChk  = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].@endChk;
			}
			else if(nextNumAry.length==3)
			{
				trace("nextNumAry넥스트 넘: ",nextNumAry);
				nextSwfUrl = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].list[int(nextNumAry[2])].@swf;
				skipChk = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].list[int(nextNumAry[2])].@skipChk;
				loopChk = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].list[int(nextNumAry[2])].@loopChk;
				endChk = _model.xmlData.list[int(nextNumAry[0])].list[int(nextNumAry[1])].list[int(nextNumAry[2])].@endChk;
			}			
			
			_model.activeMenu = int(skipChk);
			
			
//			if(endChk !=""){
//				_controler.activeCheck(Number(endChk));
//				_model.endChk = true;
//			}else{
//				_model.endChk = false;
//			}
			
			if(nextSwfUrl.length!=0){
				_controler.swfContentLoad(nextNumAry);
				trace("nextSwfUrl: ",nextSwfUrl);
			}
			
			//수영 3번 클릭시 엔딩으로 보냄
			if(_model.swimChkNum > 2 ){
				_model.dispatchEvent(new PEventCommon(PEventCommon.SKIP_INTERACTION));
			}else{
				_controler.changeMovie(nextNumAry);	
			}
			
			if(skipChk == "8"){
				_model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_ROUTE_PLAY));
			}
		}
		//~~~~~~~~~~~~~~~~~~
		private function makePlayNum(notPlay:Array):int
		{
			var playNum:int=-1;
			for (var i:int = 0; i < notPlay.length; i++) 
			{
				var lastWatched:int = _model.watchedMov[_model.watchedMov.length-1];
				if(notPlay[i]>lastWatched){
					playNum = notPlay[i]
					return playNum;
				}
			}
			return notPlay[0];
		}
		
		private function makeNextNum():String
		{
			var nextNum:String;
			
			if(_model.numActiveVideo.length==1)
			{
				nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].@videoNext;
			}
			else if(_model.numActiveVideo.length==2)
			{
				nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@videoNext;
			}
			else if(_model.numActiveVideo.length==3)
			{
				nextNum = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@videoNext;
			}	
			return nextNum;
		}		
		//~~~~~~~~~~~~~~~~~~여기까지		
		
		protected function videoStatusHandler(event:MovieStatusEvent):void
		{
			
			/** 버퍼링 풀 - 재생 시작 */
			if(event.code=="NetStream.Buffer.Full"){
				trace("영상 버퍼링 풀______!! 재생 시작_______!!");
				_model.dispatchEvent(new PEventCommon(PEventCommon.MOVIE_PLAY_START));
			}
			
			if(event.code=="NetStream.Play.Stop"){
				
				if(_model.login==false){
					trace("_model.watchedMov.length    : ", _model.watchedMov.length)
					//4,0,7  3번 제한 팝업
					trace("쇼핑몰 엔딩영상인지 확인 : ",_model.numActiveVideo);
					var eventMovieCheck :Boolean = ArrayUtil.matchArray(_model.numActiveVideo,[4,0,7]);;//쇼핑몰 엔딩영상 체크
					
					if(_model.watchedMov.length > 2 && eventMovieCheck==true){
						_model.mainPopupFrame = 6;
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
						return;
					}
				}
				
				//모든 무비 체크 후  나오는 팝업
				//endChk
				if(endChk !="")
				{
					/**	봤던 영상인지 검사	*/
					_controler.activeCheck(int(endChk));
					
					//인증체크
					if(_model.userAuth == 0){
						if(_model.watchedMov.length == 3 && _model.login == false){
							trace("======================================================그냥보기에서 3번이상 ");
							_model.mainPopupFrame = 6;
							_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
							return;
						}
					}
					
//					Debug.alert("_model.watchedMov.length : "+ _model.watchedMov.length +"/n _model.allWatched : "+ _model.allWatched)
					/**	엔딩 팝업 띄울지 검사	*/
					if(_model.watchedMov.length == 8 && _model.allWatched == "false")
					{
						_model.allWatched = "true"
						_model.mainPopupFrame = 4;
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
						return;
					}
				}
				else
				{
					if(int(_model.mall) > 0)
					{
						trace("_model.mall모델몰.........: ",_model.mall);
						_model.dispatchEvent(new PEventCommon(PEventCommon.MALL_POP_OPEN));
						
					}
				}
				
				//마지막 영상이 플레이 되면 
				if(endChk=="7"){
					_model.lastMovieWatched = true;
				}		
				
				// 골프 retry일때
				if(swing =="ok"){
					_model.dispatchEvent(new PEventCommon(PEventCommon.RETRY_GOLF));
				}else{
					_controler.movieFinished();
				}
				
				
				//무비 마지막 트래킹
				if(int(endChk) == 0){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie1");
				}else if(int(endChk) == 1){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie2");
				}else if(int(endChk) == 2){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie3");
				}else if(int(endChk) == 3){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie4");
				}else if(int(endChk) == 4){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie5");
				}else if(int(endChk) == 5){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie6");
				}else if(int(endChk) == 6){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie7");
				}else if(int(endChk) == 6){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_movie8");
				}
				
			}
		}
		
		override protected function onAdded(event:Event):void
		{
//			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeydown);
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
		}	
		
		protected function onKeydown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE){
				$moviePlayer.seek($moviePlayer.duration-0.1);
			}
		}
		
		protected function playSetting(event:Event):void
		{
			//menu 활성화
			_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_ACTIVE_ON));
			
			$btnSkip.gotoAndStop(1);
			$btnSkip.visible = false;
			
			trace("------------------------------------------  playSetting  ------------------------------------------")
			var url:String;
//			var skipChk:String;
			var shk:String;
			
			if(_model.numActiveVideo[0]>1){
				
				if(_model.numActiveVideo.length==1)
				{
					url = _model.xmlData.list[int(_model.numActiveVideo[0])].@video;
					skipChk  = _model.xmlData.list[int(_model.numActiveVideo[0])].@skipChk;
					shk  = _model.xmlData.list[int(_model.numActiveVideo[0])].@shk;
					endChk  = _model.xmlData.list[int(_model.numActiveVideo[0])].@endChk;
				}
				else if(_model.numActiveVideo.length==2)
				{
					url = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@video;
					skipChk  = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@skipChk;
					shk  = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@shk;
					endChk  = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].@endChk;
				}
				else if(_model.numActiveVideo.length==3)
				{
					url = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@video;
					skipChk = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@skipChk;
					shk = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@shk;
					endChk = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@endChk;
					swing = _model.xmlData.list[int(_model.numActiveVideo[0])].list[int(_model.numActiveVideo[1])].list[int(_model.numActiveVideo[2])].@swing;
				}				
				
				_model.skipChk = skipChk;
				
				if(url.length>0){
					botRemove();
					$mCover.visible = true;
					$swfPlayer.visible = true;
					$moviePlayer.visible = true;
					$moviePlayer.play(url);
				}
				
				//shk에 ok값이 있을때 (_model.activeMenu 값이 바뀔때 )
				if(shk != ""){
					
					//yellowBar 닫기
					yellowClose();
					
					//skipTimter
					$skipTimer.stop();
					$skipTimer.start();
					
					//하단타이틀
					_model.underMovTitleSetting = _model.activeMenu + 1;
					underTitleSetting();
					
				}else{
					skipDelete();
				}
				
				//skipChk가 없으면 노란바 안나옴.
				if(!skipChk){
					yellowClose();
				}
				
				
				
				trace("넥스트 watchedMov 갯수 : ",  _model.watchedMov.length)
				trace("_model.watchedMov.length : ", _model.watchedMov.length)
			}
		}
		
		private function underTitleSetting(e:Event = null):void
		{
			trace("_model.underMovTitleSetting : ", _model.underMovTitleSetting)
			$hpCon["hpTitle"].gotoAndStop(_model.underMovTitleSetting);
			
			/** 빈 타이틀이  아닐 경우 타이틀 색상 프레임 변경 후 플레이 */
			$hpCon["hpTitle"]["btTitleCon"].gotoAndStop(_model.underTitleFrameSrtting);
			$hpCon["hpTitle"]["btTitleCon"]["title"].gotoAndPlay(2);
			if($hpCon["hpTitle"]["btTitleCon"]["apmCon"] != null)
			{
				var frameLabel:String = String((_model.activeMenu % 3) +1);
				TweenLite.to($hpCon["hpTitle"]["btTitleCon"]["apmCon"], 0.5, {frameLabel:frameLabel});
				TweenLite.to($hpCon["hpTitle"]["btTitleCon"]["watchCon"], 0.5, {frameLabel:frameLabel});
				trace("frameLabel : ", frameLabel);
			}
		}
		
		protected function popClickPause(e:PEventCommon):void
		{
			trace("팝클릭 액티브넘 : ", _model.activeMenu);
			$moviePlayer.pause();
		}
		protected function popClickPlay(e:PEventCommon):void
		{
			trace("팝클릭 액티브넘 : ", _model.activeMenu);
			$moviePlayer.resume();
		}
		
		private function skipInteraction(e:TimerEvent):void
		{
			skipOn();
		}
		
		protected function yellowComplete(evt:Event=null):void
		{
			$yellowBar["bg"].stop();
			$yellowBar["yTxt"].gotoAndStop(_model.activeMenu + 1);
			TweenLite.to($yellowBar["yTxt"], .5, {autoAlpha:1});
		}
		
		//오른쪽 routeMap
		protected function routeMapLoad(evt:Event):void
		{
			botRemove();
			if($botCover){
				_model.botPopupType = "routeMap";
				$moviePlayer.visible = false;
				$moviePlayer.close();
				$moviePlayer.clear();
				$yellowBar.visible = false;
				_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			}
//			_controler.makeLoading();
			$botSwf = new SWFLoader(_model.urlDefault +"MiniMap.swf", {container:$botCover, onProgress:loadProgress, onComplete:loadComplete});
			$botSwf.load();
			$swfArr.push($botSwf);
		}
		
		//왼쪽 eventPop
		protected function eventMapLoad(evt:Event):void
		{
			botRemove();
			if($botCover){
				_model.botPopupType = "eventPop";
				$moviePlayer.visible = false;
				$moviePlayer.close();
				$moviePlayer.clear();
				$yellowBar.visible = false;
				_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			}
//			_controler.makeLoading();
			$botSwf = new SWFLoader(_model.urlDefault +"EventPop.swf", {container:$botCover, onProgress:loadProgress, onComplete:loadComplete});
			$botSwf.load();
			$swfArr.push($botSwf);
		}
		
		/**	로드 진행	*/
		private function loadProgress(e:LoaderEvent):void
		{
			var percent:Number = int((e.target.bytesLoaded/e.target.bytesTotal)*100);
			_controler.progress(percent);
			trace("로드중__ " + percent);
			
		}
		/**	로드 완료	*/
		private function loadComplete(e:LoaderEvent):void
		{
			_controler.loadComplete();
			trace("로드완료__!!");
			_model.botChk = true;
		}
		
		private function botRemove():void
		{
			_model.botPopupType = "";
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_POPUP_EVENT));
			
			while($botCover.numChildren > 0){
				
				$botCover.removeChildAt(0);
				$swfArr[0].unload();
				$swfArr[0] = null;
				$swfArr.shift();
			}
		}
		
		//logo클릭시
		public function mainPlayerRemove(evt:Event=null):void
		{
			botRemove();
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			$mCover.visible = false;
			$moviePlayer.visible = false;
			$moviePlayer.close();
			$moviePlayer.clear();
			trace("$mCover.numChildren : ", $mCover.numChildren)
		}
		
		protected function onResize(event:Event=null):void
		{
			if($mCover){
				$mCover.x = int(-196+(stage.stageWidth - $mCover.width)/2);
				$mCover.y = int(190+(stage.stageHeight - $mCover.height)/2);
			}
			if($botCover){
				$botCover.x = int(($mCover.x) + 575);
				$botCover.y = int(($mCover.y) + 65);
			}
		}
		
	}
}