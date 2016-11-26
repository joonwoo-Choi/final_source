(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('profileWorksCtrl', ['$rootScope', '$scope', 'initData', 'authSvc', 'restApiSvc', '$timeout', function ($rootScope, $scope, initData, authSvc, restApiSvc, $timeout) {
        
        $scope.worksLists = initData.works;
        $scope.page = 1;
        $scope.pageSize = 20;
        $scope.lastPage = false;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        $scope.isProfileWork = true;
        
        $scope.loadList = function(userId){
            if($scope.isLoading || $scope.lastPage) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var params = {
                target_id: userId, 
                page: $scope.page, 
                size: $scope.pageSize
            };
            restApiSvc.get(restApiSvc.apiPath.getWorks(userId), params).then(
                function(res){
                    $scope.lastPage = res.data.data.last;
                    $scope.worksLists = $scope.worksLists.concat(res.data.data.content);
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                },function(err){
                    
                }
            );
        };
        
        $scope.$on('worksListLoad', function(e, params){
            $scope.loadList(params.userId);
        });
        
        /** initialize  */
        $timeout(function(){
            if($rootScope.isMobile){
                window.scrollTo(0,0);
            }else{
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar("scrollTo", 0, {scrollInertia:0});
                $('.profile-wrap .profile-contents-wrap')[0].scrollTop = 0;
            }
            if($scope.worksLists.length <= 0){
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar("destroy");
            }else if($scope.worksLists.length > 0 && !$rootScope.isMobile){
                $scope.$emit('makeProfileViewScroll');
            };
        });
        
    }]);

})(angular);
