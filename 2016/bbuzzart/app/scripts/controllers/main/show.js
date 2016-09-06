(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('showCtrl', ['$rootScope', '$scope', '$window', 'initData', 'restApiSvc', 'cacheSvc', '$timeout', function ($rootScope, $scope, $window, initData, restApiSvc, cacheSvc, $timeout) {
        
        $scope.mainShowLists = initData.mainShowLists;
        $scope.listColumnLength = 0;
        $scope.page = 1;
        $scope.maxPage = 10;
        $scope.pageSize = 20;
        $scope.isLastPage = false;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        
        $scope.loadList = function(){
            if($scope.isLoading || $scope.isLastPage || ($scope.page >= $scope.maxPage)) return;
            $scope.isLoading = true;
            $scope.page++;
            
            restApiSvc.get(restApiSvc.apiPath.showLists, {page:$scope.page,size:$scope.pageSize}).then(
                function(res){
                    $scope.isLastPage = res.data.data.last;
                    if(res.data.data.content.length > 0){
                        $scope.mainShowLists = $scope.mainShowLists.concat(res.data.data.content);
//                        $scope.putCache();
                    }
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                },function(res, status){
                    
                }
            );
        }
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 767){
                $scope.listColumnLength = 4;
            }else{
                $scope.listColumnLength = 2;
            }
        });
        
        $scope.$on('mainListLoad', function(){
            $scope.loadList();
        });
        
//        $scope.putCache = function(){
//            cacheSvc.remove('mainShowLists');
//            cacheSvc.put('mainShowLists', $scope.mainShowLists);
//        }
        
//        $scope.putCache();
        
        /** initialize  */
//        $scope.mainShowLists = $scope.convertData($scope.mainShowLists);
        
    }]);
    
})(angular);
