(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('trackerSvc', ['$analytics', function($analytics){
        
        return {
            eventTrack: function(evt, params){
                $analytics.eventTrack(evt, params);
			},
            pageTrack: function(trackPageName){
                $analytics.pageTrack(trackPageName);
            }
		};
    }]);
    
})(angular);
