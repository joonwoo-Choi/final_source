(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('myfeedsCtrl', ['$rootScope', '$scope', '$window', '$timeout', 'initData', 'restApiSvc', 'authSvc', 'blockUI', function ($rootScope, $scope, $window, $timeout, initData, restApiSvc, authSvc, blockUI) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.isLogin = authSvc.isLogin();
        $scope.hotBuzzlerLists = [];
        $scope.myFeedsLists = initData.myFeedsLists;
        $scope.listColumnLength = 0;
        $scope.isMyfeeds = Boolean($scope.myFeedsLists.length > 0);
        $scope.page = 1;
        $scope.isLastPage = false;
        $scope.pageSize = 20;
        $scope.isLoading = false;
        $scope.loadDelay = 500;
        $scope.scrollTop = 0;
        $scope.scrollbarsConfig = {
            callbacks: {
                onScroll: function () {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                },
                whileScrolling: function() {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                }
            }
        }
        
        angular.element($window).bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.body.scrollTop;
            var maxScrollTop = e.target.body.scrollHeight - angular.element($window).height();
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        });
        $scope.onScroll = function(scrollTop, scrollPct){
            if(scrollPct != undefined && scrollPct >= 95){
                $scope.loadList();
            }
        }
        
        $scope.loadList = function(){
            if($scope.isLoading || $scope.isLastPage) return;
            $scope.isLoading = true;
            $scope.page++;
            
            restApiSvc.get(restApiSvc.apiPath.getMyfeeds, {page:$scope.page,size:$scope.pageSize}).then(
                function(res){
                    $scope.isLastPage = res.data.data.last;
                    if(res.data.data.content.length > 0){
                        $scope.myFeedsLists = $scope.myFeedsLists.concat(res.data.data.content);
                    }
                    
                    $timeout(function(){
                        $scope.isLoading = false;
                    }, $scope.loadDelay);
                },function(res, status){
                    
                }
            );
        }
        
        $scope.getHotBuzzlerList = function(){
            blockUI.start();
            restApiSvc.get(restApiSvc.apiPath.getHotBuzzler).then(
                function(res){
                    $scope.hotBuzzlerLists = res.data.data;
                    $scope.setHotBuzzlerList();
                    blockUI.stop();
                },function(res, status){
                    blockUI.stop();
                }
            );
        }
        
        $scope.setHotBuzzlerList = function(){
            angular.forEach($scope.hotBuzzlerLists, function(val, key){
                if($scope.isLogin){
                    if(authSvc.getUserInfo().id == val.id){
                        val.isMe = true;
                    }
                }else{
                    val.isMe = false;
                }

                if(!val.isMe){
                    if(val.following){
                        val.tooltipTitle = 'UNFOLLOW';
                    }else{
                        val.tooltipTitle = 'FOLLOW';
                    }
                }

                val.worksLists = val.works;
            });
        }
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 999){
                $scope.listColumnLength = 3;
            }else if(newVal > 699 && newVal <= 999){
                $scope.listColumnLength = 2;
            }else if(newVal <= 699){
                $scope.listColumnLength = 1;
            }
        });
        
        /** initialize  */
        if($scope.isMobile){
            $timeout(function(){
                $('.myfeeds-scroll-wrap').mCustomScrollbar("destroy");
            });
        }
        if(!$scope.isMyfeeds){
            $scope.getHotBuzzlerList();
        }
        
    }]);

})(angular);
