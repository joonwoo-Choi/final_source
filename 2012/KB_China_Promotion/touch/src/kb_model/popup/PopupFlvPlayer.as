package kb_model.popup
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class PopupFlvPlayer
	{
		/**	모델	*/
		private var $model:Model;
		/**	컨테이너	*/
		private var $con:MovieClip;
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
		
		public function PopupFlvPlayer(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.MODEL_POPUP, showPopup);
			
			makeButton();
		}
		
		private function showPopup(e:Event):void
		{
			if($model.popupNum > 0) return;
			$con.btnPlay.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function makeButton():void
		{
			/**	시작 버튼	*/
			$con.btnPlay.buttonMode = true;
			$con.btnPlay.addEventListener(MouseEvent.CLICK, playHandler);
			
			/**	시작, 일시정지 토글 버튼	*/
			$con.btnToggle.buttonMode = true;
			$con.btnToggle.addEventListener(MouseEvent.CLICK, btnToggleHandler);
			
			/**	닫기 버튼	*/
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function playHandler(e:MouseEvent):void
		{
			TweenMax.to($con.img, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($con.cover, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			TweenMax.to($con.btnPlay, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:videoSetting});
		}
		
		private function btnToggleHandler(e:MouseEvent):void
		{
			$ns.togglePause()
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new ModelEvent(ModelEvent.LIST_ALPHA_1));
			if($video != null) TweenMax.to($video, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destroyVideo});
			TweenMax.to($con, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
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
			$con.mov.addChild($video);
			
			$videoPath = $model.defaultURL + $model.ModelXml.list[0].@url;
			trace("$videoPath: " + $videoPath);
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
				trace("$videoWidth: "+$videoWidth);
				trace("$videoHeight: "+$videoHeight);
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
					trace("video_Start");
					break;
				case "NetStream.Play.Stop" :
					TweenMax.to($video, 0.75, {autoAlpha:0, ease:Cubic.easeOut, onComplete:destroyVideo});
					trace("video_Stop");
					break;
			}
		}
		
		/**	비디오 제거	*/
		private function destroyVideo():void
		{
			$ns.close();
			$video.clear();
			$con.mov.removeChild($video);
			$video = null;
			$playing = false;
			
			TweenMax.to($con.img, 0, {autoAlpha:1});
			TweenMax.to($con.cover, 0, {autoAlpha:1});
			TweenMax.to($con.btnPlay, 0, {autoAlpha:1});
			
			trace("_____비디오 제거_____$video == " + $video);
		}
		/**	리사이즈 핸들러		*/
		private function resizeHandler(e:Event=null):void
		{
			if( $video != null ){
				/**	사이즈 맞추기	*/
				$con.mov.width = $con.maskMC.width;
				$con.mov.height = $con.maskMC.height;
				$con.mov.scaleX = $con.mov.scaleY = Math.max($con.mov.scaleX, $con.mov.scaleY);
				
				/**	비디오 X,Y축 가운데 정렬*/
//				$con.mov.x = $con.cover.width/2 - $con.mov.width/2;
//				$con.mov.y = $con.cover.height/2 - $con.mov.height/2;
//				trace($con.mov.x, $con.cover.x);
			}
		}
	}
}