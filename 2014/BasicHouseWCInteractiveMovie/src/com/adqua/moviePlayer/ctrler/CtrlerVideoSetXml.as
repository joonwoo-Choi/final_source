package com.adqua.moviePlayer.ctrler
{
	public class CtrlerVideoSetXml extends Ctrler
	{
		public var datalist:Object;
		public var video_mc:VideoMc;
		public function CtrlerVideoSetXml()
		{
		}
		public function setting():void{
			_model.rStgW=_model.validate(datalist.videoWidth,"n")?Number(datalist.videoWidth):_model.rStgW;
			_model.rStgH=_model.validate(datalist.videoHeight,"n")?Number(datalist.videoHeight):_model.rStgH;
			
			if (_model.validate(datalist.playerNavigations,"s")) {
				_model.objs=[];
				_model.objs=String(datalist.playerNavigations).split(",");
			}
			
			_model.thumbImgPath= _model.validate(datalist.imagePath,"s")? String(datalist.imagePath) : _model.thumbImgPath;
			_model.pArr=  _model.validate(datalist.videoPath,"s")? String(datalist.videoPath): _model.pArr;
			_model.pathArr=[];
			_model.pathArr=_model.pArr.split(",");
			
			_model.pArrHd=  _model.validate(datalist.videoPathHd,"s")? String(datalist.videoPathHd): _model.pArrHd;
			_model.pathArrHd=[];
			_model.pathArrHd=_model.pArrHd.split(",");
			
			video_mc.yTub.vidQul= _model.vidQulLoc =  _model.validate(datalist.videoDefaultQuality,"s")? String(datalist.videoDefaultQuality) : video_mc.yTub.vidQul;
			
			_model.vidSource=(_model.vidQulLoc=="hd720")?_model.pathArrHd[0]:_model.pathArr[0];
			
			_model.locVideo=(_model.vidSource.substring(_model.vidSource.length-3,_model.vidSource.length-4)!=".")?false:true;
			
			_model.autoPlayVideo= _model.validate(datalist.videoAutoStart,"s")? (String(datalist.videoAutoStart)== "yes"? true : false) : _model.autoPlayVideo;
			_model.autoHideF= _model.validate(datalist.playerAutoHide,"s")? (String(datalist.playerAutoHide)== "no"? false : true) : _model.autoHideF;
			_model.autoHide= _model.autoHideF;
			_model.bufTim = _model.validate(datalist.videoBufferTime,"n")? Number(datalist.videoBufferTime) : _model.bufTim;
			
			_model.vidWidF= _model.validate(datalist.playerWidth,"n")? Number(datalist.playerWidth) : _model.vidWidF;
			_model.vidWid= _model.vidWidF;
			
			_model.vidHig= _model.validate(datalist.playerHeight,"n")? Number(datalist.playerHeight) : _model.vidHig;
			_model.vidFixSiz= _model.validate(datalist.playerFixedSizeOnFullScreenMode,"s")? (String(datalist.playerFixedSizeOnFullScreenMode)== "yes"? true : false) : _model.vidFixSiz;
			_model.vidFixSizF=_model.vidFixSiz;
			_model.videoSmoothness= _model.validate(datalist.videoSmoothness,"s")? (String(datalist.videoSmoothness)== "yes"? true : false) : true;
			
			_model.vidBr= _model.validate(datalist.playerBorderSize,"n")? Number(datalist.playerBorderSize) : _model.vidBr;
			_model.vidMrg= _model.validate(datalist.playerHorizontalMargin,"n")? Number(datalist.playerHorizontalMargin) : _model.vidMrg;
			_model.vidVMrg= _model.validate(datalist.playerVerticalMargin,"n")? Number(datalist.playerVerticalMargin) : _model.vidVMrg;
			_model.vidCorRad= _model.validate(datalist.playerCornerRadius,"n")? Number(datalist.playerCornerRadius) : _model.vidCorRad;
			_model.vidCol=  _model.validate(datalist.playerBgColor,"s")? String("0x"+datalist.playerBgColor) : _model.vidCol;
			_model.vidBrCol=  _model.validate(datalist.playerBorderColor,"s")? String("0x"+datalist.playerBorderColor) : _model.vidBrCol;
			_model.vidBgTra= _model.validate(datalist.playerBgTransparency,"n")? Number(datalist.playerBgTransparency)/100 : _model.vidBgTra;
			_model.vidBrTra= _model.validate(datalist.playerBorderTransparency,"n")? Number(datalist.playerBorderTransparency)/100 : _model.vidBrTra;
			_model.vidTimAlignB= _model.validate(datalist.playerTimerAlignBottom,"s")? (String(datalist.playerTimerAlignBottom)== "yes"? true : false) : _model.vidTimAlignB;
			_model.skinType= _model.validate(datalist.playerSkinGlassType,"s")? (String(datalist.playerSkinGlassType)== "yes"? 0 : 1) : _model.skinType;
			_model.vidOvrLayCol=  _model.validate(datalist.playerOverlayColor,"s")? String("0x"+datalist.playerOverlayColor) : _model.vidOvrLayCol;
			_model.vidOvrLayTra= _model.validate(datalist.playerOverlayTransparency,"n")? Number(datalist.playerOverlayTransparency)/100 : _model.vidOvrLayTra;
			_model.shadowAlpha= _model.validate(datalist.playerShadowTransparency,"n")? Number(datalist.playerShadowTransparency)/100 : _model.shadowAlpha;
			_model.vidSekBarCol=  _model.validate(datalist.playerSeekBarColor,"s")? String("0x"+datalist.playerSeekBarColor) : _model.vidSekBarCol;
			_model.sekHig= _model.validate(datalist.playerSeekBarHeight,"n")? Number(datalist.playerSeekBarHeight) : _model.sekHig;
			
			_model.btnWid= _model.validate(datalist.playerButtonWidth,"n")? Number(datalist.playerButtonWidth) : _model.btnWid;
			_model.btnOvrCol= _model.validate(datalist.playerButtonRollOverColor,"s")? String("0x"+datalist.playerButtonRollOverColor) : _model.btnOvrCol;
			_model.btnSprCol= _model.validate(datalist.playerSeparatorColor,"s")? String("0x"+datalist.playerSeparatorColor) : _model.btnSprCol;
			_model.btnSprTra= _model.validate(_model.btnSprCol,"s")? .25 : 0;
			_model.icoCol= _model.validate(datalist.playerIconColor,"s")? String("0x"+datalist.playerIconColor) : _model.icoCol;
			_model.icoSiz= _model.validate(datalist.playerIconSize,"n")? Number(datalist.playerIconSize)/100 : _model.icoSiz;
			
			_model.textBgAlpha= _model.validate(datalist.textBgAlpha,"n")? Number(datalist.textBgAlpha)/100 : .75;
			_model.textBgColor= _model.validate(datalist.textBgColor,"s")? String("0x"+datalist.textBgColor) : _model.textBgColor;
			_model.embedFont =  _model.validate(datalist.textEmbedFont,"s")? (String(datalist.textEmbedFont)== "no"? false : true) : true;
			_model.titleVspace= _model.validate(datalist.titleVerticalSpace,"n")? Number(datalist.titleVerticalSpace) : 0;
			_model.bgColor= _model.validate(datalist.videoBgColor,"s")? String("0x"+datalist.videoBgColor) : _model.bgColor;
			_model.volPrePos= _model.validate(datalist.videoVolumeStart,"n")? Number(datalist.videoVolumeStart)/100 : .5;
			_model.volval = _model.volPrePos;
			video_mc.btns.volMc.volMc.volMc.scaleX=_model.volPrePos;
			
			_model.reflect = _model.validate(datalist.reflection,"s")?(String(datalist.reflection)=="yes"?true:false):_model.reflect;
			_model.refVidOnly = _model.validate(datalist.reflectVideoOnly,"s")?(String(datalist.reflectVideoOnly)=="no"?false:true):_model.refVidOnly;
			_model.refDis =_model.validate(datalist.refelectionDistance,"n")?Number(datalist.refelectionDistance):_model.refDis;
			_model.refDep =_model.validate(datalist.reflectionDepth,"n")?Number(datalist.reflectionDepth):_model.refDep;
			_model.refAlp =_model.validate(datalist.reflectionTransparency,"n")?Number(datalist.reflectionTransparency)/100:_model.refAlp;
						
		}
	}
}