(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('searchCtrl', ['$rootScope', '$scope', '$window', '$state', '$stateParams', 'initData', 'restApiSvc', 'cacheSvc', 'authSvc', '$timeout', function ($rootScope, $scope, $window, $state, $stateParams, initData, restApiSvc, cacheSvc, authSvc, $timeout) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.isLogin = authSvc.isLogin();
        $scope.keyword = initData.word;
        $scope.totalSearchedLength = 0;
        $scope.isPerson = initData.isPerson;
        $scope.isTag = initData.isTag;
        $scope.isTitle = initData.isTitle;
        $scope.selectedTabIdx = -1;
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
        };
        
        angular.element($window).bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.body.scrollTop;
            var maxScrollTop = e.target.body.scrollHeight - angular.element($window).height();
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        });
        $scope.onScroll = function(scrollTop, scrollPct){
            if(scrollPct != undefined && scrollPct >= 95){
                $rootScope.$broadcast('searchedListLoad');
            };
        };
        
        $scope.searchKeydown = function(e, keyword){
            if(e.keyCode == 13){
                $scope.searchKeyword(keyword);
            };
        };
        $scope.searchKeyword = function(keyword){
            if(keyword <= 0) return;
            
            var params = {};
            /** 태그 검색   */
            if(keyword.indexOf('#') == 0){
                while(keyword){
                    if(keyword.indexOf('#') > -1){
                        keyword = keyword.substr(1);
                    }else{
                        break;
                    };
                };
                params = {
                    word: keyword
                };
                restApiSvc.get(restApiSvc.apiPath.searchTag, params).then(
                    function(res){
                        var tagLength = res.data.data.content.length;
                        if(tagLength > 0){
                            $state.go('search.searched', {word:keyword, tab:'tag'});
                        }else{
                            $state.go('search.searched', {word:keyword, tab:'no-result'});
                        };
                        
                        if($scope.isLogin) $rootScope.$broadcast('getSearchedHistories');
                    },function(err){
                        
                    }
                );
            }else{
                /** 일반 검색   */
                params = {
                    word: keyword,
                    tagSize: 1,
                    personSize: 1,
                    titleSize: 1
                };
                restApiSvc.get(restApiSvc.apiPath.search, params).then(
                    function(res){
                        if($scope.isLogin) $rootScope.$broadcast('getSearchedHistories');
                        
                        var isPerson = Boolean(res.data.data.users.length);
                        var isTag = Boolean(res.data.data.tags.length);
                        var isTitle = Boolean(res.data.data.works.length);
                        
                        if(isPerson){
                            $state.go('search.searched', {word: keyword, tab:'person'});
                        }else if(!isPerson && isTag){
                            $state.go('search.searched', {word: keyword, tab:'tag'});
                        }else if(!isPerson && isTag && isTitle){
                            $state.go('search.searched', {word: keyword, tab:'title'});
                        }else{
                            $state.go('search.searched', {word: keyword, tab:'no-result'});
                        };
                    },function(err){
                        
                    }
                );
            };
        };
        
        $scope.tabChange = function(isLocChange){
            $scope.isPerson = initData.isPerson;
            $scope.isTag = initData.isTag;
            $scope.isTitle = initData.isTitle;
            
            var arr = location.href.split('/');
            if(arr[arr.length-2].indexOf('person') > -1){
                $scope.selectedTabIdx = 0;
            }else if(arr[arr.length-2].indexOf('tag') > -1){
                $scope.selectedTabIdx = 1;
            }else if(arr[arr.length-2].indexOf('title') > -1){
                $scope.selectedTabIdx = 2;
            }else{
                $scope.selectedTabIdx = -1;
                if(isLocChange){
                    $scope.totalSearchedLength = 0;
                    $scope.isPerson = false;
                    $scope.isTag = false;
                    $scope.isTitle = false;
                };
            };
        };
        
        $rootScope.$on('$locationChangeSuccess', function() {
            $scope.tabChange(true);
	    });
        
        $scope.$on('searchedLengthChange', function(e, params){
            $scope.totalSearchedLength = params.searchedLength.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        });
        
        /** initialize  */
        $scope.tabChange();
        if($scope.isMobile){
            $timeout(function(){
                $('.search-scroll-wrap').mCustomScrollbar("destroy");
            });
        };
        
    }]);
    
})(angular);
