(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('cacheSvc', ['$cacheFactory', function($cacheFactory){
        return $cacheFactory('BBuzzArt-cache-service');
    }]);
    
})(angular);
