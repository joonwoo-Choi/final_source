(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('discoverCtrl', ['$rootScope', '$scope', '$window', '$timeout', '$state', 'initData', 'restApiSvc', 'blockUI', function ($rootScope, $scope, $window, $timeout, $state, initData, restApiSvc, blockUI) {
        
        $scope.mainDiscoverLists = initData.mainDiscoverLists;
        $scope.listColumnLength = 0;
        $scope.page = 1;
        $scope.maxPage = 10;
        $scope.pageSize = 20;
        $scope.isRecent = initData.isRecent;
        $scope.isLastPage = false;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        
        $scope.loadList = function(){
            if($scope.isLoading || $scope.isLastPage || ($scope.page >= $scope.maxPage)) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var params = {
                page:$scope.page,
                size:$scope.pageSize
            }
            if(!$scope.isRecent) params.type = 'hot';
            restApiSvc.get(restApiSvc.apiPath.discoverLists, params).then(
                function(res){
                    $scope.isLastPage = res.data.data.last;
                    if(res.data.data.content.length > 0){
                        var tempList = $scope.convertList(res.data.data.content);
                        $scope.mainDiscoverLists = $scope.mainDiscoverLists.concat(tempList);
//                        $scope.putCache();
                    }
                    
                    $timeout(function(){
                        if($scope.page == 1){
                            blockUI.stop();
                        }
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                },function(res, status){
                    
                }
            );
        }
        
        $scope.convertList = function(list){
            var tempList = [];
            angular.forEach(list, function(val, idx){
                tempList.push(val.work);
            });
            return tempList;
        }
        
        $scope.listFiltering = function(listType){
            $state.go('main.discover', {listType:listType});
//            blockUI.start();
//            $scope.isRecent = isRecent;
//            $scope.page = 0;
//            $scope.isLastPage = false;
//            $scope.isLoading = false;
//            $scope.mainDiscoverLists.length = 0;
//            $scope.loadList();
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
//            cacheSvc.remove('mainDiscoverLists');
//            cacheSvc.put('mainDiscoverLists', $scope.mainDiscoverLists);
//        }
        
//        $scope.putCache();
        
        /** initialize  */
        $scope.mainDiscoverLists = $scope.convertList($scope.mainDiscoverLists);
        
    }]);

})(angular);
