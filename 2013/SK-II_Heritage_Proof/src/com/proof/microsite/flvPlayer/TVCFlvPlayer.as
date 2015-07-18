package com.proof.microsite.flvPlayer
{
	import com.adqua.display.Resize;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.filters.BlurFilter;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class TVCFlvPlayer
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
		/**	seekBar 타임아웃	*/
		private var $seekTimeout:uint;
		
		public function TVCFlvPlayer(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.VIDEO_SETTING, videoSetting);
			
			$resize = new Resize();
			
			$con.seekBar.btnToggle.buttonMode = true;
			$con.seekBar.btnSnd.buttonMode = true;
				
			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**	비디오 셋팅	*/
		private function videoSetting(e:Event):void
		{
			addMouseEvent();
			
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video = new Video();
			$video.smoothing = true;
			$video.attachNetStream( $ns );
			$con.video.addChild($video);
//			$video.alpha = 0;
			
			$videoPath = $model.videoPath;
			trace($videoPath);
			playVideo();
		}
		
		private function addMouseEvent():void
		{
			$con.btnPlay.gotoAndStop(2);
			$con.seekBar.btnToggle.gotoAndStop(2);
			$con.seekBar.btnSnd.gotoAndStop(1);
			
			$con.btnPlay.addEventListener(MouseEvent.MOUSE_MOVE, showSeekBar);
			$con.stage.addEventListener(Event.MOUSE_LEAVE, hideSeekBar);
			
			$con.seekBar.addEventListener(MouseEvent.MOUSE_OVER, seekbarOverHandler);
			
			$con.seekBar.btnToggle.addEventListener(MouseEvent.CLICK, toggleHandler);
			$con.seekBar.btnSnd.addEventListener(MouseEvent.CLICK, soundHandler);
			
			$con.seekBar.seek.addEventListener(Event.ENTER_FRAME, seekCheckHandler);
		}
		
		private function showSeekBar(e:MouseEvent):void
		{
			TweenLite.to($con.seekBar, 0.75, {y:$con.plane.height - $con.seekBar.height, ease:Cubic.easeOut});
			clearTimeout($seekTimeout);
			$seekTimeout = setTimeout(hideSeekBar, 2000);
		}
		
		private function hideSeekBar(e:Event = null):void
		{		TweenLite.to($con.seekBar, 0.75, {y:$con.plane.height, ease:Cubic.easeOut});	}
		
		private function seekbarOverHandler(e:MouseEvent):void
		{
			TweenLite.to($con.seekBar, 0.75, {y:$con.plane.height - $con.seekBar.height, ease:Cubic.easeOut});
			clearTimeout($seekTimeout);
		}
		
		private function toggleHandler(e:MouseEvent):void
		{
			$ns.togglePause();
			if($con.seekBar.btnToggle.currentFrame == 1) 
			{
				$con.seekBar.seek.addEventListener(Event.ENTER_FRAME, seekCheckHandler);
				$con.seekBar.btnToggle.gotoAndStop(2);
				$con.btnPlay.gotoAndStop(1);
			}
			else 
			{
				$con.seekBar.seek.removeEventListener(Event.ENTER_FRAME, seekCheckHandler);
				$con.seekBar.btnToggle.gotoAndStop(1);
				$con.btnPlay.gotoAndStop(2);
			}
			
			TweenMax.to($con.btnPlay, 1, {
				alpha:1,
				colorTransform:{exposure:1.2},
				reversed:true,
				ease:Cubic.easeOut
			});
		}
		
		private function soundHandler(e:MouseEvent):void
		{
			var volume:SoundTransform = new SoundTransform();
			if($con.seekBar.btnSnd.currentFrame == 1) 
			{
				volume.volume = 0;
				$con.seekBar.btnSnd.gotoAndStop(2);
			}
			else 
			{
				volume.volume = 1;
				$con.seekBar.btnSnd.gotoAndStop(1);
			}
			$ns.soundTransform = volume;
			trace($ns.soundTransform.volume);
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
			
			TweenMax.to($video, 1, {
				alpha:0,
				colorTransform:{exposure:1.2},
				reversed:true,
				ease:Cubic.easeOut
			});
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
			$con.btnPlay.gotoAndStop(1);
			$con.seekBar.btnToggle.gotoAndStop(1);
			$con.seekBar.btnSnd.gotoAndStop(1);
			
			$con.btnPlay.removeEventListener(MouseEvent.MOUSE_MOVE, showSeekBar);
			$con.stage.removeEventListener(Event.MOUSE_LEAVE, hideSeekBar);
			$con.seekBar.removeEventListener(MouseEvent.MOUSE_OVER, seekbarOverHandler);
			$con.seekBar.btnToggle.removeEventListener(MouseEvent.CLICK, toggleHandler);
			$con.seekBar.btnSnd.removeEventListener(MouseEvent.CLICK, soundHandler);
			$con.seekBar.seek.removeEventListener(Event.ENTER_FRAME, seekCheckHandler);
			
			$ns.close();
			$video.clear();
			$con.video.removeChild($video);
			$video = null;
			$playing = false;
			
			hideSeekBar();
			$model.dispatchEvent(new ModelEvent(ModelEvent.VIDEO_STOP));
		}
		
		private function seekCheckHandler(e:Event):void
		{
			$con.seekBar.seek.bar.width = $ns.time / $totalTime * $con.seekBar.seek.bg.width;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$resize.stageResize($con.video, $con.plane.width, $con.plane.height, 0, 0, true, true);
		}
	}
}