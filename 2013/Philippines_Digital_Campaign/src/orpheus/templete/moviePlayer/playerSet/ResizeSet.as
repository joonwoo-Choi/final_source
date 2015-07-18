package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.events.Event;
	
	public class ResizeSet extends AbsrtractMCCtrler
	{
		public function ResizeSet(mc:MoviePlayer)
		{
			super(mc);
		}
		// Resize the video function
		// Resize the object using below function
		
		private var W:Number;
		private var H:Number;
		private var rw:Number;
		private var rh:Number;
		private var curNum:Number=0;
		private var objW:Number;
		private var objH:Number;
		
		public function resiz(obj, wid, hig, ResizeType) {
			
			_con.stage.removeEventListener( Event.ENTER_FRAME, _con.rezEntFrm );
			var vW:Number=0;
			var vH:Number=0;
			var vX:Number=0;
			var vY:Number=0;
			
			_model.userRezMod=ResizeType!="undefined"?ResizeType:_model.userRezMod;
			W = _con.vidDisWid;
			H = _con.vidDisHig;
			rw = W/wid;
			rh = H/hig;
			
			if (_model.userRezMod == "none") {
				if (_con.StageWidth>=_con.vidDisWid && _con.StageHeight>=_con.vidDisHig) {
					vW=_con.vidDisWid;
					vH=_con.vidDisHig;
					vX=(_con.StageWidth-_con.vidDisWid)/2;
					vY=(_con.StageHeight-_con.vidDisHig)/2;
					_con.video_mc.btns.rez.ico.gotoAndStop(1);
				} else {
					_model.userRezMod = "fittoarea";
				}
			}
			if (_model.userRezMod == "fittoarea") {
				if (rw<rh) {
					objW = W/rh;
					objH = H/rh;
				} else {
					objW = W/rw;
					objH = H/rw;
				}
				_con.video_mc.btns.rez.ico.gotoAndStop(4);
				vW=objW;
				vH=objH;
				vX=(_con.StageWidth-objW)/2;
				vY=(_con.StageHeight-objH)/2;
			}
			if (Math.round(wid) != Math.round(W) || Math.round(hig) != Math.round(H) || _model.rezStg ) {
				if (!_model.rezStg) {
					rSpd=40;
					rObj=obj;
					rObjW=vW;
					rObjH=vH;
					rObjX=vX;
					rObjY=vY;
					YrObjW=_model.locVideo?_con.localVideoMCControl.vidDis.width:_con.video_mc.yTub.player.width;
					YrObjH=_model.locVideo?_con.localVideoMCControl.vidDis.height:_con.video_mc.yTub.player.height;
					_con.stage.addEventListener( Event.ENTER_FRAME, rezEntFrm );
				} else {
					if (_model.locVideo) {
						obj.width= vW;
						obj.height= vH;
					} else {
						_con.video_mc.yTub.player.setSize(vW,vH);
					}
					obj.x= vX;
					obj.y= vY;
				}
			} else {
				obj.x= vX;
				obj.y= vY;
				_con.video_mc.btns.rez.ico.gotoAndStop(4);
			}
			_model.rezStg = false;
		}
		// Video resize Animation
		
		private var rObj:*;
		private var rObjW :Number=0;
		private var rObjH :Number=0;
		private var YrObjW :Number=0;
		private var YrObjH :Number=0;
		
		private var rObjX :Number=0;
		private var rObjY :Number=0;
		private var rSpd:Number=0;
		
		public function rezEntFrm(ev) {
			rSpd+=(2-rSpd)/3;
			if (rObj.width<rObjW+5 && rObj.width>rObjW-5 && rObj.height<rObjH+5 && rObj.height>rObjH-5 && rObj.x<rObjX+5 && rObj.x>rObjX-5 && rObj.y<rObjY+5 && rObj.y>rObjY-5) {
				if (_model.locVideo) {
					rObj.width=rObjW;
					rObj.height=rObjH;
				} else {
					_con.video_mc.yTub.player.setSize(rObjW,rObjH);
				}
				rObj.x=rObjX;
				rObj.y=rObjY;
				if (_model.reflect && !_model.fulScreen && _model.locVideo) {
					_con.takeSnapeShot();
				}
				_con.stage.removeEventListener( Event.ENTER_FRAME, rezEntFrm );
			} else {
				YrObjW+=Math.round((rObjW-Math.round(YrObjW))/rSpd);
				YrObjH+=Math.round((rObjH-Math.round(YrObjH))/rSpd);
				if (_model.locVideo) {
					rObj.width=YrObjW;
					rObj.height=YrObjH;
				} else {
					_con.video_mc.yTub.player.setSize(YrObjW,YrObjH);
				}
				rObj.x+=Math.round((rObjX-Math.round(rObj.x))/rSpd);
				rObj.y+=Math.round((rObjY-Math.round(rObj.y))/rSpd);
			}
			if (_model.reflect && !_model.fulScreen && _model.locVideo) {
				_con.takeSnapeShot();
			}
		}
	}
}