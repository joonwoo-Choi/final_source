
angular.module('giftbox.directives')

.directive('sideMenu', ['$timeout', '$state', '$ionicActionSheet', '$cordovaSocialSharing', '$cordovaGoogleAnalytics', 'pushSvc', 'browserSvc', 'dialogSvc', function($timeout, $state, $ionicActionSheet, $cordovaSocialSharing, $cordovaGoogleAnalytics, pushSvc, browserSvc, dialogSvc){
    return {
        restrict: 'A',
        scope: true,
        replace: false,
        link: function($scope, iElm, iAttrs){
            
            $scope.isPush = true;
            
            var message = 'Pumpkin - 넝굴째 굴러온 이벤트\n수많은 이벤트를 일일이 찾아보기 힘들었다구요?\n흩어져있는 다양한 이벤트를 여러분께 넝쿨째 굴려 드립니다.\n',
                image = '',
                storeUrl = 'http://www.pumpkinfactory.net/';
            
            $scope.sendGoogleAnalytics = function(state){
                if(window.cordova){
                    $cordovaGoogleAnalytics.trackEvent('SIDE MENU', state);
                };
            };
            
            $scope.openShareSheet = function() {
                if(window.cordova){
                    $cordovaGoogleAnalytics.trackEvent('SHARE APP', 'Open Sheet');
                    $cordovaSocialSharing.share(message, '', '', storeUrl).then(
                        function(res) {
                            
                        }, function(err) {
                            
                        }
                    );
                };
            };
            
            $scope.togglePush = function(){
                if(window.cordova){
                    pushSvc.hasPermission().then(
                        function(res){
                            if(res){
                                if($scope.isPush){
                                    $timeout(function(){
                                        $scope.isPush = false;
                                        pushSvc.unregister();
                                    });
                                }else{
                                    $timeout(function(){
                                        $scope.isPush = true;
                                        pushSvc.register();
                                    });
                                }
                            }else{
                                $scope.isPush = false;
                                dialogSvc.alert('설정에서 알림을 허용해주세요!');
                            }
                        },
                        function(err){
                            
                        }
                    )
                };
            };
            
            $scope.$on('setNotification', function(e, params){
                if(window.cordova){
                    pushSvc.hasPermission().then(
                        function(res){
                            if(res){
                                $timeout(function(){
                                    $scope.isPush = JSON.parse(params.isPush);
                                });
                            }else{
                                $timeout(function(){
                                    $scope.isPush = false;
                                });
                            };

                        },
                        function(err){

                        }
                    );
                };
            })
            
        }
    };
}]);



