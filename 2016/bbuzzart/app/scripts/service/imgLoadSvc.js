(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('imgLoadSvc', [function(){
        
        return {
            load: function(src, callback){
                var img = new Image();
                img.onload = function() {
                    callback(src);
                };
                img.src = src;
			}
		};
    }]);
    
})(angular);
