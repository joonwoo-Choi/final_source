(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('feedList', ['$timeout', '$state', 'trackerSvc', 'authSvc', 'dialogSvc', 'restApiSvc', 'timeSvc', 'imgLoadSvc', 'blockUI', function($timeout, $state, trackerSvc, authSvc, dialogSvc, restApiSvc, timeSvc, imgLoadSvc, blockUI){
		return {
			restrict: 'A',
			templateUrl: 'views/list/feedList.html',
            scope: true,
			replace: true,
            link: function($scope, iElm, iAttrs){
                
                $scope.thumbnailUrl = '/images/thumbnail_default_img.png';
                $scope.loadTimeout = null;
                
                if($scope.listItem.work == null || $scope.listItem.work == undefined){
                    $scope.listItem.work = $scope.listItem;
                }
                
                $scope.likeThis = function(liked, workId){
                    if(authSvc.isLogin()){
                        blockUI.start();
                        if(liked){
                            restApiSvc.delete(restApiSvc.apiPath.unLikeActivity(workId)).then(
                                function(res){
                                    blockUI.stop();
                                    if(res.data.success){
                                        $scope.listItem.work.liked = !$scope.listItem.work.liked;
                                        $scope.listItem.work.likeCount--;
                                        $scope.setListItem();
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
                                        $scope.sendTrackWork('LIKE');
                                        $scope.listItem.work.liked = !$scope.listItem.work.liked;
                                        $scope.listItem.work.likeCount++;
                                        $scope.setListItem();
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
                
                $scope.openLikedPeopleLists = function(workId){
                    if($scope.listItem.work.likeCount <= 0) return;
                    $scope.sendTrackWork('LIKE COUNT');
                    var title = 'PEOPLE LIKE THIS',
                        getType = 'like';
                    dialogSvc.openPeopleLists({title: title, type: getType, searchData: workId});
                }
                
                $scope.sendTrackFeedback = function(action){
                    var category = 'FEED_FEEDBACK';
                    trackerSvc.eventTrack(action, {category:category});
                }
                $scope.sendTrackWork = function(action){
                    var category = '';
                    switch($state.current.name){
                        case 'my-feeds' :
                            category = 'FEED_WORK';
                            break;
                        case 'profile.works' :
                            category = 'WORK';
                            break;
                    }
                    trackerSvc.eventTrack(action, {category:category});
                }
                
                $scope.setListItem = function(){
                    if($scope.listItem.type == 'FEEDBACK'){
                        $scope.listItem.createdBy = $scope.listItem.feedback.createdBy;
                        $scope.listItem.convertedDate = timeSvc.getDate($scope.listItem.feedback.createdDate);

                        $scope.listItem.feedback.convertedMessage = '"' + $scope.listItem.feedback.message + '"';
                        var reg = /{{(\d+):(.*?)}}/ig;
                        var mentions = $scope.listItem.feedback.convertedMessage.match(reg);
                        if(mentions != null){
                            angular.forEach(mentions, function(mentionVal, idx){
                                var id = mentionVal.replace(reg, '$1');
                                var name = '@' + mentionVal.replace(reg, '$2');
                                $scope.listItem.feedback.convertedMessage = $scope.listItem.feedback.convertedMessage.replace(mentionVal, name);
                            });
                        }
                    }else{
                        $scope.listItem.createdBy = $scope.listItem.work.createdBy;
                        $scope.listItem.convertedDate = timeSvc.getDate($scope.listItem.work.createdDate);
                    }
                    /** work like & feed count setting  */
                    $scope.listItem.work.convertedLikeCount = parseInt($scope.listItem.work.likeCount);
                    $scope.listItem.work.convertedFeedbackCount = parseInt($scope.listItem.work.feedbackCount);
                    if($scope.listItem.work.convertedLikeCount > 999) {
                        $scope.listItem.work.convertedLikeCount = '999+';
                    }
                    if($scope.listItem.work.convertedFeedbackCount > 999) {
                        $scope.listItem.work.convertedFeedbackCount = '999+';
                    }
                }
                
                $scope.loadTimeout = $timeout(function(){
                    $scope.thumbnailUrl = $scope.listItem.work.attachments[0].thumbnail.medium;
                }, 10000);
                
                $timeout(function(){
                    iElm.css({opacity: 1});
                });
                imgLoadSvc.load($scope.listItem.work.attachments[0].thumbnail.medium, function(src){
                    $timeout.cancel($scope.loadTimeout);
                    $scope.loadTimeout = null;
                    $timeout(function(){
                        $scope.thumbnailUrl = src;
                    }, 500);
                });
                
                $scope.$on('set-myfeeds-list', function(){
                    $timeout(function(){
                        $scope.setListItem();
                    });
                });
                
                if($scope.listItem.work.type == 'WORK_WRITING'){
                    $scope.$watch(function(){
                        return iElm.find('.thumb-wrap').height();
                    }, function(newVal, oldVal){
                        if(iElm.find('.pre-mask pre').css('line-height') == undefined) return;
                        
                        var lineHeight = iElm.find('.pre-mask pre').css('line-height').split('px')[0];
                        var maxHeight = Math.floor((newVal/2)/lineHeight) * lineHeight;
                        iElm.find('.pre-mask').css({
                            'max-height': maxHeight
                        });
                    });
                }
                $scope.setListItem();
                
            }
		};
	}]);
})(angular);