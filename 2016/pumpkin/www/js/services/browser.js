angular.module('giftbox.services')

.factory('browserSvc', ['$cordovaInAppBrowser', 'appDataSvc', function($cordovaInAppBrowser, appDataSvc){
    
    function openBrowser(url){
        
        var options = {
                location: 'yes',
                clearcache: 'no',
                toolbar: 'no'
            };
        
        if(appDataSvc.os == 'IOS'){
            options.location = 'no';
            options.toolbar = 'yes';
            options.enableViewportScale = 'yes';
        };
        
        $cordovaInAppBrowser.open(url, '_blank', options).then(
            function(event) {
                // success
                
            }).catch(
            function(event) {
                // error
                
            });
        
    }
    
    return {
        open: openBrowser,
        close: function(){
            $cordovaInAppBrowser.close();
        }
    };
}]);




