(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('navigatorCtrl', ['$scope', '$window', '$q', '$timeout', '$mdMenu', '$state', 'trackerSvc', 'authSvc', 'restApiSvc', 'dialogSvc', 'timeSvc', function ($scope, $window, $q, $timeout, $mdMenu, $state, trackerSvc, authSvc, restApiSvc, dialogSvc, timeSvc) {
        
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
        $scope.searchOn = false;
        $scope.searched = false;
        $scope.isTagMore = false;
        $scope.keyword = '';
        $scope.searchedKeyword = '';
        $scope.searchHistories = [];
        $scope.showTags = [];
        $scope.searchedLists = {
            tags: [],
            works: [],
            users: []
        };
        
        $scope.logoHandler = function(){
            if($state.current.name.indexOf('main') > -1){
                $window.location.reload();
            }else{
                $state.go('main', {}, {reload: true});
            }
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
                }
                
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
			}
		};
        $scope.getNotipications = function(){
            $scope.notiPage++;
            var params = {
                page: $scope.notiPage,
                size: $scope.notiPageSize
            }
            restApiSvc.get(restApiSvc.apiPath.getNotis, params).then(
                function(res){
                    var tempLists = res.data.data.content;
                    tempLists = $scope.setNotipications(tempLists);
                    $scope.notiLists = $scope.notiLists.concat(tempLists);
                },function(res){

                }
            );
        }
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
                    }
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
                    }
                }
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
            }
        }
        $scope.goWork = function(type, id, confirmed, notiId){
            trackerSvc.eventTrack('WORK DETAIL', {category:'NOTIFICATION'});
            if(confirmed){
                $state.go('detail', {artworkType:type, id:id});
            }else{
                $state.go('detail', {artworkType:type, id:id});
                $scope.setConfirmedNotiId(notiId);
            }
        }
        $scope.setConfirmedNotiId = function(notiId){
            /** set notification confirmed  */
            restApiSvc.get(restApiSvc.apiPath.setViewedNoti(notiId)).then(
                function(res){
                    $scope.notiLists = res.data.data.content;
                    $scope.setNotipications($scope.notiLists);
                },function(res){

                }
            );
        }
        
        $scope.searchKeydown = function(e, keyword){
            if(e.keyCode == 13){
                $scope.searchKeyword(keyword);
            }
        };
        $scope.searchHistoryKeyword = function(keyword){
            trackerSvc.eventTrack('SEARCH KEYWORD', {category:'SEARCH HISTORY'});
            $scope.searchKeyword(keyword);
        }
        $scope.searchKeyword = function(keyword){
            if(keyword <= 0) return;
            $scope.keyword = keyword;
            
            var apiPath = '';
            var params = {};
            var isSearchTag = Boolean(keyword.indexOf('#') > -1);
            if(isSearchTag){
                apiPath = restApiSvc.apiPath.searchTag;
                params = {
                    word: keyword
//                    page: 1,
//                    size: 20
                };
            }else{
                apiPath = restApiSvc.apiPath.search;
                params = {
                    word: keyword,
                    tagSize: 20,
                    personSize: 3,
                    titleSize: 3
                };
            }
            restApiSvc.get(apiPath, params).then(
                function(res){
                    trackerSvc.pageTrack('SEARCH RESULT');
                    
                    if($scope.searchedKeyword.length > 0 && ($scope.searchedLists.tags.length > 0 || $scope.searchedLists.users.length > 0 || $scope.searchedLists.works.length > 0)){
                        $timeout(function(){
                            $scope.$broadcast('masonry.reload');
                        });
                    }
                    
                    $scope.searched = true;
//                    $scope.keyword = '';
                    $scope.searchedKeyword = keyword;
                    if(isSearchTag){
                        $scope.isTagMore = true;
                        $scope.searchedLists.tags = res.data.data.content;
                        $scope.searchedLists.works.length = 0;
                        $scope.searchedLists.users.length = 0;
                        $scope.showTags = $scope.searchedLists.tags;
                    }else{
                        $scope.isTagMore = false;
                        $scope.searchedLists = res.data.data;
                        $scope.showTags = $scope.searchedLists.tags.slice(0, 3);
                    }
                    
                    if($scope.isLogin){
                        restApiSvc.get(restApiSvc.apiPath.searchHistories).then(
                            function(res){
                                $scope.searchHistories = res.data.data;
                            },function(res, status){

                            }
                        );
                    }
                },function(res, status){
                    
                }
            );
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
        $scope.btnMoreHandler = function(type){
            var title = '',
                getType = '';
            switch (type){
                case 'person' :
                    trackerSvc.eventTrack('PERSON (MORE)', {category:'PERSON (MORE)'});
                    $scope.keyword = '';
                    $scope.searchOff();
                    title = 'Search > Person ' + '"' + $scope.searchedKeyword + '"';
                    getType = 'search';
                    dialogSvc.openPeopleLists({title: title, type: getType, searchData: $scope.searchedKeyword});
                    break;
                case 'tag' :
                    $scope.isTagMore = !$scope.isTagMore;
                    break;
                case 'title' :
                    trackerSvc.eventTrack('TITLE (MORE)', {category:'TITLE (MORE)'});
                    $scope.keyword = '';
                    $scope.searchOff();
                    title = 'Search > Title ' + '"' + $scope.searchedKeyword + '"';
                    getType = 'title';
                    dialogSvc.openSearchedList({title: title, type: getType, searchData: $scope.searchedKeyword});
                    break;
            }
        }
        $scope.searchTag = function(tag){
            trackerSvc.eventTrack('TAG_WORK LIST', {category:'TAG_WORK LIST'});
            $scope.keyword = '';
            $scope.searchOff();
            var title = 'Search > ' + tag,
                getType = 'tag';
                dialogSvc.openSearchedList({title: title, type: getType, searchData: tag});
        }
        $scope.searchOff = function(){
            $timeout(function(){
                $('.header .search')[0].blur();
                $scope.searchOn = false;
                $scope.isTagMore = false;
            });
        }
        
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
            }
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
            }
        };
        
        $scope.scrollHandler = function(e){
//            if(!$scope.isMobile) return;
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
                }
            });
        }
        
        $scope.$watch('searchOn', function(newVal, oldVal, scope){
            if($scope.searched && newVal){
                $timeout(function(){
                    $scope.$broadcast('masonry.reload');
                }, 450);
            }
        });
        
        $scope.$watch('keyword', function(newVal, oldVal){
            if(newVal.length > 0 && newVal == $scope.searchedKeyword){
                $scope.searched = true;
            }else{
                $scope.searched = false;
            }
        });
        
        $scope.$watch('isTagMore', function(newVal, oldVal){
            if($scope.searchedLists.tags){
                if(newVal){
                    $scope.showTags = $scope.searchedLists.tags;
                }else{
                    $scope.showTags = $scope.searchedLists.tags.slice(0,3);
                }
            }
        });
        
        $scope.$on(authSvc.event.userInfoChanged, function(event, userInfo) {
            $scope.loginSetting(userInfo);
        });
        
        $scope.$on('$stateChangeSuccess', function(e, to, params){
            $scope.keyword = '';
            $scope.searched = false;
            $scope.searchOff();
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
//        $scope.loginSetting(authSvc.getUserInfo());
        if(authSvc.isLogin()){
            /** user info reload    */
            var loginInfo = authSvc.getUserInfo().loginInfo;
            if(loginInfo != null && loginInfo != undefined){
                var apiPath = restApiSvc.apiPath.login;
                var params = {};
                var contentType = undefined;
                if(loginInfo.accessFbToken.length <= 0){
                    params.email = loginInfo.email;
                    params.password = loginInfo.password;
                }else{
                    contentType = 'form';
                    apiPath = restApiSvc.apiPath.fbLogin;
                    var profile = {
                            email: loginInfo.email,
                            userId: loginInfo.fbId,
                            username: loginInfo.fbName,
                            accessToken: loginInfo.accessFbToken
                        }
                    profile = restApiSvc.jsonToString(profile);
                    params.profile = profile;
                    params = restApiSvc.jsonToForm(params);
                }
                restApiSvc.post(apiPath, params, contentType).then(
                    function(res){
                        var userInfo = res.data.data;
                        userInfo.loginInfo = loginInfo;
                        authSvc.setUserInfo(userInfo);
                    },function(res){
                        authSvc.removeData();
                    }
                );
            }else{
                authSvc.removeData();
            }
        }
        
    }]);

})(angular);
