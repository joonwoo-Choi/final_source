(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('profileBookmarksCtrl', ['$rootScope', '$scope', '$window', '$state', 'initData', 'authSvc', 'restApiSvc', '$timeout', function ($rootScope, $scope, $window, $state, initData, authSvc, restApiSvc, $timeout) {
        
        $scope.bookmarksLists = initData.bookmarks;
        $scope.listColumnLength = 0;
        $scope.page = 1;
        $scope.pageSize = 20;
        $scope.lastPage = false;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        $scope.isBookmarks = Boolean($state.current.name.indexOf('bookmarks') > -1);
        
        $scope.loadList = function(userId){
            if($scope.isLoading || $scope.lastPage) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var params = {
                target_id: userId, 
                page: $scope.page, 
                size: $scope.pageSize
            };
            restApiSvc.get(restApiSvc.apiPath.getBookmarks(userId), params).then(
                function(res){
                    $scope.lastPage = res.data.data.last;
                    $scope.bookmarksLists = $scope.bookmarksLists.concat(res.data.data.content);
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                },function(err){
                    
                }
            );
        };
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 1280){
                $scope.listColumnLength = 3;
            }else{
                $scope.listColumnLength = 2;
            };
        });
        
        $scope.$on('bookmarksListLoad', function(e, params){
            $scope.loadList(params.userId);
        });
        
        /** initialize  */
        $timeout(function(){
            if($rootScope.isMobile){
                window.scrollTo(0,0);
            }else{
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar("scrollTo", 0, {scrollInertia:0});
                $('.profile-wrap .profile-contents-wrap')[0].scrollTop = 0;
            };
            if($scope.bookmarksLists.length <= 0){
                $('.profile-wrap .profile-view-wrap').mCustomScrollbar("destroy");
            }else if($scope.bookmarksLists.length > 0 && !$rootScope.isMobile){
                $scope.$emit('makeProfileViewScroll');
            };
        });
        
    }]);
    
})(angular);
