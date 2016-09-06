
angular.module('giftbox.directives')

.directive('bottomBanner', ['$timeout', 'browserSvc', 'restApiSvc', function($timeout, browserSvc, restApiSvc){
    return {
        restrict: 'A',
        templateUrl: 'templates/common/bottom-banner.html',
        scope: true,
        replace: true,
        link: function($scope, iElm, iAttrs){
            
            $scope.bottomBanner = null;
            
            $scope.closeBanner = function(){
                iElm.css({'display':'none'});
            };
            
            $scope.openBannerSite = function(url){
                browserSvc.open(url);
            };
            
            $scope.getBottomBanner = function(){
                restApiSvc.get(restApiSvc.apiPath.getBottomBanner, {page:1, size:1, premium:false}).then(
                    function(res){
                        $scope.bottomBanner = res.data.data.content[0];
                        iElm.addClass('show');
                    },function(res, status){

                    }
                );
            };
            
            $timeout(function(){
                $scope.getBottomBanner();
            });
            
        }
    };
}]);



