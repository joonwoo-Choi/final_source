

var weatherAppDirectives = angular.module('weatherApp.directives', []);

weatherAppDirectives.directive('globalEvents', ['$window', function($window) {
    return {
        link: function(scope, element, attrs) {
            angular.element($window).on('resize', function(e) {
                scope.$broadcast('globalEvt:resize');
            });
            angular.element($window).on('scroll', function(e) {
                scope.$broadcast('globalEvt:scroll');
            });
            angular.element($window).on('orientationchange', function(e) {
                scope.$broadcast('globalEvt:orientationchange');
            });
            angular.element($window).on('touchmove', function(e) {
                if($(".popup_sns").css("display") === "block"){
                    e.preventDefault();
                    return;
                }
                scope.$broadcast('globalEvt:touchmove');
            });
        }
    }
}])
.directive('ngHeader', [function() {
    return {
        name: 0,
        restrict: 'A',
        priority: 0,
//        template: '<div ng-controller="headerCtrl"><h1>ng-header</h1></div>',
        templateUrl: 'js/app/template/header.tmpl.html',
        replace: false,
        transclude: false,
        scope: false,
        link: function(scope, element, attrs) {
            
        }
    }
}])
.directive('ngContainer', [function() {
    return {
        name: 0,
        restrict: 'A',
        priority: 0,
//        template: '<div ng-controller="containerCtrl"><h1>ng-container</h1></div>',
        templateUrl: 'js/app/template/container.tmpl.html',
        replace: false,
        transclude: false,
        scope: false,
        link: function(scope, element, attrs) {
            
        }
    }
}])
.directive('ngPopup', [function() {
    return {
        name: 0,
        restrict: 'A',
        priority: 0,
//        template: '<div ng-controller="popupCtrl"><h1>ng-footer</h1></div>',
        templateUrl: 'js/app/template/popup.tmpl.html',
        replace: false,
        transclude: false,
        scope: false,
        link: function(scope, element, attrs) {
            
        }
    }
}]);






