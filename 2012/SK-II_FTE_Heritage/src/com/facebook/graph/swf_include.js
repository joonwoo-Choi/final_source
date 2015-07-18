function swf_include(swfUrl,swfWidth,swfHeight,bgColor,swfName,access,flashVars){
	// 플래시 코드 정의
	var flashStr=
	"<object classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0' width='"+swfWidth+"' height='"+swfHeight+"' id='"+swfName+"' align='middle' />"+
	"<param name='allowScriptAccess' value='"+access+"' />"+
	"<param name='wmode' value='transparent' />"+
	"<param name='movie' value='"+swfUrl+"' />"+
	"<param name='FlashVars' value='"+flashVars+"' />"+
	"<param name='loop' value='false' />"+
	"<param name='menu' value='false' />"+
	"<param name='quality' value='high' />"+
	"<param name='scale' value='noscale' />"+
	"<param name='bgcolor' value='"+bgColor+"' />"+
	"<param name='allowFullScreen' value='false' />"+
	"<embed src='"+swfUrl+"' FlashVars='"+flashVars+"'  quality='best' bgcolor='#EEF8FF' width='"+swfWidth+"' height='"+swfHeight+"' name='"+swfName+"' align='middle' allowFullScreen='false' allowScriptAccess='always' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer' />"+
	"</object>";

	// 플래시 코드 출력
	document.write(flashStr);
};