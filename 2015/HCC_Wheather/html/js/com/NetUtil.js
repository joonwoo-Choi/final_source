var NetUtil = (function() {
    
    return {
        isMobile: function() {
            /** 모바일 체크  */
            var ua = window.navigator.userAgent.toLowerCase();
            if ( /android/.test(ua) || /iphone/.test(ua) || /ipad/.test(ua) || /ipod/.test(ua) ){
                // 모바일
                return true;
            }
            return false;
        },
        getBrowser: function() {
            /** 브라우저 체크  */
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
        getParameterByName: function(name) {
            /** url 파라미터 값 이름으로 가져오기  */
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        },
        setCookie: function() {
            /** 쿠키 저장  */
            var expire = new Date();
            expire.setDate(expire.getDate() + cDay);
            cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
            if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
            document.cookie = cookies;
        },
        getCookie: function() {
            /** 쿠키 가져오기  */
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
        }
    }
    
})(NetUtil);

