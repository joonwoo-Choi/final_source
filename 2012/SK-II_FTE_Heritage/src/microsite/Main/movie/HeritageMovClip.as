package microsite.Main.movie
{
	
	import adqua.event.LoadVarsEvent;
	import adqua.net.Debug;
	import adqua.net.LoadVars;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.layout.AlignMode;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	import com.lumpens.utils.ButtonUtil;
	import com.lumpens.utils.JavaScriptUtil;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	import flash.utils.setTimeout;
	
	import microsite.Main.MainCtrler;
	import microsite.Main.MainModel;
	
	import orpheus.system.SecurityUtil;

	public class HeritageMovClip extends AbstractPlayer
	{
		/** 망점 담기 **/
		private var $fillPattern:Sprite;
		/** 망점 소스 **/
		private var $dotMC:dot;
		/** 비트맵 데이타 **/
		private var $sourceBmd:BitmapData;
		/** 영상 번호 **/
		private var $videoNum:int;
		/** 영상 경로 **/
//		private var _videoPath:String;
		/** Global **/
		private var $global:Global;
		/** 에세이 XML **/
		private var $essayXml:XML;
		
		public function HeritageMovClip( container:MovieClip )
		{
			$model = MainModel.getInstance();
			$ctrler = MainCtrler.getInstance();
			super(container);
			init();
		}
		
		private function init():void
		{
			$model.addEventListener(GlobalEvent.MOVIE_COUNT_CHANGED,completeHandler);
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.XML_LOADED , xmlLoaded );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , pageChanged );
			$global.addEventListener( GlobalEvent.VIDEO_PLAY , playVideoHandler );
			$global.addEventListener( GlobalEvent.VIDEO_PAUSE , pauseVideoHandler );
			$global.addEventListener( GlobalEvent.VIDEO_ON , videoOnHandler );
			$global.addEventListener( GlobalEvent.VIDEO_OFF , videoOffHandler );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , defaultSetting );
			
			drawDot();
			videoSetting();
		}
		
		
		protected function videoOnHandler(e:Event):void
		{
			_container.stage.addEventListener( Event.RESIZE, fillPattern );
			fillPattern();
			TweenMax.to( _video, 1, { autoAlpha:1 });
		}
		
		protected function fillPattern(event:Event=null):void
		{
			trace(":::::::::::::::::::::::::::::::::fillPattern");
			$fillPattern.graphics.clear()
			$fillPattern.graphics.beginBitmapFill( $sourceBmd );
			$fillPattern.graphics.drawRect( 0 , 0 , _container.stage.stageWidth , _container.stage.stageHeight );
			$fillPattern.graphics.endFill();
			
			if( _video != null ){
				resezeMC(Sprite(_container.movContainer.mov));
				_container.movContainer.mov.scaleX = _container.movContainer.mov.scaleY = Math.max(_container.movContainer.mov.scaleX, _container.movContainer.mov.scaleY);
				
				centerMC(Sprite(_container.movContainer.mov));
				
				TweenLite.killTweensOf( _container.movContainer.controllClip );
				TweenLite.to( _container.movContainer.controllClip , 0.5, { y:_container.stage.stageHeight - 77 });
				
				_container.movContainer.controllClip.movControl.mcBG.width = _container.stage.stageWidth;
				_container.movContainer.controllClip.controllerMask.width = _container.stage.stageWidth;
				
				_container.movContainer.controllClip.movControl.seekBar.width = _container.movContainer.controllClip.movControl.mcBG.width - 65;
				_container.movContainer.controllClip.movControl.toggleSound.x = _container.movContainer.controllClip.movControl.mcBG.width - 29;
			}
			
			/** imgStop 위치 **/
			centerMC(Sprite(_container.movContainer.mcBtn));
			
			/** btnStop 리사이즈 **/
			resezeMC(Sprite(_container.movContainer.btnStop));
		}
		
		private function centerMC(param0:Sprite):void
		{
			param0.x = (_container.stage.stageWidth - param0.width) / 2;
			param0.y = (_container.stage.stageHeight - param0.height) / 2;			
		}
		
		
		private function resezeMC(param0:Sprite):void
		{
			param0.width=_container.stage.stageWidth;
			param0.height=_container.stage.stageHeight;
		}
		
		protected function videoOffHandler(e:Event):void
		{
			_container.stage.removeEventListener( Event.RESIZE, fillPattern );
			TweenMax.to( _video, 1, { autoAlpha:0 });
		}
		
		/** 비디오 플레이 **/
		protected function playVideoHandler(e:Event):void
		{
			playVideo();
		}
		
		/** 비디오 일시정지 **/
		protected function pauseVideoHandler(event:Event):void
		{ _ns.togglePause(); }
		
		/** 에세이 페이지 변환 시 실행 **/
		protected function pageChanged(e:Event):void
		{
			defaultSetting();
			$videoNum = $global.essayNum;
			_videoPath = SecurityUtil.getPath(_container.root)+$essayXml.essay[$videoNum].mov;
//			videoPath();
		}
		
		/** XML 로드 **/
		protected function xmlLoaded(e:Event):void
		{
			$essayXml = $global.essayXml;
			_videoPath = SecurityUtil.getPath(_container.root)+$essayXml.essay[$videoNum].mov;
//			TweenMax.delayedCall(0.75,playVideo);
		}
		
//		private function videoPath():void
//		{
//			_videoPath = SecurityUtil.getPath(_container.root)+$essayXml.essay[$videoNum].mov;
//			TweenMax.killDelayedCallsTo(playVideo);
//			TweenMax.delayedCall(0.75, playVideo);
//			trace("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
//		}
		
		/** 스테이지 망점 그리기 **/
		private function drawDot():void
		{
			$sourceBmd = new dot(0,0);
			$fillPattern = new Sprite;
			_container.movContainer.dot.addChild( $fillPattern );
		}
		
		override protected function settingEtc(e:Event=null):void
		{
			_container.stage.dispatchEvent( new Event( Event.RESIZE ));
		}
		
		/** 비디오 사운드 **/
		private var $st:SoundTransform;
		private var $loadVars:LoadVars;
		private var $model:MainModel;
		private var $ctrler:MainCtrler;
		
		/** 비디오 셋팅 **/
		override protected function videoSetting():void
		{
			super.videoSetting();
			_container.movContainer.mov.addChild( _video );
			
			$st = new SoundTransform;
			_ns.soundTransform = $st;
			
			ButtonUtil.movButton( _container.movContainer.controllClip.movControl.toggleSound , soundBtnHandler );
		}
		
		/** 사운드 조절 **/
		private function soundBtnHandler( e:MouseEvent ):void
		{
			if( e.type == MouseEvent.CLICK ) {
				switch ( _container.movContainer.controllClip.movControl.toggleSound.currentFrame ) {
					case 1 : 
						$st.volume = 0;
						_ns.soundTransform = $st;
						_container.movContainer.controllClip.movControl.toggleSound.gotoAndStop(2); 
						break;
					case 2 : 
						$st.volume = 1;
						_ns.soundTransform = $st;
						_container.movContainer.controllClip.movControl.toggleSound.gotoAndStop(1); 
						break;
				}
			}
		}
		
		/** 비디오 플레이 **/
		override protected function playVideo(e:Event = null):void
		{
			$global.playIs = true;
			super.playVideo();
			videoShow();
		}
		
		private function videoShow():void
		{
			_video.alpha = 0;
			TweenLite.killTweensOf( _video );
			TweenLite.to( _video , 1 , {delay:1.5,  autoAlpha:1 });
		}
		
		override protected function videoStartSetting():void
		{
			$global.$playIs = "start";
			_container.movContainer.controllClip.movControl.seekBar.bar.addEventListener( Event.ENTER_FRAME , seekChk );
		}		
		
		override protected function videoStoppSetting():void{
			$global.$playIs = "stop"
			_container.movContainer.controllClip.movControl.seekBar.bar.removeEventListener( Event.ENTER_FRAME , seekChk );
			/** 트래킹 전달 **/
			JavaScriptUtil.call( "realTracking" , $model.realmovAry[$global.essayNum] );
			plusMovieCount();
			defaultSetting();			
		}
		
		/** 무비 카운트 더하기 **/
		private function plusMovieCount():void
		{
			$ctrler.getMovieCnt("set");
			$global.dispatchEvent( new Event( GlobalEvent.VIDEO_OFF ));
		}
		
		protected function completeHandler(evt:GlobalEvent):void
		{
			TweenLite.delayedCall(2,function():void{
				$model.dispatchEvent(new GlobalEvent(GlobalEvent.PLUS_FLIP_COUNT));
			});
		}
		
		protected function seekChk( e:Event ):void
		{
			_container.movContainer.controllClip.movControl.seekBar.bar.scaleX = _ns.time / _totalTime;
		}
		
		/** 초기화 **/
		public function defaultSetting(e:Event=null):void{
			$global.$playIs = "reset";
			TweenLite.killTweensOf( _video );
			TweenLite.to( _video , 1, { autoAlpha:0 });
			TweenLite.to( _container.movContainer.controllClip.movControl , 0.5, { y:40 });
			_container.movContainer.controllClip.movControl.toggleSound.gotoAndStop(1);
			$st.volume = 1;
			_ns.soundTransform = $st;
			_ns.close();
			_container.stage.removeEventListener( Event.RESIZE, fillPattern );
			if( $global.essayNum != 5 )	$global.dispatchEvent( new Event( GlobalEvent.VIDEO_STOP ));
			trace( "$playIs: ",$global.$playIs );
		}
	}
}