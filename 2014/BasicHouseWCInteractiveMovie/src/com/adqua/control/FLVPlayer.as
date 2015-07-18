package com.adqua.control
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class FLVPlayer
	{
		/**	전체 컨테이너	*/
		private var $con:MovieClip;
		/**	비디오 객체 컨테이너 	*/
		private var $videoCon:MovieClip;
		/**	넷 스트림	*/
		private var $ns:NetStream;
		/**	넷 커넥션	*/
		private var $nc:NetConnection;
		/**	비디오	*/
		private var $video:Video;
		/**	플레이 true / false	*/
		private var $playing:Boolean = true;
		/**	전체 시간	*/
		private var $totalTime:Number;
		/**	비디오 가로 크기	*/
		private var $videoWidth:int;
		/**	비디오 세로 크기	*/
		private var $videoHeight:int;
		/**	비디오 경로	*/
		private var $videoPath:String = "video/SK2WH_Teser.f4v";
		
		public function FLVPlayer(con:MovieClip, videoCon:MovieClip, videoPath:String)
		{
			$con = con;
			
			$videoCon = videoCon;
			
			$videoPath = videoPath;
			
			videoSetting();
		}
		
		/**	비디오 객체 만들기	*/
		private function videoSetting():void
		{
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video = new Video();
			$video.smoothing = true;
			$video.attachNetStream( $ns );
			$videoCon.addChild($video);
			
			playVideo();
		}
		
		/** 비디오 플레이 **/
		private function playVideo():void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				$totalTime = info["duration"];
				$videoWidth = info["width"];
				$videoHeight = info["height"];
				$video.width =  $videoWidth;
				$video.height =  $videoHeight;
				trace("$totalTime: "+$totalTime);
				trace("$videWidth: "+$videoWidth);
				trace("$videHeight: "+$videoHeight);
			};
			
			meta.onCuePoint = function(info:Object):void{
				for (var infoName:String in info) 
				{
					trace("infoName: "+infoName);
				}
			};
			$ns.client = meta;
			$ns.play( $videoPath );
			$ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
		}
		
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" :
					$ns.pause();
//					$main.seekBar.seek.addEventListener(Event.ENTER_FRAME, seekCheckHandler);
					trace("video_Start");
					break;
				case "NetStream.Play.Stop" :
//					destroyVideo();
					trace("video_Stop");
					break;
			}
		}
		
		/**	비디오 제거	*/
		private function destroyVideo():void
		{
			$ns.close();
			$video.clear();
			$con.seekBar.btnToggle.gotoAndStop(2);
			$con.seekBar.btnSnd.sndBar.width = $con.seekBar.btnSnd.btn.width;
			$con.seekBar.seek.removeEventListener(Event.ENTER_FRAME, seekCheckHandler);
//			$con.seekBar.seek.removeEventListener(MouseEvent.MOUSE_DOWN, seekBarHandler);
			$con.seekBar.seek.bar.width = 0;
			$con.videoCon.removeChild($video);
			$video = null;
			$playing = false;
		}
		
		private function seekCheckHandler(e:Event):void
		{
			$con.seekBar.seek.bar.width = $ns.time / $totalTime * $con.seekBar.seek.bg.width;
		}
	}
}