(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('tagList', ['$timeout', 'trackerSvc', 'dialogSvc', function($timeout, trackerSvc, dialogSvc){
		return {
			restrict: 'A',
			templateUrl: 'views/list/tagList.html',
            scope: true,
			replace: true,
            link: function($scope, iElm, iAttrs){
                
                $scope.bgColorList = ['#fff9fd', '#f5fff1', '#fff', '#f4ffff', '#f8f6ff', '#f8f6ff', '#fff', '#fff9fd', '#fff', '#f5fff1', '#fff', '#f4ffff', '#fff', '#f8f6ff', '#fff9fd', '#f5fff1', '#f8f6ff', '#fff9fd', '#fff', '#f4ffff'];
                $scope.bgColor = $scope.bgColorList[$scope.$index%20];
                
                $scope.searchTag = function(tag){
                    trackerSvc.eventTrack('TAG_WORK LIST', {category:'TAG_WORK LIST'});
                    var title = 'Search > ' + tag,
                        getType = 'tag';
                    dialogSvc.openSearchedList({title: title, type: getType, searchData: tag});
                };
                
                $timeout(function(){
                    iElm.css({opacity: 1});
                });
                
            }
		};
	}]);
})(angular);