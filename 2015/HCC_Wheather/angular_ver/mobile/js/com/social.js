var social = {};
social.config = {};

/** 카카오 자바스크립트 앱 키  */
social.config.kakaoApplicationKey = "5be90a8b749f5ae5a5ec7965dd1bbaf1";

(function ($) {
    'use strict';
    /** 카카오스토리  */
    var kakaoUserId = null,
        kakaoUserName = null,
        kakaoProfileImage = null;
    
    var shareMethods = {
        /** 페이스북    */
        shareOnFacebook: function(linkUrl, description) { 
            window.open("http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(linkUrl) + "&t=" + encodeURIComponent(description));
        },
        /** 트위터 */
        shareOnTwitter: function(linkUrl, description) { 
            window.open("http://twitter.com/intent/tweet?url=" + encodeURIComponent(linkUrl) + "&text=" + encodeURIComponent(description));
        },
        /** 링크드인    */
        shareOnLinkedIn: function(linkUrl, description, title, source) { 
            window.open("http://www.linkedin.com/shareArticle?mini=true&url=" + encodeURIComponent(linkUrl) + "&title=" + encodeURIComponent(title) + "&description=" + encodeURIComponent(description) + "&source=" + encodeURIComponent(source));
        },
        /** 구글+ */
        shareOnGooglePlus: function(linkUrl) { 
            window.open("https://plus.google.com/share?url=" + encodeURIComponent(linkUrl));
        },
        /** 핀터레스트   */
        shareOnPinterest: function(linkUrl, description, thumbnail){
            window.open("http://pinterest.com/pin/create/button/?url=" + encodeURIComponent(linkUrl) + "&media=" + encodeURIComponent(thumbnail) + "&description=" +  encodeURIComponent(description));
        },
        /** 네이버 밴드  */
        shareOnBand: function(linkUrl, description){
            var param = 'bandapp://create/post?text=' + encodeURIComponent(description) + "&route=" + encodeURIComponent(linkUrl);
            if(navigator.userAgent.match(/android/i)){
                /** 안드로이드   */
                setTimeout(function(){
                    location.href = 'intent:' + param + '#Intent;package=com.nhn.android.band;end;';
                }, 100);
            }else if(navigator.userAgent.match(/iphone|ipod|ipad/i)){
                /** IOS */
                setTimeout(function(){
                    location.href = 'itms-apps://itunes.apple.com/app/id542613198?mt=8';
                }, 200);
                setTimeout(function(){
                    location.href = param;
                }, 100);
            }else{
                /** PC 웹    */
                window.open("http://www.band.us/plugin/share?body=" + encodeURIComponent(description) + "&route=" + encodeURIComponent(linkUrl));
            }
        },
        /** 네이버 라인  */
        shareOnLine: function(linkUrl, description){
            var param = 'line://msg/text/' + encodeURIComponent(description) + "\n" + encodeURIComponent(linkUrl);
            if(navigator.userAgent.match(/android/i)){
                /** 안드로이드   */
                setTimeout(function(){
                    location.href = 'intent:' + param + '#Intent;package=jp.naver.line.android;end;';
                }, 100);
            }else if(navigator.userAgent.match(/iphone|ipod|ipad/i)){
                /** IOS */
                setTimeout(function(){
                    location.href = 'itms-apps://itunes.apple.com/app/line/id443904275?mt=8';
                }, 200);
                setTimeout(function(){
                    location.href = param;
                }, 100);
            }else{
                /** PC 웹    */
				location.href = "http://line.naver.jp/R/msg/text/?" + encodeURIComponent(description) + "\n" + encodeURIComponent(linkUrl);
            }
        },
        /** 메일  */
        shareOnMail: function(email, title, description){
            var mailToLink = "mailto:" + encodeURIComponent(email);
            if(title == "") mailToLink = mailToLink + "?body=" + encodeURIComponent(description);
            else mailToLink = mailToLink + "?subject=" + encodeURIComponent(title) + "&body=" + encodeURIComponent(description);
            window.location.href = mailToLink;
        },
        /** SMS  */
        shareOnSMS: function(phNum, description){
            var smsToLink;
            if(navigator.userAgent.match(/iphone|ipod|ipad/i)){
                smsToLink = "sms:" + encodeURIComponent(phNum);
            }else{
                smsToLink = "sms:" + encodeURIComponent(phNum) + "?body=" + encodeURIComponent(description);
            }
            window.location.href = smsToLink;
        },
        /** URL 클립보드 복사  */
        shareOnCopyUrl: function(linkUrl, description){
            if(navigator.userAgent.match(/trident|msie/gi)){
                window.clipboardData.setData('Text', linkUrl);
                alert("복사되었습니다.\n원하는 곳에 붙여넣기(Ctrl+V)하세요.");
            }else{
                prompt(description, linkUrl);
            }
        },
        /** 카카오 */
        kakao:{
            /** 로그인 */
            login: function(callback){
                if(typeof(Kakao) !== "null" && typeof(Kakao) !== "undefined" && !libraryInitialized){
                    Kakao.init(social.config.kakaoApplicationKey);
                    libraryInitialized = true;
                }
                Kakao.Auth.getStatus(function(status){
                    if(status.status == 'connected'){
                        kakaoUserId = status.user.id;
                        kakaoUserName = status.user.properties.nickname;
                        kakaoProfileImage = status.user.properties.profile_image;

                        if($.isFunction(callback)){
                            callback.call(this, social.kakao.getUserInfo());
                        }
                    }else{
                        Kakao.Auth.login({
                            success: function(data){
                                Kakao.API.request({
                                    url:"/v1/user/me",
                                    success: function(res){
                                        kakaoUserId = res.id;
                                        kakaoUserName = res.properties.nickname;
                                        kakaoProfileImage = res.properties.profile_image;

                                        if($.isFunction(callback)){
                                            callback.call(this, social.kakao.getUserInfo());
                                        }
                                    }
                                });
                            },
                            fail: function(err) {
                                alert(JSON.stringify(err))
                            }
                        });
                    }
                });
            },
            /** 유저정보 가져오기   */
            getUserInfo: function(){
                return {
                    id: kakaoUserId,
                    nickName: kakaoUserName,
                    profileImage: kakaoProfileImage
                };
            },
            /** 카카오톡 공유 */
            shareOnTalk: function(linkUrl, title, linkText, thumbnail, thumbWidth, thumbHeight, btnTitle){
                if(!isKakaoApiLoaded) return;
                if(typeof(Kakao) !== "null" && typeof(Kakao) !== "undefined" && !libraryInitialized){
                    libraryInitialized = true;
                    Kakao.init(social.config.kakaoApplicationKey);
                }
                var param = {
                    label: title,
                    webLink: { text: linkText, url: linkUrl },
                    image : { src : thumbnail, width : thumbWidth, height : thumbHeight },
                    webButton: { text: btnTitle, url: linkUrl }
                };

                if(title == "") delete param.label;
                if(linkUrl == "") delete param.webLink;
                if(thumbnail == "") delete param.image;
                if(btnTitle == "") delete param.webButton;

                Kakao.Link.sendTalkLink(param);
            },
            /** 카카오스토리 공유   */
            shareOnStory: function(linkUrl, linkTitle, description, imgUrl, callback){
                if(typeof(Kakao) !== "null" && typeof(Kakao) !== "undefined" && !libraryInitialized){
                    libraryInitialized = true;
                    Kakao.init(social.config.kakaoApplicationKey);
                }
                /** 모바일이면 앱으로 연결 / PC면 바로 공유    */
                if(navigator.userAgent.match(/iphone|ipad|ipod|android/gi)){
                    var infoParam = {}
                    kakao.link("story").send({
                        post : linkTitle + "\n" + description+"\n"+linkUrl,
                        appid : linkTitle,
                        appver : "1.0",
                        appname : linkTitle,
                        urlinfo : JSON.stringify({title:linkTitle, desc:description, imageurl:imgUrl, type:"article"})
                    });
                }else{
                    social.kakao.login(function(){
                        Kakao.API.request({
                            url:"/v1/api/story/linkinfo",
                            data:{ url: linkUrl }
                        }).then(function(res){
                            Kakao.API.request({
                                url:"/v1/api/story/post/link",
                                data:{
                                    content: description+"\n"+linkUrl,
                                    link_info: res
                                },
                                success: function(res){
                                    if($.isFunction(callback)){
                                        callback.call(this, res.id);
                                    }
                                }
                            });
                        });
                    });
                }
            }
        }
    }
    
    $.extend(social, shareMethods);
    
})(jQuery);


/** 앱키 인증 여부    */
var libraryInitialized = false;
/** 카카오 API 로드   */
var head = document.getElementsByTagName('head')[0];
var kakaoApi= document.createElement('script');
kakaoApi.type= 'text/javascript';

var isKakaoApiLoaded = false;
/** API 로드 체크   */
if(/msie 7|msie 8/gi.test(navigator.userAgent)){
    /** IE7/8 API 로드 체크 */
    kakaoApi.onreadystatechange = function () {
        if (this.readyState == 'loaded' || this.readyState == 'complete') {
            if (isKakaoApiLoaded) { return; }
            kakaoApiLoadedCallback();
        }
    }
}else{
    kakaoApi.onload = function () {
        if (isKakaoApiLoaded) { return; }
        kakaoApiLoadedCallback();
    };
}
function kakaoApiLoadedCallback(){
    isKakaoApiLoaded = true;
    /** 개발자 앱키 받아오기 */
    if(typeof(Kakao) !== "null" && typeof(Kakao) !== "undefined" && !libraryInitialized){
        libraryInitialized = true;
        Kakao.init(social.config.kakaoApplicationKey);
    }
}
kakaoApi.src = "https://developers.kakao.com/sdk/js/kakao.min.js";
head.appendChild(kakaoApi);



/* 
* Copyright 2014 KAKAO 
*/
/** 카카오 스토리 API - 카카오스토리 링크 */
!function(a){"use strict";var b=a.userAgent=function(a){function b(a){var b={},d=/(dolfin)[ \/]([\w.]+)/.exec(a)||/(chrome)[ \/]([\w.]+)/.exec(a)||/(opera)(?:.*version)?[ \/]([\w.]+)/.exec(a)||/(webkit)(?:.*version)?[ \/]([\w.]+)/.exec(a)||/(msie) ([\w.]+)/.exec(a)||a.indexOf("compatible")<0&&/(mozilla)(?:.*? rv:([\w.]+))?/.exec(a)||["","unknown"];return"webkit"===d[1]?d=/(iphone|ipad|ipod)[\S\s]*os ([\w._\-]+) like/.exec(a)||/(android)[ \/]([\w._\-]+);/.exec(a)||[d[0],"safari",d[2]]:"mozilla"===d[1]?d[1]=/trident/.test(a)?"msie":"firefox":/polaris|natebrowser|([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test(a)&&(d[1]="polaris"),b[d[1]]=!0,b.name=d[1],b.version=c(d[2]),b}function c(a){var b={},c=a?a.split(/\.|-|_/):["0","0","0"];return b.info=c.join("."),b.major=c[0]||"0",b.minor=c[1]||"0",b.patch=c[2]||"0",b}function d(a){return e(a)?"pc":f(a)?"tablet":g(a)?"mobile":""}function e(a){return a.match(/linux|windows (nt|98)|macintosh/)&&!a.match(/android|mobile|polaris|lgtelecom|uzard|natebrowser|ktf;|skt;/)?!0:!1}function f(a){return a.match(/ipad/)||a.match(/android/)&&!a.match(/mobi|mini|fennec/)?!0:!1}function g(a){return a.match(/ip(hone|od)|android.+mobile|windows (ce|phone)|blackberry|bb10|symbian|webos|firefox.+fennec|opera m(ob|in)i|polaris|iemobile|lgtelecom|nokia|sonyericsson|dolfin|uzard|natebrowser|ktf;|skt;/)?!0:!1}function h(a){var b={},d=/(iphone|ipad|ipod)[\S\s]*os ([\w._\-]+) like/.exec(a)||/(android)[ \/]([\w._\-]+);/.exec(a)||(/android/.test(a)?["","android","0.0.0"]:!1)||(/polaris|natebrowser|([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test(a)?["","polaris","0.0.0"]:!1)||/(windows)(?: nt | phone(?: os){0,1} | )([\w._\-]+)/.exec(a)||(/(windows)/.test(a)?["","windows","0.0.0"]:!1)||/(mac) os x ([\w._\-]+)/.exec(a)||(/(linux)/.test(a)?["","linux","0.0.0"]:!1)||(/webos/.test(a)?["","webos","0.0.0"]:!1)||/(bada)[ \/]([\w._\-]+)/.exec(a)||(/bada/.test(a)?["","bada","0.0.0"]:!1)||(/(rim|blackberry|bb10)/.test(a)?["","blackberry","0.0.0"]:!1)||["","unknown","0.0.0"];return"iphone"===d[1]||"ipad"===d[1]||"ipod"===d[1]?d[1]="ios":"windows"===d[1]&&"98"===d[2]&&(d[2]="0.98.0"),b[d[1]]=!0,b.name=d[1],b.version=c(d[2]),b}function i(a){var b={},d=/(crios)[ \/]([\w.]+)/.exec(a)||/(daumapps)[ \/]([\w.]+)/.exec(a)||["",""];return d[1]?(b.isApp=!0,b.name=d[1],b.version=c(d[2])):b.isApp=!1,b}return a=(a||window.navigator.userAgent).toString().toLowerCase(),{ua:a,browser:b(a),platform:d(a),os:h(a),app:i(a)}};"object"==typeof window&&window.navigator.userAgent&&(window.ua_result=b(window.navigator.userAgent)||null),window&&(window.util=window.util||{},window.util.userAgent=b)}(function(){return"object"==typeof exports?(exports.daumtools="undefined"==typeof exports.daumtools?{}:exports.daumtools,exports.daumtools):"object"==typeof window?(window.daumtools="undefined"==typeof window.daumtools?{}:window.daumtools,window.daumtools):void 0}()),function(a){"use strict";a.web2app=function(){function a(a){window.location.href=a}function b(b){var e="function"==typeof b.willInvokeApp?b.willInvokeApp:function(){},h="function"==typeof b.onAppMissing?b.onAppMissing:a,i="function"==typeof b.onUnsupportedEnvironment?b.onUnsupportedEnvironment:function(){};e(),r.android?c()||b.useUrlScheme?b.storeURL&&d(b.urlScheme,b.storeURL,h):b.intentURI&&f(b.intentURI):r.ios&&b.storeURL?g(b.urlScheme,b.storeURL,h):setTimeout(function(){i()},100)}function c(){var a=new RegExp(s.join("|"),"i");return a.test(q.ua)}function d(a,b,c){e(o,b,c),k(a)}function e(a,b,c){var d=(new Date).getTime();return setTimeout(function(){var e=(new Date).getTime();j()&&a+p>e-d&&c(b)},a)}function f(a){setTimeout(function(){top.location.href=a},100)}function g(a,b,c){var d;parseInt(q.os.version.major,10)<8?(d=e(n,b,c),h(d)):(d=e(m,b,c),i(d)),k(a)}function h(a){window.addEventListener("pagehide",function b(){j()&&(clearTimeout(a),window.removeEventListener("pagehide",b))})}function i(a){document.addEventListener("visibilitychange",function b(){j()&&(clearTimeout(a),document.removeEventListener("visibilitychange",b))})}function j(){for(var a=["hidden","webkitHidden"],b=0,c=a.length;c>b;b++)if("undefined"!==document[a[b]])return!document[a[b]];return!0}function k(a){setTimeout(function(){var b=l("appLauncher");b.src=a},100)}function l(a){var b=document.createElement("iframe");return b.id=a,b.style.border="none",b.style.width="0",b.style.height="0",b.style.display="none",b.style.overflow="hidden",document.body.appendChild(b),b}var m=1e3,n=2e3,o=300,p=100,q=daumtools.userAgent(),r=q.os,s=["firefox","opr"];return b}()}(window.daumtools="undefined"==typeof window.daumtools?{}:window.daumtools),function(a){"use strict";a.daumtools="undefined"==typeof a.daumtools?{}:a.daumtools,"undefined"!=typeof a.daumtools.web2app&&(a.daumtools.web2app.version="1.0.3")}(window); 

 
(function(kakao, undefined) { 
    var base_url = "storylink://posting?"; 
    var apiver =  "1.0"; 
    var store = { 
        android: "market://details?id=com.kakao.story", 
        ios: "http://itunes.apple.com/app/id486244601" 
    }; 
    var packageName = "com.kakao.story"; 

    kakao.link = function (name) { 
        if (name != 'story') return { send: function () { 
            throw "only story links are supported."; 
        }}; 

        return { 
            send: function(params) { 
                params['apiver'] = apiver; 

                var urlScheme = base_url + serialized(params); 
                var intentURI = 'intent:' + urlScheme + "#Intent;package=" + packageName + ";end;"; 
                var appStoreURL = daumtools.userAgent().os.android ? store.android : store.ios; 

                daumtools.web2app({ 
                    urlScheme: urlScheme, 
                    intentURI: intentURI, 
                    storeURL : appStoreURL, 
                    appName : 'KakaoStory' 
                }); 
            } 
        }; 

        function serialized(params) { 
            var stripped = []; 
            for (var k in params) { 
                if (params.hasOwnProperty(k)) { 
                    stripped.push(k + "=" + encodeURIComponent(params[k])); 
                } 
            } 
            return stripped.join("&"); 
        } 
    }; 
}(window.kakao = window.kakao || {})); 








