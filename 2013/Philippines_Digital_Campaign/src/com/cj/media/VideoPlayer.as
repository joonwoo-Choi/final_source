package com.cj.media
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayer extends Sprite
	{
		// 첫프레임에서 재생을 알림
		public static const INIT_PLAY:String = "initPlay";
		
		protected var _defaultW:Number;
		protected var _defaultH:Number;
		protected var _containerW:Number;
		protected var _containerH:Number;
		protected var _flvLoader:VideoLoader;
		
		private var _alternateURL:String;
		
		private var _resize:String;
		private var _auto:Boolean;
		private var _comeBack:Boolean;
		private var _isAp:Boolean;
		private var _repeat:int; 
		protected var _isMute:Boolean;
		protected var _isPlay:Boolean;
		
		protected var _container:Sprite;
		private var _videoX:Number;
		private var _videoY:Number;
		
		protected var _toggleBtn:MovieClip;
		protected var _playBtn:Sprite;
		protected var _pauseBtn:Sprite;
		protected var _stopBtn:Sprite;
		protected var _muteBtn:MovieClip;
		
		private var _videoPath:String;
		private var _videoRatio:Number;
		private var _vx:Number;
		private var _vy:Number;
		
		private var _nc:NetConnection;
		
		public function VideoPlayer() 
		{
			super();
			_container = new Sprite();
			addChild(_container);
		}
		
		// ----- getter / setter ----------------------------------------------------------------------
		
		public function get vy():Number
		{
			return _vy;
		}

		public function get vx():Number
		{
			return _vx;
		}

		public function get containerH():Number
		{
			return _containerH;
		}

		public function set containerH(value:Number):void
		{
			_containerH = value;
		}

		public function get containerW():Number
		{
			return _containerW;
		}

		public function set containerW(value:Number):void
		{
			_containerW = value;
		}

		public function get videoRatio():Number
		{
			return _videoRatio;
		}

		public function get isPlay():Boolean
		{
			return _isPlay;
		}

		public function get loader():VideoLoader
		{
			return _flvLoader;
		}
		
		public function set toggleButton(value:MovieClip):void
		{
			if(_toggleBtn) return;
			_toggleBtn = value;
			setButtonEvent(_toggleBtn, setToggle);
		}
		
		public function set playButton(value:Sprite):void
		{
			if(_playBtn) return;
			_playBtn = value;
			setButtonEvent(_playBtn, setPlay);
		}
		
		public function set pauseButton(value:Sprite):void
		{
			if(_pauseBtn) return;
			_pauseBtn = value;
			setButtonEvent(_pauseBtn,setPause);
		}
		
		public function set stopButton(value:Sprite):void
		{
			if(_stopBtn) return;
			_stopBtn = value;
			setButtonEvent(_stopBtn, setStop);
		}
		
		public function set muteBtn(value:MovieClip):void
		{
			if(_muteBtn){
				if(value == null){
					_muteBtn.removeEventListener(MouseEvent.CLICK, setMute);
					_muteBtn = null;
				}
				return;
			}else{
				if(value == null) return;
			}
			
			_muteBtn = value;
			setButtonEvent(_muteBtn, setMute);
		}
		
		// --------------------------------------------------------------------------------------------
		
		public function init($videoX:Number, $videoY:Number, $videoW:Number, $videoH:Number):void
		{
			_videoX = $videoX;
			_videoY = $videoY;
			_containerW = $videoW;
			_containerH = $videoH;
		}
		
		public function dispose():void
		{
			if(_flvLoader==null) return;
			if(_flvLoader.progress > 0 && _flvLoader.progress < 1){
				_flvLoader.pause();
			}
			_flvLoader.removeEventListener(VideoLoader.VIDEO_COMPLETE, videoCompleteHandler);
			_flvLoader.removeEventListener(VideoLoader.VIDEO_PLAY, videoPlayHandler);
			_flvLoader.removeEventListener(VideoLoader.VIDEO_PAUSE, videoPauseHandler);
			_flvLoader.removeEventListener(VideoLoader.VIDEO_CUE_POINT, videoCuePointHandler);
			
			(_flvLoader.rawContent as Video).clear();
			_flvLoader.unload();
			_flvLoader.dispose();
			_flvLoader = null;
		}
		
		/**
		 * 
		 * @param $videoPath
		 * @param {auto:false, repeat:0, resize:'none', isAp:false, comeBack:false, conW:0, conH:0, alternateURL:""}
		 */		
		public function startVideo($videoPath:String, $data:Object):void
		{
			_videoPath = $videoPath;
			
			_auto = ($data.auto) ? Boolean($data.auto) : false;
			_isAp = ($data.isAp) ? Boolean($data.isAp) : false;
			_resize = ($data.resize) ? String($data.resize) : "none";
			_comeBack = ($data.comeBack) ? Boolean($data.comeBack) : false;
			_repeat = ($data.repeat) ? Number($data.repeat) : 0;
			_containerW = ($data.conW) ? Number($data.conW) : _containerW;
			_containerH = ($data.conH) ? Number($data.conH) : _containerH;
			_alternateURL = ($data.alternateURL) ? String($data.alternateURL) : "";
			
			_nc = $data.nc;
			
			dispose();
			flvPlay();
		}
		
		private function flvPlay():void
		{
			var params:Object = {};
			params.name = "flv";
			params.container = _container;
			params.alpha = 0;
			params.autoPlay = false;
			params.checkPolicyFile = true;
			params.autoAdjustBuffer = false;
			params.bufferTime = 2;
			params.bufferMode = true;
			//params.noCache = true; 
			
			// 기존 URL 실패시 대체 URL 설정
			if(_alternateURL != "") params.alternateURL = _alternateURL;
			
			
			if(_nc is NetConnection){
				var ns:NetStream = new NetStream(_nc);
				
				
				//ns.videoSampleAccess = true;
				//ns.receiveVideo(true);
				params.netStream = ns;
			}
			
			params.x = _videoX;
			params.y = _videoY;
			params.repeat = _repeat;
			params.smoothing = true;
			params.onInit = loadOnInitHandler;
			params.onProgress = loadProgressHandler;
			params.onComplete = loadCompleteHandler;
			
			_flvLoader = new VideoLoader(_videoPath, params);
			_flvLoader.addEventListener(VideoLoader.VIDEO_COMPLETE, videoCompleteHandler);
			_flvLoader.addEventListener(VideoLoader.VIDEO_PLAY, videoPlayHandler);
			_flvLoader.addEventListener(VideoLoader.VIDEO_PAUSE, videoPauseHandler);
			_flvLoader.addEventListener(VideoLoader.VIDEO_CUE_POINT, videoCuePointHandler);
			_flvLoader.load();
		}
		
		// 비디오사이즈 셋팅
		public function setVideoSize(conW:int=0, conH:int=0):void
		{
			if(_flvLoader == null || _flvLoader.rawContent == null) return;
			
			var cw:Number = (conW == 0) ? _containerW : conW;
			var ch:Number = (conH == 0) ? _containerH : conH;
			var videoW:Number;
			var videoH:Number;
			
			var fy:Number = 0;
			switch(_resize)
			{
				case "widthOnly":
					videoW = cw;
					videoH = Math.round( (_defaultH / _defaultW) * cw );
					fy = (ch - videoH) / 2;
					break;
				case "heightOnly":
					videoW = Math.round( (_defaultW / _defaultH) * ch );
					videoH = ch;
					break;
				case "auto":
					videoW = Math.round( (_defaultW / _defaultH) * ch );
					videoH = ch;
					if(videoW < cw){
						videoW = cw;
						videoH = Math.round( (_defaultH / _defaultW) * cw );
						
						fy = (ch - videoH) / 2;
					}
					break;
			}
			_videoRatio = videoW/_defaultW;
			
			_flvLoader.content.width = videoW;
			_flvLoader.content.height = videoH;
			
			_vx = (cw - videoW) / 2;
			_vy = fy + _videoY;
			_flvLoader.content.x = _vx;
			_flvLoader.content.y = _vy;
		}
		
		// 로드시작 -메타데이터 정보를 받아옴
		protected function loadOnInitHandler(e:LoaderEvent):void
		{
			var obj:Object = _flvLoader.metaData;
			/*for ( var p:String in obj ) {
				trace( p + "=" + obj[p] );
			}*/
			_defaultW = obj.width;
			_defaultH = obj.height;
			
			if(_resize!="none") setVideoSize();
			if(_auto) _flvLoader.playVideo();
			if(_isAp){
				TweenMax.to(_flvLoader.content, 1.4, { alpha:1, ease:Expo.easeInOut} );
			}else{
				_flvLoader.content.alpha = 1;
			}
			
			dispatchEvent( e );
		}
		
		private function loadProgressHandler(e:LoaderEvent):void
		{
			//trace(_flvLoader.bytesLoaded/_flvLoader.bytesTotal);
			dispatchEvent(e);
		}
		
		// 비디오 로드완료
		private function loadCompleteHandler(e:LoaderEvent):void
		{
			//trace("비디오 다운로드완료!!");
		}
		
		private function setToggle(e:MouseEvent=null):void
		{
			if(_isPlay){
				setPause();
			}else{
				setPlay();
			}
		}
		
		public function setPlay(e:MouseEvent=null):void
		{
			if(_flvLoader==null) return;
			if (_flvLoader.playProgress == 1) _flvLoader.gotoVideoTime(0);
			_flvLoader.playVideo();
		}
		
		public function setPause(e:MouseEvent=null):void
		{
			if(_flvLoader==null) return;
			_flvLoader.pauseVideo();
		}
		
		public function setStop(e:MouseEvent=null):void
		{
			if(_flvLoader==null) return;
			_flvLoader.pauseVideo();
			_flvLoader.gotoVideoTime(0);
		}
		
		public function setMute(e:MouseEvent=null):void
		{
			if(_flvLoader==null) return;
			_isMute = !_isMute;
			if (_isMute) {
				_flvLoader.volume = 0;
			}else {
				_flvLoader.volume = 1;
			}
		}
		
		private function setButtonEvent(target:Sprite, clickFN:Function):void
		{
			target.buttonMode = true;
			target.mouseChildren = false;
			target.addEventListener(MouseEvent.CLICK, clickFN);
		}
		
		protected function videoPlayHandler(e:LoaderEvent=null):void
		{
			//trace("재생시작!!");
			_isPlay = true;
			if (Math.floor(_flvLoader.videoTime) == 0) {
				this.dispatchEvent(new Event(INIT_PLAY));
			}
			//
		}
		
		protected function videoPauseHandler(e:LoaderEvent=null):void
		{
			_isPlay = false;
			//
		}
		
		private function videoCompleteHandler(e:LoaderEvent):void
		{
			trace("재생완료!!");
			if(_comeBack) _flvLoader.gotoVideoTime(0);
			
			dispatchEvent(e);
		}
		
		private function videoCuePointHandler(e:LoaderEvent):void
		{
			dispatchEvent(e);
		}
	}
}