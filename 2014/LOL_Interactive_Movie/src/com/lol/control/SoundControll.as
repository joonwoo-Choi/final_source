package com.lol.control
{
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.SoundTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class SoundControll
	{
		
		private var _model:Model = Model.getInstance();
		
		private var _lolBgm:Sound;
		private var _lolBgmChannel:SoundChannel;
		private var _interBgm:Sound;
		private var _interBgmChannel:SoundChannel;
		private var _banPickBgm:Sound;
		private var _banPickBgmChannel:SoundChannel;
		private var _trainingBgm:Sound;
		private var _trainingBgmChannel:SoundChannel;
		
		private var _lolSt:SoundTransform;
		private var _banPickSt:SoundTransform;
		private var _interSt:SoundTransform;
		private var _trainingSt:SoundTransform;
		private var _lolBgmLoadChk:Boolean = false;
		private var _banPickBgmLoadChk:Boolean = false;
		private var _interBgmLoadChk:Boolean = false;
		private var _trainingBgmLoadChk:Boolean = false;
		private var _mute:Boolean = false;
		
		private var _lolPlay:Boolean = false;
		private var _banPickPlay:Boolean = false;
		private var _interPlay:Boolean = false;
		private var _trainingPlay:Boolean = false;
		
		private var _tainingPlayTime:Number;
		
		public function SoundControll()
		{
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([SoundTransformPlugin]);
			
			_lolBgm = new Sound();
			_lolBgmChannel = new SoundChannel();
			_interBgm = new Sound();
			_interBgmChannel = new SoundChannel();
			_banPickBgm = new Sound();
			_banPickBgmChannel = new SoundChannel();
			_trainingBgm = new Sound();
			_trainingBgmChannel = new SoundChannel();
			
			_lolSt = new SoundTransform();
			_lolSt.volume = 0;
			_interSt = new SoundTransform();
			_interSt.volume = 0;
			_banPickSt = new SoundTransform();
			_banPickSt.volume = 0;
			_trainingSt = new SoundTransform();
			_trainingSt.volume = 0;
			
			_lolBgm.load(new URLRequest(_model.commonPath + "snd/LOL_BGM.mp3"));
			_interBgm.load(new URLRequest(_model.commonPath + "snd/Inter_BGM.mp3"));
			_banPickBgm.load(new URLRequest(_model.commonPath + "snd/BanPick_BGM.mp3"));
			_trainingBgm.load(new URLRequest(_model.commonPath + "snd/Training_BGM.mp3"));
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.VIDEO_PAUSE, trainingSndPause);
			_model.addEventListener(LolEvent.VIDEO_RESUME, trainingSndResume);
			
			_model.addEventListener(LolEvent.DIMMED_OFF, soundVolumeChk);
			_model.addEventListener(LolEvent.PANNING_VIDEO_STOP, soundVolumeChk);
			_model.addEventListener(LolEvent.HIDE_QUICK_MENU, soundVolumeChk);
			_model.addEventListener(LolEvent.VOLUME_CHANGE, totalVolumeChange);
			
			_lolBgm.addEventListener(Event.COMPLETE, lolSoundLoadComplete);
			_interBgm.addEventListener(Event.COMPLETE, interSoundLoadComplete);
			_banPickBgm.addEventListener(Event.COMPLETE, banPickSoundLoadComplete);
			_trainingBgm.addEventListener(Event.COMPLETE, trainingSoundLoadComplete);
		}
		
		private function lolSoundLoadComplete(e:Event):void
		{
			trace("LOL BGM 로드 완료_______________!!");
			_lolBgm.removeEventListener(Event.COMPLETE, lolSoundLoadComplete);
			_lolBgmLoadChk = true;
			lolBgmPlay();
		}
		
		private function interSoundLoadComplete(e:Event):void
		{
			trace("Interaction BGM 로드 완료_______________!!");
			_interBgmLoadChk = true;
		}
		
		private function banPickSoundLoadComplete(e:Event):void
		{
			trace("BanPick BGM 로드 완료_______________!!");
			_banPickBgmLoadChk = true;
		}
		
		private function trainingSoundLoadComplete(e:Event):void
		{
			trace("Training BGM 로드 완료_______________!!");
			_trainingBgmLoadChk = true;
		}
		
		protected function trainingSndPause(e:LolEvent):void
		{
			if(_model.videoNum == 20 || _model.videoNum == 21){
				_trainingBgmChannel.removeEventListener(Event.SOUND_COMPLETE, trainingBgmReplay);
				_tainingPlayTime = _trainingBgmChannel.position;
				_trainingBgmChannel.stop();
			}
		}
		
		protected function trainingSndResume(e:LolEvent):void
		{
			if(_model.videoNum == 20 || _model.videoNum == 21) trainingBgmPlay();
		}
		
		protected function totalVolumeChange(e:LolEvent):void
		{
			if(_model.totalVolume.volume == 0)
			{
				_mute = true;
				TweenLite.killTweensOf(_lolSt);
				TweenLite.killTweensOf(_banPickSt);
				TweenLite.killTweensOf(_interSt);
				TweenLite.killTweensOf(_trainingSt);
				_lolSt.volume = 0;
				_banPickSt.volume = 0;
				_interSt.volume = 0;
				_trainingSt.volume = 0;
				_lolBgmChannel.soundTransform = _model.totalVolume;
				_interBgmChannel.soundTransform = _model.totalVolume;
				_banPickBgmChannel.soundTransform = _model.totalVolume;
				_trainingBgmChannel.soundTransform = _model.totalVolume;
			}
			else
			{
				_mute = false;
				soundVolumeChk();
			}
			trace("음소거_____On  //  Off_____>     " + _model.totalVolume);
		}
		
		protected function soundVolumeChk(e:LolEvent = null):void
		{
			
			if(!_mute){
				/**	기본 BGM	*/
				if(_model.videoNum <= 1 || _model.videoNum >= 27){
					TweenLite.to(_lolSt, 1.5, {
						volume:0.15, 
						onUpdateParams:[_lolBgmChannel, _lolSt], 
						onUpdate:sndVolumeUp, 
						onCompleteParams:[_lolBgmChannel, _lolSt], 
						onComplete:sndVolumeUp});
				}else if(_model.videoNum >= 10 && _model.videoNum <= 19){
					TweenLite.to(_lolSt, 1.5, {
						volume:0.15, 
						onUpdateParams:[_lolBgmChannel, _lolSt], 
						onUpdate:sndVolumeUp, 
						onCompleteParams:[_lolBgmChannel, _lolSt], 
						onComplete:sndVolumeUp});
				}else if(_model.videoNum == 22){
					TweenLite.to(_lolSt, 1.5, {
						volume:0.15, 
						onUpdateParams:[_lolBgmChannel, _lolSt], 
						onUpdate:sndVolumeUp, 
						onCompleteParams:[_lolBgmChannel, _lolSt], 
						onComplete:sndVolumeUp});
				}else{
					TweenLite.to(_lolSt, 1.5, {
						volume:0, 
						onUpdate:sndVolumeDown, 
						onUpdateParams:[_lolBgmChannel, _lolSt], 
						onCompleteParams:[_lolBgmChannel, _lolSt], 
						onComplete:sndVolumeDown});
				}
				
				/**	밴픽 BGM */
				if(_model.videoNum == 2 || _model.videoNum == 4){
					if(!_banPickPlay) banPickBgmPlay();
					/**	패닝영상 플레이인지 체크	*/
					if(_model.isPanningVideo) 
						TweenLite.to(_banPickSt, 1.5, {
							volume:0, 
							onUpdate:sndVolumeDown, 
							onUpdateParams:[_banPickBgmChannel, _banPickSt], 
							onCompleteParams:[_banPickBgmChannel, _banPickSt], 
							onComplete:sndVolumeDown});
					else 
						TweenLite.to(_banPickSt, 1.5, {
							volume:0.65, 
							onUpdate:sndVolumeUp, 
							onUpdateParams:[_banPickBgmChannel, _banPickSt], 
							onCompleteParams:[_banPickBgmChannel, _banPickSt], 
							onComplete:sndVolumeUp});
				}else	{
					if(_banPickPlay){
						_banPickSt.volume = 0.15;
						TweenLite.to(_banPickSt, 1.5, {
							volume:0, 
							onUpdate:sndVolumeDown, 
							onUpdateParams:[_banPickBgmChannel, _banPickSt], 
							onComplete:banPickEndChk});
					}
				}
				
				/**	트레이닝 BGM */
				if(_model.videoNum == 20 || _model.videoNum == 21){
					if(!_trainingPlay){
						_tainingPlayTime = 0;
						trainingBgmPlay();
					}
					TweenLite.to(_trainingSt, 1.5, {
						volume:0.65, 
						onUpdate:sndVolumeUp, 
						onUpdateParams:[_trainingBgmChannel, _trainingSt], 
						onCompleteParams:[_trainingBgmChannel, _trainingSt], 
						onComplete:sndVolumeUp});
				}else{
					if(_trainingPlay) {
						trainingEndChk();
						TweenLite.to(_trainingSt, 1.5, {
							volume:0, 
							onUpdate:sndVolumeDown, 
							onUpdateParams:[_banPickBgmChannel, _trainingSt], 
							onComplete:trainingEndChk});
					}
				}
				
				/**	인터랙션 BGM	*/
				if(_model.isInterPopup){
					if(!_interPlay)	interBgmPlay();
					/**	패닝영상 플레이인지 체크	*/
					if(_model.isPanningVideo) 
						TweenLite.to(_interSt, 1.5, {
							volume:0, 
							onUpdate:sndVolumeDown, 
							onUpdateParams:[_interBgmChannel, _interSt], 
							onCompleteParams:[_interBgmChannel, _interSt], 
							onComplete:sndVolumeDown});
					else 
						TweenLite.to(_interSt, 1.5, {
							volume:0.35, 
							onUpdate:sndVolumeUp, 
							onUpdateParams:[_interBgmChannel, _interSt], 
							onCompleteParams:[_interBgmChannel, _interSt], 
							onComplete:sndVolumeUp});
				}else{
					if(_interPlay){
						TweenLite.to(_interSt, 1.5, {
							volume:0, 
							onUpdate:sndVolumeDown, 
							onUpdateParams:[_interBgmChannel, _interSt], 
							onComplete:interEndChk});
					}
				}
			}else{
				_lolBgmChannel.soundTransform = _model.totalVolume;
				_interBgmChannel.soundTransform = _model.totalVolume;
				_banPickBgmChannel.soundTransform = _model.totalVolume;
			}
		}
		
		/**	밴픽 BGM 종료할지 체크	*/
		private function banPickEndChk():void
		{
			if(_model.videoNum < 2 || _model.videoNum > 4){
				_banPickBgmChannel.removeEventListener(Event.SOUND_COMPLETE, banPickBgmReplay);
				_banPickBgmChannel.stop();
				_banPickPlay = false;
			}
		}
		
		/**	인터랙션 BGM 종료할지 체크	*/
		private function interEndChk():void
		{
			if(_model.isInterPopup == false){
				_interBgmChannel.removeEventListener(Event.SOUND_COMPLETE, interBgmReplay);
				_interBgmChannel.stop();
				_interPlay = false;
			}
		}
		
		/**	트레이닝 BGM 종료할지 체크	*/
		private function trainingEndChk():void
		{
			if(_model.videoNum < 20 || _model.videoNum > 21){
				_trainingBgmChannel.removeEventListener(Event.SOUND_COMPLETE, trainingBgmReplay);
				_trainingBgmChannel.stop();
				_trainingPlay = false;
			}
		}
		
		
		/**	LOL BGM 플레이	*/
		private function lolBgmPlay():void
		{
			if(_lolBgmLoadChk == false) return;
			
			_lolBgmChannel = _lolBgm.play();
			_lolBgmChannel.soundTransform = _lolSt;
			_lolBgmChannel.addEventListener(Event.SOUND_COMPLETE, lolBgmReplay);
			soundVolumeChk();
		}
		/**	LOL BGM 리플레이	*/
		private function lolBgmReplay(e:Event):void
		{		lolBgmPlay();		}
		
		
		/**	BanPick BGM 플레이	*/
		private function banPickBgmPlay():void
		{
			if(_banPickBgmLoadChk == false) return;
			_banPickPlay = true;
			_banPickBgmChannel = _banPickBgm.play();
			_banPickBgmChannel.soundTransform = _banPickSt;
			_banPickBgmChannel.addEventListener(Event.SOUND_COMPLETE, banPickBgmReplay);
		}
		/**	BanPick BGM 리플레이	*/
		private function banPickBgmReplay(e:Event):void
		{
			_banPickPlay = false;
			if(_model.videoNum == 2 || _model.videoNum == 4) banPickBgmPlay();
		}
		
		
		/**	Inter BGM 플레이	*/
		private function interBgmPlay():void
		{
			if(_interBgmLoadChk == false) return;
			_interPlay = true;
			_interBgmChannel = _interBgm.play();
			_interBgmChannel.soundTransform = _interSt;
			_interBgmChannel.addEventListener(Event.SOUND_COMPLETE, interBgmReplay);
		}
		/**	Inter BGM 리플레이	*/
		private function interBgmReplay(e:Event):void
		{
			_interPlay = false;
			if(_model.isInterPopup) interBgmPlay();
		}
		
		
		/**	Training BGM 플레이	*/
		private function trainingBgmPlay():void
		{
			if(_interBgmLoadChk == false) return;
			_trainingPlay = true;
			_trainingBgmChannel = _trainingBgm.play(_tainingPlayTime);
			_trainingBgmChannel.soundTransform = _trainingSt;
			_trainingBgmChannel.addEventListener(Event.SOUND_COMPLETE, trainingBgmReplay);
		}
		/**	Training BGM 리플레이	*/
		private function trainingBgmReplay(e:Event):void
		{
			_trainingPlay = false;
//			if(_model.videoNum == 20 || _model.videoNum == 21) trainingBgmPlay();
		}
		
		
		private function sndVolumeDown(sndChannel:SoundChannel, st:SoundTransform):void
		{
			sndChannel.soundTransform = st;
		}
		
		private function sndVolumeUp(sndChannel:SoundChannel, st:SoundTransform):void
		{
			sndChannel.soundTransform = st;
		}
	}
}