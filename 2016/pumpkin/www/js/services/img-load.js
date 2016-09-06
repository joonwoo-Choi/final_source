angular.module('giftbox.services')

.factory('imgLoadSvc', [function(){

    return {
        load: function(src, callback){
            var img = new Image();
            img.onload = function() {
                callback(src);
            }
            img.src = src;
        }
    };
}]);
    
