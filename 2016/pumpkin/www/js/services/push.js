angular.module('giftbox.services')

.factory('pushSvc', ['$rootScope', '$q', '$timeout', '$state', 'restApiSvc', 'storageSvc', 'appDataSvc', 'calendarSvc', function($rootScope, $q, $timeout, $state, restApiSvc, storageSvc, appDataSvc, calendarSvc){
    
    var push = null;
    var pushOptions = {
            android: {
                senderID: '83144609301',
                clearBadge: true
            },
            ios: {
                senderID: '83144609301',
                gcmSandbox: true,
                alert: 'true',
                badge: 'true',
                sound: 'true'
            }
        };
    
    function initPush(){
        push = PushNotification.init(pushOptions);
        
//        clearAllNotifications();
        
        push.on('registration', function(data) {
            setBadgeNumber(0);
            
            var token = '';
            token = data.registrationId;
            appDataSvc.setDeviceToken(token);
//            alert(token);
//            calendarSvc.createEvent({
//                    title: token,
//                    notes: token,
//                    publicationDate: '2016-08-24'
//                });
            
            storageSvc.getByTableId('userInfo', 1).then(
                function(res){
                    var params = {
                        os: appDataSvc.os,
                        token: token
                    };
                    
                    if(res == null || res.os == undefined){
                        storageSvc.insertUserInfo([appDataSvc.os, true, token]);
                        setPushToken(params);
                    }else{
                        if(res.deviceToken != token){
                            setPushToken(params);
                        };
                        
                        var isPush = res.isPush;
                        storageSvc.updateUserInfo([appDataSvc.os, isPush, token]).then(
                            function(res){
                                $rootScope.$broadcast('setNotification' ,{isPush: isPush});
                            }
                        );
                    };
                }
            );
        });
        
        push.on('notification', function(data) {
            var eventId;
            var foreground = data.additionalData.foreground;
            
            if(appDataSvc.os == 'ANDROID'){
                eventId = data.additionalData.eventId;
            }else{
                eventId = data.additionalData['gcm.notification.eventId'];
            };
            
//            alert('notification on ' + JSON.stringify(data));
//            alert('notification on ' + eventId + ' ' + foreground);
            
            if(eventId != undefined && eventId != null && !foreground){
                $rootScope.$broadcast('getPushNotification' ,{eventId: eventId});
            };
        });
        
        push.on('error', function(e) {
//            alert('error ' + e.message);
        });
        
        push.off('notification', function(data) {
//            alert('notification off ' + data);
        });
    };
    
    function setPushToken(params){
        restApiSvc.post(restApiSvc.apiPath.setPushToken, params).then(
            function(res){
//                alert('success token ' + JSON.stringify(res));
            },
            function(err){
//                alert('err token ' + JSON.stringify(err));
            }
        );
    }
    
    function hasPushPermission(){
        var deferred = $q.defer();
        PushNotification.hasPermission(function(data) {
            deferred.resolve(data.isEnabled);
        });
        return deferred.promise;
    };
    
    function clearAllNotifications(){
        push.clearAllNotifications(function() {
            
        }, function() {
            
        });
    };
    
    function setBadgeNumber(num){
        push.setApplicationIconBadgeNumber(function() {
//            alert('success badgeNumber ' + num);
        }, function() {
//            alert('error badgeNumber');
        }, num);
    };
    
    function pushRegister(){
        var token = appDataSvc.getDeviceToken();
        storageSvc.updateUserInfo([appDataSvc.os, true, token]);
        
        PushNotification.register(
            function(res){}, 
            function(err){}, 
            pushOptions
        );
    };
    
    function pushUnregister(){
        push.unregister(function() {
            push = null;
            var token = appDataSvc.getDeviceToken();
            storageSvc.updateUserInfo([appDataSvc.os, false, token]);
//            alert('unregister ');
        }, function() {
//            alert('error');
        });
    };
    
    return {
        init: initPush,
        hasPermission: hasPushPermission,
        clearNotifications: clearAllNotifications,
        register: pushRegister,
        unregister: pushUnregister
    };
}]);
    




