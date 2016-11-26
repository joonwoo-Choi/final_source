(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('profileCtrl', ['$rootScope', '$scope', '$window', '$timeout', '$state', 'initData', 'trackerSvc', 'restApiSvc', 'authSvc', 'convertFileSvc', 'cacheSvc', 'dialogSvc', 'blockUI', 'Upload', function ($rootScope, $scope, $window, $timeout, $state, initData, trackerSvc, restApiSvc, authSvc, convertFileSvc, cacheSvc, dialogSvc, blockUI, Upload) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.profile = initData.profile;
        $scope.isTabWorks = true;
        $scope.myId = null;
        $scope.isMe = false;
        $scope.isEdit = false;
        $scope.uploadInfo = {
            username: '',
            image: null,
            description: '',
            work: '',
            urls: [],
            inputAddUrls: 'http://'
        };
        $scope.activate = false;
        $scope.tooltipTitle = '';
        $scope.scrollTop = 0;
        $scope.scrollbarsConfig = {
            callbacks: {
                onScroll: function () {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                },
                whileScrolling: function() {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                }
            }
        };
        $scope.mobileScrollBarOptions = {
            advanced:{
                updateOnContentResize: true
            },
            mouseWheel:{
                scrollAmount: 100,
                disableOver: []
            },
            contentTouchScroll: 25,
            documentTouchScroll: true,
            scrollInertia: 150,
            axis: 'y',
            theme: 'minimal-dark',
            autoHideScrollbar: true,
            callbacks: {
                onScroll: function () {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                },
                whileScrolling: function() {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                }
            }
        };
        
        angular.element($window).bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.body.scrollTop;
            var maxScrollTop = e.target.body.scrollHeight - angular.element($window).height();
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        });
        $scope.onScroll = function(scrollTop, scrollPct){
            if(scrollPct != undefined && scrollPct >= 95){
                if($rootScope.actualState.indexOf('works') > -1){
                    $scope.$broadcast('worksListLoad', {userId:$scope.profile.createdBy.id});
                }else{
                    $scope.$broadcast('bookmarksListLoad', {userId:$scope.profile.createdBy.id});
                };
            };
        };
        
        $scope.openFollowDialog = function(getType){
            var title = getType == 'following' ? 'FOLLOWING' : 'FOLLOWERS';
            dialogSvc.openPeopleLists({title: title, type: getType, searchData: $scope.profile.createdBy.id});
        };
        
        $scope.followHandler = function(isFollowing){
            if($scope.isMe) return;
            if(authSvc.isLogin()){
                blockUI.start();
                if(isFollowing){
                    restApiSvc.delete(restApiSvc.apiPath.unfollow($scope.myId,$scope.profile.createdBy.id)).then(
                        function(res){
                            if(res.data.success){
                                $scope.reloadProfile();
                            };
                        },function(err){
                            blockUI.stop();
                        }
                    );
                }else{
                    restApiSvc.post(restApiSvc.apiPath.follow($scope.myId, $scope.profile.createdBy.id)).then(
                        function(res){
                            if(res.data.success){
                                trackerSvc.eventTrack('FOLLOW', {category:'PROFILE'});
                                $scope.reloadProfile();
                            }
                        },function(err){
                            blockUI.stop();
                        }
                    );
                }
            }else{
                dialogSvc.openAccount();
            };
        };
        
        $scope.reloadProfile = function(){
            restApiSvc.get(restApiSvc.apiPath.getProfile($scope.profile.createdBy.id)).then(
                function(res){
                    blockUI.stop();
                    $scope.profile = res.data.data;
                    $scope.setProfileData();
                },function(err){
                    blockUI.stop();
                }
            );
        };
        
        $scope.setProfileData = function(){
            if(authSvc.isLogin()){
                $scope.myId = authSvc.getUserInfo().id;
                if($scope.myId == $scope.profile.createdBy.id){
                    $scope.isMe = true;
                };
            }else{
                $scope.isMe = false;
            };
            
            $scope.profile.convertedFollowingCount = $scope.profile.followingCount;
            if(parseInt($scope.profile.convertedFollowingCount) > 999){
                $scope.profile.convertedFollowingCount = '999+';
            };
            $scope.profile.convertedFollowerCount = $scope.profile.followerCount;
            if(parseInt($scope.profile.convertedFollowerCount) > 999){
                $scope.profile.convertedFollowerCount = '999+';
            };
            
            if(!$scope.isMe){
                if($scope.profile.following){
                    $scope.tooltipTitle = 'UNFOLLOW';
                }else{
                    $scope.tooltipTitle = 'FOLLOW';
                };
            };
            
            if($scope.profile.urls != null){
                if($scope.profile.urls.length > 0){
                    $scope.profile.convertedUrls = $scope.profile.urls.split(',');
                    $scope.profile.convertedLinks = $scope.profile.urls.split(',');
                    angular.forEach($scope.profile.convertedLinks, function(val, idx){
                        if(val.indexOf('http://') < 0 && val.indexOf('https://') < 0){
                            $scope.profile.convertedLinks[idx] = '//' + val;
                        };
                    });
                };
            };
        };
        
        $scope.editProfile = function(){
            trackerSvc.eventTrack('EDIT', {category:'PROFILE'});
            $scope.isEdit = true;
            var tempProfile = JSON.parse(JSON.stringify($scope.profile));
            $scope.uploadInfo.username = tempProfile.createdBy.username;
            $scope.uploadInfo.profileImageFile = null;
            $scope.uploadInfo.description = tempProfile.description;
            $scope.uploadInfo.education = tempProfile.education;
            if($scope.profile.urls != null){
                if($scope.profile.urls.length > 0){
                    $scope.uploadInfo.urls = tempProfile.convertedUrls;
                };
            }else{
                $scope.uploadInfo.urls.length = 0;
            };
        };
        
        $scope.convertFile = function(file){
            convertFileSvc.convertFile(file, function(convertedFile){
                $scope.uploadInfo.convertedFile = convertedFile;
                if(convertedFile == null) $scope.uploadInfo.file = null;
            });
        };
        
        $scope.addUrl = function(){
            if($scope.uploadInfo.urls.length >= 5) return;
            
            if(!validateUrl($scope.uploadInfo.inputAddUrls)){
                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.validateUrl, function(answer){
                    dialogSvc.closeConfirm();
                });
                return;
            };
            
            $scope.uploadInfo.urls.push($scope.uploadInfo.inputAddUrls);
            $scope.uploadInfo.inputAddUrls = 'http://';
        };
        
        $scope.removeUrl = function($index){
            $scope.uploadInfo.urls.splice($index, 1);
        };
        
        $scope.editSave = function(){
            if(!$scope.activate) return;
            
            var params = {
                    profile: {
                        username: $scope.uploadInfo.username || '',
                        description: $scope.uploadInfo.description || '',
                        education: $scope.uploadInfo.education || '',
                        urls: $scope.uploadInfo.urls.join()
                    }
                };
            
            if($scope.uploadInfo.convertedFile){
                params.profileImageFile = $scope.uploadInfo.convertedFile;
            };
            
            params.profile = restApiSvc.jsonToString(params.profile);
            params = restApiSvc.jsonToForm(params);
            
            blockUI.start();
            restApiSvc.post(restApiSvc.apiPath.editProfile($scope.profile.createdBy.id), params, 'form').then(
                function(res){
                    blockUI.stop();
                    var tempInfo = authSvc.getUserInfo();
                    tempInfo.profileImage = res.data.data.createdBy.profileImage;
                    tempInfo.thumbnail = res.data.data.createdBy.thumbnail;
                    tempInfo.username = res.data.data.createdBy.username;
                    authSvc.setUserInfo(tempInfo);
                    $state.go('profile.works', {}, {reload: true});
                },function(err){
                    blockUI.stop();
                }
            );
        };
        
        $scope.editCancel = function(){
            $scope.isEdit = false;
        };
        
        $scope.checkMobileView = function(){
            var wWidth = angular.element($window).width();
            
            $timeout(function(){
                if(wWidth > 999){
                    $('.profile-wrap .user-profile').mCustomScrollbar("update");
                    $('.profile-wrap .profile-view-wrap').mCustomScrollbar("update");
                    $('.profile-wrap .profile-scroll-wrap').mCustomScrollbar("destroy");
                }else{
                    $('.profile-wrap .user-profile').mCustomScrollbar("disable");
                    $('.profile-wrap .profile-view-wrap').mCustomScrollbar("disable");
                    $('.profile-wrap .profile-scroll-wrap').mCustomScrollbar($scope.mobileScrollBarOptions);
                };
            });
        };
        
        $scope.$on('reloadProfile', function(){
            $scope.reloadProfile();
        });
        
        $scope.$watch(function(){
            return $state.current.name;
        }, function(newVal, oldVal){
            if(newVal.indexOf('works') > -1){
                $scope.isTabWorks = true;
            }else{
                $scope.isTabWorks = false;
            };
        });
        
        $scope.$watch('uploadInfo.username', function(newVal, oldVal){
            if(newVal.length > 0){
                $scope.activate = true;
            }else{
                $scope.activate = false;
            };
        });
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            $scope.checkMobileView();
        });
        
        $scope.$on('makeProfileViewScroll', function(e){
            if($('.profile-wrap .profile-view-wrap').hasClass('mCS_destroyed')){
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar($scope.scrollbarsConfig);
            };
        });
        
        /** initialize  */
        $scope.checkMobileView();
        if($scope.isMobile){
            $timeout(function(){
                $('.profile-wrap .user-profile').mCustomScrollbar("destroy");
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar("destroy");
            });
        };
        $scope.setProfileData();
        
    }]);
    
    function validateUrl(url){
        var pattern = /(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)/g;
        return pattern.test(url);
    }

})(angular);
