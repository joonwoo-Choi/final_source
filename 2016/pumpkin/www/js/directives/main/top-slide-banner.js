
angular.module('giftbox.directives')

.directive('topSlideBanner', ['$timeout', '$state', '$ionicSlideBoxDelegate', '$cordovaGoogleAnalytics', 'appDataSvc', 'restApiSvc', 'browserSvc', function($timeout, $state, $ionicSlideBoxDelegate, $cordovaGoogleAnalytics, appDataSvc, restApiSvc, browserSvc){
    return {
        restrict: 'A',
        scope: true,
        link: function($scope, iElm, iAttrs){
            
            $scope.slideBanners = [];
            $scope.recycleTimeout = null;
            $scope.isBannerLoaded = false;
            $scope.slideIdx = 0;
            
            $scope.$on('$stateChangeSuccess', function(){
                $scope.slideRestartCheck();
            });
            
            $scope.slideRestartCheck = function(){
                if($scope.slideBanners.length <= 0) return;
                if($state.current.name == 'tab.home'){
                    if($scope.slideIdx >= $scope.slideBanners.length-1){
                        $scope.recycleTimeout = $timeout(function(){
                            $scope.recycleTimeout = null;
                            $ionicSlideBoxDelegate.$getByHandle('topSlideBanner').slide(0, 300);
                        }, 5000);
                    }else{
                        $ionicSlideBoxDelegate.$getByHandle('topSlideBanner').start();
                    }
                }else{
                    if($scope.recycleTimeout != null){
                        $timeout.cancel($scope.recycleTimeout);
                        $scope.recycleTimeout = null;
                    };
                    $ionicSlideBoxDelegate.$getByHandle('topSlideBanner').stop();
                };
            }
            
            $scope.goDetail = function(detailId, bannerPage){
                var currentState = $state.current.name;
                var params = {
                        detailId: detailId
                    };
                
                if(detailId != null){
                    $state.go(currentState+'-detail', params);
                }else{
                    browserSvc.open(bannerPage);
                }
                
                if(window.cordova){
                    $cordovaGoogleAnalytics.trackEvent('HOME SLIDE BANNER', 'Event Detail');
                };
            };
            
            $scope.slideChanged = function(idx){
                if($scope.slideBanners.length <= 0) return;
                
                $scope.slideIdx = idx;
                if($scope.recycleTimeout != null){
                    $timeout.cancel($scope.recycleTimeout);
                    $scope.recycleTimeout = null;
                };
                if(idx >= $scope.slideBanners.length-1){
                    $scope.recycleTimeout = $timeout(function(){
                        $scope.recycleTimeout = null;
                        $ionicSlideBoxDelegate.$getByHandle('topSlideBanner').slide(0, 300);
                    }, 5000);
                };
            };
            
            $scope.resizeSlideImage = function(){
                $ionicSlideBoxDelegate.$getByHandle('topSlideBanner').update();
                var bannerWidth = $('#tab-home .top-banner-wrap').width();
                var bannerHeight = $('#tab-home .top-banner-wrap').height();
                angular.forEach($scope.slideBanners, function(val, idx){
                    var currentWidth = val.attachments[0].width;
                    var currentHeight = val.attachments[0].height;

                    if(bannerWidth - currentWidth < bannerHeight - currentHeight){
                        var marginLeft = (bannerWidth - (bannerHeight/currentHeight)*currentWidth)/2;
                        $('#tab-home .top-banner-wrap .slider .box img').eq(idx).css({
                            'width':'auto',
                            'height':'100%',
                            'margin-left':marginLeft + 'px'
                        });
                    };
                });
            };
            
            $scope.getTopSlideBanners = function(){
                if(appDataSvc.slideBanners == null){
                    restApiSvc.get(restApiSvc.apiPath.getSlideBanner, {page:1, size:10}).then(
                        function(res){
                            if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                                console.log(typeof res.data)
                                res.data = JSON.parse(res.data);
                            };
                            $scope.isBannerLoaded = true;
                            appDataSvc.slideBanners = res.data.data.content;
                            $scope.slideBanners = JSON.parse(JSON.stringify(appDataSvc.slideBanners));

                            if($scope.slideBanners.length > 0){
                                $timeout(function(){
                                    $scope.slideRestartCheck();
                                    $scope.resizeSlideImage();
                                    iElm.addClass('show');
                                });
                            }else{
                                $timeout(function(){
                                    iElm.addClass('empty');
                                });
                            };
                        },
                        function(err){
                            
                        }
                    );
                }else{
                    $scope.slideBanners.length = 0;
                    $timeout(function(){
                        $scope.slideBanners = JSON.parse(JSON.stringify(appDataSvc.slideBanners));

                        if($scope.slideBanners.length <= 0){
                            $timeout(function(){
                                iElm.addClass('empty');
                            });
                        }else{
                            $timeout(function(){
                                $scope.resizeSlideImage();
                                iElm.addClass('show');
                            });
                        };
                    });
                };
            };
            
            $scope.$on('homeRefresh', function(){
                if(!$scope.isBannerLoaded){
                    $scope.getTopSlideBanners();
                }
            });
            
            
            $scope.getTopSlideBanners();
            
        }
    };
}]);



