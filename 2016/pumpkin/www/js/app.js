
/** url scheme function */
var handleOpenURL;
/** 애드몹 광고 오픈 체크    */
var isAdmobOpen = false;

angular.module('giftbox.services', []);
angular.module('giftbox.directives', []);
angular.module('giftbox.controllers', []);

var app = angular.module('giftbox', ['ionic', 'ngCordova', 'cordovaHTTP', 'giftbox.services', 'giftbox.directives', 'giftbox.controllers'])

app.run(function($rootScope, $window, $q, $timeout, $state, $ionicPlatform, $ionicLoading, $cordovaDevice, $cordovaGoogleAnalytics, pushSvc, storageSvc, appDataSvc, restApiSvc, dialogSvc, calendarSvc) {
    
    var directDetailGo = false;
    var isGetNotification = false;
    var isGetUrlscheme = false;
    var isHomeEventListLoaded = false;
    var eventId;
    
    $rootScope.$on('$stateChangeStart', function(e, to, params){
//        $ionicLoading.hide();
//        $ionicLoading.show();
    });
    $rootScope.$on('$stateChangeSuccess', function(){
//        $ionicLoading.hide();
        if (window.cordova) {
            $timeout(function(){
                var location = window.location.hash.split('#')[1];
                $cordovaGoogleAnalytics.trackView(location);
            });
        };
    });
    $rootScope.$on('getPushNotification', function(e, params){
        directDetailGo = true;
        isGetNotification = true;
        eventId = params.eventId;
        directGoDetail();
    });
    $rootScope.$on('homeEventListLoaded', function(e, params){
        isHomeEventListLoaded = true;
        directGoDetail();
    });
    
    function directGoDetail(){
        if(isGetNotification && isHomeEventListLoaded){
            isGetNotification = false;
            $timeout(function(){
                $cordovaGoogleAnalytics.trackEvent('NOTIFICATION EVENT', 'Event Detail - ' + eventId);
                $state.go('tab.home', {eventId: eventId});
            });
        }else if(isGetUrlscheme && isHomeEventListLoaded){
            isGetUrlscheme = false;
            $timeout(function(){
                $cordovaGoogleAnalytics.trackEvent('URL SCHEME EVENT', 'Event Detail - ' + eventId);
                $state.go('tab.home', {eventId: eventId});
            });
        };
    };
    
    
    /** set api base url    */
    restApiSvc.setBaseUrl('http://api.pumpkinfactory.net');
    
    /** os 설정   */
    if( /(android)/i.test(navigator.userAgent) ){
        appDataSvc.os = 'ANDROID';
    }else{
        appDataSvc.os = 'IOS';
    }
    
    $ionicLoading.show();
    
    /** ionic ready */
    $ionicPlatform.ready(function() {
        if (window.cordova) {
            /** 디바이스 아이디    */
            var devideId = $cordovaDevice.getUUID();
            var devideName = $cordovaDevice.getName();
            appDataSvc.setDeviceId(devideId);
//            alert('devideId ' + devideName + ' ' + appDataSvc.os);
            
            /** 구글 애널리틱스    */
//            $cordovaGoogleAnalytics.debugMode();
//            $cordovaGoogleAnalytics.startTrackerWithId('UA-80182145-1');
//            $cordovaGoogleAnalytics.setUserId(devideId);
            
            /** 푸시  */
            pushSvc.init();
            
            /** 디바이스 회전 잠금  */
            window.plugins.orientationLock.lock("portrait");
        };
        if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
            /** 키보드 */
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
            cordova.plugins.Keyboard.disableScroll(true);
        };
        if (window.StatusBar) {
            /** 스테이터스 바 */
            StatusBar.styleDefault();
        };
        
        storageSvc.init();
        
        /** 링크타고 진입시    */
        handleOpenURL = function(url) {
            if(url.indexOf('?') > -1){
                var tempParams = url.split('?')[1].split('&');
                var params = {};
                tempParams.forEach(function(val, idx){
                    var keyVal = val.split('=');
                    params[keyVal[0]] = keyVal[1];
                });
//                alert("RECEIVED URL: " + params.event);

                if(params.event != undefined){
                    isGetUrlscheme = true;
                    directDetailGo = true;
                    eventId = params.event;
                    directGoDetail();
                }
            };
        };
        
        /** 홈 전면팝업 유무 체크    */
        $timeout(function(){
            restApiSvc.get(restApiSvc.apiPath.getMainPopup, {page:1, size:1}).then(
                function(res){
                    if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                        res.data = JSON.parse(res.data);
                    };
                    
                    var popupContent = res.data.data.content;
                    if(popupContent.length > 0){
                        storageSvc.getAll('homePopupClosed').then(
                            function(res){
                                $rootScope.mainPopupData = popupContent[0];
                                
                                var isDontShow = false;
                                angular.forEach(res, function(val, idx){
                                    if(!isDontShow){
                                        if(val.id == $rootScope.mainPopupData.eventId){
                                            isDontShow = true;
                                        };
                                    };
                                });

                                if(!isDontShow && !directDetailGo){
                                    dialogSvc.openMainPopup();
                                };
                            }
                        );
                    }
                    
                    /** 구글 애드몹 - 팝업이 없을 때   */
                    initAd(popupContent.length);
                }
            );
        });
    });
    
})

.constant('$ionicLoadingConfig', {
    templateUrl: 'templates/common/blockui.html',
    delay: 50
})

.config(function($ionicConfigProvider, $stateProvider, $urlRouterProvider) {
    
    $ionicConfigProvider.navBar.alignTitle('center');
    $ionicConfigProvider.backButton.text('');
    $ionicConfigProvider.backButton.previousTitleText(false);
    
    $stateProvider
    
    .state('tab', {
//        url: '/tab',
        abstract: true,
        templateUrl: 'templates/tabs/tabs.html'
    })
    
    .state('tab.home', {
        url: '/home',
        params: {
            eventId: null,
        },
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-main.html',
                controller: 'mainCtrl'
            }
        },
        onEnter: function($timeout, $stateParams, $state){
            if($stateParams.eventId != null){
                var params = {
                        detailId: $stateParams.eventId
                    };
                
                $state.go('tab.home-detail', params);
            };
        }
    })
    .state('tab.home-detail', {
        cache: false,
        url: '/home/detail/:detailId',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-event-detail.html',
                controller: 'eventDetailCtrl'
            }
        },
        resolve:{
            initData : function ($q, $timeout, $stateParams, $ionicLoading, storageSvc, restApiSvc){
                
                var defer = $q.defer(),
                    tableName = 'viewedList';
                
                $ionicLoading.show();
                storageSvc.getByEventId(tableName, $stateParams.detailId).then(
                    function(res){
                        if(res != undefined && res != null){
                            var nowTime = new Date().getTime();
                            var savedTime = res.updatedTime;
                            var day = ((1000 * 60) * 60) * 24;
                            var gapTime = Math.floor((nowTime - savedTime)/day);
                            if(gapTime < 1){
                                delete res.tableId;
                                defer.resolve({
                                    eventList: res
                                });
                                storageSvc.insertViewedEvent(res);
                                $timeout(function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                getDeatilInfo();
                            };
                        }else{
                            getDeatilInfo();
                        };
                    }
                );
                
                function getDeatilInfo(){
                    restApiSvc.get(restApiSvc.apiPath.getEventDetail($stateParams.detailId)).then(
                        function(res){
                            /** success */
                            if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                                res.data = JSON.parse(res.data);
                            };
                            var data = res.data.data;
                            data.updatedTime = new Date().getTime();
                            $timeout(function(){
                                defer.resolve({
                                    eventList: data
                                });
                                storageSvc.insertViewedEvent(data);
                            }, 500);
                            $timeout(function(){
                                $ionicLoading.hide();
                            }, 150);
                        }, function(res, status){
                            /** error   */
                            defer.resolve(null);
                            $timeout(function(){
                                $ionicLoading.hide();
                            });
                        }
                    );
                };

                return defer.promise;
                
            }
        }
    })

    .state('tab.viewed', {
        url: '/viewed',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-my-event.html',
                controller: 'myEventCtrl'
            }
        }
    })
    .state('tab.viewed-detail', {
        cache: false,
        url: '/viewed/detail/:detailId',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-event-detail.html',
                controller: 'eventDetailCtrl'
            }
        },
        resolve:{
            initData : function ($q, $timeout, $stateParams, $ionicLoading, restApiSvc, storageSvc){
                
                var defer = $q.defer(),
                    tableName = 'viewedList';
                
                $ionicLoading.show();
                storageSvc.getByEventId(tableName, $stateParams.detailId).then(
                    function(res){
                        if(res != undefined && res != null){
                            var nowTime = new Date().getTime();
                            var savedTime = res.updatedTime;
                            var day = ((1000 * 60) * 60) * 24;
                            var gapTime = Math.floor((nowTime - savedTime)/day);
                            if(gapTime < 1){
                                defer.resolve({
                                    eventList: res
                                });
                                $timeout(function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                getDeatilInfo();
                            };
                        }else{
                            getDeatilInfo();
                        };
                    }
                );
                
                function getDeatilInfo(){
                    restApiSvc.get(restApiSvc.apiPath.getEventDetail($stateParams.detailId)).then(
                        function(res){
                            /** success */
                            if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                                res.data = JSON.parse(res.data);
                            };
                            var data = res.data.data;
                            data.updatedTime = new Date().getTime();
                            $timeout(function(){
                                defer.resolve({
                                    eventList: data
                                });
                                storageSvc.insertViewedEvent(data);
                            }, 500);
                            $timeout(function(){
                                $ionicLoading.hide();
                            }, 150);
                        }, function(res, status){
                            /** error   */
                            defer.resolve(null);
                            $timeout(function(){
                                $ionicLoading.hide();
                            });
                        }
                    );
                };
                
                return defer.promise;
                
            }
        }
    })

    .state('tab.bookmarked', {
        url: '/bookmarked',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-my-event.html',
                controller: 'myEventCtrl'
            }
        }
    })
    .state('tab.bookmarked-detail', {
        cache: false,
        url: '/bookmarked/detail/:detailId',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-event-detail.html',
                controller: 'eventDetailCtrl'
            }
        },
        resolve:{
            initData : function ($q, $timeout, $stateParams, $ionicLoading, restApiSvc, storageSvc){
                
                var defer = $q.defer(),
                    tableName = 'bookmarkedList';
                
                $ionicLoading.show();
                storageSvc.getByEventId(tableName, $stateParams.detailId).then(
                    function(res){
                        if(res != undefined && res != null){
                            var nowTime = new Date().getTime();
                            var savedTime = res.updatedTime;
                            var day = ((1000 * 60) * 60) * 24;
                            var gapTime = Math.floor((nowTime - savedTime)/day);
                            if(gapTime < 1){
                                defer.resolve({
                                    eventList: res
                                });
                                $timeout(function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                getDeatilInfo();
                            };
                        }else{
                            getDeatilInfo();
                        };
                    }
                );
                
                function getDeatilInfo(){
                    restApiSvc.get(restApiSvc.apiPath.getEventDetail($stateParams.detailId)).then(
                        function(res){
                            /** success */
                            if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                                res.data = JSON.parse(res.data);
                            };
                            var data = res.data.data;
                            data.updatedTime = new Date().getTime();
                            $timeout(function(){
                                defer.resolve({
                                    eventList: data
                                });
                                storageSvc.insertViewedEvent(data);
                            }, 500);
                            $timeout(function(){
                                $ionicLoading.hide();
                            }, 150);
                        }, function(res, status){
                            /** error   */
                            defer.resolve(null);
                            $timeout(function(){
                                $ionicLoading.hide();
                            });
                        }
                    );
                };
                
                return defer.promise;
                
            }
        }
    })

    .state('tab.joined', {
        url: '/joined',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-my-event.html',
                controller: 'myEventCtrl'
            }
        }
    })
    .state('tab.joined-detail', {
        cache: false,
        url: '/joined/detail/:detailId',
        views: {
            'tab-home': {
                templateUrl: 'templates/tabs/tab-event-detail.html',
                controller: 'eventDetailCtrl'
            }
        },
        resolve:{
            initData : function ($q, $timeout, $stateParams, $ionicLoading, restApiSvc, storageSvc){
                
                var defer = $q.defer(),
                    tableName = 'joinedList';
                
                $ionicLoading.show();
                storageSvc.getByEventId(tableName, $stateParams.detailId).then(
                    function(res){
                        if(res != undefined && res != null){
                            var nowTime = new Date().getTime();
                            var savedTime = res.updatedTime;
                            var day = ((1000 * 60) * 60) * 24;
                            var gapTime = Math.floor((nowTime - savedTime)/day);
                            if(gapTime < 1){
                                defer.resolve({
                                    eventList: res
                                });
                                $timeout(function(){
                                    $ionicLoading.hide();
                                });
                            }else{
                                getDeatilInfo();
                            };
                        }else{
                            getDeatilInfo();
                        };
                    }
                );
                
                function getDeatilInfo(){
                    restApiSvc.get(restApiSvc.apiPath.getEventDetail($stateParams.detailId)).then(
                        function(res){
                            /** success */
                            if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                                res.data = JSON.parse(res.data);
                            };
                            var data = res.data.data;
                            data.updatedTime = new Date().getTime();
                            $timeout(function(){
                                defer.resolve({
                                    eventList: data
                                });
                                storageSvc.insertViewedEvent(data);
                            }, 500);
                            $timeout(function(){
                                $ionicLoading.hide();
                            }, 150);
                        }, function(res, status){
                            /** error   */
                            defer.resolve(null);
                            $timeout(function(){
                                $ionicLoading.hide();
                            });
                        }
                    );
                };
                
                return defer.promise;
                
            }
        }
    });

    // if none of the above states are matched, use this as the fallback
    $urlRouterProvider.otherwise('/home');

});



/** 구글 애드몹  */

//initialize the goodies
function initAd(isHomePopup){
    if ( window.plugins && window.plugins.AdMob ) {
        var isShowGooglePopup = false;
        if(!isHomePopup){
            isShowGooglePopup = true;
        };
        
        var ad_units = {
            ios : {
                banner: 'ca-app-pub-3298227722707285/8261255451',
                interstitial: 'ca-app-pub-3298227722707285/2214721857'
            },
            android : {
                banner: 'ca-app-pub-3298227722707285/8400856252',
                interstitial: 'ca-app-pub-3298227722707285/3831055857'
            }
        };
        var admobid = ( /(android)/i.test(navigator.userAgent) ) ? ad_units.android : ad_units.ios;
        
        window.plugins.AdMob.setOptions({
            publisherId: admobid.banner,
            interstitialAdId: admobid.interstitial,
            adSize: window.plugins.AdMob.AD_SIZE.SMART_BANNER,  //use SMART_BANNER, BANNER, IAB_MRECT, IAB_BANNER, IAB_LEADERBOARD
            bannerAtTop: false, // set to true, to put banner at top
            overlap: true, // banner will overlap webview
            offsetTopBar: false, // set to true to avoid ios7 status bar overlap
            isTesting: true, // receiving test ad
            autoShow: isShowGooglePopup // auto show interstitial ad when loaded
        });
        
        registerAdEvents();
        
        setTimeout(function(){
            showInterstitialFunc();
            showBannerFunc();
        }, 500);
    } else {
//        alert( 'admob plugin not ready' );
    }
}
//functions to allow you to know when ads are shown, etc.
function registerAdEvents() {
    document.addEventListener('onReceiveAd', function(){
        isAdmobOpen = true;
//        alert('onReceiveAd');
    });
    document.addEventListener('onFailedToReceiveAd', function(data){
        isAdmobOpen = false;
//        alert('onFailedToReceiveAd\n ' + JSON.stringify(data));
    });
    document.addEventListener('onPresentAd', function(){
        closeBannerFunc();
        isAdmobOpen = false;
//        alert('onPresentAd');
    });
    document.addEventListener('onDismissAd', function(){
//        alert('onDismissAd');
    });
    document.addEventListener('onLeaveToAd', function(){
//        alert('onLeaveToAd');
    });
    document.addEventListener('onReceiveInterstitialAd', function(){
//        alert('onReceiveInterstitialAd');
    });
    document.addEventListener('onPresentInterstitialAd', function(){
//        alert('onPresentInterstitialAd');
    });
    document.addEventListener('onDismissInterstitialAd', function(){
//        alert('onDismissInterstitialAd');
    });
}

//display the banner
function showBannerFunc(){
    window.plugins.AdMob.createBannerView();
}
//display the interstitial
function showInterstitialFunc(){
    window.plugins.AdMob.createInterstitialView();  //get the interstitials ready to be shown and show when it's loaded.
    window.plugins.AdMob.requestInterstitialAd();
}

//close banner
function closeBannerFunc(){
    window.plugins.AdMob.destroyBannerView();
}


/** angular bootstrap   */
if(window.cordova){
    document.addEventListener('deviceready', function() { 
        angular.bootstrap(document, ['giftbox']);
    }, false);
}else{
    setTimeout(function(){
        angular.bootstrap(document, ['giftbox']);
    });
};







