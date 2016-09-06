
angular.module('giftbox.directives')

.directive('mainPopup', ['$rootScope', '$timeout', '$state', '$cordovaGoogleAnalytics', 'storageSvc', 'browserSvc', 'dialogSvc', 'imgLoadSvc', 'restApiSvc', function($rootScope, $timeout, $state, $cordovaGoogleAnalytics, storageSvc, browserSvc, dialogSvc, imgLoadSvc, restApiSvc){
    return {
        restrict: 'A',
        templateUrl: 'templates/dialog/main-popup.html',
        scope: true,
        replace: true,
        link: function($scope, iElm, iAttrs){
            
            $scope.thumbnailUrl = 'img/img_thumanail_default.png';
            $scope.mainPopup = null;
            $scope.sitelinkUrl = '';
            $scope.isDontShow = false;
            
            $scope.toggleDontShow = function(){
                $scope.isDontShow = !$scope.isDontShow;
            };
            
            $scope.goDetail = function(detailId, popupPage){
                var currentState = $state.current.name;
                var params = {
                        detailId: detailId
                    };
                
                dialogSvc.popupClose();
                if(detailId != null){
                    $state.go(currentState+'-detail', params);
                }else{
                    browserSvc.open(popupPage);
                }
                
                if(window.cordova){
                    $cordovaGoogleAnalytics.trackEvent('HOME POPUP', 'Event Detail');
                };
            };
            
            $scope.getMainPopup = function(){
//                restApiSvc.get(restApiSvc.apiPath.getMainPopup, {page:1, size:1, premium:false}).then(
//                    function(res){
//                        if(res.data.data.content.length > 0){
                            $scope.mainPopup = $rootScope.mainPopupData;

                            var loadTimeout = $timeout(function(){
                                $scope.thumbnailUrl = $scope.mainPopup.attachments[0].thumbnailS;
                            }, 10000);

                            imgLoadSvc.load($scope.mainPopup.attachments[0].thumbnailS, function(src){
                                $timeout.cancel(loadTimeout);
                                loadTimeout = null;

                                $timeout(function(){
                                    $scope.thumbnailUrl = src;
                                });
                            });
//                        }else{
//                            
//                        }
//                    },
//                    function(err, status){
//                        
//                    }
//                );
            };
            
            $scope.popupClose = function(){
                dialogSvc.popupClose();
                
                if($scope.isDontShow){
                    storageSvc.insert('homePopupClosed', 'id', $scope.mainPopup.eventId);
                    if(window.cordova){
                        var action = 'Don`t Show Popup-' + $scope.mainPopup.eventId;
                        $cordovaGoogleAnalytics.trackEvent('HOME POPUP', action);
                    }
                }else{
                    if(window.cordova){
                        $cordovaGoogleAnalytics.trackEvent('HOME POPUP', 'Close Popup');
                    }
                };
            };
            
            $timeout(function(){
                $scope.getMainPopup();
            }, 250);
            
        }
    };
}]);



