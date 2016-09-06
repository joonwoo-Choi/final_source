(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('uploadBtn', [function(){
		return {
			restrict: 'A',
			templateUrl: 'views/dialog/upload/uploadBtn.html',
            controller: 'uploadBtnCtrl',
			replace: true
		};
	}]);
})(angular);