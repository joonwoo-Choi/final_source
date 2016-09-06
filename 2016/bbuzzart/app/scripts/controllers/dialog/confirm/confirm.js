(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('popupConfirmCtrl', ['$rootScope', '$scope', 'dialogParams', 'dialogSvc', function ($rootScope, $scope, dialogParams, dialogSvc) {
        
        $scope.type = dialogParams.type;
        
        $scope.confirm = function(answer){
            dialogSvc.close(answer);
        }
        
    }]);
    
})(angular);
