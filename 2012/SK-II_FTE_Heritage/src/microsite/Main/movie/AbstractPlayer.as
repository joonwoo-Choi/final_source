package microsite.Main.movie
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class AbstractPlayer
	{
		/** 전체 담기 **/
		protected var _container:MovieClip;
		protected var _ns:NetStream;
		protected var _nc:NetConnection;
		protected var _video:Video;
		protected var _totalTime:Number;
		protected var _videWidth:int;
		protected var _videHeight:int;
		protected var _videoPath:String;
		
		public function AbstractPlayer(container:MovieClip)
		{
			_container = container;			
		}
		/** 비디오 셋팅 **/
		protected function videoSetting():void
		{
			_video = new Video();
			_video.smoothing = true;
			_nc = new NetConnection();
			_nc.connect( null );
			_ns = new NetStream( _nc );
			_video.attachNetStream( _ns );
		}
		/** 비디오 플레이 **/
		protected function playVideo(e:Event = null):void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				_totalTime = info["duration"];
				_videWidth = info["width"];
				_videHeight = info["height"];
				_video.width =  _videWidth;
				_video.height =  _videHeight;
				settingEtc();
			}
			
			meta.onCuePoint = function(info:Object):void{
				
			}
			_ns.client = meta;
			_ns.play( _videoPath );
			_ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
		}
		protected function settingEtc(event:Event=null):void
		{
			
		}
		
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" : 
					videoStartSetting();
					break;
				case "NetStream.Play.Stop" : 
					videoStoppSetting();
					break;
			}
		}
		
		protected function videoStartSetting():void
		{
			
		}
		
		protected function videoStoppSetting():void
		{
			_ns.close();
		}
	}
}