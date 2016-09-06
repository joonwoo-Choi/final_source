angular.module('giftbox.services')

.factory('appDataSvc', [function(){
    
    var deviceId = '';
    var deviceToken = '';
    
    return {
        setDeviceId: function(id){
            deviceId = id;
        },
        getDeviceId: function(){
            return deviceId;
        },
        setDeviceToken: function(token){
            deviceToken = token;
        },
        getDeviceToken: function(){
            return deviceToken;
        },
        filterOption: null,
        slideBanners: null,
        os: ''
    };
}]);
    
