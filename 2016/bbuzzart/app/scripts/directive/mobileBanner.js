(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('mobileBanner', [function(){
		return {
			restrict: 'A',
			templateUrl: 'views/main/mobileBanner.html',
			replace: true,
            link: function(scope, iElement, iAttrs){
                
                scope.isAndroid = false;
                scope.ua = window.navigator.userAgent.toLowerCase();
                if( scope.ua.indexOf('android') > -1 && scope.ua.indexOf('mobile') > -1 ){
                    scope.isAndroid = true;
                }else{
                    scope.isAndroid = false;
                }
                
                scope.popupClose = function(){
                    iElement.css({'display':'none'});
                }
                
                scope.openApp = function(){
                    var appInfo = {
                            baseURL : 'bbuzzart://',
                            android : {
                                package : 'net.bbuzzart.android',
                                storeURL : 'market://details?id=net.bbuzzart.android'
                            },
                            ios : {
                                appID : '868618986',
                                storeURL : 'itms-apps://itunes.apple.com/kr/app/id868618986'
                            }
                        };
                    
                    if(scope.ua.indexOf('android') > -1){
                        var appUrl = appInfo.baseURL;
                        location.href = 'intent:' + appUrl + '#Intent;package=' + appInfo.android.package + ';end;';
//                        if (scope.ua.indexOf('fb_iab') > -1) {
//                            //FACEBOOK IN APP BROWSER
//                            var runAppInFacebook = function (uri) {
//                                var iframe = document.createElement('iframe');
//                                iframe.style.display = 'none';
//                                iframe.src = uri;
//                                iframe.width = '0px';
//                                iframe.height = '0px';
//                                document.body.appendChild(iframe);
//                            };
//                            runAppInFacebook(appUrl);
//                            setTimeout(function () {
//                                runAppInFacebook(appInfo.android.storeURL);	
//                            }, 1500);
//                        } else if (scope.ua.indexOf('chrome') > -1) {
//                            // https://developers.google.com/chrome/mobile/docs/intents
//                            window.location = 'intent:' + appUrl + '#Intent;package=' + appInfo.android.package + ';end;';
//                        } else {
//                            //DEFAULT ANDROID BROWSER
//                            var appUrls = [];
//                            appUrls.push(appInfo.android.storeURL);
//                            appUrls.push(appUrl);
//
//                            (function runApp (uri) {
//                                if (uri.length > 0) {
//                                    var appuri = uri.pop();
//                                    var iframe = document.createElement('iframe');
//                                    iframe.style.display = 'none';
//                                    iframe.src = appuri;
//                                    iframe.width = '0px';
//                                    iframe.height = '0px';
//                                    iframe.onload = function (){
//                                        runApp(uri);
//                                    };
//                                    document.body.appendChild(iframe);
//                                }
//                            }(appUrls));
//                        }
                    }else{
                        var timer = setTimeout(function(){
                            clearTimer();
                            location.href = appInfo.ios.storeURL;
                        }, 1500);
                        
                        function clearTimer(){
                            clearTimeout(timer);
                            timer = null;
                            window.removeEventListener('pagehide', clearTimer);
                        };
                        
                        window.addEventListener('pagehide', clearTimer);
                        location.href = appInfo.baseURL;
                    }
                }
                
            }
		};
	}]);
})(angular);