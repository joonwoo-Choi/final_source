package com.bh.player
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="introFinished" , type="flash.events.Event")]
	
	public class IndexFlvPlayer extends EventDispatcher
	{
		public static const INTRO_FINISHED:String = "introFinished";
		
		private var _con:MovieClip;
		private var _commonPath:String;
		
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
		private var _videoPath:String = "mov/intro.f4v";
		
		
		public function IndexFlvPlayer(con:MovieClip, commonPath:String)
		{
			_con = con;
			_commonPath = commonPath;
			
			videoSetting();
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
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			_videoPath = _commonPath + "mov/intro.f4v";
			trace("인트로 비디오 경로_____________>>    " + _videoPath);
			playVideo();
		}
		
		/**	일시정지	*/
		public function videoPause():void
		{
			_ns.pause();
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
				trace("_totalTime: "+_totalTime);
				trace("_videWidth: "+_videoWidth);
				trace("_videHeight: "+_videoHeight);
			};
			
			meta.onCuePoint = function(info:Object):void{};
			
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
					resizeHandler();
					break;
				case "NetStream.Play.Stop" :
					trace("video_Stop");
					videoEnd();
					break;
			}
		}
		
		private function videoEnd():void
		{
			dispatchEvent( new Event(INTRO_FINISHED) );
		}
		
		private function removeCover():void
		{
			
		}
		
		/**	비디오 제거	*/
		public function destroyVideo():void
		{
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, playChk);
			_con.stage.removeEventListener(Event.RESIZE, resizeHandler);
			_ns.close();
			_video.clear();
			_con.video.removeChild(_video);
			_video = null;
			_playing = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
//			if(_con.stage.stageWidth >= 1920 || _con.stage.stageHeight >= 1080)
//			{
				_con.video.width = _con.stage.stageWidth;
				_con.video.height = _con.stage.stageHeight;
				_con.video.scaleX = _con.video.scaleY = Math.max(_con.video.scaleX, _con.video.scaleY);
//			}
			_con.video.x = int(_con.stage.stageWidth/2 - _con.video.width/2);
			_con.video.y = int(_con.stage.stageHeight/2 - _con.video.height/2);
		}
	}
}