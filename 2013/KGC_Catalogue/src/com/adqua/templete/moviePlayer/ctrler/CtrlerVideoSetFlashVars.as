package com.adqua.templete.moviePlayer.ctrler
{
	import com.adqua.templete.moviePlayer.ModelPlayer;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class CtrlerVideoSetFlashVars extends Ctrler
	{
		public function CtrlerVideoSetFlashVars()
		{
		}
		public function videoValueSetting():void{
			_model.dataPath= _model.validate(_model.parameter.xmlPath,"s") ? _model.parameter.xmlPath : "";
			_model.settingLI= _model.validate(_model.parameter.setting,"n") ? String(_model.parameter.setting) : "2";
			_model.xmlLoad= new URLLoader();
			_model.url= new URLRequest(_model.dataPath);
			
			_model.thumbImgPath=String(_model.parameter.imagePath)!="undefined"?String(_model.parameter.imagePath):"videos_asset/image.jpg";
			_model.pArr= _model.validate(_model.parameter.videoPath,"s")?String(_model.parameter.videoPath):_model.locVideo?"videos_asset/video.flv":"";
			_model.pathArr=_model.pArr.split(",");
			
			_model.pArrHd= _model.validate(_model.parameter.videoPathHd,"s")?String(_model.parameter.videoPathHd):"";
			_model.pathArrHd=_model.pArrHd.split(",");
			
			_model.logoPath=String(_model.parameter.logoPath)!="undefined"?String(_model.parameter.logoPath):"";
			_model.logoXmargin=_model.validate(_model.parameter.logoHorizontalMargin,"n")?Number(_model.parameter.logoHorizontalMargin):-5;
			_model.logoYmargin=_model.validate(_model.parameter.logoVerticalMargin,"n")?Number(_model.parameter.logoVerticalMargin):-5;
			
			_model.autoPlayVideo=_model.validate(_model.parameter.videoAutoStart,"s")?(String(_model.parameter.videoAutoStart)=="yes"?true:false):_model.autoPlayVideo;
			_model.autoHideF=_model.validate(_model.parameter.playerAutoHide,"s")?(String(_model.parameter.playerAutoHide)=="no"?false:true):true;
			_model.autoHide=_model.autoHideF;
			_model.bufTim= _model.validate(_model.parameter.videoBufferTime,"n")?Number(_model.parameter.videoBufferTime):1;
			
			_model.vidWidF=_model.validate(_model.parameter.playerWidth,"n")?Number(_model.parameter.playerWidth):_model.vidWidF;
			_model.vidWid=_model.vidWidF;
			_model.vidHig=_model.validate(_model.parameter.playerHeight,"n")?Number(_model.parameter.playerHeight):_model.vidHig;
			
			_model.vidFixSiz=_model.validate(_model.parameter.playerFixedSizeOnFullScreenMode,"s")?(String(_model.parameter.playerFixedSizeOnFullScreenMode)=="yes"?true:false):_model.vidFixSiz;
			_model.vidFixSizF=_model.vidFixSiz;
			_model.videoSmoothness=_model.validate(_model.parameter.videoSmoothness,"s")?(String(_model.parameter.videoSmoothness)=="yes"?true:false):true;
			
			_model.vidBr=_model.validate(_model.parameter.playerBorderSize,"n")?Number(_model.parameter.playerBorderSize):_model.vidBr;
			_model.vidMrg=_model.validate(_model.parameter.playerHorizontalMargin,"n")?Number(_model.parameter.playerHorizontalMargin):_model.vidMrg;
			_model.vidVMrg=_model.validate(_model.parameter.playerVerticalMargin,"n")?Number(_model.parameter.playerVerticalMargin):_model.vidVMrg;
			_model.vidCorRad=_model.validate(_model.parameter.playerCornerRadius,"n")?Number(_model.parameter.playerCornerRadius):_model.vidCorRad;
			_model.vidCol= _model.validate(_model.parameter.playerBgColor,"s")?String("0x"+_model.parameter.playerBgColor):_model.vidCol;
			_model.vidBrCol= _model.validate(_model.parameter.playerBorderColor,"s")?String("0x"+_model.parameter.playerBorderColor):_model.vidBrCol;
			_model.vidBgTra=_model.validate(_model.parameter.playerBgTransparency,"n")?Number(_model.parameter.playerBgTransparency)/100:_model.vidBgTra;
			_model.vidBrTra=_model.validate(_model.parameter.playerBorderTransparency,"n")?Number(_model.parameter.playerBorderTransparency)/100:_model.vidBrTra;
			_model.vidTimAlignB=_model.validate(_model.parameter.playerTimerAlignBottom,"s")?(String(_model.parameter.playerTimerAlignBottom)=="yes"?true:false):_model.vidTimAlignB;
			_model.skinType=_model.validate(_model.parameter.playerSkinGlassType,"s")?(String(_model.parameter.playerSkinGlassType)=="yes"?0:1):_model.skinType;
			_model.vidOvrLayCol= _model.validate(_model.parameter.playerOverlayColor,"s")?String("0x"+_model.parameter.playerOverlayColor):_model.vidOvrLayCol;
			_model.vidOvrLayTra=_model.validate(_model.parameter.playerOverlayTransparency,"n")?Number(_model.parameter.playerOverlayTransparency)/100:_model.vidOvrLayTra;
			_model.shadowAlpha=_model.validate(_model.parameter.playerShadowTransparency,"n")?Number(_model.parameter.playerShadowTransparency)/100:_model.shadowAlpha;
			_model.vidSekBarCol= _model.validate(_model.parameter.playerSeekBarColor,"s")?String("0x"+_model.parameter.playerSeekBarColor):_model.vidSekBarCol;
			_model.sekHig=_model.validate(_model.parameter.playerSeekBarHeight,"n")?Number(_model.parameter.playerSeekBarHeight):_model.sekHig;
			
			_model.btnWid=_model.validate(_model.parameter.playerButtonWidth,"n")?Number(_model.parameter.playerButtonWidth):_model.btnWid;
			_model.btnOvrCol=_model.validate(_model.parameter.playerButtonRollOverColor,"s")?String("0x"+_model.parameter.playerButtonRollOverColor):_model.btnOvrCol;
			_model.btnSprCol=_model.validate(_model.parameter.playerSeparatorColor,"s")?String("0x"+_model.parameter.playerSeparatorColor):_model.btnSprCol;
			_model.btnSprTra=_model.validate(_model.btnSprCol,"s")?.25:0;
			_model.icoCol=_model.validate(_model.parameter.playerIconColor,"s")?String("0x"+_model.parameter.playerIconColor):_model.icoCol;
			_model.icoSiz=_model.validate(_model.parameter.playerIconSize,"n")?Number(_model.parameter.playerIconSize)/100:_model.icoSiz;
			
			_model.textBgAlpha=_model.validate(_model.parameter.textBgAlpha,"n")?Number(_model.parameter.textBgAlpha)/100:.75;
			_model.textBgColor=_model.validate(_model.parameter.textBgColor,"s")?String("0x"+_model.parameter.textBgColor):"0xffffff";
			_model.embedFont= _model.validate(_model.parameter.textEmbedFont,"s")?(String(_model.parameter.textEmbedFont)=="no"?false:true):true;
			_model.titleText=_model.validate(_model.parameter.videoTitle,"s")?String(_model.parameter.videoTitle):"";
			_model.titleVspace=_model.validate(_model.parameter.titleVerticalSpace,"n")?Number(_model.parameter.titleVerticalSpace):0;
			
			_model.desText=_model.validate(_model.parameter.videoDescription ,"s")?String(_model.parameter.videoDescription ):"";
			_model.bgColor=_model.validate(_model.parameter.videoBgColor,"s")?String("0x"+_model.parameter.videoBgColor):"0x000000";
			_model.volPrePos=_model.validate(_model.parameter.videoVolumeStart,"n")?Number(_model.parameter.videoVolumeStart)/100:.5;
			
			_model.reflect= _model.validate(_model.parameter.reflection,"s")?(String(_model.parameter.reflection)=="yes"?true:false):false;
			_model.refVidOnly= _model.validate(_model.parameter.reflectVideoOnly,"s")?(String(_model.parameter.reflectVideoOnly)=="yes"?true:false):true;
			_model.refDis=_model.validate(_model.parameter.refelectionDistance,"n")?Number(_model.parameter.refelectionDistance):1;
			_model.refDep=_model.validate(_model.parameter.reflectionDepth,"n")?Number(_model.parameter.reflectionDepth):39;
			_model.refAlp=_model.validate(_model.parameter.reflectionTransparency,"n")?Number(_model.parameter.reflectionTransparency)/100:.5;
			
		}		
	}
}