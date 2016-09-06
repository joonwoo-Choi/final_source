(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('artworkList', ['$timeout', '$state', 'trackerSvc', 'authSvc', 'dialogSvc', 'restApiSvc', 'imgLoadSvc', 'blockUI', function($timeout, $state, trackerSvc, authSvc, dialogSvc, restApiSvc, imgLoadSvc, blockUI){
		return {
			restrict: 'A',
			templateUrl: 'views/list/artworkList.html',
            scope: true,
			replace: true,
            link: function($scope, iElm, iAttrs){
                
                $scope.thumbnailUrl = '/images/thumbnail_default_img.png';
                $scope.loadTimeout = null;
                
                $scope.likeThis = function(liked, workId){
                    if(authSvc.isLogin()){
                        blockUI.start();
                        if(liked){
                            restApiSvc.delete(restApiSvc.apiPath.unLikeActivity(workId)).then(
                                function(res){
                                    blockUI.stop();
                                    if(res.data.success){
                                        $scope.listItem.liked = !$scope.listItem.liked;
                                    }
                                },function(res, status){
                                    blockUI.stop();
                                }
                            );
                        }else{
                            restApiSvc.post(restApiSvc.apiPath.likeActivity(workId)).then(
                                function(res){
                                    blockUI.stop();
                                    if(res.data.success){
                                        $scope.listItem.liked = !$scope.listItem.liked;
                                    }
                                },function(res, status){
                                    blockUI.stop();
                                }
                            );
                        }
//                        $scope.putCache();
                    }else{
                        dialogSvc.openAccount();
                    }
                }
                
                $scope.sendTrack = function(){
                    if($scope.dialogType != undefined){
                        switch($scope.dialogType){
                            case 'keyword' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'WORK LIST'});
                                break;
                            case 'tag' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'TAG_WORK LIST'});
                                break;
                            case 'title' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'TITLE (MORE)'});
                                break;
                        }
                    }else if($scope.searchOn){
                        trackerSvc.eventTrack('WORK DETAIL', {category:'SEARCH RESULT'});
                    }else{
                        switch($state.current.name){
                            case 'main.discover' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'DISCOVER'});
                                break;
                            case 'main.show' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'SHOW'});
                                break;
                            case 'profile.bookmarks' :
                                trackerSvc.eventTrack('WORK DETAIL', {category:'BOOKMARK'});
                                break;
                        }
                    }
                }
                
                $scope.selectWork = function(listItem){
                    var tempList = {
                        id: listItem.id,
                        thumbnail: listItem.attachments[0].thumbnail.small
                    };
                    if(!listItem.selected){
                        /** 10개 이상 선택시 리턴   */
                        if($scope.participationWorkIds.length >= 10) return;
                        listItem.selected = !listItem.selected;
                        $scope.participationWorkIds.push(tempList);
                    }else{
                        listItem.selected = !listItem.selected;
                        angular.forEach($scope.participationWorkIds, function(val, idx){
                            if(val.id == tempList.id){
                                $scope.participationWorkIds.splice(idx, 1);
                            };
                        });
                    };
                }
                
                $scope.loadTimeout = $timeout(function(){
                    $scope.thumbnailUrl = $scope.listItem.attachments[0].thumbnail.small;
                }, 10000);
                
                $timeout(function(){
                    iElm.css({opacity: 1});
                });
                imgLoadSvc.load($scope.listItem.attachments[0].thumbnail.small, function(src){
                    $timeout.cancel($scope.loadTimeout);
                    $scope.loadTimeout = null;
                    $timeout(function(){
                        $scope.thumbnailUrl = src;
                    }, 500);
                });
                
                if($scope.listItem.type == 'WORK_WRITING'){
                    $scope.$watch(function(){
                        return iElm.find('.thumb-wrap').height();
                    }, function(newVal, oldVal){
                            var lineHeight = iElm.find('.pre-mask pre').css('line-height').split('px')[0];
                            var maxHeight = Math.floor((newVal/2)/lineHeight) * lineHeight;
                            iElm.find('.pre-mask').css({
                                'max-height': maxHeight
                            })
                    });
                }
                
            }
		};
	}]);
})(angular);