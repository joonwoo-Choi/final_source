package microsite.Main.movie
{
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HeritageTitleMovie extends AbstractPlayer
	{
		/** 글로벌 클래스 **/
		private var $global:Global;
		/** 비디오 Y값 **/
		private var $videoY:int;
		/** 타임 아웃 **/
		private var $timeOut:uint;
		
		public function HeritageTitleMovie( container:MovieClip )
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			super(container);
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.XML_LOADED , xmlLoaded );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , titleChanged );
			$global.addEventListener( GlobalEvent.ACTIVE_RESIZE , resizeHandler );
			$global.addEventListener( GlobalEvent.CENTER_BUTTON , videoClose );
			$global.addEventListener( GlobalEvent.VIDEO_OFF , delayPlayVideo );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , videoClose );
		}
		
		protected function resizeHandler(e:Event = null):void
		{
			var percentY:Number = (_container.stage.stageHeight-1 - 769) / 230;
			if( _container.stage.stageHeight < 1000 && _container.stage.stageHeight > 768 )
			{ _container.titleContainer.y = int(100 + percentY*90); }
			else if( _container.stage.stageHeight <= 768 )
			{ _container.titleContainer.y = 100; }
			else 
			{ _container.titleContainer.y = $global.titleY + (_container.stage.stageHeight - 1000)/4; }
			
			_container.titleContainer.x = $global.titleMovX-_container.titleContainer.width;
		}
		
		/** 페이지 체인지 **/
		protected function titleChanged(e:Event):void
		{
			_ns.close();
			_videoPath = SecurityUtil.getPath(_container.root)+$global.essayXml.essay[$global.essayNum].title;
		}
		
		protected function videoClose(e:Event = null):void
		{ if($global.centerBtnNum == 0) _ns.close(); }
		
		/** 비디오 경로 설정 **/
		protected function xmlLoaded(e:Event):void
		{
			_videoPath = SecurityUtil.getPath(_container.root)+$global.essayXml.essay[$global.essayNum].title;
			videoSetting();
		}
		
		/** 비디오 셋팅 **/
		override protected function videoSetting():void
		{
			super.videoSetting();
			$videoY = _video.y;
			_container.titleContainer.addChild( _video );
			TweenMax.killDelayedCallsTo(playVideo);
			TweenMax.delayedCall(1.75, playVideo);
		}
		
		protected function delayPlayVideo(event:Event):void
		{
			TweenMax.killDelayedCallsTo(playVideo);
			TweenMax.delayedCall(0.75,playVideo);
		}
		
		override protected function playVideo(e:Event=null):void
		{ super.playVideo(); }
		
		override protected function settingEtc(event:Event=null):void
		{ resizeHandler(); }
	}
}