package com.proof.microsite.flvPlayer
{
	
	import com.adqua.display.Resize;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class SubFlvPlayer2
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
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
		private var $videoPath:String;
		/**	리사이즈	*/
		private var $resize:Resize;
		
		public function SubFlvPlayer2(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.VIDEO_PLAY, videoSetting);
			
			$resize = new Resize();
			
			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**	비디오 셋팅	*/
		private function videoSetting(e:Event):void
		{
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video = new Video();
			$video.smoothing = true;
			$video.attachNetStream( $ns );
			$con.video.addChild($video);
			$video.alpha = 0;
			
			$videoPath = $model.defaulfPath + "flv/FTE_Sub_Mov_" + $model.subMovNum + ".f4v";
			trace($videoPath);
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
				resizeHandler();
				trace("$totalTime: "+$totalTime);
				trace("$videWidth: "+$videoWidth);
				trace("$videHeight: "+$videoHeight);
			};
			
			meta.onCuePoint = function(info:Object):void{
				for (var infoName:String in info) 
				{	trace("infoName: "+infoName);	}
			};
			
			TweenLite.to($video, 1, {delay:0.5, alpha:1, ease:Cubic.easeOut});
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
					resizeHandler();
					trace("video_Start");
					break;
				case "NetStream.Play.Stop" :
					TweenLite.to($video, 1, {delay:0.5, alpha:0, ease:Cubic.easeOut, onComplete:destroyVideo});
					trace("video_Stop");
					break;
			}
		}
		/**	비디오 제거	*/
		private function destroyVideo():void
		{
			$ns.close();
			
			$video.clear();
			$con.video.removeChild($video);
			$video = null;
			$playing = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$resize.stageResize($con.video, $con.stage.stageWidth, $con.stage.stageHeight, 0, 0, true, true);
			
			//			$video.width = $con.plane.width;
			//			$video.height = $con.plane.height;
			//			$video.scaleX = $video.scaleY = Math.max($video.scaleX, $video.scaleY);
		}
	}
}