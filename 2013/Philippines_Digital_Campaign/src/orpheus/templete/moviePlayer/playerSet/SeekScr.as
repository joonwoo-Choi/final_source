package orpheus.templete.moviePlayer.playerSet
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	public class SeekScr extends AbsrtractMCCtrler
	{
		public function SeekScr(mc:MoviePlayer)
		{
			super(mc);
		}
		// Seek bar Mouse down function
		
		public function sekScr(event:MouseEvent) {
			if (_model.vLoaded) {
				if (_con.video_mc.thumbImg.alpha>0) {
					_con.ctrlerBtn.thumbFadeOut();
					_con.ctrlerBtn.titleTxtFadIn(false);
				}
				_model.spd=200;
				if (_model.locVideo) {
					_con.localVideoMCControl.NS.pause();
				} else {
					_con.video_mc.yTub.player.pauseVideo();
				}
				_con.video_mc.btns.vidSekMc.addEventListener( Event.ENTER_FRAME, _con.sekEntFrm );
				_con.stage.addEventListener(MouseEvent.MOUSE_UP, _con.sekScrStp);
				
				_con.video_mc.btns.vidSekMc.vidPos.alp = _con.video_mc.btns.vidSekMc.vidPos.alpha*100;
				_con.video_mc.btns.vidSekMc.vidPos.trg =100;
				_con.video_mc.btns.vidSekMc.vidPos.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
				_con.video_mc.btns.vidSekMc.vidPos.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
				
				_model.sekDrg=true;
				event.target.ico.alpha=1;
				
				_con.video_mc.vid.btn[(String(event.target.name))].alp = _con.video_mc.vid.btn[(String(event.target.name))].alpha*100;
				_con.video_mc.vid.btn[(String(event.target.name))].trg = _model.btnOvrTra*100;
				_con.video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
				_con.video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
			}
		}			
	}
}