package com.smirnoff.control
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.smirnoff.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class SndControl
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _snd:Sound;
		private var _sndCh:SoundChannel;
		private var _position:Number;
		private var _selectedCD:MovieClip;
		
		public function SndControl(con:MovieClip)
		{
			_con = con;
			
			ButtonUtil.makeButton(_con.btnToggle, btnToggleHandler);
			_con.volCon.buttonMode = true;
			_con.volCon.addEventListener(MouseEvent.MOUSE_DOWN, volDown);
			
			_con.seekBar.buttonMode = true;
			_con.seekBar.addEventListener(MouseEvent.MOUSE_DOWN, seekBarDown);
		}
		
		public function loadSnd():void
		{
			_snd = new Sound();
			_sndCh = new SoundChannel();
			_snd.load(new URLRequest(_model.sndUrl));
		}
		
		public function selectedCD(cd:MovieClip):void
		{
			_selectedCD = cd;
		}
		
		private function btnToggleHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					sndToggle();
					break;
			}
		}
		
		public function sndToggle():void
		{
			if(_snd == null && _sndCh == null) loadSnd();
			
			if(_con.btnToggle.currentFrame == 1)
			{
				if(_model.sndUrl == "" || _model.sndUrl == null)
				{
					initSnd();
					JavaScriptUtil.alert("오픈되지 않은 음원입니다.");
					return;
				}
				_con.btnToggle.gotoAndStop(2);
				_sndCh = _snd.play(_position);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = _con.volCon.vol.scaleX;
				_sndCh.soundTransform = volume;
				_sndCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
				_con.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
			else
			{
				_con.btnToggle.gotoAndStop(1);
				_position = _sndCh.position;
				_sndCh.stop();
				_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				_con.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
		}
		
		private function volDown(e:MouseEvent):void
		{
			if(_snd == null || _sndCh == null) return;
			_con.volCon.stage.addEventListener(MouseEvent.MOUSE_MOVE, soundDragHandler);
			_con.volCon.stage.addEventListener(MouseEvent.MOUSE_UP, soundMouseUpHandler);
			
			soundHandler();
		}
		
		private function soundDragHandler(e:MouseEvent):void
		{
			soundHandler();
		}
		
		private function soundMouseUpHandler(e:MouseEvent):void
		{
			_con.volCon.stage.removeEventListener(MouseEvent.MOUSE_MOVE, soundDragHandler);
			_con.volCon.stage.removeEventListener(MouseEvent.MOUSE_UP, soundMouseUpHandler);
		}
		
		private function soundHandler():void
		{
			_con.volCon.vol.width = _con.volCon.mouseX;
			var volume:SoundTransform = new SoundTransform();
			volume.volume = _con.volCon.vol.scaleX;
			if(volume.volume <= 0)
			{
				volume.volume = 0;
			}
			else if(volume.volume >= 1)
			{
				volume.volume = 1;
			}
			_sndCh.soundTransform = volume;
			trace(_sndCh.soundTransform.volume);
		}
		
		private function seekBarDown(e:MouseEvent):void
		{
			if(_snd == null || _sndCh == null) return;
			seekBarDragMove(_con.seekBar.mouseX);
			_con.seekBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, seekBarMove);
			_con.seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, seekBarMoveComplete);
			
			_sndCh.stop();
			_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
			_con.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
		}
		
		private function seekBarMove(e:MouseEvent):void
		{
			seekBarDragMove(_con.seekBar.mouseX);
		}
		
		private function seekBarMoveComplete(e:MouseEvent):void
		{
			_con.seekBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, seekBarMove);
			_con.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, seekBarMoveComplete);
			
			if(_con.btnToggle.currentFrame == 2)
			{
				_sndCh = _snd.play(_position);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = _con.volCon.vol.scaleX;
				_sndCh.soundTransform = volume;
				_sndCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
				_con.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
			
			if(_con.seekBar.seekMask.scaleX == 1) initSnd();
		}
		
		private function seekBarDragMove(num:Number):void
		{
			var width:int = num - 6;
			if(num <= 0 ) width = 0;
			else if(num >= 270) width = 270;
			_con.seekBar.seekMask.width = width;
			var percent:Number = _con.seekBar.seekMask.scaleX;
			_con.seekBar.handle.x = int(12 + (264 * percent));
			_position = percent * _snd.length;
			trace(num, _con.seekBar.seekMask.width);
		}
		
		private function sndPlayProgress(e:Event):void
		{
			_con.seekBar.seekMask.scaleX = _sndCh.position / _snd.length;
			if(264 * _con.seekBar.seekMask.scaleX >= 0)
			{
				_con.seekBar.handle.x = int(12 + (264 * _con.seekBar.seekMask.scaleX));
			}
			
//			TweenLite.killTweensOf(_selectedCD);
//			TweenLite.to(_selectedCD, 0.3, {rotation:360 * (_sndCh.position / _snd.length)});
			
//			_selectedCD.rotation += 1;
			
			_selectedCD.rotation = 720 * (_sndCh.position / _snd.length);
//			trace(_selectedCD.rotation);
		}
		
		public function initSnd(e:Event = null):void
		{
			_con.seekBar.handle.x = 12;
			_con.seekBar.seekMask.scaleX = 0;
			_con.btnToggle.gotoAndStop(1);
			_position = 0;
			if(_snd != null && _sndCh != null)
			{
				_con.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
				_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = 1;
				_sndCh.soundTransform = volume;
				_con.volCon.vol.scaleX = 1
				_sndCh.stop();
				if(_snd.isBuffering == true) _snd.close();
				_snd = null;
				_sndCh = null;
				TweenLite.to(_selectedCD, 2, {rotation:0, ease:Cubic.easeOut, onComplete:rotationComplete});
			}
		}
		
		private function rotationComplete():void
		{
			_selectedCD.rotation = 0;
		}
	}
}