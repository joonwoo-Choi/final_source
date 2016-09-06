(function (angular) {
	'use strict';
	var BBuzzArtApp = angular.module('BBuzzArtApp');

	BBuzzArtApp.directive('confirmDialog', [function(){
		return {
			restrict: 'A',
            scope: true,
			templateUrl: 'views/dialog/confirm/confirm.html',
            link: function (scope, element, attrs) {
                var params = scope.$eval(attrs.confirmDialog);
                scope.type = params.type;
                
                scope.confirm = function(answer){
                    scope.confirmDialogCallback(answer);
                }
            }
		};
	}]);
})(angular);