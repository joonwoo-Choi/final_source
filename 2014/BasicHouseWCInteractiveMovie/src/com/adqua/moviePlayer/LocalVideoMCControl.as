package com.adqua.moviePlayer
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	public class LocalVideoMCControl
	{
		public function LocalVideoMCControl(moviePlayer:MoviePlayer)
		{
			_model = ModelPlayer.getInstance();
			_player = moviePlayer;
			_me = _player.video_mc.locVid;
			defaultSetting();
		}
		
		private function defaultSetting():void
		{
			// Setting all Player objects and movie clip
			
			_player.video_mc.desTxt.x= _player.video_mc.desTxt.y=0;
			_player.video_mc.btnMsk.cacheAsBitmap= _player.video_mc.btns.cacheAsBitmap=true;
			_player.video_mc.btnMsk.buttonMode= _player.video_mc.vid.s_.buttonMode= _player.video_mc.vid.sh.buttonMode= _player.video_mc.vid.sh1.buttonMode= _player.video_mc.vid.sh2.buttonMode= _player.video_mc.vid.sh3.buttonMode=false;
			_player.video_mc.btnMsk.mouseEnabled= _player.video_mc.vid.s_.mouseEnabled= _player.video_mc.vid.sh.mouseEnabled= _player.video_mc.vid.sh1.mouseEnabled= _player.video_mc.vid.sh2.mouseEnabled= _player.video_mc.vid.sh3.mouseEnabled=false;
			_player.video_mc.btnMsk.mouseChildren= _player.video_mc.vid.s_.mouseChildren= _player.video_mc.vid.sh.mouseChildren= _player.video_mc.vid.sh1.mouseChildren= _player.video_mc.vid.sh2.mouseChildren= _player.video_mc.vid.sh3.mouseChildren=false;
			_player.video_mc.vid.btn.ply.buttonMode= _player.video_mc.vid.btn.ply.mouseEnabled=true;
			_player.video_mc.vid.btn.ply.mouseChildren=false;
			
			_player.video_mc.btns.volMc.buttonMode=false;
			_player.video_mc.btns.volMc.mouseChildren=false;
			_player.video_mc.btns.volMc.mouseEnabled=false;		
			
			_model.volval=_model.volPrePos;
			_player.video_mc.btns.volMc.volMc.width=_player.video_mc.btns.volMc.bg.width=40;
			_player.video_mc.btns.volMc.volMc.height=_player.video_mc.btns.volMc.bg.height=4;
			_player.video_mc.btns.volMc.volMc.volMc.scaleX=_model.volPrePos;
			
			_player.video_mc.btns.vidSekMc.buttonMode=false;
			_player.video_mc.btns.vidSekMc.mouseChildren=false;
			_player.video_mc.btns.vidSekMc.mouseEnabled=false;
			_player.video_mc.btns.vidSekMc.vidPos.txt.autoSize = TextFieldAutoSize.LEFT;
			_player.video_mc.btns.vidSekMc.vidSek.lod.scaleX=_player.video_mc.btns.vidSekMc.vidSek.sek.scaleX=0;				
			// TODO Auto Generated method stub
			
			NC = new NetConnection();
			NC.addEventListener(NetStatusEvent.NET_STATUS, NSstatus);
			NC.connect(null);
			NS = new NetStream(NC);
			NS.addEventListener(NetStatusEvent.NET_STATUS, NSstatus);
			NS.client = this;
			vidDis= new Video();
			vidDis.attachNetStream(NS);
			vidDis.width=vidDis.height=0;
		}
		
		// Initial all required variable for local video
		
		private const smooth:Boolean= true;
		
		private var NC:NetConnection;
		public var NS:NetStream;
		private var objInfo:Object;
		private var setTim:Timer;
		private var vidSta:*;
		private var bolProgressScrub:Boolean= false;
		
		
		// Below function is used to init to load the local video
		public var vidDis:Video;
		private var _player:MoviePlayer;
		private var _me:MovieClip;
		private var _model:ModelPlayer;
		
		public function intVideo() {
			
			vidDis.smoothing = _model.videoSmoothness;
			NS.bufferTime = _model.bufTim;
			_me.addChild(vidDis);
			NS.play(_model.vidSource);
			
			if (_model.reflect) {
				_player.removeEventListener(Event.ENTER_FRAME, _player.RefEnterFrame);
				_player.addEventListener(Event.ENTER_FRAME, _player.RefEnterFrame);
			}
		}
		
		
		// Net stream event status function
		
		private function NSstatus(event:NetStatusEvent):void {
			vidSta = event.info.code;
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound" :
					break;
				case "NetStream.Play.Start" :
					//trace("Stream found: " + MovieClip(parent).vidSource);
					_me.visible = true;
					vidDis.visible=true;
					_model.vLoaded = true;
					_model.vidEnd = false;
					_player.volTraFn(_model.volPrePos);
					_player.volTraFn(_model.volval);
					break;
				case "NetConnection.Connect.Success" :
					break;
				case "NetStream.Play.Stop" :
					_player.playNext();
					break;
			}
		}
		
		// Initiate the player timing and resize the video when the required value is received from onMetaData function
		
		public function onMetaData(info:Object):void {
			
			_model.startV=true;
			
			objInfo = info;
			_model.vidTotDur=objInfo.duration;
			
			_player.video_mc.btns.vidSekMc.staTxt.text=_player.ctrlerBtn.fTime(0);
			_player.video_mc.btns.vidSekMc.endTxt.text=_player.ctrlerBtn.fTime(objInfo.duration);
			_player.video_mc.btns.vidSekMc.staTxt.alpha=_player.video_mc.btns.vidSekMc.endTxt.alpha=1;
			
			_player.ctrlerBtn.enableButtons();
			
			if (!_player.TmrAutoHide.running) {
				_player.TmrAutoHide.start();
			}
			_model.rezStg=true;
			_player.vidDisWid=vidDis.width=objInfo.width;
			_player.vidDisHig=vidDis.height=objInfo.height;
			_model.userRezMod="fittoarea";
			_player.resiz(this.vidDis, _player.StageWidth,_player.StageHeight, _model.userRezMod);
			
			_player.ctrlerBtn.thumbFadeOut();
			_player.video_mc.thumbImg.btn.gotoAndStop(1);
			
		}	
		public function onXMPData(info:Object):void{
			trace("onXmpData");
		}
	}
}