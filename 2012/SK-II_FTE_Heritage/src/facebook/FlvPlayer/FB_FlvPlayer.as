package facebook.FlvPlayer
{
	
	import adqua.event.XMLLoaderEvent;
	import adqua.net.LoadVars;
	import adqua.net.XMLLoader;
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.lumpens.utils.ButtonUtil;
	import com.lumpens.utils.JavaScriptUtil;
	import com.sw.net.list.Page;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.Main.MainModel;
	
	import org.osmf.events.SeekEvent;
	
	[SWF(width = "700", height = "393", backgroundColor = "#2b2b2b", frameRate = "30")]
	
	public class FB_FlvPlayer extends Sprite
	{
		
		/** Asset **/
		private var $main:Asset_FB_FlvPlayer;
		/** 플레이 상태 **/
		private var $playIs:String = "reset";
		/** 타임아웃 **/
		private var $timeOut:uint;
		/** 페이지 번호 받아오기 **/
		private var $flashVars:Object;
		/** 페이지 번호 **/
		private var $pageNum:int;
		/** xml **/
		private var $xml:XML;
		private var $loadVars:LoadVars;
		
		public function FB_FlvPlayer()
		{
			if( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/** init **/
		private function init():void
		{
			removeEventListener( Event.ADDED_TO_STAGE , init );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new Asset_FB_FlvPlayer;
			addChild( $main );
			
			$flashVars = root.loaderInfo.parameters;
			if($flashVars["pageNum"]==undefined){
				$pageNum = 1;
			}else{
				$pageNum = root.loaderInfo.parameters.pageNum - 1;
			}
			
			btnSetting();
			activeVideo();
			xmlLoad();
			stage.addEventListener( Event.RESIZE, resizeHandler );
		}
		
		/** XML 로드 **/
		private function xmlLoad():void
		{
			var essayListLoader:XMLLoader = new XMLLoader();
			essayListLoader.load(SecurityUtil.getPath(root)+"xml/FB_movList.xml");
			essayListLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE,xmlLoadHandler);
		}
		
		/** XML 로드 완료 **/
		private function xmlLoadHandler(e:XMLLoaderEvent):void {
			$xml = new XML( e.xml );
		}
		
		protected function resizeHandler(event:Event):void
		{
			if( $video != null ){
				$main.movContainer.width = $main.stage.stageWidth;
				$main.movContainer.height = $main.stage.stageHeight;
				$main.movContainer.scaleX = $main.movContainer.scaleY = Math.max($main.movContainer.scaleX, $main.movContainer.scaleY);
			}
		}
		
		/** 버튼 셋팅 **/
		private function btnSetting():void
		{
			ButtonUtil.makeButton( $main.btnPlay, btnPlayHandler );
			ButtonUtil.movButton( $main.movControl.btnToggle, toggleBtnHandler );
			ButtonUtil.movButton( $main.movControl.btnSound, soundBtnHandler );
			ButtonUtil.containerButton( $main.movControl, movControlHandler );
		}
		
		/** btnPlay 버튼 이벤트 **/
		private function btnPlayHandler( e:MouseEvent ):void
		{
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : clearTimeout( $timeOut ); movControllView( "over" ); break;
				case MouseEvent.MOUSE_OUT : $timeOut = setTimeout( movControllView , 1000 , "out" ); break;
				case MouseEvent.CLICK : 
					if( $playIs == "reset" ) 
						TweenMax.to( $main.imgClip , 1.5 , { alpha:0 , ease:Cubic.easeOut , onComplete:playVideo }); 
						TweenMax.to( $main.toggleView , 1.5 , { alpha:0 , ease:Cubic.easeOut });
					break;
			}
		}
		
		/** movControl 이벤트 **/
		private function movControlHandler( e:MouseEvent ):void
		{
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : clearTimeout( $timeOut ); movControllView( "over" ); break;
				case MouseEvent.MOUSE_OUT : $timeOut = setTimeout( movControllView , 1000 , "out" ); break;
			}
		}
		
		/** 이벤트 활성화  **/
		private function movControllView( e:String ):void
		{
			switch ( e ) {
				case "over" : 
					if( $playIs == "start" ) TweenMax.to( $main.movControl , 0.5 , { y:353 , ease:Cubic.easeOut });
					break;
				case "out" : 
					if( $playIs == "start" ) TweenMax.to( $main.movControl , 0.5 , { y:393 , ease:Cubic.easeOut });
					break;
			}
		}
		
		/** movControl 플레이 토글 버튼  **/
		private function toggleBtnHandler( e:MouseEvent ):void
		{
			if( e.type == MouseEvent.CLICK ) {
				$ns.togglePause();
				TweenMax.killTweensOf( $main.toggleView );
				$main.toggleView.alpha = 1;
				TweenMax.to( $main.toggleView , 0.8 , { delay:0.8 , alpha:0 , ease:Cubic.easeOut });
				switch ( $main.movControl.btnToggle.currentFrame ) {
					case 1 : 
						$main.movControl.seekBar.addEventListener( Event.ENTER_FRAME , seekChk );
						$main.movControl.btnToggle.gotoAndStop(2);
						$main.toggleView.gotoAndStop(1);
						break;
					case 2 : 
						$main.movControl.seekBar.removeEventListener( Event.ENTER_FRAME , seekChk );
						$main.movControl.btnToggle.gotoAndStop(1);
						$main.toggleView.gotoAndStop(2);
						break;
				}
			}
		}
		
		/** seek bar 사운드 토글 버튼 **/
		private function soundBtnHandler( e:MouseEvent ):void
		{
			if( e.type == MouseEvent.CLICK ) {
				switch ( $main.movControl.btnSound.currentFrame ) {
					case 1 : 
						$st.volume = 0;
						$ns.soundTransform = $st;
						$main.movControl.btnSound.gotoAndStop(2); 
						break;
					case 2 : 
						$st.volume = 1;
						$ns.soundTransform = $st;
						$main.movControl.btnSound.gotoAndStop(1); 
						break;
				}
			}
		}
		
		/** 비디오 객체 **/
		private var $video:Video;
		/** 넷커넥션 **/
		private var $nc:NetConnection;
		/** 넷스트림 **/
		private var $ns:NetStream;
		/** 비디오 사운드 **/
		private var $st:SoundTransform
		/** 비디오 총 시간 **/
		private var $totalTime:Number;
		/** 비디오 가로 크기 **/
		private var $videWidth:int;
		/** 비디오 가세로 크기 **/
		private var $videHeight:int;
		
		/** 비디오 커넥트 **/
		private function activeVideo():void
		{
			$video = new Video();
			$main.movContainer.addChild( $video );
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video.attachNetStream( $ns );
			$st = new SoundTransform;
			$ns.soundTransform = $st;
		}
		
		/** 비디오 플레이 **/
		private function playVideo():void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				$totalTime = info["duration"];
				$videWidth = info["width"];
				$videHeight = info["height"];
				$video.width =  $videWidth;
				$video.height =  $videHeight;
				stage.dispatchEvent( new Event( Event.RESIZE ));
			}
			$ns.client = meta;
			
			$video.alpha = 0;
			TweenMax.to( $video , 1.5 , { alpha:1 });
			$ns.play( SecurityUtil.getPath(root)+$xml.mov[$pageNum] );
			$ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
		}
		
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" : 
					$playIs = "start";
					/** 트래킹 전달 **/
					JavaScriptUtil.call( "gTracking" , MainModel.getInstance().gmovAry[$pageNum] );
					$main.movControl.seekBar.addEventListener( Event.ENTER_FRAME , seekChk );
					$main.movControl.seekMove.addEventListener( MouseEvent.MOUSE_DOWN , seekMoveHandler );
					$main.btnPlay.buttonMode = false;
					$main.btnPlay.alpha = 0;
					$main.toggleView.gotoAndStop( 2 );
					$main.movControl.btnToggle.gotoAndStop(2);
					break;
				case "NetStream.Play.Stop" : 
					$playIs = "stop"
					/** 트래킹 전달 **/
					JavaScriptUtil.call( "realTracking" , MainModel.getInstance().realnumAry[$pageNum] );
					$main.movControl.seekBar.removeEventListener( Event.ENTER_FRAME , seekChk );
					TweenMax.to( $video , 1.5 , { alpha:0 , onComplete:defaultSetting });
					plusMovieCount();
					break;
			}
		}
		
		private function seekMoveHandler( e:MouseEvent ):void
		{
			
		}
		
		protected function seekChk( e:Event ):void
		{
			$main.movControl.seekBar.scaleX = $ns.time / $totalTime;
		}
		
		/** 무비 카운트 더하기 **/
		private function plusMovieCount():void
		{
			var sendData:URLVariables = new URLVariables();
			sendData.mov = "mov"+(int($pageNum)+1);
			sendData.t = "set";
			sendData.s = "F";
			$loadVars = new LoadVars(Global.getIns().dataURL+"/Process/MovieCount.ashx", sendData,URLRequestMethod.POST,URLLoaderDataFormat.TEXT);
		}
		
		/** 초기화 **/
		public function defaultSetting():void{
			$playIs = "reset";
			$main.btnPlay.buttonMode = true;
			TweenMax.to( $main.imgClip , 1.5 , { alpha:1 , ease:Cubic.easeOut });
			TweenMax.to( $main.toggleView , 1.5 , { alpha:1 , ease:Cubic.easeOut });
			TweenMax.to( $main.movControl , 0.5 , { y:393 , ease:Cubic.easeOut });
			$main.toggleView.gotoAndStop(1);
			$main.movControl.btnToggle.gotoAndStop(1);
			$main.movControl.btnSound.gotoAndStop(1);
			$st.volume = 1;
			$ns.soundTransform = $st;
			$ns.close();
		}
	}
}