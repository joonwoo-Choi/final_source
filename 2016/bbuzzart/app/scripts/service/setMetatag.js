(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('setMetatagSvc', ['$rootScope', function($rootScope){
        
        function setMetatagData(params) {
            var pageTitle = params.pageTitle || '';
            var metaTitle = params.metaTitle || 'BBuzzArt';
            var metaDescription = params.metaDescription || 'BBuzzArt is an art social platform to present new and emerging art and to share simple and sincere feedback. It is open to every artists and art enthusiasts around the world.';
            var metaKeywords = params.metaKeywords || 'artist,writers,critics,creative agencies,art lovers';
            var metaAuthor = params.metaAuthor || 'BBuzzArt';
            
            $('title').text('BBuzzArt' + pageTitle);
            $("meta[name='title']").attr("content", metaTitle);
            $("meta[name='subject']").attr("content", metaDescription);
            $("meta[name='description']").attr("content", metaDescription);
            $("meta[name='keywords']").attr("content", metaKeywords);
            $("meta[name='author']").attr("content", metaAuthor);
		}
        
        return {
			setMetatag: setMetatagData
		};
    }]);
    
})(angular);
