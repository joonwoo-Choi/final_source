var utils = {
    
    netUtil: {
        /** 모바일 체크  */
        isMobile: function() {
            var ua = window.navigator.userAgent.toLowerCase();
            if ( navigator.userAgent.match(/(android)|(iphone)|(ipod)|(ipad)/i) ){
                // 모바일
                return true;
            }
            return false;
        },
        /** 브라우저 체크  */
        getBrowser: function() {
            var ua= navigator.userAgent, tem,
            M= ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
            if(/trident/i.test(M[1])){
                tem=  /\brv[ :]+(\d+)/g.exec(ua) || [];
                return 'IE '+(tem[1] || '');
            }
            if(M[1]=== 'Chrome'){
                tem= ua.match(/\bOPR\/(\d+)/)
                if(tem!= null) return 'Opera '+tem[1];
            }
            M= M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
            if((tem= ua.match(/version\/(\d+)/i))!= null) M.splice(1, 1, tem[1]);
            return M.join(' ');
        },
        /** url 파라미터 값 이름으로 가져오기  */
        getParameterByName: function(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        },
        /** 쿠키 저장  */
        setCookie: function(cName, cValue, cDay) {
            var expire = new Date();
            expire.setDate(expire.getDate() + cDay);
            cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
            if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
            document.cookie = cookies;
        },
        /** 쿠키 가져오기  */
        getCookie: function(cName) {
            cName = cName + '=';
            var cookieData = document.cookie;
            var start = cookieData.indexOf(cName);
            var cValue = '';
            if(start != -1){
               start += cName.length;
               var end = cookieData.indexOf(';', start);
               if(end == -1)end = cookieData.length;
               cValue = cookieData.substring(start, end);
            }
            return unescape(cValue);
        },
        /** 쿠키 체크   */
        checkCookie: function(cName) {
            var user = utils.netUtil.getCookie("cName");
            if (user != "") {
                /** 쿠키 있음   */
//                alert("Welcome  " + user);
            } else {
                /** 쿠키 없음   */
//                user = prompt("Please enter your name:", "");
//                if (user != "" && user != null) {
//                    utils.netUtil.setCookie("username", user, 365);
//                }
            }
        }
    },
    
    /** 플래시 */
    swfUtil: {
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
            }else{
                alert("아래 링크를 사용하여 Flash를 재설치 해주세요.");
                var nonFlash = '<div id="nonFlash" style="margin:100px;text-align:center;" >플래시 파일이 안보이시면 아래 Flash Player를 설치하신 후 인터넷창을 새로 열어서 확인바랍니다.<p><a href="http://get.adobe.com/kr/flashplayer/" target="_blank"><img src="../../libs/adobe/flash/flash_128.jpg" alt="플래시 플레이어 재설치" /></a> </p></div>';
                $("#"+$container).html(nonFlash);
            }
        },
        empty: function($container) {
            $("#"+$container).empty();
        }
    },
    
    /** 버튼 생성   */
    buttonUtil: {
        makeButton: function($target, $fn) {
            $($target).css({"cursor":"pointer"});
            $($target).bind("mouseenter", $fn);
            $($target).bind("mouseleave", $fn);
            $($target).bind("click", $fn);
        },
        removeButton: function($target, $fn) { 
            $($target).css({"cursor":"auto"});
            $($target).unbind("mouseenter", $fn);
            $($target).unbind("mouseleave", $fn);
            $($target).unbind("click", $fn);
        }
    },
    
    /** 단위 콤마 찍기    */
    currencyFormat: function($str) { 
        var num = $str.trim();

        while ((/(-?[0-9]+)([0-9]{3})/).test(num)) {
            num = num.replace((/(-?[0-9]+)([0-9]{3})/), "$1,$2");
        }

        return num;
    },
    
    /** 배열 랜덤 섞기    */
    shuffle: function(array) {
        var currentIndex = array.length, temporaryValue, randomIndex ;
        
        while (0 !== currentIndex) {
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex -= 1;

            temporaryValue = array[currentIndex];
            array[currentIndex] = array[randomIndex];
            array[randomIndex] = temporaryValue;
        }
        return array;
    },
    
    /** 배열 인덱스 체인지  */
    arrayChangeIndex: function(array, newIdx, oldIdx) {
        var arr = array;
        if (newIdx >= arr.length) {
            var k = newIdx - arr.length;
            while ((k--) + 1) {
                arr.push(undefined);
            }
        }
        arr.splice(newIdx, 0, arr.splice(oldIdx, 1)[0]);
        return arr;
    },
    
    /** 마우스&터치 포인트 좌표 값 리턴  */
    pointerEventToXY: function(e){
        var out = {x:0, y:0};
        if(e.type == 'touchstart' || e.type == 'touchmove' || e.type == 'touchend' || e.type == 'touchcancel'){
            var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
            out.x = touch.pageX;
            out.y = touch.pageY;
        } else if (e.type == 'mousedown' || e.type == 'mouseup' || e.type == 'mousemove' || e.type == 'mouseover'|| e.type=='mouseout' || e.type=='mouseenter' || e.type=='mouseleave') {
            out.x = e.pageX;
            out.y = e.pageY;
        }
        return out;
    }
    
};

