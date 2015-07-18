package com.lol.control
{
	import com.greensock.TweenLite;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class PopupControl
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var btnCntArr:Array = [0, 0, 0];
		
		private var _popupArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _popup9BtnArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var _popup9BlockArr:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		public function PopupControl(con:MovieClip, popupArr:Vector.<MovieClip>, popup9BtnArr:Vector.<MovieClip>, popup9BlockArr:Vector.<MovieClip>)
		{
			_con = con;
			_popupArr = popupArr;
			_popup9BtnArr = popup9BtnArr;
			_popup9BlockArr = popup9BlockArr;
		}
		
		public function action(btnNum:int):void
		{
			var clickBtn:MovieClip = _popupArr[_model.popupNum]["btn" + _model.selectPopupBtnNum] as MovieClip;
			
			_popupArr[_model.popupNum].dimmed.visible = true;
			switch (_model.popupNum)
			{
				case 1 : 
					/**	롤 할래 말래	*/
					_model.videoNum = _model.videoList.interaction.mov[0].@videoNum;
					_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[0].mov[_model.selectPopupBtnNum];
					break;
				case 2 :
					/**	소환사 이름 짓기	*/
					if(_con.popup.popup2.txt.text == ""){
						if(_model.verEng == false) _model.userName = "명예로운유저";
						else _model.userName = "HonoredPlayer";
					}else{
						_model.userName = _con.popup.popup2.txt.text;
					}
					_model.isPopup = false;
					_model.videoNum = _model.videoList.interaction.mov[1].@videoNum;
					_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[1].@videoPath;
					break;
				case 3 : 
					/**	랜덤조합 가능 묻기	*/
					if(btnNum == 1){
						_model.isPopup = false;
						_model.videoNum = _model.videoList.interaction.mov[4].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[4].@videoPath;						
					}else{
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[3].mov[_model.randomMixNum];
						_model.videoNum = _model.videoList.interaction.mov[3].@videoNum;
					}
					_model.dispatchEvent(new LolEvent(LolEvent.HIDE_PANNING_BUTTON));
					break;
				case 4 : 
					/**	팀랭하자 팝업 0	*/
					if(btnNum == 0) {
						_model.videoNum = _model.videoList.interaction.mov[16].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[16].@videoPath;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[12].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[12].@videoPath;
					}
					break;
				case 5 : 
					/**	팀랭하자 팝업 1	*/
					if(btnNum == 0) {
						_model.videoNum = _model.videoList.interaction.mov[16].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[16].@videoPath;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[13].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[13].@videoPath;
					}
					break;
				case 6 :
					/**	팀랭하자 팝업 2	*/
					if(btnNum == 0) {
						_model.videoNum = _model.videoList.interaction.mov[16].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[16].@videoPath;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[14].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[14].@videoPath;
					}
					break;
				case 7 :
					/**	팀랭하자 팝업 3	*/
					if(btnNum == 0) {
						_model.videoNum = _model.videoList.interaction.mov[16].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[16].@videoPath;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[15].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[15].@videoPath;
					}
					break;
				case 8 : 
					/**	팀명 짓기	*/
					if(_con.popup.popup8.txt.text == ""){
						if(_model.verEng == false) _model.rankName = "팀랭크가좋아";
						else _model.rankName = "WeLoveRankedTeam";
					}else{
						_model.rankName = _con.popup.popup8.txt.text;
					}
					_model.isPopup = false; 
					_model.videoNum = _model.videoList.interaction.mov[17].@videoNum;
					_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[17].@videoPath;
					_model.dispatchEvent(new LolEvent(LolEvent.HIDE_PANNING_BUTTON));
					break;
				case 9 :
					/**	조합 선택	*/
					if(btnNum == -1){
						_model.combiNum = 3;
						clickBtn = _popupArr[_model.popupNum]["btn3"] as MovieClip;
					}else{
						_model.combiNum = btnNum;
					}
					clickCountChk(btnNum);
					
					clickBtn.btnBg.gotoAndStop(1);
					clickBtn.clickComp.gotoAndStop(1);
					TweenLite.to(clickBtn.btnBg, 0.66, {frame:clickBtn.btnBg.totalFrames});
					TweenLite.to(clickBtn.clickComp, 1, {frame:clickBtn.clickComp.totalFrames, onComplete:hideCombiPopup});
					_model.dispatchEvent(new LolEvent(LolEvent.HIDE_PANNING_BUTTON));
					return;
					break;
				case 10 :
					/**	소문내기 애교 0	*/
					if(btnNum == 0) {
						trace("유저 리워드 연결");
						_model.endingPopup = true;
						_model.popupNum = 14;
						_model.popupType = "popup";
						_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
						return;
					}else{
						_model.isPopup = false; 
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[30].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[30].@videoPath;
					}
					break;
				case 11 : 
					/**	소문내기 애교 1	*/
					if(btnNum == 0) {
						trace("유저 리워드 연결");
						_model.endingPopup = true;
						_model.popupNum = 14;
						_model.popupType = "popup";
						_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
						return;
					}else{
						_model.isPopup = false; 
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[31].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[31].@videoPath;
					}
					break;
				case 12 : 
					/**	소문내기 애교 2	*/
					if(btnNum == 0) {
						trace("유저 리워드 연결");
						_model.endingPopup = true;
						_model.popupNum = 14;
						_model.popupType = "popup";
						_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
						return;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[32].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[32].@videoPath;
					}
					break;
				case 13 : 
					/**	소문내기 애교 3	*/
					if(btnNum == 0) {
						trace("유저 리워드 연결");
						_model.endingPopup = true;
						_model.popupNum = 14;
						_model.popupType = "popup";
						_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
						return;
					}else{
						_model.isPopup = false;
						clickBtn = _popupArr[_model.popupNum]["btn1"] as MovieClip;
						_model.videoNum = _model.videoList.interaction.mov[33].@videoNum;
						_model.videoPath = _model.commonPath + _model.videoList.interaction.mov[33].@videoPath;
					}
					break;
			}
			
//			_model.dispatchEvent(new LolEvent(LolEvent.TIMER_STOP));
			clickBtn.clickComp.gotoAndStop(1);
			clickBtn.btnBg.gotoAndStop(1);
			TweenLite.to(clickBtn.clickComp, 1, {frame:clickBtn.clickComp.totalFrames, onComplete:hidePopup});
			TweenLite.to(clickBtn.btnBg, 0.66, {frame:clickBtn.btnBg.totalFrames});
		}
		
		/**	조합선택 팝업 닫기	*/
		private function hideCombiPopup():void
		{
			_model.selectPopupBtnNum = _model.combiNum;
			_model.dispatchEvent(new LolEvent(LolEvent.SELECT_TEAM_COMBINATION));
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_OFF));
			TweenLite.to(_popupArr[_model.popupNum], 0.75 , {autoAlpha:0});
		}
		
		/**	조합선택 클릭수 체크	*/
		private function clickCountChk(btnNum:int):void
		{
			if(btnNum == -1) return;
			
			btnCntArr[btnNum]++;
			for (var i:int = 0; i < btnCntArr.length; i++) 
			{
				if(btnCntArr[i] >= 2)
				{
					TweenLite.to(_popup9BtnArr[i].off, 0.5, {alpha:1});
					_popup9BlockArr[i].visible = true;
				}
			}
			if(_model.combiNum == 3){
				for (var j:int = 0; j < _popup9BlockArr.length; j++) 
				{		_popup9BlockArr[j].visible = true;			}
				setTimeout(popup9Reset, 1000);
			}
		}
		
		private function hidePopup():void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_CLOSE));
		}
		
		/**	팝업9 리셋	*/
		private function popup9Reset():void
		{
			for (var i:int = 0; i < btnCntArr.length; i++) 
			{
				btnCntArr = [0,0,0];
				_popup9BtnArr[i].off.alpha = 0;
				_popup9BlockArr[i].visible = false;
			}
		}
	}
}