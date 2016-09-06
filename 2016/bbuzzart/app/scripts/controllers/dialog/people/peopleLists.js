(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('peopleListCtrl', ['$rootScope', '$scope', '$window', '$timeout', '$mdSidenav', 'dialogParams', 'trackerSvc', 'restApiSvc', 'authSvc', 'dialogSvc', 'blockUI', function ($rootScope, $scope, $window, $timeout, $mdSidenav, dialogParams, trackerSvc, restApiSvc, authSvc, dialogSvc, blockUI) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.dialogTitle = dialogParams.title;
        $scope.searchData = dialogParams.searchData;
        $scope.dialogType = dialogParams.type;
        $scope.peopleLists = [];
        $scope.listColumnLength = 0;
        $scope.page = 0;
        $scope.totalPages = 1;
        $scope.pageSize = 20;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        $scope.isFirstSearched = false;
        
        $scope.getPeopleList = function(){
            if($scope.isLoading || ($scope.page > $scope.totalPages-1)) return;
            $scope.isLoading = true;
            $scope.page++;
            
            var apiPath = '';
            var params = {
                    page: $scope.page,
                    size: $scope.pageSize
                };
            switch($scope.dialogType){
                case 'following' :
                    apiPath = restApiSvc.apiPath.getFollowings($scope.searchData);
                    break;
                case 'followers' :
                    apiPath = restApiSvc.apiPath.getFollowers($scope.searchData);
                    break;
                case 'search' :
                    params.word = $scope.searchData;
                    apiPath = restApiSvc.apiPath.searchPerson;
                    break;
                case 'like' :
                    apiPath = restApiSvc.apiPath.getLikePeople($scope.searchData);
                    break;
            }
            restApiSvc.get(apiPath, params).then(
                function(res){
                    $scope.peopleLists = $scope.peopleLists.concat(res.data.data.content);
                    $scope.totalPages = res.data.data.totalPages;
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                    
                    if(!$scope.isFirstSearched) $scope.isFirstSearched = true;
                },function(res, status){
                    
                }
            );
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
                $scope.getPeopleList();
            }
        }
        
        $scope.popupClose = function(){
            dialogSvc.close();
            $rootScope.$broadcast('reloadProfile');
        }
        
        $scope.$watch('peopleLists', function(newVal, oldVal){
            if(newVal.length > 0 && oldVal == 0){
                $timeout(function(){
                    $('.people-lists-container').bind('scroll', $scope.scrollHandler);
                });
            }
        });
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 767){
                $scope.listColumnLength = 2;
            }else{
                $scope.listColumnLength = 1;
            }
        });
        
        /** initialize  */
        switch($scope.dialogType){
            case 'following' :
                trackerSvc.pageTrack('FOLLOWING');
                break;
            case 'followers' :
                trackerSvc.pageTrack('FOLLOWERS');
                break;
            case 'search' :
                trackerSvc.pageTrack('PERSON LIST');
                break;
            case 'like' :
                trackerSvc.pageTrack('PEOPLE THIS LIKE');
                break;
        }
        $scope.getPeopleList();
    }]);
    
})(angular);
