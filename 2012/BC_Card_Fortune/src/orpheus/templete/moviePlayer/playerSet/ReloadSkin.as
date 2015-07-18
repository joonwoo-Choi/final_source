package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.Sprite;
	
	public class ReloadSkin extends AbsrtractMCCtrler
	{
		public function ReloadSkin(mc:MoviePlayer)
		{
			super(mc);
		}
		public function reLoadVidSkin() {		
			_con.sekBtnYes=false;
			_model.rezStg=true;
			_model.btnSprTra=_model.validate(_model.btnSprCol,"s")?.25:0;
			_con.video_mc.stgBg.width= _con.video_mc.locVid.bg.width= _con.video_mc.yTub.bg.width= _con.video_mc.thumbImg.bg.width=_con.StageWidth;
			_con.video_mc.stgBg.height= _con.video_mc.locVid.bg.height= _con.video_mc.yTub.bg.height= _con.video_mc.thumbImg.bg.height=_con.StageHeight;
			
			//---------- player front image resize  
			_con.video_mc.thumbImg.scaleX= _con.video_mc.thumbImg.scaleY= _con.video_mc.thumbImg.img.scaleX= _con.video_mc.thumbImg.img.scaleY=1;
			_con.video_mc.thumbImg.btn.x=Math.round( _con.video_mc.thumbImg.bg.width/2);
			_con.video_mc.thumbImg.btn.y=Math.round( _con.video_mc.thumbImg.bg.height/2);
			if ( _con.video_mc.thumbImg.refMc.numChildren>0) {
				for (var k= _con.video_mc.thumbImg.refMc.numChildren-1; k>-1; k--) {
					_con.video_mc.thumbImg.refMc.removeChild( _con.video_mc.thumbImg.refMc.getChildAt(k));
				}
			}
			_con.fitToArea( _con.video_mc.thumbImg.img,_con.StageWidth,_con.StageHeight);
			if (_model.reflect && _model.refVidOnly) {
				_con.reflection( _con.video_mc.thumbImg,_model.refDis,_model.refDep,_model.refAlp);
				_con.video_mc.thumbImg.refMc.addChild(_con.bmp2);
			}
			// start to create Description text 
			
			if (_model.desText!="") {
				_con.txtformat( _con.video_mc.desTxt, _model.desText,_con.StageWidth);
			} else {
				for (k=0; k<_model.objs.length; k++) {
					if (_model.objs[k] == "txt") {
						_model.objs.splice(k, 1);
					}
				}
			}
			_con.video_mc.desTxt.trgY= _con.video_mc.desTxt.y= _con.video_mc.desTxt.y<0?-Math.round( _con.video_mc.desTxt.height+5):0;
			
			// Remove the previous child if the player is redraw
			
			if ( _con.video_mc.btnMsk.numChildren>0 ) {
				_con.video_mc.btnMsk.removeChild( _con.video_mc.btnMsk.getChildAt(0));
				_con.video_mc.vid.bg.removeChild( _con.video_mc.vid.bg.getChildAt(0));
				_con.video_mc.vid.sh1.removeChild( _con.video_mc.vid.sh1.getChildAt(0));
				_con.video_mc.vid.sh2.removeChild( _con.video_mc.vid.sh2.getChildAt(0));
				_con.video_mc.vid.sh3.removeChild( _con.video_mc.vid.sh3.getChildAt(0));
				_con.video_mc.vid.msk.removeChild( _con.video_mc.vid.msk.getChildAt(0));
				_con.video_mc.vid.br.removeChild( _con.video_mc.vid.br.getChildAt(0));
				_con.video_mc.vid.brShd.removeChild( _con.video_mc.vid.brShd.getChildAt(0));
				_con.setVidBtn();
			}
			if (_model.vLoaded ||  _con.video_mc.yTub.vFirLod) {
				if (_model.locVideo) {
					_con.resiz( _con.localVideoMCControl.vidDis, _con.StageWidth, _con.StageHeight, "undefined");
				} else {
					_con.resiz( _con.video_mc.yTub.player, _con.StageWidth, _con.StageHeight, "undefined");
				}
			}
			if (_model.reflect && _model.startV) {
				_con.takeSnapeShot();
			}	
		}
	}
}