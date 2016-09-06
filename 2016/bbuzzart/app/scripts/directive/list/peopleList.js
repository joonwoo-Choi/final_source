(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('peopleList', ['$rootScope', '$timeout', '$state', 'trackerSvc', 'authSvc', 'dialogSvc', 'restApiSvc', 'timeSvc', 'imgLoadSvc', 'blockUI', function($rootScope, $timeout, $state, trackerSvc, authSvc, dialogSvc, restApiSvc, timeSvc, imgLoadSvc, blockUI){
		return {
			restrict: 'A',
			templateUrl: 'views/list/peopleList.html',
            scope: true,
			replace: true,
            link: function($scope, iElm, iAttrs){
                
                $scope.isLogin = authSvc.isLogin();
                $scope.isMobile = $rootScope.isMobile;
                $scope.scrollbarsConfig = {
                    axis: 'x'
                }
                $scope.myId = null;
                $scope.profileThumbnailUrl = '/images/img_profile_default.png';
                $scope.worksThumbnailUrl = [];
                
                $scope.followHandler = function(listItem){
                    if(listItem.isMe) return;
                    if(authSvc.isLogin()){
                        blockUI.start();
                        if(listItem.followed){
                            restApiSvc.delete(restApiSvc.apiPath.unfollow($scope.myId, listItem.id)).then(
                                function(res){
                                    blockUI.stop();
                                    if(res.data.success){
                                        listItem.followed = !listItem.followed;
                                        listItem.tooltipTitle = 'FOLLOW';
                                    }
                                },function(res, status){
                                    blockUI.stop();
                                }
                            );
                        }else{
                            restApiSvc.post(restApiSvc.apiPath.follow($scope.myId, listItem.id)).then(
                                function(res){
                                    blockUI.stop();
                                    if(res.data.success){
                                        $scope.sendTrackFollow();
                                        listItem.followed = !listItem.followed;
                                        listItem.tooltipTitle = 'UNFOLLOW';
                                    }
                                },function(res, status){
                                    blockUI.stop();
                                }
                            );
                        }
                    }else{
                        dialogSvc.openAccount();
                    }
                }
                
                $scope.sendTrackProfile = function(){
                    $scope.sendTrack('PROFILE');
                }
                $scope.sendTrackFollow = function(){
                    $scope.sendTrack('FOLLOW');
                }
                $scope.sendTrackDetail = function(){
                    $scope.sendTrack('WORK DETAIL');
                }
                $scope.sendTrack = function(action){
                    if($scope.dialogType != undefined){
                        switch($scope.dialogType){
                            case 'following' :
                                trackerSvc.eventTrack(action, {category:'FOLLOWING'});
                                break;
                            case 'followers' :
                                trackerSvc.eventTrack(action, {category:'FOLLOWERS'});
                                break;
                            case 'search' :
                                trackerSvc.eventTrack(action, {category:'PERSON (MORE)'});
                                break;
                        }
                    }else if($scope.searchOn){
                        trackerSvc.eventTrack(action, {category:'SEARCH RESULT'});
                    }else{
                        switch($state.current.name){
                            case 'my-feeds' :
                                trackerSvc.eventTrack(action, {category:'HOT BUZZLER'});
                                break;
                        }
                    }
                }
                
                $scope.workListsResize = function(idx){
                    $timeout(function(){
                        var target = iElm.find('.work-thumbnail')[idx];
                        var imgWidth = target.naturalWidth;
                        var imgHeight = target.naturalHeight;
                        var currWidth;
                        var currHeight;
                        if(imgWidth > imgHeight){
                            angular.element(target).css({
                                width: 'auto',
                                height: '100%'
                            });
                            currWidth = angular.element(target).width();
                            currHeight = angular.element(target).height();
                            angular.element(target).css({
                                'margin-left': (currHeight-currWidth)/2+'px'
                            });
                        }else{
                            angular.element(target).css({
                                width: '100%',
                                height: 'auto'
                            });
                            currWidth = angular.element(target).width();
                            currHeight = angular.element(target).height();
                            angular.element(target).css({
                                'margin-top': (currWidth-currHeight)/2+'px'
                            });
                        }
                    });
                }
                
//                $scope.$watch(function(){
//                    return iElm.width();
//                }, function(newVal, oldVal){
//                    if(oldVal == 0 && newVal > 0){
//                        var worksLength = iElm.find('.work-thumbnail').length;
//                        if(worksLength > 0){
//                            for(var i=0; i < iElm.find('.work-thumbnail').length; i ++){
//                                $scope.workListsResize(i);
//                            }
//                        }
//                    }
//                });
                
                /** initialize  */
                $timeout(function(){
                    if($scope.isLogin){
                        $scope.myId = authSvc.getUserInfo().id;
                        if($scope.myId == $scope.listItem.id){
                            $scope.listItem.isMe = true;
                        }
                    }else{
                        $scope.listItem.isMe = false;
                    }
                    if(!$scope.listItem.isMe){
                        if($scope.listItem.followed){
                            $scope.listItem.tooltipTitle = 'UNFOLLOW';
                        }else{
                            $scope.listItem.tooltipTitle = 'FOLLOW';
                        }
                    }

                    if($scope.isMobile){
                        iElm.find('.works-scroll-wrap').mCustomScrollbar("destroy");
                    }
                });
                
                if($scope.listItem.thumbnail != null){
                    imgLoadSvc.load($scope.listItem.thumbnail, function(src){
                        $timeout(function(){
                            $scope.profileThumbnailUrl = src;
                        });
                    });
                }
                
                if($scope.listItem.works.length > 0){
                    angular.forEach($scope.listItem.works, function(val, idx){
                        $scope.worksThumbnailUrl[idx] = '/images/thumbnail_default_img.png';
                        imgLoadSvc.load(val.attachments[0].thumbnail.small, function(src){
                            $timeout(function(){
                                $scope.worksThumbnailUrl[idx] = src;
                                $scope.workListsResize(idx);
                            });
                        });
                    });
                }
            }
		};
	}]);
})(angular);