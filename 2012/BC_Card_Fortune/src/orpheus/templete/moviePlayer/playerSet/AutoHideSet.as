package orpheus.templete.moviePlayer.playerSet
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	public class AutoHideSet extends AbsrtractMCCtrler
	{
		public function AutoHideSet(mc:MoviePlayer)
		{
			super(mc);
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		private var byteLod:Number=0;
		private var byteTot:Number=0;
		// Seek bar coding
		
		public function autoHideFn(e:TimerEvent):void {
			if (_model.vLoaded) {
				if (_model.locVideo) {
					byteLod=_con.localVideoMCControl.NS.bytesLoaded;
					byteTot=_con.localVideoMCControl.NS.bytesTotal;
					_model.vidCurDur = _con.localVideoMCControl.NS.time;
				} else {
					byteLod=_con.video_mc.yTub.player.getVideoBytesLoaded();
					byteTot=_con.video_mc.yTub.player.getVideoBytesTotal();
					_model.vidCurDur=_con.video_mc.yTub.player.getCurrentTime();
					
				}
				if ((byteLod!=byteTot || _con.video_mc.btns.vidSekMc.vidSek.lod.scaleX!=1)) {
					_con.video_mc.btns.vidSekMc.vidSek.lod.scaleX = (byteLod/byteTot);
				}
				if (_model.vidCurDur>_model.vidTotDur) {
					_con.video_mc.btns.vidSekMc.staTxt.text=_con.ctrlerBtn.fTime(_model.vidTotDur);
				} else {
					_con.video_mc.btns.vidSekMc.staTxt.text=_con.ctrlerBtn.fTime(_model.vidCurDur);
				}
				_con.video_mc.btns.vidSekMc.vidSek.sek.scaleX=_con.sekPosVal=_model.startV?(_model.vidCurDur/_model.vidTotDur)>1?1:(_model.vidCurDur/_model.vidTotDur):0;
			}
			if (_model.autoHide) {
				if (_con.video_mc.stgBg.hitTestPoint(_con.stage.mouseX, _con.stage.mouseY, true) && ((_con.xMouse !=_con.stage.mouseX || _con.yMouse !=_con.stage.mouseY) || _con.video_mc.btns.hitTestPoint(_con.stage.mouseX, _con.stage.mouseY, true))) {
					_con.xMouse =_con.stage.mouseX;
					_con.yMouse =_con.stage.mouseY;
					_model.hideDelayTim=0;
					if (_con.video_mc.vid.alpha!=1) {
						_con.video_mc.vid.alp = _con.video_mc.vid.alpha*100;
						_con.video_mc.vid.trg = 100;
						_con.video_mc.vid.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						_con.video_mc.vid.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						TweenLite.to(_con.video_mc.thumbImg.btn,.5,{autoAlpha:1});		
						
						_con.video_mc.btns.alp = _con.video_mc.btns.alpha*100;
						_con.video_mc.btns.trg = 100;
						_con.video_mc.btns.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						_con.video_mc.btns.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
					}
				}
				if (_model.hideDelayTim==4) {
					if (_con.video_mc.vid.alpha!=0) {
						_con.video_mc.vid.alp = _con.video_mc.vid.alpha*100;
						_con.video_mc.vid.trg = 0;
						_con.video_mc.vid.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						_con.video_mc.vid.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						TweenLite.to(_con.video_mc.thumbImg.btn,.5,{autoAlpha:0});		
						
						_con.video_mc.btns.alp = _con.video_mc.btns.alpha*100;
						_con.video_mc.btns.trg = 0;
						_con.video_mc.btns.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
						_con.video_mc.btns.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
					}
				}
				_model.hideDelayTim=_model.hideDelayTim<3?_model.hideDelayTim+1:4;
			}
		}		
	}
}