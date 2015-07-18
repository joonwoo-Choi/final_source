package com.smirnoff.page
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class Page_2
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		private var _firstChk:int;
		private var _isPlay:Boolean = false;
		private var _allPlay:Boolean = false;
		
		private var _btnBeatArr:Array;
		private var _btnDrumArr:Array;
		private var _btnEffectArr:Array;
		private var _selectedNoArr:Array;
		
		private var _beatSnd:Sound;
		private var _drumSnd:Sound;
		private var _effectSnd:Sound;
		private var _beatCh:SoundChannel;
		private var _drumCh:SoundChannel;
		private var _effectCh:SoundChannel;
		
		public function Page_2(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin, ColorTransformPlugin]);
			_con = con;
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			_model.addEventListener(SmirnoffEvents.GO_MAIN, goMain);
			
			makeBtn();
		}
		
		protected function goMain(event:Event):void
		{
			if(_con.visible == false) return;
			initSnd();
			_firstChk = 0;
			TweenLite.to(_con, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onCompleteParams:[3], onComplete:outMotionComplete});
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) != 2) return;
			trace("2페이지 시작__!!");
			/**	트래킹	*/
			JavaScriptUtil.call("googleSender", "District", "step2");
			
			_con.alpha = 0;
			_con.visible = false;
			_con.cover.visible = false;
			_con.btn0.over.alpha = 0;
			_isPlay = false;
			_allPlay = false;
			inMotion();
			
			updateLaunchPad("beat", 0);
			updateLaunchPad("drum", 0);
			updateLaunchPad("effect", 0);
		}
		
		private function inMotion():void
		{
			TweenLite.to(_con, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		private function outMotion(num:int):void
		{
			TweenLite.to(_con, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onCompleteParams:[num], onComplete:outMotionComplete});
		}
		
		private function outMotionComplete(num:int):void
		{
			if(num == 1) _model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:1}));
			else if(num == 2) _model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:3}));
			else if(num == 3) _model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:0}));
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var commonBtn:MovieClip = _con.getChildByName("btn" + i) as MovieClip;
				commonBtn.no = i;
				ButtonUtil.makeButton(commonBtn, commonBtnHandler);
			}
			
			_btnBeatArr = [];
			_btnDrumArr = [];
			_btnEffectArr = [];
			_selectedNoArr = [];
			for (var j:int = 0; j < 5; j++) 
			{
				var btnBeat:MovieClip = _con.getChildByName("btnBeat" + j) as MovieClip;
				btnBeat.no = j;
				btnBeat.type = "beat";
				btnBeat.active = "off";
				_btnBeatArr.push(btnBeat);
				ButtonUtil.makeButton(btnBeat, remixBtnHandler);
				
				var btnDrum:MovieClip = _con.getChildByName("btnDrum" + j) as MovieClip;
				btnDrum.no = j;
				btnDrum.type = "drum";
				btnDrum.active = "off";
				_btnDrumArr.push(btnDrum);
				ButtonUtil.makeButton(btnDrum, remixBtnHandler);
				
				var btnEffect:MovieClip = _con.getChildByName("btnEffect" + j) as MovieClip;
				btnEffect.no = j;
				btnEffect.type = "effect";
				btnEffect.active = "off";
				_btnEffectArr.push(btnEffect);
				ButtonUtil.makeButton(btnEffect, remixBtnHandler);
			}
		}
		
		private function commonBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.0}});
					break;
				case MouseEvent.CLICK :
					if(target.no == 0)
					{
						if(_allPlay == false)
						{
							_allPlay = true;
							if(_isPlay == true) initSnd();
							playSnd("all");
							TweenLite.to(target.over, 0.5, {alpha:1});
						}
						else
						{
							_allPlay = false;
							TweenLite.to(target.over, 0.5, {alpha:0});
							initSnd();
						}
						trace(_isPlay);
					}
					
					if(target.no == 1 || target.no == 2)
					{
						if(target.no == 1)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("googleSender", "District", "step2btn1");
						}
						if(target.no == 2)
						{
							/**	트래킹	*/
							JavaScriptUtil.call("googleSender", "District", "step2btn2");
							
							_model .selectedRemixNum = _selectedNoArr;
						}
						_firstChk = 0;
						_isPlay = false;
						_con.cover.visible = true;
						initSnd();
						outMotion(target.no);
					}
					break;
			}
		}
		
		private function playSnd(type:String):void
		{
			initSnd();
			_isPlay = true;
			
			_beatSnd = new Sound();
			_drumSnd = new Sound();
			_effectSnd = new Sound();
			_beatCh = new SoundChannel();
			_drumCh = new SoundChannel();
			_effectCh = new SoundChannel();
			
			
			if(type == "beat")
			{
				_beatSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.base.item[_selectedNoArr[0]])));
				_beatCh = _beatSnd.play();
				_beatCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
			}
			if(type == "drum")
			{
				_drumSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.drum.item[_selectedNoArr[1]])));
				_drumCh = _drumSnd.play();
				_drumCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
			}
			if(type == "effect")
			{
				_effectSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.effect.item[_selectedNoArr[2]])));
				_effectCh = _effectSnd.play();
				_effectCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
			}
			if(type == "all")
			{
				_beatSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.base.item[_selectedNoArr[0]])));
				_drumSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.drum.item[_selectedNoArr[1]])));
				_effectSnd.load(new URLRequest(String(_model.defaultPath + _model.sndList.source.effect.item[_selectedNoArr[2]])));
				_beatCh = _beatSnd.play();
				_drumCh = _drumSnd.play();
				_effectCh = _effectSnd.play();
				_beatCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
			}
			
		}
		
		private function initSnd(e:Event = null):void
		{
			if(_beatSnd != null && _beatCh != null)
			{
				_isPlay = false;
				_beatCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				_drumCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				_effectCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				
				_beatCh.stop();
				_drumCh.stop();
				_effectCh.stop();
				if(_beatSnd.isBuffering == true) _beatSnd.close();
				if(_drumSnd.isBuffering == true) _drumSnd.close();
				if(_effectSnd.isBuffering == true) _effectSnd.close();
				_beatSnd = null;
				_drumSnd = null;
				_effectSnd = null;
				_beatCh = null;
				_drumCh = null;
				_effectCh = null;
			}
		}
		
		private function remixBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
//					if(target.active == "on") return;
					updateLaunchPad(target.type, target.no);
					break;
			}
		}
		
		private function updateLaunchPad(btnType:String, btnNo:int):void
		{
			var selectedBtnArr:Array;
			if(btnType == "beat")
			{
				selectedBtnArr = _btnBeatArr;
				_selectedNoArr.splice(0, 1, btnNo);
			}
			else if(btnType == "drum")
			{
				selectedBtnArr = _btnDrumArr;
				_selectedNoArr.splice(1, 1, btnNo);
			}
			else if(btnType == "effect")
			{
				selectedBtnArr = _btnEffectArr;
				_selectedNoArr.splice(2, 1, btnNo);
			}
			trace("현재 선택된 번호: " + _selectedNoArr);
			
			for (var i:int = 0; i < selectedBtnArr.length; i++) 
			{
				if(i == btnNo)
				{
					selectedBtnArr[i].active = "on";
					TweenLite.to(selectedBtnArr[i].over, 0.5, {alpha:1});
				}
				else
				{
					selectedBtnArr[i].active = "off";
					TweenLite.to(selectedBtnArr[i].over, 0.5, {alpha:0});
				}
			}
			
			_firstChk++;
			if(_firstChk <= 3) return;
			playSnd(btnType);
			_allPlay = false;
			TweenLite.to(_con.btn0.over, 0.5, {alpha:0});
		}
		
//		private function sendUserData():void
//		{
//			var vari:URLVariables = new URLVariables();
//			vari.rand = Math.round(Math.random()*10000);
//			vari.mnum = _model.cdNum + 1;
//			vari.bnum = _model.selectedRemixNum[0] + 1;
//			vari.dnum = _model.selectedRemixNum[1] + 1;
//			vari.efnum = _model.selectedRemixNum[2] + 1;
//			
//			var req:URLRequest = new URLRequest(_model.sendUserDataUrl);
//			req.data = vari;
//			req.method =URLRequestMethod.POST;
//			
//			var urlLdr:URLLoader = new URLLoader();
//			urlLdr.load(req);
//			urlLdr.addEventListener(Event.COMPLETE, sendUserDataComplete);
//		}
//		
//		private function sendUserDataComplete(e:Event):void
//		{
//			trace(e.target.data);
//			var sndName:String = e.target.data;
//			outMotion(2);
//			_model.sndUrl = _model.outputSndUrl + sndName;
//		}
	}
}