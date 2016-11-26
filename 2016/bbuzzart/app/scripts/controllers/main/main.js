(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('mainCtrl', ['$rootScope', '$scope', '$window', '$cookies', 'initData','$state', '$timeout', '$interval', '$filter', 'trackerSvc', 'restApiSvc', 'cacheSvc', 'dialogSvc', function ($rootScope, $scope, $window, $cookies, initData, $state, $timeout, $interval, $filter, trackerSvc, restApiSvc, cacheSvc, dialogSvc) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.mainCurationLists = initData.mainCurationLists;
        $scope.curationListLength = $scope.mainCurationLists.length;
        $scope.isChanging = true;
        $scope.imgLoadedCnt = 0;
        $scope.curationIdx = -1;
        $scope.listInterval = undefined;
        $scope.isOpenDialog = false;
        $scope.isFixedMenu = false;
        $scope.listMoveTwice = false;
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
        $scope.mainMenu = [
            {class:'on', name:'keyword'},
            {class:'', name:'discover'},
            {class:'', name:'show'}
        ];
        
        angular.element($window).bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.body.scrollTop;
            var maxScrollTop = e.target.body.scrollHeight - angular.element($window).height();
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        });
        $scope.onScroll = function(scrollTop, scrollPct){
            scrollTop = Math.abs(scrollTop);
            $scope.scrollTop = scrollTop;
            var setMenuFixedY = $('.main-wrap .curation-wrap').outerHeight();
            if($scope.scrollTop >= setMenuFixedY) {
                $scope.isFixedMenu = true;
                $scope.rollingStop();
                $('.nav-main').addClass('fixed');
            }else{
                $scope.isFixedMenu = false;
                if($scope.listInterval == undefined){
                    $scope.rollingStart();
                };
                if($('.md-dialog-container').length <= 0){
                    $('.nav-main').removeClass('fixed');
                };
            };
            
            /** list load   */
            if(scrollPct != undefined && scrollPct >= 95){
                $scope.$broadcast('mainListLoad');
            };
        };
        
        $scope.curationImgLoadComplete = function(){
            $scope.imgLoadedCnt++;
            if($scope.imgLoadedCnt < $scope.curationListLength) return;
            
            $timeout(function(){
                angular.forEach($scope.mainCurationLists, function(val, idx){
                    $('.main-wrap .curation-wrap .info-wrap li').eq(idx).css({
                        '-webkit-transition-delay': (idx*0.065) + 's',
                        'transition-delay': (idx*0.065) + 's'
                    });
                });
                $('.main-wrap .curation-wrap').addClass('loaded');
            }, 150);
            $timeout(function(){
                if($scope.isMobile && angular.element($window).width() < 768) return;
            
                $scope.curationIdx = 0;
                $scope.rollingStart();
            }, 500);
        };
        
        $scope.rollingStart = function(){
            if($scope.isOpenDialog || $scope.isFixedMenu) return;
            
            $scope.listInterval = $interval(function(){
                $scope.curationIdx++;
                if($scope.curationIdx >= $scope.curationListLength){
                    $scope.curationIdx = 0;
                }
            }, 6000);
        };
        $scope.rollingStop = function(){
            $interval.cancel($scope.listInterval);
            $scope.listInterval = undefined;
        };
        $scope.curationListChange = function(idx){
            $scope.curationIdx = idx;
            $scope.rollingStop();
            $scope.rollingStart();
        };
        
        $scope.goDetail = function(){
            trackerSvc.eventTrack('WORK DETAIL', {category:"Curator's PICK"});
            
            var idx = $scope.curationIdx;
            $state.go('detail', {
                artworkType: $scope.mainCurationLists[idx].work.type, 
                id: $scope.mainCurationLists[idx].work.id
            });
        };
        
        $scope.mainNavHandler = function(state){
            switch(state){
                case 'keyword' :
                    trackerSvc.eventTrack('KEYWORD', {category:'KEYWORD'});
                    break;
                case 'discover' :
                    trackerSvc.eventTrack('DISCOVER', {category:'DISCOVER'});
                    break;
                case 'show' :
                    trackerSvc.eventTrack('SHOW', {category:'SHOW'});
                    break;
            };
        };
        
        $scope.mainResize = function(){
            if($scope.isMobile){
                var wWidth = angular.element($window).width();
                if(wWidth < 768){
                    $timeout(function(){
                        $('.main-wrap .curation-wrap').css({'height': 0});
                        $('.main-wrap .contents-wrap .nav-main .nav-main-wrap').css({'padding-top': 0});
                    });
                }else{
                    var wScrollTop = angular.element($window).scrollTop();
                };
            }else{
                var wScrollTop = angular.element($window).scrollTop();
            };
        };
        
        $scope.$watch(function(){
            return $('.md-dialog-container').length;
        }, function(newVal, oldVal){
            if(newVal > 0){
                $scope.isOpenDialog = true;
                $scope.rollingStop();
            }else{
                $scope.isOpenDialog = false;
                if($scope.listInterval == undefined){
                    if($scope.imgLoadedCnt >= $scope.curationListLength){
                        $scope.rollingStart();
                    };
                };
            };
        });
        
        $scope.$on('$stateChangeStart', function(e, toState){
            var stateName = toState.name;
            if(stateName.indexOf('main.') < 0){
                $scope.rollingStop();
            };
        });
        $scope.$on('$stateChangeSuccess', function(e, toState){
            var stateName = toState.name;
            if(stateName.indexOf('main.') < 0) return;
            angular.forEach($scope.mainMenu, function(value, key) {
                value.class = '';
                if(stateName.indexOf(value.name) > -1) value.class = 'on';
            });
            
            var wWidth = angular.element($window).width();
            if($scope.isMobile && wWidth < 768){
                window.scrollTo(0,0);
            }else{
                var setMenuFixedY = $('.main-wrap .curation-wrap').outerHeight();
                if($scope.scrollTop >= setMenuFixedY) {
                    if($scope.isMobile){
                        $('body')[0].scrollTop = setMenuFixedY;
                    }else{
                        $('.main-wrap').mCustomScrollbar("scrollTo", setMenuFixedY, {scrollInertia:0});
                    };
                };
            };
        });
        
        angular.element($window).bind('resize', function(){
            $scope.mainResize();
        });
        angular.element($window).bind("orientationchange", function() {
            $scope.mainResize();
        });
        
        /** initialize  */
        angular.forEach($scope.mainCurationLists, function(val, idx) {
            /** convert date    */
            var temp = String(val.createdDate).split(' ');
			var tempDate = temp[0].split('-');
			var objDate = new Date(tempDate.join('/') + ' ' + temp[1] + ' UTC');
            val.convertedDate = $filter('date')(objDate.toISOString(), 'MMM. d');
        });
        
        if($scope.isMobile){
            $timeout(function(){
                $('.main-wrap').mCustomScrollbar("destroy");
            });
            $scope.mainResize();
        };
        
        /** main banner open    */
        if($rootScope.initSite){
            $rootScope.initSite = false;
            var loc = location.href.toLowerCase();
            var tempLoc = loc.replace(/#\//g, '');
            var originLoc = location.origin + '/';
            if(tempLoc == originLoc){
                restApiSvc.get(restApiSvc.apiPath.getBanners).then(
                    function(res){
                        if(res.data.data.length <= 0) return;
                        
                        var getCookie = $cookies.get(loc + 'hideBanner'+res.data.data[0].id);
                        if(getCookie == undefined){
                            $timeout(function(){
                                dialogSvc.openBanner({bannersData:res.data.data});
                            });
                        };
                    },function(err){

                    }
                );
            };
        };
        
    }]);
    
})(angular);
