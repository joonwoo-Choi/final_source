package
{
	
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import pEvent.PEvent;
	import pEvent.PEventCommon;

	[SWF(width="1280", height="150", frameRate="30", backgroundColor="0xdddddd")]
	
	public class GNB extends AbstractMain
	{
		
		private var $main:AssetGNB;
		/**	버튼 수	*/
		private var $btnLength:int = 8;
		/**	버튼 배열	*/
		private var $btnArr:Array;
		
		private var $dot:dot;
		private var $gnbChk:Boolean = false;
		private var $id:uint;
		private var mTimer:Timer;
		private var $isPopup:Boolean;
		
		public function GNB()
		{
			super();
			TweenPlugin.activate([TintPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
//			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetGNB();
			this.addChild($main);
			$main.y = -129;
			
			
			//gnb 닫기버튼
//			$main["bg2"]["closeBtn"].gotoAndStop(1);
			$main["bg2"]["closeBtn"].buttonMode = true;
			$main["bg2"]["closeBtn"].mouseChildren = false;
			$main["bg2"]["closeBtn"].addEventListener(MouseEvent.ROLL_OVER, gnbCloseOver);
			$main["bg2"]["closeBtn"].addEventListener(MouseEvent.ROLL_OUT, gnbCloseOut);
			$main["bg2"]["closeBtn"].addEventListener(MouseEvent.CLICK, gnbCloseClick);
			$gnbChk = false;
			
			//메뉴바 도트
			$dot = new dot();
			
			_model.addEventListener(PEvent.ACTIVE_MENU_CHECK, watchedMovieChk);
			_model.addEventListener(PEventCommon.GNB_OPEN_ON,gnbOn);
			_model.addEventListener(PEventCommon.GNB_OPEN_OFF,gnbOff);
			_model.addEventListener(PEventCommon.GNB_OPEN_ONOFF,gnbOnOff);
			
			_model.addEventListener(PEventCommon.GNB_ACTIVE_ON, activeMenuOn);
			
			makeBtn();
			activeBtn(_model.activeMenu);

//			TweenLite.delayedCall(2, gnbOn);
			
			resizeHandler();
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		//메뉴 활성화
		protected function activeMenuOn(evt:PEventCommon=null):void
		{
			activeBtn(_model.activeMenu);
		}
		
		//gnb ON
		protected function gnbOn(event:PEventCommon=null):void
		{
			TweenLite.to($main, .5,{y:0, onComplete:gnbOnComplete});
			$main["bg2"]["closeBtn"].gotoAndStop(2);
			$gnbChk = false;
		}
		
		private function gnbOnComplete(evt:Event=null):void
		{
			var logoTitleMc:MovieClip = $main["gnbCon"]["logo"];
			TweenLite.to(logoTitleMc, 1.0,{frame:logoTitleMc.totalFrames-1, onComplete:gnbTitleLoop});
		}
		
		private function gnbTitleLoop(evt:Event=null):void
		{
			var logoTitleMc:MovieClip = $main["gnbCon"]["logo"];
			TweenLite.to(logoTitleMc, 1.0,{frame:1, onComplete:gnbOnComplete});
		}
		
		//gnb OFF
		protected function gnbOff(event:PEventCommon=null):void
		{
			TweenLite.to($main, .5,{delay:.2, y:-129, onComplete:gnbOffEnd});
		}
		
		//gnb OFF(닫히고 버튼이미지 변경)
		private function gnbOffEnd():void
		{
			$main["bg2"]["closeBtn"].gotoAndStop(1);
		}
		
		//열렸다가 닫힘
		protected function gnbOnOff(event:PEventCommon=null):void
		{
			TweenLite.to($main, .5,{y:0});
			$main["bg2"]["closeBtn"].gotoAndStop(2);
			$gnbChk = false;
//			menuTimer();
		}
		
		//gnb 클릭
		protected function gnbCloseClick(evt:MouseEvent):void
		{
			if($gnbChk == false){
				_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_OPEN_OFF));
				$gnbChk = true;
				trace("$gnbChk : ",$gnbChk )
			}else{
				_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_OPEN_ON));
				$gnbChk = false;
				trace("$gnbChk : ",$gnbChk )
			}
		}
		
		protected function gnbCloseOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc = $main["bg2"]["closeBtn"]["overMc"]
			TweenLite.to(curMc, .4, {frame:curMc.totalFrames});
		}
		
		protected function gnbCloseOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc = $main["bg2"]["closeBtn"]["overMc"]
			TweenLite.to(curMc, .4, {frame:1});
		}
		
		public function menuTimer():void {
			mTimer = new Timer(1500,1);
			mTimer.addEventListener("timer", timerHandler);
			mTimer.start();
		}
		
		public function timerHandler(evt:TimerEvent):void {
			gnbOff(null);
		}
		
		//메뉴 버튼
		private function makeBtn():void
		{
			var i:int;
			$btnArr = [];
			for (i = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.gnbCon.btnCon.getChildByName("btn" + i) as MovieClip;
				btns.thumbCon.gotoAndStop(i + 1);
				btns.txtCon.gotoAndStop(i + 1);
				btns.no = i;
				$btnArr.push(btns);
				ButtonUtil.makeButton(btns, gnbHandler);
			}
			watchedMovieChk();
			trace("$btnArr   :::::::::::::::::::: ", $btnArr)
		}
		
		private function gnbHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					clearTimeout($id);
					activeBtn(target.no);
					
					break;
				case MouseEvent.MOUSE_OUT :
					$id = setTimeout(activeBtn,500,_model.activeMenu);
					
					break;
				case MouseEvent.CLICK :
					
					_model.activeBottonContent = false; 
					
					if(_model.watchedMov.length == 3 && _model.login == false){
						_model.mainPopupFrame = 6;
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
						return;
					}
					
					_model.activeMenu2 = target;
					trace("버튼 번호: " + target.no);
					
					
					/**	플레이 & 리턴	*/
					if(_model.botChk)
					{
						bottomActive(target.no);
						return;
					}
					else if(_model.activeMenu == target.no)
					{
						/**	현재 활성화된 영상이랑 같은 번호 눌렀을 때	*/
						changeMovie(target.no);
						_model.dispatchEvent(new PEventCommon(PEventCommon.DESTROY_INTERACTION));
						_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
						return;
					}
					
					var i:int;
					if(_model.watchedMov.length > 0)
					{
						/**	현재 영상이 봤던 영상이고 보지 않은 영상 버튼 눌렀을 때	*/
						for (i = 0; i < _model.watchedMov.length; i++) 
						{
							if(_model.watchedMov[i] == _model.activeMenu && _model.activeMenu != target.no)
							{
								_model.activeMenu = target.no;
								activeBtn(_model.activeMenu);
								changeMovie(_model.activeMenu);
								_model.dispatchEvent(new PEventCommon(PEventCommon.DESTROY_INTERACTION));
								_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
								return;
							}
						}
					}
					
					
					popupOpenCheck(target.no);					
					trace("팝업 띄울까________??:      " + $isPopup);
					/**	팝업을 띄웁시다	*/
					if($isPopup)
					{
						_controler.pauseMovie();
						_model.mainPopupFrame = 1;
						_model.dispatchEvent(new PEventCommon(PEventCommon.MAIN_POPUP_SHOW));
						trace("딴거 볼거냐 팝____________________업________!!");
						return;
					}
					
					/**	이미 본 영상일 경우 아래 진행	*/
					watchedMovie(target.no);
					
					break;
			}
		}
		
		private function watchedMovie(num:int):void
		{
			_model.activeMenu = num;
			changeMovie(_model.activeMenu);
			activeBtn(_model.activeMenu);
			_model.dispatchEvent(new PEventCommon(PEventCommon.DESTROY_INTERACTION));
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
			trace("영상 번호: ", _model.activeMenu);			
		}
		
		private function popupOpenCheck(num:int):void
		{
			/**	팝업 띄울지 말지 검사	*/
			$isPopup= true;
			if(_model.watchedMov.length > 0)
			{
				for (var i:int = 0; i < _model.watchedMov.length; i++) 
				{
					if(_model.watchedMov[i] == num)
					{
						$isPopup = false;
						break;
					}
					else
					{
						$isPopup = true;
					}
				}
			}
			
		}
		
		private function bottomActive(num:int):void
		{
			/**	이벤트 팝업 or 루트 팝업 활성화일 때	*/
			_model.botChk = false;
			_model.dispatchEvent(new PEventCommon(PEventCommon.BOT_REMOVE));
			_model.activeMenu = num;
			activeBtn(_model.activeMenu);
			changeMovie(_model.activeMenu);
			_model.dispatchEvent(new PEventCommon(PEventCommon.DESTROY_INTERACTION));
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));

		}
		/**	영상 플레이	*/
		private function changeMovie(movNum:int):void
		{
			
			if(movNum == 0){
				_controler.changeMovie([2,0]); //바바라스
			}else if(movNum == 1){
				_controler.changeMovie([2,2]); //수영장
			}else if(movNum == 2){
				_controler.changeMovie([2,3]); //밤쇼핑
			}
			
			
			else if(movNum == 3){
				_controler.changeMovie([3,0]); //골프
			}else if(movNum == 4){
				_controler.changeMovie([3,2]); //마사지
			}else if(movNum == 5){
				_controler.changeMovie([3,4]); //석양
			}
			
			
			else if(movNum == 6){
				_controler.changeMovie([4,0]); //기념품샵
			}else if(movNum == 7){
				_controler.changeMovie([4,1]); //씨푸드
			}
		}
		
		
		private function activeBtn(param0:int):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var pageBtn:MovieClip = $btnArr[i];
				pageBtn.buttonMode = true;                         //pageNum button
				if(i==param0){
					TweenLite.to(pageBtn.over,.5,{tint:0xfff400}); //pageNum color
				}else{
					TweenLite.to(pageBtn.over,.5,{tint:null});
				}
			}
		}
		
		/**	본 영상 체크	*/
		private function watchedMovieChk(e:Event = null):void
		{
			var i:int;
			var j:int;
			for (i = 0; i < $btnLength; i++) 
			{
				$btnArr[i].chk.alpha = 0;
				for (j = 0; j < _model.watchedMov.length; j++) 
				{
					if(_model.watchedMov[j] == i) $btnArr[i].chk.alpha = 1;
				}
				
			}
		}
		
		/**	배경 망점 & 위치	*/
		private function resizeHandler(e:Event = null):void
		{
			$main.bg.width = int($main.stage.stageWidth);
			$main.bg.x = int((stage.stageWidth - $main.bg.width)/2);
			$main.bg2.x = int((stage.stageWidth - $main.bg2.width)/2);
			$main.gnbCon.x = int((stage.stageWidth - $main.gnbCon.width)/2);
			
			$main.dotCon.graphics.clear();
			$main.dotCon.graphics.beginBitmapFill($dot);
			$main.dotCon.graphics.drawRect(0, 0, $main.bg.width, $main.bg.height);
			$main.dotCon.graphics.endFill();
		}
	}
}