var SwfUtil = (function() {
    
    return {
        load: function($container, $src, $width, $height, $data) {
            var flashVersion = swfobject.getFlashPlayerVersion();
            
            if (flashVersion.major >= 10) {
                /** 플래시로 전달할 데이터    */
                var flashVars = $data;
                var params = { allowScriptAccess: 'always', allowFullScreen: 'true', wmode: 'transparent' };
                var attr = { id: $container, name: $container };
                /** 플래시 경로  */
                var src = $src;
                swfobject.embedSWF(src+"?rand=" + Math.random() * 100000, $container, $width+"px", $height+"px", '10', '../../libs/adobe/flash/expressinstall.swf', flashVars, params, attr);
            }
            else {
                alert("아래 링크를 사용하여 Flash를 재설치 해주세요.");
                var nonFlash = '<div id="nonFlash" style="margin:100px;text-align:center;" >플래시 파일이 안보이시면 아래 Flash Player를 설치하신 후 인터넷창을 새로 열어서 확인바랍니다.<p><a href="http://get.adobe.com/kr/flashplayer/" target="_blank"><img src="../../libs/adobe/flash/flash_128.jpg" alt="플래시 플레이어 재설치" /></a> </p></div>';
                $("#"+$container).html(nonFlash);
            }
        }
    }
    
})(SwfUtil);

