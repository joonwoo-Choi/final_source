package com.lol.control
{
	
	import com.lol.events.LolEvent;
	import com.lol.font.SetFont;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SwfTextSetting
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _setFont:SetFont;
		private var _movMC:MovieClip;
		
		public function SwfTextSetting()
		{
			_setFont = new SetFont();
		}
		
		public function swfTxtSetting(mc:MovieClip):void
		{
			_movMC = mc;
			if(_model.videoNum == 1){
				_setFont.setYgdFont(_movMC.userName.txt);
				_setFont.setYgdFont(_movMC.userName2.txt);
				_setFont.setYgdFont(_movMC.userName3.txt);
				_movMC.userName.txt.text = _model.userName;
				_movMC.userName2.txt.text = _model.userName;
				_movMC.userName3.txt.text = _model.userName;
			}
			if(_model.videoNum == 2){
				_setFont.setYgdFont(_movMC.userName.txt);
				_movMC.userName.txt.text = _model.userName;
			}
			if(_model.videoNum == 4){
				_movMC.chatmc.gotoAndStop(_model.randomMixNum + 1);
				_setFont.setYgdFont(_movMC.userName.txt);
				_setFont.setRixFont(_movMC.chatmc.mc.txt);
				_setFont.setRixFont(_movMC.chatmc.mc.userTxt2.txt);
				
				_movMC.userName.txt.text = _model.userName;
				_movMC.userName.txt.autoSize = TextFieldAutoSize.CENTER;
				
				settingUserTxt(_movMC.chatmc.mc.txt, _movMC.chatmc.mc.txtMc);
				settingUserTxt(_movMC.chatmc.mc.userTxt2.txt, _movMC.chatmc.mc.userTxt2.txtMc);
			}
			if(_model.videoNum == 8){
				_setFont.setRixFont(_movMC.userName.txt);
				_movMC.userName.txt.text = _model.userName;
				_movMC.userName.txt.autoSize = TextFieldAutoSize.LEFT;
				_movMC.userName.txtMc.x = _movMC.userName.txt.x + _movMC.userName.txt.width;
			}
			if(_model.videoNum == 10){
				_setFont.setRixFont(_movMC.userName2.txt);
				_setFont.setRixFont(_movMC.userName3.txt);
				_setFont.setRixFont(_movMC.userName4.txt);
				
				_movMC.userName2.txt.text = _model.userName;
				_movMC.userName3.txt.text = _model.userName;
				
				settingUserTxt(_movMC.userName4.txt, _movMC.txtMc);
			}
			if(_model.videoNum == 17){
				_setFont.setYgdFont(_movMC.userName.txt);
				_setFont.setYgdFont(_movMC.userName1.txt);
				_setFont.setYgdFont(_movMC.userName2.txt);
				_setFont.setYgdFont(_movMC.userName4.txt);
				_setFont.setYgdFont(_movMC.userName5.txt);
				_setFont.setYgdFont(_movMC.userName6.txt);
				_setFont.setYgdFont(_movMC.userName7.txt);
				_setFont.setYgdFont(_movMC.rankName.txt);
				
				_movMC.userName.txt.text = _model.userName;
				_movMC.userName1.txt.text = _model.userName;
				_movMC.userName2.txt.text = _model.userName;
				_movMC.userName6.txt.text = _model.userName;
				_movMC.userName7.txt.text = _model.userName;
				_movMC.rankName.txt.text = _model.rankName;
				
				settingUserTxt(_movMC.userName4.txt, _movMC.userName4.txtMc);
				settingUserTxt(_movMC.userName5.txt, _movMC.userName5.txtMc);
				settingUserTxt(_movMC.userName6.txt, _movMC.userName6.txtMc);
			}
			if(_model.videoNum == 18){
				_setFont.setYgdFont(_movMC.userName.txt);
				_setFont.setYgdFont(_movMC.userName1.txt);
				_setFont.setYgdFont(_movMC.userName2.txt);
				_setFont.setYgdFont(_movMC.userName3.txt);
				_setFont.setYgdFont(_movMC.rankName.txt);
				_setFont.setYgdFont(_movMC.rankName1.txt);
				_setFont.setYgdFont(_movMC.rankName2.txt);
				_setFont.setYgdFont(_movMC.rankName3.txt);
				_setFont.setYgdFont(_movMC.rankName4.txt);
				_setFont.setYgdFont(_movMC.rankName5.txt);
				
				_setFont.setRixFont(_movMC.loadCon.txt0_0.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt0_0.userName1.txt);
				_setFont.setRixFont(_movMC.loadCon.txt0_1.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt0_1.userName1.txt);
				
				_setFont.setRixFont(_movMC.loadCon.txt1_0.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt1_0.userName1.txt);
				_setFont.setRixFont(_movMC.loadCon.txt1_1.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt1_1.userName1.txt);
				
				_setFont.setRixFont(_movMC.loadCon.txt2_0.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt2_0.userName1.txt);
				_setFont.setRixFont(_movMC.loadCon.txt2_1.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt2_1.userName1.txt);
				
				_setFont.setRixFont(_movMC.loadCon.txt3.userName.txt);
				_setFont.setRixFont(_movMC.loadCon.txt3.userName1.txt);
				
				_movMC.userName.txt.text = _model.userName;
				_movMC.userName1.txt.text = _model.userName;
				_movMC.userName2.txt.text = _model.userName;
				_movMC.userName3.txt.text = _model.userName;
				_movMC.rankName.txt.text = _model.rankName;
				_movMC.rankName1.txt.text = _model.rankName;
				_movMC.rankName2.txt.text = _model.rankName;
				_movMC.rankName3.txt.text = _model.rankName;
				_movMC.rankName4.txt.text = _model.rankName;
				_movMC.rankName5.txt.text = _model.rankName;
				
				settingUserTxt(_movMC.loadCon.txt0_0.userName.txt, _movMC.loadCon.txt0_0.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt0_0.userName1.txt, _movMC.loadCon.txt0_0.userName1.txtMc);
				settingUserTxt(_movMC.loadCon.txt0_1.userName.txt, _movMC.loadCon.txt0_1.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt0_1.userName1.txt, _movMC.loadCon.txt0_1.userName1.txtMc);
				
				settingUserTxt(_movMC.loadCon.txt1_0.userName.txt, _movMC.loadCon.txt1_0.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt1_0.userName1.txt, _movMC.loadCon.txt1_0.userName1.txtMc);
				settingUserTxt(_movMC.loadCon.txt1_1.userName.txt, _movMC.loadCon.txt1_1.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt1_1.userName1.txt, _movMC.loadCon.txt1_1.userName1.txtMc);
				
				settingUserTxt(_movMC.loadCon.txt2_0.userName.txt, _movMC.loadCon.txt2_0.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt2_0.userName1.txt, _movMC.loadCon.txt2_0.userName1.txtMc);
				settingUserTxt(_movMC.loadCon.txt2_1.userName.txt, _movMC.loadCon.txt2_1.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt2_1.userName1.txt, _movMC.loadCon.txt2_1.userName1.txtMc);
				
				settingUserTxt(_movMC.loadCon.txt3.userName.txt, _movMC.loadCon.txt3.userName.txtMc);
				settingUserTxt(_movMC.loadCon.txt3.userName1.txt, _movMC.loadCon.txt3.userName1.txtMc);
			}
			if(_model.videoNum == 20){
				_setFont.setRixFont(_movMC.rankName.rankName.txt);
				
				_movMC.rankName.rankName.txt.text = _model.rankName;
				_movMC.rankName.rankName.txt.autoSize = TextFieldAutoSize.LEFT;
				_movMC.rankName.txtMc.x = _movMC.rankName.rankName.txt.x + _movMC.rankName.rankName.txt.width;
				
				_movMC.rankName.x = int(1280/2 - _movMC.rankName.width/2);
			}
			if(_model.videoNum == 28){
				_setFont.setRixFont(_movMC.userName2.txt);
				_setFont.setRixFont(_movMC.userName3.txt);
				_setFont.setRixFont(_movMC.userName5.txt);
				
				_movMC.userName2.txt.text = _model.userName;
				_movMC.userName3.txt.text = _model.userName;
				
				settingUserTxt(_movMC.userName5.txt, _movMC.userName5.txtMc);
			}
			
			if(_model.videoNum == 5 || _model.videoNum == 23){
				_setFont.setYgdFont(_movMC.userName.txt);
				_movMC.userName.txt.text = _model.userName;
			}
		}
		
		private function settingUserTxt(tf:TextField, mc:MovieClip):void
		{
			tf.text = _model.userName;
			tf.autoSize = TextFieldAutoSize.LEFT;
			mc.x = tf.x + tf.width;
		}
	}
}