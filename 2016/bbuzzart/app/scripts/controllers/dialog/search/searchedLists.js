(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('searchedListsCtrl', ['$rootScope', '$scope', '$timeout', '$window', 'dialogParams', 'trackerSvc', 'restApiSvc', 'dialogSvc', 'blockUI', function ($rootScope, $scope, $timeout, $window, dialogParams, trackerSvc, restApiSvc, dialogSvc, blockUI) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.dialogTitle = dialogParams.title;
        $scope.searchData = dialogParams.searchData;
        $scope.dialogType = dialogParams.type;
        $scope.searchedLists = [];
        $scope.listColumnLength = 0;
        $scope.page = 0;
        $scope.totalPages = 1;
        $scope.pageSize = 20;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        $scope.isFirstSearched = false;
        
        
        $scope.getSearchList = function(){
            if($scope.isLoading || ($scope.page > $scope.totalPages-1)) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var params = {
                page: $scope.page,
                size: $scope.pageSize
            };
            if($scope.dialogType == 'tag'){
                params.tagName = $scope.searchData;
                restApiSvc.get(restApiSvc.apiPath.searchTagWorks, params).then(
                    function(res){
                        $scope.addLists(res);
                    },function(res, status){
                        
                    }
                );
            }else if($scope.dialogType == 'keyword'){
                params.keyword = $scope.searchData;
                restApiSvc.get(restApiSvc.apiPath.searchKeywordWorks, params).then(
                    function(res){
                        $scope.addLists(res);
                    },function(res, status){
                        
                    }
                );
            }else{
                params.word = $scope.searchData;
                restApiSvc.get(restApiSvc.apiPath.searchTitle, params).then(
                    function(res){
                        $scope.addLists(res);
                    },function(res, status){
                        
                    }
                );
            }
        }
        $scope.addLists = function(loadedLists){
            $scope.searchedLists = $scope.searchedLists.concat(loadedLists.data.data.content);
            $scope.totalPages = loadedLists.data.data.totalPages;
            
            $timeout(function(){
                $scope.isLoading = false;
            }, $scope.loadDelay);
            
            if(!$scope.isFirstSearched) $scope.isFirstSearched = true;
        }
        
        $scope.scrollHandler = function(e){
//            if(!$scope.isMobile) return;

            var scrollTop = e.target.scrollTop;
            var maxScrollTop = e.target.scrollHeight - e.target.clientHeight;
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        }
        $scope.onScroll = function(scrollTop, scrollPct){
            scrollTop = Math.abs(scrollTop);
            
            /** list load   */
            if(scrollPct != undefined && scrollPct >= 95){
                $scope.getSearchList();
            }
        }
        
        $scope.popupClose = function(){
            dialogSvc.close();
            $rootScope.$broadcast('reloadProfile');
        }
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 1024){
                $scope.listColumnLength = 4;
            }else if(newVal > 767 && newVal <= 1024){
                $scope.listColumnLength = 3;
            }else{
                $scope.listColumnLength = 2;
            }
        });
        
        $scope.$watch('searchedLists', function(newVal, oldVal){
            if(newVal.length > 0 && oldVal == 0){
                $timeout(function(){
                    $('.searched-lists-container').bind('scroll', $scope.scrollHandler);
                });
            }
        });
        
        /** initialize  */
        trackerSvc.pageTrack('WORK LIST');
        $scope.getSearchList();
    }]);

})(angular);
