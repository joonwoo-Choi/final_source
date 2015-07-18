package microsite.Main.movie
{
	
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class HeritageCycleMovie extends AbstractPlayer
	{
		
		/** 글로벌 클래스 **/
		private var $global:Global;
		/** 망점 담기 **/
		private var $fillPattern:Sprite;
		/** 망점 소스 **/
		private var $dotMC:dot;
		/** 비트맵 데이타 **/
		private var $sourceBmd:BitmapData;
		
		public function HeritageCycleMovie( container:MovieClip )
		{
			super(container);
			
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.XML_LOADED , xmlLoaded );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , movieChange );
			$global.addEventListener( GlobalEvent.CENTER_BUTTON , hideCycleMovie );
			$global.addEventListener( GlobalEvent.VIDEO_OFF , showCycleMovie );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , specialPageOn );
			
			_container.stage.addEventListener( Event.RESIZE, settingEtc );
			_container.addEventListener( Event.ACTIVATE, settingEtc );
		}
		
		protected function specialPageOn(e:Event):void
		{
			_ns.close();
			TweenLite.killTweensOf( _video );
			TweenLite.to( _video , 0.75 , { autoAlpha:0 });
			_container.dotContainer.visible = false;
			_container.stage.removeEventListener( Event.RESIZE, settingEtc );
		}
		
		protected function hideCycleMovie(e:Event):void
		{
			if( $global.centerBtnNum == 0 )
			{
				_ns.close();
				TweenLite.killTweensOf( _video );
				TweenLite.to( _video , 0.75 , { autoAlpha:0 });
				_container.dotContainer.visible = false;
				_container.stage.removeEventListener( Event.RESIZE, settingEtc );
			}
		}
		
		private function showCycleMovie(e:Event):void
		{
//			TweenMax.delayedCall(1.75, playVideo);
			playVideo();
			_container.dotContainer.visible = true;
			_container.stage.addEventListener( Event.RESIZE, settingEtc );
			settingEtc();
		}
		
		/** 페이지 체인지 **/
		protected function movieChange(e:Event):void
		{
			_ns.close();
			TweenLite.killTweensOf( _video );
			TweenLite.to( _video , 0.75 , { autoAlpha:0 });
			_videoPath = SecurityUtil.getPath(_container.root)+$global.essayXml.essay[$global.essayNum].cycle;
			_container.dotContainer.visible = false;
			_container.stage.removeEventListener( Event.RESIZE, settingEtc );
		}
		
		/** 비디오 경로 설정 **/
		protected function xmlLoaded(e:Event):void
		{
			_videoPath = SecurityUtil.getPath(_container.root)+$global.essayXml.essay[$global.essayNum].cycle;
			videoSetting();
		}
		
		/** 비디오 셋팅 **/
		override protected function videoSetting():void
		{
			drawDot();
			super.videoSetting();
			_container.cycleMovie.addChild( _video );
			_video.alpha = 0;
			_video.visible = false;
//			playVideo();		
		}
		
		/** 비디오 플레이 **/
		override protected function playVideo(e:Event = null):void
		{
			super.playVideo();
			TweenLite.killTweensOf( _video );
			TweenLite.to( _video , 1 , {delay:1.75, autoAlpha:1 });
		}
		override protected function videoStoppSetting():void
		{
			_ns.seek( 0 );
		}	
		
		/** 스테이지 망점 그리기 **/
		private function drawDot():void
		{
			$sourceBmd = new dot(0,0);
			$fillPattern = new Sprite;
			_container.dotContainer.addChild( $fillPattern );
			
			settingEtc();
		}
		
		override protected function settingEtc(e:Event=null):void
		{
			if( $fillPattern != null ){
				$fillPattern.graphics.clear();
				$fillPattern.graphics.beginBitmapFill( $sourceBmd );
				$fillPattern.graphics.drawRect( 0 , 0 , _container.stage.stageWidth , _container.stage.stageHeight );
				$fillPattern.graphics.endFill();
			}
			if( _video != null ){
				_container.cycleMovie.width = _container.stage.stageWidth;
				_container.cycleMovie.height = _container.stage.stageHeight;
				_container.cycleMovie.scaleX = _container.cycleMovie.scaleY = Math.max(_container.cycleMovie.scaleX, _container.cycleMovie.scaleY);
			}
		}
	}
}