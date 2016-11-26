(function(angular){
    'use strict';
    
    angular.module('BBuzzArtApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ui.router', 'ngSanitize', 'ngTouch', 'ngMaterial', 'facebook', 'angulartics', 'angulartics.google.analytics', 'ngDialog', 'blockUI', 'ngScrollbars', 'ngFileUpload', 'ngCropper', 'uiGmapgoogle-maps', 'mentio']);
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    /** initialize  */
    BBuzzArtApp.config(function($locationProvider, FacebookProvider, $analyticsProvider, ngDialogProvider, blockUIConfig, ScrollBarsProvider){
        var loc = location.href.toLowerCase();
        if(loc.indexOf('localhost') < 0){
            $locationProvider.html5Mode(true);
        }
        FacebookProvider.init('837272499631458');
        
        /** set angulartics */
		$analyticsProvider.firstPageview(true);
        
        /** set ngDialog    */
        ngDialogProvider.setForceBodyReload(true);
	    ngDialogProvider.setDefaults({
	        showClose: false,
            ariaAuto: false,
            closeByDocument: true,
	        closeByEscape: true
	    });
        
        /** set blockUI */
        blockUIConfig.templateUrl = '/views/common/blockui.html';
        blockUIConfig.delay = 50;
        blockUIConfig.autoBlock = false;
        
        /** set custom scrollbars   */
        ScrollBarsProvider.defaults = {
            advanced:{
                updateOnContentResize: true
            },
            mouseWheel:{
                scrollAmount: 100,
                preventDefault: false,
                disableOver: []
            },
            contentTouchScroll: 25,
            documentTouchScroll: true,
            scrollInertia: 150,
            axis: 'y',
            theme: 'minimal-dark',
            autoHideScrollbar: true
        };
        
    });
    
    /** set router  */
    BBuzzArtApp.config(function ($stateProvider, $urlRouterProvider) {
        
        $stateProvider
            .state('main', {
                views: {
                    pageView: {
                        templateUrl: '/views/main/main.html',
                        controller: 'mainCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, setMetatagSvc, restApiSvc){
                        var defer = $q.defer();
                        
                        loadInitData();
                        
                        function loadInitData(){
                            restApiSvc.get(restApiSvc.apiPath.curationLists, {page:1,size:5}).then(
                                function(res){
                                    defer.resolve({
                                        mainCurationLists: res.data.data
                                    });
                                    
                                    setMetatagSvc.setMetatag({});
                                },function(res, status){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                },
                redirectTo: 'main.keyword'
            })
            .state('main.keyword', {
                url: '/',
                views: {
                    mainView: {
                        templateUrl: '/views/main/keyword.html',
                        controller: 'keywordCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, trackerSvc, restApiSvc){
                        trackerSvc.pageTrack('HOME_KEYWORD');
                        
                        var defer = $q.defer();
                        
                        loadInitData();
                        
                        function loadInitData(){
                            restApiSvc.get(restApiSvc.apiPath.keywordLists, {page:1,size:20}).then(
                                function(res){
                                    defer.resolve({
                                        mainKeywordLists: res.data.data.content
                                    });
                                },function(res, status){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('main.discover', {
                url: '/discover/:listType',
                views: {
                    mainView: {
                        templateUrl: '/views/main/discover.html',
                        controller: 'discoverCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, trackerSvc, restApiSvc){
                        trackerSvc.pageTrack('HOME_DISCOVER');
                        
                        if($stateParams.listType.length <= 0) $stateParams.listType = 'trending';
                        
                        var defer = $q.defer();
                        var isRecent = true;
                        
                        loadInitData()
                        
                        function loadInitData(){
                            var params = {
                                    page: 1,
                                    size: 20
                                };
                            if($stateParams.listType != 'recent'){
                                params.type = 'hot';
                                isRecent = false;
                            }
                            
                            restApiSvc.get(restApiSvc.apiPath.discoverLists, params).then(
                                function(res){
                                    defer.resolve({
                                        mainDiscoverLists: res.data.data.content,
                                        isRecent: isRecent
                                    });
                                },function(res, status){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('main.show', {
                url: '/show',
                views: {
                    mainView: {
                        templateUrl: '/views/main/show.html',
                        controller: 'showCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, trackerSvc, restApiSvc){
                        trackerSvc.pageTrack('HOME_SHOW');
                        var defer = $q.defer();
                        
                        loadInitData();
                        
                        function loadInitData(){
                            restApiSvc.get(restApiSvc.apiPath.showLists, {page:1,size:19}).then(
                                function(res){
                                    var showList = res.data.data.content;
                                    var bbuzzshowBanner = {
                                        title: 'BBuzzShow',
                                        url: '/bbuzzshow/gangnam/',
                                        type: 'BBUZZ_SHOW',
                                        attachments: [
                                            {
                                                thumbnail: {
                                                    small: '/images/img-bbuzzshow-banner.png'
                                                }
                                            }
                                        ]
                                    };
                                    showList.unshift(bbuzzshowBanner);
                                    defer.resolve({
                                        mainShowLists: showList
                                    });
                                },function(res, status){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('search', {
                url: '/search',
                params: {
                    word: ''
                },
                views: {
                    pageView: {
                        templateUrl: '/views/search/search.html',
                        controller: 'searchCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, restApiSvc){
                        var defer = $q.defer(),
                            params = {
                                word: $stateParams.word,
                                tagSize: 1,
                                personSize: 1,
                                titleSize: 1
                            };
                        
                        if($stateParams.word == ''){
                            defer.resolve({
                                    word: '',
                                    isPerson: false,
                                    isTag: false,
                                    isTitle: false
                                });
                        }else{
                            restApiSvc.get(restApiSvc.apiPath.search, params).then(
                                function(res){
                                    defer.resolve({
                                        word: $stateParams.word,
                                        isPerson: Boolean(res.data.data.users.length),
                                        isTag: Boolean(res.data.data.tags.length),
                                        isTitle: Boolean(res.data.data.works.length)
                                    });
                                },function(err){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('search.searched', {
                url: '/:tab/:word',
                views: {
                    searchView: {
                        templateUrl: '/views/search/searchedList.html',
                        controller: 'searchedResultList'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, restApiSvc){
                        
                        var defer = $q.defer(),
                            params = {
                                word: $stateParams.word, 
                                page: 1, 
                                size: 20
                            },
                            apiPath = '';
                        
                        if($stateParams.tab == 'no-result'){
                            defer.resolve({
                                tab: $stateParams.tab,
                                keyword: $stateParams.word,
                                lastPage: true,
                                searchedLength: 0,
                                searchLists: []
                            });
                        }else{
                            if($stateParams.tab == 'person'){
                                apiPath = restApiSvc.apiPath.searchPerson;
                            }else if($stateParams.tab == 'tag'){
                                apiPath = restApiSvc.apiPath.searchTag;
                            }else if($stateParams.tab == 'title'){
                                apiPath = restApiSvc.apiPath.searchTitle;
                            };
                            
                            restApiSvc.get(apiPath, params).then(
                                function(res){
                                    defer.resolve({
                                        tab: $stateParams.tab,
                                        keyword: $stateParams.word,
                                        lastPage: res.data.data.last,
                                        searchedLength: res.data.data.totalElements,
                                        searchLists: res.data.data.content
                                    });
                                },function(res, status){
                                    defer.resolve(null);
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('profile', {
                params: {
                    userId: null,
                },
                views: {
                    pageView: {
                        templateUrl: '/views/profile/profile.html',
                        controller: 'profileCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, setMetatagSvc, restApiSvc, blockUI, dialogSvc){
                        var defer = $q.defer(),
                            userId = parseInt($stateParams.userId);
                        
                        loadInitData();
                        
                        function loadInitData(){
                            restApiSvc.get(restApiSvc.apiPath.getProfile(userId)).then(
                                function(res){
                                    if(res.data.success){
                                        var profile = res.data.data
                                        defer.resolve({
                                            profile: profile
                                        });
                                        
                                        var params = {
                                                pageTitle:' | Profile' + ' - ' + profile.createdBy.username,
                                                metaTitle:profile.createdBy.username,
                                                metaDescription:profile.description,
                                                metaKeywords:profile.createdBy.username,
                                                metaAuthor:profile.createdBy.username
                                            };
                                        setMetatagSvc.setMetatag(params);
                                    }
                                },function(res, status){
                                    dialogSvc.confirmDialog(dialogSvc.confirmDialogType.nomember,function(answer){
                                        dialogSvc.closeConfirm();
                                        blockUI.stop();
                                        window.history.back();
                                    });
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                },
                redirectTo: 'profile.works'
            })
            .state('profile.works', {
                url: '/profile/:userId/works',
                views: {
                    profileView: {
                        templateUrl: '/views/profile/works.html',
                        controller: 'profileWorksCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, trackerSvc, restApiSvc){
                        trackerSvc.pageTrack('PROFILE_WORK');
                        
                        var defer = $q.defer(),
                            userId = $stateParams.userId,
                            params = {
                                target_id: userId, 
                                page: 1, 
                                size: 20
                            };
                        restApiSvc.get(restApiSvc.apiPath.getWorks(userId)).then(
                            function(res){
                                var contents = res.data.data? res.data.data.content : null;
                                defer.resolve({
                                    works: contents
                                });
                            },function(res, status){
                                defer.resolve(null);
                            }
                        );
                        
                        return defer.promise;
                    }
                }
            })
            .state('profile.bookmarks', {
                url: '/profile/:userId/bookmarks',
                views: {
                    profileView: {
                        templateUrl: '/views/profile/bookmarks.html',
                        controller: 'profileBookmarksCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, $stateParams, trackerSvc, restApiSvc){
                        trackerSvc.pageTrack('PROFILE_BOOKMARK');
                        
                        var defer = $q.defer(),
                            userId = $stateParams.userId,
                            params = {
                                target_id: userId, 
                                page: 1, 
                                size: 20
                            };
                        restApiSvc.get(restApiSvc.apiPath.getBookmarks(userId)).then(
                            function(res){
                                var contents = res.data.data? res.data.data.content : null;
                                defer.resolve({
                                    bookmarks: contents
                                });
                            },function(res, status){
                                defer.resolve(null);
                            }
                        );
                        
                        return defer.promise;
                    }
                }
            })
            .state('my-feeds', {
                url: '/myfeeds',
                views: {
                    pageView: {
                        templateUrl: '/views/myfeeds/myfeeds.html',
                        controller: 'myfeedsCtrl'
                    }
                },
                resolve:{
                    initData : function ($q, setMetatagSvc, authSvc, trackerSvc, restApiSvc, dialogSvc, blockUI){
                        trackerSvc.pageTrack('MY FEED');
                        
                        var defer = $q.defer(),
                            id = authSvc.isLogin() ? authSvc.getUserInfo().id : undefined;
                        
                        restApiSvc.get(restApiSvc.apiPath.getMyfeeds, {page:1,size:20}).then(
                            function(res){
                                defer.resolve({
                                    myFeedsLists: res.data.data.content
                                });
                                
                                var params = {
                                        pageTitle:' | My Feed',
                                        metaTitle:'My Feed'
                                    };
                                setMetatagSvc.setMetatag(params);
                            },function(res, status){
                                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.page,function(answer){
                                    dialogSvc.closeConfirm();
                                    blockUI.stop();
                                    window.history.back();
                                });
                            }
                        );
                        return defer.promise;
                    }
                }
            })
            .state('oldDetail', {
                cache: false,
                url: '/:artworkType/detail?id',
                onEnter: function($stateParams, $state, restApiSvc, dialogSvc){
                    var params = {
                            artworkType: $stateParams.artworkType,
                            id: $stateParams.id,
                        };
                    $state.go('detail', params, {reload: true});
                }
            })
            .state('detail', {
                url: '/:artworkType/detail/:id',
                params: {
                    inputFeed: null,
                },
                views: {
                    pageView: {
                        templateUrl: '/views/detail/detail.html',
                        controller: 'detailCtrl'
                    }
                },
                resolve:{
                    initData : function ($window, $q, $stateParams, setMetatagSvc, trackerSvc, restApiSvc, dialogSvc, blockUI){
                        var defer = $q.defer(),
                            id = $stateParams.id,
                            detailApiPath = restApiSvc.apiPath.getDetailImage(id);
                        
                        if($stateParams.artworkType == 'WORK_IMAGE' || 
                           $stateParams.artworkType == 'art'){
                            $stateParams.artworkType = 'art';
                            trackerSvc.pageTrack('IMAGE DETAIL');
                            detailApiPath = restApiSvc.apiPath.getDetailImage(id);
                            loadInitData();
                        }else if($stateParams.artworkType == 'WORK_VIDEO' || 
                                 $stateParams.artworkType == 'video'){
                            $stateParams.artworkType = 'video';
                            trackerSvc.pageTrack('VIDEO DETAIL');
                            detailApiPath = restApiSvc.apiPath.getDetailVideo(id);
                            loadInitData();
                        }else if($stateParams.artworkType == 'WORK_WRITING' || 
                                 $stateParams.artworkType == 'writing'){
                            $stateParams.artworkType = 'writing';
                            trackerSvc.pageTrack('WRITING DETAIL');
                            detailApiPath = restApiSvc.apiPath.getDetailWriting(id);
                            loadInitData();
                        }else if($stateParams.artworkType == 'WORK_SHOW' || 
                                 $stateParams.artworkType == 'show'){
                            $stateParams.artworkType = 'show';
                            trackerSvc.pageTrack('SHOW DETAIL');
                            detailApiPath = restApiSvc.apiPath.getDetailShow(id);
                            loadInitData();
                        };
                        
                        function loadInitData(){
                            $q.all([
                                restApiSvc.get(detailApiPath),
                                restApiSvc.get(restApiSvc.apiPath.getFeedback(id), {page:1, size:20})
                            ]).then(
                                function(res){
                                    var detailData = res[0].data.data;
                                    var feedbackLists = res[1].data.data.content;
                                    
                                    if(detailData != undefined){
                                        detailData.inputFeed = $stateParams.inputFeed;
                                        defer.resolve({
                                            detailData: detailData,
                                            feedbackLists: feedbackLists
                                        });
                                        var params = {
                                                pageTitle:' | ' + detailData.title + ' - ' + detailData.createdBy.username,
                                                metaTitle:detailData.title,
                                                metaDescription:detailData.note || detailData.abstractText || detailData.introduction,
                                                metaKeywords:detailData.tags.join().replace(/#/g, ''),
                                                metaAuthor:detailData.createdBy.username
                                            };
                                        setMetatagSvc.setMetatag(params);
                                    }
                                },function(res, status){
                                    dialogSvc.confirmDialog(dialogSvc.confirmDialogType.page,function(answer){
                                        dialogSvc.closeConfirm();
                                        blockUI.stop();
                                        window.history.back();
                                    });
                                }
                            );
                        };
                        
                        return defer.promise;
                    }
                }
            })
            .state('service', {
                cache: false,
                url: '/service',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                redirectTo: 'notice'
            })
            .state('notice', {
                cache: false,
                url: '/service/notice',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                onEnter: function(setMetatagSvc){
                    var params = {
                            pageTitle:' | Notice'
                        };
                    setMetatagSvc.setMetatag(params);
                }
            })
            .state('help', {
                cache: false,
                url: '/service/help',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                onEnter: function(setMetatagSvc){
                    var params = {
                            pageTitle:' | Help'
                        };
                    setMetatagSvc.setMetatag(params);
                }
            })
            .state('contactus', {
                cache: false,
                url: '/service/contactus',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                onEnter: function(setMetatagSvc){
                    var params = {
                            pageTitle:' | Contact us'
                        };
                    setMetatagSvc.setMetatag(params);
                }
            })
            .state('termsofuse', {
                cache: false,
                url: '/service/termsofuse',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                onEnter: function(setMetatagSvc){
                    var params = {
                            pageTitle:' | Terms of use'
                        };
                    setMetatagSvc.setMetatag(params);
                }
            })
            .state('privacypolicy', {
                cache: false,
                url: '/service/privacypolicy',
                views: {
                    pageView: {
                        templateUrl: '/views/service/service.html',
                        controller: 'serviceCtrl'
                    }
                },
                onEnter: function(setMetatagSvc){
                    var params = {
                            pageTitle:' | Privacy policy'
                        };
                    setMetatagSvc.setMetatag(params);
                }
            })
            .state('verificationEmail', {
                url: '/verification-email?email&token',
                onEnter: function($stateParams, $state, restApiSvc, dialogSvc){
                    var params = {
                            email: $stateParams.email,
                            token: $stateParams.token,
                        };
                    
                    restApiSvc.get(restApiSvc.apiPath.verificationEmail, params).then(
                        function(res){
                            dialogSvc.openAccount({type: 'verification'});
                        },function(res, status){
                            var errorMessage = res.data.message;
                            if(errorMessage == 'Confirmed E-mail.'){
                                alert(errorMessage);
                                $state.go('main', {}, {reload: true});
                            }else if(errorMessage == 'The URL Link sent by E-mail has expired.'){
                                dialogSvc.openAccount({type: 'expired', data: params});
                            }else{
                                alert(res.data.message);
                                $state.go('main', {}, {reload: true});
                            };
                        }
                    );
                }
            })
            .state('deleteEmail', {
                url: '/delete-email?email',
                onEnter: function($stateParams, dialogSvc){
                    var params = {
                            email: $stateParams.email
                        };
                    dialogSvc.openAccount({type: 'delete', data: params});
                }
            })
            .state('resetPassword', {
                url: '/reset-password?email&token',
                onEnter: function($stateParams, dialogSvc){
                    var params = {
                            email: $stateParams.email,
                            token: $stateParams.token
                        };
                    dialogSvc.openAccount({type: 'resetPassword', data: params});
                }
            });
        
        $urlRouterProvider.otherwise('/');
    });
        
    /** run */
    BBuzzArtApp.run(function($rootScope, $window, $timeout, $cookies, $http, $location, $mdMenu, $state, restApiSvc, dialogSvc, blockUI){
        /** api url */
        var loc = location.href.toLowerCase();
        if(loc.indexOf('http://bbuzzart.com') > -1 ||
           loc.indexOf('https://bbuzzart.com') > -1 ||
           loc.indexOf('http://www.bbuzzart.com') > -1 ||
           loc.indexOf('https://www.bbuzzart.com') > -1 ||
           loc.indexOf('http://pp3-bbuzzart.azurewebsites.net') > -1 ||
           loc.indexOf('https://pp3-bbuzzart.azurewebsites.net') > -1 ||
           loc.indexOf('http://pp3.bbuzzart.com') > -1 ||
           loc.indexOf('https://pp3.bbuzzart.com') > -1){
            restApiSvc.setBaseUrl('http://api3.bbuzzart.com');
        }else{
            restApiSvc.setBaseUrl('http://alpha4.api.bbuzzart.com');
        };
        
        /** context menu    */
        if(loc.indexOf('http://bbuzzart.com') > -1 ||
           loc.indexOf('https://bbuzzart.com') > -1 ||
           loc.indexOf('http://www.bbuzzart.com') > -1 ||
           loc.indexOf('https://www.bbuzzart.com') > -1){
            angular.element('body').attr({'oncontextmenu': 'return false'});
        }else{
            angular.element('body').attr({'oncontextmenu': 'return true'});
        };
        
        /** mobile check    */
        var ua = window.navigator.userAgent.toLowerCase();
        if( /android|iphone|ipad|ipod/.test(ua) ){
            $rootScope.isMobile = true;
            $('body, .wrap').css({'height': 'auto'});
        }else{
            $rootScope.isMobile = false;
        };
        
        /** cell phone check    */
        if( /android|iphone|ipod/.test(ua) && ua.indexOf('mobile') > -1 ){
            $rootScope.isCellPhone = true;
        }else{
            $rootScope.isCellPhone = false;
        };
        
        /** ie check    */
        if(ua.indexOf('trident') > -1){
            $rootScope.isIE = true;
        }else{
            $rootScope.isIE = false;
        };
        $rootScope.initSite = true;
        
        /** state event */
        $rootScope.$on('$locationChangeSuccess', function() {
            $rootScope.actualLocation = $location.path();
	    });

        $rootScope.$on('$stateChangeStart', function(e, to, params){
            $mdMenu.hide();
            dialogSvc.close();
            dialogSvc.closeConfirm();
            if(to.redirectTo){
                blockUI.stop();
                e.preventDefault();
                $state.go(to.redirectTo, params);
            }else{
                blockUI.stop();
                blockUI.start();
            };
        });
        
        $rootScope.$on('$stateChangeSuccess', function(){
            if($rootScope.actualState != undefined && $rootScope.actualState != $state.current.name){
                $rootScope.initSite = false;
            };
            
            blockUI.stop();
            $rootScope.actualState = $state.current.name;
        });
    });
    
})(angular);
