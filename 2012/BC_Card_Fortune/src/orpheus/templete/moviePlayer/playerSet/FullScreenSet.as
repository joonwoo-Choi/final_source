package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	public class FullScreenSet extends AbsrtractMCCtrler
	{
		public function FullScreenSet(mc:MoviePlayer)
		{
			super(mc);
		}
		// fullScreenRedraw function is an event function for stage resize 
		
		public function fullScreenRedraw(event:FullScreenEvent):void {
			if (event.fullScreen) {
				_model.fulScreen = true;
				_model.autoHide=true;
				_con.video_mc.btns.ful.ico.gotoAndStop(2);
				_con.video_mc.refMc.visible=false;
				_con.StageWidth= _con.video_mc.stgBg.width= _con.video_mc.locVid.bg.width= _con.video_mc.yTub.bg.width=_con.stage.stageWidth;
				_con.StageHeight= _con.video_mc.stgBg.height= _con.video_mc.locVid.bg.height= _con.video_mc.yTub.bg.height=_con.stage.stageHeight;
			} else {
				_model.fulScreen = false;
				if (_model.reflect && _model.startV) {
					_con.video_mc.refMc.visible=true;
				}
				_model.autoHide=_model.autoHideF;
				if (!_model.autoHideF) {
					_con.video_mc.vid.alp =  _con.video_mc.vid.alpha*100;
					_con.video_mc.vid.trg = 100;
					_con.video_mc.vid.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
					_con.video_mc.vid.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
					
					_con.video_mc.btns.alp =  _con.video_mc.btns.alpha*100;
					_con.video_mc.btns.trg = 100;
					_con.video_mc.btns.removeEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
					_con.video_mc.btns.addEventListener( Event.ENTER_FRAME, _con.ctrlerBtn.fade );
				}
				_con.video_mc.btns.ful.ico.gotoAndStop(1);
				
				_con.StageWidth=_model.rStgW<100?_con.stage.stageWidth:_model.rStgW;
				_con.StageHeight=_model.rStgH<100?(_model.autoHide?_con.stage.stageHeight:(_con.stage.stageHeight-_model.vidHig-(_model.vidBr*2)-(_model.vidVMrg*2))):_model.rStgH;
				_con.StageHeight=_model.reflect&& _model.rStgH<100?(_con.StageHeight-_model.refDep-_model.refDis):_con.StageHeight;
			}
			_con.reLoadVidSkin();
		}		
	}
}