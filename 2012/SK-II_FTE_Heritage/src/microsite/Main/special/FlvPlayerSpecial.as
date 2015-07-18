package microsite.Main.special
{
	
	import adqua.event.XMLLoaderEvent;
	import adqua.net.LoadVars;
	import adqua.net.XMLLoader;
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
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
	
	public class FlvPlayerSpecial extends Sprite
	{
		
		/** Asset **/
		private var $main:Asset_FlvPlayer;
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
		
		public function FlvPlayerSpecial(mainCon:SpecialCon)
		{
			$mainCon = mainCon;
			TweenPlugin.activate([AutoAlphaPlugin]);
			$model = MainModel.getInstance();
			if( stage ) init();
			else addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		/** init **/
		private function init(event:Event=null):void
		{
			$btnClose = new MCBtnClose;
			$btnClose.x = 720;
			$btnShare = new MCBtnShare;
			$btnShare.x = $btnClose.x;
			$btnShare.y = $btnClose.height;
			
			$btnClose.addEventListener(MouseEvent.CLICK,onCloseClick);
			$btnShare.addEventListener(MouseEvent.CLICK,onBtnShare);
			$btnShare.addEventListener(MouseEvent.ROLL_OVER,onBtnShareOver);
			$btnShare.addEventListener(MouseEvent.ROLL_OUT,onBtnShareOut);
			
			$btnClose.buttonMode = $btnShare.buttonMode = true;
			
			addChild($btnClose);
			addChild($btnShare);
			
			removeEventListener( Event.ADDED_TO_STAGE , init );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new Asset_FlvPlayer;
			addChild( $main );
			
			$flashVars = root.loaderInfo.parameters;
			if($flashVars["pageNum"]==undefined){
				$pageNum = 0;
			}else{
				$pageNum = root.loaderInfo.parameters.pageNum - 1;
			}
			
			btnSetting();
			activeVideo();
			$model.addEventListener(GlobalEvent.SPECIAL_BTN_CLICK,changeContent);
		}
		
		protected function changeContent(event:Event):void
		{
			if($model.activeSpecialNum>3){
				$main.imgClip.alpha=1 
				$main.toggleView.alpha=1;
				defaultImgLoad();
			}
		}
		
		protected function onBtnShareOut(evt:MouseEvent):void
		{
			var btn:MCBtnShare = evt.currentTarget as MCBtnShare;
			TweenLite.to(btn.over,.5,{alpha:0});
		}
		
		protected function onBtnShareOver(evt:MouseEvent):void
		{
			var btn:MCBtnShare = evt.currentTarget as MCBtnShare;
			TweenLite.to(btn.over,.5,{alpha:1});
		}
		
		protected function onBtnShare(event:MouseEvent):void
		{
			var paramNum:int = ($model.activeSpecialNum==4)?1:2;
			JavaScriptUtil.call("fbscrap",paramNum);
			JavaScriptUtil.call( "gTracking" , $model.specialMovieShareG[$model.activeSpecialNum-4] );
			JavaScriptUtil.call( "realTracking" , $model.specialMovieShareR[$model.activeSpecialNum-4] );
		}
		
		protected function onCloseClick(event:MouseEvent):void
		{
			defaultSetting();
			$main.movControl.seekBar.removeEventListener( Event.ENTER_FRAME , seekChk );
			$video.alpha=0
			$mainCon.onCloseClick();
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
					if( $playIs == "start" ) TweenMax.to( $main.movControl , 0.5 , { y:448 , ease:Cubic.easeOut });
					break;
				case "out" : 
					if( $playIs == "start" ) TweenMax.to( $main.movControl , 0.5 , { y:488 , ease:Cubic.easeOut });
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
			$video = new Video(720,488);
			$video.smoothing = true;
			$main.movContainer.addChild( $video );
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video.attachNetStream( $ns );
			$st = new SoundTransform;
			$ns.soundTransform = $st;
			
		}
		
		private function defaultImgLoad():void
		{
			remvoePrevImg();
			var url:String=SecurityUtil.getPath(root)+"img/"+$imgURL[$model.activeSpecialNum-4];
			$imgLoader = new ImageLoader(url, 
				{container:$main.imgClip, 
					smoothing:true,
					onComplete:imgSetting,
					alpha:0
				});
			$imgLoader.load();	
			
		}
		
		private function imgSetting(evt:LoaderEvent):void
		{
			TweenLite.to(evt.target.content, .5,{alpha:1});
		}
		
		private function remvoePrevImg():void
		{
			if($main.imgClip.numChildren>0){
				$main.imgClip.removeChildAt(0);
			}
		}
		
		/** 비디오 플레이 **/
		private var $videoURL:Array = ["30s_edit_cut0.f4v","30s_edit_cut1.f4v"];
		private var $imgURL:Array = ["specialDefault0.png","specialDefault1.png"];
		private function playVideo():void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				trace( "$videWidth: ",int(info["width"]) );
				trace( "$$videHeight: ",int(info["height"]) );
				trace( "$duration: ",int( info["duration"]) );
				$totalTime = info["duration"];
				$videWidth = info["width"];
				$videHeight = info["height"];
			}
			$ns.client = meta;
			$video.alpha = 0;
			$ns.play( SecurityUtil.getPath(root)+"video/"+$videoURL[$model.activeSpecialNum-4]);
			TweenMax.to( $video , 0.75 , {delay:1.5, alpha:1 });
			$ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
		}
		
		private var $model:MainModel;
		private var $imgLoader:ImageLoader;
		private var $btnClose:MCBtnClose;
		private var $btnShare:MCBtnShare;
		private var onComplete:Object;
		private var $mainCon:SpecialCon;
		
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			trace("event.info.code: ",e.info.code);
			switch(e.info.code)
			{
				case "NetStream.Play.Start" : 
					$playIs = "start";
					/** 트래킹 전달 **/
					JavaScriptUtil.call( "gTracking" , $model.gmovArySpecial[$model.activeSpecialNum-4] );
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
					JavaScriptUtil.call( "realTracking" , MainModel.getInstance().realnumArySpcialCut[$model.activeSpecialNum-4] );
					$main.movControl.seekBar.removeEventListener( Event.ENTER_FRAME , seekChk );
					TweenMax.to( $video , 1.5 , { alpha:0 , onComplete:defaultSetting });
					break;
			}
		}
		
		private function seekMoveHandler( e:MouseEvent ):void
		{
			
		}
		
		protected function seekChk( e:Event ):void
		{
			$main.movControl.seekBar.width = $ns.time / $totalTime * $main.movControl.bg.width;
			trace( $main.movControl.seekBar.scaleX );
		}
		
		
		/** 초기화 **/
		public function defaultSetting():void{
			$playIs = "reset";
			$main.btnPlay.buttonMode = true;
			
			TweenMax.to( $main.imgClip , 1.5 , { alpha:1 , ease:Cubic.easeOut });
			TweenMax.to( $main.toggleView , 1.5 , { alpha:1 , ease:Cubic.easeOut });
			TweenMax.to( $main.movControl , 0.5 , { y:488 , ease:Cubic.easeOut });
			$main.toggleView.gotoAndStop(1);
			$main.movControl.btnToggle.gotoAndStop(1);
			$main.movControl.btnSound.gotoAndStop(1);
			$st.volume = 1;
			$ns.soundTransform = $st;
			$ns.close();
			trace( "$playIs: ",$playIs );
		}
	}
}