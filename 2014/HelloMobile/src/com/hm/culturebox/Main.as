package com.hm.culturebox
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.hm.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;

	public class Main
	{
		
		private var _con:MovieClip;
		private var _artworkBG:ArtworkBG;
		
		private var _model:Model = Model.getInstance();
		
		private var _reLoad:Boolean = false;
		
		private var _rowLength:int = 23;
		private var _colLength:int = 22;
		private var _boxNum:int = 0;
		private var _tabBoxNum:int = 0;
		private var _boxChange:Boolean = false;
		private var _tabBtnLength:int = 2;
		
		private var _boxPlayClip:boxPlayClip;
		
		private var _boxArr:Array;
		private var _btnOnArr:Array;
		private var _btnOffArr:Array;
		private var _boxFaceFrame:Array = [
			[4,7,30,10,16,34,32],
			[31,1,9,26,19,14,13],
			[29,8,28,5,24,21],
			[3,25,18,27,11,35],
			[15,6,23,22,38,2],
			[37,20,36,12,33,17]
		];
		
		private var _hideBoxArr:Array;
		
		private var _colorArr:Array = [0x00BBDE, 0x913696, 0xFFCA08];
		private var _btnOffXArr:Array = [[null, 713, 976], [0, null, 976 ], [0, 264,null]];
		
		public function Main(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, ColorTransformPlugin, FramePlugin]);
			
			_artworkBG = new ArtworkBG(_con.ArtworkCon);
			
			_boxArr = [];
			var boxIdx:int;
			for (var i:int = 0; i < _colLength; i++) 
			{
				var rowGroup:Array = [];
				for (var j:int = 0; j < _rowLength; j++) 
				{
					var box:boxClip = new boxClip();
					box.row = j;
					box.col = i;
					if(i >= 20 && j >= 20)
					{
						box.x = -2000;
						box.y = -2000;
						box.visible = false;
					}
					else
					{
						box.x = j*53;
						box.y = i*54;
						box.no = boxIdx;
						boxIdx++;
					}
					var boxFaceFrame:int = _boxFaceFrame[i%6][j%(_boxFaceFrame[i%6].length)];
					box.face.gotoAndStop(boxFaceFrame);
					box.side.gotoAndStop(j+1);
					_con.boxCon.addChild(box);
					rowGroup.push(box);
					
					if(j > 11 )
					{
						_con.boxCon.setChildIndex(box, 1);
					}
					else if( j <= 11 && i > 0)
					{
						var idx:int = _con.boxCon.getChildIndex(_boxArr[i-1][j]);
						_con.boxCon.setChildIndex(box, idx-1);
					}
				}
				_boxArr.push(rowGroup);
			}
			
			_btnOnArr = [];
			_btnOffArr = [];
			for (var k:int = 0; k < _tabBtnLength; k++) 
			{
				var btnOn:MovieClip = _con.getChildByName("btnOn_" + k) as MovieClip;
				btnOn.no = k;
				_btnOnArr.push(btnOn);
				var btnOff:MovieClip = _con.getChildByName("btnOff_" + k) as MovieClip;
				btnOff.no = k;
				_btnOffArr.push(btnOff);
			}
			
			/**	박스 플레이 클립	*/
			_boxPlayClip = new boxPlayClip();
			_con.boxCon.addChild(_boxPlayClip);
			_boxPlayClip.stop();
			_boxPlayClip.visible = false;
			_boxPlayClip.x = -500;
			_boxPlayClip.y = -500;
			
			boxDataLoad();
		}
		
		private function boxDataLoad():void
		{
			/**	박스 정보 로드	*/
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			makeUrlLoader(vari, getBoxInfoComplete, _model.dataUrl + "process/cultureBoxCodeList.ashx");
		}
		
		private function initEventListener():void
		{
			if(ExternalInterface.available) ExternalInterface.addCallback("culTureBoxRateType", getUserInfo);
			
			for (var i:int = 0; i < _colLength; i++) 
			{
				for (var j:int = 0; j < _rowLength; j++) 
				{
					ButtonUtil.makeButton(_boxArr[i][j], selectBoxHandler);
				}
			}
			
			for (var k:int = 0; k < _tabBtnLength; k++) 
			{
				ButtonUtil.makeButton(_btnOffArr[k], tabBtnHandler);
			}
		}
		
		/**	사용자 정보 콜백 받음	*/
		protected function getUserInfo(type:int):void
		{
			// type : 1 => 영화		2 => 음악		3=> CJ one
			if(int(type) <=0 || int(type) > 3) return;
			
			_con.tabBtnBlockMC.visible = true;
			_con.blockMC.visible = false;
			_model.rateType = type;
			
			if(_tabBoxNum == int(type)-1) return;
			boxContentChange(int(type)-1);
		}
		/**	사용자 정보 로드 완료	*/
		private function getBoxInfoComplete(e:Event):void
		{
			_model.boxData = XML(e.target.data);
			trace(_model.boxData);
			
			_hideBoxArr = [];
			for (var i:int = 0; i < _model.boxData.contents.hideBox.length(); i++) 
			{
				var hideBox:Array = String(_model.boxData.contents.hideBox[i]).split(",");
				_hideBoxArr.push(hideBox);
			}
			
			JavaScriptUtil.call("sendBoxData", String(_model.boxData));
			_con.tabBtnBlockMC.visible = false;
			if(_reLoad == false) boxContentChange(1);
		}
		/**	URL로더 생성	*/
		private function makeUrlLoader(vari:URLVariables, fn:Function, url:String):void
		{
			var req:URLRequest = new URLRequest(url);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(req);
			urlLdr.addEventListener(Event.COMPLETE, fn);
		}
		
		/**	탭버튼 핸들러	*/
		private function tabBtnHandler(e:MouseEvent):void
		{
			if(_boxChange) return;
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target.bg, 0.65, {tint:_colorArr[target.no], ease:Cubic.easeOut});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(target.bg, 0.65, {tint:null, ease:Cubic.easeOut});
					break;
				case MouseEvent.CLICK :
					TweenLite.to(target.bg, 0.65, {tint:null, ease:Cubic.easeOut});
					boxContentChange(target.no); 
					break;
			}
		}
		/**	박스 배경 & 탭버튼 색상 변경	*/
		private function boxContentChange(contentNum:int):void
		{
			_boxChange = true;
			_model.boxTabNum = contentNum;
			_tabBoxNum = contentNum;
			setTimeout(boxChangeFalse, 2000);
			/**	배경 색상 변경 후 박스 앞면 변경	*/
			TweenLite.to(_con.boxBG, 0.65, {tint:_colorArr[contentNum], ease:Expo.easeOut, onCompleteParams:[contentNum], onComplete:boxFaceChange});
			for (var i:int = 0; i < _btnOnArr.length; i++) 
			{
				if(i == contentNum)
				{
					TweenLite.to(_btnOnArr[i], 0.65, {y:0, ease:Expo.easeOut});
					TweenLite.to(_btnOffArr[i], 0.65, {y:60, ease:Expo.easeOut});
				}
				else
				{
					TweenLite.to(_btnOnArr[i], 0.65, {y:88, ease:Expo.easeOut});
					TweenLite.to(_btnOffArr[i], 0.65, {y:17, ease:Expo.easeOut});
					/**	두번째 컨텐츠일시 탭메뉴 크기 변경	*/
//					if(contentNum == 1)
//					{
//						TweenLite.to(_btnOnArr[i], 0.65, {y:88, ease:Expo.easeOut});
//						if(_btnOffArr[i].y > 17) _btnOffArr[i].x = _btnOffXArr[contentNum][i];
//						TweenLite.to(_btnOffArr[i], 0.65, {
//							x:_btnOffXArr[contentNum][i], y:17, 
//							ease:Cubic.easeOut});
//						TweenLite.killTweensOf(_btnOffArr[i].bg);
//						TweenLite.to(_btnOffArr[i].txt, 0.65, {frame:_btnOffArr[i].txt.totalFrames, ease:Cubic.easeOut});
//						TweenLite.to(_btnOffArr[i].bg, 0.65, {tint:null, frame:_btnOffArr[i].bg.totalFrames, ease:Cubic.easeOut});
//					}
//					else
//					{
//						TweenLite.to(_btnOnArr[i], 0.65, {y:88, ease:Expo.easeOut});
//						if(_btnOffArr[i].y > 17) _btnOffArr[i].x = _btnOffXArr[contentNum][i];
//						TweenLite.to(_btnOffArr[i], 0.65, {
//							x:_btnOffXArr[contentNum][i], y:17, 
//							frame:1, 
//							ease:Cubic.easeOut});
//						TweenLite.killTweensOf(_btnOffArr[i].bg);
//						TweenLite.to(_btnOffArr[i].txt, 0.65, {frame:1, ease:Cubic.easeOut});
//						TweenLite.to(_btnOffArr[i].bg, 0.65, {tint:null, frame: 1, ease:Cubic.easeOut});
//					}
				}
			}
			/**	푸터 텍스트 변경	*/
			_con.footer.gotoAndStop(contentNum+1);
			/**	배경 아트웍 변경	*/
			_artworkBG.artworkChange(contentNum);
		}
		/**	박스 내용 변경	*/
		private function boxFaceChange(contentNum:int):void
		{
			for (var i:int = 0; i < _colLength; i++) 
			{
				for (var j:int = 0; j < _rowLength; j++) 
				{
					for (var k:int = 0; k < _tabBtnLength; k++) 
					{
						var showFace:MovieClip = _boxArr[i][j].face.getChildByName("c" + k) as MovieClip;
						if(k == contentNum)
						{
							_boxArr[i][j].face.setChildIndex(showFace, _boxArr[i][j].face.numChildren - 1);
							showFace.alpha = 0;
							TweenLite.to(showFace, 0.5, {delay:i*0.015 + j*0.015, 
								colorTransform:{exposure:1.05}, 
								reversed:true,  
								ease:Cubic.easeOut, 
								onStartParams:[showFace, _boxArr[i][j], contentNum], 
								onStart:boxFaceShow});
						}
					}
				}
			}
		}
		/**	박스페이스 변경 시작	*/
		private function boxFaceShow(showFace:MovieClip, box:MovieClip, contentNum:int):void
		{
			showFace.alpha = 1;
			
			var hide:Boolean = false;
			for (var j:int = 0; j < _hideBoxArr[contentNum].length; j++) 
			{
				if(int(box.no)+1 == int(_hideBoxArr[contentNum][j]))
				{
					hide = true;
					break;
				}
			}
			
			if(hide) TweenLite.to(box, 0.5, {autoAlpha:0});
			else TweenLite.to(box, 0.5, {autoAlpha:1});
		}
		/**	박스 변경 가능	*/
		private function boxChangeFalse():void
		{
			_boxChange = false;
			JavaScriptUtil.call("sendChangeBoxNum", String(_model.boxTabNum));
		}
		
		/**	박스 선택	*/
		private function selectBoxHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					target.visible = false;
					target.alpha = 0;
					
					_con.blockMC.visible = true;
					_boxNum = target.no;
					boxOpenPlay(target);
					break;
			}
		}
		/**	선택 박스 재생	*/
		private function boxOpenPlay(target:MovieClip):void
		{
			_boxPlayClip.x = target.x - 98;
			_boxPlayClip.y = target.y - 98;
			_boxPlayClip.face.gotoAndStop(target.face.currentFrame);
			
			for (var i:int = 0; i < _boxPlayClip.face.numChildren; i++) 
			{
				var face:MovieClip = _boxPlayClip.face.getChildByName("c" + i) as MovieClip;
				if(i == _tabBoxNum) face.alpha = 1;
				else face.alpha = 0;
			}
			
			_boxPlayClip.gotoAndPlay(1);
			_boxPlayClip.visible = true;
			_boxPlayClip.addEventListener(Event.ENTER_FRAME, boxPlayEndChk);
		}
		/**	박스플레이 종료 체크	*/
		private function boxPlayEndChk(e:Event):void
		{
			if(_boxPlayClip.currentFrame == _boxPlayClip.totalFrames)
			{
				_boxPlayClip.removeEventListener(Event.ENTER_FRAME, boxPlayEndChk);
				_boxPlayClip.visible = false;
				_boxPlayClip.x = -500;
				_boxPlayClip.y = -500;
				sendUserData();
			}
		}
		/**	선택 완료 사용자 정보 저장	*/
		private function sendUserData():void
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.rateType = _model.rateType;
			vari.boxNum = _boxNum + 1;
			trace(vari.rateType, vari.boxNum);
			makeUrlLoader(vari, sendUserInfoComplete, _model.dataUrl + "process/cultureBoxCodeSave.ashx");
		}
		/**	사용자 정보 저장 완료	*/
		private function sendUserInfoComplete(e:Event):void
		{
			var resultArr:Array = String(e.target.data).split("&");
			for (var i:int = 0; i < resultArr.length; i++) 
			{
				var sliceNum:int = int(String(resultArr[i]).indexOf("="))+1;
				resultArr[i] = String(resultArr[i]).slice(sliceNum);
			}
			trace("resultArr: " + resultArr);
			
			switch (int(resultArr[0]))
			{
				case 1:
				case 2:
					_reLoad = true;
					boxDataLoad();
					if(resultArr[1] == 0 || resultArr[1] == null) JavaScriptUtil.call("cultureBoxCodeSaveResult", resultArr[0]);
					else JavaScriptUtil.call("cultureBoxCodeSaveResult", resultArr[0], resultArr[1]);
					trace("이벤트 참여 완료");
					break;
				case -1:
					trace("코드확인 필요");
					break;
				case -2:
					trace("필수정보 값 부족");
					break;
			}
		}
	}
}