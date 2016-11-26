(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('navigatorView', [function(){
		return {
			restrict: 'A',
			templateUrl: 'views/common/navigator.html',
			replace: true,
            controller: function ($scope, $window, $q, $timeout, $mdMenu, $state, trackerSvc, authSvc, restApiSvc, dialogSvc, timeSvc) {

                $scope.isLogin = false;
                $scope.userInfo = null;
                $scope.userId = null;
                $scope.mobileView = false;
                $scope.sideNavLists = [
                    'ABOUT BBuzzArt',
                    'NOTICE',
                    'HELP',
                    'CHANGE PASSWORD',
                    'TERMS OF USE',
                    'PRIVACY POLICY',
                    'LOG IN / SIGN UP',
                    'MY PROFILE',
                    'MY FEED',
                    'LOG OUT'
                ];
                $scope.notiLists = [];
                $scope.notiPage = 0;
                $scope.notiPageSize = 20;
                $scope.isSearchHide = true;
                $scope.searchOn = false;
                $scope.keyword = '';
                $scope.searchHistories = [];

                $scope.logoHandler = function(){
                    if($state.current.name.indexOf('main') > -1){
                        $window.location.reload();
                    }else{
                        $state.go('main', {}, {reload: true});
                    };
                };

                $scope.popupLogin = function(){
                    $scope.searchOff();
                    dialogSvc.openAccount();
                };
                $scope.loginSetting = function (userInfo) {
                    if (userInfo) {
                        $scope.isLogin = true;
                        $scope.userInfo = userInfo;
                        $scope.userId = userInfo.id;
                        $scope.userInfo.convertedNotificationCount = $scope.userInfo.notificationCount;
                        if($scope.userInfo.notificationCount >= 100){
                            $scope.userInfo.convertedNotificationCount = '99+';
                        };

                        $scope.getNotipications();
                        restApiSvc.get(restApiSvc.apiPath.searchHistories, {size: 10}).then(
                            function(res){
                                $scope.searchHistories = res.data.data;
                            },function(res){

                            }
                        );
                    } else {
                        $scope.isLogin = false;
                        $scope.userInfo = null;
                        $scope.userId = null;
                        $scope.searchHistories.length = 0;
                    };
                };
                $scope.getNotipications = function(){
                    $scope.notiPage++;
                    var params = {
                        page: $scope.notiPage,
                        size: $scope.notiPageSize
                    };
                    restApiSvc.get(restApiSvc.apiPath.getNotis, params).then(
                        function(res){
                            var tempLists = res.data.data.content;
                            tempLists = $scope.setNotipications(tempLists);
                            $scope.notiLists = $scope.notiLists.concat(tempLists);
                        },function(res){

                        }
                    );
                };
                $scope.setNotipications = function(notiLists){
                    angular.forEach(notiLists, function(val, key){
                        if(val.type == 'BOOKMARK'){
                            val.typeText = 'bookmarked your work.';
                            val.createdBy = val.bookmark.createdBy;
                            val.convertedDate = timeSvc.getDate(val.bookmark.createdDate);
                            val.work = val.bookmark.work;
                        }else if(val.type == 'LIKE'){
                            val.typeText = 'liked your work.';
                            val.createdBy = val.like.createdBy;
                            val.work = val.like.work;
                            val.convertedDate = timeSvc.getDate(val.like.createdDate);
                        }else if(val.type == 'FEEDBACK'){
                            val.typeText = 'provided feedback your work.';
                            val.createdBy = val.feedback.createdBy;
                            val.convertedDate = timeSvc.getDate(val.feedback.createdDate);

                            val.feedback.convertedMessage = '"' + val.feedback.message + '"';
                            var reg = /{{(\d+):(.*?)}}/ig;
                            var mentions = val.feedback.convertedMessage.match(reg);
                            if(mentions != null){
                                angular.forEach(mentions, function(mentionVal, idx){
                                    var id = mentionVal.replace(reg, '$1');
                                    var name = '@' + mentionVal.replace(reg, '$2');
                                    val.feedback.convertedMessage = val.feedback.convertedMessage.replace(mentionVal, name);
                                });
                            };
                        }else if(val.type == 'FOLLOW'){
                            val.typeText = 'followed you.';
                            val.createdBy = val.sender;
                            val.convertedDate = timeSvc.getDate(val.createdDate);
                        }else if(val.type == 'MENTION'){
                            val.typeText = 'mentioned you in a feedback.';
                            val.createdBy = val.sender;
                            val.convertedDate = timeSvc.getDate(val.createdDate);

                            val.feedback.convertedMessage = '"' + val.feedback.message + '"';
                            var reg = /{{(\d+):(.*?)}}/ig;
                            var mentions = val.feedback.convertedMessage.match(reg);
                            if(mentions != null){
                                angular.forEach(mentions, function(mentionVal, idx){
                                    var id = mentionVal.replace(reg, '$1');
                                    var name = '@' + mentionVal.replace(reg, '$2');
                                    val.feedback.convertedMessage = val.feedback.convertedMessage.replace(mentionVal, name);
                                });
                            };
                        };
                    });
                    return notiLists;
                }
                $scope.logout = function () {
                    authSvc.removeData();
                    $scope.logoHandler();
                };

                $scope.goProfile = function(id, confirmed, notiId){
                    trackerSvc.eventTrack('PROFILE', {category:'NOTIFICATION'});
                    if(confirmed){
                        $state.go('profile', {userId:id});
                    }else{
                        $state.go('profile', {userId:id});
                        $scope.setConfirmedNotiId(notiId);
                    };
                };
                $scope.goWork = function(type, id, confirmed, notiId){
                    trackerSvc.eventTrack('WORK DETAIL', {category:'NOTIFICATION'});
                    if(confirmed){
                        $state.go('detail', {artworkType:type, id:id});
                    }else{
                        $state.go('detail', {artworkType:type, id:id});
                        $scope.setConfirmedNotiId(notiId);
                    };
                };
                $scope.setConfirmedNotiId = function(notiId){
                    /** set notification confirmed  */
                    restApiSvc.get(restApiSvc.apiPath.setViewedNoti(notiId)).then(
                        function(res){
                            $scope.notiLists = res.data.data.content;
                            $scope.setNotipications($scope.notiLists);
                        },function(res){

                        }
                    );
                };

                $scope.searchKeydown = function(e, keyword){
                    if(e.keyCode == 13){
                        $scope.searchKeyword(keyword);
                    };
                };
                $scope.searchHistoryKeyword = function(keyword){
                    trackerSvc.eventTrack('SEARCH KEYWORD', {category:'SEARCH HISTORY'});
                    $scope.searchKeyword(keyword);
                };
                $scope.searchKeyword = function(keyword){
                    if(keyword <= 0) return;
                    $scope.keyword = keyword;

                    var params = {};
                    /** 태그 검색   */
                    if($scope.keyword.indexOf('#') == 0){
                        while(keyword){
                            if(keyword.indexOf('#') > -1){
                                keyword = keyword.substr(1);
                            }else{
                                break;
                            };
                        };
                        params = {
                            word: keyword
                        };
                        restApiSvc.get(restApiSvc.apiPath.searchTag, params).then(
                            function(res){
                                var tagLength = res.data.data.content.length;
                                if(tagLength > 0){
                                    $state.go('search.searched', {word:keyword, tab:'tag'});
                                }else{
                                    $state.go('search.searched', {word:keyword, tab:'no-result'});
                                };

                                $scope.getSearchHistory();
                            },function(err){

                            }
                        );
                    }else{
                        /** 일반 검색   */
                        params = {
                            word: keyword,
                            tagSize: 1,
                            personSize: 1,
                            titleSize: 1
                        };
                        restApiSvc.get(restApiSvc.apiPath.search, params).then(
                            function(res){
                                var isPerson = Boolean(res.data.data.users.length);
                                var isTag = Boolean(res.data.data.tags.length);
                                var isTitle = Boolean(res.data.data.works.length);

                                if(isPerson){
                                    $state.go('search.searched', {word:keyword, tab:'person'});
                                }else if(!isPerson && isTag){
                                    $state.go('search.searched', {word:keyword, tab:'tag'});
                                }else if(!isPerson && isTag && isTitle){
                                    $state.go('search.searched', {word:keyword, tab:'title'});
                                }else{
                                    $state.go('search.searched', {word:keyword, tab:'no-result'});
                                };

                                $scope.getSearchHistory();
                            },function(err){

                            }
                        );
                    };
                };
                $scope.getSearchHistory = function(){
                    /** 서치 히스토리 가져오기    */
                    if($scope.isLogin){
                        restApiSvc.get(restApiSvc.apiPath.searchHistories).then(
                            function(res){
                                $scope.searchHistories = res.data.data;
                            },function(res, status){

                            }
                        );
                    };
                };
                $scope.removeKeywordHistory = function(idx){

                    var id = $scope.searchHistories[idx].id;
                    restApiSvc.post(restApiSvc.apiPath.removeHistory(id)).then(
                        function(res){
                            trackerSvc.eventTrack('DELETE', {category:'SEARCH HISTORY'});
                            $scope.searchHistories = res.data.data;
                        },function(res, status){

                        }
                    );
                };
                $scope.searchOff = function(){
                    $timeout(function(){
                        $('.header .search')[0].blur();
                        $scope.searchOn = false;
                    });
                };

                $scope.toggleNoti = function($mdOpenMenu, e){
                    trackerSvc.pageTrack('NOTIFICATION');

                    $scope.searchOff();
                    if($scope.userInfo.notificationCount > 0){
                        restApiSvc.post(restApiSvc.apiPath.resetNotiCount).then(
                            function(res){
                                var tempInfo = authSvc.getUserInfo();
                                tempInfo.notificationCount = res.data.data.notificationCount;
                                tempInfo.convertedNotificationCount = tempInfo.notificationCount;
                                authSvc.setUserInfo(tempInfo);
                                $mdOpenMenu(e);
                                /** notipication scroll handler */
                                $timeout(function(){
                                    $('.noti-scroll-contents').bind('scroll', $scope.scrollHandler);
                                });
                            },function(res, status){

                            }
                        );
                    }else{
                        $mdOpenMenu(e);
                        /** notipication scroll handler */
                        $timeout(function(){
                            $('.noti-scroll-contents').bind('scroll', $scope.scrollHandler);
                        });
                    };
                };

                $scope.toggleSideNav = function($mdOpenMenu, e){
                    $scope.searchOff();
                    $mdOpenMenu(e);
                };
                $scope.sideNavHandler = function(menu){
                    $mdMenu.hide();
                    switch(menu){
                        case 'LOG IN / SIGN UP' :
                            $scope.popupLogin();
                            break;
                        case 'MY PROFILE' :
                            $state.go('profile', {userId: authSvc.getUserInfo().id}, {reload: true});
                            break;
                        case 'MY FEED' :
                            $state.go('my-feeds', {}, {reload: true});
                            break;
                        case 'ABOUT BBuzzArt' :
                            trackerSvc.eventTrack('About BBuzzArt', {category:'ETC'});
                            window.open('/static/about_bbuzzart/', '_blank');
                            break;
                        case 'NOTICE' :
                            $state.go('notice', {}, {reload: true});
                            break;
                        case 'HELP' :
                            $state.go('help', {}, {reload: true});
                            break;
                        case 'CHANGE PASSWORD' :
                            dialogSvc.openAccount({type:'changePassword'});
                            break;
                        case 'TERMS OF USE' :
                            $state.go('termsofuse', {}, {reload: true});
                            break;
                        case 'PRIVACY POLICY' :
                            $state.go('privacypolicy', {}, {reload: true});
                            break;
                        case 'LOG OUT' :
                            trackerSvc.eventTrack('LOG OUT', {category:'LOG IN/OUT'});
                            $scope.logout();
                            break;
                    };
                };

                $scope.scrollHandler = function(e){
                    var scrollTop = e.target.scrollTop;
                    var maxScrollTop = e.target.scrollHeight - e.target.clientHeight;
                    var scrollPct = (scrollTop/maxScrollTop)*100;
                    $scope.onScroll(scrollTop, scrollPct);
                };
                $scope.onScroll = function(scrollTop, scrollPct){
                    scrollTop = Math.abs(scrollTop);

                    /** list load   */
                    if(scrollPct != undefined && scrollPct >= 95){
                        $scope.getNotipications();
                    };
                };

                $scope.checkMobileView = function(){
                    var wWidth = angular.element($window).width();

                    $timeout(function(){
                        if(wWidth > 767){
                            $scope.mobileView = false;
                        }else{
                            $scope.mobileView = true;
                        };
                    });
                };

                $scope.searchShowHide = function(bool){
                    $scope.isSearchHide = bool;
                };

                $scope.$on(authSvc.event.userInfoChanged, function(event, userInfo) {
                    $scope.loginSetting(userInfo);
                });

                $scope.$on('getSearchedHistories', function(e, to, params){
                    $scope.getSearchHistory();
                });

                $scope.$on('$stateChangeSuccess', function(e, to, params){
                    $scope.keyword = '';
                    $scope.searched = false;
                    $scope.searchOff();
                    if($state.current.name.indexOf('search') > -1){
                       $scope.searchShowHide(true);
                    }else{
                        $scope.searchShowHide(false);
                    };
                });

                angular.element($window).bind('resize', function(){
                    $scope.checkMobileView();
                });
                angular.element($window).bind("orientationchange", function() {
                    $scope.checkMobileView();
                });

                $('.container, .header-bg').click(function(e){
                    $scope.searchOff();
                });


                /** initialize  */
                $scope.checkMobileView();
                if(authSvc.isLogin()){
                    /** 저장된 auth로 로그인 후 최신정보 업데이트   */
                    var userInfo = authSvc.getUserInfo();
                    if(userInfo.auth != null){
                        restApiSvc.post(restApiSvc.apiPath.authLogin).then(
                            function(res){
                                var getData = res.data.data;
                                getData.auth = userInfo.auth;
                                authSvc.setUserInfo(getData);
                            },function(res){
                                authSvc.removeData();
                            }
                        );
                    }else{
                        authSvc.removeData();
                    };
                };

            }
		};
	}]);
})(angular);