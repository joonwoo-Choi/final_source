package main
{
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import pEvent.PEventCommon;
	
	import popup.MainPopup;
	

	[SWF(width="1280",height="850",frameRate="30")]
	public class Main extends AbstractMain
	{
		private var $mainBg:IntroMc;
		private var $keyMc:KeyMc;
		private var $keyMcView:ViewKeyPage;
		private var $backBg:BackMc;
		private var $peopleCon:PeopleMc;
		private var $peopleView:ViewMain;
		private var $titleCon:TitleMc;
		private var $keyCover:KeyCover;
		private var $keyNextMc:KeyMcNext;
		
		public function Main()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			//back 배경이미지
			$backBg = new BackMc;
			addChild($backBg);
			
			//back 배경이미지 랜덤값
			var keyMovNum:int = Math.ceil(Math.random()*3)-1;
			
//			var url:String = SecurityUtil.getPath(root)+_model.xmlData.mainbg[0].list[keyMovNum].@img;
			var url:String = _model.xmlData.mainbg[0].list[keyMovNum].@img;
			var thumbLoader:ImageLoader = new ImageLoader(url,{
				container:$backBg.bgCon, 
				smoothing:true,
				x:0,
				width: 1600, height: 900,
				onComplete:imgShow,
				alpha:1
			});
			thumbLoader.load(); 
			
			//타이틀
			$titleCon = new TitleMc;
			addChild($titleCon);
			$titleCon.gotoAndStop(keyMovNum+1);
			
			//에일리
			$peopleCon = new PeopleMc;
			addChild($peopleCon);
			$peopleCon.alpha = 0;
			$peopleView = new ViewMain($peopleCon);
			
			//bgCover
			$mainBg = new IntroMc;
			addChild($mainBg);
				
			//키패드커버
			$keyCover = new KeyCover;
			addChild($keyCover);
			$keyCover.alpha  = 0;
			
			
			//키패드
			$keyMc = new KeyMc;
			$keyCover["keyLoadCon"].addChild($keyMc);
			$keyCover["keyLoadCon"].x = 28;
			$keyMcView = new ViewKeyPage($keyMc);
			
			//키패드 next창
			$keyNextMc = new KeyMcNext;
			
			
			//back 배경이미지 MoveHandler
			TweenLite.to($mainBg["bgCover"], .5,{delay:.5,onComplete:mainBgMovStart});
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
			
			_model.addEventListener(PEventCommon.KEY_NEXT_MOV,keyNextMov);
			_model.addEventListener(PEventCommon.KEY_PREV_MOV,keyPrevMov);

			super.onAdded(event);
			
			if(_model.userAuth == 1){
				$keyCover["keyLoadCon"].x = -248;
			}
			
			//메인셋팅
			TweenLite.delayedCall(0.3,mainStartSetting);
			
		}
	
		protected function mainStartSetting():void
		{
			$peopleCon.x = int(_model.sw - $peopleCon.width)/2 - 300;
			$keyCover.x = int($titleCon.x +  $titleCon.width)+10;
			
			$titleCon.titleM1.gotoAndPlay(2);
			$titleCon.titleM2.gotoAndPlay(2);
			$titleCon.titleBg.gotoAndPlay(2);
			
			setTimeout(introMotion,1500);
				
			/**	시간	*/
			$keyCover.addEventListener(Event.ENTER_FRAME, timeChange);
		}
		
		/** 에일리 키패드 등장 모션 */
		private function introMotion():void
		{
			TweenLite.to($peopleCon, 0.6, {x:$peopleCon.x + 100, alpha:1,easing:Cubic.easeInOut});
			TweenLite.to($keyCover, 0.6, {x:$keyCover.x -100,alpha:1,onComplete:keyNoticeStart,easing:Cubic.easeInOut});
		}
		
		
		private function timeChange(e:Event):void
		{
			var date:Date = new Date();
			var hour:int = date.hours;
			var minutes:int = date.minutes;
			
			/**	AM PM 셋팅	*/
			if(hour >= 12 && hour < 24) $keyCover.apm.text = "PM";
			else $keyCover.apm.text = "AM";
			$keyCover.apm.autoSize = TextFieldAutoSize.LEFT;
			
			/**	24시간 변환	*/
			if(hour > 12) hour = hour - 12;
			else if(hour >= 24) hour = 0;
			
			var minutesTxt:String = String(minutes);
			if(minutes < 10) minutesTxt = "0" + minutes;
			
			$keyCover.time.text = hour + ":" + minutesTxt;
			$keyCover.time.autoSize = TextFieldAutoSize.RIGHT;
//			trace($keyCover.time.text, $keyCover.apm.text);
		}
		
		private function keyNoticeStart(evt:PEventCommon=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.NOTICE_START));
			
		}
		
		override protected function onRemoved(event:Event):void
		{
			_model.removeEventListener(PEventCommon.KEY_NEXT_MOV,keyNextMov);
			_model.removeEventListener(PEventCommon.KEY_PREV_MOV,keyPrevMov);
		}
		
		protected function keyNextMov(evt:Event):void
		{
			var keyNext:MovieClip = $keyCover["keyLoadCon"];
			TweenLite.to(keyNext, .5, {x:-248});
		}
		
		protected function keyPrevMov(evt:Event):void
		{
			var keyNext:MovieClip = $keyCover["keyLoadCon"];
			TweenLite.to(keyNext, .5, {x:28});
		}
		
		
		protected function imgShow(evt:LoaderEvent):void
		{
//			TweenLite.to(evt.target.content, .5,{alpha:1});
		}
		
		private function mainBgMovStart(evt:Event=null):void
		{
			$mainBg["bgCover"].addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}		
		
		protected function moveHandler(evt:MouseEvent):void
		{
			var moveNumX:int = int(stage.stageWidth/2 - $backBg.width/2) + (stage.stageWidth/2 - stage.mouseX) / 40;
			var moveNumY:int = int(stage.stageHeight/2 - $backBg.height/2) + (stage.stageHeight/2 - stage.mouseY) / 40;
			TweenLite.killTweensOf($backBg);
			TweenLite.to($backBg, 0.5, {x:moveNumX, y:moveNumY});
		}
		
		
		protected function onResize(event:Event=null):void
		{
			
			if($backBg){
				TweenLite.killTweensOf($backBg);
				$backBg.width = _model.sw + 50;
				$backBg.height = _model.sh + 50;
				$backBg.scaleX = $backBg.scaleY = Math.max($backBg.scaleX, $backBg.scaleY);
				_model.objW2 = $backBg.width;			
				_model.objH2 = $backBg.height;	
//				$backBg.x = int(_model.objW2 - $backBg.width)/2;
//				$backBg.y = int(_model.objH2 - $backBg.height)/2;
				$backBg.x = int((_model.sw - $backBg.width)/2);
				$backBg.y = int((_model.sh - $backBg.height)/2);
				
			}
			
			if($titleCon){
				$titleCon.x = int((_model.sw - $titleCon.width)/2 + 55);
				$titleCon.y = int((_model.sh - $titleCon.height)/2 - 120);
			}
			if($peopleCon){
				$peopleCon.scaleX = $backBg.scaleX;
				$peopleCon.scaleY = $backBg.scaleY;
				
				if($backBg.scaleX > 1.1 && $backBg.scaleY > 1.1){
					_model.pepleScaleX = $peopleCon.scaleX = 1.1;
					_model.pepleScaleY = $peopleCon.scaleY = 1.1;
				}else{
					_model.pepleScaleX = $peopleCon.scaleX;
					_model.pepleScaleY = $peopleCon.scaleY;
				}
				$peopleCon.x = int((_model.sw - $peopleCon.width)/2 - 200);
				$peopleCon.y = int((_model.sh - $peopleCon.height) + 35);
			}
			
			if($mainBg){
				$mainBg.x = int((_model.sw - $mainBg.width)/2);
				$mainBg.y = int((_model.sh - $mainBg.height)/2);
			}
			
			if($keyCover){
				$keyCover.x = int(($titleCon.x +  $titleCon.width)-90);
				$keyCover.y = int((_model.sh - $keyCover.height)/2);
				
			}
			
		}		
	}
}