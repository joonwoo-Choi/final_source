package flvPlayer
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[SWF(width = "1200", height = "700", backgroundColor = "#000000", frameRate = "30")]
	
	public class flvPlayer extends Sprite
	{
		
		private var $container:AssetMain;
		private var $ns:NetStream;
		private var $nc:NetConnection;
		private var $video:Video;
		private var $totalTime:Number;
		private var $videWidth:int;
		private var $videHeight:int;
		private var $videoPath:String = "video/essaymovie2.f4v";
		
		public function flvPlayer()
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , init );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$container = new AssetMain();
			addChild( $container );
			
			videoSetting();
		}
		
		protected function videoSetting():void
		{
			$video = new Video();
			$video.smoothing = true;
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video.attachNetStream( $ns );
			$container.addChild($video);
			
			playVideo();
		}
		/** 비디오 플레이 **/
		protected function playVideo():void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				$totalTime = info["duration"];
				$videWidth = info["width"];
				$videHeight = info["height"];
				$video.width =  $videWidth;
				$video.height =  $videHeight;
				resizeHandler();
			}
			
			meta.onCuePoint = function(info:Object):void{
				
			}
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
					trace("video_Start");
					break;
				case "NetStream.Play.Stop" : 
					trace("video_Stop");
					break;
			}
		}
		
		private function resizeHandler(e:Event=null):void
		{
			if( $video != null ){
				$container.width = $container.stage.stageWidth;
				$container.height = $container.stage.stageHeight;
				$container.scaleX = $container.scaleY = Math.max($container.scaleX, $container.scaleY);
			}
		}
	}
}