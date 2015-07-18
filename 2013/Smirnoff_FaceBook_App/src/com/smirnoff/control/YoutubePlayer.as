package com.smirnoff.control
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	[SWF(width="455", height="265", frameRate="60", backgroundColor="0xffffff")]
	public class YoutubePlayer extends Sprite
	{
		private var _videoWidth:int;
		private var _videoHeight:int;
		
		private var _loader:SWFLoader;
		private var _videoLink:String;
		private var _videoPlayer:Object;
		
		private var _videoPlayEnded:Boolean;
		
		public function YoutubePlayer()
		{
			super();
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Security.allowDomain("www.youtube.com");
			
			_videoLink = "O9M8IZA0bzk";
			_videoWidth = 455;
			_videoHeight = 265;
			
			loadYoutubeVideoPlayer();
		}
		
		private function loadYoutubeVideoPlayer():void
		{
			_videoPlayEnded = true;
//			컨트롤 바 & 정보 숨기기      >>      &controls=0&showinfo=0
			_loader = new SWFLoader( "http://www.youtube.com/v/"+_videoLink+"?version=3&feature=player_detailpage&autohide=2&fs=1&rel=0", 
				{ name:"youtube", container:this, onComplete:completeSwf } );
			_loader.load();
		}
		
		private function completeSwf(e:LoaderEvent):void
		{
			_videoPlayer = _loader.rawContent;
			_videoPlayer.addEventListener( "onReady", youtubeOnReady );
			_videoPlayer.addEventListener( "onStateChange", youtubeOnStateChange );
		}
		
		private function youtubeOnReady(e:Event):void
		{
			if(_videoPlayer == null) return;
			
			_videoPlayer.setSize( _videoWidth, _videoHeight );
			_videoPlayer.playVideo();
		}
		
		private function youtubeOnStateChange(e:Event):void
		{
			var value:int = Object(e).data;
			trace("player state:", value);
			switch(value)
			{
				case 0:
					// ended
					_videoPlayEnded = true;
					break;
				case 1:
					// playing
					
					_videoPlayEnded = false;
					break;
				case 2:
					// paused
					
					break;
			}
		}
		
		public function removeYoutubePlayer():void
		{
			if(_videoPlayer == null) return;
			
			_videoPlayer.stopVideo();
			_videoPlayer.destroy();
			_videoPlayer = null;
			
			_loader.unload();
		}
		
	}
}