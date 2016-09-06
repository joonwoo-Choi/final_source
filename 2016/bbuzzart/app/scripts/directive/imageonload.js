(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('imageonload', [function(){
		return {
			restrict: 'A',
            link: function(scope, element, attrs) {
                element.bind('load', function() {
                    scope.$apply(attrs.imageonload);
                });
            }
		};
	}]);
})(angular);