(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('keywordList', ['$timeout', 'trackerSvc', 'authSvc', 'dialogSvc', 'restApiSvc', 'timeSvc', 'imgLoadSvc', 'blockUI', function($timeout, trackerSvc, authSvc, dialogSvc, restApiSvc, timeSvc, imgLoadSvc, blockUI){
		return {
			restrict: 'A',
			templateUrl: 'views/list/keywordList.html',
            scope: true,
			replace: true,
            link: function($scope, iElm, iAttrs){
                
                $scope.thumbnailUrl = '/images/thumbnail_default_img.png';
                $scope.loadTimeout = null;
                
                $scope.openSearchKeywordDialog = function(keyword){
                    trackerSvc.eventTrack('KEYWORD LIST', {category:'KEYWORD'});
                    var title = keyword;
                    var getType = 'keyword';
                    dialogSvc.openSearchedList({title: title, type: getType, searchData: keyword});
                };
                
                $scope.loadTimeout = $timeout(function(){
                    $scope.thumbnailUrl = $scope.listItem.work.attachments[0].thumbnail.small;
                }, 10000);
                
                $timeout(function(){
                    iElm.css({opacity: 1});
                });
                imgLoadSvc.load($scope.listItem.work.attachments[0].thumbnail.small, function(src){
                    $timeout.cancel($scope.loadTimeout);
                    $scope.loadTimeout = null;
                    $timeout(function(){
                        $scope.thumbnailUrl = src;
                    }, 500);
                });
                
            }
		};
	}]);
})(angular);