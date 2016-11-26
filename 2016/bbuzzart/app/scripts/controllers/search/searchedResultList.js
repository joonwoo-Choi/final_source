(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('searchedResultList', ['$rootScope', '$scope', '$window', 'initData', 'restApiSvc', '$timeout', function ($rootScope, $scope, $window, initData, restApiSvc, $timeout) {
        
        $scope.searchedLists = initData.searchLists;
        $scope.keyword = initData.keyword;
        $scope.tab = initData.tab;
        $scope.apiPath = '';
        $scope.page = 1;
        $scope.pageSize = 20;
        $scope.listColumnLength = 0;
        $scope.lastPage = initData.lastPage;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        
        $scope.loadList = function(){
            if($scope.isLoading || $scope.lastPage) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var params = {
                word: $scope.keyword,
                page: $scope.page,
                size: $scope.pageSize
            };
            restApiSvc.get($scope.apiPath, params).then(
                function(res){
                    if($scope.page >= 10){
                        $scope.lastPage = true;
                    }else{
                        $scope.lastPage = res.data.data.last;
                    };
                    $scope.searchedLists = $scope.searchedLists.concat(res.data.data.content);
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                        
                    }, $scope.loadDelay);
                },function(err){
                    
                }
            );
        };
        
        $scope.$watch(function(){
            return $('.searched-lists').height();
        }, function(newVal, oldVal){
            if(newVal != oldVal){
                if(!$scope.lastPage && ($('.search-view-wrap').height() >= $('.searched-lists').height())){
                    $timeout(function(){
                        $scope.loadList();
                    });
                };
            };
        });
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 1024){
                if($scope.tab == 'person'){
                    $scope.listColumnLength = 2;
                }else if($scope.tab == 'tag'){
                    $scope.listColumnLength = 5;
                }else if($scope.tab == 'title'){
                    $scope.listColumnLength = 4;
                };
            }else if(newVal > 767 && newVal <= 1024){
                if($scope.tab == 'person'){
                    $scope.listColumnLength = 2;
                }else if($scope.tab == 'tag'){
                    $scope.listColumnLength = 5;
                }else if($scope.tab == 'title'){
                    $scope.listColumnLength = 3;
                };
            }else{
                if($scope.tab == 'person'){
                    $scope.listColumnLength = 1;
                }else if($scope.tab == 'tag'){
                    $scope.listColumnLength = 2;
                }else if($scope.tab == 'title'){
                    $scope.listColumnLength = 2;
                };
            };
        });
        
        $scope.$on('searchedListLoad', function(e, params){
            $scope.loadList();
        });
        
        /** initialize  */
        if($scope.tab == 'person'){
            $scope.apiPath = restApiSvc.apiPath.searchPerson;
        }else if($scope.tab == 'tag'){
            $scope.apiPath = restApiSvc.apiPath.searchTag;
        }else if($scope.tab == 'title'){
            $scope.apiPath = restApiSvc.apiPath.searchTitle;
        };
        $rootScope.$broadcast('searchedLengthChange', {searchedLength: initData.searchedLength});
        
    }]);

})(angular);
