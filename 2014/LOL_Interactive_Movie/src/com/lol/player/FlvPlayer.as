package com.lol.player
{
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.filters.BlurFilter;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class FlvPlayer
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
		private var _volume:SoundTransform;
		
		public function FlvPlayer(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
			videoSetting();
		}
		
		private function init():void
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			
			_volume = new SoundTransform();
			
			_con.swfCon.visible = false;
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.VIDEO_PLAY, readyToPlay);
			_model.addEventListener(LolEvent.PANNING_VIDEO_PLAY, panningVideoPlay);
			_model.addEventListener(LolEvent.VIDEO_PAUSE, videoPause);
			_model.addEventListener(LolEvent.VIDEO_RESUME, videoResume);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
//			/**	테스트용	*/
//			_con.stage.addEventListener(KeyboardEvent.KEY_DOWN, skipVideo);
		}
		
//		protected function skipVideo(e:KeyboardEvent):void
//		{
//			if(_model.videoType != "flv") return;
//			if(e.keyCode == 32) _ns.seek(_totalTime/2);
//			if(e.keyCode == 39) _ns.seek(_ns.time + 1);
//		}
		
		protected function videoPause(e:LolEvent):void
		{		_ns.pause();		}
		
		protected function videoResume(e:LolEvent):void
		{		_ns.resume();		}
		
		protected function panningVideoPlay(e:LolEvent):void
		{
			_ns.dispose();
			playVideo();
		}
		
		private var _setting:Boolean = false;
		protected function readyToPlay(e:LolEvent):void
		{
			if(_setting) return;
			_setting = true;
			_ns.dispose();
			
			if(_model.isPopup){
				if(_model.videoList.interaction.mov[_model.videoNum].mov.length() > 0){
					_model.videoType = _model.videoList.interaction.mov[_model.videoNum].mov[_model.selectPopupBtnNum].@videoType;
					_model.popupType = _model.videoList.interaction.mov[_model.videoNum].mov[_model.selectPopupBtnNum].@popupType;
					if(_model.popupType == "popup") _model.popupNum = _model.videoList.interaction.mov[_model.videoNum].mov[_model.selectPopupBtnNum].@popupNum;
					else if(_model.popupType == "inter") _model.interPopupNum = _model.videoList.interaction.mov[_model.videoNum].mov[_model.selectPopupBtnNum].@popupNum;
					trace("영상 경로___: " + _model.videoPath + " / " + _model.videoList.interaction.mov[_model.videoNum].mov[_model.selectPopupBtnNum].@title + " / " + _model.selectPopupBtnNum + " / " + _model.videoType);
				}else{
					_model.videoType = _model.videoList.interaction.mov[_model.videoNum].@videoType;
					_model.popupType = _model.videoList.interaction.mov[_model.videoNum].@popupType;
					if(_model.popupType == "popup") _model.popupNum = _model.videoList.interaction.mov[_model.videoNum].@popupNum;
					else if(_model.popupType == "inter") _model.interPopupNum = _model.videoList.interaction.mov[_model.videoNum].@popupNum;
					trace("영상 경로___:: " + _model.videoPath + " / " + _model.videoList.interaction.mov[_model.videoNum].@title + " / " + _model.selectPopupBtnNum + " / " + _model.videoType);
				}
				
				_model.isPopup = false;
				_videoPath = _model.videoPath;
			}else{
				_model.videoType = _model.videoList.interaction.mov[_model.videoNum].@videoType;
				_model.popupType = _model.videoList.interaction.mov[_model.videoNum].@popupType;
				if(_model.popupType == "popup") _model.popupNum = _model.videoList.interaction.mov[_model.videoNum].@popupNum;
				else if(_model.popupType == "inter") _model.interPopupNum = _model.videoList.interaction.mov[_model.videoNum].@popupNum;
				
				if(_model.videoNum == 2){
					_model.randomMixNum = Math.random()*8;
					_videoPath = _model.commonPath + _model.videoList.interaction.mov[_model.videoNum].mov[_model.randomMixNum];
					trace("영상 경로___::: " + _videoPath + " / " + _model.videoList.interaction.mov[_model.videoNum].mov[_model.randomMixNum].@title + " / " +  _model.randomMixNum + " / " + _model.videoType);
				}else{
					_videoPath = _model.commonPath + _model.videoList.interaction.mov[_model.videoNum].@videoPath;
					trace("영상 경로___:::: " + _videoPath + " / " + _model.videoList.interaction.mov[_model.videoNum].@title + " / " + _model.videoNum + " / " + _model.videoType);
				}
			}
			
			/**	swf - flv 체크	*/
			if(_model.videoType == "flv"){
				_con.video.visible = true;
				_con.swfCon.visible = false;
				playVideo();
				_setting = false;
			}else if(_model.videoType == "swf"){
				_model.videoPath = _videoPath;
				_con.video.visible = false;
				_con.swfCon.visible = true;
				_model.dispatchEvent(new LolEvent(LolEvent.SWF_VIDEO_PLAY));
				_setting = false;
			}
			
			if(_model.videoNum == 1 || _model.videoNum == 11 || _model.videoNum == 16 || _model.videoNum == 23 || _model.videoNum == 29){
				if(_model.videoNum == 1) _model.quickNum = 0;
				if(_model.videoNum == 11) _model.quickNum = 1;
				if(_model.videoNum == 16) _model.quickNum = 2;
				if(_model.videoNum == 23) _model.quickNum = 3;
				if(_model.videoNum == 29) _model.quickNum = 4;
				_model.dispatchEvent(new LolEvent(LolEvent.REICIVE_QUICK_NUM));
			}
		}
		
		private function soundHandler():void
		{
			var volume:SoundTransform = new SoundTransform();
			if(_con.videoCon.seekBar.btnSnd.currentFrame == 1) volume.volume = 0;
			else volume.volume = 1;
			_ns.soundTransform = volume;
		}
		
		/**	비디오 셋팅	*/
		private function videoSetting():void
		{
			_nc = new NetConnection();
			_nc.connect( null );
			_ns = new NetStream( _nc );
			_video = new Video();
			_video.smoothing = true;
			_video.attachNetStream( _ns );
			_con.video.addChild(_video);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
			
			_model.isPopup = false;
//			_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
			
			_videoPath = _model.commonPath + _model.videoList.intro;
			trace("인트로 비디오 경로_____________>>    " + _videoPath);
			playVideo();
		}
		
		/** 비디오 플레이 **/
		private function playVideo(e:Event = null):void
		{
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
				trace(queName);
				if(queName == "popup") _model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
				
				if(String(queName.substr(0,4)) == "talk"){
					_model.talkPopupNum = int(queName.slice(4));
					if(_model.talkPopupNum > 0) _model.dispatchEvent(new LolEvent(LolEvent.SHOW_TALK_POPUP));
				}
				if(String(queName.substr(0,8)) == "reaction"){
					_model.reactionPopupNum = int(queName.slice(8));
					_model.dispatchEvent(new LolEvent(LolEvent.SHOW_REACTION_POPUP));
				}
//				for (var infoName:String in info) 
//				{	trace("infoName: "+infoName);	}
			};
			
			_ns.client = meta;
			if(_model.isPanningVideo) _ns.play( _model.panningPath);
			else _ns.play( _videoPath);
		}
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" :
					trace("video_Start");
					_ns.pause();
					_con.addEventListener(Event.ENTER_FRAME, removeCoverChk);
					resizeHandler();
					break;
				case "NetStream.Play.Stop" :
					trace("video_Stop");
					if(_model.isPanningVideo == true){
						_model.isPanningVideo = false;
						_model.dispatchEvent(new LolEvent(LolEvent.PANNING_VIDEO_STOP));
					}else{
						videoEnd();
					}
					break;
			}
		}
		
		private function removeCoverChk(e:Event):void
		{
			if(_model.isVideoPause == false)
			{
				if(_ns.bytesLoaded / _ns.bytesTotal >= 0.05)
				{
					removeCover();
					_ns.resume();
				}
			}
		}
		
		private function removeCover():void
		{
			_con.removeEventListener(Event.ENTER_FRAME, removeCoverChk);
			if(_model.isPanningVideo == true) _model.dispatchEvent(new LolEvent(LolEvent.PANNING_HIDE_CONTENTS));
			else _model.dispatchEvent(new LolEvent(LolEvent.REMOVE_COVER));
			_model.dispatchEvent(new LolEvent(LolEvent.DIMMED_OFF));
		}
		
		private function videoEnd():void
		{
			_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
			_ns.dispose();
			if(_model.endingPopup) return;
			
			if(_model.popupType == "popup"){
				if(!_model.isPopup) _model.dispatchEvent(new LolEvent(LolEvent.SELECT_POPUP_OPEN));
			}else if(_model.popupType == "inter"){
				if(!_model.isPopup) _model.dispatchEvent(new LolEvent(LolEvent.INTERACTION_POPUP_OPEN));
			}else if(_model.popupType == "sns"){
				trace("최종 영상 끝___/////____________________    SNS 팝업 띄우기");
			}else{
				if(_model.introChk) _model.introChk = false;
				else _model.videoNum = int(_model.videoList.interaction.mov[_model.videoNum].@videoNum) + 1;
				_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
			}
			
			trace("자식 영상 수: " + _model.videoList.interaction.mov[_model.videoNum].mov.length(), _model.videoNum);
		}
		
		/**	비디오 제거	*/
		private function destroyVideo():void
		{
			_ns.close();
			_video.clear();
			_con.video.removeChild(_video);
			_video = null;
			_playing = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			var stageWidth:Number;
			var stageHeight:Number;
			if(_con.stage.stageWidth > 1024)
			{
				stageWidth = _con.stage.stageWidth;
				_con.video.width = int(_con.stage.stageWidth);
			}
			else
			{
				stageWidth = 1024;
				_con.video.width = 1024;
			}
			if(_con.stage.stageHeight > 600)
			{
				stageHeight = _con.stage.stageHeight;
				_con.video.height = int(_con.stage.stageHeight);
			}
			else
			{
				stageHeight = 600;
				_con.video.height = 600;
			}
			_con.video.scaleX = _con.video.scaleY = Math.max(_con.video.scaleX, _con.video.scaleY);
			_con.video.x = int(stageWidth/2 - _con.video.width/2);
			_con.video.y = int(stageHeight/2 - _con.video.height/2);
//			trace(_con.stage.stageWidth, _con.stage.stageHeight, _con.x, _con.y);
		}
	}
}