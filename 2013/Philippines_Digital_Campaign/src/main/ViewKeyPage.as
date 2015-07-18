package main 
{
	import com.adqua.movieclip.TestButton;
	import com.cj.utils.ArrayUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import orpheus.events.XMLLoaderEvent;
	import orpheus.nets.XMLLoader;
	import orpheus.utils.Debug;
	
	import pEvent.PEvent;
	import pEvent.PEventCommon;
	
	import util.KeyBoardUtil;
	import util.ONLineCheck;


	
	public class ViewKeyPage extends AbstractMCView
	{
		private var con:DisplayObject;
		private var $count:int = 12;
		private var $phoneNum:String;
		private var phoneNum:String;
		private var $checkNum:String;
		private var checkNumber:String;
		private var step:int;
		private var applyBoolean:Boolean;
		private var overCheck:Boolean;
		private var $endId:int;
		private var $keymenuMcBank:Array = [];
		private var $endIdBank:Array = [];
		private var $NumId:int;
		private var $curId:int;
		private var $randNum:Number;
		private var cellular:String;
		private var $keyMcNext:KeyMcNext;
		private var keyXml:XMLLoader;
		private var watchXml:XMLLoader;
		private var watchNum:Array;
		private var count:int;
		private var $blockMC:Sprite;
		private var $blockMC2:Sprite;
		
		public function ViewKeyPage(con:MovieClip)
		{
			super(con);
			setting();
		}
		
		override protected function onRemoved(event:Event):void
		{
			_mcView.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyEvent);
			super.onRemoved(event);
		}
		
		override public function setting():void
		{
			
			$keyMcNext = new KeyMcNext;
			_mcView.parent.addChild($keyMcNext);
			
			$blockMC = TestButton.btn(276,441);
			_mcView.parent.addChild($blockMC);
			$blockMC.alpha = 0;
			$blockMC.visible = false;
			
			$blockMC2 = TestButton.btn(276,441);
			$keyMcNext.addChild($blockMC2);
			$blockMC2.alpha = 0;
			$blockMC2.visible = false;
			
			$keyMcNext.x = 276;
			$keyMcNext.gotoAndStop(1);
			
			if(_model.userAuth == 1){
				step = 1;
				$keyMcNext.gotoAndStop(3); //인증했을때 페이지
				checkNext2();
			}
			
			$phoneNum = _mcView["phoneTxt"].text;
			$phoneNum = "";
			
			_mcView["keyNotice1"].visible = true;
			_mcView["phoneTxt"].text ="";
			_mcView["mcNumCover0"].addEventListener(MouseEvent.CLICK,onFocus0);
			_mcView["btn1"].buttonMode = true;
			_mcView["btn2"].buttonMode = true;
			_mcView["btn1"].addEventListener(MouseEvent.ROLL_OVER, checkOver);  
			_mcView["btn1"].addEventListener(MouseEvent.ROLL_OUT, checkOut);
			_mcView["btn2"].addEventListener(MouseEvent.ROLL_OVER, checkOver);  
			_mcView["btn2"].addEventListener(MouseEvent.ROLL_OUT, checkOut);
			
			_mcView["btn1"].addEventListener(MouseEvent.CLICK, btn1Click);   //그냥보기
			_mcView["btn2"].addEventListener(MouseEvent.CLICK, btn2Click);   //전화번호 입력완료(인증)
			
			_mcView["applyBtn"].buttonMode = true;
			_mcView["applyBtn"].addEventListener(MouseEvent.CLICK, applyClick); //동의버튼	
			
			
			for (var i:int = 0; i < $count; i++) 
			{
				var keyMenuMc:MovieClip = _mcView["keyCon"+i];
				keyMenuMc.id = i;
				keyMenuMc.keyOverMc.numPan.numMc.gotoAndStop(i);
				
				if(i == 0){
					keyMenuMc.keyOverMc.numPan.numMc.gotoAndStop(10);
				}else if(i == 10){ //delete
					keyMenuMc.keyOverMc.numPan.numMc.gotoAndStop(11);
				}else if(i == 11){ //all delete
					keyMenuMc.keyOverMc.numPan.numMc.gotoAndStop(12);
				}
				
				keyMenuMc.mouseChildren = false;
				keyMenuMc.buttonMode = true;
				keyMenuMc.addEventListener(MouseEvent.ROLL_OVER, numOver);
				keyMenuMc.addEventListener(MouseEvent.ROLL_OUT, numOut);
				keyMenuMc.addEventListener(MouseEvent.CLICK, numClick); //키패드버튼
				$keymenuMcBank.push(keyMenuMc);
				_mcView.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyEvent);
			}
			
			_mcView.stage.scaleMode = "noScale";
			_mcView.stage.align = "TL";
			
			_model.addEventListener(PEventCommon.NOTICE_START, keyNoticeStart)
		}
		
		protected function keyNoticeStart(evt:PEventCommon):void
		{
			_mcView["keyNotice1"].gotoAndPlay(2);
		}
		//인증팝업
		protected function onFocus1(event:MouseEvent):void
		{
			if(step==1){
				$keyMcNext["keyNotice2"].visible = false;
				$keyMcNext["mcCursor1"].alpha = 1;
			}else{
				Debug.alert("전화번호 입력 후 입력완료 버튼을 눌러주세요");
			}
		}
		
		protected function onFocus0(event:MouseEvent):void
		{
			_mcView["keyNotice1"].visible = false;
			_mcView["mcCursor0"].alpha = 1;
		}
		
		protected function keyEvent(evt:KeyboardEvent):void
		{
//			trace("keyEvent//////////////event.keyCode: ",evt.keyCode);
			KeyBoardUtil.checkNumPad(evt.keyCode,$keymenuMcBank);
		}
		
		private function applyClick(evt:MouseEvent):void
		{
			trace("[동의하기]")
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			if(!applyBoolean){
				curMc.gotoAndStop(2);
				applyBoolean = true;
			}else{
				curMc.gotoAndStop(1);
				applyBoolean = false;
			}
		}
		
		private function btn1Click(evt:MouseEvent):void
		{
			if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_main_Pass");
			$blockMC.visible = true;
			trace("[그냥하기]");
			$keyMcNext.gotoAndStop(2);
			checkView();
			_model.dispatchEvent(new PEventCommon(PEventCommon.KEY_NEXT_MOV));
			TweenLite.delayedCall(.5,function():void{$blockMC.visible = false;});
		}
		
		private function btn2Click(evt:MouseEvent):void
		{
		
			if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_main_Call");
			trace("입력완료")
			trace("ViewKeyPage:::::::::applyBoolean:::::",applyBoolean);
			if(applyBoolean){
				if(_mcView["phoneTxt"].text == ""){
					Debug.alert("전화번호를 입력해주세요.");
				}else{
					keyXml = new XMLLoader();
					keyXml.addEventListener(XMLLoaderEvent.XML_COMPLETE, userInfoSaved);
					var urlVars:URLVariables = new URLVariables;
					urlVars.cellular = _mcView["phoneTxt"].text;
					_model.phoneNum = urlVars.cellular;
					var loadURL:String = _model.urlUserInfo[ONLineCheck.url()];
					keyXml.load(loadURL,urlVars);
					trace("loadURL : ", loadURL)
					$blockMC.visible = true;
				}
			}else{
				Debug.alert("개인정보 활용에 동의해주세요.");
			}
			
		}
		//전화번호 날리고 받았을때
		protected function userInfoSaved(event:XMLLoaderEvent):void
		{
			var keyResult:XML = event.xml;
			
			//8개 다 보면 movieAllWatched 값이 true
			_model.allWatched =  keyResult.movieAllWatched;
			
			//발송성공
			if(keyResult.result == "1"){
				_model.login = true;
				step = 1;
				$keyMcNext.gotoAndStop(1); //인증 안한경우
				checkNext();
				$keyMcNext["checkTxt"].text = "";
				$keyMcNext["checkTxt"].maxChars = 3;
				
			}else if(keyResult.result == "2"){
				_model.userAuth = 1;
				_model.login = true;
				step = 1;
				$keyMcNext.gotoAndStop(3); //인증 한경우
				checkNext2();
				
			}else {
				
//				Debug.alert(keyResult.result)
				if(keyResult.result == "-2"){
					Debug.alert("잠시 뒤에 접속하세요")
				}else if(keyResult.result == "-1"){
					Debug.alert("전화번호를 확인 후 다시 입력해주세요.")
				}
			}
			
			_model.dispatchEvent(new PEventCommon(PEventCommon.KEY_NEXT_MOV));
			TweenLite.delayedCall(.5,function():void{$blockMC.visible = false;});
			keyXml.removeEventListener(XMLLoaderEvent.XML_COMPLETE,userInfoSaved);
		}
		
		//인증페이지(1)
		private function checkNext():void
		{
			$keyMcNext["checkTxt"].text = "";
			$keyMcNext["checkTxt"].selectable = false;
			
			$keyMcNext["keyNotice2"].visible = true;
			$keyMcNext["mcNumCover1"].addEventListener(MouseEvent.CLICK,onFocus1); //인증텍스트포커스
			$keyMcNext["closeBtn"].buttonMode = true;
			$keyMcNext["closeBtn"].addEventListener(MouseEvent.CLICK, chkClose); // 팝업close
			$keyMcNext["btn"].buttonMode = true;
			$keyMcNext["btn"].addEventListener(MouseEvent.ROLL_OVER, checkOver);   //
			$keyMcNext["btn"].addEventListener(MouseEvent.ROLL_OUT, checkOut);   //
			$keyMcNext["btn"].addEventListener(MouseEvent.CLICK, checkClick);   //인증번호전송 (첫영상통화하기)
		}
		
		//인증페이지(3)
		protected function checkNext2():void
		{
			$keyMcNext["btn2"].buttonMode = true;
			$keyMcNext["btn2"].addEventListener(MouseEvent.ROLL_OVER, checkOver); 
			$keyMcNext["btn2"].addEventListener(MouseEvent.ROLL_OUT, checkOut); 
			$keyMcNext["btn2"].addEventListener(MouseEvent.CLICK, userAuthClick); //재인증 (영상통화계속하기)
		}
		
		//그냥보기페이지(2)
		protected function checkView():void
		{
			$keyMcNext["btn0"].buttonMode = true;
			$keyMcNext["btn0"].addEventListener(MouseEvent.ROLL_OVER, checkOver); 
			$keyMcNext["btn0"].addEventListener(MouseEvent.ROLL_OUT, checkOut); 
			$keyMcNext["btn0"].addEventListener(MouseEvent.CLICK, keyNextBtn0); //그냥보기 (번호입력하기)
			$keyMcNext["btn1"].buttonMode = true;
			$keyMcNext["btn1"].addEventListener(MouseEvent.ROLL_OVER, checkOver); 
			$keyMcNext["btn1"].addEventListener(MouseEvent.ROLL_OUT, checkOut); 
			$keyMcNext["btn1"].addEventListener(MouseEvent.CLICK, keyNextBtn1); //그냥보기 (그냥하기)
	
		}
		private function keyNextBtn0(evt:MouseEvent):void
		{
			trace("btn0 : 번호입력하기");
//			step = 0;
			_mcView["phoneTxt"].text = "";
			$phoneNum = "";
			_mcView["keyNotice1"].visible = true;
			_mcView["keyNotice1"].gotoAndPlay(2);
			_model.dispatchEvent(new PEventCommon(PEventCommon.KEY_PREV_MOV));
			
		}
		private function keyNextBtn1(evt:MouseEvent):void
		{
			trace("btn1 : 그냥보기");		
			//인증체크값 (그냥보기)
//			_model.userAuth = 0;
			
			//3개 다 봤을때 
			if(_model.watchedMov.length == 3){
				Debug.alert("그냥하기로 한 경우,영상통화는 3번만 가능합니다. \n 영상통화를 계속 하고 싶으시면 \n 전화번호를 입력해 주세요.");
				
			}else{
				_controler.changeMovie([2,0]);
				_model.dispatchEvent(new PEventCommon(PEventCommon.MAKE_DAYBG));
			}
			
		}
		
		private function chkClose(event:MouseEvent = null):void
		{
			trace("닫기");
			
			step = 0;
			_mcView["phoneTxt"].text = "";
			$phoneNum = "";
			
			$keyMcNext["checkTxt"].text = "";
			$checkNum = "";
			
			_mcView["keyNotice1"].visible = true;
			//			_mcView["keyNotice1"].gotoAndPlay(2);
			
			_model.dispatchEvent(new PEventCommon(PEventCommon.KEY_PREV_MOV));
		}
		
		protected function checkClick(evt:MouseEvent):void
		{
			trace("[인증번호전송]==================================");
			
			if(_mcView["phoneTxt"].text == ""){
				Debug.alert("전화번호를 입력해주세요.");
			}else if($keyMcNext["checkTxt"].text == ""){
				if(step != 1){
					Debug.alert("전화번호를 정확히 입력해주세요.");
				}else{
					Debug.alert("인증번호를 입력해주세요.");
				}
			}else{
				trace("인증번호 저장");
				authClick();
			}
		}
		
		protected function authClick(evt:MouseEvent=null):void
		{
			keyXml = new XMLLoader();
			keyXml.addEventListener(XMLLoaderEvent.XML_COMPLETE,userAuthComplete);
			
			var urlVars:URLVariables = new URLVariables;
			urlVars.cellular = _model.phoneNum;
			urlVars.authNum  = $keyMcNext["checkTxt"].text;
			
			var loadURL:String = _model.urlAuth[ONLineCheck.url()];
			keyXml.load(loadURL, urlVars);
		}
		
		//6개 인증번호 return xml
		protected function userAuthComplete(event:XMLLoaderEvent):void
		{
			var keyResult:XML = event.xml;
			
			//발송성공
			if(keyResult.result == "1"){
				userAuthClick()
				
				//인증체크값(인증했을때)
				_model.userAuth = 1;
				
			}else{
//				Debug.alert(keyResult.result)
					
				if(keyResult.result == "-2"){
					$keyMcNext["mcCursor1"].visible = true;
					$keyMcNext["mcCursor1"].alpha = 1;
					
					$keyMcNext["checkTxt"].text = "";
					$checkNum = "";
					Debug.alert("인증번호를 다시 입력해 주세요.")
				}	
			}
		}		
		
		protected function userAuthClick(evt:MouseEvent=null):void
		{
			$blockMC2.visible = true;
			
			watchNum = _model.watchedMov;
			
			//영상8개 봤을때 첫무비로
			if(watchNum.length == 8){
				_controler.changeMovie([2,0]);
				_model.dispatchEvent(new PEventCommon(PEventCommon.MAKE_DAYBG));
				return;
			}
			xmlUserLoad();
			TweenLite.delayedCall(.8,function():void{$blockMC2.visible = false;});
			
//			if(watchNum.length > 0){
//				xmlUserLoad();
//			}else{
//				watchComplete();
//			}
		}
		protected function xmlUserLoad():void
		{
			
			watchXml = new XMLLoader();
			watchXml.addEventListener(XMLLoaderEvent.XML_COMPLETE, userWatchComplete);
			if(watchNum.length > 0){
				var urlVars:URLVariables = new URLVariables;
				urlVars.movNum = watchNum[count];
				trace("-------------------------------------")
				trace("_model.watchedMov : ", _model.watchedMov)
				trace("count : ", count)
				trace("-----------------------------------------------------------")
			}
			
			var loadURL:String = _model.urlWatch[ONLineCheck.url()];
			watchXml.load(loadURL, urlVars);
			
		}
		
		protected function userWatchComplete(event:XMLLoaderEvent):void
		{
			$blockMC2.visible = true;
			
			var watchResult:XML = event.xml;
			trace("ss : ",String(watchResult.watchedMovie).length)
			
			if(String(watchResult.watchedMovie).length > 0)
			{
				_model.watchedMov = watchResult.watchedMovie.split(",");
			}
			
			count++;
			if(count < watchNum.length){
				xmlUserLoad();
				
			}else{
				count = 0;
				watchComplete();
			}
		}		
		
		protected function watchComplete(evt:MouseEvent = null):void
		{
//			$blockMC2.visible = false;
			TweenLite.delayedCall(.8,function():void{$blockMC2.visible = false;});
			
			var notWatched:Array = ArrayUtil.diff(_model.menuBank,_model.watchedMov);		
			
			if(notWatched.length>0 && notWatched.length<_model.menuBank.length){
				_controler.changeMovie(_model.watchedMov2[notWatched[0]]);
			}else{
				_controler.changeMovie([2,0]); // Day 처음시작
				trace("여기 2,0!!!!!!!!!!!!!!!!!!!!!!!");
			}
			_model.activeMenu = notWatched[0];
			_model.underMovTitleSetting = _model.activeMenu + 1;
			
			_model.dispatchEvent(new PEvent(PEvent.ACTIVE_MENU_CHECK));
			_model.dispatchEvent(new PEventCommon(PEventCommon.GNB_ACTIVE_ON));
			_model.dispatchEvent(new PEventCommon(PEventCommon.POPBG_HIDE));
			_model.dispatchEvent(new PEventCommon(PEventCommon.MAKE_DAYBG));
			
			
		}		
		
		
		private function numOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndPlay(2);
		}
		private function numOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			curMc.gotoAndStop(1);
		}
		private function numClick(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			$curId = curMc.id;
			$randNum = Math.ceil(Math.random()*3);
			
			resetNumMC();
			FrameUtil.arriveFrame(curMc, 16, keyEnded);

			
			//인증번호 입력
			if(step == 1){
				$keyMcNext["keyNotice2"].visible = false;
				$keyMcNext["mcCursor1"].visible = false;
				
				
				if($curId == 10){
					$checkNum = $checkNum.substr(0, $checkNum.length-1);
					$keyMcNext["checkTxt"].text = $checkNum;
				}else{
					$checkNum += $curId
					$keyMcNext["checkTxt"].text = $checkNum;
					if($checkNum.length > 6){
						$checkNum = $checkNum.substr(0, $checkNum.length-1);
						$keyMcNext["checkTxt"].text = $checkNum;
					}
				}
				checkNumber = $checkNum;
				trace("checkTxt          : ", checkNumber);
				
			//전화번호 입력
			}else{
				_mcView["mcCursor0"].visible = false;
				_mcView["keyNotice1"].visible = false;
				//지움
				if($curId == 10){
					$phoneNum = $phoneNum.substr(0, $phoneNum.length-1);
					_mcView["phoneTxt"].text = $phoneNum;
				}else if($curId == 11){
					$phoneNum = "";
					_mcView["phoneTxt"].text = "";
				}else{
					$phoneNum += $curId
					_mcView["phoneTxt"].text = $phoneNum;
					
					if($phoneNum.length > 11){
						$phoneNum = $phoneNum.substr(0, $phoneNum.length-1);
						
						_mcView["phoneTxt"].text = $phoneNum;
					}
				}
				cellular = $phoneNum;
				trace("phoneTxt : ", cellular);		
			}
		}
		
		private function resetNumMC():void
		{
			for (var i:int = 0; i < 12; i++) 
			{
				var keyMenuMc:MovieClip = _mcView["keyCon"+i];
				keyMenuMc.gotoAndStop(1);
			}
		}
		
		private function keyEnded():void
		{
//			$keymenuMcBank[$endId].stop();
		}
		
		protected function checkOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			TweenLite.to(curMc,.5,{tint:0xffffff});
		}
		protected function checkOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			TweenLite.to(curMc,.5,{tint:null});
		}
		
	}
}