(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('navigatorView', [function(){
		return {
			restrict: 'A',
			templateUrl: 'views/common/navigator.html',
            controller: 'navigatorCtrl',
			replace: true
		};
	}]);
})(angular);