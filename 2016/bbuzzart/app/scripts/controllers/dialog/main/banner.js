(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('popupBannerCtrl', ['$scope', '$cookies', '$timeout', 'dialogParams', 'dialogSvc', 'imgLoadSvc', 'blockUI', function ($scope, $cookies, $timeout, dialogParams, dialogSvc, imgLoadSvc, blockUI) {
        
        $scope.bannersData = dialogParams.bannersData;
        $scope.thumbnailTitle = 'BBuzzart';
        $scope.thumbnailUrl = '/images/thumbnail_default_img.png';
        $scope.isDontShow = false;
        
        $scope.goDetail = function(){
            location.href = $scope.bannersData[0].detail;
        };
        
        $scope.closeBanner = function(){
            if($scope.isDontShow){
                var loc = location.href.toLowerCase();
                $cookies.put(loc + 'hideBanner' + $scope.bannersData[0].id, 'hide');
            };
            dialogSvc.close();
        };
        
        /** initialize  */
        imgLoadSvc.load($scope.bannersData[0].image, function(src){
            $timeout(function(){
                $scope.thumbnailTitle = $scope.bannersData[0].title;
                $scope.thumbnailUrl = src;
            }, 1000);
        });
        
        
    }]);

})(angular);
