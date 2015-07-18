package com.bh.player
{
	import com.adqua.util.JavaScriptUtil;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;

	public class MainFlvPlayer
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		/**	넷 스트림	*/
		private var _ns:NetStream;
		/**	넷 커넥션	*/
		private var _nc:NetConnection;
		/**	비디오	*/
		private var _video:Video;
		/**	플레이 true / false	*/
		private var _playing:Boolean = true;
		/**	전체 시간	*/
		private var _totalTime:Number;
		/**	비디오 가로 크기	*/
		private var _videoWidth:int;
		/**	비디오 세로 크기	*/
		private var _videoHeight:int;
		/**	비디오 경로	*/
		private var _videoPath:String;
		
		private var _firstChk:Boolean = true;
		private var _introChk:Boolean = false;
		private var _fullVideoEnd:Boolean = false;
		
		private var _ending:Boolean = false;
		private var _fullVideoIntro:Boolean = false;
		
		private var _fullSnd:Sound;
		private var _fullSndChannel:SoundChannel;
		private var _fullSndReady:Boolean = false;
		private var _fullVideoClosing:Boolean = false;
		
		private var _volume:Number = 1;
		
		public function MainFlvPlayer(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.PLAY_VIDEO, resetVideoPlay);
			_model.addEventListener(BhEvent.VOLUME_CHANGE, volumeChange);
			_model.addEventListener(BhEvent.FULL_CARDSECTION_FINISHED, fullCardsectionFinished);
			_model.addEventListener(BhEvent.MAIN_CONTENTS_START, mainContentsStart);
			_model.addEventListener(BhEvent.PAUSE_VIDEO, pauseVideo);
			_model.addEventListener(BhEvent.RESUME_VIDEO, resumeVideo);
			_model.addEventListener(BhEvent.PLAY_FULL_VIDEO, playFullVideo);
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resetVideoPlay(e:BhEvent):void
		{
			_model.loop = true;
			_videoPath = _model.commonPath + "mov/scene_loop_v2.f4v";
			TweenLite.killTweensOf(_con.toName);
			TweenLite.killTweensOf(_con.fromName);
			TweenLite.to(_con.toName, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.fromName, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			
			TweenLite.to(_con.video, 0.75, {delay:1, alpha:0, onComplete:fullVideoStart});
			
			if(_model.mute == false && !_con.hasEventListener(Event.ENTER_FRAME)) _con.addEventListener(Event.ENTER_FRAME, volumeDown);
			if(_model.mute) _fullSndChannel.stop();
		}
		
		private function volumeChange(e:BhEvent):void
		{
			var st:SoundTransform = new SoundTransform();
			if(_model.mute) st.volume = 0;
			else st.volume = 1;
			_ns.soundTransform = st;
			
			if(_model.fullVideo && _fullVideoClosing == false) _fullSndChannel.soundTransform = st;
		}
		
		private function fullCardsectionFinished(e:BhEvent):void
		{
			_con.plane.alpha = 1;
			TweenLite.to(_con.video, 1, {alpha:0, onComplete:videoEnd});
			
			_fullVideoClosing = true;
			if(_model.mute == false) _con.addEventListener(Event.ENTER_FRAME, volumeDown);
			else _fullSndChannel.stop();
		}
		
		/**	풀영상 종료 사운드 감소	*/
		private function volumeDown(e:Event):void
		{
			_volume -= 0.05;
			var st:SoundTransform = new SoundTransform();
			st.volume = _volume;
			_fullSndChannel.soundTransform = st;
			trace("볼륨 감소중::::   " + _volume, _ns.soundTransform.volume);
			
			if(_volume <= 0) 
			{
				_con.removeEventListener(Event.ENTER_FRAME, volumeDown);
				_fullVideoClosing = false;
				_volume = 0;
				st.volume = _volume;
				_fullSndChannel.soundTransform = st;
				_fullSndChannel.stop();
				trace("볼륨 감소 완료____!  " + _volume, _ns.soundTransform.volume);
			}
		}
		
		private function mainContentsStart(e:BhEvent):void
		{
			playVideo();
			_model.dispatchEvent(new BhEvent(BhEvent.CHANGE_VIDEO));
		}
		
		private function playFullVideo(e:BhEvent):void
		{
			if(_fullSndReady == false) return;
			
			_introChk = true;
			_model.isIntro = true;
			_fullVideoIntro = true;
			_con.block.alpha = 1;
			
			_fullSndChannel = _fullSnd.play();
			if(_model.mute) _volume = 0;
			else _volume = 1;
			var st:SoundTransform = new SoundTransform();
			st.volume = _volume;
			_fullSndChannel.soundTransform = st;
			_videoPath = _model.commonPath + "mov/intro_v2.f4v";
			playVideo();
		}
		
		private function fullVideoStart():void
		{
			playVideo();
			TweenLite.to(_con.video, 0.75, {alpha:1});
		}
		
		private function pauseVideo(e:BhEvent):void
		{
			_ns.pause();
		}
		
		private function resumeVideo(e:BhEvent):void
		{
			_ns.resume();
		}
		
		/**	비디오 셋팅	*/
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			_con.toName.visible = false;
			_con.fromName.visible = false;
			
			_fullSnd = new Sound();
			_fullSnd.load(new URLRequest(_model.commonPath + "snd/fullSound.mp3"));
			_fullSnd.addEventListener(Event.COMPLETE, soundLoadComplete);
			
			_nc = new NetConnection();
			_nc.connect( null );
			_ns = new NetStream( _nc );
			_video = new Video();
			_video.smoothing = true;
			_video.attachNetStream( _ns );
			_con.video.addChild(_video);
			
			_model.loop = true;
			_videoPath = _model.commonPath + "mov/scene_loop_v2.f4v";
			trace("인트로 비디오 경로_____________>>    " + _videoPath);
//			playVideo();
		}
		
		private function soundLoadComplete(e:Event):void
		{
			_fullSndReady = true;
			if(_model.fullVideo) _model.dispatchEvent(new BhEvent(BhEvent.PLAY_FULL_VIDEO));
		}
		
		/** 비디오 플레이 **/
		private function playVideo(e:Event = null):void
		{
//			if(_model.fullVideo == false && _firstChk == false) _model.dispatchEvent(new BhEvent(BhEvent.CHANGE_VIDEO));
			
			var meta:Object = new Object();
			meta.onMetaData = function(info:Object):void{
				_totalTime = info["duration"];
				_videoWidth = info["width"];
				_videoHeight = info["height"];
				_video.width =  _videoWidth;
				_video.height =  _videoHeight;
				resizeHandler();
//				trace("_totalTime: "+_totalTime);
//				trace("_videWidth: "+_videoWidth);
//				trace("_videHeight: "+_videoHeight);
			};
			
			meta.onCuePoint = function(info:Object):void{
				var queName:String = info["name"];
				queName = queName.toLowerCase();
				trace("큐포인트 이름::::::::   " + queName);
				if(queName == "endcardsection")
				{
					_model.nowPlay = false;
					_model.dispatchEvent(new BhEvent(BhEvent.FINISH_CARDSECTION));
				}
				if(_model.fullVideo)
				{
					if(queName == "toname") showToName();
					if(queName == "fromname") showFromName();
					if(queName == "closeup") _model.dispatchEvent(new BhEvent(BhEvent.FULL_CARDSECTION_START));
				}
			};
			
			_ns.client = meta;
			_ns.play(_videoPath);
		}
		
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" :
					trace("video_Start");
					/**	좋아요 버튼 숨길지 말지 체크	*/
//					if(!_model.fullVideo) JavaScriptUtil.call("likeBoxCheck");
					if(_model.fullVideo == false) _fullVideoClosing = false;
					if(_con.hasEventListener(Event.ENTER_FRAME)) _con.removeEventListener(Event.ENTER_FRAME, volumeDown);
					
					if(_fullVideoEnd)
					{
						_fullVideoEnd = false;
						_model.dispatchEvent(new BhEvent(BhEvent.PAUSE_VIDEO));
					}
					else
					{
						_introChk = false;
						if(_firstChk)
						{
							_firstChk = false;
//							_ns.pause();
						}
						if(_fullVideoIntro)
						{
							_fullVideoIntro = false;
							_ns.pause();
							_con.addEventListener(Event.ENTER_FRAME, removeCoverChk);
						}
						if(_model.sceneNum >= 2){
							setTimeout(function():void{
								_con.video.alpha = 1;
								_con.video.visible = true;
							}, 350);
						}
						trace("영상 포즈", _introChk);
					}
					resizeHandler();
					break;
				case "NetStream.Play.Stop" :
					trace("video_Stop");
//					drawCover();
					videoEnd();
					break;
			}
		}
		
		private function removeCoverChk(e:Event):void
		{
			if(_ns.bytesLoaded / _ns.bytesTotal >= 0.025)
			{
				_con.removeEventListener(Event.ENTER_FRAME, removeCoverChk);
				_ns.resume();
				TweenLite.to(_con.block, 0.75, {delay:1, alpha:0});
//				removeCover();
//				if(_model.fullVideo == false && _firstChk == false) _model.dispatchEvent(new BhEvent(BhEvent.CHANGE_VIDEO));
			}
		}
		
		private function videoEnd():void
		{
			/**	풀영상 재생시 화면전환 방지 인트로 체크	*/
			if(_introChk) return;
			
			_model.isIntro = false;
			if(_model.fullVideo)
			{
				trace("풀 영상 플레이___!  " + _model.sceneNum);
				_model.sceneNum++;
				if(_model.sceneNum >= 3)
				{
					_fullVideoEnd = true;
					_model.hideUI = false;
					_model.fullVideo = false;
					_model.loop = true;
					_model.sceneNum = 0;
					_con.plane.alpha = 0;
					_videoPath = _model.commonPath + "mov/scene_loop_v2.f4v";
					fullVideoStart();
					if(_model.galleryOpen)
					{
						_model.galleryOpen = false;
						_model.dispatchEvent(new BhEvent(BhEvent.SHOW_MOVIE_COVER));
						JavaScriptUtil.call("showPopup", 3);
					}
					if(_model.myMovieOpen)
					{
						_model.myMovieOpen = false;
						_model.dispatchEvent(new BhEvent(BhEvent.SHOW_MOVIE_COVER));
						JavaScriptUtil.call("showPopup", 1);
					}
					if(_model.scrap)
					{
						_model.scrap = false;
//						_ns.resume();
						_fullVideoEnd = false;
						_model.dispatchEvent(new BhEvent(BhEvent.CONTENTS_INMOTION));
					}
					trace("오픈 팝업____>  " + _model.galleryOpen, _model.myMovieOpen, _model.scrap);
					
					_model.dispatchEvent(new BhEvent(BhEvent.HIDE_VIDEO_BUTTON));
				}
				else
				{
					_videoPath = _model.commonPath + "mov/scene_" + (_model.sceneNum-1) + "_v2.f4v";
//					_con.video.alpha = 1;
//					_con.video.visible = true;
					trace("풀영상 진행중____>> " + _videoPath);
					
					playVideo();
//					if(_model.sceneNum-1 == 0) setTimeout(cardSectionStart, 2000);
					if(_model.sceneNum-1 == 1) _con.plane.alpha = 1;
				}
			}
			else
			{
				trace("루프영상 플레이___!");
				_model.loop = true;
				_videoPath = _model.commonPath + "mov/scene_loop_v2.f4v";
				playVideo();
				_model.dispatchEvent(new BhEvent(BhEvent.CONTENTS_INMOTION));
			}
			trace(_videoPath);
		}
		
//		private function videoCloseUp():void
//		{
//			if(_model.sceneNum-1 == 0) setTimeout(cardSectionStart, 2000);
//		}
//		
//		private function cardSectionStart():void
//		{
//			_model.dispatchEvent(new BhEvent(BhEvent.FULL_CARDSECTION_START));
//		}
		
//		/**	마지막 장면 그리기	*/
//		private function drawCover():void
//		{
//			var bmpData:BitmapData = new BitmapData(1920, 1080);
//			bmpData.draw(_con.video);
//			
//			var bmp:Bitmap = new Bitmap(bmpData);
//			bmp.smoothing = true;
//			_con.cover.addChild(bmp);
//		}
//		
//		/**	마지막 장면 지우기	*/
//		private function removeCover():void
//		{
//			TweenLite.killTweensOf(_con.cover);
//			_con.video.alpha = 1;
//			TweenLite.to(_con.cover, 1, {alpha:0, onComplete:removeCaptureImg});
//		}
//		/**	이미지 제거	*/
//		private function removeCaptureImg():void
//		{
//			while(_con.cover.numChildren > 0)
//			{
//				var childIdx:int = _con.cover.numChildren-1;
//				var bmp:Bitmap = _con.cover.getChildAt(childIdx) as Bitmap;
//				bmp.bitmapData.dispose();
//				_con.cover.removeChild(bmp);
//			}
//			trace("커버 지우기 ==>  " + _con.cover.numChildren);
//		}
		
		/**	비디오 제거	*/
		private function destroyVideo():void
		{
			_ns.close();
			_video.clear();
			_con.video.removeChild(_video);
			_video = null;
			_playing = false;
		}
		
		private function showToName():void
		{
			_con.toName.txt.text = _model.toName;
			_con.toName.txt.autoSize = TextFieldAutoSize.LEFT;
			_con.toName.x = int(1920/2 - _con.toName.width/2);
			_con.toName.y = int(1080/2 - _con.toName.height/2)+125;
			TweenLite.to(_con.toName, 0.75, {delay:0.5, autoAlpha:1, ease:Cubic.easeOut, onComplete:hideToname});
		}
		private function hideToname():void
		{	TweenLite.to(_con.toName, 0.75, {delay:0.35, autoAlpha:0, ease:Cubic.easeOut});		}
		
		private function showFromName():void
		{
			_con.fromName.txt.text = _model.fromName;
			_con.fromName.txt.autoSize = TextFieldAutoSize.CENTER;
			_con.fromName.x = int(1920/2);
			_con.fromName.y = int(1080/2 - _con.fromName.height/2);
			TweenLite.to(_con.fromName, 0.55, {autoAlpha:1, ease:Cubic.easeOut, onComplete:hideFromname});
		}
		private function hideFromname():void
		{	TweenLite.to(_con.fromName, 1, {delay: 0.5, autoAlpha:0, ease:Cubic.easeOut});	}
		
		private function resizeHandler(e:Event = null):void
		{
			if(_con.stage.stageWidth >= 1920 || _con.stage.stageHeight >= 1080 || _model.isIntro)
			{
				_con.width = _con.stage.stageWidth;
				_con.height = _con.stage.stageHeight;
				_con.scaleX = _con.scaleY = Math.max(_con.scaleX, _con.scaleY);
			}
			else
			{
				_con.scaleX = _con.scaleY = 1;
			}
			_con.x = Math.ceil(Math.floor(_con.stage.stageWidth/2) - Math.ceil(_con.width/2));
			_con.y = Math.ceil(Math.floor(_con.stage.stageHeight/2) - Math.ceil(_con.height/2));
			
			var pp:PerspectiveProjection=new PerspectiveProjection();
			pp.projectionCenter=new Point(1920/2,1080/2);
			_con.transform.perspectiveProjection=pp;
		}
	}
}