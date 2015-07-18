package orpheus.templete.moviePlayer.ctrler
{
	import flash.events.Event;
	
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	public class CtrlerSeekBar extends AbsrtractMCCtrler
	{
		public function CtrlerSeekBar(mc:MoviePlayer)
		{
			super(mc);
		}
		
		private var sDr:Number=-1;
		public function sekEntFrm(ev) {
			if (_model.sekDrg) {
				_con.TmrAutoHide.stop();
				if (_model.vidEnd) {
					_model.vidEnd=false;
					_con.video_mc.btns.ply.ico.gotoAndStop(1);
					_con.video_mc.thumbImg.btn.gotoAndStop(1);
				}
				_con.sekPosVal=(Math.round(_con.video_mc.btns.vidSekMc.vidSek.mouseX<0||_con.video_mc.btns.vidSekMc.vidSek.mouseX>100?(_con.video_mc.btns.vidSekMc.vidSek.mouseX<0?0:100):_con.video_mc.btns.vidSekMc.vidSek.mouseX))/100;
				if (sDr != _con.sekPosVal && _model.vLoaded) {
					sDr = _con.sekPosVal;
					if (_model.locVideo) {
						_con.localVideoMCControl.NS.seek(Math.floor(_con.sekPosVal*_model.vidTotDur));
					} else {
						_con.video_mc.yTub.player.seekTo(Math.floor(_con.sekPosVal*_model.vidTotDur));
					}
				}
				_con.ctrlerBtn.sekScrPos();
			} else {
				sDr =-1;
				_con.TmrAutoHide.start();
				
				if (_con.video_mc.btns.vidSekMc.vidSek.sek.scaleX>_con.sekPosVal-.05 && _con.video_mc.btns.vidSekMc.vidSek.sek.scaleX<_con.sekPosVal+.05) {
					_con.video_mc.btns.vidSekMc.removeEventListener( Event.ENTER_FRAME, sekEntFrm );
					_con.video_mc.btns.vidSekMc.vidSek.sek.scaleX=_con.sekPosVal;
				}
			}
			_model.spd +=(2-_model.spd)/2;
			_con.video_mc.btns.vidSekMc.vidSek.sek.scaleX+=(_con.sekPosVal-_con.video_mc.btns.vidSekMc.vidSek.sek.scaleX)/_model.spd;
			
		}
		
	}
}