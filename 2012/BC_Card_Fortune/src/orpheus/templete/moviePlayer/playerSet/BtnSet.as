package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	public class BtnSet extends AbsrtractMCCtrler
	{
		public function BtnSet(mc:MoviePlayer)
		{
			super(mc);
		}
		private var shadowDistance:Number=0;
		private var firLodVid:Boolean=true;

		public function setVidBtn() { 
			_con.video_mc.vid.btn.ply.x=_con.video_mc.vid.btn.sha.x=_con.video_mc.vid.btn.sek.x=_con.video_mc.vid.btn.vol.x=_con.video_mc.vid.btn.rez.x=_con.video_mc.vid.btn.ful.x=_con.video_mc.vid.btn.hdv.x=_con.video_mc.vid.btn.bri.x=_con.video_mc.vid.btn.txt.x=-245;
			_con.video_mc.btns.ply.x=_con.video_mc.btns.sha.x=_con.video_mc.btns.sek.x=_con.video_mc.btns.vol.x=_con.video_mc.btns.rez.x=_con.video_mc.btns.ful.x=_con.video_mc.btns.hdv.x=_con.video_mc.btns.bri.x=_con.video_mc.btns.txt.x=-245;
			_con.video_mc.vid.btn.s1.x=_con.video_mc.vid.btn.s2.x=_con.video_mc.vid.btn.s3.x=_con.video_mc.vid.btn.s4.x=_con.video_mc.vid.btn.s5.x=_con.video_mc.vid.btn.s6.x=_con.video_mc.vid.btn.s7.x=_con.video_mc.vid.btn.s8.x=-245;
			
			_model.vidWid = _model.vidWidF;
			_con.video_mc.logo.x=_model.logoXmargin>=0?_model.logoXmargin:_con.StageWidth-_con.video_mc.logo.width+_model.logoXmargin;
			_con.video_mc.logo.y=_model.logoYmargin>=0?_model.logoYmargin:_con.StageHeight-_con.video_mc.logo.height+_model.logoYmargin;
			
			if (_model.fulScreen) {
				_model.vidFixSiz =(_model.vidWid+(_model.vidBr*2)+(_model.vidMrg*2)) >= _con.StageWidth && _model.vidWid>0?false:_model.vidFixSizF;
			} else {
				_model.vidFixSiz =(_model.vidWid+(_model.vidBr*2)+(_model.vidMrg*2)) <= _con.StageWidth && _model.vidWid>0?true:false;
			}
			
			for (f=0; f<_con.objsAll.length; f++) {
				if (_con.objsAll[f]!="sek" && _con.objsAll[f]!="vol") {
					
					if (_model.icoSiz>.5) {
						_con.video_mc.btns[_con.objsAll[f]].setIco(true);
						_con.video_mc.btns[_con.objsAll[f]].ico.scaleX=_con.video_mc.btns[_con.objsAll[f]].ico.scaleY=_model.icoSiz;
					} else {
						_con.video_mc.btns[_con.objsAll[f]].setIco(false);
						_con.video_mc.btns[_con.objsAll[f]].ico.scaleX=_con.video_mc.btns[_con.objsAll[f]].ico.scaleY=_model.icoSiz*2;
					}
				}
			}
			
			
			_con.video_mc.btnMsk.x=_con.video_mc.btns.x=_con.video_mc.vid.x=_model.vidMrg;
			var pos:Number=0;
			var noBtn:Number=_model.objs.length-1;
			var tem:Boolean=false;
			
			for (var f:Number=0; f<_model.objs.length; f++) {
				if (_model.objs[f]=="vol") {
					tem=true;
				}
				if (_model.objs[f]=="sek") {
					_con.sekBtnYes=true;
				}
			}
			noBtn=tem?noBtn-1:noBtn;
			_model.volWid=tem?_model.volWid:0;
			
			
			if (_model.vidFixSiz) {
				_con.sekWid = Math.round((_model.vidWid-(((_model.btnWid+_con.sprWid)*noBtn)+_con.sprWid+_model.volWid+(_model.vidBr+_model.vidMrg)*2)));
			} else {
				_con.sekWid = Math.round(_con.StageWidth-(((_model.btnWid+_con.sprWid)*noBtn)+_con.sprWid+_model.volWid+(_model.vidBr+_model.vidMrg)*2));
			}
			_con.sekWid=_con.sekWid<150?150:_con.sekWid;
			_con.sekWid=_con.sekBtnYes?_con.sekWid:50;
			
			for (f=0; f<_model.objs.length; f++) {
				
				_con.applyColor(_con.video_mc.vid.btn[_model.objs[f]], _model.btnOvrCol,0);
				_con.applyColor(_con.video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)], _model.btnSprCol,_model.btnSprTra);
				
				_con.video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)].width=_con.sprWid;
				pos=  f>0 ? pos+_con.video_mc.vid.btn[_model.objs[f-1]].width+_con.sprWid : pos;
				
				if (_model.objs[f]!="sek" && _model.objs[f]!="vol") {
					_con.video_mc.vid.btn[_model.objs[f]].width=_model.btnWid;
					_con.video_mc.vid.btn[_model.objs[f]].x=pos;
				}
				if (_model.objs[f]=="sek") {
					_con.video_mc.vid.btn[_model.objs[f]].x=pos;
					_con.video_mc.vid.btn[_model.objs[f]].width=_con.sekWid;
					_con.sekBtnYes = true;
				}
				if (_model.objs[f]=="vol") {
					_con.video_mc.vid.btn[_model.objs[f]].x=pos;
					_con.video_mc.vid.btn[_model.objs[f]].width=_model.volWid;
				}
				_con.video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)].x=(_con.video_mc.vid.btn[_model.objs[f]].x+_con.video_mc.vid.btn[_model.objs[f]].width);
			}
			
			_model.vidWid=_con.video_mc.vid.btn[_model.objs[_model.objs.length-1]].x+_con.video_mc.vid.btn[_model.objs[_model.objs.length-1]].width;
			_con.video_mc.vid.btn.height=_model.vidHig;
			
			// draw rounded rectangle for required player movieclip
			
			_con.drawRoundedRectangle(_con.video_mc.vid.bg,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			_con.drawRoundedRectangle(_con.video_mc.vid.sh1,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			_con.drawRoundedRectangle(_con.video_mc.vid.sh2,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			drawSkin2(_con.video_mc.vid.sh3,_model.vidWid, _model.vidHig,_model.vidOvrLayCol,_model.vidBr,_model.vidCorRad);
			_con.drawRoundedRectangle(_con.video_mc.vid.msk,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			_con.drawRoundedRectangle(_con.video_mc.btnMsk,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			
			drawRoundedBorder(_con.video_mc.vid.br,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,_model.vidBr,_model.vidCorRad);
			if (_model.vidBr>0) {
				drawRoundedBorder(_con.video_mc.vid.brShd,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,_model.vidBr,_model.vidCorRad);
			} else {
				drawRoundedBorder(_con.video_mc.vid.brShd,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,1,_model.vidCorRad);
			}
			
			_con.video_mc.btns.mask = _con.video_mc.btnMsk;
			
			_con.video_mc.vid.s_.width=(_model.vidWid-30)>0?(_model.vidWid-30):10;
			_con.video_mc.vid.s_.x=(_model.vidWid+(_model.vidBr*2)-_con.video_mc.vid.s_.width)/2;
			_con.video_mc.vid.s_.y=_model.vidHig+_model.vidBr-32;
			_con.video_mc.vid.sh.width=(_model.vidWid-50)>0?(_model.vidWid-50):10;
			_con.video_mc.vid.sh.x=(_model.vidWid+(_model.vidBr*2)-_con.video_mc.vid.sh.width)/2;
			_con.video_mc.vid.sh.y=_model.vidBr+7;
			_con.video_mc.vid.sh1.x=_con.video_mc.vid.sh2.x=_con.video_mc.vid.sh3.x=_con.video_mc.vid.bg.x=_model.vidBr;
			_con.video_mc.vid.sh1.y=_con.video_mc.vid.sh2.y=_con.video_mc.vid.sh3.y=_con.video_mc.vid.bg.y=_model.vidBr;
			
			_con.video_mc.vid.msk.x=_con.video_mc.vid.msk.y=_con.video_mc.vid.btn.x=_con.video_mc.vid.btn.y=_model.vidBr;
			
			// Choose player skin type
			
			if (_model.skinType == 0) {
				_con.applyColor(_con.video_mc.vid.s_, _model.vidOvrLayCol,(_model.vidOvrLayTra*.65));
				_con.applyColor(_con.video_mc.vid.sh, _model.vidOvrLayCol,(_model.vidOvrLayTra*.30));
				_con.applyColor(_con.video_mc.vid.sh1, _model.vidOvrLayCol,(_model.vidOvrLayTra*.4));
				_con.applyColor(_con.video_mc.vid.sh3, _model.vidCol,0);
				_con.video_mc.vid.sh2.alpha=_model.vidOvrLayTra;
			} else {
				_con.applyColor(_con.video_mc.vid.s_, _model.vidOvrLayCol,0);
				_con.applyColor(_con.video_mc.vid.sh, _model.vidOvrLayCol,0);
				_con.applyColor(_con.video_mc.vid.sh1, _model.vidOvrLayCol,0);
				_con.applyColor(_con.video_mc.vid.sh3, _model.vidOvrLayCol,_model.vidOvrLayTra);
				_con.video_mc.vid.sh2.alpha=0;
			}
			
			_con.video_mc.vid.bg.alpha=_model.vidBgTra;
			_con.video_mc.vid.br.alpha=_model.vidBrTra;
			
			// Seek button setting
			
			_con.video_mc.btns.sek.btn.width =_con.video_mc.btns.sek.ico.width= _con.sekBtnYes?_con.video_mc.vid.btn.sek.width:20;
			_con.video_mc.btns.sek.btn.height = _model.vidHig;
			_con.video_mc.btns.sek.x = _con.video_mc.vid.btn.sek.x;
			_con.video_mc.btns.sek.ico.height=_model.sekHig;
			_con.video_mc.btns.sek.ico.x=0;
			_con.video_mc.btns.sek.ico.y=18;
			
			_con.video_mc.btns.vidSekMc.vidSek.width=50;
			_con.video_mc.btns.vidSekMc.vidSek.width=_model.vidTimAlignB?_con.video_mc.btns.sek.btn.width-20:_con.video_mc.btns.sek.btn.width-80;
			_con.video_mc.btns.vidSekMc.vidSek.height=_con.video_mc.btns.sek.ico.height;
			_con.video_mc.btns.vidSekMc.vidPos.alpha=0;
			_con.video_mc.btns.vidSekMc.vidPos.bar.height=Math.round((_model.vidHig+_model.sekHig)/2);
			_con.video_mc.btns.vidSekMc.vidPos.y=-Math.round((_model.vidHig-_model.sekHig)/2-3);
			_con.video_mc.btns.vidSekMc.vidPos.txt.y=Math.round(_con.video_mc.btns.vidSekMc.vidPos.bar.height-_con.video_mc.btns.vidSekMc.vidPos.txt.height-_model.sekHig)/2;
			
			_con.video_mc.btns.vidSekMc.x=_model.vidTimAlignB?_con.video_mc.btns.sek.x+10:_con.video_mc.btns.sek.x+40;
			_con.video_mc.btns.vidSekMc.y=Math.round(_model.vidHig/2-_model.sekHig/2);
			_con.video_mc.btns.vidSekMc.vidPos.txt.autoSize = TextFieldAutoSize.LEFT;
			_con.video_mc.btns.vidSekMc.staTxt.autoSize = TextFieldAutoSize.LEFT;
			_con.video_mc.btns.vidSekMc.endTxt.autoSize = TextFieldAutoSize.LEFT;
			_con.video_mc.btns.vidSekMc.staTxt.x=_model.vidTimAlignB?-8:-35;
			_con.video_mc.btns.vidSekMc.endTxt.x=_model.vidTimAlignB?Math.round(_con.video_mc.btns.vidSekMc.vidSek.width-_con.video_mc.btns.vidSekMc.endTxt.width+8):Math.round(_con.video_mc.btns.vidSekMc.vidSek.width+4);
			_con.video_mc.btns.vidSekMc.staTxt.y=_con.video_mc.btns.vidSekMc.endTxt.y=_model.vidTimAlignB?Math.round(_model.vidHig/4+_model.sekHig/2-7):Math.round(-8+_model.sekHig/2);
			
			_con.applyColor(_con.video_mc.btns.vidSekMc.vidSek.sek, _model.vidSekBarCol,1);
			_con.applyColor(_con.video_mc.btns.vidSekMc.vidSek.lod, _model.icoCol,.2);
			_con.applyColor(_con.video_mc.btns.vidSekMc.vidSek.bg, _model.icoCol,.2);
			_con.applyColor(_con.video_mc.btns.vidSekMc.vidPos, _model.icoCol,0);
			_con.applyColor(_con.video_mc.btns.vidSekMc.staTxt, _model.icoCol,1);
			_con.applyColor(_con.video_mc.btns.vidSekMc.endTxt, _model.icoCol,1);
			_con.applyColor(_con.video_mc.btns.vidSekMc.vidPos, _model.icoCol,0);
			
			//Volume button setting
			
			_con.video_mc.btns.vol.btn.width = _con.video_mc.vid.btn.vol.width;
			_con.video_mc.btns.vol.btn.height = _model.vidHig;
			_con.video_mc.btns.vol.x = Math.round(_con.video_mc.vid.btn.vol.x);
			if (_model.icoSiz>.5) {
				_con.video_mc.btns.vol.setIco(true);
				_con.video_mc.btns.vol.ico.scaleX=_con.video_mc.btns.vol.ico.scaleY=_model.icoSiz;
			} else {
				_con.video_mc.btns.vol.setIco(false);
				_con.video_mc.btns.vol.ico.scaleX=_con.video_mc.btns.vol.ico.scaleY=_model.icoSiz*2;
			}
			_con.video_mc.btns.vol.ico.x=Math.round((_con.video_mc.btns.vol.btn.width-(_con.video_mc.btns.vol.ico.width))/2)-23;
			_con.video_mc.btns.volMc.x=Math.round(_con.video_mc.btns.vol.x+_con.video_mc.btns.vol.ico.x+_con.video_mc.btns.vol.ico.width+4);
			_con.video_mc.btns.volMc.height=_model.sekHig>4?4:_model.sekHig;
			_con.video_mc.btns.volMc.y=Math.round((_model.vidHig-_con.video_mc.btns.volMc.height)/2);
			_con.video_mc.btns.volMc.y=_model.sekHig>1?_con.video_mc.btns.volMc.y-1:_con.video_mc.btns.volMc.y;
			_con.video_mc.btns.vol.ico.y=Math.round((_model.vidHig-_con.video_mc.btns.vol.ico.height)/2);
			_con.applyColor(_con.video_mc.btns.volMc.volMc, _model.vidSekBarCol,1);
			_con.applyColor(_con.video_mc.btns.volMc.bg, _model.icoCol,.4);
			
			for (f=0; f<_model.objs.length; f++) {
				if (_model.objs[f]!="sek" && _model.objs[f]!="vol") {
					_con.video_mc.btns[_model.objs[f]].x=_con.video_mc.vid.btn[_model.objs[f]].x;
					_con.video_mc.btns[_model.objs[f]].btn.width=_model.btnWid;
					_con.video_mc.btns[_model.objs[f]].btn.height=_model.vidHig;
					_con.video_mc.btns[_model.objs[f]].ico.x=Math.round((_model.btnWid-(_con.video_mc.btns[_model.objs[f]].ico.width))/2);
					_con.video_mc.btns[_model.objs[f]].ico.y=Math.round((_model.vidHig-(_con.video_mc.btns[_model.objs[f]].ico.height))/2);
				}
				_con.applyColor(_con.video_mc.btns[_model.objs[f]].ico, _model.icoCol,.65);
			}
			
			_con.video_mc.vid.x=_model.vidFixSiz?Math.round((_con.StageWidth-_con.video_mc.vid.br.width)/2):Math.round((_con.sekBtnYes?_con.video_mc.btnMsk.x:(_con.StageWidth-_con.video_mc.vid.br.width)/2));
			_con.video_mc.vid.y=_model.autoHide?Math.round(_con.StageHeight-_model.vidHig-_model.vidVMrg-_model.vidBr+_model.refDis):Math.round(_con.StageHeight-_model.vidBr)+_model.vidVMrg;
			
			
			_con.video_mc.btnMsk.x=_con.video_mc.btns.x=_con.video_mc.vid.x+_model.vidBr;
			_con.video_mc.btnMsk.y=_con.video_mc.btns.y=_con.video_mc.vid.y+_model.vidBr;
			
			var filterArray:Array = new Array();
			var filter:DropShadowFilter = new DropShadowFilter(shadowDistance, 45, 0x000000, _model.shadowAlpha, 5, 5, 1, 3,false,true);
			filterArray.push(filter);
			_con.video_mc.vid.brShd.filters = filterArray;
			
			_con.video_mc.vid.alpha=_con.video_mc.btns.alpha=_model.autoHideF?0:1;
			
			_con.video_mc.stgBg.width=_con.video_mc.locVid.bg.width=_con.video_mc.yTub.bg.width=_con.StageWidth;
			_con.video_mc.stgBg.height=_con.video_mc.locVid.bg.height=_con.video_mc.yTub.bg.height=_con.StageHeight;
			
			// set intial HD icon
			if (firLodVid) {
				if (_model.vidQulLoc == "hd720") {
					_con.video_mc.btns.hdv.ico.gotoAndStop(2);
					if (_model.locVideo && !_model.validate(_model.pathArrHd[_model.curPathNum],"s")) {
						_con.video_mc.btns.hdv.ico.gotoAndStop(1);
					}
				} else {
					_con.video_mc.btns.hdv.ico.gotoAndStop(1);
				}
			}
			firLodVid = false;
		}		
		// draw skin type two
		
		private function drawSkin2(mc,w,h,borderColor,borderSize,cornerRadius) {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(100, 100, 0, 0, 0);
			matr.rotate((Math.PI/180)*90);
			mc.shape = new Sprite();
			mc.shape.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 100], [0x00, 0xFF], matr, SpreadMethod.PAD);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}		
		// function to draw a rounded border  
		
		private function drawRoundedBorder(mc,w,h,borderColor,borderSize,cornerRadius) {
			mc.shape = new Sprite();
			mc.shape.graphics.beginFill(borderColor);
			mc.shape.graphics.drawRoundRect(borderSize, borderSize,w-borderSize*2, h-borderSize*2, cornerRadius);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}		
	}
}