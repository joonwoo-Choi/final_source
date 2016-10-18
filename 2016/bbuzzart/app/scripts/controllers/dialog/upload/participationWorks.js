(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('participationWorksCtrl', ['$rootScope', '$scope', '$window', '$timeout', 'dep', 'restApiSvc', 'dialogSvc', 'blockUI', function ($rootScope, $scope, $window, $timeout, dep, restApiSvc, dialogSvc, blockUI) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.isParticipationWorksLists = true;
        $scope.userId = dep.userId;
        $scope.copyParticipationWorkIds = JSON.parse(JSON.stringify(dep.participationWorkIds));
        $scope.participationWorkIds = dep.participationWorkIds;
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
            restApiSvc.get(restApiSvc.apiPath.participationWorksLists($scope.userId), params).then(
                function(res){
                    $scope.addLists(res);
                },function(res, status){

                }
            );
        };
        $scope.addLists = function(loadedLists){
            var tempList = loadedLists.data.data.content;

            if($scope.participationWorkIds.length > 0){
                angular.forEach(tempList, function(tempVal, idx){
                    var isSelected = false;
                    angular.forEach($scope.participationWorkIds, function(workVal, idx){
                        if(tempVal.id == workVal.id){
                            isSelected = true;
                        };
                    });
                    if(isSelected){
                        tempVal.selected = true;
                    }else{
                        tempVal.selected = false;
                    };
                });
            }else{
                angular.forEach(tempList, function(tempVal, idx){
                    tempVal.selected = false;
                });
            };

            $scope.searchedLists = $scope.searchedLists.concat(tempList);
            $scope.totalPages = loadedLists.data.data.totalPages;

            $timeout(function(){
                $scope.isLoading = false;
            }, $scope.loadDelay);

            if(!$scope.isFirstSearched) $scope.isFirstSearched = true;
        };

        $scope.confirm = function(){
            if($scope.participationWorkIds.length <= 0) return;
            $('.popup-participation-lists .list-wrap').css({display: 'none'});
            $scope.participationWorkIds.sort(function(a, b){return b.id - a.id});
            dep.confirmCallback($scope.participationWorkIds);
            dialogSvc.closeConfirm();
        };

        $scope.scrollHandler = function(e){
            var scrollTop = e.target.scrollTop;
            var maxScrollTop = e.target.scrollHeight - e.target.clientHeight;
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        };
        $scope.onScroll = function(scrollTop, scrollPct){
            scrollTop = Math.abs(scrollTop);

            /** list load   */
            if(scrollPct != undefined && scrollPct >= 95){
                $scope.getSearchList();
            };
        };

        $scope.popupClose = function(){
            $('.searched-lists-container').unbind('scroll', $scope.scrollHandler);
            $('.popup-participation-lists .list-wrap').css({display: 'none'});
            dep.confirmCallback($scope.copyParticipationWorkIds);
            dialogSvc.closeConfirm();
        };

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
            if(newVal.length > 0 && oldVal.length == 0){
                $timeout(function(){
                    $('.searched-lists-container').bind('scroll', $scope.scrollHandler);
                });
            };
        });

        /** initialize  */
        $scope.getSearchList();
        
    }]);

})(angular);
